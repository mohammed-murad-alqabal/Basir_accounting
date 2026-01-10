import 'dart:convert';

import 'package:basir_app/features/invoices/application/zatca_service.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ZatcaService QR Code Verification (Phase 1 Compliance)', () {
    test('encodeTlv should produce valid Base64 TLV string', () {
      const sellerName = 'Basir Tech';
      const taxNumber = '310123456700003';
      final timestamp = DateTime.parse('2025-01-09T18:00:00Z');
      final totalAmount = Decimal.parse('1150.00');
      final vatAmount = Decimal.parse('150.00');

      final result = ZatcaService.encodeTlv(
        sellerName: sellerName,
        taxNumber: taxNumber,
        timestamp: timestamp,
        totalAmount: totalAmount,
        vatAmount: vatAmount,
      );

      expect(result, isNotEmpty);

      // Decode Base64
      final decodedBytes = base64.decode(result);

      // Verify Tag 1 (Seller Name)
      expect(decodedBytes[0], 1); // Tag
      expect(decodedBytes[1], sellerName.length); // Length

      // Verify Tag 2 (Tax Number)
      const offset = 2 + sellerName.length;
      expect(decodedBytes[offset], 2);
      expect(decodedBytes[offset + 1], taxNumber.length);

      debugPrint('Zatca QR TLV (Base64): $result');
    });

    test('validateInvoice should catch invalid data', () {
      final invalidInvoice = Invoice(
        id: '1',
        invoiceNumber: 'INV-001',
        customerId: 'C-001',
        customerName: '', // Invalid: Empty
        items: [],
        issuedDate: DateTime.now(),
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: InvoiceStatus.draft,
        subtotalAmount: Decimal.fromInt(-10), // Invalid: Negative
        taxAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        totalAmount: Decimal.fromInt(-10),
        paidAmount: Decimal.zero,
        discountRate: Decimal.zero,
        taxRate: Decimal.fromInt(15),
      );

      expect(
        () => ZatcaService.validateInvoice(invalidInvoice),
        throwsException,
      );
    });

    test('validateInvoice should pass for valid data', () {
      final validInvoice = Invoice(
        id: '1',
        invoiceNumber: 'INV-001',
        customerId: 'C-001',
        customerName: 'Test Customer',
        items: [
          InvoiceItem(
            id: 'item-1',
            name: 'Service',
            quantity: Decimal.one,
            price: Decimal.fromInt(100),
            total: Decimal.fromInt(100),
            taxAmount: Decimal.fromInt(15),
          ),
        ],
        issuedDate: DateTime.now(),
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: InvoiceStatus.sent,
        subtotalAmount: Decimal.fromInt(100),
        taxAmount: Decimal.fromInt(15),
        discountAmount: Decimal.zero,
        totalAmount: Decimal.fromInt(115),
        paidAmount: Decimal.zero,
        discountRate: Decimal.zero,
        taxRate: Decimal.fromInt(15),
      );

      // Should not throw
      ZatcaService.validateInvoice(validInvoice);
    });
  });
}
