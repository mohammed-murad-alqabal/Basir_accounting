use accounting_core::accounts::models::Account;
use accounting_core::audit::chain::{compute_record_hash, GENESIS_HASH};
use accounting_core::audit::models::{AuditAction, AuditMetadata, AuditRecord, WhatInfo};
use chrono::Utc;
use sqlx::PgPool;
use uuid::Uuid;

pub struct PgAccountRepository {
    pool: PgPool,
}

impl PgAccountRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
    pub async fn save(
        &self,
        account: &Account,
        metadata: &AuditMetadata,
    ) -> Result<Uuid, anyhow::Error> {
        // 0. Check for cyclic dependencies
        if let Some(p_id) = account.parent_id {
            if p_id == account.id {
                return Err(anyhow::anyhow!("Account cannot be its own parent"));
            }
            // Use a recursive CTE to check if account.id exists in the path up to the root
            let cycle = sqlx::query!(
                r#"
                WITH RECURSIVE parents AS (
                    SELECT id, parent_id FROM accounts WHERE id = $1
                    UNION ALL
                    SELECT a.id, a.parent_id FROM accounts a
                    JOIN parents p ON a.id = p.parent_id
                )
                SELECT EXISTS(SELECT 1 FROM parents WHERE id = $2) as "has_cycle!"
                "#,
                p_id,
                account.id
            )
            .fetch_one(&self.pool)
            .await?;

            if cycle.has_cycle {
                return Err(anyhow::anyhow!(
                    "Cyclic dependency detected in account hierarchy"
                ));
            }
        }

        let kind_str = serde_json::to_string(&account.kind)?.replace("\"", "");
        let classification_str = account.classification.map(|c| format!("{:?}", c));

        let mut tx = self.pool.begin().await?;

        // Get old parent_id before update
        let old_parent_id =
            sqlx::query!("SELECT parent_id FROM accounts WHERE id = $1", account.id)
                .fetch_optional(&mut *tx)
                .await?
                .and_then(|r| r.parent_id);

        // 1. Insert/Update Account
        // We preserve is_leaf if it's an update, otherwise default to true
        sqlx::query!(
            r#"
            INSERT INTO accounts (id, code, name_ar, name_en, type, parent_id, is_leaf, ifrs_tag, classification, currency)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
            ON CONFLICT (id) DO UPDATE SET
                code = EXCLUDED.code,
                name_ar = EXCLUDED.name_ar,
                name_en = EXCLUDED.name_en,
                type = EXCLUDED.type,
                parent_id = EXCLUDED.parent_id,
                ifrs_tag = EXCLUDED.ifrs_tag,
                classification = EXCLUDED.classification,
                currency = EXCLUDED.currency
            "#,
            account.id,
            account.code,
            account.name_ar,
            account.name_en,
            kind_str,
            account.parent_id,
            true, // Potential leaf
            account.ifrs_tag,
            classification_str,
            account.currency.as_deref().unwrap_or("SAR")
        )
        .execute(&mut *tx)
        .await?;

        // 2. Update Parents' is_leaf status
        // New parent is NOT a leaf anymore
        if let Some(parent_id) = account.parent_id {
            sqlx::query!(
                "UPDATE accounts SET is_leaf = FALSE WHERE id = $1",
                parent_id
            )
            .execute(&mut *tx)
            .await?;
        }

        // Old parent might become a leaf if it has no more children
        if let Some(op_id) = old_parent_id {
            if Some(op_id) != account.parent_id {
                let count = sqlx::query_scalar!(
                    "SELECT COUNT(*) FROM accounts WHERE parent_id = $1",
                    op_id
                )
                .fetch_one(&mut *tx)
                .await?
                .unwrap_or(0);

                if count == 0 {
                    sqlx::query!("UPDATE accounts SET is_leaf = TRUE WHERE id = $1", op_id)
                        .execute(&mut *tx)
                        .await?;
                }
            }
        }

        // 3. Audit Logging (Requirement 5)
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
                action: AuditAction::Update, // Or Create depending on conflict
                entity_type: "Account".to_string(),
                entity_id: account.id,
                change_description: format!("Saved Account {} ({})", account.code, account.name_en),
                old_value: None, // Could fetch old value if needed for higher fidelity
                new_value: Some(serde_json::to_string(account)?),
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
        Ok(account.id)
    }

    pub async fn list_all(&self) -> Result<Vec<Account>, anyhow::Error> {
        let rows = sqlx::query!(
            r#"
            SELECT id, code, name_ar, name_en, type, parent_id, ifrs_tag, classification, currency
            FROM accounts
            ORDER BY code
            "#
        )
        .fetch_all(&self.pool)
        .await?;

        let mut accounts = Vec::new();
        for row in rows {
            let kind: accounting_core::accounts::models::AccountKind =
                serde_json::from_str(&format!("\"{}\"", row.r#type))?;

            let mut acc = Account::new(row.code, row.name_ar, row.name_en, kind);
            acc.id = row.id;
            acc.parent_id = row.parent_id;
            acc.ifrs_tag = row.ifrs_tag;
            acc.classification = row.classification.and_then(|c| {
                // Parse classification back into enum
                serde_json::from_str(&format!("\"{}\"", c)).ok()
            });
            acc.currency = row.currency;
            accounts.push(acc);
        }

        Ok(accounts)
    }

    pub async fn get_by_id(&self, id: Uuid) -> Result<Option<Account>, anyhow::Error> {
        let row = sqlx::query!(
            r#"
            SELECT id, code, name_ar, name_en, type, parent_id, ifrs_tag, classification, currency
            FROM accounts
            WHERE id = $1
            "#,
            id
        )
        .fetch_optional(&self.pool)
        .await?;

        if let Some(r) = row {
            let kind: accounting_core::accounts::models::AccountKind =
                serde_json::from_str(&format!("\"{}\"", r.r#type))?;

            let mut acc = Account::new(r.code, r.name_ar, r.name_en, kind);
            acc.id = r.id;
            acc.parent_id = r.parent_id;
            acc.ifrs_tag = r.ifrs_tag;
            acc.classification = r
                .classification
                .and_then(|c| serde_json::from_str(&format!("\"{}\"", c)).ok());
            acc.currency = r.currency;
            Ok(Some(acc))
        } else {
            Ok(None)
        }
    }
    pub async fn seed_defaults(&self) -> Result<(), anyhow::Error> {
        let defaults = accounting_core::accounts::defaults::default_chart_of_accounts();

        // System metadata for seeding
        let system_id = Uuid::nil();
        let metadata = AuditMetadata {
            who: accounting_core::audit::models::WhoInfo {
                user_id: system_id,
                user_name: "SYSTEM".to_string(),
                role: "SYSTEM".to_string(),
                session_id: system_id,
            },
            r#where: accounting_core::audit::models::WhereInfo {
                system_id: "INTERNAL".to_string(),
                ip_address: None,
                location: None,
                device_id: None,
                app_version: None,
            },
            why: accounting_core::audit::models::WhyInfo {
                reason_code: Some("SEED".to_string()),
                justification: Some("Initial seeding of default Chart of Accounts".to_string()),
                authorization_reference: None,
            },
            how: accounting_core::audit::models::HowInfo {
                method: "seed_defaults".to_string(),
                procedure_reference: None,
                api_endpoint: None,
            },
        };

        for acc in defaults {
            self.save(&acc, &metadata).await?;
        }
        Ok(())
    }
}
