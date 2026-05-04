use flutter_rust_bridge::frb;
use crate::api::simple::greet;

/// Represents a Journal Entry in the double-entry accounting system.
/// Complies with IFRS IAS 1 requirements for financial statement presentation.
#[frb(sync)]
pub struct JournalEntry {
    /// Unique identifier (UUID v4)
    pub id: String,
    /// Transaction date in ISO 8601 format
    pub date: String,
    /// Narrative description of the transaction
    pub description: String,
    /// List of debit and credit items
    pub items: Vec<JournalItem>,
}

/// Represents a single line item within a Journal Entry.
/// Ensures mathematical accuracy as required by ZATCA Phase 2 technical specifications.
#[frb(sync)]
pub struct JournalItem {
    /// Reference to the Chart of Accounts ID
    pub account_id: String,
    /// Debit amount (must be positive)
    pub debit: f64,
    /// Credit amount (must be positive)
    pub credit: f64,
}

/// Validates the fundamental accounting equation: Total Debits = Total Credits.
/// This is a mandatory check for CP-001 (Double-Entry Balance Enforcement).
#[frb(sync)]
pub fn validate_entry(entry: JournalEntry) -> bool {
    let total_debit: f64 = entry.items.iter().map(|item| item.debit).sum();
    let total_credit: f64 = entry.items.iter().map(|item| item.credit).sum();
    
    // Using a small epsilon for floating point comparison
    (total_debit - total_credit).abs() < 1e-10
}

/// Returns the current operational status of the accounting engine.
pub fn get_accounting_status() -> String {
    format!("Basir Accounting Engine: Operational. {}", greet("System".to_string()))
}
