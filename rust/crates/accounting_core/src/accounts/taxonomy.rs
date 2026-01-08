//! IFRS Taxonomy Validation
//!
//! Implements Task 4.3: IFRS Taxonomy Validation
//! and Task 4.4: Account Code Management
//!
//! # Design Reference
//! - Req 3.2: IFRS Alignment
//! - Req 3.5: Account taxonomy mapping
//! - Req 3.6: Unique account codes

use std::collections::HashSet;
use thiserror::Error;

use super::models::{Account, AccountKind};

#[derive(Debug, Error)]
pub enum TaxonomyError {
    #[error("Invalid IFRS tag format: {0}. Expected format: 'prefix:ElementName'")]
    InvalidFormat(String),

    #[error("Account kind '{0:?}' does not match IFRS tag '{1}' which belongs to '{2}'")]
    KindMismatch(AccountKind, String, String),

    #[error("Unknown IFRS taxonomy prefix: {0}")]
    UnknownPrefix(String),
}

#[derive(Debug, Error)]
pub enum AccountCodeError {
    #[error("Duplicate account code: {0}")]
    DuplicateCode(String),

    #[error("Invalid account code format: {0}. Must be numeric.")]
    InvalidFormat(String),

    #[error("Account code '{0}' does not match kind '{1:?}'. Expected range: {2}")]
    KindRangeMismatch(String, AccountKind, String),
}

/// Known IFRS-full taxonomy elements mapped to AccountKind.
/// This is a simplified mapping for MVP - in production, this would load from XBRL taxonomy.
const ASSET_TAGS: &[&str] = &[
    "ifrs-full:Cash",
    "ifrs-full:CashAndCashEquivalents",
    "ifrs-full:TradeReceivables",
    "ifrs-full:Inventories",
    "ifrs-full:PropertyPlantAndEquipment",
    "ifrs-full:IntangibleAssets",
    "ifrs-full:InvestmentProperty",
    "ifrs-full:BiologicalAssets",
    "ifrs-full:NoncurrentAssets",
    "ifrs-full:CurrentAssets",
];

const LIABILITY_TAGS: &[&str] = &[
    "ifrs-full:TradePayables",
    "ifrs-full:BorrowingsNoncurrent",
    "ifrs-full:BorrowingsCurrent",
    "ifrs-full:Provisions",
    "ifrs-full:DeferredTaxLiabilities",
    "ifrs-full:NoncurrentLiabilities",
    "ifrs-full:CurrentLiabilities",
];

const EQUITY_TAGS: &[&str] = &[
    "ifrs-full:IssuedCapital",
    "ifrs-full:SharePremium",
    "ifrs-full:RetainedEarnings",
    "ifrs-full:TreasuryShares",
    "ifrs-full:OtherReserves",
    "ifrs-full:EquityAttributableToOwnersOfParent",
];

const INCOME_TAGS: &[&str] = &[
    "ifrs-full:Revenue",
    "ifrs-full:OtherIncome",
    "ifrs-full:InterestIncome",
    "ifrs-full:GainsArising",
];

const EXPENSE_TAGS: &[&str] = &[
    "ifrs-full:CostOfSales",
    "ifrs-full:DistributionCosts",
    "ifrs-full:AdministrativeExpenses",
    "ifrs-full:FinanceCosts",
    "ifrs-full:IncomeTaxExpense",
    "ifrs-full:DepreciationExpense",
];

/// Validate a tag follows the "prefix:ElementName" pattern.
pub fn validate_tag_format(tag: &str) -> Result<(), TaxonomyError> {
    if !tag.contains(':') {
        return Err(TaxonomyError::InvalidFormat(tag.to_string()));
    }

    let parts: Vec<&str> = tag.splitn(2, ':').collect();
    if parts.len() != 2 || parts[0].is_empty() || parts[1].is_empty() {
        return Err(TaxonomyError::InvalidFormat(tag.to_string()));
    }

    // Check known prefixes
    let known_prefixes = ["ifrs-full", "ifrs-smes", "custom"];
    if !known_prefixes.contains(&parts[0]) {
        return Err(TaxonomyError::UnknownPrefix(parts[0].to_string()));
    }

    Ok(())
}

/// Validate that an IFRS tag matches the account kind.
///
/// Task 4.3: Implement IFRS Taxonomy Validation
pub fn validate_tag_kind(tag: &str, kind: AccountKind) -> Result<(), TaxonomyError> {
    // First validate format
    validate_tag_format(tag)?;

    // Allow custom tags without validation
    if tag.starts_with("custom:") {
        return Ok(());
    }

    // Determine expected kind from tag
    let expected_kind = if ASSET_TAGS.contains(&tag) {
        Some(AccountKind::Asset)
    } else if LIABILITY_TAGS.contains(&tag) {
        Some(AccountKind::Liability)
    } else if EQUITY_TAGS.contains(&tag) {
        Some(AccountKind::Equity)
    } else if INCOME_TAGS.contains(&tag) {
        Some(AccountKind::Income)
    } else if EXPENSE_TAGS.contains(&tag) {
        Some(AccountKind::Expense)
    } else {
        None // Unknown tag, allow for extensibility
    };

    if let Some(expected) = expected_kind {
        if expected != kind {
            return Err(TaxonomyError::KindMismatch(
                kind,
                tag.to_string(),
                format!("{:?}", expected),
            ));
        }
    }

    Ok(())
}

/// Validate an account's IFRS tag if present.
pub fn validate_account_taxonomy(account: &Account) -> Result<(), TaxonomyError> {
    if let Some(ref tag) = account.ifrs_tag {
        validate_tag_kind(tag, account.kind)?;
    }
    Ok(())
}

/// Account code range conventions (IAS 1.54-80A aligned):
/// - 1000-1999: Assets
/// - 2000-2999: Liabilities
/// - 3000-3999: Equity
/// - 4000-4999: Income
/// - 5000-5999: Expenses
fn expected_code_range(kind: AccountKind) -> (u32, u32) {
    match kind {
        AccountKind::Asset => (1000, 1999),
        AccountKind::Liability => (2000, 2999),
        AccountKind::Equity => (3000, 3999),
        AccountKind::Income => (4000, 4999),
        AccountKind::Expense => (5000, 5999),
    }
}

/// Validate account code format and range.
///
/// Task 4.4: Implement Account Code Management
pub fn validate_account_code(code: &str, kind: AccountKind) -> Result<(), AccountCodeError> {
    // Parse as number
    let code_num: u32 = code
        .parse()
        .map_err(|_| AccountCodeError::InvalidFormat(code.to_string()))?;

    // Check range
    let (min, max) = expected_code_range(kind);
    if code_num < min || code_num > max {
        return Err(AccountCodeError::KindRangeMismatch(
            code.to_string(),
            kind,
            format!("{}-{}", min, max),
        ));
    }

    Ok(())
}

/// Check for duplicate account codes in a set of accounts.
pub fn check_duplicate_codes(accounts: &[Account]) -> Result<(), AccountCodeError> {
    let mut seen = HashSet::new();
    for account in accounts {
        if !seen.insert(account.code.clone()) {
            return Err(AccountCodeError::DuplicateCode(account.code.clone()));
        }
    }
    Ok(())
}

/// Validate an account's code against its kind.
pub fn validate_account_code_assignment(account: &Account) -> Result<(), AccountCodeError> {
    validate_account_code(&account.code, account.kind)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_validate_tag_format_valid() {
        assert!(validate_tag_format("ifrs-full:Cash").is_ok());
        assert!(validate_tag_format("ifrs-smes:Revenue").is_ok());
        assert!(validate_tag_format("custom:MyAccount").is_ok());
    }

    #[test]
    fn test_validate_tag_format_invalid() {
        assert!(validate_tag_format("Cash").is_err());
        assert!(validate_tag_format(":Cash").is_err());
        assert!(validate_tag_format("prefix:").is_err());
    }

    #[test]
    fn test_validate_tag_kind_match() {
        assert!(validate_tag_kind("ifrs-full:Cash", AccountKind::Asset).is_ok());
        assert!(validate_tag_kind("ifrs-full:TradePayables", AccountKind::Liability).is_ok());
        assert!(validate_tag_kind("ifrs-full:Revenue", AccountKind::Income).is_ok());
    }

    #[test]
    fn test_validate_tag_kind_mismatch() {
        let result = validate_tag_kind("ifrs-full:Cash", AccountKind::Liability);
        assert!(matches!(result, Err(TaxonomyError::KindMismatch(_, _, _))));
    }

    #[test]
    fn test_validate_account_code_valid() {
        assert!(validate_account_code("1000", AccountKind::Asset).is_ok());
        assert!(validate_account_code("2500", AccountKind::Liability).is_ok());
        assert!(validate_account_code("3100", AccountKind::Equity).is_ok());
        assert!(validate_account_code("4000", AccountKind::Income).is_ok());
        assert!(validate_account_code("5500", AccountKind::Expense).is_ok());
    }

    #[test]
    fn test_validate_account_code_range_mismatch() {
        let result = validate_account_code("1000", AccountKind::Liability);
        assert!(matches!(
            result,
            Err(AccountCodeError::KindRangeMismatch(_, _, _))
        ));
    }

    #[test]
    fn test_duplicate_code_detection() {
        let accounts = vec![
            Account::new("1000", "النقد", "Cash", AccountKind::Asset),
            Account::new("1000", "نقد 2", "Cash 2", AccountKind::Asset), // Duplicate
        ];

        let result = check_duplicate_codes(&accounts);
        assert!(matches!(result, Err(AccountCodeError::DuplicateCode(_))));
    }
}
