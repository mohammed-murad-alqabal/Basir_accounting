use base64::{engine::general_purpose, Engine as _};
use thiserror::Error;

#[derive(Error, Debug)]
pub enum QrError {
    #[error("Value too long for TLV encoding")]
    ValueTooLong,
}

/// Tag-Length-Value (TLV) tags for ZATCA QR Code
/// Phase 2 requires Tags 1-9 for full compliance.
#[repr(u8)]
enum Tag {
    SellerName = 1,
    VatNumber = 2,
    Timestamp = 3,
    TotalAmount = 4,
    VatAmount = 5,
    Hash = 6,
    Signature = 7,
    PublicKey = 8,
    CertificateSignature = 9,
}

/// ZATCA QR Code Payload for E-Invoicing.
///
/// # Phase 2 Requirements
/// Tags 1-5: Basic invoice information (Phase 1)
/// Tags 6-9: Cryptographic elements (Phase 2)
pub struct ZatcaQrPayload {
    pub seller_name: String,
    pub vat_number: String,
    pub timestamp: String,
    pub total_amount: String,
    pub vat_amount: String,
    /// SHA-256 hash of the invoice XML (Base64 encoded)
    pub hash: String,
    /// ECDSA signature of the hash (Base64 encoded)
    pub signature: String,
    /// Public key used for signing (Base64 encoded)
    pub public_key: String,
    /// Certificate signature for chain verification (Base64 encoded)
    pub certificate_signature: String,
}

impl ZatcaQrPayload {
    /// Encodes the payload into a Base64 string compliant with ZATCA Phase 2 standards.
    pub fn to_base64(&self) -> Result<String, QrError> {
        let mut buffer = Vec::new();

        self.write_tlv(&mut buffer, Tag::SellerName, self.seller_name.as_bytes())?;
        self.write_tlv(&mut buffer, Tag::VatNumber, self.vat_number.as_bytes())?;
        self.write_tlv(&mut buffer, Tag::Timestamp, self.timestamp.as_bytes())?;
        self.write_tlv(&mut buffer, Tag::TotalAmount, self.total_amount.as_bytes())?;
        self.write_tlv(&mut buffer, Tag::VatAmount, self.vat_amount.as_bytes())?;

        // Tags 6-9 are essential for Phase 2 compliance
        self.write_tlv(&mut buffer, Tag::Hash, self.hash.as_bytes())?;
        self.write_tlv(&mut buffer, Tag::Signature, self.signature.as_bytes())?;
        self.write_tlv(&mut buffer, Tag::PublicKey, self.public_key.as_bytes())?;
        self.write_tlv(
            &mut buffer,
            Tag::CertificateSignature,
            self.certificate_signature.as_bytes(),
        )?;

        Ok(general_purpose::STANDARD.encode(&buffer))
    }

    fn write_tlv(&self, buffer: &mut Vec<u8>, tag: Tag, value: &[u8]) -> Result<(), QrError> {
        if value.len() > 255 {
            return Err(QrError::ValueTooLong);
        }

        buffer.push(tag as u8);
        buffer.push(value.len() as u8);
        buffer.extend_from_slice(value);

        Ok(())
    }
}
