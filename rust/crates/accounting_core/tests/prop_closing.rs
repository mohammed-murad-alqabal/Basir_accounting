use accounting_core::{
    accounts::defaults::default_chart_of_accounts,
    accounts::models::AccountKind,
    ledger::closing::ClosingEntryGenerator,
    ledger::models::{
        EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
        TemporalJustification,
    },
    reporting::generate_trial_balance,
};
use chrono::{NaiveDate, Utc};
use proptest::prelude::*;
use rust_decimal::Decimal;
use uuid::Uuid;

// Strategy to generate a random Decimal between 0 and 1000
fn prop_decimal() -> impl Strategy<Value = Decimal> {
    any::<u32>().prop_map(|n| Decimal::from(n % 10001)) // Increased range for better testing
}

proptest! {
    #![proptest_config(ProptestConfig::with_cases(500))]

    #[test]
    fn prop_period_closing_integrity(
        revenue_amount in prop_decimal(),
        expense_amount in prop_decimal(),
    ) {
        let accounts = default_chart_of_accounts();
        let closing_date = NaiveDate::from_ymd_opt(2025, 12, 31).unwrap();

        let revenue_id = accounts.iter().find(|a| a.code == "4100").unwrap().id;
        let expense_id = accounts.iter().find(|a| a.code == "5100").unwrap().id;
        let cash_id = accounts.iter().find(|a| a.code == "1110").unwrap().id;
        let retained_earnings_id = accounts.iter().find(|a| a.code == "3200").unwrap().id;

        // 1. Create initial transaction (Revenue)
        // Dr Cash, Cr Revenue
        let rev_entry = JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "REV-001".to_string(),
            description: "Opening Revenue".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(closing_date, closing_date),
            standards: StandardsJustification::simple("IFRS 15"),
            lines: vec![
                JournalEntryLine::debit(cash_id, revenue_amount, "Sale"),
                JournalEntryLine::credit(revenue_id, revenue_amount, "Sale"),
            ],
            created_by: Uuid::nil(),
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: "mock".to_string(),
            previous_hash: "mock".to_string(),
        };

        // 2. Create second transaction (Expense)
        // Dr Expense, Cr Cash
        let exp_entry = JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "EXP-001".to_string(),
            description: "Opening Expense".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(closing_date, closing_date),
            standards: StandardsJustification::simple("IAS 1"),
            lines: vec![
                JournalEntryLine::debit(expense_id, expense_amount, "Payment"),
                JournalEntryLine::credit(cash_id, expense_amount, "Payment"),
            ],
            created_by: Uuid::nil(),
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: "mock".to_string(),
            previous_hash: "mock".to_string(),
        };

        let mut entries = vec![rev_entry, exp_entry];

        // 3. Generate Closing Entry
        let closing_entry = ClosingEntryGenerator::generate_year_end_entry(
            "Year-End Closing",
            closing_date,
            &entries,
            &accounts,
            retained_earnings_id,
        );

        // Mock posting the closing entry
        let mut posted_closing = closing_entry.clone();
        posted_closing.status = EntryStatus::Posted;
        entries.push(posted_closing);

        // 4. Verify Final Trial Balance
        let tb = generate_trial_balance(&entries, &accounts, closing_date, None);

        // TB must be balanced
        assert!(tb.total_debits == tb.total_credits, "Post-closing TB must be balanced. Debits: {}, Credits: {}", tb.total_debits, tb.total_credits);

        // Income and Expense accounts must be ZERO
        for tb_line in &tb.lines {
            let acc = accounts.iter().find(|a| a.code == tb_line.account_code).unwrap();
            if acc.kind == AccountKind::Income || acc.kind == AccountKind::Expense {
                assert_eq!(tb_line.debit_balance, Decimal::ZERO, "Income/Expense must be cleared: {}", acc.code);
                assert_eq!(tb_line.credit_balance, Decimal::ZERO, "Income/Expense must be cleared: {}", acc.code);
            }
        }

        // The net Profit/Loss should now be in Retained Earnings
        let profit_or_loss = revenue_amount - expense_amount;
        let re_balance = tb.lines.iter()
            .find(|l| l.account_code == "3200")
            .map(|l| l.credit_balance - l.debit_balance)
            .unwrap_or(Decimal::ZERO);

        assert_eq!(re_balance, profit_or_loss, "Retained Earnings must hold the net profit/loss. Expected: {}, Got: {}", profit_or_loss, re_balance);
    }
}
