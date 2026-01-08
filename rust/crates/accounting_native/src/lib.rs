//! Native Compatibility Layer
//!
//! Bridges the "Pure Logic" `accounting_core` with the Flutter application
//! using `flutter_rust_bridge`.
//!
//! # Modules
//! - `api`: Public API surface callable from Dart

pub mod api;
mod frb_generated;
