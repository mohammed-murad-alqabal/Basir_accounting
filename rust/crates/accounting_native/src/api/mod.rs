pub mod accounts;
pub mod assets;
pub mod auditor;
pub mod calendar;
pub mod currency;
pub mod inventory;
pub mod ledger;
pub mod purchasing;
pub mod reports;
pub mod sales;
pub mod standards;
pub mod zatca;

// Specific re-exports for API functions and DTOs
pub use accounts::{create_account, get_account_by_id, list_accounts, AccountDto};
pub use assets::{get_asset_by_id, list_assets, register_asset, run_depreciation_cycle, AssetDto};
pub use auditor::{scan_sequence, AnomalyDto};
pub use calendar::{close_period, get_period_by_date, save_period, PeriodDto};
pub use currency::{get_exchange_rate, save_exchange_rate, ExchangeRateDto};
pub use inventory::{
    get_item_by_id, get_valuation_report, list_items, list_movements, record_impairment,
    record_movement, record_purchase, record_sale, save_item, verify_inventory_chain,
    InventoryItemDto, InventoryValuationReportDto, StockMovementDto, ValuationItemDto,
};
pub use ledger::{
    get_agent_consensus, list_audit_logs, log_agent_consensus, post_journal_entry,
    reverse_journal_entry, validate_journal_entry, EntryDto, LineDto,
};
pub use purchasing::{
    create_vendor, delete_bill, delete_vendor, get_purchase_bill_by_id, get_vendor_by_id,
    list_purchase_bills, list_vendors, record_bill_payment, update_vendor, BillPaymentDto,
    PurchaseBillDto, VendorDto,
};
pub use reports::{
    generate_balance_sheet, generate_cash_flow_statement, generate_income_statement,
    generate_trial_balance, generate_zakah_statement, get_account_entries, DrillDownEntryDto,
    FinancialReportDto, FinancialReportLineDto, TrialBalanceDto, TrialBalanceLineDto,
};
pub use sales::{
    create_customer, create_invoice, delete_customer, delete_invoice, get_invoice_by_id,
    list_customers, list_invoices, record_customer_payment, update_customer, CustomerDto,
    CustomerPaymentDto, SalesInvoiceDto, SalesInvoiceLineDto,
};
pub use standards::{get_standard_info, search_standards, StandardDto};
pub use zatca::{
    generate_zatca_csr, generate_zatca_key_pair, generate_zatca_signed_xml, ZatcaCsrInputDto,
    ZatcaInvoiceInputDto, ZatcaInvoiceLineDto, ZatcaPartyDto,
};

use flutter_rust_bridge::frb;
use sqlx::PgPool;
use std::sync::OnceLock;

static DB_POOL: OnceLock<PgPool> = OnceLock::new();

/// Initialize the native API with a database connection.
pub async fn init_api(database_url: String) -> anyhow::Result<()> {
    if DB_POOL.get().is_some() {
        return Ok(());
    }

    let pool = PgPool::connect(&database_url).await?;

    // Run migrations automatically
    sqlx::migrate!("../../migrations")
        .run(&pool)
        .await
        .map_err(|e| anyhow::anyhow!("Failed to run migrations: {}", e))?;

    if DB_POOL.set(pool).is_err() {
        // Race condition or re-entry, but we checked get() so this is unlikely unless concurrent init.
        // We can assume it's fine.
        return Ok(());
    }
    Ok(())
}

/// Internal helper to get the database pool.
pub(crate) fn get_pool() -> anyhow::Result<&'static PgPool> {
    DB_POOL
        .get()
        .ok_or_else(|| anyhow::anyhow!("Database not initialized. Call init_api first."))
}

#[frb(sync)]
pub fn check_health() -> bool {
    true
}

// --- Shared DTOs for Audit Metadata ---

#[derive(Clone)]
pub struct WhoDto {
    pub user_id: String,
    pub user_name: String,
    pub role: String,
    pub session_id: String,
}

#[derive(Clone)]
pub struct WhereDto {
    pub system_id: String,
    pub ip_address: Option<String>,
    pub location: Option<String>,
    pub device_id: Option<String>,
    pub app_version: Option<String>,
}

#[derive(Clone)]
pub struct WhyDto {
    pub reason_code: Option<String>,
    pub justification: Option<String>,
    pub authorization_reference: Option<String>,
}

#[derive(Clone)]
pub struct HowDto {
    pub method: String,
    pub procedure_reference: Option<String>,
    pub api_endpoint: Option<String>,
}

#[derive(Clone)]
pub struct AuditMetadataDto {
    pub who: WhoDto,
    pub r#where: WhereDto,
    pub why: WhyDto,
    pub how: HowDto,
}

#[derive(Clone)]
pub struct WhatDto {
    pub action: String,
    pub entity_type: String,
    pub entity_id: String,
    pub change_description: String,
    pub old_value: Option<String>,
    pub new_value: Option<String>,
}

#[derive(Clone)]
pub struct AuditRecordDto {
    pub record_id: String,
    pub who: WhoDto,
    pub what: WhatDto,
    pub when: String, // ISO 8601
    pub r#where: WhereDto,
    pub why: WhyDto,
    pub how: HowDto,
    pub hash: String,
    pub previous_hash: String,
    pub is_verified: bool,
}

impl TryFrom<AuditMetadataDto> for accounting_core::audit::models::AuditMetadata {
    type Error = anyhow::Error;

    fn try_from(dto: AuditMetadataDto) -> Result<Self, Self::Error> {
        use accounting_core::audit::models::*;
        use uuid::Uuid;

        Ok(AuditMetadata {
            who: WhoInfo {
                user_id: Uuid::parse_str(&dto.who.user_id)?,
                user_name: dto.who.user_name,
                role: dto.who.role,
                session_id: Uuid::parse_str(&dto.who.session_id)?,
            },
            r#where: WhereInfo {
                system_id: dto.r#where.system_id,
                ip_address: dto.r#where.ip_address,
                location: dto.r#where.location,
                device_id: dto.r#where.device_id,
                app_version: dto.r#where.app_version,
            },
            why: WhyInfo {
                reason_code: dto.why.reason_code,
                justification: dto.why.justification,
                authorization_reference: <credential-fixture>,
            },
            how: HowInfo {
                method: dto.how.method,
                procedure_reference: dto.how.procedure_reference,
                api_endpoint: <credential-fixture>,
            },
        })
    }
}

pub(crate) fn map_audit_record_to_dto(
    record: accounting_core::audit::models::AuditRecord,
) -> AuditRecordDto {
    let is_verified = record.verify();
    AuditRecordDto {
        record_id: record.record_id.to_string(),
        who: WhoDto {
            user_id: record.who.user_id.to_string(),
            user_name: record.who.user_name,
            role: record.who.role,
            session_id: record.who.session_id.to_string(),
        },
        what: WhatDto {
            action: format!("{:?}", record.what.action),
            entity_type: record.what.entity_type,
            entity_id: record.what.entity_id.to_string(),
            change_description: record.what.change_description,
            old_value: record.what.old_value,
            new_value: record.what.new_value,
        },
        when: record.when.to_rfc3339(),
        r#where: WhereDto {
            system_id: record.r#where.system_id,
            ip_address: record.r#where.ip_address,
            location: record.r#where.location,
            device_id: record.r#where.device_id,
            app_version: record.r#where.app_version,
        },
        why: WhyDto {
            reason_code: record.why.reason_code,
            justification: record.why.justification,
            authorization_reference: <credential-fixture>,
        },
        how: HowDto {
            method: record.how.method,
            procedure_reference: record.how.procedure_reference,
            api_endpoint: <credential-fixture>,
        },
        hash: record.hash,
        previous_hash: record.previous_hash,
        is_verified,
    }
}
