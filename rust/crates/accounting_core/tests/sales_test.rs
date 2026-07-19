use accounting_core::partners::models::{Partner, PartnerType};
use accounting_core::sales::models::{SalesInvoice, SalesInvoiceLine, SalesInvoiceStatus};
use accounting_core::sales::service::SalesService;
use accounting_zatca::crypto::{generate_key_pair, Certificate, PrivateKey};
use chrono::Utc;
use rust_decimal::Decimal;
use uuid::Uuid;

#[test]
fn test_finalize_invoice_with_zatca() {
    // 1. Setup Keys
    let (priv_pem, _pub_pem) = generate_key_pair();
    let certificate = Certificate {
        content: "CERT_BASE64_DEMO".to_string(),
    };
    let private_key = PrivateKey { content: priv_pem };

    // 2. Setup Partners
    let mut seller = Partner::new("S123", "البائع", "Seller", PartnerType::Vendor);
    seller.tax_id = Some("310122393500003".to_string()); // 15 digit VAT ID

    let mut customer = Partner::new("C456", "المشتري", "Buyer", PartnerType::Customer);
    customer.tax_id = Some("310122393500003".to_string());

    // 3. Setup Invoice
    let mut invoice = SalesInvoice {
        id: Uuid::new_v4(),
        invoice_number: "INV-2026-001".to_string(),
        customer_id: customer.id,
        invoice_date: Utc::now(),
        due_date: Utc::now(),
        total_amount: Decimal::from(115),
        balance_due: Decimal::from(115),
        status: SalesInvoiceStatus::Draft,
        income_account_id: Uuid::new_v4(),
        ar_account_id: Uuid::new_v4(),
        gl_entry_id: None,
        description: Some("Test Invoice".to_string()),
        zatca_uuid: None,
        zatca_hash: None,
        zatca_previous_hash: None,
        xml_content: None,
        qr_code_data: None,
    };

    let line = SalesInvoiceLine {
        id: Uuid::new_v4(),
        invoice_id: invoice.id,
        product_id: Some(Uuid::new_v4()),
        description: "Test Product".to_string(),
        quantity: Decimal::from(1),
        unit_price: Decimal::from(100),
        tax_amount: Decimal::from(15),
        tax_category: "S".to_string(),
        total_amount: Decimal::from(115),
    };

    let lines = vec![line];

    // 4. Finalize
    SalesService::finalize_invoice(
        &mut invoice,
        &lines,
        &customer,
        &seller,
        &certificate,
        &private_key,
        1,
        "PREVIOUS_HASH_PLACEHOLDER".to_string(),
    )
    .expect("Finalization failed");

    // 5. Assertions
    assert_eq!(invoice.status, SalesInvoiceStatus::Posted);
    assert!(invoice.xml_content.is_some());
    assert!(invoice.qr_code_data.is_some());
    assert_eq!(invoice.zatca_uuid, Some(invoice.id));

    let xml = invoice.xml_content.unwrap();
    println!("Generated XML: {}", xml);
    assert!(xml.contains("<cbc:ID>INV-2026-001</cbc:ID>"));
    assert!(xml.contains("<cbc:UUID>"));
}
