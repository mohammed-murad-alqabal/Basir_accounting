import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceItem Tests', () {
    test('should create InvoiceItem with all properties', () {
      // Arrange & Act
      final item = InvoiceItem(
        id: 'item-1',
        name: 'خدمة استشارية',
        quantity: Decimal.fromInt(2),
        price: Decimal.fromInt(500),
        total: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
      );

      // Assert
      expect(item.id, 'item-1');
      expect(item.name, 'خدمة استشارية');
      expect(item.quantity, Decimal.fromInt(2));
      expect(item.price, Decimal.fromInt(500));
      expect(item.total, Decimal.fromInt(1000));
      expect(item.taxAmount, Decimal.fromInt(150));
    });

    test('should hold correct total', () {
      // Arrange
      final item = InvoiceItem(
        id: 'item-1',
        name: 'خدمة',
        quantity: Decimal.fromInt(3),
        price: Decimal.fromInt(250),
        total: Decimal.fromInt(750),
        taxAmount: Decimal.parse('112.5'),
      );

      // Assert
      expect(item.total, Decimal.fromInt(750));
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
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد محمد',
        items: [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.fromInt(2),
            price: Decimal.fromInt(500),
            total: Decimal.fromInt(1000),
            taxAmount: Decimal.fromInt(150),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
        totalAmount: Decimal.fromInt(1150),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
      );

      // Assert
      expect(invoice.id, 'inv-001');
      expect(invoice.customerId, 'customer-1');
      expect(invoice.customerName, 'أحمد محمد');
      expect(invoice.items.length, 1);
      expect(invoice.taxRate, Decimal.parse('0.15'));
      expect(invoice.status, InvoiceStatus.sent);
      expect(invoice.totalAmount, Decimal.fromInt(1150));
    });

    test('should hold correct subtotal with single item', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.fromInt(2),
            price: Decimal.fromInt(500),
            total: Decimal.fromInt(1000),
            taxAmount: Decimal.fromInt(150),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
        totalAmount: Decimal.fromInt(1150),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
      );

      // Assert
      expect(invoice.subtotalAmount, Decimal.fromInt(1000));
    });

    test('should hold correct tax total', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.fromInt(2),
            price: Decimal.fromInt(500),
            total: Decimal.fromInt(1000),
            taxAmount: Decimal.fromInt(150),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
        totalAmount: Decimal.fromInt(1150),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
      );

      // Assert
      expect(invoice.taxAmount, Decimal.fromInt(150)); // 1000 * 0.15
    });

    test('should hold correct grand total', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.fromInt(2),
            price: Decimal.fromInt(500),
            total: Decimal.fromInt(1000),
            taxAmount: Decimal.fromInt(150),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
        totalAmount: Decimal.fromInt(1150),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
      );

      // Assert
      expect(invoice.totalAmount, Decimal.fromInt(1150)); // 1000 + 150
    });

    test('should support optional notes', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.one,
            price: Decimal.fromInt(100),
            total: Decimal.fromInt(100),
            taxAmount: Decimal.fromInt(15),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(100),
        taxAmount: Decimal.fromInt(15),
        totalAmount: Decimal.fromInt(115),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        notes: 'شروط الدفع: 30 يوم',
      );

      // Assert
      expect(invoice.notes, 'شروط الدفع: 30 يوم');
    });

    test('should support copyWith for status change', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: Decimal.one,
            price: Decimal.fromInt(100),
            total: Decimal.fromInt(100),
            taxAmount: Decimal.fromInt(15),
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.draft,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: Decimal.fromInt(100),
        taxAmount: Decimal.fromInt(15),
        totalAmount: Decimal.fromInt(115),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
      );

      // Act
      final updated = invoice.copyWith(status: InvoiceStatus.paid);

      // Assert
      expect(updated.status, InvoiceStatus.paid);
      expect(updated.id, invoice.id);
      expect(updated.customerId, invoice.customerId);
    });
  });
}
