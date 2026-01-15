import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for multi-currency base currency conversions.
/// These tests verify that Invoice amounts are correctly converted to SAR.
void main() {
  group('Multi-Currency Base Currency Conversion', () {
    test('USD Invoice (Rate 3.75) converts to correct SAR amounts', () {
      final invoice = Invoice(
        id: 'inv-1',
        invoiceNumber: 'INV-001',
        customerId: 'cust-1',
        customerName: 'Test Customer',
        issuedDate: DateTime(2024),
        dueDate: DateTime(2024, 2),
        status: InvoiceStatus.sent,
        items: [],
        subtotalAmount: Decimal.parse('100'),
        taxAmount: Decimal.parse('15'),
        discountAmount: Decimal.zero,
        totalAmount: Decimal.parse('115'),
        paidAmount: Decimal.zero,
        taxRate: Decimal.parse('0.15'),
        discountRate: Decimal.zero,
        currency: 'USD',
        exchangeRate: Decimal.parse('3.75'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 100 USD * 3.75 = 375 SAR
      expect(invoice.subtotalAmountBaseCurrency, Decimal.parse('375'));
      // 15 USD * 3.75 = 56.25 SAR
      expect(invoice.taxAmountBaseCurrency, Decimal.parse('56.25'));
      // 115 USD * 3.75 = 431.25 SAR
      expect(invoice.totalAmountBaseCurrency, Decimal.parse('431.25'));
    });

    test('EUR Invoice (Rate 4.10) converts to correct SAR amounts', () {
      final invoice = Invoice(
        id: 'inv-2',
        invoiceNumber: 'INV-002',
        customerId: 'cust-1',
        customerName: 'Test Customer',
        issuedDate: DateTime(2024),
        dueDate: DateTime(2024, 2),
        status: InvoiceStatus.sent,
        items: [],
        subtotalAmount: Decimal.parse('200'),
        taxAmount: Decimal.parse('30'),
        discountAmount: Decimal.parse('10'),
        totalAmount: Decimal.parse('220'),
        paidAmount: Decimal.zero,
        taxRate: Decimal.parse('0.15'),
        discountRate: Decimal.parse('0.05'),
        currency: 'EUR',
        exchangeRate: Decimal.parse('4.10'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 200 EUR * 4.10 = 820 SAR
      expect(invoice.subtotalAmountBaseCurrency, Decimal.parse('820'));
      // 30 EUR * 4.10 = 123 SAR
      expect(invoice.taxAmountBaseCurrency, Decimal.parse('123'));
      // 10 EUR * 4.10 = 41 SAR
      expect(invoice.discountAmountBaseCurrency, Decimal.parse('41'));
      // 220 EUR * 4.10 = 902 SAR
      expect(invoice.totalAmountBaseCurrency, Decimal.parse('902'));
    });

    test('SAR Invoice (Rate 1.0) remains unchanged', () {
      final invoice = Invoice(
        id: 'inv-3',
        invoiceNumber: 'INV-003',
        customerId: 'cust-1',
        customerName: 'Test Customer',
        issuedDate: DateTime(2024),
        dueDate: DateTime(2024, 2),
        status: InvoiceStatus.sent,
        items: [],
        subtotalAmount: Decimal.parse('500'),
        taxAmount: Decimal.parse('75'),
        discountAmount: Decimal.zero,
        totalAmount: Decimal.parse('575'),
        paidAmount: Decimal.zero,
        taxRate: Decimal.parse('0.15'),
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(invoice.subtotalAmountBaseCurrency, Decimal.parse('500'));
      expect(invoice.taxAmountBaseCurrency, Decimal.parse('75'));
      expect(invoice.totalAmountBaseCurrency, Decimal.parse('575'));
    });

    test('Aggregation of mixed-currency invoices in SAR', () {
      final inv1 = Invoice(
        id: '1',
        invoiceNumber: '1',
        customerId: '1',
        customerName: 'A',
        issuedDate: DateTime.now(),
        dueDate: DateTime.now(),
        status: InvoiceStatus.paid,
        items: [],
        subtotalAmount: Decimal.parse('100'),
        taxAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        totalAmount: Decimal.parse('100'),
        paidAmount: Decimal.zero,
        taxRate: Decimal.zero,
        discountRate: Decimal.zero,
        currency: 'USD',
        exchangeRate: Decimal.parse('3.75'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final inv2 = Invoice(
        id: '2',
        invoiceNumber: '2',
        customerId: '1',
        customerName: 'A',
        issuedDate: DateTime.now(),
        dueDate: DateTime.now(),
        status: InvoiceStatus.paid,
        items: [],
        subtotalAmount: Decimal.parse('100'),
        taxAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        totalAmount: Decimal.parse('100'),
        paidAmount: Decimal.zero,
        taxRate: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // inv1: 100 USD * 3.75 = 375 SAR
      // inv2: 100 SAR * 1 = 100 SAR
      // Total: 475 SAR
      final totalSAR =
          inv1.totalAmountBaseCurrency + inv2.totalAmountBaseCurrency;
      expect(totalSAR, Decimal.parse('475'));
    });
  });
}
