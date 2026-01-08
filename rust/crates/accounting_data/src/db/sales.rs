use accounting_core::partners::models::Partner;
use accounting_core::sales::models::{
    CustomerPayment, SalesInvoice, SalesInvoiceLine, SalesInvoiceStatus,
};
use chrono::{DateTime, Utc};
use rust_decimal::Decimal;
use sqlx::{PgPool, Row};
use uuid::Uuid;

/// Repository for customer management.
pub struct PgCustomerRepository {
    pool: PgPool,
}

impl PgCustomerRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    /// Creates a new customer in the subsidiary ledger.
    pub async fn create_customer(&self, customer: &Partner) -> anyhow::Result<()> {
        sqlx::query(
            r#"
            INSERT INTO customers (id, code, name_ar, name_en, tax_id)
            VALUES ($1, $2, $3, $4, $5)
            "#,
        )
        .bind(customer.id)
        .bind(&customer.code)
        .bind(&customer.name_ar)
        .bind(&customer.name_en)
        .bind(&customer.tax_id)
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    /// Updates an existing customer.
    pub async fn update_customer(&self, customer: &Partner) -> anyhow::Result<()> {
        sqlx::query(
            r#"
            UPDATE customers
            SET code = $1, name_ar = $2, name_en = $3, tax_id = $4, updated_at = NOW()
            WHERE id = $5
            "#,
        )
        .bind(&customer.code)
        .bind(&customer.name_ar)
        .bind(&customer.name_en)
        .bind(&customer.tax_id)
        .bind(customer.id)
        .execute(&self.pool)
        .await?;
        Ok(())
    }

    /// Lists all customers in the subsidiary ledger.
    pub async fn list_customers(&self) -> anyhow::Result<Vec<Partner>> {
        let rows = sqlx::query(
            r#"
            SELECT id, code, name_ar, name_en, tax_id
            FROM customers
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
                kind: accounting_core::partners::models::PartnerType::Customer,
                tax_id: r.get("tax_id"),
            })
            .collect())
    }

    /// Deletes a customer.
    pub async fn delete_customer(&self, id: Uuid) -> anyhow::Result<()> {
        sqlx::query("DELETE FROM customers WHERE id = $1")
            .bind(id)
            .execute(&self.pool)
            .await?;
        Ok(())
    }
}

/// Repository for sales operations (AR).
pub struct PgSalesRepository {
    pool: PgPool,
}

impl PgSalesRepository {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }

    /// Creates a new sales invoice.
    /// If status is Draft, no GL entry is created.
    /// If status is Posted/Open, GL entry is created atomically.
    pub async fn create_invoice(
        &self,
        invoice: &SalesInvoice,
        lines: &[SalesInvoiceLine],
        ledger_repo: &crate::db::ledger::PgLedgerRepository,
        metadata: &accounting_core::audit::models::AuditMetadata,
    ) -> anyhow::Result<()> {
        let mut tx = self.pool.begin().await?;

        // 1. Construct Journal Entry (IFRS 15) ONLY if not Draft
        let gl_entry_id = if invoice.status != SalesInvoiceStatus::Draft {
            let gl_entry_id = Uuid::new_v4();

            let journal_lines = vec![
                accounting_core::ledger::models::JournalEntryLine {
                    line_id: Uuid::new_v4(),
                    line_number: 1,
                    account_id: invoice.ar_account_id,
                    debit_amount: invoice.total_amount,
                    credit_amount: Decimal::ZERO,
                    description: format!("Accounts Receivable - {}", invoice.invoice_number),
                    source_document_ref: Some(invoice.id.to_string()),
                    original_currency: None,
                    exchange_rate: None,
                    original_amount: None,
                    partner_id: Some(invoice.customer_id),
                },
                accounting_core::ledger::models::JournalEntryLine {
                    line_id: Uuid::new_v4(),
                    line_number: 2,
                    account_id: invoice.income_account_id,
                    debit_amount: Decimal::ZERO,
                    credit_amount: invoice.total_amount,
                    description: format!("Revenue Recognition - {}", invoice.invoice_number),
                    source_document_ref: Some(invoice.id.to_string()),
                    original_currency: None,
                    exchange_rate: None,
                    original_amount: None,
                    partner_id: Some(invoice.customer_id),
                },
            ];

            let entry = accounting_core::ledger::models::JournalEntry {
                entry_id: gl_entry_id,
                entry_number: format!("SINV-{}", invoice.invoice_number),
                description: format!("Sales Invoice {}", invoice.invoice_number),
                entry_type: accounting_core::ledger::models::EntryType::Standard,
                status: accounting_core::ledger::models::EntryStatus::Posted,
                linked_entry_id: None,
                adjustment_reason: None,
                temporal: accounting_core::ledger::models::TemporalJustification::new(
                    invoice.invoice_date.date_naive(),
                    invoice.invoice_date.date_naive(),
                ),
                standards: accounting_core::ledger::models::StandardsJustification::simple(
                    "IFRS 15",
                ),
                lines: journal_lines,
                created_by: metadata.who.user_id,
                created_at: Utc::now(),
                approved_by: Some(metadata.who.user_id),
                approved_at: Some(Utc::now()),
                posted_by: Some(metadata.who.user_id),
                posted_at: Some(Utc::now()),
                hash: String::new(),
                previous_hash: String::new(),
            };

            // Post GL Entry
            ledger_repo
                .post_entry_with_tx(&mut tx, &entry, metadata)
                .await?;

            Some(gl_entry_id)
        } else {
            None
        };

        // 2. Insert invoice header
        sqlx::query(
            r#"
            INSERT INTO sales_invoices (
                id, invoice_number, customer_id, invoice_date, due_date, 
                total_amount, balance_due, status, income_account_id, ar_account_id, description, gl_entry_id
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
            "#,
        )
        .bind(invoice.id)
        .bind(&invoice.invoice_number)
        .bind(invoice.customer_id)
        .bind(invoice.invoice_date.date_naive())
        .bind(invoice.due_date.date_naive())
        .bind(invoice.total_amount)
        .bind(invoice.balance_due)
        .bind(format!("{:?}", invoice.status))
        .bind(invoice.income_account_id)
        .bind(invoice.ar_account_id)
        .bind(&invoice.description)
        .bind(gl_entry_id)
        .execute(&mut *tx)
        .await?;

        // 3. Insert invoice lines
        for line in lines {
            sqlx::query(
                r#"
                INSERT INTO sales_invoice_lines (
                    id, invoice_id, product_id, description, quantity, unit_price, tax_amount, total_amount
                )
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
                "#,
            )
            .bind(line.id)
            .bind(line.invoice_id)
            .bind(line.product_id)
            .bind(&line.description)
            .bind(line.quantity)
            .bind(line.unit_price)
            .bind(line.tax_amount)
            .bind(line.total_amount)
            .execute(&mut *tx)
            .await?;
        }

        tx.commit().await?;
        Ok(())
    }

    /// Posts a Draft invoice (Generating GL entries)
    pub async fn post_invoice(
        &self,
        invoice_id: Uuid,
        invoice: &SalesInvoice, // Pass the full object with ZATCA fields populated
        ledger_repo: &crate::db::ledger::PgLedgerRepository,
        metadata: &accounting_core::audit::models::AuditMetadata,
    ) -> anyhow::Result<()> {
        let mut tx = self.pool.begin().await?;

        // 1. Fetch invoice details
        let invoice_rec = sqlx::query!(
            r#"
            SELECT id, invoice_number, customer_id, invoice_date, due_date, 
                   total_amount, balance_due, status, income_account_id, ar_account_id, description, gl_entry_id
            FROM sales_invoices
            WHERE id = $1
            "#,
            invoice_id
        )
        .fetch_optional(&mut *tx)
        .await?
        .ok_or_else(|| anyhow::anyhow!("Invoice not found"))?;

        if invoice_rec.status == "Posted"
            || invoice_rec.status == "Paid"
            || invoice_rec.status == "Open"
        {
            return Ok(()); // Already posted
        }

        // 2. Construct Journal Entry
        let gl_entry_id = Uuid::new_v4();

        let journal_lines = vec![
            accounting_core::ledger::models::JournalEntryLine {
                line_id: Uuid::new_v4(),
                line_number: 1,
                account_id: invoice_rec.ar_account_id,
                debit_amount: invoice_rec.total_amount,
                credit_amount: Decimal::ZERO,
                description: format!("Accounts Receivable - {}", invoice_rec.invoice_number),
                source_document_ref: Some(invoice_rec.id.to_string()),
                original_currency: None,
                exchange_rate: None,
                original_amount: None,
                partner_id: Some(invoice_rec.customer_id),
            },
            accounting_core::ledger::models::JournalEntryLine {
                line_id: Uuid::new_v4(),
                line_number: 2,
                account_id: invoice_rec.income_account_id,
                debit_amount: Decimal::ZERO,
                credit_amount: invoice_rec.total_amount,
                description: format!("Revenue Recognition - {}", invoice_rec.invoice_number),
                source_document_ref: Some(invoice_rec.id.to_string()),
                original_currency: None,
                exchange_rate: None,
                original_amount: None,
                partner_id: Some(invoice_rec.customer_id),
            },
        ];

        let entry = accounting_core::ledger::models::JournalEntry {
            entry_id: gl_entry_id,
            entry_number: format!("SINV-{}", invoice_rec.invoice_number),
            description: format!("Sales Invoice {}", invoice_rec.invoice_number),
            entry_type: accounting_core::ledger::models::EntryType::Standard,
            status: accounting_core::ledger::models::EntryStatus::Posted,
            linked_entry_id: None,
            adjustment_reason: None,
            temporal: accounting_core::ledger::models::TemporalJustification::new(
                invoice_rec.invoice_date,
                invoice_rec.invoice_date,
            ),
            standards: accounting_core::ledger::models::StandardsJustification::simple("IFRS 15"),
            lines: journal_lines,
            created_by: metadata.who.user_id,
            created_at: Utc::now(),
            approved_by: Some(metadata.who.user_id),
            approved_at: Some(Utc::now()),
            posted_by: Some(metadata.who.user_id),
            posted_at: Some(Utc::now()),
            hash: String::new(),
            previous_hash: String::new(),
        };

        // 3. Post GL Entry
        ledger_repo
            .post_entry_with_tx(&mut tx, &entry, metadata)
            .await?;

        // 4. Update Invoice Status & Link GL
        sqlx::query(
            r#"
            UPDATE sales_invoices
            SET status = 'Posted', 
                gl_entry_id = $1, 
                updated_at = NOW(),
                zatca_uuid = $2,
                zatca_hash = $3,
                zatca_previous_hash = $4,
                xml_content = $5,
                qr_code_data = $6
            WHERE id = $7
            "#,
        )
        .bind(gl_entry_id)
        .bind(invoice.zatca_uuid)
        .bind(&invoice.zatca_hash)
        .bind(&invoice.zatca_previous_hash)
        .bind(&invoice.xml_content)
        .bind(&invoice.qr_code_data)
        .bind(invoice_id)
        .execute(&mut *tx)
        .await?;

        tx.commit().await?;
        Ok(())
    }

    /// Records a payment and atomically updates the invoice balance/status and GL.
    pub async fn record_payment(
        &self,
        payment: &CustomerPayment,
        ledger_repo: &crate::db::ledger::PgLedgerRepository,
        metadata: &accounting_core::audit::models::AuditMetadata,
    ) -> anyhow::Result<()> {
        let mut tx = self.pool.begin().await?;

        // 1. Fetch invoice info for GL entry
        let invoice_row = sqlx::query!(
            "SELECT ar_account_id, invoice_number FROM sales_invoices WHERE id = $1",
            payment.invoice_id
        )
        .fetch_one(&mut *tx)
        .await?;

        // 2. Construct Journal Entry for Payment (Dr. Bank, Cr. AR)
        let gl_entry_id = Uuid::new_v4();
        let entry_number = format!("RCPT-{}", payment.id.to_string()[..8].to_uppercase());

        let mut gl_payment = payment.clone();
        gl_payment.gl_entry_id = Some(gl_entry_id);

        let entry = accounting_core::ledger::models::JournalEntry {
            entry_id: gl_entry_id,
            entry_number,
            description: format!("Payment for Invoice {}", invoice_row.invoice_number),
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
                    payment.bank_account_id,
                    payment.amount,
                    &format!(
                        "Customer Payment for Invoice {}",
                        invoice_row.invoice_number
                    ),
                ),
                accounting_core::ledger::models::JournalEntryLine::credit(
                    invoice_row.ar_account_id,
                    payment.amount,
                    &format!("Payment Allocation - {}", invoice_row.invoice_number),
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
            INSERT INTO customer_payments (
                id, invoice_id, payment_date, amount, payment_method, bank_account_id, reference, gl_entry_id
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            "#,
        )
        .bind(gl_payment.id)
        .bind(gl_payment.invoice_id)
        .bind(gl_payment.payment_date.date_naive())
        .bind(gl_payment.amount)
        .bind(&gl_payment.payment_method)
        .bind(gl_payment.bank_account_id)
        .bind(&gl_payment.reference)
        .bind(gl_payment.gl_entry_id)
        .execute(&mut *tx)
        .await?;

        // 4. Update invoice balance and status
        sqlx::query(
            r#"
            UPDATE sales_invoices
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
        .bind(payment.invoice_id)
        .execute(&mut *tx)
        .await?;

        // 5. Post GL Entry
        ledger_repo
            .post_entry_with_tx(&mut tx, &entry, metadata)
            .await?;

        tx.commit().await?;
        Ok(())
    }

    /// Lists all sales invoices.
    pub async fn list_invoices(&self) -> anyhow::Result<Vec<SalesInvoice>> {
        let rows = sqlx::query(
            r#"
            SELECT id, invoice_number, customer_id, invoice_date, due_date, 
                   total_amount, balance_due, status, income_account_id, ar_account_id, description, gl_entry_id
            FROM sales_invoices
            ORDER BY invoice_date DESC, invoice_number DESC
            "#,
        )
        .fetch_all(&self.pool)
        .await?;

        Ok(rows
            .into_iter()
            .map(|r| SalesInvoice {
                id: r.get("id"),
                invoice_number: r.get("invoice_number"),
                customer_id: r.get("customer_id"),
                invoice_date: DateTime::from_naive_utc_and_offset(
                    r.get::<chrono::NaiveDate, _>("invoice_date")
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
                    "Open" | "Posted" => SalesInvoiceStatus::Posted,
                    "Paid" => SalesInvoiceStatus::Paid,
                    "PartiallyPaid" => SalesInvoiceStatus::PartiallyPaid,
                    "Cancelled" => SalesInvoiceStatus::Cancelled,
                    _ => SalesInvoiceStatus::Draft,
                },
                income_account_id: r.get("income_account_id"),
                ar_account_id: r.get("ar_account_id"),
                description: r.get("description"),
                gl_entry_id: r.get("gl_entry_id"),
                zatca_uuid: r.get("zatca_uuid"),
                zatca_hash: r.get("zatca_hash"),
                zatca_previous_hash: r.get("zatca_previous_hash"),
                xml_content: r.get("xml_content"),
                qr_code_data: r.get("qr_code_data"),
            })
            .collect())
    }

    /// Retrieves a single invoice by ID.
    pub async fn get_invoice_by_id(&self, id: Uuid) -> anyhow::Result<Option<SalesInvoice>> {
        let row = sqlx::query(
            r#"
            SELECT id, invoice_number, customer_id, invoice_date, due_date, 
                   total_amount, balance_due, status, income_account_id, ar_account_id, description, gl_entry_id
            FROM sales_invoices
            WHERE id = $1
            "#,
        )
        .bind(id)
        .fetch_optional(&self.pool)
        .await?;

        Ok(row.map(|r| SalesInvoice {
            id: r.get("id"),
            invoice_number: r.get("invoice_number"),
            customer_id: r.get("customer_id"),
            invoice_date: DateTime::from_naive_utc_and_offset(
                r.get::<chrono::NaiveDate, _>("invoice_date")
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
                "Open" | "Posted" => SalesInvoiceStatus::Posted,
                "Paid" => SalesInvoiceStatus::Paid,
                "PartiallyPaid" => SalesInvoiceStatus::PartiallyPaid,
                "Cancelled" => SalesInvoiceStatus::Cancelled,
                _ => SalesInvoiceStatus::Draft,
            },
            income_account_id: r.get("income_account_id"),
            ar_account_id: r.get("ar_account_id"),
            description: r.get("description"),
            gl_entry_id: r.get("gl_entry_id"),
            zatca_uuid: r.get("zatca_uuid"),
            zatca_hash: r.get("zatca_hash"),
            zatca_previous_hash: r.get("zatca_previous_hash"),
            xml_content: r.get("xml_content"),
            qr_code_data: r.get("qr_code_data"),
        }))
    }

    /// Deletes an invoice (if not posted/linked or as per policy).
    /// Note: Usually invoices should be cancelled, but we provide delete for draft/migration cleanup.
    pub async fn delete_invoice(&self, id: Uuid) -> anyhow::Result<()> {
        sqlx::query("DELETE FROM sales_invoices WHERE id = $1")
            .bind(id)
            .execute(&self.pool)
            .await?;
        Ok(())
    }
}
