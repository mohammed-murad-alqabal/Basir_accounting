//! Standards Registry Module
//!
//! Central repository linking all accounting treatments to authoritative
//! standards. Implements Requirements 1.6, 2.3, 4.4 from the specification.
//!
//! # Design Reference
//! - `design.md` Section 3.1: Standards Registry Component
//! - `tasks.md` Phase 1.1: Standards Registry Foundation
//!
//! # Capabilities
//! - Store complete IFRS/IAS standards with paragraph-level granularity
//! - Map accounting treatments to specific standard references
//! - Support US GAAP/UK GAAP as compatibility layers
//! - Track standards effective dates and transitions
//! - Provide validation rules derived from standards

pub mod data;
pub mod models;
pub mod recognition;
pub mod registry;
pub mod validator;
