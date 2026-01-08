//! Reporting Query Interfaces
//!
//! Defines the structures and interfaces for querying the accounting engine.
//!
//! # Task 17: Basic Query Interface
//!
//! # Requirements Alignment
//! - Req 8.8: Drill-down Capability
//! - Req 8.5: Account Balance Analysis

use chrono::NaiveDate;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

use crate::ledger::models::EntryStatus;

/// Criteria for querying journal entries.
///
/// Task 17.1: Implement journal entry query
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct EntryQuery {
    /// Filter by specific entry ID
    pub entry_id: Option<Uuid>,
    /// Filter by date range (start)
    pub start_date: Option<NaiveDate>,
    /// Filter by date range (end)
    pub end_date: Option<NaiveDate>,
    /// Filter by account involved
    pub account_id: Option<Uuid>,
    /// Filter by entry status
    pub status: Option<EntryStatus>,
    /// Filter by standards reference (exact match)
    pub standard_reference: Option<String>,
    /// Pagination: page number (0-based)
    pub page: Option<usize>,
    /// Pagination: page size
    pub page_size: Option<usize>,
}

/// Criteria for querying account balances.
///
/// Task 17.2: Implement account balance query
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct BalanceQuery {
    /// Filter by specific account
    pub account_id: Option<Uuid>,
    /// Balance as of specific date (snapshot)
    pub as_of_date: Option<NaiveDate>,
    /// Period start (for movement analysis)
    pub period_start: Option<NaiveDate>,
    /// Period end (for movement analysis)
    pub period_end: Option<NaiveDate>,
}

/// Result of an entry query.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EntryQueryResult {
    pub total_count: usize,
    pub page: usize,
    pub page_size: usize,
    // Note: Actual entries would be mapped in the data layer
    // This query structure is primarily for the API contract
}
