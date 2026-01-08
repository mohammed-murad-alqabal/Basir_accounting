use accounting_core::ledger::{
    models::{
        EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
        TemporalJustification,
    },
    validation::{validate_partners, EntryValidationError},
};
use accounting_core::{Account, AccountKind, AccountRegistry};
use chrono::{NaiveDate, Utc};
use proptest::prelude::*;
use rust_decimal::Decimal;
use uuid::Uuid;

fn create_base_entry() -> JournalEntry {
    let today = NaiveDate::from_ymd_opt(2026, 1, 3).unwrap();
    JournalEntry {
        entry_id: Uuid::new_v4(),
        entry_number: "PROP-PARTNER".to_string(),
        description: "Partner Prop Test".to_string(),
        entry_type: EntryType::Standard,
        status: EntryStatus::Draft,
        linked_entry_id: None,
        adjustment_reason: None,
        temporal: TemporalJustification::new(today, today),
        standards: StandardsJustification::simple("IAS 1.54"),
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

fn create_account(requires_partner: bool) -> Account {
    let mut acc = Account::new(
        "TEST",
        "الحساب التجريبي",
        "Test Account",
        AccountKind::Asset,
    );
    acc.requires_partner = requires_partner;
    acc
}

proptest! {
    #[test]
    fn prop_cp_010_partner_required_enforced(
        requires_partner in any::<bool>(),
        has_partner in any::<bool>(),
    ) {
        let account = create_account(requires_partner);
        let registry = AccountRegistry::new(vec![account.clone()]);

        let mut entry = create_base_entry();
        let partner_id = if has_partner { Some(Uuid::new_v4()) } else { None };

        entry.lines.push(JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: 1,
            account_id: account.id,
            debit_amount: Decimal::new(100, 0),
            credit_amount: Decimal::ZERO,
            description: "Sub-ledger entry".to_string(),
            source_document_ref: Some("INV-001".to_string()),
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
            partner_id,
        });

        let result = validate_partners(&entry, &registry);

        if requires_partner && !has_partner {
            prop_assert!(matches!(result, Err(EntryValidationError::MissingPartner(_))));
        } else {
            prop_assert!(result.is_ok());
        }
    }

    #[test]
    fn prop_cp_010_mixed_lines_validation(
        partner_req_1 in any::<bool>(),
        partner_req_2 in any::<bool>(),
        has_partner_1 in any::<bool>(),
        has_partner_2 in any::<bool>(),
    ) {
        let acc1 = create_account(partner_req_1);
        let acc2 = create_account(partner_req_2);
        let registry = AccountRegistry::new(vec![acc1.clone(), acc2.clone()]);

        let mut entry = create_base_entry();

        entry.lines.push(JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: 1,
            account_id: acc1.id,
            debit_amount: Decimal::new(100, 0),
            credit_amount: Decimal::ZERO,
            description: "Line 1".to_string(),
            source_document_ref: Some("DOC-1".to_string()),
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
            partner_id: if has_partner_1 { Some(Uuid::new_v4()) } else { None },
        });

        entry.lines.push(JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: 2,
            account_id: acc2.id,
            debit_amount: Decimal::ZERO,
            credit_amount: Decimal::new(100, 0),
            description: "Line 2".to_string(),
            source_document_ref: Some("DOC-2".to_string()),
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
            partner_id: if has_partner_2 { Some(Uuid::new_v4()) } else { None },
        });

        let result = validate_partners(&entry, &registry);

        let should_fail = (partner_req_1 && !has_partner_1) || (partner_req_2 && !has_partner_2);

        if should_fail {
            prop_assert!(result.is_err());
        } else {
            prop_assert!(result.is_ok());
        }
    }
}
