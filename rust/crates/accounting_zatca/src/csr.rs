use anyhow::Result;
use rcgen::{CertificateParams, DistinguishedName, DnType, KeyPair};

pub struct ZatcaCsrInput {
    pub common_name: String,
    pub organization_unit: String,
    pub organization: String,
    pub country: String,
    pub serial_number: String,
    pub vat_number: String,
    pub business_category: String,
    pub registered_address: String,
}

/// Generates a ZATCA-compliant CSR based on the provided input.
pub fn generate_csr(input: ZatcaCsrInput, key_pair_pem: &str) -> Result<String> {
    let mut params = CertificateParams::default();

    // ZATCA requires P-256 ECDSA
    let key_pair = KeyPair::from_pem(key_pair_pem)?;

    let mut dn = DistinguishedName::new();
    dn.push(DnType::CommonName, &input.common_name);
    dn.push(DnType::OrganizationalUnitName, &input.organization_unit);
    dn.push(DnType::OrganizationName, &input.organization);
    dn.push(DnType::CountryName, &input.country);

    // ZATCA specific Subject attributes using OIDs
    // Serial Number (OID 2.5.4.5)
    dn.push(DnType::CustomDnType(vec![2, 5, 4, 5]), &input.serial_number);
    // Organization Identifier (using 15-digit VAT number) (OID 2.5.4.97)
    dn.push(DnType::CustomDnType(vec![2, 5, 4, 97]), &input.vat_number);
    // Title (OID 2.5.4.12)
    dn.push(
        DnType::CustomDnType(vec![2, 5, 4, 12]),
        &input.business_category,
    );
    // Business Category (OID 2.5.4.15)
    dn.push(
        DnType::CustomDnType(vec![2, 5, 4, 15]),
        &input.registered_address,
    );

    params.distinguished_name = dn;

    // NOTE: In Phase 2, ZATCA requires specific extensions (Certificate Template Name).
    // OID: 1.3.6.1.4.1.311.20.2
    // Value: "ZATCA-Code-Signing" (for simulation/test) or specific values.
    // This can be added via params.custom_extensions if needed.

    let csr = params.serialize_request(&key_pair)?;
    Ok(csr.pem()?)
}
