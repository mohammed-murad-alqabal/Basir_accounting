//! Audit Trail Data Models
//!
//! Derived from `design.md` Section 5.3: Audit Trail Model
//!
//! # The 5W+H Model
//! - Who: User identity and role
//! - What: Change description
//! - When: Precise timestamp
//! - Where: System location
//! - Why: Justification
//! - How: Method used

use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

/// Actions that can be recorded in the audit trail.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum AuditAction {
    Create,
    Update,
    Delete,
    Approve,
    Post,
    Reverse,
    Query,
    CognitiveVerify,
}

/// Who performed the action.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WhoInfo {
    pub user_id: Uuid,
    pub user_name: String,
    pub role: String,
    pub session_id: Uuid,
}

/// What was changed.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WhatInfo {
    pub action: AuditAction,
    pub entity_type: String,
    pub entity_id: Uuid,
    pub change_description: String,
    pub old_value: Option<String>,
    pub new_value: Option<String>,
}

/// Where the action occurred.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WhereInfo {
    pub system_id: String,
    pub ip_address: Option<String>,
    pub location: Option<String>,
    pub device_id: Option<String>,
    pub app_version: Option<String>,
}

/// Why the action was performed.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WhyInfo {
    pub reason_code: Option<String>,
    pub justification: Option<String>,
    pub authorization_reference: Option<String>,
}

/// How the action was performed.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HowInfo {
    pub method: String,
    pub procedure_reference: Option<String>,
    pub api_endpoint: Option<String>,
}

/// A complete audit record with 5W+H and integrity fields.
///
/// Once created, this record is immutable. The hash field links
/// it to the previous record, forming a tamper-evident chain.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AuditRecord {
    pub record_id: Uuid,

    // 5W+H fields
    pub who: WhoInfo,
    pub what: WhatInfo,
    pub when: DateTime<Utc>,
    pub r#where: WhereInfo,
    pub why: WhyInfo,
    pub how: HowInfo,

    // Integrity fields (CP-003)
    /// SHA-256 hash of this record's content
    pub hash: String,
    /// Hash of the previous record in the chain
    pub previous_hash: String,
}

impl AuditRecord {
    /// Get the content to be hashed (everything except the hash field).
    pub fn hashable_content(&self) -> String {
        format!(
            "{}|{}|{}|{}|{}|{}|{}|{}",
            self.record_id,
            self.who.user_id,
            serde_json::to_string(&self.what).unwrap_or_default(),
            self.when.timestamp_millis(),
            self.r#where.system_id,
            self.why.reason_code.as_deref().unwrap_or(""),
            self.how.method,
            self.previous_hash,
        )
    }

    /// Verify the integrity of this record's hash.
    pub fn verify(&self) -> bool {
        use sha2::{Digest, Sha256};
        let mut hasher = Sha256::new();
        hasher.update(self.hashable_content());
        let calculated_hash = hex::encode(hasher.finalize());
        calculated_hash == self.hash
    }
}

/// Helper struct to pass context for audit logging.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AuditMetadata {
    pub who: WhoInfo,
    pub r#where: WhereInfo,
    pub why: WhyInfo,
    pub how: HowInfo,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_audit_action_serialization() {
        let action = AuditAction::Post;
        let json = serde_json::to_string(&action).unwrap();
        assert!(json.contains("Post"));
    }
}
