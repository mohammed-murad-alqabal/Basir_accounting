import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
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
        items: const [],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: 0.15,
        status: InvoiceStatus.draft,
        subtotalAmount: 0,
        taxAmount: 0,
        totalAmount: 0,
        paidAmount: 0,
        discountAmount: 0,
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
      const item1 = InvoiceItem(
        id: '1',
        name: 'خدمة استشارة',
        quantity: 2,
        price: 500,
        total: 1000,
        taxAmount: 150,
      );
      const item2 = InvoiceItem(
        id: '2',
        name: 'خدمة تطوير',
        quantity: 1,
        price: 500,
        total: 500,
        taxAmount: 75,
      );

      final invoice = Invoice(
        id: '1',
        invoiceNumber: 'INV-001',
        customerId: 'cust_1',
        customerName: 'أحمد محمد',
        items: const [item1, item2],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: 0.15,
        status: InvoiceStatus.sent,
        subtotalAmount: 1500,
        taxAmount: 225,
        totalAmount: 1725,
        paidAmount: 0,
        discountAmount: 0,
        createdAt: now,
        updatedAt: now,
      );

      expect(invoice.subtotalAmount, equals(1500.0));
      expect(invoice.taxAmount, equals(225.0));
      expect(invoice.totalAmount, equals(1725.0));
    });

    test('InvoiceItem total verification', () {
      const item = InvoiceItem(
        id: '1',
        name: 'خدمة',
        quantity: 3,
        price: 100,
        total: 300,
      );

      expect(item.total, equals(300.0));
    });

    test('Invoice equality', () {
      final now = DateTime.now();
      final invoice1 = Invoice(
        id: '1',
        invoiceNumber: 'INV-001',
        customerId: 'cust_1',
        customerName: 'أحمد',
        items: const [],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: 0.15,
        status: InvoiceStatus.draft,
        subtotalAmount: 0,
        taxAmount: 0,
        totalAmount: 0,
        paidAmount: 0,
        discountAmount: 0,
        createdAt: now,
        updatedAt: now,
      );
      final invoice2 = Invoice(
        id: '1',
        invoiceNumber: 'INV-001',
        customerId: 'cust_1',
        customerName: 'أحمد',
        items: const [],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: 0.15,
        status: InvoiceStatus.draft,
        subtotalAmount: 0,
        taxAmount: 0,
        totalAmount: 0,
        paidAmount: 0,
        discountAmount: 0,
        createdAt: now,
        updatedAt: now,
      );

      expect(invoice1, equals(invoice2));
    });
  });
}
