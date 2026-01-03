import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
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
        total: 1000,
        taxAmount: 150,
      );

      // Assert
      expect(item.id, 'item-1');
      expect(item.name, 'خدمة استشارية');
      expect(item.quantity, 2.0);
      expect(item.price, 500.0);
      expect(item.total, 1000.0);
      expect(item.taxAmount, 150.0);
    });

    test('should hold correct total', () {
      // Arrange
      const item = InvoiceItem(
        id: 'item-1',
        name: 'خدمة',
        quantity: 3,
        price: 250,
        total: 750,
        taxAmount: 112.5,
      );

      // Assert
      expect(item.total, 750.0);
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
        items: const [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: 2,
            price: 500,
            total: 1000,
            taxAmount: 150,
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: 1000,
        taxAmount: 150,
        totalAmount: 1150,
        paidAmount: 0,
        discountAmount: 0,
      );

      // Assert
      expect(invoice.id, 'inv-001');
      expect(invoice.customerId, 'customer-1');
      expect(invoice.customerName, 'أحمد محمد');
      expect(invoice.items.length, 1);
      expect(invoice.taxRate, 0.15);
      expect(invoice.status, InvoiceStatus.sent);
      expect(invoice.totalAmount, 1150.0);
    });

    test('should hold correct subtotal with single item', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: 2,
            price: 500,
            total: 1000,
            taxAmount: 150,
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: 1000,
        taxAmount: 150,
        totalAmount: 1150,
        paidAmount: 0,
        discountAmount: 0,
      );

      // Assert
      expect(invoice.subtotalAmount, 1000.0);
    });

    test('should hold correct tax total', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: 2,
            price: 500,
            total: 1000,
            taxAmount: 150,
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: 1000,
        taxAmount: 150,
        totalAmount: 1150,
        paidAmount: 0,
        discountAmount: 0,
      );

      // Assert
      expect(invoice.taxAmount, 150.0); // 1000 * 0.15
    });

    test('should hold correct grand total', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: 2,
            price: 500,
            total: 1000,
            taxAmount: 150,
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: 1000,
        taxAmount: 150,
        totalAmount: 1150,
        paidAmount: 0,
        discountAmount: 0,
      );

      // Assert
      expect(invoice.totalAmount, 1150.0); // 1000 + 150
    });

    test('should support optional notes', () {
      // Arrange
      final invoice = Invoice(
        id: 'inv-001',
        invoiceNumber: 'INV-001',
        customerId: 'customer-1',
        customerName: 'أحمد',
        items: const [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: 1,
            price: 100,
            total: 100,
            taxAmount: 15,
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: 100,
        taxAmount: 15,
        totalAmount: 115,
        paidAmount: 0,
        discountAmount: 0,
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
        items: const [
          InvoiceItem(
            id: 'item-1',
            name: 'خدمة',
            quantity: 1,
            price: 100,
            total: 100,
            taxAmount: 15,
          ),
        ],
        issuedDate: now,
        dueDate: dueDate,
        taxRate: 0.15,
        status: InvoiceStatus.draft,
        createdAt: now,
        updatedAt: now,
        subtotalAmount: 100,
        taxAmount: 15,
        totalAmount: 115,
        paidAmount: 0,
        discountAmount: 0,
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
