//! Double-Entry Ledger Module
//!
//! The core of the accounting engine - enforces double-entry balance,
//! temporal justification, and standards justification.
//!
//! # Design Reference
//! - `design.md` Section 3.3: Double-Entry Ledger Component
//! - `tasks.md` Phase 1.3: Double-Entry Ledger Engine
//!
//! # Correctness Properties
//! - CP-001: Double-Entry Balance Enforcement
//! - CP-008: Temporal Justification Completeness
//!
//! # Core Rules (from spec)
//! - Balance Enforcement: Σ(Debits) = Σ(Credits) for every entry
//! - Immutability: No modification or deletion of posted entries
//! - Temporal Justification: 3 dates required (transaction, effective, recording)
//! - Standards Justification: Standard.Paragraph reference required

pub mod chain;
pub mod closing;
pub mod fiscal_period;
pub mod models;
pub mod service;
pub mod validation;
