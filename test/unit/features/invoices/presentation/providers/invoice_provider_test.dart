import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/mock_data.dart';
import '../../../../../mocks/mock_invoice_repository.dart';

class TestNotificationService extends NotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {}

  @override
  Future<void> cancelNotification(int id) async {}

  @override
  Future<void> cancelAll() async {}
}

void main() {
  group('Invoice Providers Tests', () {
    late ProviderContainer container;
    late MockInvoiceRepository mockRepository;

    setUp(() {
      mockRepository = MockInvoiceRepository();

      container = ProviderContainer(
        overrides: [
          invoiceRepositoryProvider.overrideWithValue(mockRepository),
          notificationServiceProvider.overrideWithValue(TestNotificationService()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('invoicesProvider', () {
      test('should load all invoices successfully', () async {
        final testInvoices = [
          MockData.createTestInvoice(id: 'inv-1'),
          MockData.createTestInvoice(id: 'inv-2'),
        ];
        mockRepository.setInvoices(testInvoices);

        final invoices = await container.read(invoicesProvider.future);

        expect(invoices, testInvoices);
        expect(invoices.length, 2);
      });

      test('should return empty list when no invoices', () async {
        mockRepository.setInvoices([]);
        final invoices = await container.read(invoicesProvider.future);
        expect(invoices, isEmpty);
      });

      test('should handle errors', () async {
        mockRepository.shouldThrowError = true;
        expect(() => container.read(invoicesProvider.future), throwsException);
      });
    });

    group('addInvoiceProvider', () {
      test('should add invoice successfully', () async {
        final newInvoice = MockData.createTestInvoice(id: 'new-inv');
        final result = await container.read(
          addInvoiceProvider(newInvoice).future,
        );
        expect(result, isTrue);
        expect(mockRepository.invoices, contains(newInvoice));
      });
    });

    group('invoiceFilterProvider', () {
      test('should have "all" as initial value', () {
        final filter = container.read(invoiceFilterProvider);
        expect(filter, 'all');
      });
    });

    group('invoiceStatisticsProvider', () {
      test('should calculate statistics correctly', () async {
        // Arrange
        final testInvoices = [
          MockData.createTestInvoice(
            id: 'inv-1',
            status: InvoiceStatus.paid,
            itemPrice: Decimal.fromInt(1000),
          ),
          MockData.createTestInvoice(
            id: 'inv-2',
            status: InvoiceStatus.overdue,
            itemPrice: Decimal.fromInt(500),
          ),
          MockData.createTestInvoice(
            id: 'inv-3',
            status: InvoiceStatus.draft,
            itemPrice: Decimal.fromInt(200),
          ),
        ];
        mockRepository.setInvoices(testInvoices);

        // Act
        await container.read(invoicesProvider.future);
        final statsAsync = container.read(invoiceStatisticsProvider);

        // Assert
        statsAsync.whenData((stats) {
          expect(stats.totalInvoices, 3);
          expect(stats.paidInvoices, 1);
          expect(stats.overdueInvoices, 1);
          expect(stats.totalAmount, greaterThan(Decimal.fromInt(1700)));
        });
      });

      test('should return 0 stats for empty list', () async {
        mockRepository.setInvoices([]);
        await container.read(invoicesProvider.future);
        final statsAsync = container.read(invoiceStatisticsProvider);

        statsAsync.whenData((stats) {
          expect(stats.totalInvoices, 0);
          expect(stats.paidInvoices, 0);
          expect(stats.totalAmount, Decimal.zero);
        });
      });
    });
  });
}
