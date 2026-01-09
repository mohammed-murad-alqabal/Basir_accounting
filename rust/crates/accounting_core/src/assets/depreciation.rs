use chrono::{Datelike, NaiveDate};
use rust_decimal::Decimal;

/// Trait for calculating depreciation.
pub trait DepreciationCalculator {
    /// Calculate depreciation for a given period.
    ///
    /// # Arguments
    /// * `cost` - The initial cost of the asset.
    /// * `residual_value` - The estimated value at end of life.
    /// * `useful_life_years` - Total useful life in years.
    /// * `acquisition_date` - Date the asset was acquired.
    /// * `period_start` - Start of the period to calculate for.
    /// * `period_end` - End of the period to calculate for.
    ///
    /// # Returns
    /// The depreciation amount for the specified period.
    fn calculate_period_depreciation(
        &self,
        cost: Decimal,
        residual_value: Decimal,
        useful_life_years: i32,
        acquisition_date: NaiveDate,
        period_start: NaiveDate,
        period_end: NaiveDate,
    ) -> Decimal;
}

/// Straight-Line Depreciation Implementation
pub struct StraightLineDepreciation;

impl DepreciationCalculator for StraightLineDepreciation {
    fn calculate_period_depreciation(
        &self,
        cost: Decimal,
        residual_value: Decimal,
        useful_life_years: i32,
        _acquisition_date: NaiveDate, // Simplification: assuming full years or pro-rating based on period
        period_start: NaiveDate,
        period_end: NaiveDate,
    ) -> Decimal {
        if useful_life_years <= 0 {
            return Decimal::ZERO;
        }

        let depreciable_amount = cost - residual_value;
        if depreciable_amount <= Decimal::ZERO {
            return Decimal::ZERO;
        }

        let annual_depreciation = depreciable_amount / Decimal::from(useful_life_years);

        // Calculate pro-ration factor based on days in period vs days in year
        // Use the year of the period_end to determine days in year (Fiscal Year basis typically)
        let year = period_end.year();
        let is_leap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
        let days_in_year = if is_leap { 366 } else { 365 };

        let days_in_period = (period_end - period_start).num_days() as i64 + 1; // Inclusive

        let factor = Decimal::from(days_in_period) / Decimal::from(days_in_year);

        (annual_depreciation * factor).round_dp(2)
    }
}

pub fn calculate_depreciation(
    asset: &crate::assets::models::FixedAsset,
    period_end: NaiveDate,
) -> Result<Decimal, crate::assets::models::AssetError> {
    use crate::assets::models::{AssetError, DepreciationMethod};

    // Determine period start... for now, let's assume monthly calculation from period_end
    // In reality, this needs context or last run date.
    // For simplicity of API matching, we assume we are calculating for the month ending at period_end.
    let period_start = period_end
        .with_day(1)
        .ok_or_else(|| AssetError::DepreciationError("Invalid date".to_string()))?;

    let calculator: Box<dyn DepreciationCalculator> = match asset.depreciation_method {
        DepreciationMethod::StraightLine => Box::new(StraightLineDepreciation),
        // For others, fallback to StraightLine or implement them later.
        _ => Box::new(StraightLineDepreciation),
    };

    Ok(calculator.calculate_period_depreciation(
        asset.cost,
        asset.residual_value,
        asset.useful_life_years,
        asset.acquisition_date,
        period_start,
        period_end,
    ))
}
