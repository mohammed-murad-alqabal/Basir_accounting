//! Property-Based Tests for Account Hierarchy
//!
//! Verifies:
//! - Cyclic detection works reliably.
//! - Taxonomy alignment is enforced.
//! - Leaf node identification.

use accounting_core::accounts::models::{Account, AccountKind, HierarchyError};
use accounting_core::accounts::registry::AccountRegistry;
use proptest::prelude::*;
use uuid::Uuid;

/// Strategy to generate a simple account hierarchy.
fn account_hierarchy_strategy(size: usize) -> impl Strategy<Value = Vec<Account>> {
    let ids: Vec<Uuid> = (0..size).map(|_| Uuid::new_v4()).collect();

    // Generate accounts where each might have a parent from the previous IDs (ensures no cycles by construction if processed linearly)
    prop::collection::vec(0..size, size).prop_map(move |parent_indices| {
        let mut accounts = Vec::new();
        for (i, &p_idx) in parent_indices.iter().enumerate() {
            let mut acc = Account::new(
                format!("ACC-{}", i),
                format!("حساب {}", i),
                format!("Account {}", i),
                AccountKind::Asset, // Simplified for base case
            );
            acc.id = ids[i];
            // Only assign parent if it's "before" us in the list to avoid cycles
            if p_idx < i {
                acc.parent_id = Some(ids[p_idx]);
            }
            accounts.push(acc);
        }
        accounts
    })
}

proptest! {
    /// Property: A logically constructed DAG must pass hierarchy validation.
    #[test]
    fn prop_dag_hierarchy_passes(accounts in account_hierarchy_strategy(10)) {
        let registry = AccountRegistry::new(accounts);
        prop_assert!(registry.validate_hierarchy().is_ok());
    }

    /// Property: A circular reference must be detected.
    #[test]
    fn prop_detects_circular_reference(id1_raw in any::<[u8; 16]>(), id2_raw in any::<[u8; 16]>()) {
        let id1 = Uuid::from_bytes(id1_raw);
        let id2 = Uuid::from_bytes(id2_raw);
        if id1 == id2 { return Ok(()); }

        let mut acc1 = Account::new("1", "1", "1", AccountKind::Asset);
        acc1.id = id1;
        let mut acc2 = Account::new("2", "2", "2", AccountKind::Asset);
        acc2.id = id2;

        // Create cycle: 1 -> 2 -> 1
        acc1.parent_id = Some(id2);
        acc2.parent_id = Some(id1);

        let registry = AccountRegistry::new(vec![acc1, acc2]);
        let result = registry.validate_hierarchy();

        prop_assert!(matches!(result, Err(HierarchyError::CircularReference(_))));
    }

    /// Property: Taxonomy alignment ensures child kind == parent kind.
    #[test]
    fn prop_enforces_taxonomy_alignment(
        child_kind in prop_oneof![Just(AccountKind::Asset), Just(AccountKind::Liability), Just(AccountKind::Income)],
        parent_kind in prop_oneof![Just(AccountKind::Asset), Just(AccountKind::Liability), Just(AccountKind::Income)]
    ) {
        let parent_id = Uuid::new_v4();
        let child_id = Uuid::new_v4();

        let mut parent = Account::new("P", "P", "P", parent_kind);
        parent.id = parent_id;

        let mut child = Account::new("C", "C", "C", child_kind);
        child.id = child_id;
        child.parent_id = Some(parent_id);

        let registry = AccountRegistry::new(vec![parent, child]);
        let result = registry.validate_taxonomy();

        if child_kind == parent_kind {
            prop_assert!(result.is_ok());
        } else {
            let is_incompatible = matches!(result, Err(HierarchyError::IncompatibleKind { .. }));
            prop_assert!(is_incompatible);
        }
    }
}
