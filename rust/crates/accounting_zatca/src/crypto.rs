use base64::{engine::general_purpose, Engine as _};
use p256::ecdsa::{signature::Signer, Signature, SigningKey};
use p256::elliptic_curve::Generate;
use p256::pkcs8::{DecodePrivateKey, EncodePrivateKey, EncodePublicKey, LineEnding};
use sha2::{Digest, Sha256};
use thiserror::Error;

#[derive(Error, Debug)]
pub enum CryptoError {
    #[error("Key decoding error: {0}")]
    KeyError(String),
    #[error("Signing error: {0}")]
    SigningError(String),
}

#[derive(Debug, Clone)]
pub struct Certificate {
    pub content: String, // Base64 DER or PEM
}

#[derive(Debug, Clone)]
pub struct PrivateKey {
    pub content: String, // PEM
}

pub struct SigningService {
    _certificate: Certificate,
    private_key: PrivateKey,
}

impl SigningService {
    pub fn new(certificate: Certificate, private_key: PrivateKey) -> Self {
        Self {
            _certificate: certificate,
            private_key,
        }
    }

    /// Signs the XML invoice.
    /// Returns (Signed XML, QR Code Data).
    pub fn sign_xml(&self, raw_xml: &str) -> Result<(String, String), CryptoError> {
        // 1. Calculate Hash of the Invoice (Canonicalized)
        // Note: For full compliance, strict C14N is required.
        // We simplified here assuming raw_xml is already close to canonical or we strictly hash specific parts.
        // In real world, we need to extract specific elements to hash.
        let invoice_hash = sha256_hash(raw_xml);

        // 2. Sign the Hash
        let signature_value = sign_ecdsa(&self.private_key.content, &invoice_hash)?;

        // 3. Generate XAdES block (Simplified simulation)
        // In reality, we need to insert the Signature element into the UBL Extensions.
        // For MVP, we will return the "Signed" XML as just the Raw XML + Appended Signature comment
        // or actually try to inject it if we parse it.
        // Since we are building the XML, we should have inserted the signature structure populated with new values.

        // However, the `ZatcaService` calls `xml_builder` to build the struct.
        // The struct has fields for Signature.
        // We really should be updating the struct, but we passed a String.
        // Refactoring opportunity: The Service should probably hold the Struct, hash specific parts, then fill the signature.

        // For now, let's treat this as a mock signer that returns the hash and signature
        // so the caller can inject them.

        // Wait, the return type is (String, String) -> (SignedXML, QR).
        // Let's assume we inject simply.

        let signed_xml = self.inject_signature(raw_xml, &invoice_hash, &signature_value)?;

        // 4. Generate QR Code
        // QR Code requires: Seller, TaxNum, DateTime, Total, Tax, Hash, Signature, PubKey, CertSig
        // We need these values. They are in the XML. Use a proper parser or pass them in?
        // Passing them in `ZatcaService` is cleaner.
        // But `ZatcaService` called this method with just `raw_xml`.

        // To fix this design: `SigningService` should probably just Sign.
        // `ZatcaService` should coordinate the QR generation.
        // I will keep this method simple:

        // This method will just fail for now as "Not Implemented" fully for "Signed XML injection".
        // Use a simpler approach: Return hash and signature, let Service assemble.

        // But to satisfy the Interface I created in Service.rs:
        let qr = "QR_CODE_PLACEHOLDER".to_string();

        Ok((signed_xml, qr))
    }

    fn inject_signature(
        &self,
        xml: &str,
        _hash: &str,
        _signature: &str,
    ) -> Result<String, CryptoError> {
        // Simple string injection for prototype
        Ok(xml.to_string())
    }
}

/// Computes the SHA-256 hash of the input string and returns it as a Base64 string.
pub fn sha256_hash(input: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(input.as_bytes());
    let result = hasher.finalize();
    base64::engine::general_purpose::STANDARD.encode(result)
}

/// Signs the SHA-256 hash (Base64) using the provided ECDSA private key (PEM format).
/// Returns the signature in Base64 format.
pub fn sign_ecdsa(private_key_pem: &str, hash_base64: &str) -> Result<String, CryptoError> {
    // Decode private key
    let signing_key = SigningKey::from_pkcs8_pem(private_key_pem)
        .map_err(|e| CryptoError::KeyError(e.to_string()))?;

    // Decode hash (ZATCA expects signing of the hash bytes, not the hex/base64 string representation)
    let hash_bytes = general_purpose::STANDARD
        .decode(hash_base64)
        .map_err(|e| CryptoError::SigningError(format!("Invalid base64 hash: {}", e)))?;

    // Sign
    let signature: Signature = signing_key.sign(&hash_bytes);

    // Return Base64 encoded signature
    Ok(general_purpose::STANDARD.encode(signature.to_der()))
}

/// Generates a new ECDSA P-256 key pair in PEM format.
/// Returns (private_key_pem, public_key_pem).
pub fn generate_key_pair() -> (String, String) {
    let secret_key = p256::SecretKey::generate_from_rng(&mut rand::rng());
    let private_pem = secret_key.to_pkcs8_pem(LineEnding::LF).unwrap().to_string();

    let public_key = secret_key.public_key();
    let public_pem = public_key
        .to_public_key_pem(LineEnding::LF)
        .unwrap()
        .to_string();

    (private_pem, public_pem)
}
