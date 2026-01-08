//! Journal Entry Data Models
//!
//! Derived from `design.md` Section 5.1: Core Entity Model
//!
//! # Requirements Alignment
//! - Req 2.1: Double-Entry Balance Enforcement
//! - Req 2.2: Temporal Justification
//! - Req 2.3: Standards Justification
//! - Req 2.4: Append-Only Immutability

use crate::standards::models::{MeasurementBasis, RecognitionBasis};
use chrono::{DateTime, NaiveDate, Utc};
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

/// Entry status workflow.
///
/// Follows the lifecycle: DRAFT -> PENDING_APPROVAL -> APPROVED -> POSTED
/// With REVERSED as a terminal state for corrections.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum EntryStatus {
    /// Initial creation, can be modified
    Draft,
    /// Submitted for approval, read-only
    PendingApproval,
    /// Approved, waiting for posting
    Approved,
    /// Posted to ledger, immutable
    Posted,
    /// Reversed by a correcting entry
    Reversed,
}

/// Entry type classification.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum EntryType {
    /// Normal business transaction
    Standard,
    /// Period-end adjustment
    Adjusting,
    /// Correction of previous entry
    Reversing,
    /// Period close entry
    Closing,
}

/// Temporal justification for a journal entry.
///
/// Per Req 2.2 (IAS 10), every entry must have three dates:
/// - Transaction date: When the event actually occurred
/// - Effective date: When the accounting effect applies
/// - Recording date: When entered into the system
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct TemporalJustification {
    /// Date when the underlying transaction occurred
    pub transaction_date: NaiveDate,
    /// Date when the accounting effect applies
    pub effective_date: NaiveDate,
    /// System timestamp when the entry was recorded
    pub recording_date: DateTime<Utc>,
}

impl TemporalJustification {
    /// Create new temporal justification with current recording time.
    pub fn new(transaction_date: NaiveDate, effective_date: NaiveDate) -> Self {
        Self {
            transaction_date,
            effective_date,
            recording_date: Utc::now(),
        }
    }

    /// Validate the temporal relationships.
    ///
    /// Per CP-008: effective_date <= recording_date + tolerance
    /// Default tolerance is 0 days for strict IFRS compliance.
    pub fn is_valid(&self, future_tolerance_days: i64) -> bool {
        let max_valid_date =
            self.recording_date.date_naive() + chrono::Duration::days(future_tolerance_days);
        self.effective_date <= max_valid_date
    }
}

/// Standards justification for a journal entry.
///
/// Per Req 2.3 (IAS 1.117-124), every posted entry must reference
/// an accounting standard to justify the treatment.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct StandardsJustification {
    /// Reference in format "BODY NUMBER.PARAGRAPH" (e.g., "IFRS 15.35")
    pub standard_reference: String,
    /// Optional: basis for recognition
    pub recognition_basis: Option<RecognitionBasis>,
    /// Optional: basis for measurement
    pub measurement_basis: Option<MeasurementBasis>,
    /// Optional: professional judgment documentation
    pub professional_judgment: Option<String>,
}

impl StandardsJustification {
    /// Create a simple standards justification with just the reference.
    pub fn simple(standard_reference: &str) -> Self {
        Self {
            standard_reference: standard_reference.to_string(),
            recognition_basis: None,
            measurement_basis: None,
            professional_judgment: None,
        }
    }
}

/// A single line within a journal entry.
///
/// Each line represents a debit or credit to a specific account.
/// Either debit_amount or credit_amount should be non-zero, not both.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct JournalEntryLine {
    /// Unique identifier for this line
    pub line_id: Uuid,
    /// Sequential line number within the entry
    pub line_number: u32,
    /// Account to debit/credit
    pub account_id: Uuid,
    /// Debit amount (zero if credit)
    pub debit_amount: Decimal,
    /// Credit amount (zero if debit)
    pub credit_amount: Decimal,
    /// Line description
    pub description: String,
    /// Reference to source document
    pub source_document_ref: Option<String>,

    // Multi-currency support (IAS 21)
    /// Original currency of the transaction
    pub original_currency: Option<String>,
    /// Exchange rate used (Original * Rate = System Currency Amount)
    pub exchange_rate: Option<Decimal>,
    /// Original amount in the stated currency
    pub original_amount: Option<Decimal>,
    /// Optional: Linked partner (Customer/Vendor) for sub-ledger (CP-010)
    pub partner_id: Option<Uuid>,
}

impl JournalEntryLine {
    /// Create a debit line.
    pub fn debit(account_id: Uuid, amount: Decimal, description: &str) -> Self {
        Self {
            line_id: Uuid::new_v4(),
            line_number: 0,
            account_id,
            debit_amount: amount,
            credit_amount: Decimal::ZERO,
            description: description.to_string(),
            source_document_ref: None,
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
            partner_id: None,
        }
    }

    /// Create a credit line.
    pub fn credit(account_id: Uuid, amount: Decimal, description: &str) -> Self {
        Self {
            line_id: Uuid::new_v4(),
            line_number: 0,
            account_id,
            debit_amount: Decimal::ZERO,
            credit_amount: amount,
            description: description.to_string(),
            source_document_ref: None,
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
            partner_id: None,
        }
    }
}

/// Reasons for an adjustment entry.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum AdjustmentReason {
    Correction,
    Reclassification,
    Accrual,
    Deferral,
    EstimationChange,
    PolicyChange,
}

/// A complete journal entry.
///
/// This is the core data structure for the accounting engine.
/// It enforces double-entry balance through validation before posting.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct JournalEntry {
    /// Unique identifier
    pub entry_id: Uuid,
    /// Sequential entry number (period-specific)
    pub entry_number: String,
    /// Entry description
    pub description: String,
    /// Entry type
    pub entry_type: EntryType,
    /// Current status
    pub status: EntryStatus,
    /// Link to original entry (for Reversal/Adjustment)
    pub linked_entry_id: Option<Uuid>,
    /// Reason for adjustment (if applicable)
    pub adjustment_reason: Option<AdjustmentReason>,
    /// Temporal justification
    pub temporal: TemporalJustification,
    /// Standards justification
    pub standards: StandardsJustification,
    /// Entry lines (debits and credits)
    pub lines: Vec<JournalEntryLine>,

    // Audit metadata
    /// User who created the entry
    pub created_by: Uuid,
    /// Timestamp of creation
    pub created_at: DateTime<Utc>,
    /// User who approved (if applicable)
    pub approved_by: Option<Uuid>,
    /// Timestamp of approval
    pub approved_at: Option<DateTime<Utc>>,
    /// User who posted (if applicable)
    pub posted_by: Option<Uuid>,
    /// Timestamp of posting
    pub posted_at: Option<DateTime<Utc>>,

    // Integrity
    /// SHA-256 hash of entry content
    pub hash: String,
    /// Hash of previous entry (for chain)
    pub previous_hash: String,
}

impl JournalEntry {
    /// Calculate total debits across all lines.
    pub fn total_debits(&self) -> Decimal {
        self.lines.iter().map(|l| l.debit_amount).sum()
    }

    /// Calculate total credits across all lines.
    pub fn total_credits(&self) -> Decimal {
        self.lines.iter().map(|l| l.credit_amount).sum()
    }

    /// Check if the entry is balanced (CP-001).
    ///
    /// This is the core invariant: Σ(Debits) = Σ(Credits)
    pub fn is_balanced(&self) -> bool {
        self.total_debits() == self.total_credits()
    }

    /// Check if the entry has at least one line.
    pub fn has_lines(&self) -> bool {
        !self.lines.is_empty()
    }

    /// Check if the entry is in a modifiable state.
    pub fn is_modifiable(&self) -> bool {
        self.status == EntryStatus::Draft
    }

    /// Check if the entry is posted (immutable).
    pub fn is_posted(&self) -> bool {
        self.status == EntryStatus::Posted
    }

    /// Create a complete reversal of this entry.
    ///
    /// Task 10.3: Implement entry reversal mechanism
    ///
    /// This creates a new entry that exactly reverses all debits and credits
    /// from the original entry. The original entry is NOT modified - it remains
    /// in the ledger with its status changed to Reversed.
    ///
    /// # Arguments
    /// * `reversal_reason` - Required documentation explaining why the reversal is needed
    /// * `created_by` - User creating the reversal
    ///
    /// # Requirements
    /// - Original entry must be Posted
    /// - Reversal swaps all debits to credits and vice versa
    /// - Links reversal to original entry via standards.professional_judgment
    pub fn create_reversal(&self, reversal_reason: &str, created_by: Uuid) -> Option<JournalEntry> {
        // Can only reverse posted entries
        if self.status != EntryStatus::Posted {
            return None;
        }

        // Create reversed lines (swap debits and credits)
        let reversed_lines: Vec<JournalEntryLine> = self
            .lines
            .iter()
            .map(|line| {
                JournalEntryLine {
                    line_id: Uuid::new_v4(),
                    line_number: line.line_number,
                    account_id: line.account_id,
                    debit_amount: line.credit_amount, // Swap: credit -> debit
                    credit_amount: line.debit_amount, // Swap: debit -> credit
                    description: format!("Reversal: {}", line.description),
                    source_document_ref: line.source_document_ref.clone(),
                    original_currency: line.original_currency.clone(),
                    exchange_rate: line.exchange_rate,
                    original_amount: line.original_amount,
                    partner_id: line.partner_id,
                }
            })
            .collect();

        let today = Utc::now().date_naive();

        Some(JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: format!("REV-{}", self.entry_number),
            description: format!("Reversal of {}: {}", self.entry_number, reversal_reason),
            entry_type: EntryType::Reversing,
            status: EntryStatus::Draft,
            linked_entry_id: Some(self.entry_id),
            adjustment_reason: Some(AdjustmentReason::Correction),
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification {
                standard_reference: self.standards.standard_reference.clone(),
                recognition_basis: self.standards.recognition_basis,
                measurement_basis: self.standards.measurement_basis,
                professional_judgment: Some(format!(
                    "Reversal of entry {} - Reason: {}",
                    self.entry_number, reversal_reason
                )),
            },
            lines: reversed_lines,
            created_by,
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        })
    }

    /// Mark this entry as reversed.
    ///
    /// Called after the reversing entry is posted.
    pub fn mark_reversed(&mut self) {
        self.status = EntryStatus::Reversed;
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn create_test_entry(debit: Decimal, credit: Decimal) -> JournalEntry {
        let acc1 = Uuid::new_v4();
        let acc2 = Uuid::new_v4();
        let today = NaiveDate::from_ymd_opt(2026, 1, 3).unwrap();

        JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "TEST-001".to_string(),
            description: "Test Entry".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Draft,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification::simple("IFRS 15.35"),
            lines: vec![
                JournalEntryLine::debit(acc1, debit, "Revenue"),
                JournalEntryLine::credit(acc2, credit, "Cash"),
            ],
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
    fn test_balanced_entry() {
        let entry = create_test_entry(Decimal::from(1000), Decimal::from(1000));
        assert!(entry.is_balanced());
    }

    #[test]
    fn test_unbalanced_entry() {
        let entry = create_test_entry(Decimal::from(1000), Decimal::from(999));
        assert!(!entry.is_balanced());
    }

    #[test]
    fn test_total_calculations() {
        let entry = create_test_entry(Decimal::from(500), Decimal::from(500));
        assert_eq!(entry.total_debits(), Decimal::from(500));
        assert_eq!(entry.total_credits(), Decimal::from(500));
    }

    #[test]
    fn test_status_modifiable() {
        let mut entry = create_test_entry(Decimal::from(100), Decimal::from(100));
        assert!(entry.is_modifiable());
        entry.status = EntryStatus::Posted;
        assert!(!entry.is_modifiable());
    }
}
