use accounting_core::accounts::models::{Account, AccountKind};
use accounting_core::reporting::zakah::{ZakahBase, ZakahCalculator, ZakahCalendarType};
use proptest::prelude::*;
use rust_decimal::Decimal;

proptest! {
    #[test]
    fn test_zakah_mathematical_invariants(
        asset_val in 0..1_000_000i64,
        liab_val in 0..1_000_000i64,
    ) {
        let asset_dec = Decimal::from(asset_val);
        let liab_dec = Decimal::from(liab_val);

        let cash = Account::new("1000", "النقدية", "Cash", AccountKind::Asset);
        let debt = Account::new("2000", "الديون", "Debt", AccountKind::Liability);

        let base = ZakahBase {
            zakatable_assets: vec![(cash, asset_dec)],
            deductible_liabilities: vec![(debt, liab_dec)],
        };

        let net = base.net_zakatable_assets();
        let zakah_h = ZakahCalculator::calculate(&base, ZakahCalendarType::Hijri);
        let zakah_g = ZakahCalculator::calculate(&base, ZakahCalendarType::Gregorian);

        if net <= Decimal::ZERO {
            prop_assert_eq!(zakah_h, Decimal::ZERO);
            prop_assert_eq!(zakah_g, Decimal::ZERO);
        } else {


            prop_assert!(zakah_g > Decimal::ZERO);
            // Gregorian rate (2.5775%) is higher than Hijri rate (2.5%)
            prop_assert!(zakah_g > zakah_h);

            // Proportionality check
            let expected_h = (net * Decimal::from_str_radix("0.025", 10).unwrap()).round_dp(2);
            prop_assert_eq!(zakah_h, expected_h);
        }
    }
}
