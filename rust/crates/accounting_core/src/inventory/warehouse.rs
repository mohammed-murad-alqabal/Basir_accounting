//! Warehouse Transfer Module
//!
//! Implements multi-warehouse inventory management with dual-entry accounting
//! for inter-warehouse transfers as specified in file 085 - Inventory Operations List.

use chrono::{DateTime, Utc};
use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

/// Represents a physical storage location for inventory.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Warehouse {
    pub id: Uuid,
    pub code: String,
    pub name_ar: String,
    pub name_en: String,
    /// Reference to the inventory asset account for this warehouse
    pub asset_account_id: Uuid,
    /// Whether this is the default (primary) warehouse
    pub is_default: bool,
    /// Whether the warehouse is active
    pub is_active: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

/// Represents a transfer of inventory between two warehouses.
///
/// # Accounting Treatment
/// A warehouse transfer is an internal movement that does NOT affect P&L.
/// It generates a dual-entry journal:
/// - Debit: Destination Warehouse Inventory Account
/// - Credit: Source Warehouse Inventory Account
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WarehouseTransfer {
    pub id: Uuid,
    /// Sequential transfer number (e.g., "TRF-2026-0001")
    pub transfer_number: String,
    pub source_warehouse_id: Uuid,
    pub destination_warehouse_id: Uuid,
    pub transfer_date: DateTime<Utc>,
    pub status: TransferStatus,
    /// Total value of items being transferred
    pub total_value: Decimal,
    pub lines: Vec<TransferLine>,
    /// Associated journal entry ID (created on approval)
    pub journal_entry_id: Option<Uuid>,
    pub notes: Option<String>,
    pub created_by: Uuid,
    pub created_at: DateTime<Utc>,
    pub approved_by: Option<Uuid>,
    pub approved_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq, Eq)]
pub enum TransferStatus {
    /// Transfer created but not yet submitted
    Draft,
    /// Transfer submitted, awaiting approval
    Pending,
    /// Transfer approved and executed
    Completed,
    /// Transfer cancelled
    Cancelled,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TransferLine {
    pub id: Uuid,
    pub transfer_id: Uuid,
    pub item_id: Uuid,
    pub quantity: Decimal,
    /// Unit cost at time of transfer (for valuation)
    pub unit_cost: Decimal,
    /// Total line value (quantity * unit_cost)
    pub total_value: Decimal,
}

impl WarehouseTransfer {
    /// Create a new draft warehouse transfer.
    pub fn new(
        source_warehouse_id: Uuid,
        destination_warehouse_id: Uuid,
        created_by: Uuid,
    ) -> Self {
        Self {
            id: Uuid::new_v4(),
            transfer_number: String::new(),
            source_warehouse_id,
            destination_warehouse_id,
            transfer_date: Utc::now(),
            status: TransferStatus::Draft,
            total_value: Decimal::ZERO,
            lines: Vec::new(),
            journal_entry_id: None,
            notes: None,
            created_by,
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
        }
    }

    /// Add a line item to the transfer.
    pub fn add_line(&mut self, item_id: Uuid, quantity: Decimal, unit_cost: Decimal) {
        let line_value = (quantity * unit_cost).round_dp(4);
        self.lines.push(TransferLine {
            id: Uuid::new_v4(),
            transfer_id: self.id,
            item_id,
            quantity,
            unit_cost,
            total_value: line_value,
        });
        self.total_value += line_value;
    }

    /// Calculate total value from lines.
    pub fn recalculate_total(&mut self) {
        self.total_value = self.lines.iter().map(|l| l.total_value).sum();
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_warehouse_transfer_creation() {
        let source = Uuid::new_v4();
        let dest = Uuid::new_v4();
        let user = Uuid::new_v4();

        let mut transfer = WarehouseTransfer::new(source, dest, user);
        assert_eq!(transfer.status, TransferStatus::Draft);
        assert_eq!(transfer.total_value, Decimal::ZERO);

        let item_id = Uuid::new_v4();
        transfer.add_line(item_id, Decimal::new(10, 0), Decimal::new(100, 0));

        assert_eq!(transfer.lines.len(), 1);
        assert_eq!(transfer.total_value, Decimal::new(1000, 0));
    }

    #[test]
    fn test_multiple_lines() {
        let source = Uuid::new_v4();
        let dest = Uuid::new_v4();
        let user = Uuid::new_v4();

        let mut transfer = WarehouseTransfer::new(source, dest, user);
        transfer.add_line(Uuid::new_v4(), Decimal::new(5, 0), Decimal::new(200, 0));
        transfer.add_line(Uuid::new_v4(), Decimal::new(10, 0), Decimal::new(50, 0));

        assert_eq!(transfer.lines.len(), 2);
        // 5*200 + 10*50 = 1000 + 500 = 1500
        assert_eq!(transfer.total_value, Decimal::new(1500, 0));
    }
}
