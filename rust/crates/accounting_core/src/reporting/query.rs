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

impl EntryQuery {
    /// Check if a journal entry matches the query criteria.
    ///
    /// Task 17.1: Implement journal entry query
    pub fn matches(&self, entry: &crate::ledger::models::JournalEntry) -> bool {
        // Filter by entry ID
        if let Some(qid) = self.entry_id {
            if entry.entry_id != qid {
                return false;
            }
        }

        // Filter by date range
        let entry_date = entry.temporal.effective_date;
        if let Some(start) = self.start_date {
            if entry_date < start {
                return false;
            }
        }
        if let Some(end) = self.end_date {
            if entry_date > end {
                return false;
            }
        }

        // Filter by status
        if let Some(status) = self.status {
            if entry.status != status {
                return false;
            }
        }

        // Filter by standards reference
        if let Some(std_ref) = &self.standard_reference {
            if &entry.standards.standard_reference != std_ref {
                return false;
            }
        }

        // Filter by account ID (checks if any line uses the account)
        if let Some(acc_id) = self.account_id {
            if !entry.lines.iter().any(|l| l.account_id == acc_id) {
                return false;
            }
        }

        true
    }

    /// Apply the query to a slice of entries with pagination support.
    pub fn apply<'a>(
        &self,
        entries: &'a [crate::ledger::models::JournalEntry],
    ) -> Vec<&'a crate::ledger::models::JournalEntry> {
        let filtered: Vec<_> = entries.iter().filter(|e| self.matches(e)).collect();

        let start = self.page.unwrap_or(0) * self.page_size.unwrap_or(filtered.len());
        let end = (start + self.page_size.unwrap_or(filtered.len())).min(filtered.len());

        if start >= filtered.len() {
            vec![]
        } else {
            filtered[start..end].to_vec()
        }
    }
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

impl BalanceQuery {
    /// Filter a set of account balances based on the query.
    pub fn apply(
        &self,
        balances: &[super::models::AccountBalance],
    ) -> Vec<super::models::AccountBalance> {
        balances
            .iter()
            .filter(|b| {
                if let Some(acc_id) = self.account_id {
                    if b.account_id != acc_id {
                        return false;
                    }
                }
                true
            })
            .cloned()
            .collect()
    }
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
