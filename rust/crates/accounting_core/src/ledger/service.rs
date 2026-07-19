//! Ledger Service
//!
//! Orchestrates high-level ledger operations like posting and verification.
//! Ensures that all posted entries are validated and cryptographically chained.

use chrono::Utc;
use uuid::Uuid;

use super::chain::{compute_entry_hash, LEDGER_GENESIS_HASH};
use super::models::{EntryStatus, JournalEntry};
use super::validation::validate_for_posting;
use crate::accounts::registry::AccountRegistry;
use crate::standards::registry::StandardsRegistry;

/// Service for managing the accounting ledger.
pub struct LedgerService {
    /// The hash of the last successfully posted entry.
    latest_hash: String,
}

impl LedgerService {
    /// Create a new ledger service with the last known hash.
    pub fn new(last_hash: Option<String>) -> Self {
        Self {
            latest_hash: last_hash.unwrap_or_else(|| LEDGER_GENESIS_HASH.to_string()),
        }
    }

    /// Post a journal entry to the ledger.
    ///
    /// This is a critical operation that:
    /// 1. Validates the entry against standards and chart of accounts.
    /// 2. Sets the previous_hash and computes the current hash.
    /// 3. Marks the entry as Posted.
    pub fn post_entry(
        &mut self,
        mut entry: JournalEntry,
        standards: &StandardsRegistry,
        accounts: &AccountRegistry,
        posted_by: Uuid,
    ) -> Result<JournalEntry, String> {
        // 1. Validation
        if let Err(e) = validate_for_posting(&entry, standards, accounts) {
            return Err(format!("Validation failed: {:?}", e));
        }

        // 2. Chaining and Hashing
        entry.previous_hash = self.latest_hash.clone();
        entry.posted_by = Some(posted_by);
        entry.posted_at = Some(Utc::now());
        entry.status = EntryStatus::Posted;

        // Compute hash after setting status and timestamps
        entry.hash = compute_entry_hash(&entry);

        // 3. Update Service State
        self.latest_hash = entry.hash.clone();

        Ok(entry)
    }

    /// Retrieve the latest hash for persistence.
    pub fn latest_hash(&self) -> &str {
        &self.latest_hash
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::accounts::models::{Account, AccountKind, Ifrs18Category};
    use crate::ledger::models::{
        EntryType, JournalEntryLine, StandardsJustification, TemporalJustification,
    };
    use chrono::NaiveDate;
    use rust_decimal::Decimal;

    fn setup() -> (LedgerService, StandardsRegistry, AccountRegistry) {
        let standards = StandardsRegistry::load_defaults();
        let acc_id1 = Uuid::new_v4();
        let acc_id2 = Uuid::new_v4();

        let accounts = AccountRegistry::new(vec![
            Account {
                id: acc_id1,
                code: "1001".to_string(),
                name_ar: "حساب 1".to_string(),
                name_en: "Acc 1".to_string(),
                kind: AccountKind::Asset,
                classification: None,
                parent_id: None,
                ifrs_tag: None,
                currency: None,
                ifrs18_category: Ifrs18Category::Operating,
                description: None,
                requires_partner: false,
                is_active: true,
            },
            Account {
                id: acc_id2,
                code: "4001".to_string(),
                name_ar: "حساب 2".to_string(),
                name_en: "Acc 2".to_string(),
                kind: AccountKind::Income,
                classification: None,
                parent_id: None,
                ifrs_tag: None,
                currency: None,
                ifrs18_category: Ifrs18Category::Operating,
                description: None,
                requires_partner: false,
                is_active: true,
            },
        ]);

        (LedgerService::new(None), standards, accounts)
    }

    #[test]
    fn test_post_entry_hashing() {
        let (mut service, standards, accounts) = setup();
        let user_id = Uuid::new_v4();
        let items: Vec<_> = accounts.inner().values().collect();
        let acc1 = items[0].id;
        let acc2 = items[1].id;
        let today = NaiveDate::from_ymd_opt(2026, 1, 10).unwrap();

        let entry = JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "JE-001".to_string(),
            description: "Test".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Draft,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification::simple("IFRS 15.31"),
            lines: vec![
                JournalEntryLine {
                    source_document_ref: Some("DOC-001".to_string()),
                    ..JournalEntryLine::debit(acc1, Decimal::new(100, 0), "Debit")
                },
                JournalEntryLine {
                    source_document_ref: Some("DOC-002".to_string()),
                    ..JournalEntryLine::credit(acc2, Decimal::new(100, 0), "Credit")
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

        let posted1 = service
            .post_entry(entry.clone(), &standards, &accounts, user_id)
            .unwrap();
        assert_eq!(posted1.previous_hash, LEDGER_GENESIS_HASH);
        assert!(!posted1.hash.is_empty());
        assert_eq!(posted1.status, EntryStatus::Posted);

        let entry2 = JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "JE-002".to_string(),
            ..entry
        };

        let posted2 = service
            .post_entry(entry2, &standards, &accounts, user_id)
            .unwrap();
        assert_eq!(posted2.previous_hash, posted1.hash);
        assert_ne!(posted2.hash, posted1.hash);
    }
}
