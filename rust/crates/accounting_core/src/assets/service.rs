use super::models::{AssetCategory, AssetError, FixedAsset};
use crate::ledger::models::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
    TemporalJustification,
};
use chrono::{NaiveDate, Utc};
use rust_decimal::Decimal;
use uuid::Uuid;

pub struct AssetService {
    // In a real implementation, this would hold repository references
}

impl AssetService {
    pub fn new() -> Self {
        Self {}
    }

    pub async fn register_asset(&self, asset: FixedAsset) -> Result<Uuid, AssetError> {
        // Placeholder for logic
        Ok(asset.id)
    }

    pub async fn calculate_depreciation(&self, _asset_id: Uuid) -> Result<(), AssetError> {
        // Placeholder for logic
        Ok(())
    }

    /// Creates a Journal Entry for Asset Acquisition.
    /// Dr Asset Account (Cost)
    /// Cr Source Account (Cash/AP)
    pub fn create_acquisition_entry(
        &self,
        asset: &FixedAsset,
        asset_account_id: Uuid,
        credit_account_id: Uuid,
        description: String,
        created_by: Uuid,
    ) -> Result<JournalEntry, AssetError> {
        let entry_id = Uuid::new_v4();
        let lines = vec![
            // Debit Asset
            JournalEntryLine {
                line_id: Uuid::new_v4(),
                line_number: 1,
                account_id: asset_account_id,
                debit_amount: asset.cost,
                credit_amount: Decimal::ZERO,
                description: description.clone(),
                source_document_ref: Some(asset.code.clone()),
                original_currency: None, // Assuming functional currency for now
                exchange_rate: None,
                original_amount: None,
                partner_id: None,
            },
            // Credit Payment Source
            JournalEntryLine::credit(credit_account_id, asset.cost, &description),
        ];

        let entry = JournalEntry {
            entry_id,
            entry_number: format!("ASSET-ACQ-{}", asset.code), // Placeholder numbering
            description,
            entry_type: EntryType::Standard,
            status: EntryStatus::Draft,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: TemporalJustification::new(asset.acquisition_date, asset.acquisition_date),
            standards: StandardsJustification::simple("IAS 16.7"), // Recognition of Cost
            lines,
            created_by,
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        };

        Ok(entry)
    }

    /// Creates a Journal Entry for Depreciation.
    /// Dr Depreciation Expense
    /// Cr Accumulated Depreciation
    pub fn create_depreciation_entry(
        &self,
        asset: &FixedAsset,
        category: &AssetCategory,
        amount: Decimal,
        period_end: NaiveDate,
        created_by: Uuid,
    ) -> Result<JournalEntry, AssetError> {
        let expense_account = category.depreciation_account_id.ok_or_else(|| {
            AssetError::DepreciationError("Missing depreciation account in category".to_string())
        })?;

        let accum_account = category.accum_depreciation_account_id.ok_or_else(|| {
            AssetError::DepreciationError(
                "Missing accumulated depreciation account in category".to_string(),
            )
        })?;

        let description = format!("Depreciation for {} - {}", asset.code, period_end);

        let lines = vec![
            // Debit Expense
            JournalEntryLine {
                line_id: Uuid::new_v4(),
                line_number: 1,
                account_id: expense_account,
                description: description.clone(),
                debit_amount: amount,
                credit_amount: Decimal::ZERO,
                source_document_ref: Some(asset.code.clone()),
                original_currency: None,
                exchange_rate: None,
                original_amount: None,
                partner_id: None,
            },
            // Credit Accumulated Depreciation
            JournalEntryLine::credit(accum_account, amount, &description),
        ];

        let entry = JournalEntry {
            entry_id: Uuid::new_v4(),
            entry_number: format!("DEPR-{}-{}", asset.code, period_end.format("%Y%m")),
            description,
            entry_type: EntryType::Adjusting, // Depreciation is an adjustment
            status: EntryStatus::Draft,
            linked_entry_id: None,
            adjustment_reason: Some(crate::ledger::models::AdjustmentReason::Accrual), // Or Depreciation if enum existed, Accrual close enough
            temporal: TemporalJustification::new(period_end, period_end),
            standards: StandardsJustification::simple("IAS 16.43"), // Depreciation Charge
            lines,
            created_by,
            created_at: Utc::now(),
            approved_by: None,
            approved_at: None,
            posted_by: None,
            posted_at: None,
            hash: String::new(),
            previous_hash: String::new(),
        };

        Ok(entry)
    }
}
