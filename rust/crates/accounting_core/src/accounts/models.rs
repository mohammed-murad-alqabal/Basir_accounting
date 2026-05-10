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

    /// Returns true if this kind is compatible with a parent kind.
    /// In IFRS, a child account must be of the same element kind as its parent.
    pub fn is_compatible_with(&self, parent_kind: &AccountKind) -> bool {
        self == parent_kind
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

/// IFRS 18 Categories for the Statement of Profit or Loss.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize, Default)]
pub enum Ifrs18Category {
    /// Items that are not classified in other categories
    #[default]
    Operating,
    /// Income and expenses from assets that generate a return individually and largely independently
    Investing,
    /// Income and expenses from liabilities that arise from transactions that involve only the raising of finance
    Financing,
    /// Income tax as defined in IAS 12
    IncomeTax,
    /// Discontinued operations as defined in IFRS 5
    Discontinued,
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
    /// IFRS 18 Category (for Profit or Loss classification)
    pub ifrs18_category: Ifrs18Category,
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
    /// Is this a monetary item? (IAS 21)
    /// Monetary items are units of currency held and assets and liabilities to be received or paid in a fixed or determinable number of units of currency.
    pub is_monetary: bool,
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
            ifrs18_category: Ifrs18Category::Operating,
            parent_id: None,
            ifrs_tag: None,
            currency: None,
            description: None,
            requires_partner: false,
            is_monetary: false,
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

/// Errors related to account hierarchy and taxonomy.
#[derive(Debug, thiserror::Error)]
pub enum HierarchyError {
    #[error("Circular reference detected for account {0}")]
    CircularReference(Uuid),
    #[error("Parent account {0} not found")]
    ParentNotFound(Uuid),
    #[error("Account {child} kind {child_kind:?} is incompatible with parent {parent} kind {parent_kind:?}")]
    IncompatibleKind {
        child: Uuid,
        child_kind: AccountKind,
        parent: Uuid,
        parent_kind: AccountKind,
    },
    #[error("Cannot post to account {0} because it has children (not a leaf node)")]
    NotALeafNode(Uuid),
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
