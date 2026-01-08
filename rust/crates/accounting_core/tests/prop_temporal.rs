use accounting_core::ledger::{
    models::{EntryStatus, EntryType, JournalEntry, StandardsJustification, TemporalJustification},
    validation::validate_temporal,
};
use chrono::{DateTime, Duration, TimeZone, Utc};
use proptest::prelude::*;
use uuid::Uuid;

// Strategy to generate arbitrary Utc DateTime
fn arb_datetime() -> impl Strategy<Value = DateTime<Utc>> {
    // Range: 2020-01-01 to 2030-12-31
    (1577836800..1924905600i64).prop_map(|t| Utc.timestamp_opt(t, 0).unwrap())
}

prop_compose! {
    fn arb_temporal_justification()(
        recording_date in arb_datetime(),
        // Generate an effective date that is +/- 180 days from recording_date
        offset in -180..180i64
    ) -> TemporalJustification {
        let effective_date = recording_date.date_naive() + Duration::days(offset);
        TemporalJustification {
            transaction_date: effective_date, // Simplify transaction_date to match effective_date for this test
            effective_date,
            recording_date,
        }
    }
}

prop_compose! {
    fn arb_journal_entry_temporal()(
        temporal in arb_temporal_justification()
    ) -> JournalEntry {
        JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "PROP-TEMPORAL".to_string(),
            description: "Temporal Prop Test".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Draft,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal,
            standards: StandardsJustification::simple("IFRS 15.35"),
            lines: vec![],
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
    fn prop_cp_008_temporal_justification_enforcement(entry in arb_journal_entry_temporal()) {
        let result = validate_temporal(&entry);

        let effective = entry.temporal.effective_date;
        let recording = entry.temporal.recording_date.date_naive();

        if effective <= recording {
            prop_assert!(result.is_ok());
        } else {
            prop_assert!(result.is_err());
        }
    }
}
