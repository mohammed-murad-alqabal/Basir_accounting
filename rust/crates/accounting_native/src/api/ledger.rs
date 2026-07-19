use crate::api::{get_pool, AuditMetadataDto};
use accounting_core::{
    accounts::registry::AccountRegistry, standards::registry::StandardsRegistry,
    validate_for_posting, EntryStatus, EntryType, JournalEntry, JournalEntryLine,
    StandardsJustification, TemporalJustification,
};
use accounting_data::db::accounts::PgAccountRepository;
use accounting_data::db::ledger::PgLedgerRepository;
use accounting_data::db::standards::PgStandardsRepository;
use rust_decimal::Decimal;
use std::str::FromStr;
use uuid::Uuid;

// DTOs to receive from Flutter
pub struct LineDto {
    pub account_id: String,
    pub amount: String, // System currency amount
    pub is_debit: bool,
    pub description: String,

    // Multi-currency support
    pub original_currency: Option<String>,
    pub exchange_rate: Option<String>,
    pub original_amount: Option<String>,
}

pub struct EntryDto {
    pub entry_id: Option<String>,
    pub entry_number: String,
    pub description: String,
    pub date: String, // ISO 8601
    pub standard_ref: String,
    pub lines: Vec<LineDto>,
    pub linked_entry_id: Option<String>,
    pub adjustment_reason: Option<String>,
}

/// Validate a journal entry (CP-001, CP-002, CP-010)
pub async fn validate_journal_entry(dto: EntryDto) -> anyhow::Result<()> {
    let pool = get_pool()?;

    let standards_repo = PgStandardsRepository::new(pool.clone());
    let standards: Vec<accounting_core::standards::models::StandardEntry> =
        standards_repo.load_all().await?;
    let registry = StandardsRegistry::from_entries(standards);

    let account_repo = PgAccountRepository::new(pool.clone());
    let accounts: Vec<accounting_core::accounts::models::Account> = account_repo.list_all().await?;
    let account_registry = AccountRegistry::new(accounts);

    let entry = map_dto_to_entity(dto)?;

    validate_for_posting(&entry, &registry, &account_registry)?;
    Ok(())
}

/// List journal entries with pagination
pub async fn list_journal_entries(
    limit: i64,
    offset: i64,
    from_date: Option<String>,
    to_date: Option<String>,
    account_id: Option<String>,
) -> anyhow::Result<Vec<EntryDto>> {
    let pool = get_pool()?;
    let ledger_repo = PgLedgerRepository::new(pool.clone());

    let from = from_date.and_then(|d| chrono::NaiveDate::parse_from_str(&d, "%Y-%m-%d").ok());
    let to = to_date.and_then(|d| chrono::NaiveDate::parse_from_str(&d, "%Y-%m-%d").ok());
    let acc_id = account_id.and_then(|id| Uuid::parse_str(&id).ok());

    let entries = ledger_repo
        .list_entries(limit, offset, from, to, acc_id)
        .await?;

    Ok(entries.into_iter().map(map_entity_to_dto).collect())
}

/// Post a journal entry to the database
pub async fn post_journal_entry(
    dto: EntryDto,
    metadata: AuditMetadataDto,
) -> anyhow::Result<String> {
    let pool = get_pool()?;
    let ledger_repo = PgLedgerRepository::new(pool.clone());
    let standards_repo = PgStandardsRepository::new(pool.clone());

    let _registry: Vec<accounting_core::standards::models::StandardEntry> =
        standards_repo.load_all().await?;
    let mut entry = map_dto_to_entity(dto)?;

    // Set to posted before saving (or let repository handle it)
    entry.status = EntryStatus::Posted;

    let audit_meta: accounting_core::audit::models::AuditMetadata = metadata.try_into()?;

    ledger_repo.post_entry(&entry, &audit_meta).await?;

    Ok(entry.entry_id.to_string())
}

/// Reverse a journal entry
pub async fn reverse_journal_entry(
    entry_id: String,
    reason: String,
    metadata: AuditMetadataDto,
) -> anyhow::Result<String> {
    let pool = get_pool()?;
    let ledger_repo = PgLedgerRepository::new(pool.clone());

    let entry_id_uuid = Uuid::parse_str(&entry_id)?;
    let audit_meta: accounting_core::audit::models::AuditMetadata = metadata.try_into()?;

    let reversal_id: Uuid = ledger_repo
        .reverse_entry(entry_id_uuid, &reason, &audit_meta)
        .await?;

    Ok(reversal_id.to_string())
}

/// Log the cognitive agent consensus for a journal entry
pub async fn log_agent_consensus(
    entry_id: String,
    consensus_json: String,
    metadata: AuditMetadataDto,
) -> anyhow::Result<()> {
    let pool = get_pool()?;
    let ledger_repo = PgLedgerRepository::new(pool.clone());

    let entry_id_uuid = Uuid::parse_str(&entry_id)?;
    let audit_meta: accounting_core::audit::models::AuditMetadata = metadata.try_into()?;

    ledger_repo
        .log_agent_consensus(entry_id_uuid, &consensus_json, &audit_meta)
        .await?;

    Ok(())
}

/// Retrieve the cognitive agent consensus for a journal entry
pub async fn get_agent_consensus(entry_id: String) -> anyhow::Result<Option<String>> {
    let pool = get_pool()?;
    let ledger_repo = PgLedgerRepository::new(pool.clone());

    let entry_id_uuid = Uuid::parse_str(&entry_id)?;
    ledger_repo.get_agent_consensus(entry_id_uuid).await
}

/// List all audit records for a specific entity
pub async fn list_audit_logs(entity_id: String) -> anyhow::Result<Vec<crate::api::AuditRecordDto>> {
    let pool = get_pool()?;
    let ledger_repo = PgLedgerRepository::new(pool.clone());

    let entity_id_uuid = Uuid::parse_str(&entity_id)?;
    let records = ledger_repo.get_audit_records(entity_id_uuid).await?;

    Ok(records
        .into_iter()
        .map(crate::api::map_audit_record_to_dto)
        .collect())
}

// Helper to map DTO to Core Entity
pub(crate) fn map_dto_to_entity(dto: EntryDto) -> anyhow::Result<JournalEntry> {
    let date = chrono::DateTime::parse_from_rfc3339(&dto.date)?.with_timezone(&chrono::Utc);

    let entry_id = match dto.entry_id {
        Some(id_str) => Uuid::parse_str(&id_str)
            .map_err(|e| anyhow::anyhow!("Failed to parse entry_id '{}': {}", id_str, e))?,
        None => Uuid::new_v4(),
    };

    let user_id = Uuid::new_v4(); // Current user should be in AuditMetadata

    let mut lines = Vec::new();
    for line in dto.lines {
        let account_id = Uuid::parse_str(&line.account_id)?;
        let amount = Decimal::from_str(&line.amount)?;

        let mut core_line = if line.is_debit {
            JournalEntryLine::debit(account_id, amount, &line.description)
        } else {
            JournalEntryLine::credit(account_id, amount, &line.description)
        };

        core_line.original_currency = line.original_currency;
        core_line.exchange_rate = line.exchange_rate.and_then(|s| Decimal::from_str(&s).ok());
        core_line.original_amount = line
            .original_amount
            .and_then(|s| Decimal::from_str(&s).ok());

        lines.push(core_line);
    }

    let linked_entry_id = dto
        .linked_entry_id
        .map(|id| Uuid::parse_str(&id))
        .transpose()?;

    let adjustment_reason = dto.adjustment_reason.as_deref().and_then(|r| match r {
        "Correction" => Some(accounting_core::ledger::models::AdjustmentReason::Correction),
        "Reclassification" => {
            Some(accounting_core::ledger::models::AdjustmentReason::Reclassification)
        }
        "Accrual" => Some(accounting_core::ledger::models::AdjustmentReason::Accrual),
        "Deferral" => Some(accounting_core::ledger::models::AdjustmentReason::Deferral),
        "EstimationChange" => {
            Some(accounting_core::ledger::models::AdjustmentReason::EstimationChange)
        }
        "PolicyChange" => Some(accounting_core::ledger::models::AdjustmentReason::PolicyChange),
        _ => None,
    });

    Ok(JournalEntry {
        entry_id,
        entry_number: dto.entry_number,
        description: dto.description,
        entry_type: EntryType::Standard,
        status: EntryStatus::Draft,
        linked_entry_id,
        adjustment_reason,
        temporal: TemporalJustification::new(date.date_naive(), date.date_naive()),
        standards: StandardsJustification::simple(&dto.standard_ref),
        lines,
        created_by: user_id,
        created_at: chrono::Utc::now(),
        approved_by: None,
        approved_at: None,
        posted_by: None,
        posted_at: None,
        hash: String::new(),
        previous_hash: String::new(),
    })
}

fn map_entity_to_dto(entry: accounting_core::ledger::models::JournalEntry) -> EntryDto {
    EntryDto {
        entry_id: Some(entry.entry_id.to_string()),
        entry_number: entry.entry_number,
        description: entry.description,
        date: entry
            .temporal
            .transaction_date
            .format("%Y-%m-%d")
            .to_string(),
        standard_ref: entry.standards.standard_reference,
        lines: entry
            .lines
            .into_iter()
            .map(|l| LineDto {
                account_id: l.account_id.to_string(),
                amount: l.debit_amount.max(l.credit_amount).to_string(),
                is_debit: !l.debit_amount.is_zero(),
                description: l.description,
                original_currency: l.original_currency,
                exchange_rate: l.exchange_rate.map(|d| d.to_string()),
                original_amount: l.original_amount.map(|d| d.to_string()),
            })
            .collect(),
        linked_entry_id: entry.linked_entry_id.map(|u| u.to_string()),
        adjustment_reason: entry.adjustment_reason.map(|r| format!("{:?}", r)),
    }
}
