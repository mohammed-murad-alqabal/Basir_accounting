import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Invoice Entity', () {
    test('Invoice creation with valid data', () {
      final now = DateTime.now();
      final invoice = Invoice(
        id: '1',
        customerId: 'cust_1',
        customerName: 'أحمد محمد',
        items: [],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: 0.15,
        status: 'draft',
        createdAt: now,
        updatedAt: now,
      );

      expect(invoice.id, equals('1'));
      expect(invoice.customerId, equals('cust_1'));
      expect(invoice.customerName, equals('أحمد محمد'));
      expect(invoice.status, equals('draft'));
      expect(invoice.items, isEmpty);
    });

    test('Invoice total calculation', () {
      final now = DateTime.now();
      final item1 = InvoiceItem(
        id: '1',
        name: 'خدمة استشارة',
        quantity: 2,
        price: 500,
      );
      final item2 = InvoiceItem(
        id: '2',
        name: 'خدمة تطوير',
        quantity: 1,
        price: 500,
      );

      final invoice = Invoice(
        id: '1',
        customerId: 'cust_1',
        customerName: 'أحمد محمد',
        items: [item1, item2],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: 0.15,
        status: 'issued',
        createdAt: now,
        updatedAt: now,
      );

      expect(invoice.subtotal, equals(1500.0));
      expect(invoice.taxTotal, equals(225.0));
      expect(invoice.grandTotal, equals(1725.0));
    });

    test('InvoiceItem total calculation', () {
      final item = InvoiceItem(
        id: '1',
        name: 'خدمة',
        quantity: 3,
        price: 100,
      );

      expect(item.total, equals(300.0));
    });

    test('Invoice equality', () {
      final now = DateTime.now();
      final invoice1 = Invoice(
        id: '1',
        customerId: 'cust_1',
        customerName: 'أحمد',
        items: [],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: 0.15,
        status: 'draft',
        createdAt: now,
        updatedAt: now,
      );
      final invoice2 = Invoice(
        id: '1',
        customerId: 'cust_1',
        customerName: 'أحمد',
        items: [],
        issuedDate: now,
        dueDate: now.add(const Duration(days: 30)),
        taxRate: 0.15,
        status: 'draft',
        createdAt: now,
        updatedAt: now,
      );

      expect(invoice1, equals(invoice2));
    });
  });
}
