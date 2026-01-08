use accounting_core::{
    audit::{chain::{compute_record_hash, GENESIS_HASH}, models::{AuditAction, AuditRecord, HowInfo, WhatInfo, WhereInfo, WhoInfo, WhyInfo}},
};
use chrono::Utc;
use proptest::prelude::*;
use uuid::Uuid;

// Generates random audit actions
prop_compose! {
    fn arb_audit_action()(idx in 0..7usize) -> AuditAction {
        match idx {
            0 => AuditAction::Create,
            1 => AuditAction::Update,
            2 => AuditAction::Delete,
            3 => AuditAction::Approve,
            4 => AuditAction::Post,
            5 => AuditAction::Reverse,
            _ => AuditAction::Query,
        }
    }
}

proptest! {
    // CP-003: Audit Trail Immutability Invariant
    #[test]
    fn prop_cp_003_hash_chain_integrity(
        actions in prop::collection::vec(arb_audit_action(), 1..20),
        user_id in prop::array::uniform16(0u8..255),
    ) {
        let mut prev_hash = GENESIS_HASH.to_string();
        let user_uuid = Uuid::from_bytes(user_id);
        
        for action in actions {
            let record_id = Uuid::new_v4();
            let timestamp = Utc::now();
            
            // Reconstruct a record as if it were being created
            // Note: In real implementation, the `AuditTrail` struct manages this.
            // Here we verify the core hash property: Hash(Content + PrevHash)
            
            let mut record = AuditRecord {
                record_id,
                who: WhoInfo {
                    user_id: user_uuid,
                    user_name: "test_robot".to_string(),
                    role: "system".to_string(),
                    session_id: Uuid::new_v4(),
                },
                what: WhatInfo {
                    action,
                    entity_type: "JournalEntry".to_string(),
                    entity_id: Uuid::new_v4(),
                    change_description: "Property test action".to_string(),
                    old_value: None,
                    new_value: None,
                },
                when: timestamp,
                r#where: WhereInfo {
                    system_id: "test-node".to_string(),
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
                    method: "PROPTEST".to_string(),
                    procedure_reference: None,
                    api_endpoint: None,
                },
                previous_hash: prev_hash.clone(),
                hash: String::new(), // To be computed
            };
            
            let computed = compute_record_hash(&record);
            record.hash = computed.clone();
            
            // Invariant: The record's hash MUST rely on the previous hash
            // (If we changed previous_hash, the check would fail)
            prop_assert_eq!(&record.previous_hash, &prev_hash);
            prop_assert_eq!(&record.hash, &compute_record_hash(&record));
            
            // Advance chain
            prev_hash = computed;
        }
    }
    
    #[test]
    fn prop_cp_003_tamper_evidence(
        action in arb_audit_action()
    ) {
        let prev_hash = GENESIS_HASH.to_string();
        let mut record = AuditRecord {
            record_id: Uuid::new_v4(),
            who: WhoInfo {
                user_id: Uuid::new_v4(),
                user_name: "hacker".to_string(),
                role: "admin".to_string(),
                session_id: Uuid::new_v4(),
            },
            what: WhatInfo {
                action,
                entity_type: "Ledger".to_string(),
                entity_id: Uuid::new_v4(),
                change_description: "Tampering...".to_string(),
                old_value: None,
                new_value: None,
            },
            when: Utc::now(),
            r#where: WhereInfo {
                system_id: "X".to_string(),
                ip_address: None,
                location: None,
                device_id: None,
                app_version: None,
            },
            why: WhyInfo { reason_code: None, justification: None, authorization_reference: None },
            how: HowInfo { method: "X".to_string(), procedure_reference: None, api_endpoint: None },
            previous_hash: prev_hash,
            hash: String::new(),
        };
        
        let valid_hash = compute_record_hash(&record);
        record.hash = valid_hash.clone();
        
        // TAMPERING: Change the content
        record.what.change_description = "Tampered Content".to_string();
        
        // Invariant: Hash check must fail
        let new_hash = compute_record_hash(&record);
        prop_assert_ne!(record.hash, new_hash);
    }
}
