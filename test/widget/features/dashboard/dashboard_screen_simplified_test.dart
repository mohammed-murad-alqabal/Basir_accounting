// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mock_accounting_repository.dart';
import '../../../mocks/mock_analytics_service.dart';
import '../../../mocks/mock_customer_repository.dart';
import '../../../mocks/mock_invoice_repository.dart';

void main() {
  group('DashboardScreen Simplified Tests', () {
    late MockInvoiceRepository mockInvoiceRepo;
    late MockCustomerRepository mockCustomerRepo;
    late MockAccountingRepository mockAccountingRepo;
    late MockAnalyticsService mockAnalyticsService;
    late ProviderContainer container;

    // Pre-computed test data
    late List<Invoice> testInvoices;
    late List<Customer> testCustomers;

    Invoice createTestInvoice(
      String id,
      String customerName,
      InvoiceStatus status,
      int amount,
      DateTime now,
    ) =>
        Invoice(
          id: id,
          invoiceNumber: id,
          customerId: 'c1',
          customerName: customerName,
          items: [
            InvoiceItem(
              taxRate: Decimal.parse('0.15'),
              id: 'i1',
              name: 'Test Item',
              quantity: Decimal.one,
              price: Decimal.fromInt(amount),
              total: Decimal.fromInt(amount),
              taxAmount: Decimal.zero,
            ),
          ],
          status: status,
          issuedDate: now,
          dueDate: status == InvoiceStatus.overdue
              ? now.subtract(const Duration(days: 1))
              : now.add(const Duration(days: 30)),
          createdAt: now,
          updatedAt: now,
          taxRate: Decimal.zero,
          subtotalAmount: Decimal.fromInt(amount),
          taxAmount: Decimal.zero,
          totalAmount: Decimal.fromInt(amount),
          paidAmount: status == InvoiceStatus.paid
              ? Decimal.fromInt(amount)
              : Decimal.zero,
          discountAmount: Decimal.zero,
          discountRate: Decimal.zero,
          exchangeRate: Decimal.one,
        );

    Customer createTestCustomer(String id, String name, DateTime now) =>
        Customer(
          id: id,
          nameAr: name,
          nameEn: name,
          phone: '050',
          createdAt: now,
          updatedAt: now,
        );

    setUpAll(() {
      final now = DateTime.now();
      testInvoices = [
        createTestInvoice('#001', 'أحمد محمد', InvoiceStatus.paid, 1500, now),
        createTestInvoice('#002', 'سارة علي', InvoiceStatus.sent, 2300, now),
        createTestInvoice(
          '#003',
          'محمود حسن',
          InvoiceStatus.overdue,
          1800,
          now,
        ),
      ];

      testCustomers = [
        createTestCustomer('c1', 'Customer 1', now),
        createTestCustomer('c2', 'Customer 2', now),
        createTestCustomer('c3', 'Customer 3', now),
      ];
    });

    setUp(() {
      mockInvoiceRepo = MockInvoiceRepository();
      mockCustomerRepo = MockCustomerRepository();
      mockAccountingRepo = MockAccountingRepository();
      mockAnalyticsService = MockAnalyticsService();

      mockInvoiceRepo.setInvoices(testInvoices);
      mockCustomerRepo.setCustomers(testCustomers);

      container = ProviderContainer(
        overrides: [
          invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
          customerRepositoryProvider.overrideWithValue(mockCustomerRepo),
          accountingRepositoryProvider.overrideWithValue(mockAccountingRepo),
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          analyticsServiceProvider.overrideWithValue(mockAnalyticsService),
          isGuestProvider.overrideWith((ref) => Stream.value(false)),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget() => ProviderScope(
          overrides: [
            invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
            customerRepositoryProvider.overrideWithValue(mockCustomerRepo),
            accountingRepositoryProvider.overrideWithValue(mockAccountingRepo),
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
            analyticsServiceProvider.overrideWithValue(mockAnalyticsService),
            isGuestProvider.overrideWith((ref) => Stream.value(false)),
          ],
          child: const MaterialApp(
            home: SimplifiedDashboardScreen(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ar'),
          ),
        );

    Future<void> setUpWidgets(WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 16));
    }

    testWidgets('should load dashboard data successfully', (tester) async {
      await setUpWidgets(tester);

      // Verify dashboard controller loads data
      final dashboardData =
          await container.read(dashboardControllerProvider.future);

      expect(dashboardData.totalInvoices, equals(3));
      expect(dashboardData.activeCustomersCount, equals(3));
      expect(dashboardData.paidInvoices, equals(1));
      expect(dashboardData.pendingInvoices, equals(1));
      expect(dashboardData.overdueInvoices, equals(1));
    });

    testWidgets('should display basic dashboard structure', (tester) async {
      await setUpWidgets(tester);

      // Verify basic structure exists
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should handle loading state', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for data to load
      await tester.pump(const Duration(milliseconds: 16));

      // Loading should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}

/// Simplified Dashboard Screen for testing
class SimplifiedDashboardScreen extends ConsumerWidget {
  const SimplifiedDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.dashboardTitle),
      ),
      body: dashboardAsync.when(
        data: (data) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.dashboardWelcomeMessage,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),

              // Statistics Section
              Text(
                context.l10n.dashboardStatsTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.l10n.statTotalSales),
                          Text('${data.totalSales}'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.l10n.statActiveCustomers),
                          Text('${data.activeCustomersCount}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quick Actions
              Text(
                context.l10n.dashboardQuickActionsTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              ElevatedButton(
                onPressed: () {},
                child: Text(context.l10n.actionAddInvoice),
              ),

              const SizedBox(height: 8),

              ElevatedButton(
                onPressed: () {},
                child: Text(context.l10n.actionAddCustomer),
              ),

              const SizedBox(height: 16),

              // Recent Activity
              Text(
                context.l10n.dashboardRecentActivityTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              if (data.recentInvoices.isEmpty)
                Text(context.l10n.msgNoActivity)
              else
                ...data.recentInvoices.map(
                  (invoice) => ListTile(
                    title: Text(context.l10n.invoiceTitle(invoice.id)),
                    subtitle: Text(invoice.customerName),
                    trailing: Text('${invoice.totalAmount}'),
                  ),
                ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error),
              Text('Error: $e'),
            ],
          ),
        ),
      ),
    );
  }
}
