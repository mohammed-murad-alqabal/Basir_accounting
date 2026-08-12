use accounting_zatca::crypto::{self, Certificate, PrivateKey};
use accounting_zatca::csr::{self, ZatcaCsrInput};
use accounting_zatca::service::{ZatcaInvoiceInput, ZatcaInvoiceLineInput, ZatcaService};
use accounting_zatca::xml_builder::{
    AccountingCustomerParty, AccountingSupplierParty, Party, PartyId, PartyIdentification,
    TaxCategoryCode,
};
use rust_decimal::Decimal;
use std::str::FromStr;

#[derive(Clone)]
pub struct ZatcaCsrInputDto {
    pub common_name: String,
    pub organization_unit: String,
    pub organization: String,
    pub country: String,
    pub serial_number: String,
    pub vat_number: String,
    pub business_category: String,
    pub registered_address: String,
}

#[derive(Clone)]
pub struct ZatcaInvoiceInputDto {
    pub id: String,
    pub uuid: String,
    pub issue_date: String,
    pub issue_time: String,
    pub invoice_type_code: String,
    pub invoice_counter_value: u64,
    pub previous_invoice_hash: String,
    pub seller_party: ZatcaPartyDto,
    pub buyer_party: ZatcaPartyDto,
    pub lines: Vec<ZatcaInvoiceLineDto>,
}

#[derive(Clone)]
pub struct ZatcaPartyDto {
    pub party_id: String,
    pub party_id_scheme: String, // e.g., "CRN", "NAT"
}

#[derive(Clone)]
pub struct ZatcaInvoiceLineDto {
    pub id: String,
    pub quantity: String,
    pub unit_price: String,
    pub tax_category: String, // "S", "Z", "E", "O"
    pub item_name: String,
}

pub fn generate_zatca_key_pair() -> (String, String) {
    crypto::generate_key_pair()
}

pub async fn generate_zatca_csr(
    input: ZatcaCsrInputDto,
    key_pair_pem: String,
) -> anyhow::Result<String> {
    let internal_input = ZatcaCsrInput {
        common_name: input.common_name,
        organization_unit: input.organization_unit,
        organization: input.organization,
        country: input.country,
        serial_number: input.serial_number,
        vat_number: input.vat_number,
        business_category: input.business_category,
        registered_address: input.registered_address,
    };
    csr::generate_csr(internal_input, &key_pair_pem)
}

pub async fn generate_zatca_signed_xml(
    input: ZatcaInvoiceInputDto,
    certificate_pem: String,
    private_key_pem: String,
) -> anyhow::Result<(String, String)> {
    let cert = Certificate {
        content: certificate_pem,
    };
    let priv_key = PrivateKey {
        content: private_key_pem,
    };

    let internal_input = ZatcaInvoiceInput {
        id: input.id,
        uuid: input.uuid,
        issue_date: input.issue_date,
        issue_time: input.issue_time,
        invoice_type_code: input.invoice_type_code,
        invoice_counter_value: input.invoice_counter_value,
        previous_invoice_hash: input.previous_invoice_hash,
        seller_party: AccountingSupplierParty {
            party: Party {
                party_identification: PartyIdentification {
                    id: PartyId {
                        value: input.seller_party.party_id,
                        scheme_id: input.seller_party.party_id_scheme,
                    },
                },
                ..Default::default()
            },
        },
        buyer_party: AccountingCustomerParty {
            party: Party {
                party_identification: PartyIdentification {
                    id: PartyId {
                        value: input.buyer_party.party_id,
                        scheme_id: input.buyer_party.party_id_scheme,
                    },
                },
                ..Default::default()
            },
        },
        lines: input
            .lines
            .into_iter()
            .map(|l| {
                Ok(ZatcaInvoiceLineInput {
                    id: l.id,
                    quantity: Decimal::from_str(&l.quantity)?,
                    unit_price: Decimal::from_str(&l.unit_price)?,
                    tax_category: match l.tax_category.as_str() {
                        "S" => TaxCategoryCode::Standard,
                        "Z" => TaxCategoryCode::ZeroRated,
                        "E" => TaxCategoryCode::Exempt,
                        "O" => TaxCategoryCode::OutOfScope,
                        _ => TaxCategoryCode::Standard,
                    },
                    item_name: l.item_name,
                })
            })
            .collect::<anyhow::Result<Vec<_>>>()?,
    };

    ZatcaService::generate_signed_invoice(internal_input, &cert, &priv_key)
}
