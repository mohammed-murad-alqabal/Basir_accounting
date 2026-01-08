use accounting_core::ledger::models::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
    TemporalJustification,
};
use accounting_core::ledger::validation::{validate_balance, validate_temporal};
use chrono::{NaiveDate, Utc};
use proptest::prelude::*;
use rust_decimal::Decimal;
use uuid::Uuid;

// Strategies for generating test data
fn decimal_strategy() -> impl Strategy<Value = Decimal> {
    any::<i64>().prop_map(|v| Decimal::new(v, 2).abs())
}

fn date_strategy() -> impl Strategy<Value = NaiveDate> {
    (2020..2030i32, 1..12u32, 1..28u32)
        .prop_map(|(y, m, d)| NaiveDate::from_ymd_opt(y, m, d).unwrap())
}

prop_compose! {
    fn balanced_lines_strategy()(amount in decimal_strategy()) -> Vec<JournalEntryLine> {
        let acc1 = Uuid::new_v4();
        let acc2 = Uuid::new_v4();
        vec![
            JournalEntryLine::debit(acc1, amount, "Debit line"),
            JournalEntryLine::credit(acc2, amount, "Credit line"),
        ]
    }
}

prop_compose! {
    fn journal_entry_strategy(balanced: bool)(
        lines in if balanced { balanced_lines_strategy().boxed() } else { prop::collection::vec(any::<u64>().prop_map(|_| JournalEntryLine::debit(Uuid::new_v4(), Decimal::new(100, 0), "")), 1..5).boxed() },
        transaction_date in date_strategy(),
        effective_date in date_strategy(),
    ) -> JournalEntry {
        JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "PROP-001".to_string(),
            description: "Property Test Entry".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Draft,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(transaction_date, effective_date),
            standards: StandardsJustification::simple("IFRS 15.35"),
            lines,
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
    /// Property 1: Double-Entry Balance Enforcement
    /// CP-001: Every balanced entry must pass validate_balance.
    #[test]
    fn prop_double_entry_balance_enforcement(entry in journal_entry_strategy(true)) {
        prop_assert!(entry.is_balanced());
        prop_assert!(validate_balance(&entry).is_ok());
    }

    /// Property 8: Temporal Justification Completeness
    /// CP-008: Valid temporal justification (effective <= recording) must pass validation.
    #[test]
    fn prop_temporal_justification_completeness(mut entry in journal_entry_strategy(true)) {
        // Force a valid temporal state
        let recording_date = Utc::now().date_naive();
        entry.temporal.effective_date = recording_date;
        prop_assert!(entry.temporal.is_valid(0));
        prop_assert!(validate_temporal(&entry).is_ok());

        // Test invalid state: effective > recording
        entry.temporal.effective_date = recording_date.succ_opt().unwrap();
        // Since recording_date is Utc::now(), the struct's recording_date is fixed at creation time.
        // But TemporalJustification::new sets it to Utc::now().

        // Let's manually set a future effective date relative to its recording_date
        let recording_dt = entry.temporal.recording_date;
        entry.temporal.effective_date = recording_dt.date_naive().succ_opt().unwrap();

        prop_assert!(!entry.temporal.is_valid(0));
        prop_assert!(validate_temporal(&entry).is_err());
    }
}
