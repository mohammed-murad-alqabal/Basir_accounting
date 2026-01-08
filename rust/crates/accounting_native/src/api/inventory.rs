use crate::api::{get_pool, AuditMetadataDto};
use accounting_core::inventory::models::{
    InventoryItem, MovementType, StockMovement, ValuationMethod,
};
use accounting_core::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
    TemporalJustification,
};
use accounting_data::db::inventory::PgInventoryRepository;
use accounting_data::db::ledger::PgLedgerRepository;
use chrono::Utc;
use rust_decimal::Decimal;
use std::str::FromStr;
use uuid::Uuid;

pub async fn list_items() -> anyhow::Result<Vec<InventoryItemDto>> {
    let pool = get_pool()?.clone();
    let repo = PgInventoryRepository::new(pool);
    let items = repo.get_all_items().await?;
    Ok(items.into_iter().map(InventoryItemDto::from).collect())
}

pub async fn get_item_by_id(id: String) -> anyhow::Result<Option<InventoryItemDto>> {
    let pool = get_pool()?.clone();
    let repo = PgInventoryRepository::new(pool);
    let uuid = Uuid::parse_str(&id)?;
    let item = repo.get_item(uuid).await?;
    Ok(item.map(InventoryItemDto::from))
}

pub async fn save_item(item: InventoryItemDto) -> anyhow::Result<()> {
    let pool = get_pool()?.clone();
    let repo = PgInventoryRepository::new(pool);
    let entity: InventoryItem = item.try_into()?;
    repo.save_item(&entity).await?;
    Ok(())
}

pub async fn record_movement(
    movement: StockMovementDto,
    _metadata: AuditMetadataDto,
) -> anyhow::Result<String> {
    let pool = get_pool()?.clone();
    let repo = PgInventoryRepository::new(pool);
    let mut entity: StockMovement = movement.try_into()?;

    // Calculate hash before saving
    let prev_hash = repo.get_latest_movement_hash(entity.item_id).await?;
    entity.previous_hash = prev_hash;
    entity.hash = accounting_core::inventory::chain::compute_movement_hash(&entity);

    repo.record_movement(&entity).await?;
    Ok(entity.id.to_string())
}

pub async fn record_purchase(
    item_id: String,
    quantity: String,
    unit_cost: String,
    reference_id: Option<String>,
    metadata: AuditMetadataDto,
) -> anyhow::Result<String> {
    let movement = StockMovementDto {
        id: None,
        item_id,
        movement_type: "Inbound".to_string(),
        quantity,
        unit_cost,
        reference_id,
        date: Utc::now().to_rfc3339(),
        description: Some("Purchase Inbound".to_string()),
    };
    record_movement(movement, metadata).await
}

pub async fn record_sale(
    item_id: String,
    quantity: String,
    reference_id: Option<String>,
    metadata: AuditMetadataDto,
) -> anyhow::Result<String> {
    let pool = get_pool()?.clone();
    let repo = PgInventoryRepository::new(pool.clone());
    let ledger_repo = PgLedgerRepository::new(pool);

    let item_uuid = Uuid::parse_str(&item_id)?;
    let qty = Decimal::from_str(&quantity)?;

    let item = repo
        .get_item(item_uuid)
        .await?
        .ok_or_else(|| anyhow::anyhow!("Item not found"))?;

    let movements = repo.get_movements(item_uuid).await?;
    let (_, total_val) =
        accounting_core::inventory::InventoryService::calculate_valuation(&item, &movements)?;
    let total_qty: Decimal = movements
        .iter()
        .map(|m| match m.movement_type {
            MovementType::Inbound | MovementType::Adjustment => m.quantity,
            _ => -m.quantity,
        })
        .sum();

    let unit_cost = if total_qty > Decimal::ZERO {
        total_val / total_qty
    } else {
        Decimal::ZERO
    };

    let movement = StockMovementDto {
        id: None,
        item_id,
        movement_type: "Outbound".to_string(),
        quantity,
        unit_cost: unit_cost.to_string(),
        reference_id,
        date: Utc::now().to_rfc3339(),
        description: Some("Sales Outbound".to_string()),
    };

    let move_id = record_movement(movement, metadata.clone()).await?;

    // Post COGS to Ledger
    let audit_meta: accounting_core::audit::models::AuditMetadata = metadata.try_into()?;
    let cogs_amount = (qty * unit_cost).round_dp(2);

    if cogs_amount > Decimal::ZERO {
        let entry = JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: format!("COGS-{}", move_id.as_str()[..8].to_uppercase()),
            description: format!(
                "Cost of Goods Sold - {} - Period {}",
                item.name_en,
                Utc::now().to_rfc3339()
            ),
            entry_type: EntryType::Standard,
            status: EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(Utc::now().date_naive(), Utc::now().date_naive()),
            standards: StandardsJustification::simple("IFRS 2"),
            lines: vec![
                JournalEntryLine::debit(
                    item.cogs_account_id,
                    cogs_amount,
                    &format!("Cost of Goods Sold - {}", item.name_en),
                ),
                JournalEntryLine::credit(
                    item.asset_account_id,
                    cogs_amount,
                    &format!("Inventory Reduction - {}", item.name_en),
                ),
            ],
            created_by: audit_meta.who.user_id,
            created_at: Utc::now(),
            approved_by: Some(audit_meta.who.user_id),
            approved_at: Some(Utc::now()),
            posted_by: Some(audit_meta.who.user_id),
            posted_at: Some(Utc::now()),
            hash: String::new(),
            previous_hash: String::new(),
        };
        ledger_repo.post_entry(&entry, &audit_meta).await?;
    }

    Ok(move_id)
}

pub async fn record_impairment(
    item_id: String,
    total_impairment_amount: String,
    reference_id: Option<String>,
    metadata: AuditMetadataDto,
) -> anyhow::Result<String> {
    let movement = StockMovementDto {
        id: None,
        item_id,
        movement_type: "Impairment".to_string(),
        quantity: "0".to_string(),
        unit_cost: total_impairment_amount,
        reference_id,
        date: Utc::now().to_rfc3339(),
        description: Some("Inventory Impairment".to_string()),
    };
    record_movement(movement, metadata).await
}

pub async fn verify_inventory_chain(item_id: String) -> anyhow::Result<bool> {
    let pool = get_pool()?.clone();
    let repo = PgInventoryRepository::new(pool);
    let id = Uuid::parse_str(&item_id)?;
    let movements = repo.get_movements(id).await?;
    Ok(accounting_core::inventory::chain::verify_chain(&movements))
}

pub async fn get_valuation_report(as_of: String) -> anyhow::Result<InventoryValuationReportDto> {
    let pool = get_pool()?.clone();
    let repo = PgInventoryRepository::new(pool);
    let as_of_date = chrono::DateTime::parse_from_rfc3339(&as_of)?.with_timezone(&Utc);
    let report = repo.get_valuation_report(as_of_date).await?;
    Ok(InventoryValuationReportDto::from(report))
}

pub async fn list_movements(item_id: String) -> anyhow::Result<Vec<StockMovementDto>> {
    let pool = get_pool()?.clone();
    let repo = PgInventoryRepository::new(pool);
    let id = Uuid::parse_str(&item_id)?;
    let movements = repo.get_movements(id).await?;
    Ok(movements.into_iter().map(StockMovementDto::from).collect())
}

#[derive(Clone)]
pub struct InventoryItemDto {
    pub id: Option<String>,
    pub code: String,
    pub name_ar: String,
    pub name_en: String,
    pub description: Option<String>,
    pub unit: String,
    pub valuation_method: String,
    pub asset_account_id: String,
    pub cogs_account_id: String,
    pub revenue_account_id: String,
}

impl From<InventoryItem> for InventoryItemDto {
    fn from(item: InventoryItem) -> Self {
        Self {
            id: Some(item.id.to_string()),
            code: item.code,
            name_ar: item.name_ar,
            name_en: item.name_en,
            description: None,
            unit: item.unit,
            valuation_method: format!("{:?}", item.valuation_method),
            asset_account_id: item.asset_account_id.to_string(),
            cogs_account_id: item.cogs_account_id.to_string(),
            revenue_account_id: item.revenue_account_id.to_string(),
        }
    }
}

impl TryFrom<InventoryItemDto> for InventoryItem {
    type Error = anyhow::Error;
    fn try_from(dto: InventoryItemDto) -> Result<Self, Self::Error> {
        Ok(Self {
            id: dto
                .id
                .map(|s| Uuid::parse_str(&s))
                .unwrap_or_else(|| Ok(Uuid::new_v4()))?,
            code: dto.code,
            name_ar: dto.name_ar,
            name_en: dto.name_en,
            unit: dto.unit,
            valuation_method: match dto.valuation_method.as_str() {
                "Fifo" => ValuationMethod::Fifo,
                _ => ValuationMethod::WeightedAverage,
            },
            asset_account_id: Uuid::parse_str(&dto.asset_account_id)?,
            cogs_account_id: Uuid::parse_str(&dto.cogs_account_id)?,
            revenue_account_id: Uuid::parse_str(&dto.revenue_account_id)?,
        })
    }
}

pub struct StockMovementDto {
    pub id: Option<String>,
    pub item_id: String,
    pub movement_type: String, // Inbound, Outbound, Adjustment, Impairment
    pub quantity: String,
    pub unit_cost: String,
    pub reference_id: Option<String>,
    pub date: String, // ISO 8601
    pub description: Option<String>,
}

impl From<StockMovement> for StockMovementDto {
    fn from(m: StockMovement) -> Self {
        Self {
            id: Some(m.id.to_string()),
            item_id: m.item_id.to_string(),
            movement_type: format!("{:?}", m.movement_type),
            quantity: m.quantity.to_string(),
            unit_cost: m.unit_cost.to_string(),
            reference_id: m.reference_id.map(|u| u.to_string()),
            date: m.date.to_rfc3339(),
            description: m.description,
        }
    }
}

impl TryFrom<StockMovementDto> for StockMovement {
    type Error = anyhow::Error;
    fn try_from(dto: StockMovementDto) -> Result<Self, Self::Error> {
        use chrono::{DateTime, Utc};
        Ok(Self {
            id: dto
                .id
                .map(|s| Uuid::parse_str(&s))
                .unwrap_or_else(|| Ok(Uuid::new_v4()))?,
            item_id: Uuid::parse_str(&dto.item_id)?,
            movement_type: match dto.movement_type.as_str() {
                "Inbound" => MovementType::Inbound,
                "Outbound" => MovementType::Outbound,
                "Adjustment" => MovementType::Adjustment,
                "Impairment" => MovementType::Impairment,
                _ => MovementType::Adjustment,
            },
            quantity: Decimal::from_str(&dto.quantity).unwrap_or(Decimal::ZERO),
            unit_cost: Decimal::from_str(&dto.unit_cost).unwrap_or(Decimal::ZERO),
            date: DateTime::parse_from_rfc3339(&dto.date)
                .map(|dt| dt.with_timezone(&Utc))
                .unwrap_or_else(|_| Utc::now()),
            reference_id: dto.reference_id.map(|s| Uuid::parse_str(&s)).transpose()?,
            description: dto.description,
            hash: String::new(),
            previous_hash: String::new(),
        })
    }
}

pub struct InventoryValuationReportDto {
    pub as_of: String,
    pub items: Vec<ValuationItemDto>,
    pub total_value: String,
}

pub struct ValuationItemDto {
    pub item_id: String,
    pub item_name_ar: String,
    pub item_name_en: String,
    pub quantity: String,
    pub unit_cost: String,
    pub total_value: String,
}

impl From<accounting_core::inventory::InventoryValuationReport> for InventoryValuationReportDto {
    fn from(r: accounting_core::inventory::InventoryValuationReport) -> Self {
        Self {
            as_of: r.as_of.to_rfc3339(),
            total_value: r.total_value.to_string(),
            items: r
                .items
                .into_iter()
                .map(|i| ValuationItemDto {
                    item_id: i.item_id.to_string(),
                    item_name_ar: i.item_name_ar,
                    item_name_en: i.item_name_en,
                    quantity: i.quantity.to_string(),
                    unit_cost: i.unit_cost.to_string(),
                    total_value: i.total_value.to_string(),
                })
                .collect(),
        }
    }
}
