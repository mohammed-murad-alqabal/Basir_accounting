use accounting_core::ledger::{
    models::{
        EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
        TemporalJustification,
    },
    validation::{validate_balance, EntryValidationError},
};
use chrono::{NaiveDate, Utc};
use proptest::prelude::*;
use rust_decimal::Decimal;
use uuid::Uuid;

// Generates a Decimal between 1 and 1,000,000 with 2 decimal places
prop_compose! {
    fn arb_decimal()(num in 100..100000000i64) -> Decimal {
        Decimal::new(num, 2)
    }
}

// Generates a standard reference string
prop_compose! {
    fn arb_standard_ref()(
        std in prop::sample::select(&["IFRS", "IAS"]),
        num in 1..41u32,
        para in 1..100u32
    ) -> String {
        format!("{} {}.{}", std, num, para)
    }
}

fn create_balanced_entry(amounts: Vec<Decimal>, std_ref: String) -> JournalEntry {
    let mut lines = Vec::new();
    let today = NaiveDate::from_ymd_opt(2026, 1, 3).unwrap();

    // Create pairs of debit/credit to ensure balance
    for amount in amounts {
        lines.push(JournalEntryLine::debit(Uuid::new_v4(), amount, "Debit"));
        lines.push(JournalEntryLine::credit(Uuid::new_v4(), amount, "Credit"));
    }

    JournalEntry {
        entry_id: Uuid::new_v4(),
        entry_number: "TEST-JE".to_string(),
        description: "Prop Test Balanced".to_string(),
        entry_type: EntryType::Standard,
        status: EntryStatus::Draft,
        linked_entry_id: None,
        adjustment_reason: None,
        temporal: TemporalJustification::new(today, today),
        standards: StandardsJustification::simple(&std_ref),
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

proptest! {
    // CP-001: Double-Entry Balance Enforcement
    // "For every journal entry, the sum of debits equals the sum of credits"
    #[test]
    fn prop_cp_001_balanced_entries_are_valid(
        amounts in prop::collection::vec(arb_decimal(), 1..10),
        std_ref in arb_standard_ref()
    ) {
        let entry = create_balanced_entry(amounts, std_ref);

        // Invariant: sum(debits) == sum(credits)
        prop_assert_eq!(entry.total_debits(), entry.total_credits());

        // Validation check
        prop_assert!(validate_balance(&entry).is_ok());
    }

    #[test]
    fn prop_cp_001_unbalanced_entries_are_rejected(
        d_amount in arb_decimal(),
        c_amount in arb_decimal(),
        std_ref in arb_standard_ref()
    ) {
        // Assume unequal
        prop_assume!(d_amount != c_amount);

        let today = NaiveDate::from_ymd_opt(2026, 1, 3).unwrap();
        let entry = JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "TEST-JE".to_string(),
            description: "Prop Test Unbalanced".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Draft,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification::simple(&std_ref),
            lines: vec![
                JournalEntryLine::debit(Uuid::new_v4(), d_amount, "Debit"),
                JournalEntryLine::credit(Uuid::new_v4(), c_amount, "Credit"),
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

        // Invariant: Validation must fail
        let result = validate_balance(&entry);
        // We use is_err() to avoid format string issues with matches! macro in prop_assert!
        prop_assert!(result.is_err());

        // Optional: Manual check if needed, but is_err is sufficient for this property
        if let Err(e) = result {
             assert!(matches!(e, EntryValidationError::NotBalanced { .. }));
        }
    }
}
