use crate::api::{get_pool, AuditMetadataDto};
use accounting_core::assets::depreciation::calculate_depreciation;
use accounting_core::assets::models::{DepreciationMethod, FixedAsset};
use accounting_core::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
    TemporalJustification,
};
use accounting_data::db::assets::PgAssetRepository;
use accounting_data::db::ledger::PgLedgerRepository;
use chrono::{Datelike, Utc};
use rust_decimal::Decimal;
use std::str::FromStr;
use uuid::Uuid;

pub async fn register_asset(asset: AssetDto) -> anyhow::Result<String> {
    let pool = get_pool()?.clone();
    let repo = PgAssetRepository::new(pool);
    let entity: FixedAsset = asset.try_into()?;
    repo.register_asset(&entity).await?;
    Ok(entity.id.to_string())
}

pub async fn list_assets() -> anyhow::Result<Vec<AssetDto>> {
    let pool = get_pool()?.clone();
    let repo = PgAssetRepository::new(pool);
    let assets = repo.list_active_assets().await?;
    Ok(assets.into_iter().map(AssetDto::from).collect())
}

pub async fn get_asset_by_id(id: String) -> anyhow::Result<Option<AssetDto>> {
    let pool = get_pool()?.clone();
    let repo = PgAssetRepository::new(pool);
    let uuid = Uuid::parse_str(&id)?;
    let asset = repo.get_asset(uuid).await?;
    Ok(asset.map(AssetDto::from))
}

pub async fn run_depreciation_cycle(
    asset_id: String,
    as_of: String,
    metadata: AuditMetadataDto,
) -> anyhow::Result<()> {
    let pool = get_pool()?.clone();
    let repo = PgAssetRepository::new(pool.clone());
    let ledger_repo = PgLedgerRepository::new(pool);

    let asset_uuid = Uuid::parse_str(&asset_id)?;
    let as_of_date = chrono::DateTime::parse_from_rfc3339(&as_of)?
        .with_timezone(&Utc)
        .naive_utc();

    // Determine period start (e.g., first day of month)
    let period_start = as_of_date
        .date()
        .with_day(1)
        .ok_or_else(|| anyhow::anyhow!("Invalid date"))?;
    let period_end = as_of_date.date();

    let asset = repo
        .get_asset(asset_uuid)
        .await?
        .ok_or_else(|| anyhow::anyhow!("Asset not found"))?;

    let depreciation_amount = calculate_depreciation(&asset, period_end)?;

    if depreciation_amount > Decimal::ZERO {
        let audit_meta: accounting_core::audit::models::AuditMetadata = metadata.try_into()?;
        let user_id = audit_meta.who.user_id;
        let entry_id = Uuid::new_v4();

        let entry = JournalEntry {
            entry_id,
            entry_number: format!("DEP-{}", asset.code),
            description: format!(
                "Depreciation for Asset {} ({})",
                asset.name_ar, asset.name_en
            ),
            entry_type: EntryType::Adjusting,
            status: EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: Some(
                accounting_core::ledger::models::AdjustmentReason::EstimationChange,
            ),
            temporal: TemporalJustification::new(period_start, period_end),
            standards: StandardsJustification::simple("IFRS 16"),
            lines: vec![
                JournalEntryLine::debit(
                    asset.depreciation_account_id,
                    depreciation_amount,
                    &format!("Monthly Depreciation - {}", asset.name_en),
                ),
                JournalEntryLine::credit(
                    asset.accum_depreciation_account_id,
                    depreciation_amount,
                    &format!("Monthly Depreciation - {}", asset.name_en),
                ),
            ],
            created_by: user_id,
            created_at: Utc::now(),
            approved_by: Some(user_id),
            approved_at: Some(Utc::now()),
            posted_by: Some(user_id),
            posted_at: Some(Utc::now()),
            hash: String::new(),
            previous_hash: String::new(),
        };

        ledger_repo.post_entry(&entry, &audit_meta).await?;
        repo.update_accumulated_depreciation(
            asset.id,
            depreciation_amount,
            period_start,
            period_end,
            entry_id,
        )
        .await?;
    }

    Ok(())
}

#[derive(Clone)]
pub struct AssetDto {
    pub id: Option<String>,
    pub code: String,
    pub name_ar: String,
    pub name_en: String,
    pub category_id: String,
    pub acquisition_date: String, // ISO 8601
    pub cost: String,
    pub residual_value: String,
    pub useful_life_years: u32,
    pub depreciation_method: String,
    pub accumulated_depreciation: String,
    pub asset_account_id: String,
    pub depreciation_account_id: String,
    pub accum_depreciation_account_id: String,
    pub is_active: bool,
}

impl From<FixedAsset> for AssetDto {
    fn from(a: FixedAsset) -> Self {
        use chrono::TimeZone;
        let dt = chrono::Utc.from_utc_datetime(&a.acquisition_date.and_hms_opt(0, 0, 0).unwrap());
        Self {
            id: Some(a.id.to_string()),
            code: a.code,
            name_ar: a.name_ar,
            name_en: a.name_en,
            category_id: a.category_id.to_string(),
            acquisition_date: dt.to_rfc3339(),
            cost: a.cost.to_string(),
            residual_value: a.residual_value.to_string(),
            useful_life_years: a.useful_life_years as u32,
            depreciation_method: a.depreciation_method.to_string(),
            accumulated_depreciation: a.accumulated_depreciation.to_string(),
            asset_account_id: a.asset_account_id.to_string(),
            depreciation_account_id: a.depreciation_account_id.to_string(),
            accum_depreciation_account_id: a.accum_depreciation_account_id.to_string(),
            is_active: a.is_active,
        }
    }
}

impl TryFrom<AssetDto> for FixedAsset {
    type Error = anyhow::Error;
    fn try_from(dto: AssetDto) -> Result<Self, Self::Error> {
        use chrono::{DateTime, Utc};
        Ok(Self {
            id: dto
                .id
                .map(|s| Uuid::parse_str(&s))
                .unwrap_or_else(|| Ok(Uuid::new_v4()))?,
            code: dto.code,
            name_ar: dto.name_ar,
            name_en: dto.name_en,
            category_id: Uuid::parse_str(&dto.category_id)?,
            description: None, // Added field
            acquisition_date: DateTime::parse_from_rfc3339(&dto.acquisition_date)
                .map(|dt| dt.with_timezone(&Utc))
                .unwrap_or_else(|_| Utc::now())
                .naive_utc()
                .date(),
            cost: Decimal::from_str(&dto.cost).unwrap_or(Decimal::ZERO),
            residual_value: Decimal::from_str(&dto.residual_value).unwrap_or(Decimal::ZERO),
            useful_life_years: dto.useful_life_years as i32,
            depreciation_method: match dto.depreciation_method.as_str() {
                "StraightLine" => DepreciationMethod::StraightLine,
                "DecliningBalance" => DepreciationMethod::DecliningBalance,
                "UnitsOfProduction" => DepreciationMethod::UnitsOfProduction,
                _ => DepreciationMethod::StraightLine,
            },
            status: accounting_core::assets::models::AssetStatus::Active, // Default status
            accumulated_depreciation: Decimal::from_str(&dto.accumulated_depreciation)
                .unwrap_or(Decimal::ZERO),
            asset_account_id: Uuid::parse_str(&dto.asset_account_id).unwrap_or_default(),
            depreciation_account_id: Uuid::parse_str(&dto.depreciation_account_id)
                .unwrap_or_default(),
            accum_depreciation_account_id: Uuid::parse_str(&dto.accum_depreciation_account_id)
                .unwrap_or_default(),
            is_active: dto.is_active,
        })
    }
}

pub async fn register_category(category: AssetCategoryDto) -> anyhow::Result<String> {
    let pool = get_pool()?.clone();
    let repo = PgAssetRepository::new(pool);
    let entity: accounting_core::assets::models::AssetCategory = category.try_into()?;
    repo.register_category(&entity).await?;
    Ok(entity.id.to_string())
}

pub async fn list_categories() -> anyhow::Result<Vec<AssetCategoryDto>> {
    let pool = get_pool()?.clone();
    let repo = PgAssetRepository::new(pool);
    let categories = repo.list_categories().await?;
    Ok(categories.into_iter().map(AssetCategoryDto::from).collect())
}

#[derive(Clone)]
pub struct AssetCategoryDto {
    pub id: Option<String>,
    pub name_ar: String,
    pub name_en: String,
    pub default_depreciation_method: String,
    pub default_useful_life_years: u32,
    pub asset_account_id: String,
    pub depreciation_account_id: String,
    pub accum_depreciation_account_id: String,
}

impl From<accounting_core::assets::models::AssetCategory> for AssetCategoryDto {
    fn from(c: accounting_core::assets::models::AssetCategory) -> Self {
        Self {
            id: Some(c.id.to_string()),
            name_ar: c.name_ar,
            name_en: c.name_en,
            default_depreciation_method: c.default_depreciation_method.to_string(), // Use Display
            default_useful_life_years: c.default_useful_life_years as u32,
            asset_account_id: c
                .asset_account_id
                .map(|id| id.to_string())
                .unwrap_or_default(),
            depreciation_account_id: c
                .depreciation_account_id
                .map(|id| id.to_string())
                .unwrap_or_default(),
            accum_depreciation_account_id: c
                .accum_depreciation_account_id
                .map(|id| id.to_string())
                .unwrap_or_default(),
        }
    }
}

impl TryFrom<AssetCategoryDto> for accounting_core::assets::models::AssetCategory {
    type Error = anyhow::Error;
    fn try_from(dto: AssetCategoryDto) -> Result<Self, Self::Error> {
        let parse_uuid_opt = |s: &str| -> Option<Uuid> {
            if s.is_empty() {
                None
            } else {
                Uuid::parse_str(s).ok()
            }
        };

        Ok(Self {
            id: dto
                .id
                .map(|s| Uuid::parse_str(&s))
                .unwrap_or_else(|| Ok(Uuid::new_v4()))?,
            name_ar: dto.name_ar,
            name_en: dto.name_en,
            description: Some("".to_string()), // Default description?
            default_depreciation_method: match dto.default_depreciation_method.as_str() {
                "StraightLine" => accounting_core::assets::models::DepreciationMethod::StraightLine,
                "DecliningBalance" => {
                    accounting_core::assets::models::DepreciationMethod::DecliningBalance
                }
                _ => accounting_core::assets::models::DepreciationMethod::UnitsOfProduction,
            },
            default_useful_life_years: dto.default_useful_life_years as i32,
            asset_account_id: parse_uuid_opt(&dto.asset_account_id),
            depreciation_account_id: parse_uuid_opt(&dto.depreciation_account_id),
            accum_depreciation_account_id: parse_uuid_opt(&dto.accum_depreciation_account_id),
        })
    }
}
