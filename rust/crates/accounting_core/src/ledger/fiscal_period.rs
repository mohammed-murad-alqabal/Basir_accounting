//! Fiscal Period Management
//!
//! Implements logic for managing accounting periods and enforcing locks.

use chrono::NaiveDate;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

/// Status of a fiscal period.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum PeriodStatus {
    /// Period is open for normal posting.
    Open,
    /// Period is closed (year-end entries in progress).
    Closed,
    /// Period is locked (no further modifications allowed).
    Locked,
}

/// Represents a fiscal period (e.g., a fiscal year or month).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FiscalPeriod {
    pub id: Uuid,
    pub name: String,
    pub start_date: NaiveDate,
    pub end_date: NaiveDate,
    pub status: PeriodStatus,
}

impl FiscalPeriod {
    /// Create a new open fiscal period.
    pub fn new(name: &str, start_date: NaiveDate, end_date: NaiveDate) -> Self {
        Self {
            id: Uuid::new_v4(),
            name: name.to_string(),
            start_date,
            end_date,
            status: PeriodStatus::Open,
        }
    }

    /// Check if a date falls within this period.
    pub fn contains(&self, date: NaiveDate) -> bool {
        date >= self.start_date && date <= self.end_date
    }

    /// Check if posting to this period is allowed.
    pub fn can_post(&self) -> bool {
        self.status == PeriodStatus::Open
    }
}

/// Error returned when attempting to post to an invalid period.
#[derive(Debug, thiserror::Error)]
pub enum PeriodError {
    #[error("Date {0} does not fall within any open fiscal period")]
    NoOpenPeriodFound(NaiveDate),
    #[error("Fiscal period {0} is {1:?}")]
    PeriodNotOpen(String, PeriodStatus),
    #[error("Cannot close period: {0}")]
    ClosingCheckFailed(String),
}

/// Checklist for closing a fiscal period.
/// Implements internal controls (SOX 404 / COSO).
#[derive(Debug, Clone, Default)]
pub struct PeriodClosingChecklist {
    /// No entries in Draft or PendingApproval status
    pub no_unposted_entries: bool,
    /// All sales invoices are finalized or cancelled
    pub no_draft_invoices: bool,
    /// All purchase bills are finalized or cancelled
    pub no_draft_bills: bool,
    /// Bank reconciliation is complete
    pub bank_reconciliation_done: bool,
    /// Inventory valuation is updated
    pub inventory_valuation_done: bool,
}

impl PeriodClosingChecklist {
    pub fn is_ready_to_close(&self) -> Result<(), String> {
        if !self.no_unposted_entries {
            return Err("There are unposted journal entries".to_string());
        }
        if !self.no_draft_invoices {
            return Err("There are draft sales invoices".to_string());
        }
        if !self.no_draft_bills {
            return Err("There are draft purchase bills".to_string());
        }
        Ok(())
    }
}
