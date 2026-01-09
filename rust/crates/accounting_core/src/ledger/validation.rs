//! Journal Entry Validation
//!
//! Implements the validation rules for journal entries.
//!
//! # Correctness Properties
//! - CP-001: Double-Entry Balance Enforcement
//! - CP-002: Standards Reference Completeness
//! - CP-008: Temporal Justification Completeness

use thiserror::Error;

use super::models::JournalEntry;
use crate::standards::registry::StandardsRegistry;
use crate::standards::validator::validate_format;
use rust_decimal::Decimal;

/// Validation errors for journal entries.
#[derive(Debug, Error)]
pub enum EntryValidationError {
    /// The entry is not balanced (CP-001 violation)
    #[error("Entry is not balanced: debits={debits}, credits={credits}")]
    NotBalanced { debits: String, credits: String },

    /// The entry has no lines
    #[error("Entry has no lines")]
    NoLines,

    /// The standards reference is invalid
    #[error("Invalid standards reference: {0}")]
    InvalidStandardsReference(String),

    /// The standards reference does not exist in registry
    #[error("Standards reference not found: {0}")]
    StandardsReferenceNotFound(String),

    /// The temporal justification is invalid
    #[error("Invalid temporal justification: effective_date > recording_date")]
    InvalidTemporalJustification,

    /// Cannot modify a posted entry
    #[error("Cannot modify posted entry")]
    EntryImmutable,

    /// Traceability chain is incomplete (CP-009 violation)
    #[error("Traceability chain incomplete: {0}")]
    MissingTraceability(String),

    /// Multi-currency arithmetic mismatch (CP-005 violation / IAS 21)
    #[error("Currency arithmetic mismatch: {0}")]
    CurrencyMismatch(String),

    /// Missing partner for sub-ledger account (CP-010 violation)
    #[error("Missing partner for sub-ledger account: {0}")]
    MissingPartner(String),
}

/// Result type for entry validation.
pub type ValidationResult<T> = Result<T, EntryValidationError>;

/// Validate that an entry is balanced (CP-001).
///
/// This is the most critical validation - the fundamental accounting equation.
///
/// # Returns
/// `Ok(())` if balanced, `Err` with details otherwise.
pub fn validate_balance(entry: &JournalEntry) -> ValidationResult<()> {
    if entry.is_balanced() {
        Ok(())
    } else {
        Err(EntryValidationError::NotBalanced {
            debits: entry.total_debits().to_string(),
            credits: entry.total_credits().to_string(),
        })
    }
}

/// Validate that an entry has lines.
pub fn validate_has_lines(entry: &JournalEntry) -> ValidationResult<()> {
    if entry.has_lines() {
        Ok(())
    } else {
        Err(EntryValidationError::NoLines)
    }
}

/// Validate the standards reference format (CP-002).
pub fn validate_standards_format(entry: &JournalEntry) -> ValidationResult<()> {
    let ref_str = &entry.standards.standard_reference;
    validate_format(ref_str)
        .map_err(|_| EntryValidationError::InvalidStandardsReference(ref_str.clone()))?;
    Ok(())
}

/// Validate the standards reference exists in registry (CP-002).
pub fn validate_standards_exists(
    entry: &JournalEntry,
    registry: &StandardsRegistry,
) -> ValidationResult<()> {
    let ref_str = &entry.standards.standard_reference;
    if registry.contains(ref_str) {
        Ok(())
    } else {
        Err(EntryValidationError::StandardsReferenceNotFound(
            ref_str.clone(),
        ))
    }
}

/// Validate temporal justification (CP-008).
pub fn validate_temporal(entry: &JournalEntry) -> ValidationResult<()> {
    if entry.temporal.is_valid(0) {
        Ok(())
    } else {
        Err(EntryValidationError::InvalidTemporalJustification)
    }
}

/// Validate traceability completeness (CP-009).
///
/// Ensures the chain entry -> source_doc -> transaction -> standards_ref is unbroken.
pub fn validate_traceability(entry: &JournalEntry) -> ValidationResult<()> {
    use crate::ledger::models::EntryType;

    // 1. Every entry MUST have a standards reference (CP-002)
    if entry.standards.standard_reference.trim().is_empty() {
        return Err(EntryValidationError::MissingTraceability(
            "Missing standards reference".to_string(),
        ));
    }

    // 2. Standard entries MUST have a source document reference on every line
    if entry.entry_type == EntryType::Standard {
        for (i, line) in entry.lines.iter().enumerate() {
            if line
                .source_document_ref
                .as_ref()
                .is_none_or(|s| s.trim().is_empty())
            {
                return Err(EntryValidationError::MissingTraceability(format!(
                    "Missing source document on line {}",
                    i + 1
                )));
            }
        }
    }

    // 3. Adjusting or Reversing entries MUST have a linked_entry_id
    if (entry.entry_type == EntryType::Adjusting || entry.entry_type == EntryType::Reversing)
        && entry.linked_entry_id.is_none()
    {
        return Err(EntryValidationError::MissingTraceability(format!(
            "Missing linked entry for {:?}",
            entry.entry_type
        )));
    }

    Ok(())
}

/// Validate multi-currency arithmetic (CP-005 / IAS 21).
///
/// For any line with an original currency:
/// Original Amount * Exchange Rate == (Debit or Credit Amount)
pub fn validate_currency(entry: &JournalEntry) -> ValidationResult<()> {
    for (i, line) in entry.lines.iter().enumerate() {
        if let (Some(orig_curr), Some(rate), Some(orig_amt)) = (
            &line.original_currency,
            line.exchange_rate,
            line.original_amount,
        ) {
            if rate <= Decimal::ZERO {
                return Err(EntryValidationError::CurrencyMismatch(format!(
                    "Line {}: Exchange rate must be positive, found {}",
                    i + 1,
                    rate
                )));
            }

            let calculated_functional = orig_amt * rate;
            let actual_functional = if line.debit_amount > Decimal::ZERO {
                line.debit_amount
            } else {
                line.credit_amount
            };

            // Allow for minor rounding differences (0.01)
            let diff = (calculated_functional - actual_functional).abs();
            if diff > Decimal::new(1, 2) {
                // 0.01
                return Err(EntryValidationError::CurrencyMismatch(format!(
                    "Line {}: Arithmetic mismatch for {}. Calculated {} ({} * {}), found {}",
                    i + 1,
                    orig_curr,
                    calculated_functional,
                    orig_amt,
                    rate,
                    actual_functional
                )));
            }
        }
    }
    Ok(())
}

/// Validate that entry is modifiable.
pub fn validate_modifiable(entry: &JournalEntry) -> ValidationResult<()> {
    if entry.is_modifiable() {
        Ok(())
    } else {
        Err(EntryValidationError::EntryImmutable)
    }
}

/// Perform full validation for posting.
///
/// This validates all rules required before an entry can be posted:
/// - Has lines
/// - Is balanced (CP-001)
/// - Standards reference format valid (CP-002)
/// - Standards reference exists in registry (CP-002)
/// - Temporal justification valid (CP-008)
/// - Traceability chain complete (CP-009)
pub fn validate_for_posting(
    entry: &JournalEntry,
    registry: &StandardsRegistry,
    accounts: &crate::accounts::AccountRegistry,
) -> ValidationResult<()> {
    validate_has_lines(entry)?;
    validate_balance(entry)?;
    validate_standards_format(entry)?;
    validate_standards_exists(entry, registry)?;
    validate_temporal(entry)?;
    validate_traceability(entry)?;
    validate_currency(entry)?;
    validate_partners(entry, accounts)?;
    Ok(())
}

/// Validate that entries to sub-ledger accounts have a partner_id (CP-010).
pub fn validate_partners(
    entry: &JournalEntry,
    accounts: &crate::accounts::AccountRegistry,
) -> ValidationResult<()> {
    for (i, line) in entry.lines.iter().enumerate() {
        if let Some(account) = accounts.get(&line.account_id) {
            if account.requires_partner && line.partner_id.is_none() {
                return Err(EntryValidationError::MissingPartner(format!(
                    "Line {} (Account {}) requires a partner record",
                    i + 1,
                    account.code
                )));
            }
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::ledger::models::{
        EntryStatus, EntryType, JournalEntryLine, StandardsJustification, TemporalJustification,
    };
    use chrono::{NaiveDate, Utc};
    use rust_decimal::Decimal;
    use uuid::Uuid;

    fn make_entry(debit: Decimal, credit: Decimal, std_ref: &str) -> JournalEntry {
        let today = NaiveDate::from_ymd_opt(2026, 1, 3).unwrap();
        JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: "JE-001".to_string(),
            description: "Test Entry".to_string(),
            entry_type: EntryType::Standard,
            status: EntryStatus::Draft,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(today, today),
            standards: StandardsJustification::simple(std_ref),
            lines: vec![
                JournalEntryLine {
                    line_id: Uuid::new_v4(),
                    line_number: 1,
                    account_id: Uuid::new_v4(),
                    debit_amount: debit,
                    credit_amount: Decimal::ZERO,
                    description: "Dr".to_string(),
                    source_document_ref: Some("PO-123".to_string()),
                    original_currency: None,
                    exchange_rate: None,
                    original_amount: None,
                    partner_id: None,
                },
                JournalEntryLine {
                    line_id: Uuid::new_v4(),
                    line_number: 2,
                    account_id: Uuid::new_v4(),
                    debit_amount: Decimal::ZERO,
                    credit_amount: credit,
                    description: "Cr".to_string(),
                    source_document_ref: Some("PO-123".to_string()),
                    original_currency: None,
                    exchange_rate: None,
                    original_amount: None,
                    partner_id: None,
                },
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
    fn test_validate_balanced() {
        let entry = make_entry(Decimal::from(1000), Decimal::from(1000), "IFRS 15.35");
        assert!(validate_balance(&entry).is_ok());
    }

    #[test]
    fn test_validate_unbalanced() {
        let entry = make_entry(Decimal::from(1000), Decimal::from(999), "IFRS 15.35");
        let result = validate_balance(&entry);
        assert!(matches!(
            result,
            Err(EntryValidationError::NotBalanced { .. })
        ));
    }

    #[test]
    fn test_validate_traceability_standard_missing_doc() {
        let mut entry = make_entry(Decimal::from(1000), Decimal::from(1000), "IFRS 15.35");
        entry.lines[0].source_document_ref = None;
        let result = validate_traceability(&entry);
        assert!(matches!(
            result,
            Err(EntryValidationError::MissingTraceability(msg)) if msg.contains("line 1")
        ));
    }

    #[test]
    fn test_validate_traceability_adjusting_missing_link() {
        let mut entry = make_entry(Decimal::from(1000), Decimal::from(1000), "IFRS 15.35");
        entry.entry_type = EntryType::Adjusting;
        entry.linked_entry_id = None;
        let result = validate_traceability(&entry);
        assert!(matches!(
            result,
            Err(EntryValidationError::MissingTraceability(msg)) if msg.contains("Missing linked entry")
        ));
    }

    #[test]
    fn test_validate_for_posting_success() {
        let registry = StandardsRegistry::load_defaults();
        let accounts = crate::accounts::AccountRegistry::new(vec![]);
        let entry = make_entry(Decimal::from(500), Decimal::from(500), "IFRS 15.35");
        assert!(validate_for_posting(&entry, &registry, &accounts).is_ok());
    }

    #[test]
    fn test_validate_for_posting_bad_reference() {
        let registry = StandardsRegistry::load_defaults();
        let accounts = crate::accounts::AccountRegistry::new(vec![]);
        // Use valid format (IFRS) but non-existent reference
        let entry = make_entry(Decimal::from(500), Decimal::from(500), "IFRS 999.1");
        let result = validate_for_posting(&entry, &registry, &accounts);
        assert!(matches!(
            result,
            Err(EntryValidationError::StandardsReferenceNotFound(_))
        ));
    }

    #[test]
    fn test_validate_currency_success() {
        let mut entry = make_entry(Decimal::from(375), Decimal::from(375), "IFRS 15.35");
        // 100 USD * 3.75 = 375 SAR
        entry.lines[0].original_currency = Some("USD".to_string());
        entry.lines[0].original_amount = Some(Decimal::from(100));
        entry.lines[0].exchange_rate = Some(Decimal::from_str_exact("3.75").unwrap());

        assert!(validate_currency(&entry).is_ok());
    }

    #[test]
    fn test_validate_currency_mismatch() {
        let mut entry = make_entry(Decimal::from(375), Decimal::from(375), "IFRS 15.35");
        // 100 USD * 3.75 = 375 SAR, but we put 380 in functional
        entry.lines[0].debit_amount = Decimal::from(380);
        entry.lines[0].original_currency = Some("USD".to_string());
        entry.lines[0].original_amount = Some(Decimal::from(100));
        entry.lines[0].exchange_rate = Some(Decimal::from_str_exact("3.75").unwrap());

        let result = validate_currency(&entry);
        assert!(matches!(
            result,
            Err(EntryValidationError::CurrencyMismatch(_))
        ));
    }
}
