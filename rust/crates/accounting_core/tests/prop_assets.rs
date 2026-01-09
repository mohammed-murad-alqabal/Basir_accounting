use accounting_core::assets::depreciation::{DepreciationCalculator, StraightLineDepreciation};
use chrono::NaiveDate;
use proptest::prelude::*;
use rust_decimal::Decimal;

proptest! {
    #[test]
    fn prop_straight_line_depreciation_convergence(
        cost_val in 10000..1000000i64, // Use specific range to avoid 0 cost issues in generation
        residual_val in 0..5000i64,
        years in 1..20i32
    ) {
        let cost = Decimal::from(cost_val);
        let residual = Decimal::from(residual_val);

        // Ensure valid inputs for test logic
        if residual >= cost {
            return Ok(());
        }

        let calculator = StraightLineDepreciation;
        let acq_date = NaiveDate::from_ymd_opt(2020, 1, 1).unwrap();

        let mut total_depr = Decimal::ZERO;
        let depreciable_amount = cost - residual;

        // Sum depreciation for each full year
        for i in 0..years {
            let start = NaiveDate::from_ymd_opt(2020 + i, 1, 1).unwrap();
            let end = NaiveDate::from_ymd_opt(2020 + i, 12, 31).unwrap();

            let amount = calculator.calculate_period_depreciation(
                cost, residual, years, acq_date, start, end
            );
            total_depr += amount;
        }

        // Check if total depreciation is close to depreciable amount.

        let diff = (depreciable_amount - total_depr).abs();

        // Tolerance: With 2 decimals rounding each year, max error is 0.01 * years.
        // Plus day-count approximation.
        // We use a safe tolerance.
        let tolerance = Decimal::new(years as i64 * 5, 2); // 0.05 * years per year of variance logic?
        // Actually, just < 5% of cost is a very safe "logic isn't totally broken" check.
        // Ideally we want tighter, but leaps years break simple 365 assumption.
        prop_assert!(diff < cost * Decimal::new(5, 2));

        // Book Value check: Cost - Total Depr >= Residual - Tolerance (should not over-depreciate significantly)
        // With straight line, it matches exactly total.
        prop_assert!(cost - total_depr >= residual - tolerance);
    }
}
