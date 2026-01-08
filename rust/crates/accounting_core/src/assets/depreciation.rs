use crate::assets::models::{AssetError, FixedAsset};
use chrono::{Datelike, NaiveDateTime};
use rust_decimal::Decimal;

pub fn calculate_depreciation(
    asset: &FixedAsset,
    as_of: NaiveDateTime,
) -> Result<Decimal, AssetError> {
    if as_of <= asset.purchase_date {
        return Ok(Decimal::ZERO);
    }

    match asset.depreciation_method {
        crate::assets::models::DepreciationMethod::StraightLine => {
            calculate_straight_line(asset, as_of)
        }
        crate::assets::models::DepreciationMethod::DiminishingBalance => {
            calculate_diminishing_balance(asset, as_of)
        }
        crate::assets::models::DepreciationMethod::UnitsOfProduction => {
            // Placeholder for now, requires production data
            Err(AssetError::CalculationError(
                "Units of Production not yet implemented".to_string(),
            ))
        }
    }
}

fn calculate_straight_line(
    asset: &FixedAsset,
    as_of: NaiveDateTime,
) -> Result<Decimal, AssetError> {
    if asset.useful_life_years == 0 {
        return Err(AssetError::InvalidUsefulLife);
    }

    let depreciable_amount = asset.cost - asset.salvage_value;
    if depreciable_amount <= Decimal::ZERO {
        return Ok(Decimal::ZERO);
    }

    // Days since purchase
    let duration = as_of.signed_duration_since(asset.purchase_date);
    let days_passed = duration.num_days();
    let total_days = (asset.useful_life_years * 365) as i64; // Simple approximation for now

    if days_passed <= 0 {
        return Ok(Decimal::ZERO);
    }

    if days_passed >= total_days {
        return Ok(depreciable_amount);
    }

    let depreciation =
        (depreciable_amount * Decimal::from(days_passed)) / Decimal::from(total_days);

    Ok(depreciation.round_dp(2))
}

fn calculate_diminishing_balance(
    asset: &FixedAsset,
    as_of: NaiveDateTime,
) -> Result<Decimal, AssetError> {
    // Basic 2x straight-line rate (Double declining balance)
    if asset.useful_life_years == 0 {
        return Err(AssetError::InvalidUsefulLife);
    }

    let rate = Decimal::from(2) / Decimal::from(asset.useful_life_years);

    // This requires iterative calculation or power formula
    // For MVP, we'll do an approximation based on full years passed
    let years_passed = (as_of.year() - asset.purchase_date.year()) as u32;

    let mut current_nbv = asset.cost;
    let mut total_depreciation = Decimal::ZERO;

    for _ in 0..years_passed {
        let yearly_dep = current_nbv * rate;
        total_depreciation += yearly_dep;
        current_nbv -= yearly_dep;

        if current_nbv <= asset.salvage_value {
            return Ok(asset.cost - asset.salvage_value);
        }
    }

    Ok(total_depreciation.round_dp(2))
}
