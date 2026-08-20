# Rust baseline test evidence

The full run was executed with the current stable Rust toolchain using `cargo test --workspace`.

Result: all in-memory unit and property tests shown in the run passed, but the workspace command exited non-zero because `crates/accounting_data/tests/db_integration.rs::test_persistence_flow` requires `DATABASE_URL`, which is not configured in the audit environment.

The complete raw output is preserved in `audit/rust_baseline_full_output.txt`.
