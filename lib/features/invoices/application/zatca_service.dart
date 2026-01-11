/// ***
/// Cognitive Foundation: ZatcaService
///
/// Orchestrates compliance with the Saudi Arabian ZATCA (Fatoora) standards.
/// Implements Tag-Length-Value (TLV) encoding for Phase 1 and Phase 2.
///
/// Uses [Decimal] for all financial inputs to ensure precision during
/// institutional audits.
/// ***
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:decimal/decimal.dart';

/// [ZatcaService]
class ZatcaService {
  /// Encodes institutional invoice data into a Base64 TLV string for QR codes.
  ///
  /// Tags mapping (Ref: ZATCA Requirements):
  /// 1. Seller Name
  /// 2. Tax Number (VAT Registration Number)
  /// 3. Invoice Timestamp
  /// 4. Total Amount (with VAT)
  /// 5. VAT Amount
  static String encodeTlv({
    required String sellerName,
    required String taxNumber,
    required DateTime timestamp,
    required Decimal totalAmount,
    required Decimal vatAmount,
  }) {
    final bytesBuilder = BytesBuilder();

    // Tag 1: Seller Name
    _addTag(bytesBuilder, 1, sellerName);

    // Tag 2: Tax Number
    _addTag(bytesBuilder, 2, taxNumber);

    // Tag 3: Timestamp (ISO 8601)
    _addTag(bytesBuilder, 3, timestamp.toIso8601String());

    // Tag 4: Total Amount (Precision: 2 decimal places)
    _addTag(bytesBuilder, 4, totalAmount.toStringAsFixed(2));

    // Tag 5: VAT Amount (Precision: 2 decimal places)
    _addTag(bytesBuilder, 5, vatAmount.toStringAsFixed(2));

    return base64.encode(bytesBuilder.toBytes());
  }

  /// Conducts an institutional validation audit for ZATCA compliance.
  static void validateInvoice(Invoice invoice) {
    if (invoice.totalAmount <= Decimal.zero) {
      throw Exception('Total amount must be greater than zero for ZATCA');
    }
    if (invoice.taxAmount <= Decimal.zero && invoice.taxRate > Decimal.zero) {
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
