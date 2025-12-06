import 'package:basser_app/core/providers.dart';
import 'package:basser_app/features/invoices/data/services/pdf_service.dart';
import 'package:basser_app/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/mock_data.dart';
import '../../../../../mocks/mock_invoice_repository.dart';

void main() {
  group('Invoice Providers Tests', () {
    late ProviderContainer container;
    late MockInvoiceRepository mockRepository;

    setUp(() {
      mockRepository = MockInvoiceRepository();

      container = ProviderContainer(
        overrides: [
          invoiceRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('pdfServiceProvider', () {
      test('should provide PdfService instance', () {
        // Act
        final pdfService = container.read(pdfServiceProvider);

        // Assert
        expect(pdfService, isA<PdfService>());
      });

      test('should provide same instance on multiple reads', () {
        // Act
        final service1 = container.read(pdfServiceProvider);
        final service2 = container.read(pdfServiceProvider);

        // Assert
        expect(service1, same(service2));
      });
    });

    group('invoicesProvider', () {
      test('should load all invoices successfully', () async {
        // Arrange
        final testInvoices = [
          MockData.createTestInvoice(id: 'inv-1'),
          MockData.createTestInvoice(id: 'inv-2'),
        ];
        mockRepository.setInvoices(testInvoices);

        // Act
        final invoices = await container.read(invoicesProvider.future);

        // Assert
        expect(invoices, testInvoices);
        expect(invoices.length, 2);
      });

      test('should return empty list when no invoices', () async {
        // Arrange
        mockRepository.setInvoices([]);

        // Act
        final invoices = await container.read(invoicesProvider.future);

        // Assert
        expect(invoices, isEmpty);
      });

      test('should handle errors', () async {
        // Arrange
        mockRepository.shouldThrowError = true;

        // Act & Assert
        expect(
          () => container.read(invoicesProvider.future),
          throwsException,
        );
      });
    });

    group('addInvoiceProvider', () {
      test('should add invoice successfully', () async {
        // Arrange
        final newInvoice = MockData.createTestInvoice(id: 'new-inv');

        // Act
        final result = await container.read(
          addInvoiceProvider(newInvoice).future,
        );

        // Assert
        expect(result, isTrue);
        expect(mockRepository.invoices, contains(newInvoice));
      });

      test('should return false on error', () async {
        // Arrange
        mockRepository.shouldThrowError = true;
        final newInvoice = MockData.createTestInvoice(id: 'new-inv');

        // Act
        final result = await container.read(
          addInvoiceProvider(newInvoice).future,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should invalidate invoicesProvider after adding', () async {
        // Arrange
        final newInvoice = MockData.createTestInvoice(id: 'new-inv');
        mockRepository.setInvoices([]);

        // Act
        await container.read(addInvoiceProvider(newInvoice).future);
        final invoices = await container.read(invoicesProvider.future);

        // Assert
        expect(invoices, contains(newInvoice));
      });
    });

    group('updateInvoiceProvider', () {
      test('should update invoice successfully', () async {
        // Arrange
        final originalInvoice = MockData.createTestInvoice(
          id: 'inv-1',
          status: 'draft',
        );
        mockRepository.setInvoices([originalInvoice]);

        final updatedInvoice = originalInvoice.copyWith(status: 'paid');

        // Act
        final result = await container.read(
          updateInvoiceProvider(updatedInvoice).future,
        );

        // Assert
        expect(result, isTrue);
        final invoice = mockRepository.invoices.firstWhere(
          (i) => i.id == 'inv-1',
        );
        expect(invoice.status, 'paid');
      });

      test('should return false on error', () async {
        // Arrange
        mockRepository.shouldThrowError = true;
        final invoice = MockData.createTestInvoice(id: 'inv-1');

        // Act
        final result = await container.read(
          updateInvoiceProvider(invoice).future,
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('deleteInvoiceProvider', () {
      test('should delete invoice successfully', () async {
        // Arrange
        final invoice = MockData.createTestInvoice(id: 'inv-1');
        mockRepository.setInvoices([invoice]);

        // Act
        final result = await container.read(
          deleteInvoiceProvider('inv-1').future,
        );

        // Assert
        expect(result, isTrue);
        expect(mockRepository.invoices, isEmpty);
      });

      test('should return false on error', () async {
        // Arrange
        mockRepository.shouldThrowError = true;

        // Act
        final result = await container.read(
          deleteInvoiceProvider('inv-1').future,
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('invoiceSearchProvider', () {
      test('should have empty string as initial value', () {
        // Act
        final searchQuery = container.read(invoiceSearchProvider);

        // Assert
        expect(searchQuery, '');
      });

      test('should update search query', () {
        // Act
        container.read(invoiceSearchProvider.notifier).state = 'test';
        final searchQuery = container.read(invoiceSearchProvider);

        // Assert
        expect(searchQuery, 'test');
      });
    });

    group('invoiceFilterProvider', () {
      test('should have "الكل" as initial value', () {
        // Act
        final filter = container.read(invoiceFilterProvider);

        // Assert
        expect(filter, 'الكل');
      });

      test('should update filter status', () {
        // Act
        container.read(invoiceFilterProvider.notifier).state = 'paid';
        final filter = container.read(invoiceFilterProvider);

        // Assert
        expect(filter, 'paid');
      });
    });

    group('filteredInvoicesProvider', () {
      test('should return all invoices when no filter', () async {
        // Arrange
        final testInvoices = [
          MockData.createTestInvoice(id: 'inv-1', status: 'draft'),
          MockData.createTestInvoice(id: 'inv-2', status: 'paid'),
        ];
        mockRepository.setInvoices(testInvoices);

        // Act - انتظر حتى يكتمل loading
        await container.read(invoicesProvider.future);
        final filtered = container.read(filteredInvoicesProvider);

        // Assert
        expect(
          filtered.when(
            data: (invoices) => invoices.length,
            loading: () => 0,
            error: (_, __) => 0,
          ),
          2,
        );
      });

      test('should filter by status', () async {
        // Arrange
        final testInvoices = [
          MockData.createTestInvoice(id: 'inv-1', status: 'draft'),
          MockData.createTestInvoice(id: 'inv-2', status: 'paid'),
          MockData.createTestInvoice(id: 'inv-3', status: 'paid'),
        ];
        mockRepository.setInvoices(testInvoices);
        container.read(invoiceFilterProvider.notifier).state = 'paid';

        // Act - انتظر حتى يكتمل loading
        await container.read(invoicesProvider.future);
        final filtered = container.read(filteredInvoicesProvider);

        // Assert
        expect(
          filtered.when(
            data: (invoices) => invoices.length,
            loading: () => 0,
            error: (_, __) => 0,
          ),
          2,
        );
      });

      test('should filter by search query', () async {
        // Arrange
        final testInvoices = [
          MockData.createTestInvoice(id: 'inv-001', customerName: 'أحمد'),
          MockData.createTestInvoice(id: 'inv-002', customerName: 'محمد'),
        ];
        mockRepository.setInvoices(testInvoices);
        container.read(invoiceSearchProvider.notifier).state = 'أحمد';

        // Act - انتظر حتى يكتمل loading
        await container.read(invoicesProvider.future);
        final filtered = container.read(filteredInvoicesProvider);

        // Assert
        expect(
          filtered.when(
            data: (invoices) => invoices.length,
            loading: () => 0,
            error: (_, __) => 0,
          ),
          1,
        );
      });

      test('should filter by both status and search', () async {
        // Arrange
        final testInvoices = [
          MockData.createTestInvoice(
            id: 'inv-001',
            customerName: 'أحمد',
            status: 'paid',
          ),
          MockData.createTestInvoice(
            id: 'inv-002',
            customerName: 'أحمد',
            status: 'draft',
          ),
          MockData.createTestInvoice(
            id: 'inv-003',
            customerName: 'محمد',
            status: 'paid',
          ),
        ];
        mockRepository.setInvoices(testInvoices);
        container.read(invoiceFilterProvider.notifier).state = 'paid';
        container.read(invoiceSearchProvider.notifier).state = 'أحمد';

        // Act - انتظر حتى يكتمل loading
        await container.read(invoicesProvider.future);
        final filtered = container.read(filteredInvoicesProvider);

        // Assert
        expect(
          filtered.when(
            data: (invoices) => invoices.length,
            loading: () => 0,
            error: (_, __) => 0,
          ),
          1,
        );
      });
    });

    group('totalSalesProvider', () {
      test('should calculate total sales correctly', () async {
        // Arrange
        final testInvoices = [
          MockData.createTestInvoice(
            id: 'inv-1',
            itemPrice: 869.57,
          ), // 1000 total
          MockData.createTestInvoice(
            id: 'inv-2',
            itemPrice: 1739.13,
          ), // 2000 total
          MockData.createTestInvoice(
            id: 'inv-3',
            itemPrice: 1304.35,
          ), // 1500 total
        ];
        mockRepository.setInvoices(testInvoices);

        // Act - انتظر حتى يكتمل loading
        await container.read(invoicesProvider.future);
        final totalSales = container.read(totalSalesProvider);

        // Assert
        expect(
          totalSales.when(
            data: (total) => total,
            loading: () => 0.0,
            error: (_, __) => 0.0,
          ),
          greaterThan(4400.0), // ~4500 مع هامش للتقريب
        );
      });

      test('should return 0 when no invoices', () async {
        // Arrange
        mockRepository.setInvoices([]);

        // Act
        final totalSales = container.read(totalSalesProvider);

        // Assert
        await expectLater(
          totalSales.when(
            data: (total) => total,
            loading: () => 0.0,
            error: (_, __) => 0.0,
          ),
          0.0,
        );
      });
    });

    group('overdueInvoicesCountProvider', () {
      test('should count overdue invoices correctly', () async {
        // Arrange
        final testInvoices = [
          MockData.createTestInvoice(id: 'inv-1', status: 'overdue'),
          MockData.createTestInvoice(id: 'inv-2', status: 'paid'),
          MockData.createTestInvoice(id: 'inv-3', status: 'overdue'),
          MockData.createTestInvoice(id: 'inv-4', status: 'draft'),
        ];
        mockRepository.setInvoices(testInvoices);

        // Act - انتظر حتى يكتمل loading
        await container.read(invoicesProvider.future);
        final overdueCount = container.read(overdueInvoicesCountProvider);

        // Assert
        expect(
          overdueCount.when(
            data: (count) => count,
            loading: () => 0,
            error: (_, __) => 0,
          ),
          2,
        );
      });

      test('should return 0 when no overdue invoices', () async {
        // Arrange
        final testInvoices = [
          MockData.createTestInvoice(id: 'inv-1', status: 'paid'),
          MockData.createTestInvoice(id: 'inv-2', status: 'draft'),
        ];
        mockRepository.setInvoices(testInvoices);

        // Act
        final overdueCount = container.read(overdueInvoicesCountProvider);

        // Assert
        await expectLater(
          overdueCount.when(
            data: (count) => count,
            loading: () => 0,
            error: (_, __) => 0,
          ),
          0,
        );
      });
    });
  });
}
