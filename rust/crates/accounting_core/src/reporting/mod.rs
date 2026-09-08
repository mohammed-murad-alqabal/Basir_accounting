//! Reporting Module
//!
//! Implements financial reporting functionality for the accounting engine.
//!
//! # Design Reference
//! - `tasks.md` Phase 1.5: Basic Reporting
//!
//! # Key Features
//! - Trial Balance generation (Task 16)
//! - Account balance calculation with period filtering
//! - Drill-down capability to source entries

pub mod generator;
pub mod models;
pub mod query;
pub mod trial_balance;
pub mod zakah;

pub use generator::{ComparativeBalance, FinancialReportGenerator};
pub use models::{
    AccountBalance, FinancialReport, FinancialReportLine, TrialBalance, TrialBalanceLine,
};
pub use query::{BalanceQuery, EntryQuery};
pub use trial_balance::generate_trial_balance;
