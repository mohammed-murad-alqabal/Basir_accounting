import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/mock_data.dart';
import '../../../../../mocks/mock_invoice_repository.dart';

class _NoopNotificationService extends NotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {}

  @override
  Future<void> cancelNotification(int id) async {}
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
          notificationServiceProvider.overrideWithValue(
            _NoopNotificationService(),
          ),
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

      test('should return false when the repository rejects an invoice',
          () async {
        mockRepository.shouldThrowError = true;
        final invoice = MockData.createTestInvoice(id: 'failed-inv');

        final result = await container.read(addInvoiceProvider(invoice).future);

        expect(result, isFalse);
        expect(mockRepository.invoices, isEmpty);
      });
    });

    group('invoiceFilterProvider', () {
      test('should have "all" as initial value', () {
        final filter = container.read(invoiceFilterProvider);
        expect(filter, 'all');
      });

      test('should normalize Arabic search terms and sort by amount', () async {
        final testInvoices = [
          MockData.createTestInvoice(
            id: 'invoice-1',
            invoiceNumber: 'INV-1',
            customerName: 'إدارة بصير',
            issuedDate: DateTime.utc(2026, 1, 2),
            itemPrice: Decimal.fromInt(80),
          ),
          MockData.createTestInvoice(
            id: 'invoice-2',
            invoiceNumber: 'INV-2',
            customerName: 'شركة ألف',
            issuedDate: DateTime.utc(2026),
            itemPrice: Decimal.fromInt(120),
            status: InvoiceStatus.paid,
          ),
          MockData.createTestInvoice(
            id: 'invoice-3',
            invoiceNumber: 'INV-3',
            customerName: 'شركة جيم',
            issuedDate: DateTime.utc(2026, 1, 3),
            itemPrice: Decimal.fromInt(20),
            status: InvoiceStatus.overdue,
          ),
        ];
        mockRepository.setInvoices(testInvoices);
        await container.read(invoicesProvider.future);

        container.read(invoiceSearchProvider.notifier).state = 'اداره';
        final normalized = container.read(filteredInvoicesProvider).value;
        expect(normalized, hasLength(1));
        expect(normalized!.single.id, 'invoice-1');

        container.read(invoiceSearchProvider.notifier).state = '';
        container.read(invoiceFilterProvider.notifier).state = 'paid';
        expect(
          container.read(filteredInvoicesProvider).value!.single.id,
          'invoice-2',
        );

        container.read(invoiceFilterProvider.notifier).state = 'all';
        container.read(invoiceSortProvider.notifier).state = 'amount_desc';
        expect(
          container
              .read(filteredInvoicesProvider)
              .value!
              .map((invoice) => invoice.id),
          ['invoice-2', 'invoice-1', 'invoice-3'],
        );
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

    group('invoice lifecycle actions', () {
      test('should return false for unknown invoices without posting entries',
          () async {
        expect(
          await container.read(markInvoiceAsPaidProvider('missing').future),
          isFalse,
        );
        expect(
          await container.read(sendInvoiceProvider('missing').future),
          isFalse,
        );
      });

      test('should cancel a known invoice and persist its new status',
          () async {
        final invoice = MockData.createTestInvoice(
          id: 'cancel-001',
          status: InvoiceStatus.sent,
        );
        mockRepository.setInvoices([invoice]);

        final cancelled = await container.read(
          cancelInvoiceProvider(invoice.id).future,
        );

        expect(cancelled, isTrue);
        expect(mockRepository.invoices.single.status, InvoiceStatus.cancelled);
      });

      test('should duplicate an existing invoice and refresh the collection',
          () async {
        final invoice = MockData.createTestInvoice(id: 'source-001');
        mockRepository.setInvoices([invoice]);

        final duplicate = await container.read(
          duplicateInvoiceProvider(invoice.id).future,
        );

        expect(duplicate.id, startsWith('copy_'));
        expect(duplicate.invoiceNumber, invoice.invoiceNumber);
        expect(mockRepository.invoices, hasLength(2));
      });
    });

    group('extended invoice lifecycle and derived data', () {
      test('filters every lifecycle state and derives totals and counts',
          () async {
        final invoices = [
          MockData.createTestInvoice(
            id: 'sent-001',
            customerName: 'شركة باء',
            issuedDate: DateTime.utc(2026, 1, 2),
            status: InvoiceStatus.sent,
            itemPrice: Decimal.fromInt(90),
          ),
          MockData.createTestInvoice(
            id: 'cancelled-001',
            customerName: 'شركة ألف',
            issuedDate: DateTime.utc(2026),
            status: InvoiceStatus.cancelled,
            itemPrice: Decimal.fromInt(40),
          ),
          MockData.createTestInvoice(
            id: 'refunded-001',
            customerName: 'شركة جيم',
            issuedDate: DateTime.utc(2026, 1, 3),
            status: InvoiceStatus.refunded,
            itemPrice: Decimal.fromInt(30),
          ),
          MockData.createTestInvoice(
            id: 'overdue-001',
            customerName: 'شركة دال',
            issuedDate: DateTime.utc(2026, 1, 4),
            status: InvoiceStatus.overdue,
            itemPrice: Decimal.fromInt(20),
          ),
        ];
        mockRepository.setInvoices(invoices);
        await container.read(invoicesProvider.future);

        for (final state in ['sent', 'cancelled', 'refunded', 'overdue']) {
          container.read(invoiceFilterProvider.notifier).state = state;
          expect(container.read(filteredInvoicesProvider).value, hasLength(1));
        }

        container.read(invoiceFilterProvider.notifier).state = 'all';
        container.read(invoiceSortProvider.notifier).state = 'oldest';
        expect(
          container.read(filteredInvoicesProvider).value!.first.id,
          'cancelled-001',
        );
        container.read(invoiceSortProvider.notifier).state = 'customer';
        expect(
          container.read(filteredInvoicesProvider).value!.first.customerName,
          'شركة ألف',
        );
        container.read(invoiceSortProvider.notifier).state = 'amount_asc';
        expect(
          container.read(filteredInvoicesProvider).value!.first.id,
          'overdue-001',
        );
        container.read(invoiceSortProvider.notifier).state = 'due_date';
        expect(container.read(filteredInvoicesProvider).value, hasLength(4));

        expect(
          container.read(totalSalesProvider).value,
          greaterThan(Decimal.zero),
        );
        expect(container.read(overdueInvoicesCountProvider).value, 1);
        expect(container.read(invoicesCountProvider).value, 4);
        expect(container.read(hasInvoicesProvider).value, isTrue);
        container.read(invoiceSearchProvider.notifier).state = '  إرسال  ';
        expect(container.read(searchQueryProvider), 'إرسال');
        expect(container.read(filterStatusProvider), 'all');
      });

      test('updates and deletes a draft invoice, returning false on failures',
          () async {
        final draft = MockData.createTestInvoice(
          id: 'draft-001',
          status: InvoiceStatus.draft,
        );
        mockRepository.setInvoices([draft]);

        final updated = draft.copyWith(customerName: 'العميل المعدل');
        expect(
          await container.read(updateInvoiceProvider(updated).future),
          isTrue,
        );
        expect(mockRepository.invoices.single.customerName, 'العميل المعدل');

        expect(
          await container.read(deleteInvoiceProvider(draft.id).future),
          isTrue,
        );
        expect(mockRepository.invoices, isEmpty);

        mockRepository.shouldThrowError = true;
        expect(
          await container.read(
            deleteInvoiceProvider('missing-failure').future,
          ),
          isFalse,
        );
      });
    });
  });
}
