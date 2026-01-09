use accounting_core::inventory::models::{
    InventoryItem, MovementType, StockMovement, ValuationMethod,
};
use accounting_core::inventory::service::InventoryService;
use chrono::Utc;
use rust_decimal::Decimal;
use uuid::Uuid;

#[test]
fn test_fifo_valuation() {
    let item = InventoryItem {
        id: Uuid::new_v4(),
        code: "TEST-001".to_string(),
        name_ar: "تجربة".to_string(),
        name_en: "Test Item".to_string(),
        description: None,
        unit: "Pcs".to_string(),
        valuation_method: ValuationMethod::Fifo,
        purchase_price: None,
        sale_price: None,
        asset_account_id: Uuid::new_v4(),
        cogs_account_id: Uuid::new_v4(),
        revenue_account_id: Uuid::new_v4(),
        created_at: Utc::now(),
        updated_at: Utc::now(),
    };

    let movements = vec![
        StockMovement {
            id: Uuid::new_v4(),
            item_id: item.id,
            movement_type: MovementType::Inbound,
            quantity: Decimal::new(10, 0),
            unit_cost: Decimal::new(100, 0), // Total 1000
            date: Utc::now(),
            reference_id: None,
            description: None,
            hash: String::new(),
            previous_hash: String::new(),
        },
        StockMovement {
            id: Uuid::new_v4(),
            item_id: item.id,
            movement_type: MovementType::Inbound,
            quantity: Decimal::new(10, 0),
            unit_cost: Decimal::new(150, 0), // Total 1500
            date: Utc::now(),
            reference_id: None,
            description: None,
            hash: String::new(),
            previous_hash: String::new(),
        },
    ];

    // Sale of 15 units.
    // FIFO should take 10 from $100 and 5 from $150.
    // COGS = 10 * 100 + 5 * 150 = 1000 + 750 = 1750.
    let cogs = InventoryService::calculate_cogs(&item, Decimal::new(15, 0), &movements).unwrap();
    assert_eq!(cogs, Decimal::new(1750, 0));

    // Remaining value = 5 * 150 = 750.
    // calculate_valuation(15 sold)
    let mut movements_with_sale = movements.clone();
    movements_with_sale.push(StockMovement {
        id: Uuid::new_v4(),
        item_id: item.id,
        movement_type: MovementType::Outbound,
        quantity: Decimal::new(15, 0),
        unit_cost: Decimal::new(0, 0), // Not used for calculation
        date: Utc::now(),
        reference_id: None,
        description: None,
        hash: String::new(),
        previous_hash: String::new(),
    });

    let (qty, val) = InventoryService::calculate_valuation(&item, &movements_with_sale).unwrap();
    assert_eq!(qty, Decimal::new(5, 0));
    assert_eq!(val, Decimal::new(750, 0));
}

#[test]
fn test_weighted_average_valuation() {
    let item = InventoryItem {
        id: Uuid::new_v4(),
        code: "TEST-002".to_string(),
        name_ar: "تجربة 2".to_string(),
        name_en: "Test Item 2".to_string(),
        description: None,
        unit: "Pcs".to_string(),
        valuation_method: ValuationMethod::WeightedAverage,
        purchase_price: None,
        sale_price: None,
        asset_account_id: Uuid::new_v4(),
        cogs_account_id: Uuid::new_v4(),
        revenue_account_id: Uuid::new_v4(),
        created_at: Utc::now(),
        updated_at: Utc::now(),
    };

    let movements = vec![
        StockMovement {
            id: Uuid::new_v4(),
            item_id: item.id,
            movement_type: MovementType::Inbound,
            quantity: Decimal::new(10, 0),
            unit_cost: Decimal::new(100, 0), // Total 1000
            date: Utc::now(),
            reference_id: None,
            description: None,
            hash: String::new(),
            previous_hash: String::new(),
        },
        StockMovement {
            id: Uuid::new_v4(),
            item_id: item.id,
            movement_type: MovementType::Inbound,
            quantity: Decimal::new(10, 0),
            unit_cost: Decimal::new(150, 0), // Total 1500
            date: Utc::now(),
            reference_id: None,
            description: None,
            hash: String::new(),
            previous_hash: String::new(),
        },
    ];

    // Total Qty = 20, Total Value = 2500. Average = 125.
    // Sale of 15 units. COGS = 15 * 125 = 1875.
    let cogs = InventoryService::calculate_cogs(&item, Decimal::new(15, 0), &movements).unwrap();
    assert_eq!(cogs, Decimal::new(1875, 0));

    // Remaining value = 5 * 125 = 625.
    let mut movements_with_sale = movements.clone();
    movements_with_sale.push(StockMovement {
        id: Uuid::new_v4(),
        item_id: item.id,
        movement_type: MovementType::Outbound,
        quantity: Decimal::new(15, 0),
        unit_cost: Decimal::new(0, 0),
        date: Utc::now(),
        reference_id: None,
        description: None,
        hash: String::new(),
        previous_hash: String::new(),
    });

    let (qty, val) = InventoryService::calculate_valuation(&item, &movements_with_sale).unwrap();
    assert_eq!(qty, Decimal::new(5, 0));
    assert_eq!(val, Decimal::new(625, 0));
}
