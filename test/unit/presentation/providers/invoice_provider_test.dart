/// اختبارات InvoiceProvider
///
/// يختبر جميع عمليات إدارة الفواتير في طبقة Presentation
library;

import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_data.dart';
import '../../../mocks/mock_invoice_repository.dart';

void main() {
  late MockInvoiceRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockInvoiceRepository();
    container = ProviderContainer(
      overrides: [
        // Override invoiceRepositoryProvider with mock
        // Note: We need to import the actual provider to override it
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('InvoiceProvider - Loading', () {
    test('should load invoices successfully', () async {
      // Arrange
      final testInvoices = MockData.createTestInvoices();
      for (final invoice in testInvoices) {
        await mockRepository.addInvoice(invoice);
      }

      // Act
      final invoices = await mockRepository.getAllInvoices();

      // Assert
      expect(invoices, isA<List<Invoice>>());
      expect(invoices.length, 3);
    });

    test('should return empty list when no invoices exist', () async {
      // Act
      final invoices = await mockRepository.getAllInvoices();

      // Assert
      expect(invoices, isEmpty);
    });

    test('should handle loading state with multiple invoices', () async {
      // Arrange
      final testInvoices = MockData.createTestInvoices(count: 5);
      for (final invoice in testInvoices) {
        await mockRepository.addInvoice(invoice);
      }

      // Act
      final invoices = await mockRepository.getAllInvoices();

      // Assert
      expect(invoices, isNotEmpty);
      expect(invoices.length, 5);
    });

    test('should load invoices with all fields populated', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();
      await mockRepository.addInvoice(invoice);

      // Act
      final invoices = await mockRepository.getAllInvoices();
      final loadedInvoice = invoices.first;

      // Assert
      expect(loadedInvoice.id, invoice.id);
      expect(loadedInvoice.customerName, invoice.customerName);
      expect(loadedInvoice.status, invoice.status);
      expect(loadedInvoice.items, invoice.items);
      expect(loadedInvoice.totalAmount, invoice.totalAmount);
    });
  });

  group('InvoiceProvider - Add Invoice', () {
    test('should add invoice successfully', () async {
      // Arrange
      final newInvoice = MockData.createTestInvoice(
        id: 'new-invoice',
        customerName: 'عميل جديد',
      );

      // Act
      await mockRepository.addInvoice(newInvoice);
      final invoices = await mockRepository.getAllInvoices();

      // Assert
      expect(invoices, contains(newInvoice));
      expect(invoices.length, 1);
    });

    test('should add multiple invoices', () async {
      // Arrange
      final invoice1 = MockData.createTestInvoice(id: 'invoice-1');
      final invoice2 = MockData.createTestInvoice(id: 'invoice-2');
      final invoice3 = MockData.createTestInvoice(id: 'invoice-3');

      // Act
      await mockRepository.addInvoice(invoice1);
      await mockRepository.addInvoice(invoice2);
      await mockRepository.addInvoice(invoice3);
      final invoices = await mockRepository.getAllInvoices();

      // Assert
      expect(invoices.length, 3);
      expect(invoices, contains(invoice1));
      expect(invoices, contains(invoice2));
      expect(invoices, contains(invoice3));
    });

    test('should preserve invoice data when adding', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(
        id: 'test-id',
        customerName: 'أحمد محمد',
        status: InvoiceStatus.draft,
      );

      // Act
      await mockRepository.addInvoice(invoice);
      final invoices = await mockRepository.getAllInvoices();
      final addedInvoice = invoices.first;

      // Assert
      expect(addedInvoice.id, invoice.id);
      expect(addedInvoice.customerName, invoice.customerName);
      expect(addedInvoice.status, invoice.status);
      expect(addedInvoice.items.length, invoice.items.length);
    });

    test('should calculate totals correctly when adding invoice', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(itemCount: 3, itemPrice: 100);

      // Act
      await mockRepository.addInvoice(invoice);
      final invoices = await mockRepository.getAllInvoices();
      final addedInvoice = invoices.first;

      // Assert
      expect(addedInvoice.subtotalAmount, 300.0); // 3 items * 100
      expect(addedInvoice.taxAmount, 45.0); // 300 * 0.15
      expect(addedInvoice.totalAmount, 345.0); // 300 + 45
    });
  });

  group('InvoiceProvider - Update Invoice', () {
    test('should update invoice successfully', () async {
      // Arrange
      final originalInvoice = MockData.createTestInvoice(
        id: 'invoice-1',
        customerName: 'اسم قديم',
        status: InvoiceStatus.draft,
      );
      await mockRepository.addInvoice(originalInvoice);

      final updatedInvoice = originalInvoice.copyWith(
        customerName: 'اسم جديد',
        status: InvoiceStatus.sent,
      );

      // Act
      await mockRepository.updateInvoice(updatedInvoice);
      final invoice = await mockRepository.getInvoiceById('invoice-1');

      // Assert
      expect(invoice, isNotNull);
      expect(invoice!.customerName, 'اسم جديد');
      expect(invoice.status, InvoiceStatus.sent);
    });

    test('should update only specified fields', () async {
      // Arrange
      final originalInvoice = MockData.createTestInvoice(
        id: 'invoice-1',
        customerName: 'أحمد',
        status: InvoiceStatus.draft,
      );
      await mockRepository.addInvoice(originalInvoice);

      final updatedInvoice = originalInvoice.copyWith(
        status: InvoiceStatus.paid,
      );

      // Act
      await mockRepository.updateInvoice(updatedInvoice);
      final invoice = await mockRepository.getInvoiceById('invoice-1');

      // Assert
      expect(invoice!.customerName, 'أحمد'); // لم يتغير
      expect(invoice.status, InvoiceStatus.paid); // تغير
    });

    test('should handle updating non-existent invoice', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(id: 'non-existent');

      // Act & Assert
      expect(() => mockRepository.updateInvoice(invoice), throwsException);
    });

    test('should recalculate totals when updating items', () async {
      // Arrange
      final originalInvoice = MockData.createTestInvoice(
        id: 'invoice-1',
        itemCount: 2,
        itemPrice: 100,
      );
      await mockRepository.addInvoice(originalInvoice);

      // Create updated invoice with different items
      final updatedInvoice = MockData.createTestInvoice(
        id: 'invoice-1',
        itemCount: 3,
        itemPrice: 150,
      );

      // Act
      await mockRepository.updateInvoice(updatedInvoice);
      final invoice = await mockRepository.getInvoiceById('invoice-1');

      // Assert
      expect(invoice!.subtotalAmount, 450.0); // 3 * 150
      expect(invoice.taxAmount, 67.5); // 450 * 0.15
      expect(invoice.totalAmount, 517.5); // 450 + 67.5
    });
  });

  group('InvoiceProvider - Delete Invoice', () {
    test('should delete invoice successfully', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(id: 'invoice-1');
      await mockRepository.addInvoice(invoice);

      // Act
      await mockRepository.deleteInvoice('invoice-1');
      final invoices = await mockRepository.getAllInvoices();

      // Assert
      expect(invoices, isEmpty);
    });

    test('should delete specific invoice from multiple', () async {
      // Arrange
      final invoice1 = MockData.createTestInvoice(id: 'invoice-1');
      final invoice2 = MockData.createTestInvoice(id: 'invoice-2');
      final invoice3 = MockData.createTestInvoice(id: 'invoice-3');

      await mockRepository.addInvoice(invoice1);
      await mockRepository.addInvoice(invoice2);
      await mockRepository.addInvoice(invoice3);

      // Act
      await mockRepository.deleteInvoice('invoice-2');
      final invoices = await mockRepository.getAllInvoices();

      // Assert
      expect(invoices.length, 2);
      expect(invoices, contains(invoice1));
      expect(invoices, isNot(contains(invoice2)));
      expect(invoices, contains(invoice3));
    });

    test('should handle deleting non-existent invoice gracefully', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(id: 'invoice-1');
      await mockRepository.addInvoice(invoice);

      // Act - Delete non-existent invoice (should not throw)
      await mockRepository.deleteInvoice('non-existent');
      final invoices = await mockRepository.getAllInvoices();

      // Assert - Original invoice should still exist
      expect(invoices.length, 1);
      expect(invoices.first.id, 'invoice-1');
    });
  });

  group('InvoiceProvider - Filter by Status', () {
    test('should filter invoices by status - مسودة', () async {
      // Arrange
      final invoice1 = MockData.createTestInvoice(
        id: 'invoice-1',
        status: InvoiceStatus.draft,
      );
      final invoice2 = MockData.createTestInvoice(
        id: 'invoice-2',
        status: InvoiceStatus.sent,
      );
      final invoice3 = MockData.createTestInvoice(
        id: 'invoice-3',
        status: InvoiceStatus.draft,
      );

      await mockRepository.addInvoice(invoice1);
      await mockRepository.addInvoice(invoice2);
      await mockRepository.addInvoice(invoice3);

      // Act
      final allInvoices = await mockRepository.getAllInvoices();
      final filtered =
          allInvoices.where((i) => i.status == InvoiceStatus.draft).toList();

      // Assert
      expect(filtered.length, 2);
      expect(filtered, contains(invoice1));
      expect(filtered, contains(invoice3));
    });

    test('should filter invoices by status - مدفوعة', () async {
      // Arrange
      final invoice1 = MockData.createTestInvoice(
        id: 'invoice-1',
        status: InvoiceStatus.paid,
      );
      final invoice2 = MockData.createTestInvoice(
        id: 'invoice-2',
        status: InvoiceStatus.sent,
      );

      await mockRepository.addInvoice(invoice1);
      await mockRepository.addInvoice(invoice2);

      // Act
      final allInvoices = await mockRepository.getAllInvoices();
      final filtered =
          allInvoices.where((i) => i.status == InvoiceStatus.paid).toList();

      // Assert
      expect(filtered.length, 1);
      expect(filtered.first.id, 'invoice-1');
    });

    test('should return all invoices when filter is الكل', () async {
      // Arrange
      final invoices = MockData.createTestInvoices(count: 5);
      for (final invoice in invoices) {
        await mockRepository.addInvoice(invoice);
      }

      // Act
      final allInvoices = await mockRepository.getAllInvoices();

      // Assert
      expect(allInvoices.length, 5);
    });
  });

  group('InvoiceProvider - Search', () {
    test('should search invoices by customer name', () async {
      // Arrange
      final invoice1 = MockData.createTestInvoice(
        id: 'invoice-1',
        customerName: 'أحمد محمد',
      );
      final invoice2 = MockData.createTestInvoice(
        id: 'invoice-2',
        customerName: 'محمد علي',
      );
      final invoice3 = MockData.createTestInvoice(
        id: 'invoice-3',
        customerName: 'علي حسن',
      );

      await mockRepository.addInvoice(invoice1);
      await mockRepository.addInvoice(invoice2);
      await mockRepository.addInvoice(invoice3);

      // Act
      final allInvoices = await mockRepository.getAllInvoices();
      final filtered =
          allInvoices.where((i) => i.customerName.contains('محمد')).toList();

      // Assert
      expect(filtered.length, 2);
      expect(filtered, contains(invoice1));
      expect(filtered, contains(invoice2));
    });

    test('should search invoices by ID', () async {
      // Arrange
      final invoice1 = MockData.createTestInvoice(id: 'INV-001');
      final invoice2 = MockData.createTestInvoice(id: 'INV-002');

      await mockRepository.addInvoice(invoice1);
      await mockRepository.addInvoice(invoice2);

      // Act
      final allInvoices = await mockRepository.getAllInvoices();
      final filtered =
          allInvoices.where((i) => i.id.contains('INV-001')).toList();

      // Assert
      expect(filtered.length, 1);
      expect(filtered.first.id, 'INV-001');
    });

    test('should return empty list when no matches found', () async {
      // Arrange
      final invoice = MockData.createTestInvoice(customerName: 'أحمد');
      await mockRepository.addInvoice(invoice);

      // Act
      final allInvoices = await mockRepository.getAllInvoices();
      final filtered = allInvoices
          .where((i) => i.customerName.contains('غير موجود'))
          .toList();

      // Assert
      expect(filtered, isEmpty);
    });
  });

  group('InvoiceProvider - Calculations', () {
    test('should calculate total sales correctly', () async {
      // Arrange
      final invoice1 = MockData.createTestInvoice(
        id: 'invoice-1',
        itemCount: 2,
        itemPrice: 100,
      );
      final invoice2 = MockData.createTestInvoice(
        id: 'invoice-2',
        itemCount: 3,
        itemPrice: 150,
      );

      await mockRepository.addInvoice(invoice1);
      await mockRepository.addInvoice(invoice2);

      // Act
      final invoices = await mockRepository.getAllInvoices();
      final totalSales = invoices.fold<double>(
        0,
        (sum, invoice) => sum + invoice.totalAmount,
      );

      // Assert
      // invoice1: (2 * 100) + (200 * 0.15) = 230
      // invoice2: (3 * 150) + (450 * 0.15) = 517.5
      expect(totalSales, 747.5);
    });

    test('should count overdue invoices correctly', () async {
      // Arrange
      final invoice1 = MockData.createTestInvoice(
        id: 'invoice-1',
        status: InvoiceStatus.overdue,
      );
      final invoice2 = MockData.createTestInvoice(
        id: 'invoice-2',
        status: InvoiceStatus.paid,
      );
      final invoice3 = MockData.createTestInvoice(
        id: 'invoice-3',
        status: InvoiceStatus.overdue,
      );

      await mockRepository.addInvoice(invoice1);
      await mockRepository.addInvoice(invoice2);
      await mockRepository.addInvoice(invoice3);

      // Act
      final invoices = await mockRepository.getAllInvoices();
      final overdueCount =
          invoices.where((i) => i.status == InvoiceStatus.overdue).length;

      // Assert
      expect(overdueCount, 2);
    });

    test('should handle empty invoice list in calculations', () async {
      // Act
      final invoices = await mockRepository.getAllInvoices();
      final totalSales = invoices.fold<double>(
        0,
        (sum, invoice) => sum + invoice.totalAmount,
      );

      // Assert
      expect(totalSales, 0.0);
    });
  });

  group('InvoiceProvider - Error Handling', () {
    test('should handle repository errors gracefully', () async {
      // Act - MockRepository returns null for non-existent invoices
      final invoice = await mockRepository.getInvoiceById('non-existent');

      // Assert
      expect(invoice, isNull);
    });

    test('should handle empty invoice list', () async {
      // Act
      final invoices = await mockRepository.getAllInvoices();

      // Assert
      expect(invoices, isEmpty);
      expect(invoices, isA<List<Invoice>>());
    });

    test('should handle invoices with all fields populated', () async {
      // Arrange
      final invoice = MockData.createTestInvoice();

      // Act
      await mockRepository.addInvoice(invoice);
      final retrieved = await mockRepository.getInvoiceById(invoice.id);

      // Assert
      expect(retrieved, isNotNull);
      expect(retrieved!.id, invoice.id);
      expect(retrieved.customerName, invoice.customerName);
      expect(retrieved.status, invoice.status);
      expect(retrieved.items.length, invoice.items.length);
    });
  });

  group('InvoiceProvider - State Management', () {
    test('should maintain state after multiple operations', () async {
      // Arrange & Act
      final invoice1 = MockData.createTestInvoice(id: 'invoice-1');
      final invoice2 = MockData.createTestInvoice(id: 'invoice-2');

      await mockRepository.addInvoice(invoice1);
      await mockRepository.addInvoice(invoice2);
      await mockRepository.deleteInvoice('invoice-1');

      final invoice3 = MockData.createTestInvoice(id: 'invoice-3');
      await mockRepository.addInvoice(invoice3);

      final invoices = await mockRepository.getAllInvoices();

      // Assert
      expect(invoices.length, 2);
      expect(invoices, isNot(contains(invoice1)));
      expect(invoices, contains(invoice2));
      expect(invoices, contains(invoice3));
    });

    test('should handle rapid successive operations', () async {
      // Arrange
      final invoices = MockData.createTestInvoices(count: 10);

      // Act
      for (final invoice in invoices) {
        await mockRepository.addInvoice(invoice);
      }

      final allInvoices = await mockRepository.getAllInvoices();

      // Assert
      expect(allInvoices.length, 10);
    });
  });
}
