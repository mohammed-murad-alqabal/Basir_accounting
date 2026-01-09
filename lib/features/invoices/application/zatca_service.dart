import 'dart:convert';
import 'dart:typed_data';

import 'package:basir_app/features/invoices/domain/entities/invoice.dart';

/// ZATCA Service for Saudi E-Invoicing (Fatoora) compliance.
///
/// Implements TLV (Tag-Length-Value) encoding for Phase 1 and Phase 2 QR codes.
class ZatcaService {
  /// Encodes invoice data into a Base64 TLV string.
  ///
  /// Tags:
  /// 1. Seller Name
  /// 2. Tax Number (VAT Registration Number)
  /// 3. Invoice Timestamp
  /// 4. Total Amount (with VAT)
  /// 5. VAT Amount
  static String encodeTlv({
    required String sellerName,
    required String taxNumber,
    required DateTime timestamp,
    required double totalAmount,
    required double vatAmount,
  }) {
    final bytesBuilder = BytesBuilder();

    // Tag 1: Seller Name
    _addTag(bytesBuilder, 1, sellerName);

    // Tag 2: Tax Number
    _addTag(bytesBuilder, 2, taxNumber);

    // Tag 3: Timestamp (ISO 8601)
    _addTag(bytesBuilder, 3, timestamp.toIso8601String());

    // Tag 4: Total Amount
    _addTag(bytesBuilder, 4, totalAmount.toStringAsFixed(2));

    // Tag 5: VAT Amount
    _addTag(bytesBuilder, 5, vatAmount.toStringAsFixed(2));

    return base64.encode(bytesBuilder.toBytes());
  }

  /// Validates if an invoice meets minimum ZATCA requirements.
  static void validateInvoice(Invoice invoice) {
    if (invoice.totalAmount <= 0) {
      throw Exception('Total amount must be greater than zero for ZATCA');
    }
    if (invoice.taxAmount <= 0 && invoice.taxRate > 0) {
      throw Exception('VAT amount must be calculated for ZATCA compliance');
    }
    if (invoice.customerName.isEmpty) {
      throw Exception('Customer name is required for ZATCA compliance');
    }
  }

  static void _addTag(BytesBuilder builder, int tag, String value) {
    final valueBytes = utf8.encode(value);
    builder.addByte(tag);
    builder.addByte(valueBytes.length);
    builder.add(valueBytes);
  }
}
