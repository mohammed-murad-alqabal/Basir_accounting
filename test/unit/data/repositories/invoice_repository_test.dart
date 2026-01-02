/// اختبارات InvoiceRepository
///
/// يختبر جميع عمليات CRUD والبحث في مستودع الفواتير
library;

import 'package:basir_app/features/invoices/data/models/invoice_model.dart';
import 'package:basir_app/features/invoices/data/repositories/invoice_repository_impl.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../../helpers/mock_data.dart';

void main() {
  late Isar isar;
  late InvoiceRepositoryImpl repository;

  setUp(() async {
    // إنشاء قاعدة بيانات Isar في الذاكرة للاختبار
    isar = await Isar.open(
      [InvoiceModelSchema],
      directory: '',
      name: 'test_invoice_${DateTime.now().millisecondsSinceEpoch}',
    );
    repository = InvoiceRepositoryImpl(isar: isar);
  });

  tearDown(() async {
    // تنظيف قاعدة البيانات بعد كل اختبار
    await isar.close(deleteFromDisk: true);
  });

  group('InvoiceRepository', () {
    group('addInvoice', () {
      test('should add invoice successfully', () async {
        // Arrange
        final invoice = MockData.createTestInvoice(
          id: 'test-invoice-1',
          customerId: 'customer-1',
          customerName: 'عميل اختبار',
        );

        // Act
        await repository.addInvoice(invoice);

        // Assert
        final invoices = await repository.getAllInvoices();
        expect(invoices.length, 1);
        expect(invoices.first.id, 'test-invoice-1');
        expect(invoices.first.customerName, 'عميل اختبار');
      });

      test('should add multiple invoices successfully', () async {
        // Arrange
        final invoice1 = MockData.createTestInvoice(
          id: 'invoice-1',
          customerId: 'customer-1',
        );
        final invoice2 = MockData.createTestInvoice(
          id: 'invoice-2',
          customerId: 'customer-2',
        );

        // Act
        await repository.addInvoice(invoice1);
        await repository.addInvoice(invoice2);

        // Assert
        final invoices = await repository.getAllInvoices();
        expect(invoices.length, 2);
      });

      test('should preserve all invoice data', () async {
        // Arrange
        final invoice = Invoice(
          id: 'test-invoice',
          customerId: 'customer-1',
          customerName: 'أحمد محمد',
          issuedDate: DateTime(2025, 11),
          dueDate: DateTime(2025, 12),
          status: 'draft',
          items: const [
            InvoiceItem(
              id: 'item-1',
              name: 'خدمة استشارية',
              quantity: 2,
              price: 500,
            ),
          ],
          taxRate: 0.15,
          createdAt: DateTime(2025, 11),
          updatedAt: DateTime(2025, 11),
        );

        // Act
        await repository.addInvoice(invoice);

        // Assert
        final foundInvoice = await repository.getInvoiceById('test-invoice');
        expect(foundInvoice, isNotNull);
        expect(foundInvoice!.customerName, 'أحمد محمد');
        expect(foundInvoice.status, 'draft');
        expect(foundInvoice.items.length, 1);
        expect(foundInvoice.items.first.name, 'خدمة استشارية');
        expect(foundInvoice.taxRate, 0.15);
      });
    });

    group('getAllInvoices', () {
      test('should return empty list when no invoices exist', () async {
        // Act
        final invoices = await repository.getAllInvoices();

        // Assert
        expect(invoices, isEmpty);
      });

      test('should return all invoices', () async {
        // Arrange
        final invoice1 = MockData.createTestInvoice(id: 'invoice-1');
        final invoice2 = MockData.createTestInvoice(id: 'invoice-2');
        final invoice3 = MockData.createTestInvoice(id: 'invoice-3');

        await repository.addInvoice(invoice1);
        await repository.addInvoice(invoice2);
        await repository.addInvoice(invoice3);

        // Act
        final invoices = await repository.getAllInvoices();

        // Assert
        expect(invoices.length, 3);
      });
    });

    group('getInvoiceById', () {
      test('should return invoice when exists', () async {
        // Arrange
        final invoice = MockData.createTestInvoice(
          id: 'test-invoice',
          customerName: 'عميل مميز',
        );
        await repository.addInvoice(invoice);

        // Act
        final foundInvoice = await repository.getInvoiceById('test-invoice');

        // Assert
        expect(foundInvoice, isNotNull);
        expect(foundInvoice!.id, 'test-invoice');
        expect(foundInvoice.customerName, 'عميل مميز');
      });

      test('should return null when invoice does not exist', () async {
        // Act
        final foundInvoice = await repository.getInvoiceById(
          'non-existent-invoice',
        );

        // Assert
        expect(foundInvoice, isNull);
      });

      test('should return correct invoice among multiple', () async {
        // Arrange
        final invoice1 = MockData.createTestInvoice(
          id: 'invoice-1',
          customerName: 'عميل 1',
        );
        final invoice2 = MockData.createTestInvoice(
          id: 'invoice-2',
          customerName: 'عميل 2',
        );
        final invoice3 = MockData.createTestInvoice(
          id: 'invoice-3',
          customerName: 'عميل 3',
        );

        await repository.addInvoice(invoice1);
        await repository.addInvoice(invoice2);
        await repository.addInvoice(invoice3);

        // Act
        final foundInvoice = await repository.getInvoiceById('invoice-2');

        // Assert
        expect(foundInvoice, isNotNull);
        expect(foundInvoice!.id, 'invoice-2');
        expect(foundInvoice.customerName, 'عميل 2');
      });
    });

    group('getInvoicesByCustomerId', () {
      test('should return invoices for specific customer', () async {
        // Arrange
        final invoice1 = MockData.createTestInvoice(
          id: 'invoice-1',
          customerId: 'customer-1',
        );
        final invoice2 = MockData.createTestInvoice(
          id: 'invoice-2',
          customerId: 'customer-1',
        );
        final invoice3 = MockData.createTestInvoice(
          id: 'invoice-3',
          customerId: 'customer-2',
        );

        await repository.addInvoice(invoice1);
        await repository.addInvoice(invoice2);
        await repository.addInvoice(invoice3);

        // Act
        final customerInvoices = await repository.getInvoicesByCustomerId(
          'customer-1',
        );

        // Assert
        expect(customerInvoices.length, 2);
        expect(
          customerInvoices.every((i) => i.customerId == 'customer-1'),
          isTrue,
        );
      });

      test('should return empty list when customer has no invoices', () async {
        // Arrange
        final invoice = MockData.createTestInvoice(customerId: 'customer-1');
        await repository.addInvoice(invoice);

        // Act
        final customerInvoices = await repository.getInvoicesByCustomerId(
          'customer-2',
        );

        // Assert
        expect(customerInvoices, isEmpty);
      });
    });

    group('getInvoicesByStatus', () {
      test('should return invoices with specific status', () async {
        // Arrange
        final invoice1 = MockData.createTestInvoice(
          id: 'invoice-1',
          status: 'draft',
        );
        final invoice2 = MockData.createTestInvoice(
          id: 'invoice-2',
          status: 'paid',
        );
        final invoice3 = MockData.createTestInvoice(
          id: 'invoice-3',
          status: 'draft',
        );

        await repository.addInvoice(invoice1);
        await repository.addInvoice(invoice2);
        await repository.addInvoice(invoice3);

        // Act
        final draftInvoices = await repository.getInvoicesByStatus('draft');

        // Assert
        expect(draftInvoices.length, 2);
        expect(draftInvoices.every((i) => i.status == 'draft'), isTrue);
      });

      test('should return empty list when no invoices with status', () async {
        // Arrange
        final invoice = MockData.createTestInvoice(status: 'draft');
        await repository.addInvoice(invoice);

        // Act
        final paidInvoices = await repository.getInvoicesByStatus('paid');

        // Assert
        expect(paidInvoices, isEmpty);
      });
    });

    group('updateInvoice', () {
      test('should update invoice successfully', () async {
        // Arrange
        final invoice = MockData.createTestInvoice(
          id: 'test-invoice',
          status: 'draft',
        );
        await repository.addInvoice(invoice);

        // Act
        final updatedInvoice = invoice.copyWith(
          status: 'paid',
          updatedAt: DateTime.now(),
        );
        await repository.updateInvoice(updatedInvoice);

        // Assert
        final foundInvoice = await repository.getInvoiceById('test-invoice');
        expect(foundInvoice?.status, 'paid');
      });

      test('should update only specified fields', () async {
        // Arrange
        final invoice = Invoice(
          id: 'test-invoice',
          customerId: 'customer-1',
          customerName: 'عميل أصلي',
          issuedDate: DateTime(2025, 11),
          dueDate: DateTime(2025, 12),
          status: 'draft',
          items: const [
            InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 1, price: 1000),
          ],
          taxRate: 0.15,
          createdAt: DateTime(2025, 11),
          updatedAt: DateTime(2025, 11),
        );
        await repository.addInvoice(invoice);

        // Act - تحديث الحالة فقط
        final updatedInvoice = invoice.copyWith(status: 'paid');
        await repository.updateInvoice(updatedInvoice);

        // Assert
        final foundInvoice = await repository.getInvoiceById('test-invoice');
        expect(foundInvoice?.status, 'paid');
        expect(foundInvoice?.customerName, 'عميل أصلي'); // لم يتغير
        expect(foundInvoice?.taxRate, 0.15); // لم يتغير
      });
    });

    group('deleteInvoice', () {
      test('should delete invoice successfully', () async {
        // Arrange
        final invoice = MockData.createTestInvoice(id: 'test-invoice');
        await repository.addInvoice(invoice);

        // Act
        await repository.deleteInvoice('test-invoice');

        // Assert
        final invoices = await repository.getAllInvoices();
        expect(invoices, isEmpty);
      });

      test('should not affect other invoices when deleting', () async {
        // Arrange
        final invoice1 = MockData.createTestInvoice(id: 'invoice-1');
        final invoice2 = MockData.createTestInvoice(id: 'invoice-2');
        await repository.addInvoice(invoice1);
        await repository.addInvoice(invoice2);

        // Act
        await repository.deleteInvoice('invoice-1');

        // Assert
        final invoices = await repository.getAllInvoices();
        expect(invoices.length, 1);
        expect(invoices.first.id, 'invoice-2');
      });

      test('should handle deleting non-existent invoice gracefully', () async {
        // Act & Assert - لا يجب أن يرمي خطأ
        await repository.deleteInvoice('non-existent-invoice');

        final invoices = await repository.getAllInvoices();
        expect(invoices, isEmpty);
      });
    });

    group('deleteAllInvoices', () {
      test('should delete all invoices', () async {
        // Arrange
        final invoice1 = MockData.createTestInvoice(id: 'invoice-1');
        final invoice2 = MockData.createTestInvoice(id: 'invoice-2');
        final invoice3 = MockData.createTestInvoice(id: 'invoice-3');

        await repository.addInvoice(invoice1);
        await repository.addInvoice(invoice2);
        await repository.addInvoice(invoice3);

        // Act
        await repository.deleteAllInvoices();

        // Assert
        final invoices = await repository.getAllInvoices();
        expect(invoices, isEmpty);
      });
    });

    group('getInvoiceStatistics', () {
      test('should calculate statistics correctly', () async {
        // Arrange
        final invoice1 = Invoice(
          id: 'invoice-1',
          customerId: 'customer-1',
          customerName: 'عميل 1',
          issuedDate: DateTime.now(),
          dueDate: DateTime.now(),
          status: 'paid',
          items: const [
            InvoiceItem(id: 'item-1', name: 'خدمة', quantity: 1, price: 1000),
          ],
          taxRate: 0.15,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final invoice2 = Invoice(
          id: 'invoice-2',
          customerId: 'customer-2',
          customerName: 'عميل 2',
          issuedDate: DateTime.now(),
          dueDate: DateTime.now(),
          status: 'overdue',
          items: const [
            InvoiceItem(id: 'item-2', name: 'خدمة', quantity: 1, price: 2000),
          ],
          taxRate: 0.15,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await repository.addInvoice(invoice1);
        await repository.addInvoice(invoice2);

        // Act
        final stats = await repository.getInvoiceStatistics();

        // Assert
        expect(stats.totalInvoices, 2);
        expect(stats.paidInvoices, 1);
        expect(stats.overdueInvoices, 1);
        expect(stats.totalRevenue, 1150 + 2300); // مع الضريبة
        expect(stats.paidRevenue, 1150); // فاتورة واحدة مدفوعة
      });

      test('should return zero statistics when no invoices', () async {
        // Act
        final stats = await repository.getInvoiceStatistics();

        // Assert
        expect(stats.totalInvoices, 0);
        expect(stats.paidInvoices, 0);
        expect(stats.overdueInvoices, 0);
        expect(stats.totalRevenue, 0);
        expect(stats.paidRevenue, 0);
      });
    });
  });
}
