use accounting_core::standards::{registry::StandardsRegistry, validator::validate_complete};
use proptest::prelude::*;

// Generates valid-looking standard references
prop_compose! {
    fn arb_valid_format_ref()(
        body in prop::sample::select(&["IFRS", "IAS", "US GAAP", "AAOIFI"]),
        num in 1..200u32,
        para in 1..200u32
    ) -> String {
        format!("{} {}.{}", body, num, para)
    }
}

// Generates known valid references from default set
prop_compose! {
    fn arb_existing_ref()(
        idx in 0..5usize
    ) -> String {
        match idx {
            0 => "IFRS 15.35",
            1 => "IAS 1.54",
            2 => "IAS 21.23",
            3 => "IFRS CF.4.3",
            _ => "IFRS 15.9",
        }.to_string()
    }
}

proptest! {
    // CP-002: Standards Traceability Invariant
    #[test]
    fn prop_cp_002_known_refs_always_valid(
        std_ref in arb_existing_ref()
    ) {
        let registry = StandardsRegistry::load_defaults();
        let result = validate_complete(&std_ref, &registry);

        // Invariant: Known references must always validate
        prop_assert!(result.is_ok());
    }

    #[test]
    fn prop_cp_002_invalid_formats_always_rejected(
        s in "[a-z]+ [0-9]+" // Lowercase body invalid, no paragraph
    ) {
        // Simple regex check: standard parser expects BODY NUMBER.PARAGRAPH
        // "ifrs 15" will fail
        let registry = StandardsRegistry::load_defaults();
        prop_assert!(validate_complete(&s, &registry).is_err());
    }
}
