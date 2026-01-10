use anyhow::Result;
use quick_xml::se::Serializer;
use serde::Serialize;

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct Invoice {
    #[serde(rename = "@xmlns")]
    pub xmlns: String,
    #[serde(rename = "@xmlns:cac")]
    pub xmlns_cac: String,
    #[serde(rename = "@xmlns:cbc")]
    pub xmlns_cbc: String,

    #[serde(rename = "cbc:ID")]
    pub id: String,
    #[serde(rename = "cbc:UUID")]
    pub uuid: String,
    #[serde(rename = "cbc:IssueDate")]
    pub issue_date: String,
    #[serde(rename = "cbc:IssueTime")]
    pub issue_time: String,
    #[serde(rename = "cbc:InvoiceTypeCode")]
    pub invoice_type_code: InvoiceTypeCode,
    #[serde(rename = "cbc:DocumentCurrencyCode")]
    pub document_currency_code: String,
    #[serde(rename = "cbc:TaxCurrencyCode")]
    pub tax_currency_code: String,

    #[serde(
        rename = "cac:AdditionalDocumentReference",
        skip_serializing_if = "Vec::is_empty"
    )]
    pub additional_document_references: Vec<AdditionalDocumentReference>,

    #[serde(rename = "cac:Signature", skip_serializing_if = "Vec::is_empty")]
    pub signatures: Vec<Signature>,

    #[serde(rename = "cac:AccountingSupplierParty")]
    pub accounting_supplier_party: AccountingSupplierParty,
    #[serde(rename = "cac:AccountingCustomerParty")]
    pub accounting_customer_party: AccountingCustomerParty,

    #[serde(rename = "cac:TaxTotal")]
    pub tax_total: Vec<TaxTotal>,

    #[serde(rename = "cac:LegalMonetaryTotal")]
    pub legal_monetary_total: LegalMonetaryTotal,

    #[serde(rename = "cac:InvoiceLine")]
    pub invoice_lines: Vec<InvoiceLine>,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct AdditionalDocumentReference {
    #[serde(rename = "cbc:ID")]
    pub id: String,
    #[serde(rename = "cbc:UUID", skip_serializing_if = "Option::is_none")]
    pub uuid: Option<String>,
    #[serde(
        rename = "cbc:DocumentTypeCode",
        skip_serializing_if = "Option::is_none"
    )]
    pub document_type_code: Option<String>,
    #[serde(rename = "cac:Attachment", skip_serializing_if = "Option::is_none")]
    pub attachment: Option<Attachment>,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct Attachment {
    #[serde(rename = "cbc:EmbeddedDocumentBinaryObject")]
    pub embedded_document_binary_object: EmbeddedDocumentBinaryObject,
}

#[derive(Debug, Serialize, Default)]
pub struct EmbeddedDocumentBinaryObject {
    #[serde(rename = "@mimeCode")]
    pub mime_code: String,
    #[serde(rename = "$value")]
    pub value: String,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct Signature {
    #[serde(rename = "cbc:ID")]
    pub id: String,
    #[serde(rename = "cbc:SignatureMethod")]
    pub signature_method: String,
}

#[derive(Debug, Serialize, Default)]
pub struct InvoiceTypeCode {
    #[serde(rename = "@name")]
    pub name: String,
    #[serde(rename = "$value")]
    pub value: String,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct AccountingSupplierParty {
    #[serde(rename = "cac:Party")]
    pub party: Party,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct AccountingCustomerParty {
    #[serde(rename = "cac:Party")]
    pub party: Party,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct Party {
    #[serde(rename = "cac:PartyIdentification")]
    pub party_identification: PartyIdentification,
    #[serde(rename = "cac:PartyName")]
    pub party_name: PartyName,
    #[serde(rename = "cac:PartyTaxScheme")]
    pub party_tax_scheme: PartyTaxScheme,
    #[serde(rename = "cac:PartyLegalEntity")]
    pub party_legal_entity: PartyLegalEntity,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct PartyIdentification {
    #[serde(rename = "cbc:ID")]
    pub id: PartyId,
}

#[derive(Debug, Serialize, Default)]
pub struct PartyId {
    #[serde(rename = "@schemeID")]
    pub scheme_id: String,
    #[serde(rename = "$value")]
    pub value: String,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct PartyName {
    #[serde(rename = "cbc:Name")]
    pub name: String,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct PartyTaxScheme {
    #[serde(rename = "cbc:CompanyID")]
    pub company_id: String,
    #[serde(rename = "cac:TaxScheme")]
    pub tax_scheme: TaxScheme,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct TaxScheme {
    #[serde(rename = "cbc:ID")]
    pub id: String,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct PartyLegalEntity {
    #[serde(rename = "cbc:RegistrationName")]
    pub registration_name: String,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct TaxTotal {
    #[serde(rename = "cbc:TaxAmount")]
    pub tax_amount: Amount,
    #[serde(rename = "cac:TaxSubtotal", skip_serializing_if = "Option::is_none")]
    pub tax_subtotal: Option<Vec<TaxSubtotal>>,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct TaxSubtotal {
    #[serde(rename = "cbc:TaxableAmount")]
    pub taxable_amount: Amount,
    #[serde(rename = "cbc:TaxAmount")]
    pub tax_amount: Amount,
    #[serde(rename = "cac:TaxCategory")]
    pub tax_category: TaxCategory,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct TaxCategory {
    #[serde(rename = "cbc:ID")]
    pub id: String,
    #[serde(rename = "cbc:Percent")]
    pub percent: String,
    #[serde(rename = "cac:TaxScheme")]
    pub tax_scheme: TaxScheme,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct LegalMonetaryTotal {
    #[serde(rename = "cbc:LineExtensionAmount")]
    pub line_extension_amount: Amount,
    #[serde(rename = "cbc:TaxExclusiveAmount")]
    pub tax_exclusive_amount: Amount,
    #[serde(rename = "cbc:TaxInclusiveAmount")]
    pub tax_inclusive_amount: Amount,
    #[serde(
        rename = "cbc:allowanceTotalAmount",
        skip_serializing_if = "Option::is_none"
    )]
    pub allowance_total_amount: Option<Amount>,
    #[serde(rename = "cbc:payableAmount")]
    pub payable_amount: Amount,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct InvoiceLine {
    #[serde(rename = "cbc:ID")]
    pub id: String,
    #[serde(rename = "cbc:InvoicedQuantity")]
    pub invoiced_quantity: Quantity,
    #[serde(rename = "cbc:LineExtensionAmount")]
    pub line_extension_amount: Amount,
    #[serde(rename = "cac:TaxTotal")]
    pub tax_total: TaxTotal,
    #[serde(rename = "cac:Item")]
    pub item: Item,
    #[serde(rename = "cac:Price")]
    pub price: Price,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct Item {
    #[serde(rename = "cbc:Name")]
    pub name: String,
    #[serde(rename = "cac:ClassifiedTaxCategory")]
    pub classified_tax_category: TaxCategory,
}

#[derive(Debug, Serialize, Default)]
#[serde(rename_all = "PascalCase")]
pub struct Price {
    #[serde(rename = "cbc:PriceAmount")]
    pub price_amount: Amount,
}

#[derive(Debug, Serialize, Default)]
pub struct Amount {
    #[serde(rename = "@currencyID")]
    pub currency_id: String,
    #[serde(rename = "$value")]
    pub value: String,
}

#[derive(Debug, Serialize, Default)]
pub struct Quantity {
    #[serde(rename = "@unitCode")]
    pub unit_code: String,
    #[serde(rename = "$value")]
    pub value: String,
}

impl Invoice {
    pub fn new_standard(id: String, uuid: String, issue_date: String, issue_time: String) -> Self {
        Self {
            xmlns: "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2".to_string(),
            xmlns_cac: "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                .to_string(),
            xmlns_cbc: "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                .to_string(),
            id,
            uuid,
            issue_date,
            issue_time,
            invoice_type_code: InvoiceTypeCode {
                name: "0100000".to_string(),
                value: "388".to_string(),
            },
            document_currency_code: "SAR".to_string(),
            tax_currency_code: "SAR".to_string(),
            ..Default::default()
        }
    }

    pub fn to_xml(&self) -> Result<String> {
        let mut buffer = String::new();
        let mut ser = Serializer::new(&mut buffer);
        ser.indent(' ', 2);
        self.serialize(ser)?;
        Ok(buffer)
    }
}
