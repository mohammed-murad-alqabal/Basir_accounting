//! Audit Trail Service
//!
//! Provides high-level operations for the audit trail.
//!
//! # Task 12.2: Implement 5W+H recording
//! # Task 13: Audit Operations
//!
//! Handles the creation of audit records ensuring all 5W+H fields are captured
//! and the hash chain is maintained.

use chrono::Utc;
use uuid::Uuid;

use super::chain::{compute_record_hash, verify_chain, GENESIS_HASH};
use super::models::{AuditAction, AuditMetadata, AuditRecord, WhatInfo};

/// Service for managing the audit trail.
pub struct AuditService {
    /// In-memory cache of the latest hash (in real system, this comes from DB)
    latest_hash: String,
}

impl AuditService {
    /// Create a new audit service initialized with genesis or last known hash.
    pub fn new(last_hash: Option<String>) -> Self {
        Self {
            latest_hash: last_hash.unwrap_or_else(|| GENESIS_HASH.to_string()),
        }
    }

    /// Record a change in the audit trail.
    ///
    /// Task 12.2: Implement 5W+H recording
    /// Task 13.1: Implement change recording
    ///
    /// # Arguments
    /// * `metadata` - Context (Who, Where, Why, How)
    /// * `action` - The action performed
    /// * `entity_type` - Type of entity modified
    /// * `entity_id` - ID of entity
    /// * `description` - Human readable description
    /// * `old_val` - Previous state (optional)
    /// * `new_val` - New state (optional)
    #[allow(clippy::too_many_arguments)]
    pub fn record_change(
        &mut self,
        metadata: AuditMetadata,
        action: AuditAction,
        entity_type: &str,
        entity_id: Uuid,
        description: &str,
        old_val: Option<String>,
        new_val: Option<String>,
    ) -> AuditRecord {
        let what = WhatInfo {
            action,
            entity_type: entity_type.to_string(),
            entity_id,
            change_description: description.to_string(),
            old_value: old_val,
            new_value: new_val,
        };

        let mut record = AuditRecord {
            record_id: Uuid::new_v4(),
            who: metadata.who,
            what,
            when: Utc::now(),
            r#where: metadata.r#where,
            why: metadata.why,
            how: metadata.how,
            hash: String::new(),
            previous_hash: self.latest_hash.clone(),
        };

        // Compute hash (Task 12.3)
        record.hash = compute_record_hash(&record);

        // Update chain tip
        self.latest_hash = record.hash.clone();

        record
    }

    /// Verify the integrity of a sequence of records.
    ///
    /// Task 13.2: Implement tamper detection
    pub fn verify_integrity(records: &[AuditRecord]) -> Result<(), usize> {
        verify_chain(records)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::audit::models::*;

    fn mock_metadata() -> AuditMetadata {
        AuditMetadata {
            who: WhoInfo {
                user_id: Uuid::new_v4(),
                user_name: "test".to_string(),
                role: "admin".to_string(),
                session_id: Uuid::new_v4(),
            },
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
                method: "TEST".to_string(),
                procedure_reference: None,
                api_endpoint: None,
            },
        }
    }

    #[test]
    fn test_record_creation_chaining() {
        let mut service = AuditService::new(None);

        let rec1 = service.record_change(
            mock_metadata(),
            AuditAction::Create,
            "Account",
            Uuid::new_v4(),
            "Created account",
            None,
            None,
        );

        assert_eq!(rec1.previous_hash, GENESIS_HASH);

        let rec2 = service.record_change(
            mock_metadata(),
            AuditAction::Update,
            "Account",
            Uuid::new_v4(),
            "Updated account",
            None,
            None,
        );

        assert_eq!(rec2.previous_hash, rec1.hash);

        assert!(AuditService::verify_integrity(&[rec1, rec2]).is_ok());
    }
}
