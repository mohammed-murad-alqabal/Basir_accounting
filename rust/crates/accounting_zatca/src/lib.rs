pub mod crypto;
pub mod csr;
pub mod qr;
pub mod service;
pub mod xades;
pub mod xml_builder;

#[cfg(test)]
mod tests {
    use crate::crypto::{generate_key_pair, Certificate, PrivateKey};
    use crate::service::{ZatcaInvoiceInput, ZatcaInvoiceLineInput, ZatcaService};
    use crate::xml_builder::{
        AccountingCustomerParty, AccountingSupplierParty, Party, PartyId, PartyIdentification,
        TaxCategoryCode,
    };
    use rust_decimal::Decimal;

    #[test]
    fn test_zatca_invoice_generation_multi_rate() {
        // 1. Setup Keys
        let (priv_pem, pub_pem) = generate_key_pair();
        let private_key = <credential-fixture> { content: priv_pem };
        let certificate = Certificate {
            content: pub_pem, // Simplified for test
        };

        // 2. Prepare Input
        let input = ZatcaInvoiceInput {
            id: "INV-001".to_string(),
            uuid: "cfa1c308-41f2-4217-b761-000000000001".to_string(),
            issue_date: "2023-10-27".to_string(),
            issue_time: "10:00:00".to_string(),
            invoice_type_code: "388".to_string(),
            invoice_counter_value: 123,
            previous_invoice_hash: "NWZlY2ViNjZmZmM4NmYzOGQ5NTI3ODZjNmQ2OTZjNzljMjRiZmQzNTljMzc5NDU4Y2Q3Y2Q4NDgwZDYyNWVmOA==".to_string(),
            seller_party: AccountingSupplierParty {
                party: Party {
                    party_identification: PartyIdentification {
                        id: PartyId { value: "300000000000003".to_string(), scheme_id: "CRN".to_string() },
                    },
                    ..Default::default()
                },
            },
            buyer_party: AccountingCustomerParty {
                party: Party {
                    party_identification: PartyIdentification {
                        id: PartyId { value: "300000000000003".to_string(), scheme_id: "NAT".to_string() },
                    },
                    ..Default::default()
                },
            },
            lines: vec![
                // Standard Rate Item (15%)
                ZatcaInvoiceLineInput {
                    id: "1".to_string(),
                    item_name: "Widget Standard".to_string(),
                    quantity: Decimal::from(2),
                    unit_price: Decimal::from(100), // Total 200, Tax 30
                    tax_category: TaxCategoryCode::Standard,
                },
                // Zero Rated Item (0%)
                ZatcaInvoiceLineInput {
                    id: "2".to_string(),
                    item_name: "Widget Zero".to_string(),
                    quantity: Decimal::from(5),
                    unit_price: Decimal::from(10), // Total 50, Tax 0
                    tax_category: TaxCategoryCode::ZeroRated,
                },
            ],
        };

        // 3. Generate
        let result = ZatcaService::generate_signed_invoice(input, &certificate, &private_key);
        if let Err(e) = &result {
            println!("Error: {:?}", e);
        }
        assert!(result.is_ok());

        let (xml, qr) = result.unwrap();

        // 4. Verify Content
        // println!("Generated XML: {}", xml);
        assert!(xml.contains("<cbc:ID>INV-001</cbc:ID>"));
        assert!(!qr.is_empty());

        // Verify Tax Totals roughly by value check
        // Line 1: 2 * 100 = 200. Tax 15% = 30.
        // Line 2: 5 * 10 = 50. Tax 0% = 0.
        // Total Tax = 30.00
        // We check for the value and currencyID separately to be safe against attribute ordering
        assert!(xml.contains("30.00"));
        assert!(xml.contains("currencyID=\"SAR\""));

        // Verify Subtotals exist
        // Standard (S) - 15%
        assert!(xml.contains("<cbc:ID>S</cbc:ID>"));
        assert!(xml.contains("<cbc:Percent>15.00</cbc:Percent>"));

        // Zero (Z)
        assert!(xml.contains("<cbc:ID>Z</cbc:ID>"));
    }

    #[test]
    fn test_zatca_csr_generation() {
        use crate::csr::{generate_csr, ZatcaCsrInput};

        let (priv_pem, _) = generate_key_pair();
        let input = ZatcaCsrInput {
            common_name: "TST-DEVICE-001".to_string(),
            organization_unit: "IT Department".to_string(),
            organization: "Basir Solutions".to_string(),
            country: "SA".to_string(),
            serial_number: "1-Basir|2-MVP|3-001".to_string(),
            vat_number: "310122393500003".to_string(),
            business_category: "Retail".to_string(),
            registered_address: "Riyadh, Saudi Arabia".to_string(),
        };

        let result = generate_csr(input, &priv_pem);
        assert!(result.is_ok());

        let csr_pem = result.unwrap();
        assert!(csr_pem.contains("-----BEGIN CERTIFICATE REQUEST-----"));
        assert!(csr_pem.contains("-----END CERTIFICATE REQUEST-----"));
    }
}
