//! Reporting Data Models
//!
//! Derived from `tasks.md` Task 16: Trial Balance
//!
//! # Requirements Alignment
//! - Req 8.5: Trial Balance Generation
//! - Req 8.8: Drill-down Capability

use chrono::NaiveDate;
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::accounts::models::AccountKind;

/// Balance for a single account over a period.
///
/// Represents the complete accounting equation:
/// Opening Balance + Debit Movements - Credit Movements = Closing Balance (for Debit-normal accounts)
/// Opening Balance - Debit Movements + Credit Movements = Closing Balance (for Credit-normal accounts)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AccountBalance {
    /// Account identifier
    pub account_id: Uuid,
    /// Account code for display
    pub account_code: String,
    /// Account name
    pub account_name: String,
    /// Account type (for normal balance determination)
    pub account_kind: AccountKind,
    /// Balance at the start of the period
    pub opening_balance: Decimal,
    /// Total debits during the period
    pub debit_movements: Decimal,
    /// Total credits during the period
    pub credit_movements: Decimal,
    /// Net balance at end of period
    pub closing_balance: Decimal,
}

impl AccountBalance {
    /// Calculate closing balance based on account kind.
    ///
    /// For Debit-normal accounts (Assets, Expenses):
    ///   Closing = Opening + Debits - Credits
    ///
    /// For Credit-normal accounts (Liabilities, Equity, Income):
    ///   Closing = Opening - Debits + Credits
    pub fn calculate_closing(&self) -> Decimal {
        if self.account_kind.is_debit_normal() {
            self.opening_balance + self.debit_movements - self.credit_movements
        } else {
            self.opening_balance - self.debit_movements + self.credit_movements
        }
    }
}

/// A single line in the Trial Balance report.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TrialBalanceLine {
    /// Account identifier
    pub account_id: Uuid,
    /// Account code
    pub account_code: String,
    /// Account name
    pub account_name: String,
    /// Debit balance (if debit-normal and positive net)
    pub debit_balance: Decimal,
    /// Credit balance (if credit-normal and positive net)
    pub credit_balance: Decimal,
}

/// Complete Trial Balance report.
///
/// The fundamental verification that Σ(Debits) = Σ(Credits)
/// across the entire Chart of Accounts.
///
/// # Correctness Property
/// A valid Trial Balance MUST satisfy: total_debits == total_credits
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TrialBalance {
    /// Report generation timestamp
    pub as_of_date: NaiveDate,
    /// Period start (for movement calculation)
    pub period_start: Option<NaiveDate>,
    /// Period end
    pub period_end: NaiveDate,
    /// All account lines
    pub lines: Vec<TrialBalanceLine>,
    /// Sum of all debit balances
    pub total_debits: Decimal,
    /// Sum of all credit balances
    pub total_credits: Decimal,
    /// Whether the trial balance is in balance
    pub is_balanced: bool,
}

impl TrialBalance {
    /// Verify the fundamental accounting equation.
    pub fn verify_balance(&self) -> bool {
        self.total_debits == self.total_credits
    }

    /// Get the difference (should be zero for a balanced TB).
    pub fn imbalance(&self) -> Decimal {
        self.total_debits - self.total_credits
    }
}

/// A single line in a financial report (Income Statement, Balance Sheet)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FinancialReportLine {
    pub label: String,
    pub amount: Decimal,
    pub is_title: bool,
    pub is_total: bool,
    pub indent_level: i32,
}

/// Generic financial report
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FinancialReport {
    pub title: String,
    pub from_date: NaiveDate,
    pub to_date: NaiveDate,
    pub lines: Vec<FinancialReportLine>,
    pub generated_at: NaiveDate,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_account_balance_debit_normal() {
        let balance = AccountBalance {
            account_id: Uuid::new_v4(),
            account_code: "1000".to_string(),
            account_name: "Cash".to_string(),
            account_kind: AccountKind::Asset,
            opening_balance: Decimal::from(1000),
            debit_movements: Decimal::from(500),
            credit_movements: Decimal::from(200),
            closing_balance: Decimal::ZERO, // Will calculate
        };
        
        // Assets are debit-normal: 1000 + 500 - 200 = 1300
        assert_eq!(balance.calculate_closing(), Decimal::from(1300));
    }

    #[test]
    fn test_account_balance_credit_normal() {
        let balance = AccountBalance {
            account_id: Uuid::new_v4(),
            account_code: "2000".to_string(),
            account_name: "Payables".to_string(),
            account_kind: AccountKind::Liability,
            opening_balance: Decimal::from(1000),
            debit_movements: Decimal::from(200),
            credit_movements: Decimal::from(500),
            closing_balance: Decimal::ZERO,
        };
        
        // Liabilities are credit-normal: 1000 - 200 + 500 = 1300
        assert_eq!(balance.calculate_closing(), Decimal::from(1300));
    }

    #[test]
    fn test_trial_balance_verification() {
        let tb = TrialBalance {
            as_of_date: NaiveDate::from_ymd_opt(2026, 1, 3).unwrap(),
            period_start: None,
            period_end: NaiveDate::from_ymd_opt(2026, 1, 3).unwrap(),
            lines: vec![],
            total_debits: Decimal::from(10000),
            total_credits: Decimal::from(10000),
            is_balanced: true,
        };

        assert!(tb.verify_balance());
        assert_eq!(tb.imbalance(), Decimal::ZERO);
    }

    #[test]
    fn test_trial_balance_imbalance_detection() {
        let tb = TrialBalance {
            as_of_date: NaiveDate::from_ymd_opt(2026, 1, 3).unwrap(),
            period_start: None,
            period_end: NaiveDate::from_ymd_opt(2026, 1, 3).unwrap(),
            lines: vec![],
            total_debits: Decimal::from(10000),
            total_credits: Decimal::from(9999),
            is_balanced: false,
        };

        assert!(!tb.verify_balance());
        assert_eq!(tb.imbalance(), Decimal::from(1));
    }
}
