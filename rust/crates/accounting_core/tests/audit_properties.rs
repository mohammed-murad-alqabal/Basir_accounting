//! Property-Based Tests for Audit Trail and Temporal Justification
//!
//! Verifies:
//! - Hash chain detection of tampering.
//! - Temporal justification invariants.

use accounting_core::audit::chain::{compute_record_hash, verify_chain, GENESIS_HASH};
use accounting_core::audit::models::{
    AuditAction, AuditRecord, HowInfo, WhatInfo, WhereInfo, WhoInfo, WhyInfo,
};
use accounting_core::ledger::models::TemporalJustification;
use chrono::{Duration, Utc};
use proptest::prelude::*;
use uuid::Uuid;

/// Strategy to generate an audit record.
fn audit_record_strategy(prev_hash: String) -> impl Strategy<Value = AuditRecord> {
    (
        any::<[u8; 16]>(), // record_id
        any::<[u8; 16]>(), // user_id
        any::<[u8; 16]>(), // entity_id
        ".*",              // change_description
    )
        .prop_map(move |(rid, uid, eid, desc)| {
            let mut record = AuditRecord {
                record_id: Uuid::from_bytes(rid),
                who: WhoInfo {
                    user_id: Uuid::from_bytes(uid),
                    user_name: "test".to_string(),
                    role: "admin".to_string(),
                    session_id: Uuid::new_v4(),
                },
                what: WhatInfo {
                    action: AuditAction::Update,
                    entity_type: "Account".to_string(),
                    entity_id: Uuid::from_bytes(eid),
                    change_description: desc,
                    old_value: None,
                    new_value: None,
                },
                when: Utc::now(),
                r#where: WhereInfo {
                    system_id: "test".to_string(),
                    ip_address: None,
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
                    method: "TEST".to_string(),
                    procedure_reference: None,
                    api_endpoint: None,
                },
                hash: String::new(),
                previous_hash: prev_hash.clone(),
            };
            record.hash = compute_record_hash(&record);
            record
        })
}

proptest! {
    /// Property: Any modification to a record in a chain must break the chain.
    #[test]
    fn prop_tamper_detection(
        mut records in prop::collection::vec(audit_record_strategy(GENESIS_HASH.to_string()), 1..5)
    ) {
        // Build a proper chain first
        let mut chain = Vec::new();
        let mut last_hash = GENESIS_HASH.to_string();
        for _ in 0..records.len() {
            let mut rec = records.pop().unwrap();
            rec.previous_hash = last_hash;
            rec.hash = compute_record_hash(&rec);
            last_hash = rec.hash.clone();
            chain.push(rec);
        }

        // Verify it's initially valid
        prop_assert!(verify_chain(&chain).is_ok());

        // Tamper with one record (if at least one exists)
        if !chain.is_empty() {
            let idx = 0; // Fixed index for simplicity in proptest
            chain[idx].what.change_description.push_str("_TAMPERED");
            // DO NOT recompute hash

            prop_assert!(verify_chain(&chain).is_err());
        }
    }

    /// Property: Temporal justification must respect the recording_date.
    #[test]
    fn prop_temporal_justification_validity(
        days_offset in -100i64..100i64,
        tolerance in 0i64..5i64
    ) {
        let now = Utc::now();
        let transaction_date = now.date_naive() - Duration::days(1);
        let effective_date = now.date_naive() + Duration::days(days_offset);

        let tj = TemporalJustification {
            transaction_date,
            effective_date,
            recording_date: now,
        };

        let result = tj.is_valid(tolerance);

        if days_offset <= tolerance {
            prop_assert!(result, "Expected valid for offset {} and tolerance {}", days_offset, tolerance);
        } else {
            prop_assert!(!result, "Expected invalid for offset {} and tolerance {}", days_offset, tolerance);
        }
    }
}
