use accounting_core::audit::models::{AuditMetadata, HowInfo, WhereInfo, WhoInfo, WhyInfo};
use accounting_core::ledger::models::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
    TemporalJustification,
};
use accounting_data::db::accounts::PgAccountRepository;
use accounting_data::db::ledger::PgLedgerRepository;
use chrono::Utc;
use rust_decimal::Decimal;
use sqlx::postgres::PgPoolOptions;
use sqlx::PgPool;
use uuid::Uuid;

pub struct TestContext {
    pub pool: PgPool,
    pub ledger_repo: PgLedgerRepository,
    pub account_id: Uuid,
}

pub async fn setup() -> Result<TestContext, anyhow::Error> {
    dotenvy::from_path("../../.env").ok();
    let database_url = std::env::var("DATABASE_URL").expect("DATABASE_URL must be set");

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await?;

    let accounts_repo = PgAccountRepository::new(pool.clone());
    let ledger_repo = PgLedgerRepository::new(pool.clone());

    sqlx::query("TRUNCATE TABLE audit_log, journal_entry_lines, journal_entries, accounts CASCADE")
        .execute(&pool)
        .await?;

    accounts_repo.seed_defaults().await?;

    let assets = sqlx::query!("SELECT id FROM accounts WHERE code = '1000'")
        .fetch_optional(&pool)
        .await?
        .ok_or_else(|| anyhow::anyhow!("Default Assets account should exist"))?;

    Ok(TestContext {
        pool,
        ledger_repo,
        account_id: assets.id,
    })
}

pub fn make_entry(account_id: Uuid) -> (JournalEntry, AuditMetadata) {
    let entry_id = Uuid::new_v4();
    let today = Utc::now().date_naive();

    let entry = JournalEntry {
        entry_id,
        entry_number: format!("TEST-{}", Uuid::new_v4()),
        description: "Integration Test".to_string(),
        entry_type: EntryType::Standard,
        status: EntryStatus::Posted,
        linked_entry_id: None,
        adjustment_reason: None,
        temporal: TemporalJustification::new(today, today),
        standards: StandardsJustification::simple("IFRS Test"),
        lines: vec![
            JournalEntryLine::debit(account_id, Decimal::from(100), "Test Debit"),
            JournalEntryLine::credit(account_id, Decimal::from(100), "Test Credit"),
        ],
        created_by: Uuid::new_v4(),
        created_at: Utc::now(),
        approved_by: None,
        approved_at: None,
        posted_by: None,
        posted_at: None,
        hash: "test_entry_hash".to_string(),
        previous_hash: "".to_string(),
    };

    let metadata = AuditMetadata {
        who: WhoInfo {
            user_id: Uuid::new_v4(),
            user_name: "TestRunner".into(),
            role: "System".into(),
            session_id: Uuid::new_v4(),
        },
        r#where: WhereInfo {
            system_id: "Test".into(),
            ip_address: None,
            location: None,
            device_id: Some("TEST_DEVICE".into()),
            app_version: Some("1.0.0".into()),
        },
        why: WhyInfo {
            reason_code: None,
            justification: None,
            authorization_reference: None,
        },
        how: HowInfo {
            method: "IntegrationTest".into(),
            procedure_reference: None,
            api_endpoint: None,
        },
    };

    (entry, metadata)
}
