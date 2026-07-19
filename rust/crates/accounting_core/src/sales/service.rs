use crate::partners::models::Partner;
use crate::sales::models::{SalesInvoice, SalesInvoiceLine, SalesInvoiceStatus};
use accounting_zatca::crypto::{Certificate, PrivateKey};
use accounting_zatca::service::{ZatcaInvoiceInput, ZatcaInvoiceLineInput, ZatcaService};
use accounting_zatca::xml_builder::{
    AccountingCustomerParty, AccountingSupplierParty, Party, PartyId, PartyIdentification,
    PartyLegalEntity, PartyName, PartyTaxScheme, TaxCategoryCode, TaxScheme,
};
use anyhow::{Context, Result};

pub struct SalesService;

impl SalesService {
    /// Finalizes a draft invoice, generates ZATCA compliance data, and posts it to the ledger.
    pub fn finalize_invoice(
        invoice: &mut SalesInvoice,
        lines: &[SalesInvoiceLine],
        customer: &Partner,
        seller: &Partner,
        certificate: &Certificate,
        private_key: &PrivateKey,
        invoice_counter: u64,
        previous_hash: String,
    ) -> Result<()> {
        // 1. Validation
        if invoice.status != SalesInvoiceStatus::Draft {
            anyhow::bail!("Only draft invoices can be finalized");
        }

        // 2. Map to ZATCA Input
        let zatca_input = Self::map_to_zatca_input(
            invoice,
            lines,
            customer,
            seller,
            invoice_counter,
            previous_hash,
        )?;

        // 3. Generate Signed ZATCA XML and QR Code
        let (signed_xml, qr_code) =
            ZatcaService::generate_signed_invoice(zatca_input, certificate, private_key)
                .context("Failed to generate ZATCA signed invoice")?;

        // 4. Update Invoice with Compliance Data
        invoice.status = SalesInvoiceStatus::Posted;
        invoice.xml_content = Some(signed_xml);
        invoice.qr_code_data = Some(qr_code);
        invoice.zatca_uuid = Some(invoice.id);

        // Finalize date
        invoice.invoice_date = chrono::Utc::now();

        Ok(())
    }

    fn map_to_zatca_input(
        invoice: &SalesInvoice,
        lines: &[SalesInvoiceLine],
        customer: &Partner,
        seller: &Partner,
        invoice_counter: u64,
        previous_hash: String,
    ) -> Result<ZatcaInvoiceInput> {
        let mut zatca_lines = Vec::new();
        for line in lines {
            let tax_category = match line.tax_category.as_str() {
                "S" => TaxCategoryCode::Standard,
                "Z" => TaxCategoryCode::ZeroRated,
                "E" => TaxCategoryCode::Exempt,
                "O" => TaxCategoryCode::OutOfScope,
                _ => TaxCategoryCode::Standard, // Default to Standard
            };

            zatca_lines.push(ZatcaInvoiceLineInput {
                id: line.id.to_string(),
                quantity: line.quantity,
                unit_price: line.unit_price,
                tax_category,
                item_name: line.description.clone(),
            });
        }

        Ok(ZatcaInvoiceInput {
            id: invoice.invoice_number.clone(),
            uuid: invoice.id.to_string(),
            issue_date: invoice.invoice_date.format("%Y-%m-%d").to_string(),
            issue_time: invoice.invoice_date.format("%H:%M:%S").to_string(),
            invoice_type_code: "388".to_string(), // Standard Tax Invoice
            invoice_counter_value: invoice_counter,
            previous_invoice_hash: previous_hash,
            seller_party: Self::map_partner_to_supplier(seller),
            buyer_party: Self::map_partner_to_customer(customer),
            lines: zatca_lines,
        })
    }

    fn map_partner_to_supplier(partner: &Partner) -> AccountingSupplierParty {
        AccountingSupplierParty {
            party: Party {
                party_identification: PartyIdentification {
                    id: PartyId {
                        scheme_id: "CRN".to_string(), // Commercial Registration Number
                        value: partner.code.clone(),
                    },
                },
                party_name: PartyName {
                    name: partner.name_en.clone(),
                },
                party_tax_scheme: PartyTaxScheme {
                    company_id: partner.tax_id.clone().unwrap_or_default(),
                    tax_scheme: TaxScheme {
                        id: "VAT".to_string(),
                    },
                },
                party_legal_entity: PartyLegalEntity {
                    registration_name: partner.name_en.clone(),
                },
            },
        }
    }

    fn map_partner_to_customer(partner: &Partner) -> AccountingCustomerParty {
        AccountingCustomerParty {
            party: Party {
                party_identification: PartyIdentification {
                    id: PartyId {
                        scheme_id: "NAT".to_string(), // National ID or other
                        value: partner.code.clone(),
                    },
                },
                party_name: PartyName {
                    name: partner.name_en.clone(),
                },
                party_tax_scheme: PartyTaxScheme {
                    company_id: partner.tax_id.clone().unwrap_or_default(),
                    tax_scheme: TaxScheme {
                        id: "VAT".to_string(),
                    },
                },
                party_legal_entity: PartyLegalEntity {
                    registration_name: partner.name_en.clone(),
                },
            },
        }
    }
}
