use chrono::{DateTime, Utc};
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq, Eq)]
pub enum ValuationMethod {
    Fifo,
    WeightedAverage,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq, Eq)]
pub enum MovementType {
    Inbound,    // Purchase, Return from Customer
    Outbound,   // Sale, Return to Vendor
    Adjustment, // Inventory count, Loss, Damaged
    Impairment, // IAS 2 Value reduction (LCNRV)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct InventoryItem {
    pub id: Uuid,
    pub code: String,
    pub name_ar: String,
    pub name_en: String,
    pub description: Option<String>,
    pub unit: String,
    pub min_stock_level: Option<Decimal>,
    pub valuation_method: ValuationMethod,
    pub purchase_price: Option<Decimal>,
    pub sale_price: Option<Decimal>,
    pub asset_account_id: Uuid,   // Inventory (1300 typical)
    pub cogs_account_id: Uuid,    // Cost of Goods Sold (5100 typical)
    pub revenue_account_id: Uuid, // Sales Revenue (4100 typical)
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StockMovement {
    pub id: Uuid,
    pub item_id: Uuid,
    pub movement_type: MovementType,
    pub quantity: Decimal,
    pub unit_cost: Decimal,
    pub date: DateTime<Utc>,
    pub reference_id: Option<Uuid>, // Journal Entry ID or Invoice ID
    pub description: Option<String>,
    pub hash: String,
    pub previous_hash: String,
}

impl StockMovement {
    pub fn hashable_content(&self) -> String {
        format!(
            "{}:{}:{:?}:{}:{}:{}:{}:{}",
            self.id,
            self.item_id,
            self.movement_type,
            self.quantity,
            self.unit_cost,
            self.date.to_rfc3339(),
            self.reference_id.map(|u| u.to_string()).unwrap_or_default(),
            self.previous_hash
        )
    }
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct InventoryValuationReport {
    pub as_of: DateTime<Utc>,
    pub items: Vec<ValuationItem>,
    pub total_value: Decimal,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ValuationItem {
    pub item_id: Uuid,
    pub item_name_ar: String,
    pub item_name_en: String,
    pub quantity: Decimal,
    pub unit_cost: Decimal,
    pub total_value: Decimal,
}
