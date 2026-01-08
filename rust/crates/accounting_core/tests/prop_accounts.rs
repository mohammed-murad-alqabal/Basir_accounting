use accounting_core::accounts::{
    hierarchy::HierarchyValidator,
    models::{Account, AccountKind},
};
use proptest::prelude::*;

// Generates an account with random code/name
prop_compose! {
    fn arb_account()(
        code in "[A-Z]{3}[0-9]{3}",
        name in "[a-zA-Z ]{5,20}",
        idx in 0..5usize
    ) -> Account {
        let kind = match idx {
            0 => AccountKind::Asset,
            1 => AccountKind::Liability,
            2 => AccountKind::Equity,
            3 => AccountKind::Income,
            _ => AccountKind::Expense,
        };
        Account::new(code, &name, &name, kind)
    }
}

proptest! {
    // CP-006: Hierarchy Integrity
    // "Cycles are strictly forbidden"
    #[test]
    fn prop_cp_006_simple_cycle_detection(
        mut a in arb_account(),
        mut b in arb_account()
    ) {
        // Construct a cycle: A -> B -> A
        a.parent_id = Some(b.id);
        b.parent_id = Some(a.id);

        let accounts = vec![a.clone(), b.clone()];
        let validator = HierarchyValidator::new(&accounts);

        // Invariant: Validation must fail for A (or B) due to cycle
        prop_assert!(validator.validate_account(&a).is_err());
    }

    // "Valid hierarchies must always pass"
    #[test]
    fn prop_cp_006_valid_tree_structure(
        root in arb_account(),
        mut child1 in arb_account(),
        mut child2 in arb_account()
    ) {
        // Construct valid tree: Root -> Child1 -> Child2
        child1.parent_id = Some(root.id);
        child2.parent_id = Some(child1.id);

        // Ensure same kind to avoid KindMismatch error
        child1.kind = root.kind;
        child2.kind = root.kind;

        // Ensure unique IDs (proptest *could* generate collisions but unlikely with UUIDv4,
        // strictly speaking we should force inequality but new() does random UUIDs)

        let accounts = vec![root.clone(), child1.clone(), child2.clone()];
        let validator = HierarchyValidator::new(&accounts);

        // Invariant: Leaves must be valid
        prop_assert!(validator.validate_account(&child2).is_ok());
    }
}
