/// اختبارات Invoice Model
///
/// يختبر تحويل البيانات والتحقق من الصحة لنموذج الفاتورة
library;

import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/invoice_fixtures.dart';

void main() {
  group('Invoice Model', () {
    group('copyWith', () {
      test('should create copy with updated status', () {
        // Arrange
        final original = InvoiceFixtures.invoice1;

        // Act
        final updated = original.copyWith(status: InvoiceStatus.sent);

        // Assert
        expect(updated.id, original.id);
        expect(updated.status, InvoiceStatus.sent);
        expect(updated.customerId, original.customerId);
        expect(updated.items, original.items);
      });

      test('should create copy with updated items', () {
        // Arrange
        final original = InvoiceFixtures.invoice1;
        final newItems = [
          InvoiceItem(
            id: 'new-1',
            name: 'منتج جديد',
            quantity: Decimal.fromInt(1),
            price: Decimal.fromInt(500),
            total: Decimal.fromInt(500),
            taxAmount: Decimal.fromInt(75),
          ),
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
        final updated = original.copyWith(taxRate: Decimal.parse('0.10'));

        // Assert
        expect(updated.taxRate, Decimal.parse('0.10'));
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
        final updated = original.copyWith(status: InvoiceStatus.paid);

        // Assert
        expect(original.status, originalStatus);
        expect(updated.status, InvoiceStatus.paid);
      });
    });

    group('InvoiceItem', () {
      test('should hold correct values', () {
        // Arrange
        final item = InvoiceItem(
          id: 'item-1',
          name: 'منتج اختبار',
          quantity: Decimal.fromInt(3),
          price: Decimal.fromInt(250),
          total: Decimal.fromInt(750),
          taxAmount: Decimal.parse('112.5'),
        );

        // Act & Assert
        expect(item.total, Decimal.fromInt(750));
        expect(item.taxAmount, Decimal.parse('112.5'));
      });

      test('should copy item with updated values', () {
        // Arrange
        final original = InvoiceItem(
          id: 'item-1',
          name: 'منتج',
          quantity: Decimal.one,
          price: Decimal.fromInt(100),
          total: Decimal.fromInt(100),
          taxAmount: Decimal.fromInt(15),
        );

        // Act
        final updated = original.copyWith(quantity: Decimal.fromInt(5));

        // Assert
        expect(updated.quantity, Decimal.fromInt(5));
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

      test('should not be equal when when content differs slightly', () {
        // Arrange
        final invoice1 = InvoiceFixtures.invoice1;
        final invoice2 = invoice1.copyWith(status: InvoiceStatus.paid);

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
        final draft = InvoiceFixtures.createInvoice(
          1,
          status: InvoiceStatus.draft,
        );
        final issued = InvoiceFixtures.createInvoice(
          2,
          status: InvoiceStatus.sent,
        );
        final paid = InvoiceFixtures.createInvoice(
          3,
          status: InvoiceStatus.paid,
        );

        // Assert
        expect(draft.status, InvoiceStatus.draft);
        expect(issued.status, InvoiceStatus.sent);
        expect(paid.status, InvoiceStatus.paid);
      });
    });
  });
}
