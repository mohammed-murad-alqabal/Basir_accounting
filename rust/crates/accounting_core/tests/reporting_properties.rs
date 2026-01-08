//! Property-Based Tests for Reporting Integrity
//!
//! Verifies:
//! - Trial Balance total debits/credits match entry sums.
//! - Drill-down links correctly identify contributing entries.

use accounting_core::accounts::models::{Account, AccountKind};
use accounting_core::ledger::models::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
    TemporalJustification,
};
use accounting_core::reporting::trial_balance::generate_trial_balance;
use chrono::Utc;
use proptest::prelude::*;
use rust_decimal::Decimal;
use uuid::Uuid;

fn decimal_strategy() -> impl Strategy<Value = Decimal> {
    any::<u32>().prop_map(|v| Decimal::new(v as i64, 2))
}

prop_compose! {
    fn account_strategy(kind: AccountKind)(code in "[0-9]{4}") -> Account {
        Account::new(&code, "اسم", "Name", kind)
    }
}

prop_compose! {
    fn entry_strategy(accounts: Vec<Account>)(
        amount in decimal_strategy()
    ) -> JournalEntry {
        let today = Utc::now().date_naive();
        let acc1 = accounts[0].id;
        let acc2 = accounts[1].id;

        JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "JE-TEST".to_string(),
            description: "Test".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification::simple("IFRS"),
            lines: vec![
                JournalEntryLine::debit(acc1, amount, "Db"),
                JournalEntryLine::credit(acc2, amount, "Cr"),
            ],
            created_by: Uuid::new_v4(),
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        }
    }
}

proptest! {
    /// Property: Trial Balance Totals match Entry Totals.
    #[test]
    fn prop_trial_balance_integral(
        amount1 in decimal_strategy(),
        amount2 in decimal_strategy()
    ) {
        let acc_asset = Account::new("1000", "Asset", "Asset", AccountKind::Asset);
        let acc_income = Account::new("4000", "Income", "Income", AccountKind::Income);
        let accounts = vec![acc_asset, acc_income];

        let today = Utc::now().date_naive();

        let entry1 = JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "JE-1".to_string(),
            description: "E1".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification::simple("IFRS"),
            lines: vec![
                JournalEntryLine::debit(accounts[0].id, amount1, "Db"),
                JournalEntryLine::credit(accounts[1].id, amount1, "Cr"),
            ],
            created_by: Uuid::new_v4(),
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        };

        let mut entry2 = entry1.clone();
        entry2.entry_id = Uuid::new_v4();
        entry2.lines = vec![
            JournalEntryLine::debit(accounts[0].id, amount2, "Db"),
            JournalEntryLine::credit(accounts[1].id, amount2, "Cr"),
        ];

        let entries = vec![entry1, entry2];
        let tb = generate_trial_balance(&entries, &accounts, today, None);

        prop_assert!(tb.is_balanced);
        prop_assert_eq!(tb.total_debits, amount1 + amount2);
        prop_assert_eq!(tb.total_credits, amount1 + amount2);

        // Drill-down check
        for line in tb.lines {
            prop_assert_eq!(line.source_entries.len(), 2);
            prop_assert!(line.source_entries.contains(&entries[0].entry_id));
            prop_assert!(line.source_entries.contains(&entries[1].entry_id));
        }
    }
}
