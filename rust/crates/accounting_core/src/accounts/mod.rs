//! Chart of Accounts Module
//!
//! Manages the structure and hierarchy of financial accounts.
//!
//! # Design Reference
//! - `design.md` Section 3.4: Chart of Accounts Component
//! - `tasks.md` Phase 1.2: Chart of Accounts & Hierarchy
//!
//! # Correctness Properties
//! - CP-006: Chart of Accounts Validation (Hierarchy, Taxonomy, No Cycles)
//!
//! # Key Features
//! - IFRS-aligned account categorization (Asset, Liability, Equity, Income, Expense)
//! - Hierarchical structure (Parent-Child)
//! - Currency configuration per account
//! - IFRS Taxonomy mapping

pub mod models;
pub mod hierarchy;
pub mod taxonomy;
pub mod defaults;
pub mod registry;

pub use registry::AccountRegistry;
