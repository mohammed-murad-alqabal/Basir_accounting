//! Warehouse Transfer Service
//!
//! Handles the business logic for inter-warehouse inventory transfers,
//! including validation, stock movement generation, and journal entry creation.

use crate::inventory::models::{MovementType, StockMovement};
use crate::inventory::warehouse::{TransferStatus, Warehouse, WarehouseTransfer};
use crate::ledger::models::{
    AdjustmentReason, EntryStatus, EntryType, JournalEntry, JournalEntryLine,
    StandardsJustification, TemporalJustification,
};
use chrono::Utc;
use rust_decimal::Decimal;
use uuid::Uuid;

/// Error types for warehouse transfer operations.
#[derive(Debug, Clone)]
pub enum TransferError {
    /// Transfer is not in a valid state for this operation
    InvalidStatus(TransferStatus),
    /// Source and destination are the same warehouse
    SameWarehouse,
    /// No lines in the transfer
    NoLines,
    /// Insufficient stock in source warehouse
    InsufficientStock {
        item_id: Uuid,
        available: Decimal,
        requested: Decimal,
    },
}

impl std::fmt::Display for TransferError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            TransferError::InvalidStatus(s) => write!(f, "Invalid transfer status: {:?}", s),
            TransferError::SameWarehouse => {
                write!(f, "Source and destination warehouses are the same")
            }
            TransferError::NoLines => write!(f, "Transfer has no line items"),
            TransferError::InsufficientStock {
                item_id,
                available,
                requested,
            } => {
                write!(
                    f,
                    "Insufficient stock for item {}: available {}, requested {}",
                    item_id, available, requested
                )
            }
        }
    }
}

impl std::error::Error for TransferError {}

pub struct WarehouseTransferService;

impl WarehouseTransferService {
    /// Validate a transfer before approval.
    pub fn validate(transfer: &WarehouseTransfer) -> Result<(), TransferError> {
        if transfer.source_warehouse_id == transfer.destination_warehouse_id {
            return Err(TransferError::SameWarehouse);
        }

        if transfer.lines.is_empty() {
            return Err(TransferError::NoLines);
        }

        if transfer.status != TransferStatus::Draft && transfer.status != TransferStatus::Pending {
            return Err(TransferError::InvalidStatus(transfer.status));
        }

        Ok(())
    }

    /// Generate the journal entry for a completed warehouse transfer.
    ///
    /// # Accounting Treatment
    /// - Debit: Destination Warehouse Inventory Account (increase asset)
    /// - Credit: Source Warehouse Inventory Account (decrease asset)
    ///
    /// This is an internal asset reallocation with NO P&L impact.
    pub fn generate_transfer_entry(
        transfer: &WarehouseTransfer,
        source_warehouse: &Warehouse,
        destination_warehouse: &Warehouse,
        approver_id: Uuid,
    ) -> Result<JournalEntry, TransferError> {
        Self::validate(transfer)?;

        let mut lines = Vec::new();

        // Debit: Destination Warehouse Inventory
        lines.push(JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: 1,
            account_id: destination_warehouse.asset_account_id,
            partner_id: None,
            debit_amount: transfer.total_value,
            credit_amount: Decimal::ZERO,
            description: format!(
                "Transfer IN from {} - {}",
                source_warehouse.name_en, transfer.transfer_number
            ),
            source_document_ref: Some(transfer.id.to_string()),
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
        });

        // Credit: Source Warehouse Inventory
        lines.push(JournalEntryLine {
            line_id: Uuid::new_v4(),
            line_number: 2,
            account_id: source_warehouse.asset_account_id,
            partner_id: None,
            debit_amount: Decimal::ZERO,
            credit_amount: transfer.total_value,
            description: format!(
                "Transfer OUT to {} - {}",
                destination_warehouse.name_en, transfer.transfer_number
            ),
            source_document_ref: Some(transfer.id.to_string()),
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
        });

        Ok(JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: String::new(),
            description: format!(
                "Warehouse Transfer {} -> {}",
                source_warehouse.name_en, destination_warehouse.name_en
            ),
            entry_type: EntryType::Adjusting,
            status: EntryStatus::Draft,
            linked_entry_id: Some(transfer.id),
            adjustment_reason: Some(AdjustmentReason::Transfer),
            temporal: TemporalJustification {
                transaction_date: transfer.transfer_date.date_naive(),
                effective_date: transfer.transfer_date.date_naive(),
                recording_date: Utc::now(),
            },
            standards: StandardsJustification {
                standard_reference: "IAS 2.6".to_string(),
                recognition_basis: None,
                measurement_basis: None,
                professional_judgment: Some("Inter-warehouse inventory transfer".to_string()),
            },
            lines,
            created_by: approver_id,
            created_at: Utc::now(),
            approved_by: Some(approver_id),
            approved_at: Some(Utc::now()),
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        })
    }

    /// Generate stock movements for both source and destination warehouses.
    pub fn generate_stock_movements(
        transfer: &WarehouseTransfer,
        previous_hash: &str,
    ) -> Vec<StockMovement> {
        let mut movements = Vec::new();
        let mut current_hash = previous_hash.to_string();

        for line in &transfer.lines {
            // Outbound from source
            let outbound = StockMovement {
                id: Uuid::new_v4(),
                item_id: line.item_id,
                movement_type: MovementType::Outbound,
                quantity: line.quantity,
                unit_cost: line.unit_cost,
                date: transfer.transfer_date,
                reference_id: Some(transfer.id),
                description: Some(format!("Transfer OUT: {}", transfer.transfer_number)),
                hash: String::new(),
                previous_hash: current_hash.clone(),
            };
            current_hash = format!("hash_{}", outbound.id); // Placeholder - should use real hash
            movements.push(outbound);

            // Inbound to destination
            let inbound = StockMovement {
                id: Uuid::new_v4(),
                item_id: line.item_id,
                movement_type: MovementType::Inbound,
                quantity: line.quantity,
                unit_cost: line.unit_cost,
                date: transfer.transfer_date,
                reference_id: Some(transfer.id),
                description: Some(format!("Transfer IN: {}", transfer.transfer_number)),
                hash: String::new(),
                previous_hash: current_hash.clone(),
            };
            current_hash = format!("hash_{}", inbound.id);
            movements.push(inbound);
        }

        movements
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn create_test_warehouse(name: &str) -> Warehouse {
        Warehouse {
            id: Uuid::new_v4(),
            code: name.to_uppercase(),
            name_ar: format!("مستودع {}", name),
            name_en: format!("{} Warehouse", name),
            asset_account_id: Uuid::new_v4(),
            is_default: false,
            is_active: true,
            created_at: Utc::now(),
            updated_at: Utc::now(),
        }
    }

    #[test]
    fn test_transfer_validation_same_warehouse() {
        let wh = Uuid::new_v4();
        let transfer = WarehouseTransfer::new(wh, wh, Uuid::new_v4());

        let result = WarehouseTransferService::validate(&transfer);
        assert!(matches!(result, Err(TransferError::SameWarehouse)));
    }

    #[test]
    fn test_transfer_validation_no_lines() {
        let transfer = WarehouseTransfer::new(Uuid::new_v4(), Uuid::new_v4(), Uuid::new_v4());

        let result = WarehouseTransferService::validate(&transfer);
        assert!(matches!(result, Err(TransferError::NoLines)));
    }

    #[test]
    fn test_generate_transfer_entry() {
        let source = create_test_warehouse("Main");
        let dest = create_test_warehouse("Branch");
        let user = Uuid::new_v4();

        let mut transfer = WarehouseTransfer::new(source.id, dest.id, user);
        transfer.transfer_number = "TRF-2026-0001".to_string();
        transfer.add_line(Uuid::new_v4(), Decimal::new(10, 0), Decimal::new(100, 0));

        let entry =
            WarehouseTransferService::generate_transfer_entry(&transfer, &source, &dest, user)
                .unwrap();

        assert_eq!(entry.lines.len(), 2);
        assert_eq!(entry.lines[0].debit_amount, Decimal::new(1000, 0));
        assert_eq!(entry.lines[1].credit_amount, Decimal::new(1000, 0));
        assert!(entry.description.contains("Main"));
        assert!(entry.description.contains("Branch"));
    }

    #[test]
    fn test_generate_stock_movements() {
        let mut transfer = WarehouseTransfer::new(Uuid::new_v4(), Uuid::new_v4(), Uuid::new_v4());
        transfer.add_line(Uuid::new_v4(), Decimal::new(5, 0), Decimal::new(50, 0));
        transfer.add_line(Uuid::new_v4(), Decimal::new(3, 0), Decimal::new(75, 0));

        let movements = WarehouseTransferService::generate_stock_movements(&transfer, "genesis");

        // 2 lines * 2 movements each (outbound + inbound) = 4
        assert_eq!(movements.len(), 4);
        assert!(matches!(movements[0].movement_type, MovementType::Outbound));
        assert!(matches!(movements[1].movement_type, MovementType::Inbound));
    }
}
