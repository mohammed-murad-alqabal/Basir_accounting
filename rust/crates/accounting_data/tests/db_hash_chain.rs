mod common;

#[tokio::test]
async fn audit_hash_chain_is_continuous() -> Result<(), anyhow::Error> {
    let context = common::setup().await?;
    let (entry, metadata) = common::make_entry(context.account_id);
    let mut entry2 = entry.clone();
    entry2.entry_id = uuid::Uuid::new_v4();
    entry2.entry_number = format!("TEST-{}", uuid::Uuid::new_v4());

    context.ledger_repo.post_entry(&entry, &metadata).await?;
    context.ledger_repo.post_entry(&entry2, &metadata).await?;

    let audit_log = sqlx::query!(
        "SELECT curr_hash FROM audit_log WHERE entity_id = $1",
        entry.entry_id
    )
    .fetch_one(&context.pool)
    .await?;

    let audit_log2 = sqlx::query!(
        "SELECT curr_hash, prev_hash FROM audit_log WHERE entity_id = $1",
        entry2.entry_id
    )
    .fetch_one(&context.pool)
    .await?;

    assert_eq!(
        audit_log2.prev_hash,
        Some(audit_log.curr_hash),
        "Hash chain integrity check"
    );

    Ok(())
}
