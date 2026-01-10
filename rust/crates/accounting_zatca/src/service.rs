use crate::crypto::{Certificate, PrivateKey, SigningService};
use crate::xml_builder::{
    AccountingCustomerParty, AccountingSupplierParty, AdditionalDocumentReference, Attachment,
    EmbeddedDocumentBinaryObject, Invoice, InvoiceLine, InvoiceTypeCode, Item, LegalMonetaryTotal,
    TaxCategoryCode, TaxSubtotal, TaxTotal,
};
use anyhow::Result;
use rust_decimal::Decimal;
use std::collections::HashMap;

/// Input model for the ZATCA Service.
/// This decouples the service from the core `SalesInvoice` model.
pub struct ZatcaInvoiceInput {
    pub id: String,
    pub uuid: String,
    pub issue_date: String,
    pub issue_time: String,
    pub invoice_type_code: String,     // e.g., "388" for Tax Invoice
    pub invoice_counter_value: u64,    // ICV
    pub previous_invoice_hash: String, // PIH

    pub seller_party: AccountingSupplierParty,
    pub buyer_party: AccountingCustomerParty,

    pub lines: Vec<ZatcaInvoiceLineInput>,
}

pub struct ZatcaInvoiceLineInput {
    pub id: String,
    pub quantity: Decimal,
    pub unit_price: Decimal, // Exclusive of VAT
    pub tax_category: TaxCategoryCode,
    pub item_name: String,
}

pub struct ZatcaService;

impl ZatcaService {
    /// Generates a signed ZATCA-compliant UBL XML string and its QR code.
    ///
    /// The process follows these steps:
    /// 1. Construct the base XML structure (Invoice, Supplier, Customer, Lines).
    /// 2. Calculate Taxes and Totals based on Multi-rate VAT logic.
    /// 3. Canonicalize and Hash the XML.
    /// 4. Sign the Hash using the Private Key.
    /// 5. Generate the XAdES properties.
    /// 6. Embed the Signature and QR Code into the UBL Extensions.
    /// 7. Return the final XML.
    pub fn generate_signed_invoice(
        input: ZatcaInvoiceInput,
        certificate: &Certificate,
        private_key: &PrivateKey,
    ) -> Result<(String, String)> {
        // (Signed XML, QR Code Data)

        let mut invoice = Invoice::new_standard(
            input.id.clone(),
            input.uuid.clone(),
            input.issue_date.clone(),
            input.issue_time.clone(),
        );

        // 1. Set Type Code
        invoice.invoice_type_code = InvoiceTypeCode {
            value: input.invoice_type_code.clone(),
            name: "0100000".to_string(), // Default to Standard Invoice subtype
        };

        // 2. Add Additional Document References for ICV and PIH
        // ICV
        invoice
            .additional_document_references
            .push(AdditionalDocumentReference {
                id: "ICV".to_string(),
                uuid: Some(input.invoice_counter_value.to_string()),
                ..Default::default()
            });
        // PIH
        invoice
            .additional_document_references
            .push(AdditionalDocumentReference {
                id: "PIH".to_string(),
                attachment: Some(Attachment {
                    embedded_document_binary_object: EmbeddedDocumentBinaryObject {
                        mime_code: "text/plain".to_string(),
                        value: input.previous_invoice_hash.clone(), // Field is named value in struct
                    },
                }),
                ..Default::default()
            });

        // 3. Parties
        invoice.accounting_supplier_party = input.seller_party;
        invoice.accounting_customer_party = input.buyer_party;

        // 4. Lines & Totals Calculation (Multi-rate Logic)
        let mut total_line_extension = Decimal::ZERO;
        let mut total_tax_exclusive = Decimal::ZERO;
        let mut total_tax_inclusive = Decimal::ZERO;
        let mut total_tax_amount = Decimal::ZERO; // Total VAT
        let mut tax_subtotals_map: HashMap<String, (Decimal, Decimal)> = HashMap::new();
        // Key: TaxCategoryCode (S, Z, E, O), Value: (TaxableAmount, TaxAmount)

        let mut xml_lines = Vec::new();

        for line_input in input.lines {
            let line_extension = line_input.quantity * line_input.unit_price;
            let tax_rate = Decimal::from_str_exact(line_input.tax_category.rate())?;
            let tax_percent = tax_rate / Decimal::from(100);
            let tax_amount = line_extension * tax_percent;

            total_line_extension += line_extension;
            total_tax_exclusive += line_extension;
            total_tax_amount += tax_amount;
            total_tax_inclusive += line_extension + tax_amount;

            // Group by Tax Category for Invoice-level Subtotals
            let code_str = line_input.tax_category.as_str().to_string();
            let entry = tax_subtotals_map
                .entry(code_str.clone())
                .or_insert((Decimal::ZERO, Decimal::ZERO));
            entry.0 += line_extension; // Taxable Amount
            entry.1 += tax_amount; // Tax Amount

            // Create Invoice Line XML struct
            let xml_line = InvoiceLine {
                id: line_input.id,
                invoiced_quantity: crate::xml_builder::Quantity {
                    unit_code: "PCE".to_string(), // Defaulted to Piece
                    value: format!("{:.2}", line_input.quantity),
                },
                line_extension_amount: crate::xml_builder::Amount {
                    currency_id: "SAR".to_string(),
                    value: format!("{:.2}", line_extension),
                },
                item: Item {
                    name: line_input.item_name,
                    classified_tax_category: crate::xml_builder::TaxCategory::new(
                        line_input.tax_category,
                    ),
                },
                price: crate::xml_builder::Price {
                    price_amount: crate::xml_builder::Amount {
                        currency_id: "SAR".to_string(),
                        value: format!("{:.2}", line_input.unit_price),
                    },
                },
                tax_total: TaxTotal {
                    tax_amount: crate::xml_builder::Amount {
                        currency_id: "SAR".to_string(),
                        value: format!("{:.2}", tax_amount),
                    },
                    tax_subtotal: None, // Usually handled at document level, but line level needs simple total
                },
            };
            xml_lines.push(xml_line);
        }

        invoice.invoice_lines = xml_lines;

        // 5. Populate Invoice Tax Total (with Subtotals)
        let mut tax_subtotals_vec = Vec::new();
        for (code_str, (taxable, tax_amt)) in tax_subtotals_map {
            // Re-map sting back to code or just construct TaxCategory manually since I implemented new() with code
            // But wait, I have the code string "S", "Z" etc.
            let cat_code = match code_str.as_str() {
                "S" => TaxCategoryCode::Standard,
                "Z" => TaxCategoryCode::ZeroRated,
                "E" => TaxCategoryCode::Exempt,
                "O" => TaxCategoryCode::OutOfScope,
                _ => TaxCategoryCode::Standard, // Fallback
            };

            tax_subtotals_vec.push(TaxSubtotal {
                taxable_amount: crate::xml_builder::Amount {
                    currency_id: "SAR".to_string(),
                    value: format!("{:.2}", taxable),
                },
                tax_amount: crate::xml_builder::Amount {
                    currency_id: "SAR".to_string(),
                    value: format!("{:.2}", tax_amt),
                },
                tax_category: crate::xml_builder::TaxCategory::new(cat_code),
            });
        }

        invoice.tax_total.push(TaxTotal {
            tax_amount: crate::xml_builder::Amount {
                currency_id: "SAR".to_string(),
                value: format!("{:.2}", total_tax_amount),
            },
            tax_subtotal: Some(tax_subtotals_vec),
        });

        // 6. Legal Monetary Total
        invoice.legal_monetary_total = LegalMonetaryTotal {
            line_extension_amount: crate::xml_builder::Amount {
                currency_id: "SAR".to_string(),
                value: format!("{:.2}", total_line_extension),
            },
            tax_exclusive_amount: crate::xml_builder::Amount {
                currency_id: "SAR".to_string(),
                value: format!("{:.2}", total_tax_exclusive),
            },
            tax_inclusive_amount: crate::xml_builder::Amount {
                currency_id: "SAR".to_string(),
                value: format!("{:.2}", total_tax_inclusive),
            },
            allowance_total_amount: None, // Discounts not yet handled in this input model
            charge_total_amount: None,
            prepaid_amount: None,
            payable_amount: crate::xml_builder::Amount {
                currency_id: "SAR".to_string(),
                value: format!("{:.2}", total_tax_inclusive), // Usually same as tax inclusive if no prepaid
            },
        };

        // 7. Initial Serialization to calculate Hash
        // NOTE: In Phase 2, we need clean XML for strict canonicalization.
        // For simpler MVP, we rely on the builder's to_xml then external canonicalization simulation.
        // A specialized library for C14N is recommended or careful byte manipulation.
        // For now, let's pretend "to_xml()" produces C14N compliant XML if passed through a transform.

        let raw_xml = invoice.to_xml()?;

        // 8. Sign
        let signing_service = SigningService::new(certificate.clone(), private_key.clone());
        let (signed_xml, qr_str) = signing_service.sign_xml(&raw_xml)?; // This handles hashing, QR, and XAdES embedding

        Ok((signed_xml, qr_str))
    }
}
