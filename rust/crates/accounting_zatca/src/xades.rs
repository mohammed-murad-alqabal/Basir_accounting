//! XAdES-EPES Signature Implementation
//!
//! Implements the XML Advanced Electronic Signature (XAdES) structure
//! required for ZATCA Phase 2 e-invoicing compliance.
//!
//! # ZATCA Requirements (ETSI EN 319 132-1)
//! - Enveloped signature (signature is a sub-element of the signed document)
//! - ECDSA algorithm with SHA-256 hashing
//! - Signature covers entire XML content except QR code
//! - SigningTime element with current timestamp

use base64::{engine::general_purpose, Engine};
use chrono::{DateTime, Utc};

/// XAdES-EPES Signature structure for ZATCA compliance.
///
/// This structure represents the ds:Signature element that must be
/// embedded within the UBL Invoice document.
#[derive(Debug, Clone)]
pub struct XadesSignature {
    /// Unique identifier for this signature
    pub signature_id: String,
    /// The signing timestamp
    pub signing_time: DateTime<Utc>,
    /// SHA-256 hash of the invoice content (Base64)
    pub invoice_hash: String,
    /// SHA-256 hash of the signing certificate (Base64)
    pub certificate_hash: String,
    /// The ECDSA signature value (Base64)
    pub signature_value: String,
    /// The X.509 certificate used for signing (Base64 DER)
    pub certificate: String,
    /// Issuer name from the certificate
    pub issuer_name: String,
    /// Serial number from the certificate
    pub serial_number: String,
}

impl XadesSignature {
    /// Generate the XAdES-EPES XML structure.
    ///
    /// Returns the complete ds:Signature XML element ready for embedding
    /// into the UBL Invoice's ext:UBLExtensions section.
    pub fn to_xml(&self) -> String {
        let signing_time_str = self.signing_time.format("%Y-%m-%dT%H:%M:%SZ").to_string();
        let props_hash = self.compute_signed_properties_hash();

        let mut xml = String::new();
        xml.push_str("<ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"");
        xml.push_str(&self.signature_id);
        xml.push_str("\">\n");
        xml.push_str("  <ds:SignedInfo>\n");
        xml.push_str(
            "    <ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/2006/12/xml-c14n11\"/>\n",
        );
        xml.push_str("    <ds:SignatureMethod Algorithm=\"http://www.w3.org/2001/04/xmldsig-more#ecdsa-sha256\"/>\n");
        xml.push_str("    <ds:Reference Id=\"invoiceSignedData\" URI=\"\">\n");
        xml.push_str("      <ds:Transforms>\n");
        xml.push_str(
            "        <ds:Transform Algorithm=\"http://www.w3.org/TR/1999/REC-xpath-19991116\">\n",
        );
        xml.push_str("          <ds:XPath>not(//ancestor-or-self::ext:UBLExtensions)</ds:XPath>\n");
        xml.push_str("        </ds:Transform>\n");
        xml.push_str(
            "        <ds:Transform Algorithm=\"http://www.w3.org/TR/1999/REC-xpath-19991116\">\n",
        );
        xml.push_str("          <ds:XPath>not(//ancestor-or-self::cac:Signature)</ds:XPath>\n");
        xml.push_str("        </ds:Transform>\n");
        xml.push_str(
            "        <ds:Transform Algorithm=\"http://www.w3.org/TR/1999/REC-xpath-19991116\">\n",
        );
        xml.push_str("          <ds:XPath>not(//ancestor-or-self::cac:AdditionalDocumentReference[cbc:ID='QR'])</ds:XPath>\n");
        xml.push_str("        </ds:Transform>\n");
        xml.push_str(
            "        <ds:Transform Algorithm=\"http://www.w3.org/2006/12/xml-c14n11\"/>\n",
        );
        xml.push_str("      </ds:Transforms>\n");
        xml.push_str(
            "      <ds:DigestMethod Algorithm=\"http://www.w3.org/2001/04/xmlenc#sha256\"/>\n",
        );
        xml.push_str("      <ds:DigestValue>");
        xml.push_str(&self.invoice_hash);
        xml.push_str("</ds:DigestValue>\n");
        xml.push_str("    </ds:Reference>\n");
        xml.push_str("    <ds:Reference Type=\"http://www.w3.org/2000/09/xmldsig#SignatureProperties\" URI=\"#xadesSignedProperties\">\n");
        xml.push_str(
            "      <ds:DigestMethod Algorithm=\"http://www.w3.org/2001/04/xmlenc#sha256\"/>\n",
        );
        xml.push_str("      <ds:DigestValue>");
        xml.push_str(&props_hash);
        xml.push_str("</ds:DigestValue>\n");
        xml.push_str("    </ds:Reference>\n");
        xml.push_str("  </ds:SignedInfo>\n");
        xml.push_str("  <ds:SignatureValue>");
        xml.push_str(&self.signature_value);
        xml.push_str("</ds:SignatureValue>\n");
        xml.push_str("  <ds:KeyInfo>\n");
        xml.push_str("    <ds:X509Data>\n");
        xml.push_str("      <ds:X509Certificate>");
        xml.push_str(&self.certificate);
        xml.push_str("</ds:X509Certificate>\n");
        xml.push_str("    </ds:X509Data>\n");
        xml.push_str("  </ds:KeyInfo>\n");
        xml.push_str("  <ds:Object>\n");
        xml.push_str("    <xades:QualifyingProperties xmlns:xades=\"http://uri.etsi.org/01903/v1.3.2#\" Target=\"#");
        xml.push_str(&self.signature_id);
        xml.push_str("\">\n");
        xml.push_str("      <xades:SignedProperties Id=\"xadesSignedProperties\">\n");
        xml.push_str("        <xades:SignedSignatureProperties>\n");
        xml.push_str("          <xades:SigningTime>");
        xml.push_str(&signing_time_str);
        xml.push_str("</xades:SigningTime>\n");
        xml.push_str("          <xades:SigningCertificate>\n");
        xml.push_str("            <xades:Cert>\n");
        xml.push_str("              <xades:CertDigest>\n");
        xml.push_str("                <ds:DigestMethod Algorithm=\"http://www.w3.org/2001/04/xmlenc#sha256\"/>\n");
        xml.push_str("                <ds:DigestValue>");
        xml.push_str(&self.certificate_hash);
        xml.push_str("</ds:DigestValue>\n");
        xml.push_str("              </xades:CertDigest>\n");
        xml.push_str("              <xades:IssuerSerial>\n");
        xml.push_str("                <ds:X509IssuerName>");
        xml.push_str(&self.issuer_name);
        xml.push_str("</ds:X509IssuerName>\n");
        xml.push_str("                <ds:X509SerialNumber>");
        xml.push_str(&self.serial_number);
        xml.push_str("</ds:X509SerialNumber>\n");
        xml.push_str("              </xades:IssuerSerial>\n");
        xml.push_str("            </xades:Cert>\n");
        xml.push_str("          </xades:SigningCertificate>\n");
        xml.push_str("        </xades:SignedSignatureProperties>\n");
        xml.push_str("      </xades:SignedProperties>\n");
        xml.push_str("    </xades:QualifyingProperties>\n");
        xml.push_str("  </ds:Object>\n");
        xml.push_str("</ds:Signature>");

        xml
    }

    /// Compute the hash of the SignedProperties element.
    fn compute_signed_properties_hash(&self) -> String {
        use sha2::{Digest, Sha256};

        let signing_time_str = self.signing_time.format("%Y-%m-%dT%H:%M:%SZ").to_string();

        let mut props = String::new();
        props.push_str("<xades:SignedProperties Id=\"xadesSignedProperties\">\n");
        props.push_str("  <xades:SignedSignatureProperties>\n");
        props.push_str("    <xades:SigningTime>");
        props.push_str(&signing_time_str);
        props.push_str("</xades:SigningTime>\n");
        props.push_str("    <xades:SigningCertificate>\n");
        props.push_str("      <xades:Cert>\n");
        props.push_str("        <xades:CertDigest>\n");
        props.push_str(
            "          <ds:DigestMethod Algorithm=\"http://www.w3.org/2001/04/xmlenc#sha256\"/>\n",
        );
        props.push_str("          <ds:DigestValue>");
        props.push_str(&self.certificate_hash);
        props.push_str("</ds:DigestValue>\n");
        props.push_str("        </xades:CertDigest>\n");
        props.push_str("        <xades:IssuerSerial>\n");
        props.push_str("          <ds:X509IssuerName>");
        props.push_str(&self.issuer_name);
        props.push_str("</ds:X509IssuerName>\n");
        props.push_str("          <ds:X509SerialNumber>");
        props.push_str(&self.serial_number);
        props.push_str("</ds:X509SerialNumber>\n");
        props.push_str("        </xades:IssuerSerial>\n");
        props.push_str("      </xades:Cert>\n");
        props.push_str("    </xades:SigningCertificate>\n");
        props.push_str("  </xades:SignedSignatureProperties>\n");
        props.push_str("</xades:SignedProperties>");

        let mut hasher = Sha256::new();
        hasher.update(props.as_bytes());
        general_purpose::STANDARD.encode(hasher.finalize())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_xades_signature_xml_generation() {
        let sig = XadesSignature {
            signature_id: "signature".to_string(),
            signing_time: Utc::now(),
            invoice_hash: "dGVzdA==".to_string(),
            certificate_hash: "Y2VydA==".to_string(),
            signature_value: "c2ln".to_string(),
            certificate: "Y2VydGlmaWNhdGU=".to_string(),
            issuer_name: "CN=ZATCA-Test-CA".to_string(),
            serial_number: "123456789".to_string(),
        };

        let xml = sig.to_xml();

        assert!(xml.contains("ds:Signature"));
        assert!(xml.contains("xades:SignedProperties"));
        assert!(xml.contains("ecdsa-sha256"));
        assert!(xml.contains("ZATCA-Test-CA"));
    }
}
