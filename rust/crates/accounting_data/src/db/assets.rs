use accounting_core::assets::models::{AssetCategory, AssetStatus, DepreciationMethod, FixedAsset};
use rust_decimal::Decimal;
use sqlx::PgPool;
use uuid::Uuid;

pub struct PgAssetRepository {
    pool: PgPool,
}

impl PgAssetRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    pub async fn register_asset(&self, asset: &FixedAsset) -> anyhow::Result<()> {
        // We do not insert account IDs as they are derived from Category.
        sqlx::query!(
            r#"
            INSERT INTO fixed_assets (
                id, code, name_ar, name_en, description, category_id, acquisition_date, 
                cost, residual_value, useful_life_years, depreciation_method, 
                status, accumulated_depreciation, is_active
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
            "#,
            asset.id,
            asset.code,
            asset.name_ar,
            asset.name_en,
            asset.description,
            asset.category_id,
            asset.acquisition_date,
            asset.cost,
            asset.residual_value,
            asset.useful_life_years,
            asset.depreciation_method as DepreciationMethod,
            asset.status as AssetStatus,
            Decimal::ZERO, // Initial accum depreciation
            true           // is_active
        )
        .execute(&self.pool)
        .await?;

        Ok(())
    }

    pub async fn get_asset(&self, id: Uuid) -> anyhow::Result<Option<FixedAsset>> {
        let record = sqlx::query!(
            r#"
            SELECT 
                a.id, a.code, a.name_ar, a.name_en, a.description, a.category_id, a.acquisition_date, 
                a.cost, a.residual_value, a.useful_life_years, 
                a.depreciation_method as "depreciation_method: DepreciationMethod",
                a.status as "status: AssetStatus",
                a.accumulated_depreciation,
                a.is_active,
                c.asset_account_id,
                c.depreciation_account_id,
                c.accum_depreciation_account_id
            FROM fixed_assets a
            JOIN asset_categories c ON a.category_id = c.id
            WHERE a.id = $1
            "#,
            id
        )
        .fetch_optional(&self.pool)
        .await?;

        match record {
            Some(r) => Ok(Some(FixedAsset {
                id: r.id,
                code: r.code,
                name_ar: r.name_ar,
                name_en: r.name_en,
                description: r.description,
                category_id: r.category_id,
                acquisition_date: r.acquisition_date,
                cost: r.cost,
                residual_value: r.residual_value,
                useful_life_years: r.useful_life_years,
                depreciation_method: r.depreciation_method,
                status: r.status,
                accumulated_depreciation: r.accumulated_depreciation,
                asset_account_id: r.asset_account_id.unwrap_or_default(),
                depreciation_account_id: r.depreciation_account_id.unwrap_or_default(),
                accum_depreciation_account_id: r.accum_depreciation_account_id.unwrap_or_default(),
                is_active: r.is_active,
            })),
            None => Ok(None),
        }
    }

    pub async fn update_status(&self, asset_id: Uuid, status: AssetStatus) -> anyhow::Result<()> {
        sqlx::query!(
            r#"
            UPDATE fixed_assets
            SET status = $1
            WHERE id = $2
            "#,
            status as AssetStatus,
            asset_id
        )
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    pub async fn update_accumulated_depreciation(
        &self,
        asset_id: Uuid,
        amount: Decimal,
        period_start: chrono::NaiveDate,
        period_end: chrono::NaiveDate,
        entry_id: Uuid,
    ) -> anyhow::Result<()> {
        let mut tx = self.pool.begin().await?;

        // 1. Insert into history
        sqlx::query!(
            r#"
            INSERT INTO depreciation_history (id, asset_id, period_start_date, period_end_date, amount, entry_id)
            VALUES ($1, $2, $3, $4, $5, $6)
            "#,
            Uuid::new_v4(),
            asset_id,
            period_start,
            period_end,
            amount,
            entry_id
        )
        .execute(&mut *tx)
        .await?;

        // 2. Update cached accumulated_depreciation on fixed_assets table
        sqlx::query!(
            r#"
            UPDATE fixed_assets
            SET accumulated_depreciation = accumulated_depreciation + $1
            WHERE id = $2
            "#,
            amount,
            asset_id
        )
        .execute(&mut *tx)
        .await?;

        tx.commit().await?;
        Ok(())
    }

    pub async fn register_category(&self, category: &AssetCategory) -> anyhow::Result<()> {
        sqlx::query!(
            r#"
            INSERT INTO asset_categories (
                id, name_ar, name_en, description, default_useful_life_years, 
                default_depreciation_method, asset_account_id, depreciation_account_id, 
                accum_depreciation_account_id
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            "#,
            category.id,
            category.name_ar,
            category.name_en,
            category.description,
            category.default_useful_life_years,
            category.default_depreciation_method as DepreciationMethod,
            category.asset_account_id,
            category.depreciation_account_id,
            category.accum_depreciation_account_id
        )
        .execute(&self.pool)
        .await?;

        Ok(())
    }

    pub async fn list_categories(&self) -> anyhow::Result<Vec<AssetCategory>> {
        let records = sqlx::query!(
            r#"
            SELECT 
                id, name_ar, name_en, description, default_useful_life_years, 
                default_depreciation_method as "default_depreciation_method: DepreciationMethod",
                asset_account_id, depreciation_account_id, accum_depreciation_account_id
            FROM asset_categories
            ORDER BY name_en
            "#,
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(records
            .into_iter()
            .map(|r| AssetCategory {
                id: r.id,
                name_ar: r.name_ar,
                name_en: r.name_en,
                description: r.description,
                default_useful_life_years: r.default_useful_life_years,
                default_depreciation_method: r.default_depreciation_method,
                asset_account_id: r.asset_account_id,
                depreciation_account_id: r.depreciation_account_id,
                accum_depreciation_account_id: r.accum_depreciation_account_id,
            })
            .collect())
    }

    pub async fn list_active_assets(&self) -> anyhow::Result<Vec<FixedAsset>> {
        // Need to join to get accounts
        let records = sqlx::query!(
            r#"
            SELECT 
                a.id, a.code, a.name_ar, a.name_en, a.description, a.category_id, a.acquisition_date, 
                a.cost, a.residual_value, a.useful_life_years, 
                a.depreciation_method as "depreciation_method: DepreciationMethod",
                a.status as "status: AssetStatus",
                a.accumulated_depreciation,
                a.is_active,
                c.asset_account_id,
                c.depreciation_account_id,
                c.accum_depreciation_account_id
            FROM fixed_assets a
            JOIN asset_categories c ON a.category_id = c.id
            WHERE a.is_active = true
            "#,
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(records
            .into_iter()
            .map(|r| FixedAsset {
                id: r.id,
                code: r.code,
                name_ar: r.name_ar,
                name_en: r.name_en,
                description: r.description,
                category_id: r.category_id,
                acquisition_date: r.acquisition_date,
                cost: r.cost,
                residual_value: r.residual_value,
                useful_life_years: r.useful_life_years,
                depreciation_method: r.depreciation_method,
                status: r.status,
                accumulated_depreciation: r.accumulated_depreciation,
                asset_account_id: r.asset_account_id.unwrap_or_default(),
                depreciation_account_id: r.depreciation_account_id.unwrap_or_default(),
                accum_depreciation_account_id: r.accum_depreciation_account_id.unwrap_or_default(),
                is_active: r.is_active,
            })
            .collect())
    }
}
