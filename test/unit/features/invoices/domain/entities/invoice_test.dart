import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceItem Tests', () {
    test('should create InvoiceItem with all properties', () {
      // Arrange & Act
      const item = InvoiceItem(
        id: 'item-1',
        name: 'خدمة استشارية',
        quantity: 2,
        price: 500,
      );

      // Assert
      expect(item.id, 'item-1');
      expect(item.name, 'خدمة استشارية');
      expect(item.quantity, 2.0);
      expect(item.price, 500.0);
    });

    test('should calculate total correctly', () {
      // Arrange
      const item = InvoiceItem(
        id: 'item-1',
        name: 'خدمة',
        quantity: 3,
        price: 250,
      );

      // Act
      final total = item.total;

      // Assert
      expect(total, 750.0);
    });

    test('should handle fractional quantities', () {
      // Arrange
      const item = InvoiceItem(
        id: 'item-1',
        name: 'خدمة',
        quantity: 1.5,
        price: 100,
      );

      // Act
      final total = item.total;

      // Assert
      expect(total, 150.0);
    });

    test('should handle zero quantity', () {
      // Arrange
      const item = InvoiceItem(
        id: 'item-1',
        name: 'خدمة',
        quantity: 0,
        price: 100,
      );

      // Act
      final total = item.total;

      // Assert
      expect(total, 0.0);
    });

    test('should handle zero price', () {
      // Arrange
      const item = InvoiceItem(
        id: 'item-1',
        name: 'خدمة مجانية',
        quantity: 5,
        price: 0,
      );

      // Act
      final total = item.total;

      // Assert
      expect(total, 0.0);
    });

    test('should support equality comparison', () {
      // Arrange
      const item1 = InvoiceItem(
        id: 'item-1',
        name: 'خدمة',
        quantity: 2,
        price: 500,
      );
      const item2 = InvoiceItem(
        id: 'item-1',
        name: 'خدمة',
        quantity: 2,
        price: 500,
      );

      // Assert
      expect(item1, equals(item2));
    });

    test('should support copyWith', () {
      // Arrange
      const item = InvoiceItem(
        id: 'item-1',
        name: 'خدمة',
        quantity: 2,
        price: 500,
      );

      // Act
      final updated = item.copyWith(quantity: 3);

      // Assert
      expect(updated.id, 'item-1');
      expect(updated.name, 'خدمة');
      expect(updated.quantity, 3.0);
      expect(updated.price, 500.0);
    });
  });

  group('Invoice Tests', () {
    late DateTime now;
    late DateTime dueDate;

    setUp(() {
      now = DateTime.now();
      dueDate = now.add(const Duration(days: 30));
    });

    test('should create Invoice with all properties', () {
      // Arrange & Act
      final invoice = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد محمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 2, price: 500),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'issued',
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(invoice.id, 'inv-001');
      expect(invoice.customerId, 'customer-1');
      expect(invoice.customerName, 'أحمد محمد');
      expect(invoice.items.length, 1);
      expect(invoice.taxRate, 0.15);
      expect(invoice.status, 'issued');
    });

    test('should calculate subtotal correctly with single item', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 2, price: 500),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'issued',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final subtotal = invoice.subtotal;

      // Assert
      expect(subtotal, 1000.0);
    });

    test('should calculate subtotal correctly with multiple items', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة 1', quantity: 2, price: 500),
          InvoiceItem(id: 'item-2', name: 'خدمة 2', quantity: 1, price: 300),
          InvoiceItem(id: 'item-3', name: 'خدمة 3', quantity: 3, price: 200),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'issued',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final subtotal = invoice.subtotal;

      // Assert
      expect(subtotal, 1900.0); // 1000 + 300 + 600
    });

    test('should calculate tax total correctly', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 2, price: 500),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'issued',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final taxTotal = invoice.taxTotal;

      // Assert
      expect(taxTotal, 150.0); // 1000 * 0.15
    });

    test('should calculate grand total correctly', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 2, price: 500),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'issued',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final grandTotal = invoice.grandTotal;

      // Assert
      expect(grandTotal, 1150.0); // 1000 + 150
    });

    test('should handle zero tax rate', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 2, price: 500),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0,
        status: 'issued',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final taxTotal = invoice.taxTotal;
      final grandTotal = invoice.grandTotal;

      // Assert
      expect(taxTotal, 0.0);
      expect(grandTotal, 1000.0);
    });

    test('should handle empty items list', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'draft',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final subtotal = invoice.subtotal;
      final taxTotal = invoice.taxTotal;
      final grandTotal = invoice.grandTotal;

      // Assert
      expect(subtotal, 0.0);
      expect(taxTotal, 0.0);
      expect(grandTotal, 0.0);
    });

    test('should support optional notes', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 1, price: 100),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'issued',
        createdAt: now,
        updatedAt: now,
        notes: 'شروط الدفع: 30 يوم',
      );

      // Assert
      expect(invoice.notes, 'شروط الدفع: 30 يوم');
    });

    test('should support null notes', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 1, price: 100),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'issued',
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(invoice.notes, isNull);
    });

    test('should support equality comparison', () {
      // Arrange
      final invoice1 = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 1, price: 100),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'issued',
        createdAt: now,
        updatedAt: now,
      );

      final invoice2 = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 1, price: 100),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'issued',
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(invoice1, equals(invoice2));
    });

    test('should support copyWith for status change', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 1, price: 100),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'draft',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final updated = invoice.copyWith(status: 'paid');

      // Assert
      expect(updated.status, 'paid');
      expect(updated.id, invoice.id);
      expect(updated.customerId, invoice.customerId);
    });

    test('should support copyWith for items change', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 1, price: 100),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: 'draft',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final updated = invoice.copyWith(
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 1, price: 100),
          InvoiceItem(id: 'item-2', name: 'خدمة 2', quantity: 2, price: 200),
        ],
      );

      // Assert
      expect(updated.items.length, 2);
      expect(updated.subtotal, 500.0); // 100 + 400
    });

    test('should calculate correctly with different tax rates', () {
      // Arrange
      final invoice5 = Invoice(
        id: 'inv-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 1, price: 1000),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.05, // 5%
        status: 'issued',
        createdAt: now,
        updatedAt: now,
      );

      final invoice10 = invoice5.copyWith(taxRate: 0.10); // 10%
      final invoice20 = invoice5.copyWith(taxRate: 0.20); // 20%

      // Assert
      expect(invoice5.taxTotal, 50.0);
      expect(invoice5.grandTotal, 1050.0);

      expect(invoice10.taxTotal, 100.0);
      expect(invoice10.grandTotal, 1100.0);

      expect(invoice20.taxTotal, 200.0);
      expect(invoice20.grandTotal, 1200.0);
    });
  });
}
