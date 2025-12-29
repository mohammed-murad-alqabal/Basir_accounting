# ZATCA Compliance Specification: Baseer Intelligent Financial System

**Document ID:** BASEER-P4-006  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** Technical Architecture - Compliance

---

## 1. ZATCA Overview

### What is ZATCA?

**Zakat, Tax and Customs Authority** (هيئة الزكاة والضريبة والجمارك) - Saudi Arabia's tax authority mandating electronic invoicing.

### Phases

| Phase   | Requirement | Start Date   | Status            |
| ------- | ----------- | ------------ | ----------------- |
| Phase 1 | Generation  | Dec 4, 2021  | ✅ Active         |
| Phase 2 | Integration | Jan 1, 2023+ | ✅ Active (waves) |

---

## 2. Phase 2 Requirements

### Mandatory Invoice Fields

| Field             | Arabic                | Required | Notes              |
| ----------------- | --------------------- | -------- | ------------------ |
| Invoice Number    | رقم الفاتورة          | Yes      | Unique, sequential |
| UUID              | المعرف الفريد         | Yes      | UUID v4            |
| Issue Date        | تاريخ الإصدار         | Yes      | ISO 8601           |
| Issue Time        | وقت الإصدار           | Yes      | HH:MM:SS           |
| Seller Name       | اسم البائع            | Yes      | Arabic required    |
| Seller VAT Number | الرقم الضريبي للبائع  | Yes      | 15 digits          |
| Buyer Name        | اسم المشتري           | Yes\*    | B2B required       |
| Buyer VAT Number  | الرقم الضريبي للمشتري | Yes\*    | B2B required       |
| Line Items        | بنود الفاتورة         | Yes      | Min 1 item         |
| Taxable Amount    | المبلغ الخاضع للضريبة | Yes      | Per item           |
| VAT Rate          | نسبة الضريبة          | Yes      | 15% standard       |
| VAT Amount        | مبلغ الضريبة          | Yes      | Calculated         |
| Total             | الإجمالي              | Yes      | Sum                |
| QR Code           | رمز الاستجابة السريعة | Yes      | TLV encoded        |

### Invoice Types

| Type        | Code | Description           |
| ----------- | ---- | --------------------- |
| Standard    | 388  | Regular invoice       |
| Simplified  | 381  | B2C (< SAR 1000)      |
| Credit Note | 381  | Correction (negative) |
| Debit Note  | 383  | Additional charge     |

---

## 3. QR Code Specification

### TLV Structure

| Tag | Name        | Type   | Max Length |
| --- | ----------- | ------ | ---------- |
| 1   | Seller Name | String | 256        |
| 2   | VAT Number  | String | 15         |
| 3   | Timestamp   | String | 19         |
| 4   | Total       | String | 15         |
| 5   | VAT Amount  | String | 15         |
| 6   | Hash        | Base64 | 64         |
| 7   | Signature   | Base64 | 512        |
| 8   | Public Key  | Base64 | 256        |

### Encoding Process

```
1. Build TLV data structure
2. Base64 encode
3. Generate QR code from Base64 string
```

### Implementation (Dart)

```dart
class ZatcaQrGenerator {
  String generate(Invoice invoice) {
    final tlv = BytesBuilder();

    // Tag 1: Seller Name
    _addTlv(tlv, 1, invoice.sellerName);

    // Tag 2: VAT Number
    _addTlv(tlv, 2, invoice.vatNumber);

    // Tag 3: Timestamp
    _addTlv(tlv, 3, invoice.issueDateTime.toIso8601String());

    // Tag 4: Total with VAT
    _addTlv(tlv, 4, invoice.total.toStringAsFixed(2));

    // Tag 5: VAT Amount
    _addTlv(tlv, 5, invoice.vatAmount.toStringAsFixed(2));

    // Phase 2 only: Tags 6-8 (hash, signature, public key)
    if (phase2Enabled) {
      _addTlv(tlv, 6, computeHash(invoice));
      _addTlv(tlv, 7, signInvoice(invoice));
      _addTlv(tlv, 8, getPublicKey());
    }

    return base64Encode(tlv.toBytes());
  }

  void _addTlv(BytesBuilder builder, int tag, String value) {
    final bytes = utf8.encode(value);
    builder.addByte(tag);
    builder.addByte(bytes.length);
    builder.add(bytes);
  }
}
```

---

## 4. XML Structure (UBL 2.1)

### Simplified Invoice Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">
  <cbc:ProfileID>reporting:1.0</cbc:ProfileID>
  <cbc:ID>INV-2025-0001</cbc:ID>
  <cbc:UUID>550e8400-e29b-41d4-a716-446655440000</cbc:UUID>
  <cbc:IssueDate>2025-12-27</cbc:IssueDate>
  <cbc:IssueTime>14:30:00</cbc:IssueTime>
  <cbc:InvoiceTypeCode name="0200000">388</cbc:InvoiceTypeCode>
  <cbc:DocumentCurrencyCode>SAR</cbc:DocumentCurrencyCode>

  <cac:AccountingSupplierParty>
    <cac:Party>
      <cac:PartyIdentification>
        <cbc:ID schemeID="VAT">300000000000003</cbc:ID>
      </cac:PartyIdentification>
      <cac:PartyLegalEntity>
        <cbc:RegistrationName>شركة بصير للتقنية</cbc:RegistrationName>
      </cac:PartyLegalEntity>
    </cac:Party>
  </cac:AccountingSupplierParty>

  <cac:TaxTotal>
    <cbc:TaxAmount currencyID="SAR">150.00</cbc:TaxAmount>
    <cac:TaxSubtotal>
      <cbc:TaxableAmount currencyID="SAR">1000.00</cbc:TaxableAmount>
      <cbc:TaxAmount currencyID="SAR">150.00</cbc:TaxAmount>
      <cac:TaxCategory>
        <cbc:ID>S</cbc:ID>
        <cbc:Percent>15.00</cbc:Percent>
      </cac:TaxCategory>
    </cac:TaxSubtotal>
  </cac:TaxTotal>

  <cac:LegalMonetaryTotal>
    <cbc:TaxExclusiveAmount currencyID="SAR">1000.00</cbc:TaxExclusiveAmount>
    <cbc:TaxInclusiveAmount currencyID="SAR">1150.00</cbc:TaxInclusiveAmount>
    <cbc:PayableAmount currencyID="SAR">1150.00</cbc:PayableAmount>
  </cac:LegalMonetaryTotal>

  <cac:InvoiceLine>
    <cbc:ID>1</cbc:ID>
    <cbc:InvoicedQuantity unitCode="PCE">10</cbc:InvoicedQuantity>
    <cbc:LineExtensionAmount currencyID="SAR">1000.00</cbc:LineExtensionAmount>
    <cac:Item>
      <cbc:Name>خدمات استشارية</cbc:Name>
    </cac:Item>
    <cac:Price>
      <cbc:PriceAmount currencyID="SAR">100.00</cbc:PriceAmount>
    </cac:Price>
  </cac:InvoiceLine>
</Invoice>
```

---

## 5. Signing & Hashing

### Hash Algorithm

**SHA-256** of canonicalized XML (C14N11)

### Signature Algorithm

**ECDSA** with P-256 curve

### Certificate Requirements

- ZATCA-issued device certificate
- Valid chain to ZATCA root CA
- Renewed annually

---

## 6. API Integration

### Reporting API

| Endpoint                     | Method | Purpose                |
| ---------------------------- | ------ | ---------------------- |
| `/invoices/reporting/single` | POST   | Report single invoice  |
| `/invoices/clearance/single` | POST   | Clear B2B invoice      |
| `/production/csids`          | POST   | Get CSID (certificate) |

### Response Codes

| Code     | Meaning               |
| -------- | --------------------- |
| REPORTED | Successfully reported |
| CLEARED  | B2B invoice cleared   |
| REJECTED | Validation failed     |
| WARNING  | Passed with warnings  |

---

## 7. Validation Rules

### Critical Validations

| Rule               | Error Code | Message                       |
| ------------------ | ---------- | ----------------------------- |
| Missing VAT        | VAT-001    | VAT number is required        |
| Invalid VAT format | VAT-002    | VAT must be 15 digits         |
| Missing seller     | SEL-001    | Seller name is required       |
| Invalid total      | TOT-001    | Total must equal sum of lines |
| Missing QR         | QR-001     | QR code is required           |

### Baseer Validation Layer

```dart
class ZatcaValidator {
  ValidationResult validate(Invoice invoice) {
    final errors = <ValidationError>[];

    // VAT number
    if (invoice.sellerVatNumber == null) {
      errors.add(ValidationError('VAT-001', 'VAT number required'));
    } else if (!_isValidVatNumber(invoice.sellerVatNumber!)) {
      errors.add(ValidationError('VAT-002', 'Invalid VAT format'));
    }

    // Amounts
    final calculatedTotal = invoice.items.fold(0.0, (sum, item) => sum + item.total);
    if ((invoice.subtotal - calculatedTotal).abs() > 0.01) {
      errors.add(ValidationError('TOT-001', 'Total mismatch'));
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}
```

---

## 8. Testing & Certification

### ZATCA Sandbox

| Environment | URL                                       |
| ----------- | ----------------------------------------- |
| Sandbox     | `https://gw-fatoora.zatca.gov.sa/sandbox` |
| Production  | `https://gw-fatoora.zatca.gov.sa`         |

### Certification Process

1. Register on ZATCA portal
2. Complete sandbox testing
3. Submit for certification
4. Receive production credentials
5. Deploy to production

---

**Document Control:**

- Prepared by: Baseer Development Agent Team
- Date: December 27, 2025
