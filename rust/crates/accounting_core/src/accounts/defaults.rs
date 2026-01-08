use super::models::{Account, AccountClassification, AccountKind};
use uuid::Uuid;

/// Helper to generate a stable UUID for a default account based on its code.
fn stable_id(code: &str) -> Uuid {
    let namespace = Uuid::from_u128(0x6ba7b810_9dad_11d1_80b4_00c04fd430c8); // DNS Namespace as base
    let basir_namespace = Uuid::new_v5(&namespace, b"basir.accounting.accounts");
    Uuid::new_v5(&basir_namespace, code.as_bytes())
}

/// Generates the default IFRS-aligned Chart of Accounts.
pub fn default_chart_of_accounts() -> Vec<Account> {
    let mut accounts = Vec::new();

    // ==========================================
    // 1000 ASSETS
    // ==========================================
    let mut assets = Account::new("1000", "الأصول", "Assets", AccountKind::Asset);
    assets.id = stable_id("1000");
    let assets_id = assets.id;
    accounts.push(assets);

    // 1100 Current Assets
    let mut current_assets = Account::new(
        "1100",
        "الأصول المتداولة",
        "Current Assets",
        AccountKind::Asset,
    )
    .with_parent(assets_id);
    current_assets.id = stable_id("1100");
    current_assets.classification = Some(AccountClassification::Current);
    let ca_id = current_assets.id;
    accounts.push(current_assets);

    // 1110 Cash and Cash Equivalents
    let mut cash = Account::new(
        "1110",
        "النقد وما في حكمه",
        "Cash and Cash Equivalents",
        AccountKind::Asset,
    )
    .with_parent(ca_id)
    .with_ifrs_tag("ifrs-full:CashAndCashEquivalents");
    cash.id = stable_id("1110");
    accounts.push(cash);

    // 1120 Trade Receivables
    let mut ar = Account::new(
        "1120",
        "الذمم المدينة وتجارية أخرى",
        "Trade and Other Receivables",
        AccountKind::Asset,
    )
    .with_parent(ca_id)
    .with_ifrs_tag("ifrs-full:TradeAndOtherReceivables");
    ar.id = stable_id("1120");
    ar.requires_partner = true;
    accounts.push(ar);

    // 1200 Non-Current Assets
    let mut non_current_assets = Account::new(
        "1200",
        "الأصول غير المتداولة",
        "Non-Current Assets",
        AccountKind::Asset,
    )
    .with_parent(assets_id);
    non_current_assets.id = stable_id("1200");
    non_current_assets.classification = Some(AccountClassification::NonCurrent);
    let nca_id = non_current_assets.id;
    accounts.push(non_current_assets);

    // 1210 Property, Plant and Equipment
    let mut ppe = Account::new(
        "1210",
        "الممتلكات والمشروعات والمعدات",
        "Property, Plant and Equipment",
        AccountKind::Asset,
    )
    .with_parent(nca_id)
    .with_ifrs_tag("ifrs-full:PropertyPlantAndEquipment");
    ppe.id = stable_id("1210");
    accounts.push(ppe);

    // ==========================================
    // 2000 LIABILITIES
    // ==========================================
    let mut liabilities = Account::new("2000", "المطلوبات", "Liabilities", AccountKind::Liability);
    liabilities.id = stable_id("2000");
    let liabilities_id = liabilities.id;
    accounts.push(liabilities);

    // 2100 Current Liabilities
    let mut current_liab = Account::new(
        "2100",
        "المطلوبات المتداولة",
        "Current Liabilities",
        AccountKind::Liability,
    )
    .with_parent(liabilities_id);
    current_liab.id = stable_id("2100");
    current_liab.classification = Some(AccountClassification::Current);
    let cl_id = current_liab.id;
    accounts.push(current_liab);

    // 2110 Trade Payables
    let mut ap = Account::new(
        "2110",
        "الذمم الدائنة وتجارية أخرى",
        "Trade and Other Payables",
        AccountKind::Liability,
    )
    .with_parent(cl_id)
    .with_ifrs_tag("ifrs-full:TradeAndOtherPayables");
    ap.id = stable_id("2110");
    ap.requires_partner = true;
    accounts.push(ap);

    // ==========================================
    // 3000 EQUITY
    // ==========================================
    let mut equity = Account::new("3000", "حقوق الملكية", "Equity", AccountKind::Equity);
    equity.id = stable_id("3000");
    let equity_id = equity.id;
    accounts.push(equity);

    // 3100 Share Capital
    let mut capital = Account::new(
        "3100",
        "رأس المال المصدر",
        "Share Capital",
        AccountKind::Equity,
    )
    .with_parent(equity_id)
    .with_ifrs_tag("ifrs-full:IssuedCapital");
    capital.id = <credential-fixture>("3100");
    accounts.push(capital);

    // 3200 Retained Earnings
    let mut retained = Account::new(
        "3200",
        "الأرباح المبقاة",
        "Retained Earnings",
        AccountKind::Equity,
    )
    .with_parent(equity_id)
    .with_ifrs_tag("ifrs-full:RetainedEarnings");
    retained.id = stable_id("3200");
    accounts.push(retained);

    // ==========================================
    // 4000 INCOME
    // ==========================================
    let mut income = Account::new("4000", "الدخل", "Income", AccountKind::Income);
    income.id = stable_id("4000");
    let income_id = income.id;
    accounts.push(income);

    // 4100 Revenue
    let mut revenue = Account::new("4100", "الإيرادات", "Revenue", AccountKind::Income)
        .with_parent(income_id)
        .with_ifrs_tag("ifrs-full:Revenue");
    revenue.id = stable_id("4100");
    revenue.classification = Some(AccountClassification::Operating);
    accounts.push(revenue);

    // ==========================================
    // 5000 EXPENSES
    // ==========================================
    let mut expenses = Account::new("5000", "المصروفات", "Expenses", AccountKind::Expense);
    expenses.id = stable_id("5000");
    let expenses_id = expenses.id;
    accounts.push(expenses);

    // 5100 Cost of Sales
    let mut cos = Account::new(
        "5100",
        "تكلفة المبيعات",
        "Cost of Sales",
        AccountKind::Expense,
    )
    .with_parent(expenses_id)
    .with_ifrs_tag("ifrs-full:CostOfSales");
    cos.id = stable_id("5100");
    cos.classification = Some(AccountClassification::Operating);
    accounts.push(cos);

    // 5200 Administrative Expenses
    let mut admin = Account::new(
        "5200",
        "المصروفات الإدارية",
        "Administrative Expenses",
        AccountKind::Expense,
    )
    .with_parent(expenses_id)
    .with_ifrs_tag("ifrs-full:AdministrativeExpenses");
    admin.id = stable_id("5200");
    admin.classification = Some(AccountClassification::Operating);
    accounts.push(admin);

    accounts
}
