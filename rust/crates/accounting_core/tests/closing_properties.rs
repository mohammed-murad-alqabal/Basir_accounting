//! Property-Based Tests for Fiscal Year Closing
//!
//! Verifies:
//! - Σ(P&L) == Transfer to Retained Earnings.
//! - P&L accounts are exactly zero after closing.

use accounting_core::accounts::models::{Account, AccountKind};
use accounting_core::ledger::closing::ClosingEntryGenerator;
use accounting_core::ledger::models::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
    TemporalJustification,
};
use accounting_core::reporting::trial_balance::generate_trial_balance;
use chrono::{Datelike, Utc};
use proptest::prelude::*;
use rust_decimal::Decimal;
use uuid::Uuid;

fn decimal_strategy() -> impl Strategy<Value = Decimal> {
    any::<u32>().prop_map(|v| Decimal::new(v as i64, 2))
}

fn non_zero_decimal_strategy() -> impl Strategy<Value = Decimal> {
    (1..10000u32).prop_map(|v| Decimal::new(v as i64, 2))
}

proptest! {
    /// Property: Closing entry correctly zeros P&L and transfers to RE.
    #[test]
    fn prop_closing_integrity(
        revenue_amount in decimal_strategy(),
        expense_amount in decimal_strategy()
    ) {
        let acc_cash = Account::new("1000", "Cash", "Cash", AccountKind::Asset);
        let acc_revenue = Account::new("4000", "Revenue", "Revenue", AccountKind::Income);
        let acc_expense = Account::new("5000", "Expense", "Expense", AccountKind::Expense);
        let acc_re = Account::new("3000", "RE", "Retained Earnings", AccountKind::Equity);

        let accounts = vec![acc_cash.clone(), acc_revenue.clone(), acc_expense.clone(), acc_re.clone()];
        let today = Utc::now().date_naive();

        // 1. Transaction: Cash Dr, Revenue Cr (Revenue)
        let entry1 = JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "JE-1".to_string(),
            description: "Rev".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification::simple("IFRS"),
            lines: vec![
                JournalEntryLine::debit(acc_cash.id, revenue_amount, "Db"),
                JournalEntryLine::credit(acc_revenue.id, revenue_amount, "Cr"),
            ],
            created_by: Uuid::nil(),
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        };

        // 2. Transaction: Expense Dr, Cash Cr (Expense)
        let entry2 = JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "JE-2".to_string(),
            description: "Exp".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification::simple("IFRS"),
            lines: vec![
                JournalEntryLine::debit(acc_expense.id, expense_amount, "Db"),
                JournalEntryLine::credit(acc_cash.id, expense_amount, "Cr"),
            ],
            created_by: Uuid::nil(),
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        };

        let entries = vec![entry1, entry2];

        // 3. Generate Closing Entry
        let closing_entry = ClosingEntryGenerator::generate_year_end_entry(
            "2025",
            today,
            &entries,
            &accounts,
            acc_re.id
        );

        // Verify closing entry lines
        // Should have Revenue Dr (positive net was Cr, so reverse with Dr)
        // Should have Expense Cr (positive net was Dr, so reverse with Cr)
        // Should have RE line

        let mut total_rev_reversal = Decimal::ZERO;
        let mut total_exp_reversal = Decimal::ZERO;
        let mut total_re_transfer = Decimal::ZERO;

        for line in &closing_entry.lines {
            if line.account_id == acc_revenue.id {
                total_rev_reversal += line.debit_amount - line.credit_amount;
            } else if line.account_id == acc_expense.id {
                total_exp_reversal += line.credit_amount - line.debit_amount;
            } else if line.account_id == acc_re.id {
                total_re_transfer += line.credit_amount - line.debit_amount;
            }
        }

        prop_assert_eq!(total_rev_reversal, revenue_amount);
        prop_assert_eq!(total_exp_reversal, expense_amount);
        prop_assert_eq!(total_re_transfer, revenue_amount - expense_amount); // Profit = Rev - Exp

        // 4. Verify TB after closing
        let mut all_entries = entries.clone();
        let mut posted_closing = closing_entry.clone();
        posted_closing.status = EntryStatus::Posted;
        all_entries.push(posted_closing);

        let tb_after = generate_trial_balance(&all_entries, &accounts, today, None);

        for line in tb_after.lines {
            let acc = accounts.iter().find(|a| a.id == line.account_id).unwrap();
            if acc.kind == AccountKind::Income || acc.kind == AccountKind::Expense {
                prop_assert_eq!(line.debit_balance, Decimal::ZERO);
                prop_assert_eq!(line.credit_balance, Decimal::ZERO);
            } else if acc.id == acc_re.id {
                prop_assert_eq!(line.credit_balance, (revenue_amount - expense_amount).max(Decimal::ZERO));
                prop_assert_eq!(line.debit_balance, (expense_amount - revenue_amount).max(Decimal::ZERO));
            }
        }
    }

    /// Property: Opening balance entry correctly carries forward Balance Sheet accounts.
    #[test]
    fn prop_opening_balance_integrity(
        asset_amount in non_zero_decimal_strategy(),
        liab_amount in non_zero_decimal_strategy()
    ) {
        let acc_cash = Account::new("1000", "Cash", "Cash", AccountKind::Asset);
        let acc_ap = Account::new("2000", "AP", "AP", AccountKind::Liability);
        let acc_equity = Account::new("3000", "Equity", "Equity", AccountKind::Equity);
        let accounts = vec![acc_cash.clone(), acc_ap.clone(), acc_equity.clone()];

        let today = Utc::now().date_naive();
        let next_year = today.with_year(today.year() + 1).unwrap();

        // 1. Setup initial state via a posted entry
        let entry = JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "INIT".to_string(),
            description: "Init".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification::simple("IFRS"),
            lines: vec![
                JournalEntryLine::debit(acc_cash.id, asset_amount, "Db"),
                JournalEntryLine::credit(acc_ap.id, liab_amount, "Cr"),
                JournalEntryLine::credit(acc_equity.id, asset_amount - liab_amount, "Cr"),
            ],
            created_by: Uuid::nil(),
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        };

        let entries = vec![entry];

        // 2. Generate Opening Entry for next year
        let opening_entry = ClosingEntryGenerator::generate_opening_entry(
            "2026",
            next_year,
            &entries,
            &accounts
        );

        // 3. Verify opening entry lines match previous balances
        let mut found_cash = false;
        let mut found_ap = false;
        let mut found_equity = false;

        for line in &opening_entry.lines {
            if line.account_id == acc_cash.id {
                prop_assert_eq!(line.debit_amount, asset_amount);
                found_cash = true;
            } else if line.account_id == acc_ap.id {
                prop_assert_eq!(line.credit_amount, liab_amount);
                found_ap = true;
            } else if line.account_id == acc_equity.id {
                let diff = asset_amount - liab_amount;
                if diff > Decimal::ZERO {
                    prop_assert_eq!(line.credit_amount, diff);
                    prop_assert_eq!(line.debit_amount, Decimal::ZERO);
                } else {
                    prop_assert_eq!(line.debit_amount, diff.abs());
                    prop_assert_eq!(line.credit_amount, Decimal::ZERO);
                }
                found_equity = true;
            }
        }

        prop_assert!(found_cash);
        prop_assert!(found_ap);
        if asset_amount != liab_amount {
            prop_assert!(found_equity);
        }

        let expected_lines = 2 + if asset_amount != liab_amount { 1 } else { 0 };
        prop_assert_eq!(opening_entry.lines.len(), expected_lines);
    }
}
