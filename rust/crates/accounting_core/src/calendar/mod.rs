//! Financial Period and Calendar Models
//!
//! # Requirements Alignment
//! - Req 4.4: Period Management and Closing cycles

use serde::{Deserialize, Serialize};
use chrono::NaiveDate;
use uuid::Uuid;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum PeriodStatus {
    Open,
    Locked,
    Closed,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FinancialPeriod {
    pub id: Uuid,
    pub name: String,
    pub start_date: NaiveDate,
    pub end_date: NaiveDate,
    pub status: PeriodStatus,
    pub is_year_end: bool,
}

#[derive(Debug, thiserror::Error, Serialize, Deserialize)]
pub enum ClosingError {
    #[error("Period is already closed or locked")]
    InvalidStatus,
    #[error("Trial balance is unbalanced (Sum of debits {0} != Sum of credits {1})")]
    Unbalanced(String, String),
    #[error("There are unposted entries in this period")]
    UnpostedEntries,
}

impl FinancialPeriod {
    pub fn new(
        name: impl Into<String>,
        start: NaiveDate,
        end: NaiveDate,
    ) -> Self {
        Self {
            id: Uuid::new_v4(),
            name: name.into(),
            start_date: start,
            end_date: end,
            status: PeriodStatus::Open,
            is_year_end: false,
        }
    }

    pub fn is_date_within(&self, date: NaiveDate) -> bool {
        date >= self.start_date && date <= self.end_date
    }

    pub fn is_postable(&self) -> bool {
        self.status == PeriodStatus::Open
    }

    /// Validates if the period can be closed based on the trial balance.
    /// 
    /// Requirement: Total Debits must equal Total Credits.
    pub fn validate_for_closing(&self, total_debits: rust_decimal::Decimal, total_credits: rust_decimal::Decimal) -> Result<(), ClosingError> {
        if self.status != PeriodStatus::Open {
            return Err(ClosingError::InvalidStatus);
        }

        if total_debits != total_credits {
            return Err(ClosingError::Unbalanced(total_debits.to_string(), total_credits.to_string()));
        }

        Ok(())
    }

    /// Transitions the period to the closed state.
    pub fn close(&mut self) -> Result<(), ClosingError> {
        if self.status != PeriodStatus::Open {
            return Err(ClosingError::InvalidStatus);
        }
        self.status = PeriodStatus::Closed;
        Ok(())
    }
}
