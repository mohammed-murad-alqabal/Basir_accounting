use accounting_core::{
    accounts::models::{Account, AccountKind, Ifrs18Category},
    accounts::registry::AccountRegistry,
    audit::{
        chain::GENESIS_HASH,
        models::{AuditAction, AuditMetadata, AuditRecord, HowInfo, WhereInfo, WhoInfo, WhyInfo},
        service::AuditService,
    },
    ledger::{
        models::{
            EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
            TemporalJustification,
        },
        validation::validate_for_posting,
    },
    reporting::generate_trial_balance,
    standards::registry::StandardsRegistry,
    MeasurementBasis, RecognitionBasis,
};
use chrono::{NaiveDate, Utc};
use rust_decimal::Decimal;
use uuid::Uuid;

/// Helper to create dummy audit metadata
fn mock_audit_context(user_id: Uuid) -> AuditMetadata {
    AuditMetadata {
        who: WhoInfo {
            user_id,
            user_name: "test_accountant".to_string(),
            role: "Accountant".to_string(),
            session_id: Uuid::new_v4(),
        },
        r#where: WhereInfo {
            system_id: "core-engine-test".to_string(),
            ip_address: Some("127.0.0.1".to_string()),
            location: None,
            device_id: None,
            app_version: None,
        },
        why: WhyInfo {
            reason_code: None,
            justification: None,
            authorization_reference: None,
        },
        how: HowInfo {
            method: "E2E_TEST".to_string(),
            procedure_reference: None,
            api_endpoint: None,
        },
    }
}

#[test]
fn test_e2e_accounting_workflow() {
    // 1. Setup: Initialize Standards Registry
    let registry = StandardsRegistry::load_defaults();
    let as_of_date = NaiveDate::from_ymd_opt(2026, 1, 3).unwrap();

    // Verify IFRS 15 exists (Requirement 2.3)
    assert!(registry.contains("IFRS 15.31"));

    // 2. Setup: Initialize Audit Service
    let mut audit_service = AuditService::new(None);
    let mut audit_log: Vec<AuditRecord> = Vec::new();

    // 3. Setup: Define Chart of Accounts
    let cash_account_id = Uuid::new_v4();
    let revenue_account_id = Uuid::new_v4();

    let accounts = vec![
        Account {
            id: cash_account_id,
            code: "1001".to_string(),
            name_ar: "النقدية".to_string(),
            name_en: "Cash".to_string(),
            kind: AccountKind::Asset,
            classification: None,
            parent_id: None,
            ifrs_tag: Some("ifrs-full:Cash".to_string()),
            currency: Some("USD".to_string()),
            ifrs18_category: Ifrs18Category::Operating,
            description: None,
            requires_partner: false,
            is_active: true,
        },
        Account {
            id: revenue_account_id,
            code: "4001".to_string(),
            name_ar: "الإيرادات".to_string(),
            name_en: "Revenue".to_string(),
            kind: AccountKind::Income,
            classification: None,
            parent_id: None,
            ifrs_tag: Some("ifrs-full:Revenue".to_string()),
            currency: Some("USD".to_string()),
            ifrs18_category: Ifrs18Category::Operating,
            description: None,
            requires_partner: false,
            is_active: true,
        },
    ];

    // 4. Workflow: Create Journal Entry (Revenue Recognition)
    let user_id = Uuid::new_v4();
    let entry_amount = Decimal::from(1000);

    let mut entry = JournalEntry {
        entry_id: Uuid::new_v4(),
        entry_number: "JE-2026-001".to_string(),
        description: "Revenue Recognition".to_string(),
        entry_type: EntryType::Standard,
        status: EntryStatus::Draft,
        linked_entry_id: None,
        adjustment_reason: None,
        temporal: TemporalJustification::new(as_of_date, as_of_date),
        standards: StandardsJustification {
            standard_reference: "IFRS 15.31".to_string(), // Valid ref
            recognition_basis: Some(RecognitionBasis::Accrual),
            measurement_basis: Some(MeasurementBasis::HistoricalCost),
            professional_judgment: None,
        },
        lines: vec![
            JournalEntryLine {
                source_document_ref: Some("INV-2026-001".to_string()),
                ..JournalEntryLine::debit(cash_account_id, entry_amount, "Cash from Sales")
            },
            JournalEntryLine {
                source_document_ref: Some("INV-2026-001".to_string()),
                ..JournalEntryLine::credit(revenue_account_id, entry_amount, "Sales Revenue")
            },
        ],
        created_by: user_id,
        created_at: Utc::now(),
        approved_by: None,
        approved_at: None,
        posted_by: None,
        posted_at: None,
        hash: String::new(),
        previous_hash: String::new(),
    };

    println!("Step 1: Entry Created: {:?}", entry.entry_number);

    // 5. Workflow: Validate Entry (Requirement 2.1, 2.3)
    let account_registry = AccountRegistry::new(accounts.clone());
    let validation_result = validate_for_posting(&entry, &registry, &account_registry);
    assert!(
        validation_result.is_ok(),
        "Entry validation failed: {:?}",
        validation_result.err()
    );

    // 6. Workflow: Post Entry
    // (Simulating posting logic here as we don't have the Service layer in core)
    entry.status = EntryStatus::Posted;
    entry.posted_by = Some(user_id);
    entry.posted_at = Some(Utc::now());

    // Record Audit Trail (Requirement 5.2)
    let audit_record = audit_service.record_change(
        mock_audit_context(user_id),
        AuditAction::Post,
        "JournalEntry",
        entry.entry_id,
        "Posted revenue entry",
        Some("Draft".to_string()),
        Some("Posted".to_string()),
    );
    audit_log.push(audit_record);

    println!("Step 2: Entry Posted and Audited");

    // 7. Workflow: Verify Audit Chain (Requirement 5.1)
    let chain_verify = AuditService::verify_integrity(&audit_log);
    assert!(chain_verify.is_ok(), "Audit chain integrity failed");
    assert_eq!(audit_log.last().unwrap().previous_hash, GENESIS_HASH); // Only one record

    // 8. Workflow: Generate Trial Balance (Requirement 8.5)
    // We pass the posted entries directly to the generator

    let entries_for_tb = vec![entry.clone()];

    let trial_balance = generate_trial_balance(&entries_for_tb, &accounts, as_of_date, None);

    assert!(trial_balance.is_balanced);
    assert_eq!(trial_balance.total_debits, entry_amount);
    assert_eq!(trial_balance.total_credits, entry_amount);

    println!("Step 3: Trial Balance Generated and Balanced");

    // 9. Workflow: Reversal (Requirement 2.5)
    let reversal_entry = entry
        .create_reversal("Correcting error", user_id)
        .expect("Failed to create reversal");

    assert_eq!(reversal_entry.entry_type, EntryType::Reversing);
    assert_eq!(reversal_entry.lines[0].credit_amount, entry_amount); // Swapped
    assert_eq!(reversal_entry.lines[1].debit_amount, entry_amount); // Swapped

    // Validate Reversal
    assert!(validate_for_posting(&reversal_entry, &registry, &account_registry).is_ok());

    // Post Reversal
    let mut posted_reversal = reversal_entry.clone();
    posted_reversal.status = EntryStatus::Posted;

    // Audit Reversal
    let audit_reversal = audit_service.record_change(
        mock_audit_context(user_id),
        AuditAction::Reverse,
        "JournalEntry",
        entry.entry_id,
        "Reversed entry",
        Some("Posted".to_string()),
        Some("Reversed".to_string()),
    );
    audit_log.push(audit_reversal);

    println!("Step 4: Reversal Created and Posted");

    // 10. Verification: Audit Chain Integrity
    let chain_verify_2 = AuditService::verify_integrity(&audit_log);
    assert!(chain_verify_2.is_ok());
    assert_eq!(audit_log.len(), 2);
    // Ensure chaining holds
    assert_eq!(audit_log[1].previous_hash, audit_log[0].hash);

    println!("Step 5: Audit Chain Updated and Verified");

    println!("E2E Verification Complete: SUCCESS");
}
