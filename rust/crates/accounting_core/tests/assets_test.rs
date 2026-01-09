use accounting_core::assets::depreciation::{DepreciationCalculator, StraightLineDepreciation};
use accounting_core::assets::models::{AssetCategory, AssetStatus, DepreciationMethod, FixedAsset};
use accounting_core::assets::service::AssetService;
use chrono::NaiveDate;
use rust_decimal::prelude::FromStr;
use rust_decimal::Decimal;
use uuid::Uuid;

#[test]
fn test_straight_line_depreciation() {
    let calculator = StraightLineDepreciation;
    let cost = Decimal::from(12000);
    let residual = Decimal::from(0);
    let useful_life = 1; // 1 year

    let acq_date = NaiveDate::from_ymd_opt(2023, 1, 1).unwrap();
    let start = NaiveDate::from_ymd_opt(2023, 1, 1).unwrap();
    let end = NaiveDate::from_ymd_opt(2023, 1, 31).unwrap(); // 1 month

    let amount =
        calculator.calculate_period_depreciation(cost, residual, useful_life, acq_date, start, end);

    // 12000 / 1 year = 12000 per year.
    // Days in jan = 31.
    // 12000 * (31/365) = 1019.18 (approx)
    // Let's verify precise calculation: 12000 * 31 / 365 = 1019.178... -> 1019.18
    assert_eq!(amount, Decimal::from_str("1019.18").unwrap());
}

#[test]
fn test_create_acquisition_entry() {
    let service = AssetService::new();
    let asset_id = Uuid::new_v4();
    let category_id = Uuid::new_v4();
    let asset = FixedAsset {
        id: asset_id,
        code: "AST-001".to_string(),
        name_en: "Test Laptop".to_string(),
        name_ar: "لابتوب тестовый".to_string(),
        description: None,
        category_id,
        acquisition_date: NaiveDate::from_ymd_opt(2023, 1, 1).unwrap(),
        cost: Decimal::from(2000),
        residual_value: Decimal::from(0),
        useful_life_years: 3,
        depreciation_method: DepreciationMethod::StraightLine,
        status: AssetStatus::Active,
        accumulated_depreciation: Decimal::ZERO,
        asset_account_id: Uuid::new_v4(),
        depreciation_account_id: Uuid::new_v4(),
        accum_depreciation_account_id: Uuid::new_v4(),
        is_active: true,
    };

    let asset_account = Uuid::new_v4();
    let bank_account = Uuid::new_v4();
    let created_by = Uuid::new_v4();

    let entry = service
        .create_acquisition_entry(
            &asset,
            asset_account,
            bank_account,
            "Purchase Laptop".to_string(),
            created_by,
        )
        .unwrap();

    assert!(entry.is_balanced());
    assert_eq!(entry.total_debits(), Decimal::from(2000));
    assert_eq!(entry.lines.len(), 2);
    // Line 1: Debit Asset
    assert_eq!(entry.lines[0].account_id, asset_account);
    assert_eq!(entry.lines[0].debit_amount, Decimal::from(2000));
    // Line 2: Credit Bank
    assert_eq!(entry.lines[1].account_id, bank_account);
    assert_eq!(entry.lines[1].credit_amount, Decimal::from(2000));
    assert_eq!(entry.created_by, created_by);
}

#[test]
fn test_create_depreciation_entry() {
    let service = AssetService::new();
    let category = AssetCategory {
        id: Uuid::new_v4(),
        name_en: "IT Equipment".to_string(),
        name_ar: "معدات IT".to_string(),
        description: None,
        default_useful_life_years: 3,
        default_depreciation_method: DepreciationMethod::StraightLine,
        asset_account_id: Some(Uuid::new_v4()),
        depreciation_account_id: Some(Uuid::new_v4()), // Expense
        accum_depreciation_account_id: Some(Uuid::new_v4()), // Contra
    };

    let asset = FixedAsset {
        id: Uuid::new_v4(),
        code: "AST-001".to_string(),
        name_en: "Test Laptop".to_string(),
        name_ar: "لابتوب тестовый".to_string(),
        description: None,
        category_id: category.id,
        acquisition_date: NaiveDate::from_ymd_opt(2023, 1, 1).unwrap(),
        cost: Decimal::from(2000),
        residual_value: Decimal::from(0),
        useful_life_years: 3,
        depreciation_method: DepreciationMethod::StraightLine,
        status: AssetStatus::Active,
        accumulated_depreciation: Decimal::ZERO,
        asset_account_id: Uuid::new_v4(),
        depreciation_account_id: Uuid::new_v4(),
        accum_depreciation_account_id: Uuid::new_v4(),
        is_active: true,
    };

    let amount = Decimal::from(100);
    let period_end = NaiveDate::from_ymd_opt(2023, 1, 31).unwrap();
    let created_by = Uuid::new_v4();

    let entry = service
        .create_depreciation_entry(&asset, &category, amount, period_end, created_by)
        .unwrap();

    assert!(entry.is_balanced());
    assert_eq!(entry.total_debits(), amount);
    // Line 1: Debit Expense
    assert_eq!(
        entry.lines[0].account_id,
        category.depreciation_account_id.unwrap()
    );
    assert_eq!(entry.lines[0].debit_amount, amount);
    // Line 2: Credit Accum Depr
    assert_eq!(
        entry.lines[1].account_id,
        category.accum_depreciation_account_id.unwrap()
    );
    assert_eq!(entry.lines[1].credit_amount, amount);
}
