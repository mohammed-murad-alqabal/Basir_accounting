//! Accounting Core Library
//!
//! The heart of the Basir Accounting Engine.
//!
//! This crate contains all core accounting logic, completely independent
//! of any UI or storage concerns. It implements the "Pure Logic" layer
//! as defined in the specification.
//!
//! # Modules
//!
//! - `standards`: Standards Registry and validation (IFRS/IAS/AAOIFI)
//! - `ledger`: Journal entries and double-entry validation
//! - `audit`: Audit trail with hash chain integrity
//!
//! # Correctness Properties
//! - CP-001: Double-Entry Balance Enforcement
//! - CP-002: Standards Reference Completeness
//! - CP-003: Audit Trail Immutability
//! - CP-008: Temporal Justification Completeness

pub mod accounts;
pub mod assets;
pub mod audit;
pub mod calendar;
pub mod currency;
pub mod inventory;
pub mod ledger;
pub mod partners;
pub mod purchasing;
pub mod reporting;
pub mod sales;
pub mod standards;

// Re-export commonly used types
pub use assets::models::{FixedAsset, DepreciationMethod, AssetCategory, AssetError};
pub use accounts::models::{Account, AccountKind};
pub use accounts::registry::AccountRegistry;
pub use inventory::models::{InventoryItem, StockMovement, ValuationMethod, MovementType};
pub use partners::{Partner, PartnerType};
pub use purchasing::models::{PurchaseBill, BillStatus, BillPayment};
pub use standards::models::{StandardBody, StandardEntry, StandardReference, RecognitionBasis, MeasurementBasis};
pub use standards::registry::StandardsRegistry;
pub use standards::validator::{validate_complete, validate_format, ValidationError};
pub use standards::recognition::{Ifrs15StepModel, Ifrs15Helper};

pub use ledger::models::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine,
    StandardsJustification, TemporalJustification,
};
pub use ledger::validation::{
    validate_balance, validate_for_posting, EntryValidationError,
};

pub use ledger::closing::ClosingEntryGenerator;
pub use audit::chain::{compute_hash, verify_chain, GENESIS_HASH};
pub use audit::models::{AuditAction, AuditRecord};
