/// اختبارات Invoice Model
///
/// يختبر تحويل البيانات والتحقق من الصحة لنموذج الفاتورة
library;

import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/invoice_fixtures.dart';

void main() {
  group('Invoice Model', () {
    group('copyWith', () {
      test('should create copy with updated status', () {
        // Arrange
        final original = InvoiceFixtures.invoice1;

        // Act
        final updated = original.copyWith(status: 'issued');

        // Assert
        expect(updated.id, original.id);
        expect(updated.status, 'issued');
        expect(updated.customerId, original.customerId);
        expect(updated.items, original.items);
      });

      test('should create copy with updated items', () {
        // Arrange
        final original = InvoiceFixtures.invoice1;
        const newItems = [
          InvoiceItem(id: 'new-1', name: 'منتج جديد', quantity: 1, price: 500),
        ];

        // Act
        final updated = original.copyWith(items: newItems);

        // Assert
        expect(updated.items, newItems);
        expect(updated.id, original.id);
      });

      test('should create copy with updated dates', () {
        // Arrange
        final original = InvoiceFixtures.invoice1;
        final newIssuedDate = DateTime(2025, 12);
        final newDueDate = DateTime(2026);

        // Act
        final updated = original.copyWith(
          issuedDate: newIssuedDate,
          dueDate: newDueDate,
        );

        // Assert
        expect(updated.issuedDate, newIssuedDate);
        expect(updated.dueDate, newDueDate);
      });

      test('should create copy with updated tax rate', () {
        // Arrange
        final original = InvoiceFixtures.invoice1;

        // Act
        final updated = original.copyWith(taxRate: 0.10);

        // Assert
        expect(updated.taxRate, 0.10);
        expect(updated.id, original.id);
      });

      test('should create copy with updated notes', () {
        // Arrange
        final original = InvoiceFixtures.invoice1;

        // Act
        final updated = original.copyWith(notes: 'ملاحظات جديدة');

        // Assert
        expect(updated.notes, 'ملاحظات جديدة');
      });

      test('should not modify original when creating copy', () {
        // Arrange
        final original = InvoiceFixtures.invoice1;
        final originalStatus = original.status;

        // Act
        final updated = original.copyWith(status: 'paid');

        // Assert
        expect(original.status, originalStatus);
        expect(updated.status, 'paid');
      });
    });

    group('calculations', () {
      test('should calculate subtotal correctly', () {
        // Arrange
        final invoice = Invoice(
          id: 'test-1',
          customerId: 'customer-1',
          customerName: 'عميل اختبار',
          issuedDate: DateTime.now(),
          dueDate: DateTime.now().add(const Duration(days: 30)),
          status: 'draft',
          items: const [
            InvoiceItem(id: 'item-1', name: 'منتج 1', quantity: 2, price: 100),
            InvoiceItem(id: 'item-2', name: 'منتج 2', quantity: 3, price: 200),
          ],
          taxRate: 0.15,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act & Assert
        expect(invoice.subtotal, 800); // (2*100) + (3*200) = 800
      });

      test('should calculate tax total correctly', () {
        // Arrange
        final invoice = Invoice(
          id: 'test-2',
          customerId: 'customer-1',
          customerName: 'عميل اختبار',
          issuedDate: DateTime.now(),
          dueDate: DateTime.now().add(const Duration(days: 30)),
          status: 'draft',
          items: const [
            InvoiceItem(id: 'item-1', name: 'منتج', quantity: 1, price: 1000),
          ],
          taxRate: 0.15,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act & Assert
        expect(invoice.taxTotal, 150); // 1000 * 0.15 = 150
      });

      test('should calculate grand total correctly', () {
        // Arrange
        final invoice = Invoice(
          id: 'test-3',
          customerId: 'customer-1',
          customerName: 'عميل اختبار',
          issuedDate: DateTime.now(),
          dueDate: DateTime.now().add(const Duration(days: 30)),
          status: 'draft',
          items: const [
            InvoiceItem(id: 'item-1', name: 'منتج', quantity: 1, price: 1000),
          ],
          taxRate: 0.15,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act & Assert
        expect(invoice.grandTotal, 1150); // 1000 + 150 = 1150
      });

      test('should handle zero tax rate', () {
        // Arrange
        final invoice = Invoice(
          id: 'test-4',
          customerId: 'customer-1',
          customerName: 'عميل اختبار',
          issuedDate: DateTime.now(),
          dueDate: DateTime.now().add(const Duration(days: 30)),
          status: 'draft',
          items: const [
            InvoiceItem(id: 'item-1', name: 'منتج', quantity: 1, price: 1000),
          ],
          taxRate: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act & Assert
        expect(invoice.taxTotal, 0);
        expect(invoice.grandTotal, 1000);
      });

      test('should handle empty items list', () {
        // Arrange
        final emptyInvoice = Invoice(
          id: 'test-5',
          customerId: 'customer-1',
          customerName: 'عميل اختبار',
          issuedDate: DateTime.now(),
          dueDate: DateTime.now().add(const Duration(days: 30)),
          status: 'draft',
          items: const [],
          taxRate: 0.15,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act & Assert
        expect(emptyInvoice.subtotal, 0);
        expect(emptyInvoice.taxTotal, 0);
        expect(emptyInvoice.grandTotal, 0);
      });
    });

    group('InvoiceItem', () {
      test('should calculate item total correctly', () {
        // Arrange
        const item = InvoiceItem(
          id: 'item-1',
          name: 'منتج اختبار',
          quantity: 3,
          price: 250,
        );

        // Act & Assert
        expect(item.total, 750); // 3 * 250 = 750
      });

      test('should handle decimal quantities', () {
        // Arrange
        const item = InvoiceItem(
          id: 'item-2',
          name: 'خدمة',
          quantity: 2.5,
          price: 100,
        );

        // Act & Assert
        expect(item.total, 250); // 2.5 * 100 = 250
      });

      test('should copy item with updated values', () {
        // Arrange
        const original = InvoiceItem(
          id: 'item-1',
          name: 'منتج',
          quantity: 1,
          price: 100,
        );

        // Act
        final updated = original.copyWith(quantity: 5);

        // Assert
        expect(updated.quantity, 5);
        expect(updated.name, original.name);
        expect(updated.price, original.price);
      });
    });

    group('equality', () {
      test('should be equal when IDs match', () {
        // Arrange
        final invoice1 = InvoiceFixtures.invoice1;
        final invoice2 = InvoiceFixtures.invoice1.copyWith();

        // Assert
        expect(invoice1, equals(invoice2));
      });

      test('should not be equal when IDs differ', () {
        // Arrange
        final invoice1 = InvoiceFixtures.invoice1;
        final invoice2 = InvoiceFixtures.invoice2;

        // Assert
        expect(invoice1, isNot(equals(invoice2)));
      });
    });

    group('fixtures validation', () {
      test('should have valid invoice fixtures', () {
        // Act & Assert
        expect(InvoiceFixtures.allInvoices.length, 7);
        expect(InvoiceFixtures.draftInvoices.length, 3);
        expect(InvoiceFixtures.issuedInvoices.length, 1);
        expect(InvoiceFixtures.paidInvoices.length, 1);
        expect(InvoiceFixtures.overdueInvoices.length, 1);
        expect(InvoiceFixtures.cancelledInvoices.length, 1);
      });

      test('should create dynamic invoices', () {
        // Act
        final invoice = InvoiceFixtures.createInvoice(1);
        final invoices = InvoiceFixtures.createInvoices(3);

        // Assert
        expect(invoice.id, 'invoice-1');
        expect(invoice.customerName, 'عميل رقم 1');
        expect(invoices.length, 3);
      });

      test('should handle different statuses', () {
        // Act
        final draft = InvoiceFixtures.createInvoice(1, status: 'draft');
        final issued = InvoiceFixtures.createInvoice(2, status: 'issued');
        final paid = InvoiceFixtures.createInvoice(3, status: 'paid');

        // Assert
        expect(draft.status, 'draft');
        expect(issued.status, 'issued');
        expect(paid.status, 'paid');
      });
    });
  });
}
