use accounting_core::assets::models::{AssetCategory, DepreciationMethod, FixedAsset};
use rust_decimal::Decimal;
use sqlx::{PgPool, Row};
use uuid::Uuid;

pub struct PgAssetRepository {
    pool: PgPool,
}

impl PgAssetRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    pub async fn register_asset(&self, asset: &FixedAsset) -> anyhow::Result<()> {
        sqlx::query(
            r#"
            INSERT INTO fixed_assets (
                id, code, name_ar, name_en, category_id, purchase_date, cost, salvage_value, 
                useful_life_years, depreciation_method, accumulated_depreciation, 
                asset_account_id, depreciation_account_id, accum_depreciation_account_id, is_active
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
            "#,
        )
        .bind(asset.id)
        .bind(&asset.code)
        .bind(&asset.name_ar)
        .bind(&asset.name_en)
        .bind(asset.category_id)
        .bind(asset.purchase_date)
        .bind(asset.cost)
        .bind(asset.salvage_value)
        .bind(asset.useful_life_years as i32)
        .bind(format!("{:?}", asset.depreciation_method))
        .bind(asset.accumulated_depreciation)
        .bind(asset.asset_account_id)
        .bind(asset.depreciation_account_id)
        .bind(asset.accum_depreciation_account_id)
        .bind(asset.is_active)
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    pub async fn get_asset(&self, id: Uuid) -> anyhow::Result<Option<FixedAsset>> {
        let row = sqlx::query(
            r#"
            SELECT 
                id, code, name_ar, name_en, category_id, purchase_date, cost, salvage_value, 
                useful_life_years, depreciation_method, accumulated_depreciation, 
                asset_account_id, depreciation_account_id, accum_depreciation_account_id, is_active
            FROM fixed_assets
            WHERE id = $1
            "#,
        )
        .bind(id)
        .fetch_optional(&self.pool)
        .await?;

        if let Some(r) = row {
            let depreciation_method_str: String = r.get("depreciation_method");
            let method = match depreciation_method_str.as_str() {
                "StraightLine" => DepreciationMethod::StraightLine,
                "DiminishingBalance" => DepreciationMethod::DiminishingBalance,
                _ => DepreciationMethod::UnitsOfProduction,
            };

            Ok(Some(FixedAsset {
                id: r.get("id"),
                code: r.get("code"),
                name_ar: r.get("name_ar"),
                name_en: r.get("name_en"),
                category_id: r.get("category_id"),
                purchase_date: r.get("purchase_date"),
                cost: r.get("cost"),
                salvage_value: r.get("salvage_value"),
                useful_life_years: r.get::<i32, _>("useful_life_years") as u32,
                depreciation_method: method,
                accumulated_depreciation: r.get("accumulated_depreciation"),
                asset_account_id: r.get("asset_account_id"),
                depreciation_account_id: r.get("depreciation_account_id"),
                accum_depreciation_account_id: r.get("accum_depreciation_account_id"),
                is_active: r.get("is_active"),
            }))
        } else {
            Ok(None)
        }
    }

    pub async fn list_active_assets(&self) -> anyhow::Result<Vec<FixedAsset>> {
        let rows = sqlx::query(
            r#"
            SELECT 
                id, code, name_ar, name_en, category_id, purchase_date, cost, salvage_value, 
                useful_life_years, depreciation_method, accumulated_depreciation, 
                asset_account_id, depreciation_account_id, accum_depreciation_account_id, is_active
            FROM fixed_assets
            WHERE is_active = TRUE
            "#,
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows
            .into_iter()
            .map(|r| {
                let depreciation_method_str: String = r.get("depreciation_method");
                let method = match depreciation_method_str.as_str() {
                    "StraightLine" => DepreciationMethod::StraightLine,
                    "DiminishingBalance" => DepreciationMethod::DiminishingBalance,
                    _ => DepreciationMethod::UnitsOfProduction,
                };

                FixedAsset {
                    id: r.get("id"),
                    code: r.get("code"),
                    name_ar: r.get("name_ar"),
                    name_en: r.get("name_en"),
                    category_id: r.get("category_id"),
                    purchase_date: r.get("purchase_date"),
                    cost: r.get("cost"),
                    salvage_value: r.get("salvage_value"),
                    useful_life_years: r.get::<i32, _>("useful_life_years") as u32,
                    depreciation_method: method,
                    accumulated_depreciation: r.get("accumulated_depreciation"),
                    asset_account_id: r.get("asset_account_id"),
                    depreciation_account_id: r.get("depreciation_account_id"),
                    accum_depreciation_account_id: r.get("accum_depreciation_account_id"),
                    is_active: r.get("is_active"),
                }
            })
            .collect())
    }

    pub async fn update_accumulated_depreciation(
        &self,
        asset_id: Uuid,
        amount: Decimal,
    ) -> anyhow::Result<()> {
        sqlx::query(
            r#"
            UPDATE fixed_assets
            SET accumulated_depreciation = accumulated_depreciation + $1,
                updated_at = NOW()
            WHERE id = $2
            "#,
        )
        .bind(amount)
        .bind(asset_id)
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    pub async fn register_category(&self, category: &AssetCategory) -> anyhow::Result<()> {
        sqlx::query(
            r#"
            INSERT INTO asset_categories (id, name_ar, name_en, default_depreciation_method, default_useful_life_years)
            VALUES ($1, $2, $3, $4, $5)
            "#,
        )
        .bind(category.id)
        .bind(&category.name_ar)
        .bind(&category.name_en)
        .bind(format!("{:?}", category.default_depreciation_method))
        .bind(category.default_useful_life_years as i32)
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    pub async fn list_categories(&self) -> anyhow::Result<Vec<AssetCategory>> {
        let rows = sqlx::query(
            r#"
            SELECT id, name_ar, name_en, default_depreciation_method, default_useful_life_years
            FROM asset_categories
            ORDER BY name_ar
            "#,
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows
            .into_iter()
            .map(|r| {
                let method_str: String = r.get("default_depreciation_method");
                let method = match method_str.as_str() {
                    "StraightLine" => DepreciationMethod::StraightLine,
                    "DiminishingBalance" => DepreciationMethod::DiminishingBalance,
                    _ => DepreciationMethod::UnitsOfProduction,
                };

                AssetCategory {
                    id: r.get("id"),
                    name_ar: r.get("name_ar"),
                    name_en: r.get("name_en"),
                    default_depreciation_method: method,
                    default_useful_life_years: r.get::<i32, _>("default_useful_life_years") as u32,
                }
            })
            .collect())
    }
}
