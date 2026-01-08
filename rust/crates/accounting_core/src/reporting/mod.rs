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

pub mod models;
pub mod trial_balance;
pub mod query;
pub mod generator;
pub mod zakah;

pub use models::{AccountBalance, TrialBalance, TrialBalanceLine, FinancialReport, FinancialReportLine};
pub use trial_balance::generate_trial_balance;
pub use query::{EntryQuery, BalanceQuery};
pub use generator::{FinancialReportGenerator, ComparativeBalance};
