use crate::api::{get_pool, AuditMetadataDto};
use accounting_core::partners::models::Partner;
use accounting_core::sales::models::{
    CustomerPayment, SalesInvoice, SalesInvoiceLine, SalesInvoiceStatus,
};
use accounting_data::db::ledger::PgLedgerRepository;
use accounting_data::db::sales::{PgCustomerRepository, PgSalesRepository};
use uuid::Uuid;

pub async fn list_customers() -> anyhow::Result<Vec<CustomerDto>> {
    let pool = get_pool()?.clone();
    let repo = PgCustomerRepository::new(pool);
    let customers = repo.list_customers().await?;
    Ok(customers.into_iter().map(CustomerDto::from).collect())
}

pub async fn create_customer(customer: CustomerDto) -> anyhow::Result<String> {
    let pool = get_pool()?.clone();
    let repo = PgCustomerRepository::new(pool);
    let entity = Partner {
        id: Uuid::new_v4(),
        code: customer.code,
        name_ar: customer.name_ar,
        name_en: customer.name_en,
        kind: accounting_core::partners::models::PartnerType::Customer,
        tax_id: customer.tax_id,
    };
    repo.create_customer(&entity).await?;
    Ok(entity.id.to_string())
}

pub async fn update_customer(customer: CustomerDto) -> anyhow::Result<()> {
    let pool = get_pool()?.clone();
    let repo = PgCustomerRepository::new(pool);
    let id_str = customer
        .id
        .ok_or_else(|| anyhow::anyhow!("Customer ID is required for update"))?;
    let entity = Partner {
        id: Uuid::parse_str(&id_str)?,
        code: customer.code,
        name_ar: customer.name_ar,
        name_en: customer.name_en,
        kind: accounting_core::partners::models::PartnerType::Customer,
        tax_id: customer.tax_id,
    };
    repo.update_customer(&entity).await?;
    Ok(())
}

pub async fn delete_customer(id: String) -> anyhow::Result<()> {
    let pool = get_pool()?.clone();
    let repo = PgCustomerRepository::new(pool);
    repo.delete_customer(Uuid::parse_str(&id)?).await?;
    Ok(())
}

pub async fn list_invoices() -> anyhow::Result<Vec<SalesInvoiceDto>> {
    let pool = get_pool()?.clone();
    let repo = PgSalesRepository::new(pool);
    let invoices = repo.list_invoices().await?;
    Ok(invoices.into_iter().map(SalesInvoiceDto::from).collect())
}

pub async fn get_invoice_by_id(id: String) -> anyhow::Result<Option<SalesInvoiceDto>> {
    let pool = get_pool()?.clone();
    let repo = PgSalesRepository::new(pool);
    let invoice = repo.get_invoice_by_id(Uuid::parse_str(&id)?).await?;
    Ok(invoice.map(SalesInvoiceDto::from))
}

pub async fn delete_invoice(id: String) -> anyhow::Result<()> {
    let pool = get_pool()?.clone();
    let repo = PgSalesRepository::new(pool);
    repo.delete_invoice(Uuid::parse_str(&id)?).await?;
    Ok(())
}

pub async fn create_invoice(
    invoice: SalesInvoiceDto,
    lines: Vec<SalesInvoiceLineDto>,
    metadata: AuditMetadataDto,
) -> anyhow::Result<String> {
    let pool = get_pool()?.clone();
    let repo = PgSalesRepository::new(pool.clone());
    let ledger_repo = PgLedgerRepository::new(pool);

    let entity: SalesInvoice = invoice.try_into()?;
    let line_entities: Vec<SalesInvoiceLine> = lines
        .into_iter()
        .map(|l| l.try_into())
        .collect::<anyhow::Result<Vec<_>>>()?;

    let audit_meta: accounting_core::audit::models::AuditMetadata = metadata.try_into()?;

    repo.create_invoice(&entity, &line_entities, &ledger_repo, &audit_meta)
        .await?;
    Ok(entity.id.to_string())
}

pub async fn post_invoice(id: String, metadata: AuditMetadataDto) -> anyhow::Result<()> {
    let pool = get_pool()?.clone();
    let repo = PgSalesRepository::new(pool.clone());
    let ledger_repo = PgLedgerRepository::new(pool);

    let invoice_id = Uuid::parse_str(&id)?;
    let audit_meta: accounting_core::audit::models::AuditMetadata = metadata.try_into()?;

    // 1. Fetch current invoice state
    let mut invoice = repo
        .get_invoice_by_id(invoice_id)
        .await?
        .ok_or_else(|| anyhow::anyhow!("Invoice not found"))?;

    if invoice.status == SalesInvoiceStatus::Posted
        || invoice.status == SalesInvoiceStatus::Paid
        || invoice.status == SalesInvoiceStatus::PartiallyPaid
    {
        return Ok(()); // Idempotency
    }

    // 2. Perform ZATCA Compliance Steps (Phase 2)
    use accounting_zatca::{crypto, qr, xml_builder};

    // A. Generate UBL XML
    // TODO: Populate with real Supplier/Customer/Line details used in UBL
    let zatca_uuid = Uuid::new_v4();
    let xml_invoice = xml_builder::Invoice::new_standard(
        invoice.invoice_number.clone(),
        zatca_uuid.to_string(),
        invoice.invoice_date.format("%Y-%m-%d").to_string(),
        invoice.invoice_date.format("%H:%M:%S").to_string(),
    );
    let xml_content = xml_invoice.to_xml()?;

    // B. Calculate Hash
    let hash = crypto::sha256_hash(&xml_content);

    // C. Sign Hash (ECDSA)
    // TODO: Fetch real private key from secure storage/KMS
    let (private_key, public_key) = crypto::generate_key_pair();
    let signature = crypto::sign_ecdsa(&private_key, &hash)?;

    // D. Generate QR Code
    let qr_payload = qr::ZatcaQrPayload {
        seller_name: "Basir MVP Supplier".to_string(), // TODO: Get from Config
        vat_number: "300000000000003".to_string(),     // TODO: Get from Config
        timestamp: invoice.invoice_date.to_rfc3339(),
        total_amount: invoice.total_amount.to_string(),
        vat_amount: invoice.total_amount.to_string(), // Placeholder calculation
        hash: hash.clone(),
        signature: signature.clone(),
        public_key,
    };
    let qr_code = qr_payload.to_base64()?;

    // 3. Update Invoice Object with Compliance Data
    invoice.zatca_uuid = Some(zatca_uuid);
    invoice.zatca_hash = Some(hash);
    invoice.xml_content = Some(xml_content);
    invoice.qr_code_data = Some(qr_code);
    // invoice.zatca_previous_hash = ... // TODO: Chain hash

    // 4. Post to Ledger & Save Compliance Data
    repo.post_invoice(invoice_id, &invoice, &ledger_repo, &audit_meta)
        .await?;

    Ok(())
}

pub async fn record_customer_payment(
    payment: CustomerPaymentDto,
    metadata: AuditMetadataDto,
) -> anyhow::Result<()> {
    let pool = get_pool()?.clone();
    let repo = PgSalesRepository::new(pool.clone());
    let ledger_repo = PgLedgerRepository::new(pool);

    let entity: CustomerPayment = payment.try_into()?;
    let audit_meta: accounting_core::audit::models::AuditMetadata = metadata.try_into()?;

    repo.record_payment(&entity, &ledger_repo, &audit_meta)
        .await?;
    Ok(())
}

#[derive(Clone)]
pub struct CustomerDto {
    pub id: Option<String>,
    pub code: String,
    pub name_ar: String,
    pub name_en: String,
    pub tax_id: Option<String>,
}

impl From<Partner> for CustomerDto {
    fn from(p: Partner) -> Self {
        Self {
            id: Some(p.id.to_string()),
            code: p.code,
            name_ar: p.name_ar,
            name_en: p.name_en,
            tax_id: p.tax_id,
        }
    }
}

pub struct SalesInvoiceDto {
    pub id: Option<String>,
    pub invoice_number: String,
    pub customer_id: String,
    pub invoice_date: String, // ISO 8601
    pub due_date: String,     // ISO 8601
    pub status: String,
    pub total_amount: String,
    pub balance_due: String,
    pub description: Option<String>,
    pub income_account_id: String,
    pub ar_account_id: String,
    pub qr_code_data: Option<String>,
}

pub struct SalesInvoiceLineDto {
    pub product_id: Option<String>,
    pub description: String,
    pub quantity: String,
    pub unit_price: String,
    pub tax_amount: String,
}

pub struct CustomerPaymentDto {
    pub id: Option<String>,
    pub invoice_id: String,
    pub amount: String,
    pub payment_date: String, // ISO 8601
    pub bank_account_id: String,
    pub payment_method: String,
    pub reference: Option<String>,
}

impl TryFrom<SalesInvoiceDto> for SalesInvoice {
    type Error = anyhow::Error;
    fn try_from(dto: SalesInvoiceDto) -> Result<Self, Self::Error> {
        use chrono::{DateTime, Utc};
        use std::str::FromStr;
        Ok(Self {
            id: dto
                .id
                .map(|s| Uuid::parse_str(&s))
                .unwrap_or_else(|| Ok(Uuid::new_v4()))?,
            invoice_number: dto.invoice_number,
            customer_id: Uuid::parse_str(&dto.customer_id)?,
            invoice_date: DateTime::parse_from_rfc3339(&dto.invoice_date)?.with_timezone(&Utc),
            due_date: DateTime::parse_from_rfc3339(&dto.due_date)?.with_timezone(&Utc),
            status: match dto.status.as_str() {
                "Open" => SalesInvoiceStatus::Posted, // Use Posted for Open
                "Posted" => SalesInvoiceStatus::Posted,
                "Paid" => SalesInvoiceStatus::Paid,
                "PartiallyPaid" => SalesInvoiceStatus::PartiallyPaid,
                "Cancelled" => SalesInvoiceStatus::Cancelled,
                _ => SalesInvoiceStatus::Draft,
            },
            description: dto.description,
            total_amount: rust_decimal::Decimal::from_str(&dto.total_amount)
                .unwrap_or(rust_decimal::Decimal::ZERO),
            balance_due: rust_decimal::Decimal::from_str(&dto.balance_due)
                .unwrap_or(rust_decimal::Decimal::ZERO),
            income_account_id: Uuid::parse_str(&dto.income_account_id)?,
            ar_account_id: Uuid::parse_str(&dto.ar_account_id)?,
            gl_entry_id: None,
            zatca_uuid: None, // Read-only from backend
            zatca_hash: None,
            zatca_previous_hash: None,
            xml_content: None,
            qr_code_data: dto.qr_code_data, // Preserve round-trip if valid
        })
    }
}

impl From<SalesInvoice> for SalesInvoiceDto {
    fn from(invoice: SalesInvoice) -> Self {
        Self {
            id: Some(invoice.id.to_string()),
            invoice_number: invoice.invoice_number,
            customer_id: invoice.customer_id.to_string(),
            invoice_date: invoice.invoice_date.to_rfc3339(),
            due_date: invoice.due_date.to_rfc3339(),
            status: format!("{:?}", invoice.status),
            total_amount: invoice.total_amount.to_string(),
            balance_due: invoice.balance_due.to_string(),
            description: invoice.description,
            income_account_id: invoice.income_account_id.to_string(),
            ar_account_id: invoice.ar_account_id.to_string(),
            qr_code_data: invoice.qr_code_data,
        }
    }
}

impl TryFrom<SalesInvoiceLineDto> for SalesInvoiceLine {
    type Error = anyhow::Error;
    fn try_from(dto: SalesInvoiceLineDto) -> Result<Self, Self::Error> {
        use rust_decimal::Decimal;
        use std::str::FromStr;
        let qty = Decimal::from_str(&dto.quantity)?;
        let price = Decimal::from_str(&dto.unit_price)?;
        let tax = Decimal::from_str(&dto.tax_amount)?;
        Ok(Self {
            id: Uuid::new_v4(),
            invoice_id: Uuid::nil(), // Set by repo
            product_id: dto.product_id.map(|s| Uuid::parse_str(&s)).transpose()?,
            description: dto.description,
            quantity: qty,
            unit_price: price,
            tax_amount: tax,
            total_amount: (qty * price) + tax,
        })
    }
}

impl TryFrom<CustomerPaymentDto> for CustomerPayment {
    type Error = anyhow::Error;
    fn try_from(dto: CustomerPaymentDto) -> Result<Self, Self::Error> {
        use chrono::{DateTime, Utc};
        use std::str::FromStr;
        Ok(Self {
            id: dto
                .id
                .map(|s| Uuid::parse_str(&s))
                .unwrap_or_else(|| Ok(Uuid::new_v4()))?,
            invoice_id: Uuid::parse_str(&dto.invoice_id)?,
            amount: rust_decimal::Decimal::from_str(&dto.amount)?,
            payment_date: DateTime::parse_from_rfc3339(&dto.payment_date)?.with_timezone(&Utc),
            bank_account_id: Uuid::parse_str(&dto.bank_account_id)?,
            payment_method: dto.payment_method,
            gl_entry_id: None,
            reference: dto.reference,
        })
    }
}
