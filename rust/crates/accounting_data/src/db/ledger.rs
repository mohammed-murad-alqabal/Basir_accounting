use accounting_core::audit::chain::{compute_record_hash, GENESIS_HASH};
use accounting_core::audit::models::{AuditAction, AuditMetadata, AuditRecord, WhatInfo};
use accounting_core::ledger::models::{EntryStatus, JournalEntry};
use accounting_core::ledger::validation::{
    validate_balance, validate_currency, validate_has_lines, validate_line_amounts,
};
use chrono::Utc;
use rust_decimal::Decimal;
use sqlx::PgPool;
use std::str::FromStr;
use uuid::Uuid;

pub struct PgLedgerRepository {
    pool: PgPool,
}

/// يحول تمثيل JSON القادم من PostgreSQL إلى Decimal من دون المرور عبر f64.
///
/// تقبل PostgreSQL JSON الأرقام والنصوص؛ يعالج المساران كسلسلة عشرية حتى
/// لا تتحول قيمة مالية غير صالحة بصمت إلى صفر أثناء إعادة بناء القيد.
fn decimal_from_json(value: &serde_json::Value) -> anyhow::Result<Decimal> {
    match value {
        serde_json::Value::String(text) => Decimal::from_str(text)
            .map_err(|error| anyhow::anyhow!("invalid decimal text '{text}': {error}")),
        serde_json::Value::Number(number) => Decimal::from_str(&number.to_string())
            .map_err(|error| anyhow::anyhow!("invalid decimal number '{number}': {error}")),
        _ => anyhow::bail!("expected a JSON decimal number or string"),
    }
}

impl PgLedgerRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    pub async fn post_entry(
        &self,
        entry: &JournalEntry,
        metadata: &AuditMetadata,
    ) -> Result<(), anyhow::Error> {
        let mut tx = self.pool.begin().await?;
        self.post_entry_with_tx(&mut tx, entry, metadata).await?;
        tx.commit().await?;
        Ok(())
    }

    pub async fn post_entry_with_tx(
        &self,
        tx: &mut sqlx::PgConnection,
        entry: &JournalEntry,
        metadata: &AuditMetadata,
    ) -> Result<(), anyhow::Error> {
        // Repository posting is the final boundary for all business flows. The
        // native API and sub-ledgers can call this method directly, so enforce
        // the database-independent invariants here as well as in the core service.
        if entry.status != EntryStatus::Posted {
            anyhow::bail!("Only entries in Posted status may be persisted to the ledger");
        }
        validate_has_lines(entry).map_err(|error| anyhow::anyhow!(error.to_string()))?;
        validate_line_amounts(entry).map_err(|error| anyhow::anyhow!(error.to_string()))?;
        validate_balance(entry).map_err(|error| anyhow::anyhow!(error.to_string()))?;
        validate_currency(entry).map_err(|error| anyhow::anyhow!(error.to_string()))?;

        // 1. Insert Header
        let adjustment_reason_str = entry.adjustment_reason.map(|r| format!("{:?}", r));

        sqlx::query!(
            r#"
            INSERT INTO journal_entries (
                id, entry_number, entry_type, status, 
                transaction_date, effective_date, recording_date,
                standard_reference, description, hash,
                linked_entry_id, adjustment_reason
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
            "#,
            entry.entry_id,
            entry.entry_number,
            format!("{:?}", entry.entry_type),
            format!("{:?}", entry.status),
            entry.temporal.transaction_date,
            entry.temporal.effective_date,
            entry.temporal.recording_date.naive_utc(),
            entry.standards.standard_reference,
            entry.description.clone(),
            entry.hash,
            entry.linked_entry_id,
            adjustment_reason_str
        )
        .execute(&mut *tx)
        .await?;

        // 2. Insert Lines
        for line in &entry.lines {
            sqlx::query!(
                r#"
                INSERT INTO journal_entry_lines (
                    id, entry_id, account_id, description, debit, credit,
                    original_currency, exchange_rate, original_amount, partner_id
                )
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
                "#,
                Uuid::new_v4(),
                entry.entry_id,
                line.account_id,
                line.description,
                line.debit_amount,
                line.credit_amount,
                line.original_currency,
                line.exchange_rate,
                line.original_amount,
                line.partner_id
            )
            .execute(&mut *tx)
            .await?;
        }

        // 3. Audit Log
        let prev_hash_row =
            sqlx::query!("SELECT curr_hash FROM audit_log ORDER BY timestamp DESC LIMIT 1")
                .fetch_optional(&mut *tx)
                .await?;

        let prev_hash = prev_hash_row
            .map(|r| r.curr_hash)
            .unwrap_or_else(|| GENESIS_HASH.to_string());

        let mut audit_record = AuditRecord {
            record_id: Uuid::new_v4(),
            who: metadata.who.clone(),
            what: WhatInfo {
                action: AuditAction::Post,
                entity_type: "JournalEntry".to_string(),
                entity_id: entry.entry_id,
                change_description: format!("Posted Entry {}", entry.entry_number),
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

        Ok(())
    }

    pub async fn reverse_entry(
        &self,
        entry_id: Uuid,
        reason: &str,
        metadata: &AuditMetadata,
    ) -> Result<Uuid, anyhow::Error> {
        let mut tx = self.pool.begin().await?;

        // 1. Fetch original entry
        let entry_row = sqlx::query!(
            "SELECT entry_number, entry_type, standard_reference FROM journal_entries WHERE id = $1",
            entry_id
        )
        .fetch_one(&mut *tx)
        .await?;

        // 2. Insert Reversal Header
        let reversal_id = Uuid::new_v4();
        let reversal_number = format!("REV-{}", entry_row.entry_number);

        sqlx::query!(
            r#"
            INSERT INTO journal_entries (
                id, entry_number, entry_type, status, 
                transaction_date, effective_date, recording_date,
                standard_reference, description
            )
            VALUES ($1, $2, $3, $4, CURRENT_DATE, CURRENT_DATE, NOW(), $5, $6)
            "#,
            reversal_id,
            reversal_number,
            entry_row.entry_type,
            format!("{:?}", EntryStatus::Posted),
            entry_row.standard_reference,
            format!("Reversal of {}: {}", entry_row.entry_number, reason)
        )
        .execute(&mut *tx)
        .await?;

        // 3. Insert Reversal Lines (Fliped debits/credits)
        sqlx::query!(
            r#"
            INSERT INTO journal_entry_lines (
                id, entry_id, account_id, description, debit, credit,
                original_currency, exchange_rate, original_amount
            )
            SELECT gen_random_uuid(), $1, account_id, 'Reversal: ' || description, credit, debit,
                   original_currency, exchange_rate, original_amount
            FROM journal_entry_lines
            WHERE entry_id = $2
            "#,
            reversal_id,
            entry_id
        )
        .execute(&mut *tx)
        .await?;

        // 4. Audit Log
        let prev_hash_row =
            sqlx::query!("SELECT curr_hash FROM audit_log ORDER BY timestamp DESC LIMIT 1")
                .fetch_optional(&mut *tx)
                .await?;

        let prev_hash = prev_hash_row
            .map(|r| r.curr_hash)
            .unwrap_or_else(|| GENESIS_HASH.to_string());

        let mut audit_record = AuditRecord {
            record_id: Uuid::new_v4(),
            who: metadata.who.clone(),
            what: WhatInfo {
                action: AuditAction::Reverse,
                entity_type: "JournalEntry".to_string(),
                entity_id: entry_id,
                change_description: format!(
                    "Reversed Entry {} -> {}",
                    entry_row.entry_number, reversal_number
                ),
                old_value: Some(entry_id.to_string()),
                new_value: Some(reversal_id.to_string()),
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
        Ok(reversal_id)
    }

    pub async fn log_agent_consensus(
        &self,
        entry_id: Uuid,
        consensus_json: &str,
        metadata: &AuditMetadata,
    ) -> Result<(), anyhow::Error> {
        let mut tx = self.pool.begin().await?;

        let prev_hash_row =
            sqlx::query!("SELECT curr_hash FROM audit_log ORDER BY timestamp DESC LIMIT 1")
                .fetch_optional(&mut *tx)
                .await?;

        let prev_hash = prev_hash_row
            .map(|r| r.curr_hash)
            .unwrap_or_else(|| GENESIS_HASH.to_string());

        let mut audit_record = AuditRecord {
            record_id: Uuid::new_v4(),
            who: metadata.who.clone(),
            what: WhatInfo {
                action: AuditAction::CognitiveVerify,
                entity_type: "JournalEntry".to_string(),
                entity_id: entry_id,
                change_description: "Cognitive Agent Consensus".to_string(),
                old_value: None,
                new_value: Some(consensus_json.to_string()),
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

    pub async fn get_agent_consensus(
        &self,
        entry_id: Uuid,
    ) -> Result<Option<String>, anyhow::Error> {
        let row = sqlx::query!(
            r#"
            SELECT payload->'what'->>'new_value' as consensus
            FROM audit_log
            WHERE entity_id = $1 AND action = 'CognitiveVerify'
            ORDER BY timestamp DESC
            LIMIT 1
            "#,
            entry_id
        )
        .fetch_optional(&self.pool)
        .await?;

        Ok(row.and_then(|r| r.consensus))
    }

    pub async fn get_audit_records(
        &self,
        entity_id: Uuid,
    ) -> Result<Vec<AuditRecord>, anyhow::Error> {
        let rows = sqlx::query!(
            r#"
            SELECT payload
            FROM audit_log
            WHERE entity_id = $1
            ORDER BY timestamp DESC
            "#,
            entity_id
        )
        .fetch_all(&self.pool)
        .await?;

        let mut records = Vec::new();
        for row in rows {
            let record: AuditRecord = serde_json::from_value(row.payload)?;
            records.push(record);
        }
        Ok(records)
    }

    /// List journal entries with pagination and optional filtering
    pub async fn list_entries(
        &self,
        limit: i64,
        offset: i64,
        from_date: Option<chrono::NaiveDate>,
        to_date: Option<chrono::NaiveDate>,
        account_id: Option<Uuid>,
    ) -> Result<Vec<JournalEntry>, anyhow::Error> {
        // Optimized query using json_agg to avoid N+1 problem
        let rows = sqlx::query!(
            r#"
            SELECT 
                je.id, je.entry_number, je.entry_type, je.status,
                je.transaction_date, je.effective_date, je.recording_date,
                je.standard_reference, je.description, je.hash,
                je.linked_entry_id, je.adjustment_reason,
                -- Aggregate lines into a JSON array
                COALESCE(
                    json_agg(
                        json_build_object(
                            'line_id', jel.id,
                            'account_id', jel.account_id,
                            'description', jel.description,
                            'debit_amount', jel.debit,
                            'credit_amount', jel.credit,
                            'original_currency', jel.original_currency,
                            'exchange_rate', jel.exchange_rate,
                            'original_amount', jel.original_amount,
                            'partner_id', jel.partner_id
                        ) ORDER BY jel.debit DESC, jel.credit DESC
                    ) FILTER (WHERE jel.id IS NOT NULL), 
                    '[]'::json
                ) as lines
            FROM journal_entries je
            LEFT JOIN journal_entry_lines jel ON je.id = jel.entry_id
            WHERE 
                ($3::date IS NULL OR je.transaction_date >= $3)
                AND ($4::date IS NULL OR je.transaction_date <= $4)
                AND ($5::uuid IS NULL OR EXISTS (
                    SELECT 1 FROM journal_entry_lines jel2 
                    WHERE jel2.entry_id = je.id AND jel2.account_id = $5
                ))
            GROUP BY je.id
            ORDER BY je.transaction_date DESC, je.recording_date DESC
            LIMIT $1 OFFSET $2
            "#,
            limit,
            offset,
            from_date,
            to_date,
            account_id
        )
        .fetch_all(&self.pool)
        .await?;

        let mut entries = Vec::new();

        for row in rows {
            // Parse lines from JSON
            let lines_json: serde_json::Value =
                row.lines.unwrap_or(serde_json::Value::Array(Vec::new()));
            let mut lines_vec = Vec::new();

            if let Some(lines_array) = lines_json.as_array() {
                for line_val in lines_array {
                    let line_val: &serde_json::Value = line_val;

                    let line_id_str = line_val
                        .get("line_id")
                        .and_then(|v| v.as_str())
                        .unwrap_or_default();

                    let account_id_str = line_val
                        .get("account_id")
                        .and_then(|v| v.as_str())
                        .unwrap_or_default();

                    if line_id_str.is_empty() || account_id_str.is_empty() {
                        continue;
                    }

                    let debit = decimal_from_json(
                        line_val
                            .get("debit_amount")
                            .ok_or_else(|| anyhow::anyhow!("missing debit_amount"))?,
                    )?;
                    let credit = decimal_from_json(
                        line_val
                            .get("credit_amount")
                            .ok_or_else(|| anyhow::anyhow!("missing credit_amount"))?,
                    )?;

                    let description = match line_val.get("description").and_then(|v| v.as_str()) {
                        Some(s) => s.to_string(),
                        None => String::new(),
                    };

                    let original_currency = line_val
                        .get("original_currency")
                        .and_then(|v| v.as_str())
                        .map(|s| s.to_string());

                    let exchange_rate = line_val
                        .get("exchange_rate")
                        .filter(|value| !value.is_null())
                        .map(decimal_from_json)
                        .transpose()?;
                    let original_amount = line_val
                        .get("original_amount")
                        .filter(|value| !value.is_null())
                        .map(decimal_from_json)
                        .transpose()?;
                    let partner_id = line_val
                        .get("partner_id")
                        .and_then(|v: &serde_json::Value| v.as_str())
                        .and_then(|s: &str| Uuid::parse_str(s).ok());

                    lines_vec.push(accounting_core::ledger::models::JournalEntryLine {
                        line_id: Uuid::parse_str(line_id_str).unwrap_or_default(),
                        line_number: 0,
                        account_id: Uuid::parse_str(account_id_str).unwrap_or_default(),
                        debit_amount: debit,
                        credit_amount: credit,
                        description,
                        source_document_ref: None,
                        original_currency,
                        exchange_rate,
                        original_amount,
                        partner_id,
                    });
                }
            }

            // Map Entry Type Enum
            let entry_type = match row.entry_type.as_str() {
                "Standard" => accounting_core::ledger::models::EntryType::Standard,
                "Adjusting" => accounting_core::ledger::models::EntryType::Adjusting,
                "Reversing" => accounting_core::ledger::models::EntryType::Reversing,
                "Closing" => accounting_core::ledger::models::EntryType::Closing,
                _ => accounting_core::ledger::models::EntryType::Standard,
            };

            // Map Status Enum
            let status = match row.status.as_str() {
                "Draft" => EntryStatus::Draft,
                "PendingApproval" => EntryStatus::PendingApproval,
                "Approved" => EntryStatus::Approved,
                "Posted" => EntryStatus::Posted,
                "Reversed" => EntryStatus::Reversed,
                _ => EntryStatus::Draft,
            };

            // Map Adjustment Reason
            let adjustment_reason = row.adjustment_reason.as_deref().and_then(|r| match r {
                "Correction" => Some(accounting_core::ledger::models::AdjustmentReason::Correction),
                "Reclassification" => {
                    Some(accounting_core::ledger::models::AdjustmentReason::Reclassification)
                }
                "Accrual" => Some(accounting_core::ledger::models::AdjustmentReason::Accrual),
                "Deferral" => Some(accounting_core::ledger::models::AdjustmentReason::Deferral),
                "EstimationChange" => {
                    Some(accounting_core::ledger::models::AdjustmentReason::EstimationChange)
                }
                "PolicyChange" => {
                    Some(accounting_core::ledger::models::AdjustmentReason::PolicyChange)
                }
                _ => None,
            });

            entries.push(JournalEntry {
                entry_id: row.id,
                entry_number: row.entry_number,
                description: row.description,
                entry_type,
                status,
                linked_entry_id: row.linked_entry_id,
                adjustment_reason,
                temporal: accounting_core::ledger::models::TemporalJustification {
                    transaction_date: row.transaction_date,
                    effective_date: row.effective_date,
                    recording_date: chrono::DateTime::from_naive_utc_and_offset(
                        row.recording_date,
                        Utc,
                    ),
                },
                standards: accounting_core::ledger::models::StandardsJustification::simple(
                    row.standard_reference.as_deref().unwrap_or_default(),
                ),
                lines: lines_vec,
                // Placeholder Audit Data (Not fetched in list view for performance)
                created_by: Uuid::nil(),
                created_at: Utc::now(),
                approved_by: None,
                approved_at: None,
                posted_by: None,
                posted_at: None,
                hash: row.hash.unwrap_or_default(),
                previous_hash: String::new(),
            });
        }

        Ok(entries)
    }
}

#[cfg(test)]
mod tests {
    use super::decimal_from_json;
    use rust_decimal::Decimal;
    use serde_json::json;
    use std::str::FromStr;

    #[test]
    fn parses_decimal_text_and_json_number_without_f64() {
        let text_value = json!("123456789.123456789");
        let number_value = json!(12345.6789);

        assert_eq!(
            decimal_from_json(&text_value).expect("text decimal should parse"),
            Decimal::from_str("123456789.123456789").expect("fixture is valid"),
        );
        assert_eq!(
            decimal_from_json(&number_value).expect("JSON number should parse"),
            Decimal::from_str("12345.6789").expect("fixture is valid"),
        );
    }

    #[test]
    fn rejects_invalid_or_missing_decimal_values() {
        assert!(decimal_from_json(&json!("not-a-decimal")).is_err());
        assert!(decimal_from_json(&serde_json::Value::Null).is_err());
    }
}
