use crate::api::{get_pool, AuditMetadataDto};
use accounting_core::accounts::models::{Account, AccountClassification, AccountKind};
use accounting_data::db::accounts::PgAccountRepository;
use uuid::Uuid;

/// DTO for Account
pub struct AccountDto {
    pub id: String,
    pub code: String,
    pub name_ar: String,
    pub name_en: String,
    pub kind: String, // "Asset", "Liability", etc.
    pub parent_id: Option<String>,
    pub ifrs_tag: Option<String>,
    pub classification: Option<String>,
    pub ifrs18_category: String,
    pub currency: String,
}

impl From<Account> for AccountDto {
    fn from(a: Account) -> Self {
        Self {
            id: a.id.to_string(),
            code: a.code,
            name_ar: a.name_ar,
            name_en: a.name_en,
            kind: format!("{:?}", a.kind),
            parent_id: a.parent_id.map(|id| id.to_string()),
            ifrs_tag: a.ifrs_tag,
            classification: a.classification.map(|c| format!("{:?}", c)),
            ifrs18_category: format!("{:?}", a.ifrs18_category),
            currency: a.currency.unwrap_or_default(),
        }
    }
}

pub async fn create_account(dto: AccountDto, metadata: AuditMetadataDto) -> anyhow::Result<String> {
    let pool = get_pool()?;
    let repo = PgAccountRepository::new(pool.clone());

    let account = Account {
        id: Uuid::new_v4(),
        code: dto.code,
        name_ar: dto.name_ar,
        name_en: dto.name_en,
        kind: match dto.kind.as_str() {
            "Asset" => AccountKind::Asset,
            "Liability" => AccountKind::Liability,
            "Equity" => AccountKind::Equity,
            "Income" => AccountKind::Income,
            "Expense" => AccountKind::Expense,
            _ => AccountKind::Asset,
        },
        parent_id: dto.parent_id.map(|s| Uuid::parse_str(&s)).transpose()?,
        ifrs_tag: dto.ifrs_tag,
        classification: dto.classification.map(|s| match s.as_str() {
            "Current" => AccountClassification::Current,
            "NonCurrent" => AccountClassification::NonCurrent,
            "Operating" => AccountClassification::Operating,
            "Financing" => AccountClassification::Financing,
            "Investing" => AccountClassification::Investing,
            "IncomeTaxes" => AccountClassification::IncomeTaxes,
            "DiscontinuedOperations" => AccountClassification::DiscontinuedOperations,
            "ZakahAssets" => AccountClassification::ZakahAssets,
            "ZakahLiabilities" => AccountClassification::ZakahLiabilities,
            _ => AccountClassification::Current,
        }),
        ifrs18_category: match dto.ifrs18_category.as_str() {
            "Operating" => accounting_core::accounts::models::Ifrs18Category::Operating,
            "Investing" => accounting_core::accounts::models::Ifrs18Category::Investing,
            "Financing" => accounting_core::accounts::models::Ifrs18Category::Financing,
            "IncomeTax" => accounting_core::accounts::models::Ifrs18Category::IncomeTax,
            "Discontinued" => accounting_core::accounts::models::Ifrs18Category::Discontinued,
            _ => accounting_core::accounts::models::Ifrs18Category::Operating,
        },
        currency: Some(dto.currency),
        description: None,
        requires_partner: false,
        is_active: true,
    };

    let audit_meta = metadata.try_into()?;
    repo.save(&account, &audit_meta).await?;
    Ok(account.id.to_string())
}

pub async fn update_account(dto: AccountDto, metadata: AuditMetadataDto) -> anyhow::Result<()> {
    let pool = get_pool()?;
    let repo = PgAccountRepository::new(pool.clone());

    let uuid = Uuid::parse_str(&dto.id)?;
    let mut account = repo
        .get_by_id(uuid)
        .await?
        .ok_or_else(|| anyhow::anyhow!("Account not found"))?;

    // Update mutable fields
    account.code = dto.code;
    account.name_ar = dto.name_ar;
    account.name_en = dto.name_en;
    account.kind = match dto.kind.as_str() {
        "Asset" => AccountKind::Asset,
        "Liability" => AccountKind::Liability,
        "Equity" => AccountKind::Equity,
        "Income" => AccountKind::Income,
        "Expense" => AccountKind::Expense,
        _ => AccountKind::Asset,
    };
    account.parent_id = dto.parent_id.map(|s| Uuid::parse_str(&s)).transpose()?;
    account.ifrs_tag = dto.ifrs_tag;
    account.classification = dto.classification.map(|s| match s.as_str() {
        "Current" => AccountClassification::Current,
        "NonCurrent" => AccountClassification::NonCurrent,
        "Operating" => AccountClassification::Operating,
        "Financing" => AccountClassification::Financing,
        "Investing" => AccountClassification::Investing,
        "IncomeTaxes" => AccountClassification::IncomeTaxes,
        "DiscontinuedOperations" => AccountClassification::DiscontinuedOperations,
        "ZakahAssets" => AccountClassification::ZakahAssets,
        "ZakahLiabilities" => AccountClassification::ZakahLiabilities,
        _ => AccountClassification::Current,
    });
    account.ifrs18_category = match dto.ifrs18_category.as_str() {
        "Operating" => accounting_core::accounts::models::Ifrs18Category::Operating,
        "Investing" => accounting_core::accounts::models::Ifrs18Category::Investing,
        "Financing" => accounting_core::accounts::models::Ifrs18Category::Financing,
        "IncomeTax" => accounting_core::accounts::models::Ifrs18Category::IncomeTax,
        "Discontinued" => accounting_core::accounts::models::Ifrs18Category::Discontinued,
        _ => accounting_core::accounts::models::Ifrs18Category::Operating,
    };
    account.currency = Some(dto.currency);

    let audit_meta = metadata.try_into()?;
    repo.save(&account, &audit_meta).await?;
    Ok(())
}

pub async fn list_accounts() -> anyhow::Result<Vec<AccountDto>> {
    let pool = get_pool()?;
    let repo = PgAccountRepository::new(pool.clone());
    let accounts: Vec<Account> = repo.list_all().await?;
    Ok(accounts.into_iter().map(AccountDto::from).collect())
}

pub async fn get_account_by_id(id: String) -> anyhow::Result<Option<AccountDto>> {
    let pool = get_pool()?;
    let repo = PgAccountRepository::new(pool.clone());
    let uuid = Uuid::parse_str(&id)?;
    let account = repo.get_by_id(uuid).await?;
    Ok(account.map(AccountDto::from))
}

pub async fn update_account_category(
    account_id: String,
    category: String,
    metadata: AuditMetadataDto,
) -> anyhow::Result<()> {
    let pool = get_pool()?;
    let repo = PgAccountRepository::new(pool.clone());
    let uuid = Uuid::parse_str(&account_id)?;

    let mut account = repo
        .get_by_id(uuid)
        .await?
        .ok_or_else(|| anyhow::anyhow!("Account not found"))?;

    account.classification = Some(match category.as_str() {
        "Operating" => AccountClassification::Operating,
        "Financing" => AccountClassification::Financing,
        "Investing" => AccountClassification::Investing,
        "IncomeTaxes" => AccountClassification::IncomeTaxes,
        "DiscontinuedOperations" => AccountClassification::DiscontinuedOperations,
        _ => AccountClassification::Operating,
    });

    let audit_meta = metadata.try_into()?;
    repo.save(&account, &audit_meta).await?;
    Ok(())
}
