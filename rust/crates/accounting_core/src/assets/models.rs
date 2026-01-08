use chrono::NaiveDateTime;
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use thiserror::Error;
use uuid::Uuid;

#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq, Eq)]
pub enum DepreciationMethod {
    StraightLine,
    DiminishingBalance,
    UnitsOfProduction,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FixedAsset {
    pub id: Uuid,
    pub code: String,
    pub name_ar: String,
    pub name_en: String,
    pub category_id: Uuid,
    pub purchase_date: NaiveDateTime,
    pub cost: Decimal,
    pub salvage_value: Decimal,
    pub useful_life_years: u32,
    pub depreciation_method: DepreciationMethod,
    pub accumulated_depreciation: Decimal,
    pub asset_account_id: Uuid,
    pub depreciation_account_id: Uuid,
    pub accum_depreciation_account_id: Uuid,
    pub is_active: bool,
}

impl FixedAsset {
    pub fn net_book_value(&self) -> Decimal {
        self.cost - self.accumulated_depreciation
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AssetCategory {
    pub id: Uuid,
    pub name_ar: String,
    pub name_en: String,
    pub default_depreciation_method: DepreciationMethod,
    pub default_useful_life_years: u32,
}

#[derive(Error, Debug)]
pub enum AssetError {
    #[error("Asset not found")]
    NotFound,
    #[error("Invalid useful life")]
    InvalidUsefulLife,
    #[error("Accumulated depreciation cannot exceed cost")]
    AccumulatedDepreciationExceedsCost,
    #[error("Calculation error: {0}")]
    CalculationError(String),
}
