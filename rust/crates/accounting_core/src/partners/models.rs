//! Partner Data Models
//!
//! Defines the entities for subsidiary ledgers (AR/AP).

use serde::{Deserialize, Serialize};
use uuid::Uuid;

/// Type of partner in a subsidiary ledger.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum PartnerType {
    /// Customer (Accounts Receivable)
    Customer,
    /// Vendor (Accounts Payable)
    Vendor,
    /// Employee (Payroll/Reimbursement)
    Employee,
    /// Other partner types
    Other,
}

/// A Partner definition for subsidiary ledgers.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Partner {
    /// Unique identifier
    pub id: Uuid,
    /// Partner name (Arabic)
    pub name_ar: String,
    /// Partner name (English)
    pub name_en: String,
    /// Partner unique code
    pub code: String,
    /// Detailed classification
    pub kind: PartnerType,
    /// Tax registration number
    pub tax_id: Option<String>,
}

impl Partner {
    pub fn new(
        code: impl Into<String>,
        name_ar: impl Into<String>,
        name_en: impl Into<String>,
        kind: PartnerType,
    ) -> Self {
        Self {
            id: Uuid::new_v4(),
            code: code.into(),
            name_ar: name_ar.into(),
            name_en: name_en.into(),
            kind,
            tax_id: None,
        }
    }
}
