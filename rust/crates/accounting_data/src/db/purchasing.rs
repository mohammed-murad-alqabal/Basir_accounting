use accounting_core::partners::models::Partner;
use accounting_core::purchasing::models::{BillPayment, BillStatus, PurchaseBill};
use sqlx::{PgPool, Row};
use uuid::Uuid;

use chrono::{DateTime, Utc};

/// Repository for vendor management.
pub struct PgVendorRepository {
    pool: PgPool,
}

impl PgVendorRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    /// Creates a new vendor in the subsidiary ledger.
    pub async fn create_vendor(&self, vendor: &Partner) -> anyhow::Result<()> {
        sqlx::query(
            r#"
            INSERT INTO vendors (id, code, name_ar, name_en, tax_id)
            VALUES ($1, $2, $3, $4, $5)
            "#,
        )
        .bind(vendor.id)
        .bind(&vendor.code)
        .bind(&vendor.name_ar)
        .bind(&vendor.name_en)
        .bind(&vendor.tax_id)
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    /// Retrieves a vendor by ID.
    pub async fn get_vendor(&self, id: Uuid) -> anyhow::Result<Option<Partner>> {
        let row = sqlx::query(
            r#"
            SELECT id, code, name_ar, name_en, tax_id
            FROM vendors
            WHERE id = $1
            "#,
        )
        .bind(id)
        .fetch_optional(&self.pool)
        .await?;

        Ok(row.map(|r| Partner {
            id: r.get("id"),
            code: r.get("code"),
            name_ar: r.get("name_ar"),
            name_en: r.get("name_en"),
            kind: accounting_core::partners::models::PartnerType::Vendor,
            tax_id: r.get("tax_id"),
        }))
    }

    /// Lists all vendors in the subsidiary ledger.
    pub async fn list_vendors(&self) -> anyhow::Result<Vec<Partner>> {
        let rows = sqlx::query(
            r#"
            SELECT id, code, name_ar, name_en, tax_id
            FROM vendors
            ORDER BY name_ar
            "#,
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows
            .into_iter()
            .map(|r| Partner {
                id: r.get("id"),
                code: r.get("code"),
                name_ar: r.get("name_ar"),
                name_en: r.get("name_en"),
                kind: accounting_core::partners::models::PartnerType::Vendor,
                tax_id: r.get("tax_id"),
            })
            .collect())
    }

    /// Updates a vendor.
    pub async fn update_vendor(&self, vendor: &Partner) -> anyhow::Result<()> {
        sqlx::query(
            r#"
            UPDATE vendors
            SET code = $1, name_ar = $2, name_en = $3, tax_id = $4, updated_at = NOW()
            WHERE id = $5
            "#,
        )
        .bind(&vendor.code)
        .bind(&vendor.name_ar)
        .bind(&vendor.name_en)
        .bind(&vendor.tax_id)
        .bind(vendor.id)
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    /// Deletes a vendor.
    pub async fn delete_vendor(&self, id: Uuid) -> anyhow::Result<()> {
        sqlx::query("DELETE FROM vendors WHERE id = $1")
            .bind(id)
            .execute(&self.pool)
            .await?;
        Ok(())
    }
}

/// Repository for purchasing operations (AP).
pub struct PgPurchaseRepository {
    pool: PgPool,
}

impl PgPurchaseRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    /// Creates a new purchase bill with atomic GL posting.
    pub async fn create_bill(
        &self,
        bill: &PurchaseBill,
        ledger_repo: &crate::db::ledger::PgLedgerRepository,
        metadata: &accounting_core::audit::models::AuditMetadata,
    ) -> anyhow::Result<()> {
        let mut tx = self.pool.begin().await?;

        // 1. Construct Journal Entry (IFRS 9)
        let gl_entry_id = Uuid::new_v4();
        let mut gl_bill = bill.clone();
        gl_bill.gl_entry_id = Some(gl_entry_id);

        let entry = accounting_core::ledger::models::JournalEntry {
            entry_id: gl_entry_id,
            entry_number: format!("PBILL-{}", bill.bill_number),
            description: format!("Purchase Bill {}", bill.bill_number),
            entry_type: accounting_core::ledger::models::EntryType::Standard,
            status: accounting_core::ledger::models::EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: accounting_core::ledger::models::TemporalJustification::new(
                bill.bill_date.date_naive(),
                bill.bill_date.date_naive(),
            ),
            standards: accounting_core::ledger::models::StandardsJustification::simple("IFRS 9"),
            lines: vec![
                accounting_core::ledger::models::JournalEntryLine::debit(
                    bill.expense_account_id,
                    bill.total_amount,
                    &format!("Expense Recognition - {}", bill.bill_number),
                ),
                accounting_core::ledger::models::JournalEntryLine::credit(
                    bill.ap_account_id,
                    bill.total_amount,
                    &format!("Accounts Payable - {}", bill.bill_number),
                ),
            ],
            created_by: metadata.who.user_id,
            created_at: Utc::now(),
            approved_by: Some(metadata.who.user_id),
            approved_at: Some(Utc::now()),
            posted_by: Some(metadata.who.user_id),
            posted_at: Some(Utc::now()),
            hash: String::new(),
            previous_hash: String::new(),
        };

        // 2. Insert bill header
        sqlx::query(
            r#"
            INSERT INTO purchase_bills (
                id, bill_number, vendor_id, bill_date, due_date, 
                total_amount, balance_due, status, expense_account_id, ap_account_id, description, gl_entry_id
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
            "#,
        )
        .bind(gl_bill.id)
        .bind(&gl_bill.bill_number)
        .bind(gl_bill.vendor_id)
        .bind(gl_bill.bill_date.date_naive())
        .bind(gl_bill.due_date.date_naive())
        .bind(gl_bill.total_amount)
        .bind(gl_bill.balance_due)
        .bind(format!("{:?}", gl_bill.status))
        .bind(gl_bill.expense_account_id)
        .bind(gl_bill.ap_account_id)
        .bind(&gl_bill.description)
        .bind(gl_bill.gl_entry_id)
        .execute(&mut *tx)
        .await?;

        // 3. Post GL Entry
        ledger_repo
            .post_entry_with_tx(&mut tx, &entry, metadata)
            .await?;

        tx.commit().await?;
        Ok(())
    }

    /// Records a payment and atomically updates the bill status and GL.
    pub async fn record_payment(
        &self,
        payment: &BillPayment,
        ledger_repo: &crate::db::ledger::PgLedgerRepository,
        metadata: &accounting_core::audit::models::AuditMetadata,
    ) -> anyhow::Result<()> {
        let mut tx = self.pool.begin().await?;

        // 1. Fetch bill info for GL entry
        let bill_row = sqlx::query!(
            "SELECT ap_account_id, bill_number FROM purchase_bills WHERE id = $1",
            payment.bill_id
        )
        .fetch_one(&mut *tx)
        .await?;

        // 2. Construct Journal Entry for Payment (Dr. AP, Cr. Bank)
        let gl_entry_id = Uuid::new_v4();
        let entry_number = format!("PYMT-{}", payment.id.to_string()[..8].to_uppercase());

        let mut gl_payment = payment.clone();
        gl_payment.gl_entry_id = Some(gl_entry_id);

        let entry = accounting_core::ledger::models::JournalEntry {
            entry_id: gl_entry_id,
            entry_number,
            description: format!("Payment to Vendor for Bill {}", bill_row.bill_number),
            entry_type: accounting_core::ledger::models::EntryType::Standard,
            status: accounting_core::ledger::models::EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: accounting_core::ledger::models::TemporalJustification::new(
                payment.payment_date.date_naive(),
                payment.payment_date.date_naive(),
            ),
            standards: accounting_core::ledger::models::StandardsJustification::simple("IFRS 9"),
            lines: vec![
                accounting_core::ledger::models::JournalEntryLine::debit(
                    bill_row.ap_account_id,
                    payment.amount,
                    &format!("Payment to Vendor for Bill {}", bill_row.bill_number),
                ),
                accounting_core::ledger::models::JournalEntryLine::credit(
                    payment.bank_account_id,
                    payment.amount,
                    &format!("Bank Payment - {}", bill_row.bill_number),
                ),
            ],
            created_by: metadata.who.user_id,
            created_at: Utc::now(),
            approved_by: Some(metadata.who.user_id),
            approved_at: Some(Utc::now()),
            posted_by: Some(metadata.who.user_id),
            posted_at: Some(Utc::now()),
            hash: String::new(),
            previous_hash: String::new(),
        };

        // 3. Insert payment record
        sqlx::query(
            r#"
            INSERT INTO bill_payments (
                id, bill_id, payment_date, amount, payment_method, bank_account_id, reference, gl_entry_id
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            "#,
        )
        .bind(gl_payment.id)
        .bind(gl_payment.bill_id)
        .bind(gl_payment.payment_date.date_naive())
        .bind(gl_payment.amount)
        .bind(&gl_payment.payment_method)
        .bind(gl_payment.bank_account_id)
        .bind(&gl_payment.reference)
        .bind(gl_payment.gl_entry_id)
        .execute(&mut *tx)
        .await?;

        // 4. Update bill balance and status
        sqlx::query(
            r#"
            UPDATE purchase_bills
            SET balance_due = balance_due - $1,
                status = CASE 
                    WHEN balance_due - $1 <= 0 THEN 'Paid'
                    ELSE 'PartiallyPaid'
                END,
                updated_at = NOW()
            WHERE id = $2
            "#,
        )
        .bind(payment.amount)
        .bind(payment.bill_id)
        .execute(&mut *tx)
        .await?;

        // 5. Post GL Entry
        ledger_repo
            .post_entry_with_tx(&mut tx, &entry, metadata)
            .await?;

        tx.commit().await?;
        Ok(())
    }

    /// Lists all purchase bills.
    pub async fn list_bills(&self) -> anyhow::Result<Vec<PurchaseBill>> {
        let rows = sqlx::query(
            r#"
            SELECT id, bill_number, vendor_id, bill_date, due_date, 
                   total_amount, balance_due, status, expense_account_id, ap_account_id, description, gl_entry_id
            FROM purchase_bills
            ORDER BY bill_date DESC, bill_number DESC
            "#,
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows
            .into_iter()
            .map(|r| PurchaseBill {
                id: r.get("id"),
                bill_number: r.get("bill_number"),
                vendor_id: r.get("vendor_id"),
                bill_date: DateTime::from_naive_utc_and_offset(
                    r.get::<chrono::NaiveDate, _>("bill_date")
                        .and_hms_opt(0, 0, 0)
                        .unwrap(),
                    Utc,
                ),
                due_date: DateTime::from_naive_utc_and_offset(
                    r.get::<chrono::NaiveDate, _>("due_date")
                        .and_hms_opt(0, 0, 0)
                        .unwrap(),
                    Utc,
                ),
                total_amount: r.get("total_amount"),
                balance_due: r.get("balance_due"),
                status: match r.get::<String, _>("status").as_str() {
                    "Open" => BillStatus::Open,
                    "Paid" => BillStatus::Paid,
                    "PartiallyPaid" => BillStatus::PartiallyPaid,
                    "Cancelled" => BillStatus::Cancelled,
                    _ => BillStatus::Draft,
                },
                expense_account_id: r.get("expense_account_id"),
                ap_account_id: r.get("ap_account_id"),
                description: r.get("description"),
                gl_entry_id: r.get("gl_entry_id"),
            })
            .collect())
    }

    /// Retrieves a single bill by ID.
    pub async fn get_bill_by_id(&self, id: Uuid) -> anyhow::Result<Option<PurchaseBill>> {
        let row = sqlx::query(
            r#"
            SELECT id, bill_number, vendor_id, bill_date, due_date, 
                   total_amount, balance_due, status, expense_account_id, ap_account_id, description, gl_entry_id
            FROM purchase_bills
            WHERE id = $1
            "#,
        )
        .bind(id)
        .fetch_optional(&self.pool)
        .await?;

        Ok(row.map(|r| PurchaseBill {
            id: r.get("id"),
            bill_number: r.get("bill_number"),
            vendor_id: r.get("vendor_id"),
            bill_date: DateTime::from_naive_utc_and_offset(
                r.get::<chrono::NaiveDate, _>("bill_date")
                    .and_hms_opt(0, 0, 0)
                    .unwrap(),
                Utc,
            ),
            due_date: DateTime::from_naive_utc_and_offset(
                r.get::<chrono::NaiveDate, _>("due_date")
                    .and_hms_opt(0, 0, 0)
                    .unwrap(),
                Utc,
            ),
            total_amount: r.get("total_amount"),
            balance_due: r.get("balance_due"),
            status: match r.get::<String, _>("status").as_str() {
                "Open" => BillStatus::Open,
                "Paid" => BillStatus::Paid,
                "PartiallyPaid" => BillStatus::PartiallyPaid,
                "Cancelled" => BillStatus::Cancelled,
                _ => BillStatus::Draft,
            },
            expense_account_id: r.get("expense_account_id"),
            ap_account_id: r.get("ap_account_id"),
            description: r.get("description"),
            gl_entry_id: r.get("gl_entry_id"),
        }))
    }

    /// Deletes a bill.
    pub async fn delete_bill(&self, id: Uuid) -> anyhow::Result<()> {
        sqlx::query("DELETE FROM purchase_bills WHERE id = $1")
            .bind(id)
            .execute(&self.pool)
            .await?;
        Ok(())
    }
}
