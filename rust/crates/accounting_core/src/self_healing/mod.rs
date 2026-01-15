//! Self-Healing Engine
//!
//! Responsible for identifying and suggesting repairs for ledger anomalies,
//! sequence gaps, and reconciliation discrepancies.

use crate::ledger::models::{
    AdjustmentReason, EntryStatus, EntryType, JournalEntry, JournalEntryLine,
    StandardsJustification, TemporalJustification,
};
use rust_decimal::Decimal;

/// Represents an anomaly detected in the accounting logic.
#[derive(Debug, Clone)]
pub enum Anomaly {
    /// A gap in the chronological sequence of entry numbers.
    SequenceGap { expected: String, found: String },

    /// A discrepancy between physical count and book balance.
    ReconciliationMismatch {
        account_id: uuid::Uuid,
        book_balance: Decimal,
        physical_count: Decimal,
    },

    /// An unposted entry that is older than the closing period.
    OrphanedDraft {
        entry_id: uuid::Uuid,
        date: chrono::NaiveDate,
    },
}

/// The Auditor entity that scans for anomalies.
pub struct Auditor;

impl Auditor {
    /// Scan a list of entries for sequence gaps.
    ///
    /// This parses entry numbers like "JE-001" and identifies missing numbers.
    pub fn scan_sequence(prefix: &str, entries: &[JournalEntry]) -> Vec<Anomaly> {
        let mut numbers: Vec<u32> = entries
            .iter()
            .filter(|e| e.entry_number.starts_with(prefix))
            .filter_map(|e| {
                e.entry_number
                    .strip_prefix(prefix)
                    .and_then(|s| s.parse::<u32>().ok())
            })
            .collect();

        numbers.sort_unstable();

        let mut anomalies = Vec::new();
        if numbers.is_empty() {
            return anomalies;
        }

        let mut expected = numbers[0];
        for &found in &numbers {
            while expected < found {
                anomalies.push(Anomaly::SequenceGap {
                    expected: format!("{}{:03}", prefix, expected),
                    found: format!("{}{:03}", prefix, found),
                });
                expected += 1;
            }
            expected = found + 1;
        }

        anomalies
    }

    /// Calculate the required repair entry for a reconciliation mismatch.
    pub fn suggest_repair(
        anomaly: &Anomaly,
        created_by: uuid::Uuid,
        standards_ref: &str,
    ) -> Option<JournalEntry> {
        match anomaly {
            Anomaly::ReconciliationMismatch {
                account_id,
                book_balance,
                physical_count,
            } => {
                let diff = *physical_count - *book_balance;
                if diff.is_zero() {
                    return None;
                }

                let today = chrono::Utc::now().date_naive();
                let mut lines = Vec::new();

                if diff.is_sign_positive() {
                    // Physical > Book -> Debit Account, Credit Inventory Gain
                    lines.push(JournalEntryLine::debit(
                        *account_id,
                        diff,
                        "Reconciliation gain",
                    ));
                    // Note: In a real system, the balancing account would be looked up
                    // For now, we use a placeholder UUID
                    lines.push(JournalEntryLine::credit(
                        uuid::Uuid::nil(),
                        diff,
                        "Inventory reconciliation gain account",
                    ));
                } else {
                    // Physical < Book -> Credit Account, Debit Inventory Loss
                    let abs_diff = diff.abs();
                    lines.push(JournalEntryLine::credit(
                        *account_id,
                        abs_diff,
                        "Reconciliation loss",
                    ));
                    lines.push(JournalEntryLine::debit(
                        uuid::Uuid::nil(),
                        abs_diff,
                        "Inventory reconciliation loss account",
                    ));
                }

                Some(JournalEntry {
                    entry_id: uuid::Uuid::new_v4(),
                    entry_number: "ADJ-RECON-AUTO".to_string(),
                    description: format!(
                        "Automatic reconciliation adjustment for {:?}",
                        account_id
                    ),
                    entry_type: EntryType::Adjusting,
                    status: EntryStatus::Draft,
                    linked_entry_id: None,
                    adjustment_reason: Some(AdjustmentReason::Correction),
                    temporal: TemporalJustification::new(today, today),
                    standards: StandardsJustification::simple(standards_ref),
                    lines,
                    created_by,
                    created_at: chrono::Utc::now(),
                    approved_by: None,
                    approved_at: None,
                    posted_by: None,
                    posted_at: None,
                    hash: String::new(),
                    previous_hash: String::new(),
                })
            }
            _ => None,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ledger::models::{
        EntryStatus, EntryType, JournalEntry, StandardsJustification, TemporalJustification,
    };
    use chrono::{NaiveDate, Utc};
    use rust_decimal::Decimal;
    use uuid::Uuid;

    fn mock_entry(number: &str) -> JournalEntry {
        let today = NaiveDate::from_ymd_opt(2026, 1, 3).unwrap();
        JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: number.to_string(),
            description: "Test".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Draft,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification::simple("IFRS 15.35"),
            lines: Vec::new(),
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

    #[test]
    fn test_scan_sequence_gaps() {
        let entries = vec![
            mock_entry("JE-001"),
            mock_entry("JE-003"),
            mock_entry("JE-005"),
        ];
        let anomalies = Auditor::scan_sequence("JE-", &entries);
        assert_eq!(anomalies.len(), 2);
        if let Anomaly::SequenceGap { expected, .. } = &anomalies[0] {
            assert_eq!(expected, "JE-002");
        }
    }

    #[test]
    fn test_suggest_repair_mismatch() {
        let acc_id = Uuid::new_v4();
        let anomaly = Anomaly::ReconciliationMismatch {
            account_id: acc_id,
            book_balance: Decimal::from(100),
            physical_count: Decimal::from(90),
        };
        let repair = Auditor::suggest_repair(&anomaly, Uuid::new_v4(), "IFRS 13.9").unwrap();
        assert_eq!(repair.entry_type, EntryType::Adjusting);
        assert_eq!(repair.total_debits(), Decimal::from(10));
        assert_eq!(repair.total_credits(), Decimal::from(10));
    }
}
