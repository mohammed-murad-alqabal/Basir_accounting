use crate::api::get_pool;
use accounting_core::reporting::zakah::ZakahCalendarType;
use accounting_core::reporting::{FinancialReport, TrialBalance};
use accounting_data::db::reporting::PgReportingRepository;
use chrono::NaiveDate;
use flutter_rust_bridge::frb;
use uuid::Uuid;

#[frb]
pub enum ZakahCalendarDto {
    Hijri,
    Gregorian,
}

pub struct TrialBalanceLineDto {
    pub account_id: String,
    pub account_code: String,
    pub account_name: String,
    pub debit_balance: String,
    pub credit_balance: String,
}

pub struct TrialBalanceDto {
    pub as_of_date: String,
    pub period_start: Option<String>,
    pub period_end: String,
    pub lines: Vec<TrialBalanceLineDto>,
    pub total_debits: String,
    pub total_credits: String,
    pub is_balanced: bool,
}

pub struct FinancialReportLineDto {
    pub label: String,
    pub amount: String,
    pub is_title: bool,
    pub is_total: bool,
    pub indent_level: i32,
}

pub struct FinancialReportDto {
    pub title: String,
    pub from_date: String,
    pub to_date: String,
    pub lines: Vec<FinancialReportLineDto>,
    pub generated_at: String,
}

pub struct DrillDownEntryDto {
    pub entry_id: String,
    pub entry_number: String,
    pub effective_date: String,
    pub description: String,
    pub debit: String,
    pub credit: String,
    pub standard_reference: Option<String>,
}

/// Generate a trial balance (Task 16.1, 16.2)
pub async fn generate_trial_balance(
    as_of_date: String,
    period_start: Option<String>,
) -> anyhow::Result<TrialBalanceDto> {
    let pool = get_pool()?;
    let repo = PgReportingRepository::new(pool.clone());

    let date = NaiveDate::parse_from_str(&as_of_date, "%Y-%m-%d")?;
    let start_date = match period_start {
        Some(ref s) => Some(NaiveDate::parse_from_str(s, "%Y-%m-%d")?),
        None => None,
    };

    let tb: TrialBalance = repo.generate_trial_balance(date, start_date).await?;

    Ok(TrialBalanceDto {
        as_of_date: tb.as_of_date.to_string(),
        period_start: tb.period_start.map(|d| d.to_string()),
        period_end: tb.period_end.to_string(),
        lines: tb
            .lines
            .into_iter()
            .map(|l| TrialBalanceLineDto {
                account_id: l.account_id.to_string(),
                account_code: l.account_code,
                account_name: l.account_name,
                debit_balance: l.debit_balance.to_string(),
                credit_balance: l.credit_balance.to_string(),
            })
            .collect(),
        total_debits: tb.total_debits.to_string(),
        total_credits: tb.total_credits.to_string(),
        is_balanced: tb.is_balanced,
    })
}

/// Drill down into account entries (Task 16.3)
pub async fn get_account_entries(
    account_id: String,
    period_start: Option<String>,
    period_end: String,
) -> anyhow::Result<Vec<DrillDownEntryDto>> {
    let pool = get_pool()?;
    let repo = PgReportingRepository::new(pool.clone());

    let id = Uuid::parse_str(&account_id)?;
    let start = match period_start {
        Some(ref s) => Some(NaiveDate::parse_from_str(s, "%Y-%m-%d")?),
        None => None,
    };
    let end = NaiveDate::parse_from_str(&period_end, "%Y-%m-%d")?;

    let entries = repo.get_account_entries(id, start, end).await?;

    Ok(entries
        .into_iter()
        .map(|e| DrillDownEntryDto {
            entry_id: e.entry_id.to_string(),
            entry_number: e.entry_number,
            effective_date: e.effective_date.to_string(),
            description: e.description,
            debit: e.debit.to_string(),
            credit: e.credit.to_string(),
            standard_reference: e.standard_reference,
        })
        .collect())
}

/// Generate an Income Statement (Task 16.2 extension)
pub async fn generate_income_statement(
    from_date: String,
    to_date: String,
) -> anyhow::Result<FinancialReportDto> {
    let pool = get_pool()?;
    let repo = PgReportingRepository::new(pool.clone());

    let from = NaiveDate::parse_from_str(&from_date, "%Y-%m-%d")?;
    let to = NaiveDate::parse_from_str(&to_date, "%Y-%m-%d")?;

    let report: FinancialReport = repo.generate_income_statement(from, to).await?;

    Ok(FinancialReportDto {
        title: report.title,
        from_date: report.from_date.to_string(),
        to_date: report.to_date.to_string(),
        lines: report
            .lines
            .into_iter()
            .map(|l| FinancialReportLineDto {
                label: l.label,
                amount: l.amount.to_string(),
                is_title: l.is_title,
                is_total: l.is_total,
                indent_level: l.indent_level,
            })
            .collect(),
        generated_at: report.generated_at.to_string(),
    })
}

/// Generate a Balance Sheet (Task 16.2 extension)
pub async fn generate_balance_sheet(as_of_date: String) -> anyhow::Result<FinancialReportDto> {
    let pool = get_pool()?;
    let repo = PgReportingRepository::new(pool.clone());

    let date = NaiveDate::parse_from_str(&as_of_date, "%Y-%m-%d")?;

    let report: FinancialReport = repo.generate_balance_sheet(date).await?;

    Ok(FinancialReportDto {
        title: report.title,
        from_date: report.from_date.to_string(),
        to_date: report.to_date.to_string(),
        lines: report
            .lines
            .into_iter()
            .map(|l| FinancialReportLineDto {
                label: l.label,
                amount: l.amount.to_string(),
                is_title: l.is_title,
                is_total: l.is_total,
                indent_level: l.indent_level,
            })
            .collect(),
        generated_at: report.generated_at.to_string(),
    })
}

/// Generate a Statement of Cash Flows (Task 14.2)
pub async fn generate_cash_flow_statement(
    from_date: String,
    to_date: String,
) -> anyhow::Result<FinancialReportDto> {
    let pool = get_pool()?;
    let repo = PgReportingRepository::new(pool.clone());

    let from = NaiveDate::parse_from_str(&from_date, "%Y-%m-%d")?;
    let to = NaiveDate::parse_from_str(&to_date, "%Y-%m-%d")?;

    let report: FinancialReport = repo.generate_cash_flow_statement(from, to).await?;

    Ok(FinancialReportDto {
        title: report.title,
        from_date: report.from_date.to_string(),
        to_date: report.to_date.to_string(),
        lines: report
            .lines
            .into_iter()
            .map(|l| FinancialReportLineDto {
                label: l.label,
                amount: l.amount.to_string(),
                is_title: l.is_title,
                is_total: l.is_total,
                indent_level: l.indent_level,
            })
            .collect(),
        generated_at: report.generated_at.to_string(),
    })
}

/// DTO for Aging Reports
pub struct AgingReportLineDto {
    pub partner_id: String,
    pub partner_name: String,
    pub current_amount: String,
    pub period_1_30: String,
    pub period_31_60: String,
    pub period_61_90: String,
    pub period_over_90: String,
    pub total_amount: String,
}

/// Generate a Zakah Statement (Task 14.3)
pub async fn generate_zakah_statement(
    as_of_date: String,
    calendar: ZakahCalendarDto,
) -> anyhow::Result<FinancialReportDto> {
    let pool = get_pool()?;
    let repo = PgReportingRepository::new(pool.clone());

    let date = NaiveDate::parse_from_str(&as_of_date, "%Y-%m-%d")?;

    let cal_type = match calendar {
        ZakahCalendarDto::Hijri => ZakahCalendarType::Hijri,
        ZakahCalendarDto::Gregorian => ZakahCalendarType::Gregorian,
    };

    let report: FinancialReport = repo.generate_zakah_statement(date, cal_type).await?;

    Ok(FinancialReportDto {
        title: report.title,
        from_date: report.from_date.to_string(),
        to_date: report.to_date.to_string(),
        lines: report
            .lines
            .into_iter()
            .map(|l| FinancialReportLineDto {
                label: l.label,
                amount: l.amount.to_string(),
                is_title: l.is_title,
                is_total: l.is_total,
                indent_level: l.indent_level,
            })
            .collect(),
        generated_at: report.generated_at.to_string(),
    })
}

/// Generate Accounts Receivable Aging Report
pub async fn get_receivables_aging(as_of_date: String) -> anyhow::Result<Vec<AgingReportLineDto>> {
    let pool = get_pool()?;
    let repo = PgReportingRepository::new(pool.clone());

    let date = NaiveDate::parse_from_str(&as_of_date, "%Y-%m-%d")?;
    let rows = repo.get_receivables_aging(date).await?;

    Ok(rows
        .into_iter()
        .map(|r| AgingReportLineDto {
            partner_id: r.partner_id.to_string(),
            partner_name: r.partner_name,
            current_amount: r.current_amount.to_string(),
            period_1_30: r.period_1_30.to_string(),
            period_31_60: r.period_31_60.to_string(),
            period_61_90: r.period_61_90.to_string(),
            period_over_90: r.period_over_90.to_string(),
            total_amount: r.total_amount.to_string(),
        })
        .collect())
}

/// Generate Accounts Payable Aging Report
pub async fn get_payables_aging(as_of_date: String) -> anyhow::Result<Vec<AgingReportLineDto>> {
    let pool = get_pool()?;
    let repo = PgReportingRepository::new(pool.clone());

    let date = NaiveDate::parse_from_str(&as_of_date, "%Y-%m-%d")?;
    let rows = repo.get_payables_aging(date).await?;

    Ok(rows
        .into_iter()
        .map(|r| AgingReportLineDto {
            partner_id: r.partner_id.to_string(),
            partner_name: r.partner_name,
            current_amount: r.current_amount.to_string(),
            period_1_30: r.period_1_30.to_string(),
            period_31_60: r.period_31_60.to_string(),
            period_61_90: r.period_61_90.to_string(),
            period_over_90: r.period_over_90.to_string(),
            total_amount: r.total_amount.to_string(),
        })
        .collect())
}
