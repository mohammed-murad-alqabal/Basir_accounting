use accounting_core::ledger::{
    models::{
        EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
        TemporalJustification,
    },
    validation::validate_currency,
};
use chrono::{NaiveDate, Utc};
use proptest::prelude::*;
use rust_decimal::Decimal;
use uuid::Uuid;

// Generates a Decimal for amounts
prop_compose! {
    fn arb_amount()(num in 100..1000000i64) -> Decimal {
        Decimal::new(num, 2)
    }
}

// Generates a positive exchange rate
prop_compose! {
    fn arb_rate()(num in 1..100000i64) -> Decimal {
        Decimal::new(num, 4)
    }
}

fn create_base_entry() -> JournalEntry {
    let today = NaiveDate::from_ymd_opt(2026, 1, 3).unwrap();
    JournalEntry {
        entry_id: Uuid::new_v4(),
        entry_number: "PROP-CURR".to_string(),
        description: "Currency Prop Test".to_string(),
        entry_type: EntryType::Standard,
        status: EntryStatus::Draft,
        linked_entry_id: None,
        adjustment_reason: None,
        temporal: TemporalJustification::new(today, today),
        standards: StandardsJustification::simple("IAS 21.21"),
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

proptest! {
    #[test]
    fn prop_cp_005_currency_arithmetic_valid(
        orig_amount in arb_amount(),
        rate in arb_rate(),
    ) {
        let functional_amount = orig_amount * rate;
        let mut entry = create_base_entry();

        // Add a multi-currency line
        entry.lines.push(JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: 1,
            account_id: Uuid::new_v4(),
            debit_amount: functional_amount,
            credit_amount: Decimal::ZERO,
            description: "Foreign Sales".to_string(),
            source_document_ref: Some("INV-001".to_string()),
            original_currency: Some("USD".to_string()),
            exchange_rate: Some(rate),
            original_amount: Some(orig_amount),
            partner_id: None,
        });

        // Add a balancing line (functional currency)
        entry.lines.push(JournalEntryLine::credit(Uuid::new_v4(), functional_amount, "Cash"));

        let result = validate_currency(&entry);
        prop_assert!(result.is_ok(), "Validation failed for valid arithmetic: {:?}", result.err());
    }

    #[test]
    fn prop_cp_005_currency_arithmetic_invalid(
        orig_amount in arb_amount(),
        rate in arb_rate(),
        mismatch in arb_amount(),
    ) {
        prop_assume!(mismatch != Decimal::ZERO);
        let functional_amount = orig_amount * rate;
        let incorrect_functional = functional_amount + mismatch;

        let mut entry = create_base_entry();
        entry.lines.push(JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: 1,
            account_id: Uuid::new_v4(),
            debit_amount: incorrect_functional,
            credit_amount: Decimal::ZERO,
            description: "Mismatched Foreign Sales".to_string(),
            source_document_ref: Some("INV-001".to_string()),
            original_currency: Some("USD".to_string()),
            exchange_rate: Some(rate),
            original_amount: Some(orig_amount),
            partner_id: None,
        });

        let result = validate_currency(&entry);
        prop_assert!(result.is_err(), "Validation should have failed for mismatch: {}", mismatch);
    }

    #[test]
    fn prop_cp_005_currency_zero_rate_rejected(
        orig_amount in arb_amount(),
    ) {
        let mut entry = create_base_entry();
        entry.lines.push(JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: 1,
            account_id: Uuid::new_v4(),
            debit_amount: Decimal::ZERO,
            credit_amount: Decimal::ZERO,
            description: "Zero Rate Sales".to_string(),
            source_document_ref: Some("INV-001".to_string()),
            original_currency: Some("USD".to_string()),
            exchange_rate: Some(Decimal::ZERO),
            original_amount: Some(orig_amount),
            partner_id: None,
        });

        let result = validate_currency(&entry);
        prop_assert!(result.is_err());
    }
}
