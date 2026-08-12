use accounting_core::ledger::{
    models::{
        EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
        TemporalJustification,
    },
    validation::validate_traceability,
};
use chrono::{NaiveDate, Utc};
use proptest::prelude::*;
use rust_decimal::Decimal;
use uuid::Uuid;

// Generates an arbitrary EntryType
fn arb_entry_type() -> impl Strategy<Value = EntryType> {
    prop_oneof![
        Just(EntryType::Standard),
        Just(EntryType::Adjusting),
        Just(EntryType::Reversing),
        Just(EntryType::Closing),
    ]
}

// Generates a random string that might be empty or whitespace
fn arb_maybe_empty_string() -> impl Strategy<Value = String> {
    prop_oneof![
        Just("".to_string()),
        Just("   ".to_string()),
        any::<String>(),
    ]
}

prop_compose! {
    fn arb_journal_entry_line(_is_standard: bool)(
        source_doc in prop_oneof![Just(None), Just(Some("DOC-123".to_string())), arb_maybe_empty_string().prop_map(Some)]
    ) -> JournalEntryLine {
        JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: 0,
            account_id: Uuid::new_v4(),
            debit_amount: Decimal::new(100, 0),
            credit_amount: Decimal::ZERO,
            description: "Test Line".to_string(),
            source_document_ref: source_doc,
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
            partner_id: None,
        }
    }
}

prop_compose! {
    fn arb_journal_entry()(
        entry_type in arb_entry_type(),
        std_ref in arb_maybe_empty_string(),
        linked_id in prop_oneof![Just(None), Just(Some(Uuid::new_v4()))],
        lines in prop::collection::vec(any::<bool>().prop_flat_map(arb_journal_entry_line), 1..5)
    ) -> JournalEntry {
        JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "PROP-JE".to_string(),
            description: "Traceability Prop Test".to_string(),
            entry_type,
            status: EntryStatus::Draft,
            linked_entry_id: linked_id,
            adjustment_reason: None,
            temporal: TemporalJustification::new(
                NaiveDate::from_ymd_opt(2026, 1, 1).unwrap(),
                NaiveDate::from_ymd_opt(2026, 1, 1).unwrap()
            ),
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
}

proptest! {
    #[test]
    fn prop_cp_009_traceability_completeness(entry in arb_journal_entry()) {
        let result = validate_traceability(&entry);

        // Logical implications of CP-009:

        // 1. If it's valid, it MUST have a non-empty standards ref
        if result.is_ok() {
            prop_assert!(!entry.standards.standard_reference.trim().is_empty());
        }

        // 2. If it's valid and Standard type, ALL lines must have non-empty source_doc_ref
        if result.is_ok() && entry.entry_type == EntryType::Standard {
            for line in &entry.lines {
                prop_assert!(line.source_document_ref.as_ref().is_some_and(|s| !s.trim().is_empty()));
            }
        }

        // 3. If it's valid and (Adjusting or Reversing), it MUST have a linked_entry_id
        if result.is_ok() && (entry.entry_type == EntryType::Adjusting || entry.entry_type == EntryType::Reversing) {
            prop_assert!(entry.linked_entry_id.is_some());
        }

        // Error cases verification
        if entry.standards.standard_reference.trim().is_empty() {
            prop_assert!(result.is_err());
        }

        if entry.entry_type == EntryType::Standard
            && entry
                .lines
                .iter()
                .any(|l| l.source_document_ref.as_ref().is_none_or(|s| s.trim().is_empty()))
        {
            prop_assert!(result.is_err());
        }

        if (entry.entry_type == EntryType::Adjusting || entry.entry_type == EntryType::Reversing) && entry.linked_entry_id.is_none() {
            prop_assert!(result.is_err());
        }
    }
}
