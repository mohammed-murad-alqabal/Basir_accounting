use super::get_pool;
use accounting_data::db::periods::PgPeriodRepository;
use chrono::NaiveDate;
use uuid::Uuid;

pub struct PeriodDto {
    pub id: Option<String>,
    pub name: String,
    pub start_date: String,
    pub end_date: String,
    pub status: String,
    pub is_year_end: bool,
}

pub async fn save_period(dto: PeriodDto) -> anyhow::Result<()> {
    let pool = get_pool()?;
    let repo = PgPeriodRepository::new(pool.clone());

    let start = NaiveDate::parse_from_str(&dto.start_date, "%Y-%m-%d")?;
    let end = NaiveDate::parse_from_str(&dto.end_date, "%Y-%m-%d")?;

    let mut period = accounting_core::calendar::FinancialPeriod::new(dto.name, start, end);

    if let Some(id_str) = dto.id {
        period.id = Uuid::parse_str(&id_str)?;
    }

    period.status = match dto.status.as_str() {
        "Locked" => accounting_core::calendar::PeriodStatus::Locked,
        "Closed" => accounting_core::calendar::PeriodStatus::Closed,
        _ => accounting_core::calendar::PeriodStatus::Open,
    };
    period.is_year_end = dto.is_year_end;

    repo.save_period(&period).await?;
    Ok(())
}

pub async fn get_period_by_date(date: String) -> anyhow::Result<Option<PeriodDto>> {
    let pool = get_pool()?;
    let repo = PgPeriodRepository::new(pool.clone());

    let d = NaiveDate::parse_from_str(&date, "%Y-%m-%d")?;

    let period: Option<accounting_core::calendar::FinancialPeriod> =
        repo.get_period_by_date(d).await?;

    Ok(period.map(|p| PeriodDto {
        id: Some(p.id.to_string()),
        name: p.name,
        start_date: p.start_date.to_string(),
        end_date: p.end_date.to_string(),
        status: format!("{:?}", p.status),
        is_year_end: p.is_year_end,
    }))
}

pub async fn close_period(id: String, user_id: String) -> anyhow::Result<()> {
    let pool = get_pool()?;
    let repo = PgPeriodRepository::new(pool.clone());

    let pid = Uuid::parse_str(&id)?;

    repo.close_period(pid, &user_id).await?;
    Ok(())
}

pub async fn list_periods() -> anyhow::Result<Vec<PeriodDto>> {
    let pool = get_pool()?;
    let repo = PgPeriodRepository::new(pool.clone());

    let periods = repo.list_periods().await?;

    Ok(periods
        .into_iter()
        .map(|p| PeriodDto {
            id: Some(p.id.to_string()),
            name: p.name,
            start_date: p.start_date.to_string(),
            end_date: p.end_date.to_string(),
            status: format!("{:?}", p.status),
            is_year_end: p.is_year_end,
        })
        .collect())
}

pub async fn close_financial_year(
    period_id: String,
    closing_date: String,
    retained_earnings_account_id: String,
) -> anyhow::Result<String> {
    let pool = get_pool()?;

    // 1. Parse inputs
    let pid = Uuid::parse_str(&period_id)?;
    let date = NaiveDate::parse_from_str(&closing_date, "%Y-%m-%d")?;
    let retained_earnings_id = Uuid::parse_str(&retained_earnings_account_id)?;
    let user_id = Uuid::nil(); // TODO: Pass user ID from context

    // 2. Fetch Repositories
    let ledger_repo = accounting_data::db::ledger::PgLedgerRepository::new(pool.clone());
    let account_repo = accounting_data::db::accounts::PgAccountRepository::new(pool.clone());
    let period_repo = PgPeriodRepository::new(pool.clone());

    // 3. Fetch Data
    let period = period_repo
        .get_period_by_date(date)
        .await?
        .ok_or_else(|| anyhow::anyhow!("Period not found for date"))?;

    // Fetch entries within the period dates
    let entries = ledger_repo
        .list_entries(
            100000, // Large limit for closing
            0,
            Some(period.start_date),
            Some(period.end_date),
            None,
        )
        .await?;

    // Filter for Posted entries only (ClosingEntryGenerator expects committed numbers)
    let posted_entries: Vec<_> = entries
        .into_iter()
        .filter(|e| e.status == accounting_core::ledger::models::EntryStatus::Posted)
        .collect();

    let accounts = account_repo.list_all().await?;

    // 4. Generate Closing Entry
    let closing_entry =
        accounting_core::ledger::closing::ClosingEntryGenerator::generate_year_end_entry(
            &period.name,
            date,
            &posted_entries,
            &accounts,
            retained_earnings_id,
        );

    // 5. Post Journal Entry
    let metadata = accounting_core::audit::models::AuditMetadata {
        who: accounting_core::audit::models::WhoInfo {
            user_id: user_id,
            user_name: "SYSTEM".to_string(),
            role: "SYSTEM".to_string(),
            session_id: Uuid::new_v4(),
        },
        r#where: accounting_core::audit::models::WhereInfo {
            system_id: "INTERNAL".to_string(),
            ip_address: None,
            location: None,
            device_id: None,
            app_version: None,
        },
        why: accounting_core::audit::models::WhyInfo {
            reason_code: Some("YEAR_END_CLOSE".to_string()),
            justification: Some(format!("Closing Financial Period {}", period.name)),
            authorization_reference: None,
        },
        how: accounting_core::audit::models::HowInfo {
            method: "close_financial_year".to_string(),
            procedure_reference: None,
            api_endpoint: None,
        },
    };

    ledger_repo.post_entry(&closing_entry, &metadata).await?;

    // 6. Close the Period
    period_repo.close_period(pid, &user_id.to_string()).await?;

    Ok(closing_entry.entry_id.to_string())
}
