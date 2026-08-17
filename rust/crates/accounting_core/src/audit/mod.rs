//! Audit Trail Module
//!
//! Implements the immutable, tamper-evident audit trail.
//!
//! # Design Reference
//! - `design.md` Section 3.5: Audit Trail Component
//! - `design.md` Section 5.3: Audit Trail Model
//!
//! # Correctness Properties
//! - CP-003: Audit Trail Immutability
//! - CP-009: Traceability Completeness
//!
//! # Key Features
//! - 5W+H recording for all changes
//! - SHA-256 hash chain for tamper detection
//! - Append-only structure

pub mod chain;
pub mod models;
pub mod service;
