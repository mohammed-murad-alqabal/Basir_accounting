use chrono::NaiveDate;
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use sqlx::encode::IsNull;
use std::error::Error as StdError;
use strum_macros::{Display, EnumString};
use thiserror::Error;
use uuid::Uuid;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AssetCategory {
    pub id: Uuid,
    pub name_ar: String,
    pub name_en: String,
    pub description: Option<String>,
    pub default_useful_life_years: i32,
    pub default_depreciation_method: DepreciationMethod,
    // Account Mapping
    pub asset_account_id: Option<Uuid>,
    pub depreciation_account_id: Option<Uuid>,
    pub accum_depreciation_account_id: Option<Uuid>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FixedAsset {
    pub id: Uuid,
    pub code: String,
    pub name_ar: String,
    pub name_en: String,
    pub description: Option<String>,
    pub category_id: Uuid,
    pub acquisition_date: NaiveDate,
    pub cost: Decimal,
    pub residual_value: Decimal,
    pub useful_life_years: i32,
    pub depreciation_method: DepreciationMethod,
    pub status: AssetStatus,
    pub accumulated_depreciation: Decimal,
    pub asset_account_id: Uuid,
    pub depreciation_account_id: Uuid,
    pub accum_depreciation_account_id: Uuid,
    pub is_active: bool,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize, Display, EnumString)]
pub enum DepreciationMethod {
    StraightLine,
    DecliningBalance,
    UnitsOfProduction,
}

impl sqlx::Type<sqlx::Postgres> for DepreciationMethod {
    fn type_info() -> sqlx::postgres::PgTypeInfo {
        sqlx::postgres::PgTypeInfo::with_name("text")
    }
}

impl sqlx::Encode<'_, sqlx::Postgres> for DepreciationMethod {
    fn encode_by_ref(
        &self,
        buf: &mut sqlx::postgres::PgArgumentBuffer,
    ) -> Result<IsNull, Box<dyn StdError + Send + Sync + 'static>> {
        <String as sqlx::Encode<sqlx::Postgres>>::encode_by_ref(&self.to_string(), buf)
    }
}

impl<'r> sqlx::Decode<'r, sqlx::Postgres> for DepreciationMethod {
    fn decode(
        value: sqlx::postgres::PgValueRef<'r>,
    ) -> Result<Self, Box<dyn std::error::Error + Send + Sync>> {
        let s: &str = <&str as sqlx::Decode<sqlx::Postgres>>::decode(value)?;
        s.parse().map_err(|_| "Invalid depreciation method".into())
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize, Display, EnumString)]
pub enum AssetStatus {
    Active,
    Disposed,
    FullyDepreciated,
}

impl sqlx::Type<sqlx::Postgres> for AssetStatus {
    fn type_info() -> sqlx::postgres::PgTypeInfo {
        sqlx::postgres::PgTypeInfo::with_name("text")
    }
}

impl sqlx::Encode<'_, sqlx::Postgres> for AssetStatus {
    fn encode_by_ref(
        &self,
        buf: &mut sqlx::postgres::PgArgumentBuffer,
    ) -> Result<IsNull, Box<dyn StdError + Send + Sync + 'static>> {
        <String as sqlx::Encode<sqlx::Postgres>>::encode_by_ref(&self.to_string(), buf)
    }
}

impl<'r> sqlx::Decode<'r, sqlx::Postgres> for AssetStatus {
    fn decode(
        value: sqlx::postgres::PgValueRef<'r>,
    ) -> Result<Self, Box<dyn std::error::Error + Send + Sync>> {
        let s: &str = <&str as sqlx::Decode<sqlx::Postgres>>::decode(value)?;
        s.parse().map_err(|_| "Invalid asset status".into())
    }
}

#[derive(Debug, Error)]
pub enum AssetError {
    #[error("Asset not found: {0}")]
    NotFound(Uuid),
    #[error("Invalid depreciation calculation: {0}")]
    DepreciationError(String),
}
