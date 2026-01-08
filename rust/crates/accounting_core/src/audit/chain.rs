//! Hash Chain Implementation
//!
//! Implements the cryptographic hash chain for audit trail integrity.
//!
//! # Correctness Property CP-003
//! "No audit record can be modified or deleted after creation.
//!  Hash chain must remain intact."
//!
//! # Algorithm
//! Each record's hash = SHA256(previous_hash + record_content)

use sha2::{Digest, Sha256};

use super::models::AuditRecord;

/// The genesis hash for the first record in a chain.
pub const GENESIS_HASH: &str =
    "0000000000000000000000000000000000000000000000000000000000000000";

/// Compute the SHA-256 hash of content.
pub fn compute_hash(content: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(content.as_bytes());
    let result = hasher.finalize();
    hex::encode(result)
}

/// Compute the hash for an audit record.
///
/// The hash includes the previous hash, ensuring chain integrity.
pub fn compute_record_hash(record: &AuditRecord) -> String {
    let content = record.hashable_content();
    compute_hash(&content)
}

/// Verify that a record's hash is correct.
pub fn verify_record_hash(record: &AuditRecord) -> bool {
    let computed = compute_record_hash(record);
    computed == record.hash
}

/// Verify the integrity of a chain of records.
///
/// # Returns
/// - `Ok(())` if chain is valid
/// - `Err(index)` where index is the first broken link
pub fn verify_chain(records: &[AuditRecord]) -> Result<(), usize> {
    if records.is_empty() {
        return Ok(());
    }

    // First record should have genesis hash as previous
    if records[0].previous_hash != GENESIS_HASH {
        return Err(0);
    }

    // Verify each record's hash
    for (i, record) in records.iter().enumerate() {
        if !verify_record_hash(record) {
            return Err(i);
        }

        // Verify chain link (current previous_hash = previous record's hash)
        if i > 0 && record.previous_hash != records[i - 1].hash {
            return Err(i);
        }
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::audit::models::*;
    use chrono::Utc;
    use uuid::Uuid;

    fn create_test_record(prev_hash: &str) -> AuditRecord {
        let mut record = AuditRecord {
            record_id: Uuid::new_v4(),
            who: WhoInfo {
                user_id: Uuid::new_v4(),
                user_name: "test_user".to_string(),
                role: "accountant".to_string(),
                session_id: Uuid::new_v4(),
            },
            what: WhatInfo {
                action: AuditAction::Create,
                entity_type: "JournalEntry".to_string(),
                entity_id: Uuid::new_v4(),
                change_description: "Created entry".to_string(),
                old_value: None,
                new_value: Some("{}".to_string()),
            },
            when: Utc::now(),
            r#where: WhereInfo {
                system_id: "basir-engine".to_string(),
                ip_address: Some("127.0.0.1".to_string()),
                location: None,
                device_id: None,
                app_version: None,
            },
            why: WhyInfo {
                reason_code: Some("ENTRY_CREATE".to_string()),
                justification: None,
                authorization_reference: None,
            },
            how: HowInfo {
                method: "API".to_string(),
                procedure_reference: None,
                api_endpoint: Some("/entries".to_string()),
            },
            hash: String::new(),
            previous_hash: prev_hash.to_string(),
        };

        // Compute and set the hash
        record.hash = compute_record_hash(&record);
        record
    }

    #[test]
    fn test_hash_deterministic() {
        let hash1 = compute_hash("test content");
        let hash2 = compute_hash("test content");
        assert_eq!(hash1, hash2);
        assert_eq!(hash1.len(), 64); // SHA-256 = 64 hex chars
    }

    #[test]
    fn test_verify_record_hash() {
        let record = create_test_record(GENESIS_HASH);
        assert!(verify_record_hash(&record));
    }

    #[test]
    fn test_verify_chain_valid() {
        let r1 = create_test_record(GENESIS_HASH);
        let r2 = create_test_record(&r1.hash);
        let r3 = create_test_record(&r2.hash);

        let chain = vec![r1, r2, r3];
        assert!(verify_chain(&chain).is_ok());
    }

    #[test]
    fn test_verify_chain_broken() {
        let r1 = create_test_record(GENESIS_HASH);
        let mut r2 = create_test_record(&r1.hash);
        r2.previous_hash = "tampered".to_string(); // Break the chain

        let chain = vec![r1, r2];
        assert!(verify_chain(&chain).is_err());
    }
}
