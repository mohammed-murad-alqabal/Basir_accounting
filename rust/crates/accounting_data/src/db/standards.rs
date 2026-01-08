use accounting_core::audit::chain::{compute_record_hash, GENESIS_HASH};
use accounting_core::audit::models::{AuditAction, AuditMetadata, AuditRecord, WhatInfo};
use accounting_core::standards::models::{StandardBody, StandardEntry, StandardReference};
use chrono::{NaiveDate, Utc};
use sqlx::{FromRow, PgPool};
use std::collections::HashMap;
use uuid::Uuid;

#[derive(FromRow, Debug)]
struct DbStandard {
    id: Uuid,
    body: String,
    number: String,
    paragraph: String,
    title: String,
    full_text: String,
    effective_date: NaiveDate,
    supersedes_ids: Option<Vec<Uuid>>,
    superseded_by_id: Option<Uuid>,
}

pub struct PgStandardsRepository {
    pool: PgPool,
}

impl PgStandardsRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    /// Loads all standards from the database and reconstructs the full StandardEntry objects.
    pub async fn load_all(&self) -> Result<Vec<StandardEntry>, anyhow::Error> {
        let rows = sqlx::query_as::<_, DbStandard>("SELECT * FROM standards")
            .fetch_all(&self.pool)
            .await?;

        // 1. Build Lookup Map
        let mut lookup: HashMap<Uuid, (StandardBody, String, String)> = HashMap::new();
        for row in &rows {
            // Parse Body
            let body: StandardBody =
                serde_json::from_value(serde_json::Value::String(row.body.clone()))
                    .map_err(|_| anyhow::anyhow!("Invalid StandardBody: {}", row.body))?;

            lookup.insert(row.id, (body, row.number.clone(), row.paragraph.clone()));
        }

        // 2. Map to Domain Objects
        let mut entries = Vec::new();
        for row in rows {
            let (body, number, paragraph) = lookup.get(&row.id).cloned().expect("ID must exist");

            // Resolve Supersedes
            let mut supersedes = Vec::new();
            if let Some(ids) = &row.supersedes_ids {
                for id in ids {
                    if let Some((s_body, s_num, s_para)) = lookup.get(id) {
                        supersedes.push(StandardReference {
                            id: *id,
                            body: *s_body,
                            number: s_num.clone(),
                            paragraph: s_para.clone(),
                        });
                    }
                }
            }

            // Resolve Superseded By
            let superseded_by = if let Some(id) = row.superseded_by_id {
                lookup
                    .get(&id)
                    .map(|(s_body, s_num, s_para)| StandardReference {
                        id,
                        body: *s_body,
                        number: s_num.clone(),
                        paragraph: s_para.clone(),
                    })
            } else {
                None
            };

            entries.push(StandardEntry {
                reference: StandardReference {
                    id: row.id,
                    body,
                    number,
                    paragraph,
                },
                title: row.title,
                full_text: row.full_text,
                effective_date: row.effective_date,
                supersedes,
                superseded_by,
            });
        }

        Ok(entries)
    }

    pub async fn save(
        &self,
        entry: &StandardEntry,
        metadata: &AuditMetadata,
    ) -> Result<(), anyhow::Error> {
        let mut tx = self.pool.begin().await?;

        // 1. Serialize Body
        let body_str = serde_json::to_string(&entry.reference.body)?.replace("\"", "");

        // 2. Collect Supersedes IDs
        let supersedes_ids: Vec<Uuid> = entry.supersedes.iter().map(|s| s.id).collect();
        let superseded_by_id = entry.superseded_by.as_ref().map(|s| s.id);

        sqlx::query!(
            r#"
            INSERT INTO standards (id, body, number, paragraph, title, full_text, effective_date, supersedes_ids, superseded_by_id)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            ON CONFLICT (id) DO UPDATE SET
                title = EXCLUDED.title,
                full_text = EXCLUDED.full_text,
                effective_date = EXCLUDED.effective_date,
                supersedes_ids = EXCLUDED.supersedes_ids,
                superseded_by_id = EXCLUDED.superseded_by_id
            "#,
            entry.reference.id,
            body_str,
            entry.reference.number,
            entry.reference.paragraph,
            entry.title,
            entry.full_text,
            entry.effective_date,
            &supersedes_ids,
            superseded_by_id
        )
        .execute(&mut *tx)
        .await?;

        // 3. Audit Logging (Requirement 5)
        let prev_hash =
            sqlx::query_scalar!("SELECT curr_hash FROM audit_log ORDER BY timestamp DESC LIMIT 1")
                .fetch_optional(&mut *tx)
                .await?
                .unwrap_or_else(|| GENESIS_HASH.to_string());

        let mut audit_record = AuditRecord {
            record_id: Uuid::new_v4(),
            who: metadata.who.clone(),
            what: WhatInfo {
                action: AuditAction::Update,
                entity_type: "StandardEntry".to_string(),
                entity_id: entry.reference.id,
                change_description: format!(
                    "Saved Standard {} ({})",
                    entry.reference.to_canonical(),
                    entry.title
                ),
                old_value: None,
                new_value: Some(serde_json::to_string(entry)?),
            },
            when: Utc::now(),
            r#where: metadata.r#where.clone(),
            why: metadata.why.clone(),
            how: metadata.how.clone(),
            previous_hash: prev_hash.clone(),
            hash: String::new(),
        };

        let curr_hash = compute_record_hash(&audit_record);
        audit_record.hash = curr_hash.clone();

        sqlx::query!(
            r#"
            INSERT INTO audit_log (
                id, user_id, entity_type, entity_id, action, payload, prev_hash, curr_hash, timestamp
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            "#,
            audit_record.record_id,
            audit_record.who.user_id.to_string(),
            audit_record.what.entity_type,
            audit_record.what.entity_id,
            format!("{:?}", audit_record.what.action),
            serde_json::to_value(&audit_record)?,
            prev_hash,
            curr_hash,
            audit_record.when.naive_utc()
        )
        .execute(&mut *tx)
        .await?;

        tx.commit().await?;
        Ok(())
    }
}
