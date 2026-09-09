mod common;

#[tokio::test]
async fn persistence_flow() -> Result<(), anyhow::Error> {
    let context = common::setup().await?;
    let (entry, metadata) = common::make_entry(context.account_id);

    context.ledger_repo.post_entry(&entry, &metadata).await?;

    let saved_entry = sqlx::query!(
        "SELECT id, hash FROM journal_entries WHERE id = $1",
        entry.entry_id
    )
    .fetch_one(&context.pool)
    .await?;
    assert_eq!(saved_entry.id, entry.entry_id);
    assert_eq!(saved_entry.hash, Some("test_entry_hash".to_string()));

    let saved_lines = sqlx::query!(
        "SELECT COUNT(*) as count FROM journal_entry_lines WHERE entry_id = $1",
        entry.entry_id
    )
    .fetch_one(&context.pool)
    .await?;
    assert_eq!(saved_lines.count.unwrap(), 2);

    let audit_log = sqlx::query!(
        "SELECT entity_id, curr_hash, prev_hash FROM audit_log WHERE entity_id = $1",
        entry.entry_id
    )
    .fetch_one(&context.pool)
    .await?;

    assert_eq!(audit_log.entity_id, entry.entry_id);
    assert!(!audit_log.curr_hash.is_empty());

    Ok(())
}
