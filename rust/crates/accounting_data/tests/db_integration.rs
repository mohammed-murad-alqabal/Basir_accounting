use accounting_core::audit::models::{AuditMetadata, HowInfo, WhereInfo, WhoInfo, WhyInfo};
use accounting_core::ledger::models::{
    EntryStatus, EntryType, JournalEntry, JournalEntryLine, StandardsJustification,
    TemporalJustification,
};
use accounting_data::db::accounts::PgAccountRepository;
use accounting_data::db::ledger::PgLedgerRepository;
use accounting_data::db::standards::PgStandardsRepository;
use chrono::Utc;

use rust_decimal::Decimal;
use sqlx::postgres::PgPoolOptions;
use uuid::Uuid;

#[tokio::test]
async fn test_persistence_flow() -> Result<(), anyhow::Error> {
    // 1. Connect
    dotenvy::from_path("../../.env").ok(); // Load from rust root
    let database_url = std::env::var("DATABASE_URL").expect("DATABASE_URL must be set");

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await?;

    // 2. Repositories
    let _standards_repo = PgStandardsRepository::new(pool.clone());
    let accounts_repo = PgAccountRepository::new(pool.clone());
    let ledger_repo = PgLedgerRepository::new(pool.clone());

    // 3. Clean Slate (Task-specific for this integration test)
    sqlx::query("TRUNCATE TABLE audit_log, journal_entry_lines, journal_entries, accounts CASCADE")
        .execute(&pool)
        .await?;

    // 4. Accounts Seeding
    // We clean up first to be safe (optional in test env, but good for idempotency check)
    // For now, seed_defaults uses ON CONFLICT DO NOTHING, so it's safe.
    accounts_repo.seed_defaults().await?;

    // Verify 'Assets' exists
    let assets_exists = sqlx::query!("SELECT id FROM accounts WHERE code = '1000'")
        .fetch_optional(&pool)
        .await?;
    assert!(
        assets_exists.is_some(),
        "Default Assets account should exist"
    );

    // 5. Create Journal Entry
    let account_id_val = assets_exists.unwrap().id; // Use Assets as placeholder for both sides (bad accounting, good testing)

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
            JournalEntryLine::debit(account_id_val, Decimal::from(100), "Test Debit"),
            JournalEntryLine::credit(account_id_val, Decimal::from(100), "Test Credit"),
        ],
        created_by: Uuid::new_v4(),
        created_at: Utc::now(),
        approved_by: None,
        approved_at: None,
        posted_by: None,
        posted_at: None,
        hash: "test_entry_hash".to_string(), // In Core this would be computed
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

    // 6. Post Entry
    ledger_repo.post_entry(&entry, &metadata).await?;

    // 7. Verify Data
    let saved_entry = sqlx::query!(
        "SELECT id, hash FROM journal_entries WHERE id = $1",
        entry_id
    )
    .fetch_one(&pool)
    .await?;
    assert_eq!(saved_entry.id, entry_id);
    assert_eq!(saved_entry.hash, Some("test_entry_hash".to_string()));

    let saved_lines = sqlx::query!(
        "SELECT COUNT(*) as count FROM journal_entry_lines WHERE entry_id = $1",
        entry_id
    )
    .fetch_one(&pool)
    .await?;
    assert_eq!(saved_lines.count.unwrap(), 2);

    let audit_log = sqlx::query!(
        "SELECT id, curr_hash, prev_hash FROM audit_log WHERE entity_id = $1",
        entry_id
    )
    .fetch_one(&pool)
    .await?;

    println!("Audit Log Hash: {}", audit_log.curr_hash);

    // 8. Test Chain (Post second entry)
    let entry2_id = Uuid::new_v4();
    let mut entry2 = entry.clone();
    entry2.entry_id = entry2_id;
    entry2.entry_number = format!("TEST-{}", Uuid::new_v4());

    ledger_repo.post_entry(&entry2, &metadata).await?;

    let audit_log2 = sqlx::query!(
        "SELECT curr_hash, prev_hash FROM audit_log WHERE entity_id = $1",
        entry2_id
    )
    .fetch_one(&pool)
    .await?;

    assert_eq!(
        audit_log2.prev_hash,
        Some(audit_log.curr_hash),
        "Hash chain integrity check"
    );

    Ok(())
}
