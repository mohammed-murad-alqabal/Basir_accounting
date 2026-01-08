use base64::{engine::general_purpose, Engine as _};
use p256::ecdsa::{signature::Signer, Signature, SigningKey};
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

/// Computes the SHA-256 hash of the input string and returns it as a hex string.
pub fn sha256_hash(input: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(input.as_bytes());
    let result = hasher.finalize();
    base64::engine::general_purpose::STANDARD.encode(result)
}

/// Signs the SHA-256 hash using the provided ECDSA private key (PEM format).
/// Returns the signature in Base64 format.
pub fn sign_ecdsa(private_key_pem: &str, hash_base64: &str) -> Result<String, CryptoError> {
    // Decode private key
    let signing_key = SigningKey::from_pkcs8_pem(private_key_pem)
        .map_err(|e| CryptoError::KeyError(e.to_string()))?;

    // Decode hash (ZATCA expects signing of the hash bytes, not the hex string)
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
    let secret_key = p256::SecretKey::random(&mut rand::thread_rng());
    let private_pem = secret_key.to_pkcs8_pem(LineEnding::LF).unwrap().to_string();

    let public_key = secret_key.public_key();
    let public_pem = public_key
        .to_public_key_pem(LineEnding::LF)
        .unwrap()
        .to_string();

    (private_pem, public_pem)
}
