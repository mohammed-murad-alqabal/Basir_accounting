use super::get_pool;
use accounting_data::db::currency::PgExchangeRateRepository;
use chrono::NaiveDate;
use rust_decimal::Decimal;
use std::str::FromStr;

pub struct ExchangeRateDto {
    pub base_currency: String,
    pub target_currency: String,
    pub rate: String,
    pub effective_date: String,
    pub source: Option<String>,
}

pub async fn save_exchange_rate(dto: ExchangeRateDto) -> anyhow::Result<()> {
    let pool = get_pool()?;
    let repo = PgExchangeRateRepository::new(pool.clone());

    let rate_dec = Decimal::from_str(&dto.rate)?;
    let date = NaiveDate::parse_from_str(&dto.effective_date, "%Y-%m-%d")?;

    let rate = accounting_core::currency::ExchangeRate::new(
        dto.base_currency,
        dto.target_currency,
        rate_dec,
        date,
        dto.source,
    )?;

    repo.save_rate(&rate).await?;
    Ok(())
}

pub async fn get_exchange_rate(
    base: String,
    target: String,
    date: String,
) -> anyhow::Result<Option<ExchangeRateDto>> {
    let pool = get_pool()?;
    let repo = PgExchangeRateRepository::new(pool.clone());

    let d = NaiveDate::parse_from_str(&date, "%Y-%m-%d")?;

    let rate: Option<accounting_core::currency::ExchangeRate> =
        repo.get_rate(&base, &target, d).await?;

    Ok(rate.map(|r| ExchangeRateDto {
        base_currency: r.base_currency,
        target_currency: r.target_currency,
        rate: r.rate.to_string(),
        effective_date: r.effective_date.to_string(),
        source: r.source,
    }))
}

pub async fn list_exchange_rates(
    base: Option<String>,
    target: Option<String>,
) -> anyhow::Result<Vec<ExchangeRateDto>> {
    let pool = get_pool()?;
    let repo = PgExchangeRateRepository::new(pool.clone());

    let rates = repo.list_rates(base.as_deref(), target.as_deref()).await?;

    Ok(rates
        .into_iter()
        .map(|r| ExchangeRateDto {
            base_currency: r.base_currency,
            target_currency: r.target_currency,
            rate: r.rate.to_string(),
            effective_date: r.effective_date.to_string(),
            source: r.source,
        })
        .collect())
}

pub async fn perform_revaluation(
    date: String,
    system_base: String,
    unrealized_gain_loss_account_id: String,
    metadata: crate::api::AuditMetadataDto,
) -> anyhow::Result<String> {
    let pool = get_pool()?;
    let currency_repo = PgExchangeRateRepository::new(pool.clone());
    use accounting_data::db::ledger::PgLedgerRepository;
    let ledger_repo = PgLedgerRepository::new(pool.clone());

    let as_of = NaiveDate::parse_from_str(&date, "%Y-%m-%d")?;
    let gain_loss_id = uuid::Uuid::parse_str(&unrealized_gain_loss_account_id)?;
    let audit_meta: accounting_core::audit::models::AuditMetadata = metadata.try_into()?;

    let adjustments = currency_repo
        .calculate_revaluation_adjustments(as_of, &system_base)
        .await?;

    if adjustments.is_empty() {
        return Ok("No adjustments required".to_string());
    }

    let mut lines = Vec::new();
    let mut line_number = 1;

    for adj in adjustments {
        let amount = adj.adjustment_amount.abs();

        // Line 1: Adjust the Asset/Liability Account
        lines.push(accounting_core::ledger::models::JournalEntryLine {
            line_id: uuid::Uuid::new_v4(),
            line_number,
            account_id: adj.account_id,
            // If Gain on Asset (positive adjustment) -> Debit Asset
            // If Loss on Asset (negative adjustment) -> Credit Asset
            // (Assuming standard behavior, adjustment_amount = market - book)
            debit_amount: if adj.adjustment_amount > Decimal::ZERO {
                amount
            } else {
                Decimal::ZERO
            },
            credit_amount: if adj.adjustment_amount < Decimal::ZERO {
                amount
            } else {
                Decimal::ZERO
            },
            description: format!(
                "Revaluation {} (Rate: {})",
                adj.original_currency, adj.exchange_rate
            ),
            source_document_ref: None,
            original_currency: Some(adj.original_currency.clone()),
            exchange_rate: Some(adj.exchange_rate),
            original_amount: Some(Decimal::ZERO), // Adjustment has 0 foreign impact, only base
            partner_id: None,
        });
        line_number += 1;

        // Line 2: Offset to Unrealized Gain/Loss
        lines.push(accounting_core::ledger::models::JournalEntryLine {
            line_id: uuid::Uuid::new_v4(),
            line_number,
            account_id: gain_loss_id,
            // If Gain on Asset -> Credit Gain/Loss
            // If Loss on Asset -> Debit Gain/Loss
            debit_amount: if adj.adjustment_amount < Decimal::ZERO {
                amount
            } else {
                Decimal::ZERO
            },
            credit_amount: if adj.adjustment_amount > Decimal::ZERO {
                amount
            } else {
                Decimal::ZERO
            },
            description: format!("Unrealized G/L - {}", adj.original_currency),
            source_document_ref: None,
            original_currency: None,
            exchange_rate: None,
            original_amount: None,
            partner_id: None,
        });
        line_number += 1;
    }

    let entry_id = uuid::Uuid::new_v4();
    let entry = accounting_core::ledger::models::JournalEntry {
        entry_id,
        entry_number: format!("REV-{}", as_of.format("%Y%m%d")),
        description: format!("Currency Revaluation as of {}", as_of),
        entry_type: accounting_core::ledger::models::EntryType::Adjusting,
        status: accounting_core::ledger::models::EntryStatus::Posted,
        linked_entry_id: None,
        adjustment_reason: Some(
            accounting_core::ledger::models::AdjustmentReason::EstimationChange,
        ),
        temporal: accounting_core::ledger::models::TemporalJustification::new(as_of, as_of),
        standards: accounting_core::ledger::models::StandardsJustification::simple("IAS 21"),
        lines,
        created_by: audit_meta.who.user_id,
        created_at: chrono::Utc::now(),
        approved_by: Some(audit_meta.who.user_id),
        approved_at: Some(chrono::Utc::now()),
        posted_by: Some(audit_meta.who.user_id),
        posted_at: Some(chrono::Utc::now()),
        hash: String::new(),
        previous_hash: String::new(),
    };

    ledger_repo.post_entry(&entry, &audit_meta).await?;

    Ok(entry_id.to_string())
}
