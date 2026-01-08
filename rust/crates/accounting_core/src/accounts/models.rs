//! Account Data Models
//!
//! Derived from `design.md` Section 5: Data Models (implied) and CP-006.
//!
//! # Requirements Alignment
//! - Req 3.1: Configurable Chart of Accounts
//! - Req 3.2: IFRS Alignment
//! - Req 3.5: Multi-Currency Support

use serde::{Deserialize, Serialize};
use uuid::Uuid;

/// The 5 Major Account Kinds (IFRS Elements).
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum AccountKind {
    /// Economic resource controlled by the entity (Debit normal)
    Asset,
    /// Present obligation to transfer economic resources (Credit normal)
    Liability,
    /// Residual interest in assets after deducting liabilities (Credit normal)
    Equity,
    /// Increases in assets/decreases in liabilities -> increase in equity (Credit normal)
    Income,
    /// Decreases in assets/increases in liabilities -> decrease in equity (Debit normal)
    Expense,
}

impl AccountKind {
    /// Returns true if the normal balance is Debit.
    pub fn is_debit_normal(&self) -> bool {
        matches!(self, AccountKind::Asset | AccountKind::Expense)
    }

    /// Returns true if the normal balance is Credit.
    pub fn is_credit_normal(&self) -> bool {
        matches!(
            self,
            AccountKind::Liability | AccountKind::Equity | AccountKind::Income
        )
    }
}

/// Helper to classify accounts into current/non-current (Balance Sheet)
/// or operating/financing/investing (Cash Flow).
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub enum AccountClassification {
    Current,
    NonCurrent,
    Operating,
    Financing,
    Investing,
    IncomeTaxes,
    DiscontinuedOperations,
    ZakahAssets,      // AAOIFI FAS 9: Zakatable Assets
    ZakahLiabilities, // AAOIFI FAS 9: Deductible Liabilities
}

/// A generic Account definition.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Account {
    /// Unique identifier
    pub id: Uuid,
    /// Human-readable code (e.g., "1000", "1100")
    pub code: String,
    /// Account name (Arabic)
    pub name_ar: String,
    /// Account name (English)
    pub name_en: String,
    /// Major classification (Asset, Liability, etc.)
    pub kind: AccountKind,
    /// Detailed classification
    pub classification: Option<AccountClassification>,
    /// Parent account ID (for hierarchy)
    pub parent_id: Option<Uuid>,
    /// IFRS Taxonomy tag (e.g., "ifrs-full:CashAndCashEquivalents")
    pub ifrs_tag: Option<String>,
    /// Account currency (ISO 4217 code) - if specific restricted
    pub currency: Option<String>,
    /// Description/Notes
    pub description: Option<String>,
    /// Does this account require a partner_id in journal lines? (CP-010)
    pub requires_partner: bool,
    /// Is this a posting account? (Leaf node)
    pub is_active: bool,
}

impl Account {
    /// Create a new account.
    pub fn new(
        code: impl Into<String>,
        name_ar: impl Into<String>,
        name_en: impl Into<String>,
        kind: AccountKind,
    ) -> Self {
        Self {
            id: Uuid::new_v4(),
            code: code.into(),
            name_ar: name_ar.into(),
            name_en: name_en.into(),
            kind,
            classification: None,
            parent_id: None,
            ifrs_tag: None,
            currency: None,
            description: None,
            requires_partner: false,
            is_active: true,
        }
    }

    /// Set the parent account.
    pub fn with_parent(mut self, parent_id: Uuid) -> Self {
        self.parent_id = Some(parent_id);
        self
    }

    /// Set the IFRS tag.
    pub fn with_ifrs_tag(mut self, tag: impl Into<String>) -> Self {
        self.ifrs_tag = Some(tag.into());
        self
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_account_kind_normal_balances() {
        assert!(AccountKind::Asset.is_debit_normal());
        assert!(!AccountKind::Asset.is_credit_normal());

        assert!(AccountKind::Liability.is_credit_normal());
        assert!(!AccountKind::Liability.is_debit_normal());

        assert!(AccountKind::Equity.is_credit_normal());
        assert!(AccountKind::Income.is_credit_normal());
        assert!(AccountKind::Expense.is_debit_normal());
    }

    #[test]
    fn test_create_account() {
        let acc = Account::new("1000", "النقدية", "Cash", AccountKind::Asset);
        assert_eq!(acc.code, "1000");
        assert_eq!(acc.kind, AccountKind::Asset);
        assert!(acc.is_active);
    }
}
