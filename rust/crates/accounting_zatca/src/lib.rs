pub mod crypto;
pub mod qr;
pub mod xades;
pub mod xml_builder;

#[cfg(test)]
mod tests {

    use crate::qr::ZatcaQrPayload;

    #[test]
    fn test_tlv_base64_encoding() {
        let payload = ZatcaQrPayload {
            seller_name: "Basir".to_string(),
            vat_number: "123456789".to_string(),
            timestamp: "2024-01-01T12:00:00Z".to_string(),
            total_amount: "100.00".to_string(),
            vat_amount: "15.00".to_string(),
            hash: "hash".to_string(),
            signature: "sig".to_string(),
            public_key: "pubkey".to_string(),
            certificate_signature: "certsig".to_string(),
        };
        let b64 = payload.to_base64();
        assert!(b64.is_ok());
        println!("Base64: {}", b64.unwrap());
    }
}
