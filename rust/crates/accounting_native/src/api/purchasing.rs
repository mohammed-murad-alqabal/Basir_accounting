use crate::api::{get_pool, AuditMetadataDto};
use accounting_core::partners::models::Partner;
use accounting_core::purchasing::models::{BillPayment, BillStatus, PurchaseBill};
use accounting_data::db::ledger::PgLedgerRepository;
use accounting_data::db::purchasing::{PgPurchaseRepository, PgVendorRepository};
use uuid::Uuid;

pub async fn list_vendors() -> anyhow::Result<Vec<VendorDto>> {
    let pool = get_pool()?.clone();
    let repo = PgVendorRepository::new(pool);
    let vendors = repo.list_vendors().await?;
    Ok(vendors.into_iter().map(VendorDto::from).collect())
}

pub async fn get_vendor_by_id(id: String) -> anyhow::Result<Option<VendorDto>> {
    let pool = get_pool()?.clone();
    let repo = PgVendorRepository::new(pool);
    let uuid = Uuid::parse_str(&id)?;
    let vendors = repo.list_vendors().await?;
    Ok(vendors
        .into_iter()
        .find(|v| v.id == uuid)
        .map(VendorDto::from))
}

pub async fn create_vendor(vendor: VendorDto) -> anyhow::Result<String> {
    let pool = get_pool()?.clone();
    let repo = PgVendorRepository::new(pool);
    let entity = Partner {
        id: Uuid::new_v4(),
        code: vendor.code,
        name_ar: vendor.name_ar,
        name_en: vendor.name_en,
        kind: accounting_core::partners::models::PartnerType::Vendor,
        tax_id: vendor.tax_id,
    };
    repo.create_vendor(&entity).await?;
    Ok(entity.id.to_string())
}

pub async fn update_vendor(vendor: VendorDto) -> anyhow::Result<()> {
    let pool = get_pool()?.clone();
    let repo = PgVendorRepository::new(pool);
    let id_str = vendor
        .id
        .ok_or_else(|| anyhow::anyhow!("Vendor ID is required for update"))?;
    let entity = Partner {
        id: Uuid::parse_str(&id_str)?,
        code: vendor.code,
        name_ar: vendor.name_ar,
        name_en: vendor.name_en,
        kind: accounting_core::partners::models::PartnerType::Vendor,
        tax_id: vendor.tax_id,
    };
    repo.update_vendor(&entity).await?;
    Ok(())
}

pub async fn delete_vendor(id: String) -> anyhow::Result<()> {
    let pool = get_pool()?.clone();
    let repo = PgVendorRepository::new(pool);
    repo.delete_vendor(Uuid::parse_str(&id)?).await?;
    Ok(())
}

pub async fn list_purchase_bills() -> anyhow::Result<Vec<PurchaseBillDto>> {
    let pool = get_pool()?.clone();
    let repo = PgPurchaseRepository::new(pool);
    let bills = repo.list_bills().await?;
    Ok(bills.into_iter().map(PurchaseBillDto::from).collect())
}

pub async fn get_purchase_bill_by_id(id: String) -> anyhow::Result<Option<PurchaseBillDto>> {
    let pool = get_pool()?.clone();
    let repo = PgPurchaseRepository::new(pool);
    let bill = repo.get_bill_by_id(Uuid::parse_str(&id)?).await?;
    Ok(bill.map(PurchaseBillDto::from))
}

pub async fn delete_bill(id: String) -> anyhow::Result<()> {
    let pool = get_pool()?.clone();
    let repo = PgPurchaseRepository::new(pool);
    repo.delete_bill(Uuid::parse_str(&id)?).await?;
    Ok(())
}

pub async fn create_purchase_bill(
    bill: PurchaseBillDto,
    metadata: AuditMetadataDto,
) -> anyhow::Result<String> {
    let pool = get_pool()?.clone();
    let repo = PgPurchaseRepository::new(pool.clone());
    let ledger_repo = PgLedgerRepository::new(pool);

    let entity: PurchaseBill = bill.try_into()?;
    let audit_meta: accounting_core::audit::models::AuditMetadata = metadata.try_into()?;

    repo.create_bill(&entity, &ledger_repo, &audit_meta).await?;
    Ok(entity.id.to_string())
}

pub async fn record_bill_payment(
    payment: BillPaymentDto,
    metadata: AuditMetadataDto,
) -> anyhow::Result<()> {
    let pool = get_pool()?.clone();
    let repo = PgPurchaseRepository::new(pool.clone());
    let ledger_repo = PgLedgerRepository::new(pool);

    let entity: BillPayment = payment.try_into()?;
    let audit_meta: accounting_core::audit::models::AuditMetadata = metadata.try_into()?;

    repo.record_payment(&entity, &ledger_repo, &audit_meta)
        .await?;
    Ok(())
}

#[derive(Clone)]
pub struct VendorDto {
    pub id: Option<String>,
    pub code: String,
    pub name_ar: String,
    pub name_en: String,
    pub tax_id: Option<String>,
}

impl From<Partner> for VendorDto {
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

pub struct PurchaseBillDto {
    pub id: Option<String>,
    pub bill_number: String,
    pub vendor_id: String,
    pub bill_date: String, // ISO 8601
    pub due_date: String,  // ISO 8601
    pub total_amount: String,
    pub balance_due: String,
    pub status: String,
    pub expense_account_id: String,
    pub ap_account_id: String,
    pub description: Option<String>,
}

pub struct BillPaymentDto {
    pub id: Option<String>,
    pub bill_id: String,
    pub amount: String,
    pub payment_date: String, // ISO 8601
    pub payment_method: String,
    pub bank_account_id: String,
    pub reference: Option<String>,
}

impl TryFrom<PurchaseBillDto> for PurchaseBill {
    type Error = anyhow::Error;
    fn try_from(dto: PurchaseBillDto) -> Result<Self, Self::Error> {
        use chrono::{DateTime, Utc};
        use std::str::FromStr;
        Ok(Self {
            id: dto
                .id
                .map(|s| Uuid::parse_str(&s))
                .unwrap_or_else(|| Ok(Uuid::new_v4()))?,
            bill_number: dto.bill_number,
            vendor_id: Uuid::parse_str(&dto.vendor_id)?,
            bill_date: DateTime::parse_from_rfc3339(&dto.bill_date)?.with_timezone(&Utc),
            due_date: DateTime::parse_from_rfc3339(&dto.due_date)?.with_timezone(&Utc),
            total_amount: rust_decimal::Decimal::from_str(&dto.total_amount)
                .unwrap_or(rust_decimal::Decimal::ZERO),
            balance_due: rust_decimal::Decimal::from_str(&dto.balance_due)
                .unwrap_or(rust_decimal::Decimal::ZERO),
            status: match dto.status.as_str() {
                "Open" => BillStatus::Open,
                "Paid" => BillStatus::Paid,
                "PartiallyPaid" => BillStatus::PartiallyPaid,
                "Cancelled" => BillStatus::Cancelled,
                _ => BillStatus::Draft,
            },
            expense_account_id: Uuid::parse_str(&dto.expense_account_id)?,
            ap_account_id: Uuid::parse_str(&dto.ap_account_id)?,
            gl_entry_id: None,
            description: dto.description,
        })
    }
}

impl From<PurchaseBill> for PurchaseBillDto {
    fn from(b: PurchaseBill) -> Self {
        Self {
            id: Some(b.id.to_string()),
            bill_number: b.bill_number,
            vendor_id: b.vendor_id.to_string(),
            bill_date: b.bill_date.to_rfc3339(),
            due_date: b.due_date.to_rfc3339(),
            total_amount: b.total_amount.to_string(),
            balance_due: b.balance_due.to_string(),
            status: format!("{:?}", b.status),
            expense_account_id: b.expense_account_id.to_string(),
            ap_account_id: b.ap_account_id.to_string(),
            description: b.description,
        }
    }
}

impl TryFrom<BillPaymentDto> for BillPayment {
    type Error = anyhow::Error;
    fn try_from(dto: BillPaymentDto) -> Result<Self, Self::Error> {
        use chrono::{DateTime, Utc};
        use std::str::FromStr;
        Ok(Self {
            id: dto
                .id
                .map(|s| Uuid::parse_str(&s))
                .unwrap_or_else(|| Ok(Uuid::new_v4()))?,
            bill_id: Uuid::parse_str(&dto.bill_id)?,
            amount: rust_decimal::Decimal::from_str(&dto.amount)?,
            payment_date: DateTime::parse_from_rfc3339(&dto.payment_date)?.with_timezone(&Utc),
            payment_method: dto.payment_method,
            bank_account_id: Uuid::parse_str(&dto.bank_account_id)?,
            gl_entry_id: None,
            reference: dto.reference,
        })
    }
}
