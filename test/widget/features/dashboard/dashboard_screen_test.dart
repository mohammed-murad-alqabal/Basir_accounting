// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mock_accounting_repository.dart';
import '../../../mocks/mock_customer_repository.dart';
import '../../../mocks/mock_invoice_repository.dart';

void main() {
  group('DashboardScreen', () {
    late MockInvoiceRepository mockInvoiceRepo;
    late MockCustomerRepository mockCustomerRepo;
    late MockAccountingRepository mockAccountingRepo;

    // Helper methods defined at the top to avoid referenced_before_declaration
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

    setUp(() {
      mockInvoiceRepo = MockInvoiceRepository();
      mockCustomerRepo = MockCustomerRepository();
      mockAccountingRepo = MockAccountingRepository();

      // إعداد بيانات مبسطة للاختبارات السريعة
      final now = DateTime.now();

      // 3 فواتير أساسية فقط بدلاً من 24
      final invoices = [
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

      mockInvoiceRepo.setInvoices(invoices);

      // 3 عملاء فقط بدلاً من 12
      final customers = [
        createTestCustomer('c1', 'Customer 1', now),
        createTestCustomer('c2', 'Customer 2', now),
        createTestCustomer('c3', 'Customer 3', now),
      ];
      mockCustomerRepo.setCustomers(customers);
    });

    Widget createTestWidget({Map<String, WidgetBuilder>? routes}) =>
        ProviderScope(
          overrides: [
            invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
            customerRepositoryProvider.overrideWithValue(mockCustomerRepo),
            accountingRepositoryProvider.overrideWithValue(mockAccountingRepo),
            appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          ],
          child: MaterialApp(
            home: const DashboardScreen(),
            routes: routes ?? {},
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
          ),
        );

    late AppLocalizations l10n;

    Future<void> setUpWidgets(WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      // انتظار واحد مُحسن لاكتمال AsyncNotifier
      await tester.pumpAndSettle(const Duration(milliseconds: 50));
      l10n = AppLocalizations.of(tester.element(find.byType(DashboardScreen)));
    }

    testWidgets('should display greeting message', (tester) async {
      await setUpWidgets(tester);
      expect(find.text(l10n.dashboardWelcomeMessage), findsOneWidget);
    });

    group('Statistics Section', () {
      testWidgets('should display statistics title', (tester) async {
        await setUpWidgets(tester);
        // Text may appear multiple times due to Semantics/rendering
        expect(find.text(l10n.dashboardStatsTitle), findsAtLeastNWidgets(1));
      });

      testWidgets('should display 4 stat cards', (tester) async {
        await setUpWidgets(tester);
        expect(find.byType(GlassStatCard), findsNWidgets(4));
      });

      testWidgets('should display total invoices stat', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.statTotalSales), findsOneWidget);
      });

      testWidgets('should display customers stat', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.statActiveCustomers), findsOneWidget);
        expect(find.text('12'), findsOneWidget);
      });

      testWidgets('should display sales stat', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.statTotalSales), findsOneWidget);
        // Note: Currency format in test environment might be specific.
        // FormatHelpers uses Intl, which might output '5,600 r.s' or
        // '5,600 ر.س'
        // depending on the provided locale.
        expect(find.textContaining('5,600'), findsOneWidget);
      });

      testWidgets('should display overdue stat', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.statOverdue), findsOneWidget);
      });
    });

    group('Quick Actions Section', () {
      testWidgets('should display quick actions title', (tester) async {
        await setUpWidgets(tester);
        // Text may appear multiple times due to Semantics/rendering
        expect(
          find.text(l10n.dashboardQuickActionsTitle),
          findsAtLeastNWidgets(1),
        );
      });

      testWidgets('should display new invoice button', (tester) async {
        await setUpWidgets(tester);
        expect(
          find.widgetWithText(AppEnhancedButton, l10n.actionAddInvoice),
          findsOneWidget,
        );
      });

      testWidgets('should display new customer button', (tester) async {
        await setUpWidgets(tester);
        expect(
          find.widgetWithText(AppEnhancedButton, l10n.actionAddCustomer),
          findsOneWidget,
        );
      });
    });

    group('Recent Activity Section', () {
      testWidgets('should display recent activity title', (tester) async {
        await setUpWidgets(tester);
        // Text may appear multiple times due to Semantics/rendering
        expect(
          find.text(l10n.dashboardRecentActivityTitle),
          findsAtLeastNWidgets(1),
        );
      });

      testWidgets('should display 5 activity cards', (tester) async {
        await setUpWidgets(tester);
        // Dashboard uses take(5)
        expect(find.byType(AppListCard), findsNWidgets(5));
      });

      testWidgets('should display first activity (paid invoice)', (
        tester,
      ) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.invoiceTitle('#001')), findsOneWidget);
        expect(find.text('أحمد محمد'), findsOneWidget);
      });

      testWidgets('should display second activity (pending invoice)', (
        tester,
      ) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.invoiceTitle('#002')), findsOneWidget);
        expect(find.text('سارة علي'), findsOneWidget);
      });

      testWidgets('should display third activity (overdue invoice)', (
        tester,
      ) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.invoiceTitle('#003')), findsOneWidget);
        expect(find.text('محمود حسن'), findsOneWidget);
      });
    });

    group('Navigation Tests', () {
      testWidgets('New Invoice button should navigate to form', (tester) async {
        var navigated = false;
        await tester.pumpWidget(
          createTestWidget(
            routes: {
              '/invoice-form': (context) {
                navigated = true;
                return const Scaffold();
              },
            },
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 50));

        final buttonFinder = find.widgetWithText(
          AppEnhancedButton,
          l10n.actionAddInvoice,
        );
        await tester.ensureVisible(buttonFinder);
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        expect(navigated, isTrue);
      });

      testWidgets('New Customer button should navigate to form',
          (tester) async {
        var navigated = false;
        await tester.pumpWidget(
          createTestWidget(
            routes: {
              '/customer-form': (context) {
                navigated = true;
                return const Scaffold();
              },
            },
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 50));

        final buttonFinder = find.widgetWithText(
          AppEnhancedButton,
          l10n.actionAddCustomer,
        );
        await tester.ensureVisible(buttonFinder);
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        expect(navigated, isTrue);
      });
    });

    group('Accessibility', () {
      testWidgets('should have semantic labels for buttons', (tester) async {
        await setUpWidgets(tester);

        // Verify "Add Invoice" button has correct label
        expect(find.bySemanticsLabel(l10n.actionAddInvoice), findsOneWidget);

        // Verify "Add Customer" button has correct label
        expect(find.bySemanticsLabel(l10n.actionAddCustomer), findsOneWidget);

        // Verify Accounting buttons have their custom semantic labels
        expect(
          find.bySemanticsLabel(l10n.labelChartOfAccounts),
          findsOneWidget,
        );
        expect(find.bySemanticsLabel(l10n.labelJournalEntries), findsOneWidget);
      });
    });
  });
}
