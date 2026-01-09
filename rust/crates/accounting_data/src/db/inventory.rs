use accounting_core::inventory::{InventoryItem, MovementType, StockMovement, ValuationMethod};
use rust_decimal::Decimal;
use sqlx::{FromRow, PgPool};
use uuid::Uuid;

pub struct PgInventoryRepository {
    pool: PgPool,
}

#[derive(FromRow)]
struct StockMovementRow {
    id: Uuid,
    item_id: Uuid,
    movement_type: String,
    quantity: Decimal,
    unit_cost: Decimal,
    date: chrono::DateTime<chrono::Utc>,
    reference_id: Option<Uuid>,
    description: Option<String>,
    hash: String,
    previous_hash: String,
}

#[derive(FromRow)]
struct InventoryItemRow {
    id: Uuid,
    code: String,
    name_ar: String,
    name_en: String,
    description: Option<String>,
    unit: String,
    valuation_method: String,
    purchase_price: Option<Decimal>,
    sale_price: Option<Decimal>,
    asset_account_id: Uuid,
    cogs_account_id: Uuid,
    revenue_account_id: Uuid,
    created_at: chrono::DateTime<chrono::Utc>,
    updated_at: chrono::DateTime<chrono::Utc>,
}

impl PgInventoryRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    pub async fn save_item(&self, item: &InventoryItem) -> anyhow::Result<()> {
        sqlx::query(
            r#"
            INSERT INTO inventory_items (
                id, code, name_ar, name_en, description, unit, valuation_method, 
                purchase_price, sale_price, asset_account_id, cogs_account_id, revenue_account_id,
                created_at, updated_at
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
            ON CONFLICT (id) DO UPDATE SET
                code = EXCLUDED.code,
                name_ar = EXCLUDED.name_ar,
                name_en = EXCLUDED.name_en,
                description = EXCLUDED.description,
                unit = EXCLUDED.unit,
                valuation_method = EXCLUDED.valuation_method,
                purchase_price = EXCLUDED.purchase_price,
                sale_price = EXCLUDED.sale_price,
                asset_account_id = EXCLUDED.asset_account_id,
                cogs_account_id = EXCLUDED.cogs_account_id,
                revenue_account_id = EXCLUDED.revenue_account_id,
                updated_at = NOW()
            "#,
        )
        .bind(item.id)
        .bind(&item.code)
        .bind(&item.name_ar)
        .bind(&item.name_en)
        .bind(item.description.as_ref())
        .bind(&item.unit)
        .bind(format!("{:?}", item.valuation_method))
        .bind(item.purchase_price)
        .bind(item.sale_price)
        .bind(item.asset_account_id)
        .bind(item.cogs_account_id)
        .bind(item.revenue_account_id)
        .bind(item.created_at)
        .bind(item.updated_at)
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    pub async fn get_item(&self, id: Uuid) -> anyhow::Result<Option<InventoryItem>> {
        let row = sqlx::query_as!(
            InventoryItemRow,
            r#"
            SELECT 
                id, code, name_ar, name_en, description, unit, valuation_method,
                purchase_price, sale_price, asset_account_id, cogs_account_id, revenue_account_id,
                created_at, updated_at
            FROM inventory_items
            WHERE id = $1
            "#,
            id
        )
        .fetch_optional(&self.pool)
        .await?;

        if let Some(r) = row {
            let valuation_method = match r.valuation_method.as_str() {
                "Fifo" => ValuationMethod::Fifo,
                _ => ValuationMethod::WeightedAverage,
            };

            Ok(Some(InventoryItem {
                id: r.id,
                code: r.code,
                name_ar: r.name_ar,
                name_en: r.name_en,
                description: r.description,
                unit: r.unit,
                valuation_method,
                purchase_price: r.purchase_price,
                sale_price: r.sale_price,
                asset_account_id: r.asset_account_id,
                cogs_account_id: r.cogs_account_id,
                revenue_account_id: r.revenue_account_id,
                created_at: r.created_at,
                updated_at: r.updated_at,
            }))
        } else {
            Ok(None)
        }
    }

    pub async fn record_movement(&self, movement: &StockMovement) -> anyhow::Result<()> {
        sqlx::query(
            r#"
            INSERT INTO stock_movements (id, item_id, movement_type, quantity, unit_cost, date, reference_id, description, hash, previous_hash)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
            "#
        )
        .bind(movement.id)
        .bind(movement.item_id)
        .bind(format!("{:?}", movement.movement_type))
        .bind(movement.quantity)
        .bind(movement.unit_cost)
        .bind(movement.date)
        .bind(movement.reference_id)
        .bind(movement.description.as_ref())
        .bind(&movement.hash)
        .bind(&movement.previous_hash)
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    pub async fn get_latest_movement_hash(&self, item_id: Uuid) -> anyhow::Result<String> {
        let row: Option<(String,)> = sqlx::query_as(
            r#"
            SELECT hash FROM stock_movements
            WHERE item_id = $1
            ORDER BY date DESC, created_at DESC
            LIMIT 1
            "#,
        )
        .bind(item_id)
        .fetch_optional(&self.pool)
        .await?;

        Ok(row
            .map(|r| r.0)
            .unwrap_or_else(|| accounting_core::inventory::chain::GENESIS_HASH.to_string()))
    }

    pub async fn get_movements(&self, item_id: Uuid) -> anyhow::Result<Vec<StockMovement>> {
        let rows: Vec<StockMovementRow> = sqlx::query_as(
            r#"
            SELECT id, item_id, movement_type, quantity, unit_cost, date, reference_id, description, hash, previous_hash
            FROM stock_movements
            WHERE item_id = $1
            ORDER BY date ASC
            "#
        )
        .bind(item_id)
        .fetch_all(&self.pool)
        .await?;

        let movements = rows
            .into_iter()
            .map(|r| {
                let movement_type = match r.movement_type.as_str() {
                    "Inbound" => MovementType::Inbound,
                    "Outbound" => MovementType::Outbound,
                    "Impairment" => MovementType::Impairment,
                    _ => MovementType::Adjustment,
                };

                StockMovement {
                    id: r.id,
                    item_id: r.item_id,
                    movement_type,
                    quantity: r.quantity,
                    unit_cost: r.unit_cost,
                    date: r.date,
                    reference_id: r.reference_id,
                    description: r.description,
                    hash: r.hash,
                    previous_hash: r.previous_hash,
                }
            })
            .collect();

        Ok(movements)
    }

    pub async fn get_all_items(&self) -> anyhow::Result<Vec<InventoryItem>> {
        let rows = sqlx::query_as!(
            InventoryItemRow,
            r#"
            SELECT 
                id, code, name_ar, name_en, description, unit, valuation_method,
                purchase_price, sale_price, asset_account_id, cogs_account_id, revenue_account_id,
                created_at, updated_at
            FROM inventory_items
            ORDER BY code ASC
            "#
        )
        .fetch_all(&self.pool)
        .await?;

        let items = rows
            .into_iter()
            .map(|r| {
                let valuation_method = match r.valuation_method.as_str() {
                    "Fifo" => ValuationMethod::Fifo,
                    _ => ValuationMethod::WeightedAverage,
                };

                InventoryItem {
                    id: r.id,
                    code: r.code,
                    name_ar: r.name_ar,
                    name_en: r.name_en,
                    description: r.description,
                    unit: r.unit,
                    valuation_method,
                    purchase_price: r.purchase_price,
                    sale_price: r.sale_price,
                    asset_account_id: r.asset_account_id,
                    cogs_account_id: r.cogs_account_id,
                    revenue_account_id: r.revenue_account_id,
                    created_at: r.created_at,
                    updated_at: r.updated_at,
                }
            })
            .collect();

        Ok(items)
    }

    pub async fn get_valuation_report(
        &self,
        as_of: chrono::DateTime<chrono::Utc>,
    ) -> anyhow::Result<accounting_core::inventory::InventoryValuationReport> {
        use accounting_core::inventory::{
            InventoryService, InventoryValuationReport, ValuationItem,
        };

        let items = self.get_all_items().await?;
        let mut valuation_items = Vec::new();
        let mut total_value = Decimal::ZERO;

        for item in items {
            // Get movements up to as_of
            let rows: Vec<StockMovementRow> = sqlx::query_as(
                r#"
                SELECT id, item_id, movement_type, quantity, unit_cost, date, reference_id, description, hash, previous_hash
                FROM stock_movements
                WHERE item_id = $1 AND date <= $2
                ORDER BY date ASC
                "#
            )
            .bind(item.id)
            .bind(as_of)
            .fetch_all(&self.pool)
            .await?;

            let movements: Vec<StockMovement> = rows
                .into_iter()
                .map(|r| {
                    let movement_type = match r.movement_type.as_str() {
                        "Inbound" => MovementType::Inbound,
                        "Outbound" => MovementType::Outbound,
                        "Impairment" => MovementType::Impairment,
                        _ => MovementType::Adjustment,
                    };

                    StockMovement {
                        id: r.id,
                        item_id: r.item_id,
                        movement_type,
                        quantity: r.quantity,
                        unit_cost: r.unit_cost,
                        date: r.date,
                        reference_id: r.reference_id,
                        description: r.description,
                        hash: r.hash,
                        previous_hash: r.previous_hash,
                    }
                })
                .collect();

            let (qty, val) = InventoryService::calculate_valuation(&item, &movements)?;

            valuation_items.push(ValuationItem {
                item_id: item.id,
                item_name_ar: item.name_ar,
                item_name_en: item.name_en,
                quantity: qty,
                unit_cost: if qty > Decimal::ZERO {
                    (val / qty).round_dp(4)
                } else {
                    Decimal::ZERO
                },
                total_value: val,
            });
            total_value += val;
        }

        Ok(InventoryValuationReport {
            as_of,
            items: valuation_items,
            total_value,
        })
    }
}
