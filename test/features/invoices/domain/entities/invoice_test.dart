import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Invoice Entity', () {
    test('Invoice creation with valid data', () {
      final now = DateTime.now();
      final invoice = Invoice(
        id: '1',
        invoiceNumber: 'INV-001',
        customerId: 'cust_1',
        customerName: 'أحمد محمد',
        items: [],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.draft,
        subtotalAmount: Decimal.zero,
        taxAmount: Decimal.zero,
        totalAmount: Decimal.zero,
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
        createdAt: now,
        updatedAt: now,
      );

      expect(invoice.id, equals('1'));
      expect(invoice.customerId, equals('cust_1'));
      expect(invoice.customerName, equals('أحمد محمد'));
      expect(invoice.status, equals(InvoiceStatus.draft));
      expect(invoice.items, isEmpty);
    });

    test('Invoice fields verification', () {
      final now = DateTime.now();
      final item1 = InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        id: '1',
        name: 'خدمة استشارة',
        quantity: Decimal.fromInt(2),
        price: Decimal.fromInt(500),
        total: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
      );
      final item2 = InvoiceItem(
        id: '2',
        name: 'خدمة تطوير',
        quantity: Decimal.one,
        price: Decimal.fromInt(500),
        total: Decimal.fromInt(500),
        taxAmount: Decimal.fromInt(75),
        taxRate: Decimal.parse('0.15'),
      );

      final invoice = Invoice(
        id: '1',
        invoiceNumber: 'INV-001',
        customerId: 'cust_1',
        customerName: 'أحمد محمد',
        items: [item1, item2],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        subtotalAmount: Decimal.parse('1500'),
        taxAmount: Decimal.parse('225'),
        totalAmount: Decimal.parse('1725'),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
        createdAt: now,
        updatedAt: now,
      );

      expect(invoice.subtotalAmount, equals(Decimal.parse('1500')));
      expect(invoice.taxAmount, equals(Decimal.parse('225')));
      expect(invoice.totalAmount, equals(Decimal.parse('1725')));
    });

    test('InvoiceItem total verification', () {
      final item = InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        id: '1',
        name: 'خدمة',
        quantity: Decimal.fromInt(3),
        price: Decimal.fromInt(100),
        total: Decimal.fromInt(300),
        taxAmount: Decimal.fromInt(45),
      );

      expect(item.total, equals(Decimal.fromInt(300)));
    });

    test('Invoice equality', () {
      final now = DateTime.now();
      final invoice1 = Invoice(
        id: '1',
        invoiceNumber: 'INV-001',
        customerId: 'cust_1',
        customerName: 'أحمد',
        items: [],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.draft,
        subtotalAmount: Decimal.zero,
        taxAmount: Decimal.zero,
        totalAmount: Decimal.zero,
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
        createdAt: now,
        updatedAt: now,
      );
      final invoice2 = Invoice(
        id: '1',
        invoiceNumber: 'INV-001',
        customerId: 'cust_1',
        customerName: 'أحمد',
        items: [],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.draft,
        subtotalAmount: Decimal.zero,
        taxAmount: Decimal.zero,
        totalAmount: Decimal.zero,
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
        createdAt: now,
        updatedAt: now,
      );

      expect(invoice1, equals(invoice2));
    });
  });
}
