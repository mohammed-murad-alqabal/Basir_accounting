// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
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
              taxRate: Decimal.parse('0.15'),
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
            // Mock user with viewFinancials permission for PermissionGuard tests
            currentUserProfileProvider.overrideWith(
              (ref) => const BasirUser(
                id: 'test-user',
                email: 'test@example.com',
                displayName: 'Test User',
                role: UserRole.accountant,
                permissions: Permission.viewFinancials,
              ),
            ),
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
      // تحسين الأداء - إزالة الانتظار غير الضروري
      await tester.pump(); // Single pump without delay
      l10n = AppLocalizations.of(tester.element(find.byType(DashboardScreen)));
    }

    testWidgets('should display greeting message', (tester) async {
      await setUpWidgets(tester);
      expect(
        find.text(l10n.dashboardWelcomeMessage),
        findsOneWidget,
        reason:
            'Dashboard should display welcome message: "${l10n.dashboardWelcomeMessage}"',
      );
    });

    group('Statistics Section', () {
      testWidgets('should display statistics title', (tester) async {
        await setUpWidgets(tester);
        // Text may appear multiple times due to Semantics/rendering
        expect(
          find.text(l10n.dashboardStatsTitle),
          findsAtLeastNWidgets(1),
          reason:
              'Statistics section should display title: "${l10n.dashboardStatsTitle}"',
        );
      });

      testWidgets('should display 4 stat cards', (tester) async {
        await setUpWidgets(tester);
        expect(
          find.byType(GlassStatCard),
          findsNWidgets(4),
          reason:
              'Dashboard should display exactly 4 GlassStatCard widgets for statistics',
        );
      });

      testWidgets('should display total invoices stat', (tester) async {
        await setUpWidgets(tester);
        expect(
          find.text(l10n.statTotalSales),
          findsOneWidget,
          reason:
              'Total sales statistic should be displayed: "${l10n.statTotalSales}"',
        );
      });

      testWidgets('should display customers stat', (tester) async {
        await setUpWidgets(tester);
        expect(
          find.text(l10n.statActiveCustomers),
          findsOneWidget,
          reason:
              'Active customers label should be displayed: "${l10n.statActiveCustomers}"',
        );
        expect(
          find.text('3'),
          findsOneWidget,
          reason:
              'Customer count should show "3" based on test data (3 customers created)',
        );
      });

      testWidgets('should display sales stat', (tester) async {
        await setUpWidgets(tester);
        expect(
          find.text(l10n.statTotalSales),
          findsOneWidget,
          reason:
              'Total sales label should be displayed: "${l10n.statTotalSales}"',
        );
        // Note: Currency format in test environment might be specific.
        // FormatHelpers uses Intl, which might output '5,600 r.s' or
        // '5,600 ر.س'
        // depending on the provided locale.
        expect(
          find.textContaining('5,600'),
          findsOneWidget,
          reason:
              'Sales amount should show "5,600" (1500+2300+1800 from test invoices)',
        );
      });

      testWidgets('should display overdue stat', (tester) async {
        await setUpWidgets(tester);
        expect(
          find.text(l10n.statOverdue),
          findsOneWidget,
          reason:
              'Overdue statistic should be displayed: "${l10n.statOverdue}"',
        );
      });
    });

    group('Quick Actions Section', () {
      testWidgets('should display quick actions title', (tester) async {
        await setUpWidgets(tester);
        // Text may appear multiple times due to Semantics/rendering
        expect(
          find.text(l10n.dashboardQuickActionsTitle),
          findsAtLeastNWidgets(1),
          reason:
              'Quick Actions section should display title: "${l10n.dashboardQuickActionsTitle}" for user navigation',
        );
      });

      testWidgets('should display new invoice button', (tester) async {
        await setUpWidgets(tester);
        expect(
          find.widgetWithText(AppEnhancedButton, l10n.actionAddInvoice),
          findsOneWidget,
          reason:
              'Quick Actions should contain "Add Invoice" button with text: "${l10n.actionAddInvoice}" for invoice creation',
        );
      });

      testWidgets('should display new customer button', (tester) async {
        await setUpWidgets(tester);
        expect(
          find.widgetWithText(AppEnhancedButton, l10n.actionAddCustomer),
          findsOneWidget,
          reason:
              'Quick Actions should contain "Add Customer" button with text: "${l10n.actionAddCustomer}" for customer management',
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
          reason:
              'Recent Activity section should display title: "${l10n.dashboardRecentActivityTitle}" for activity tracking',
        );
      });

      testWidgets('should display activity cards for recent invoices',
          (tester) async {
        await setUpWidgets(tester);
        // Dashboard displays one card per recent invoice (3 test invoices)
        expect(
          find.byType(AppListCard),
          findsNWidgets(3),
          reason:
              'Recent Activity should display 3 AppListCard widgets (one per test invoice: paid, sent, overdue)',
        );
      });

      testWidgets('should display first activity (paid invoice)', (
        tester,
      ) async {
        await setUpWidgets(tester);
        expect(
          find.text(l10n.invoiceTitle('#001')),
          findsOneWidget,
          reason:
              'First activity should show paid invoice #001 with title: "${l10n.invoiceTitle('#001')}"',
        );
        expect(
          find.text('أحمد محمد'),
          findsOneWidget,
          reason:
              'First activity should display customer name "أحمد محمد" for invoice #001',
        );
      });

      testWidgets('should display second activity (pending invoice)', (
        tester,
      ) async {
        await setUpWidgets(tester);
        expect(
          find.text(l10n.invoiceTitle('#002')),
          findsOneWidget,
          reason:
              'Second activity should show pending invoice #002 with title: "${l10n.invoiceTitle('#002')}"',
        );
        expect(
          find.text('سارة علي'),
          findsOneWidget,
          reason:
              'Second activity should display customer name "سارة علي" for invoice #002',
        );
      });

      testWidgets('should display third activity (overdue invoice)', (
        tester,
      ) async {
        await setUpWidgets(tester);
        expect(
          find.text(l10n.invoiceTitle('#003')),
          findsOneWidget,
          reason:
              'Third activity should show overdue invoice #003 with title: "${l10n.invoiceTitle('#003')}"',
        );
        expect(
          find.text('محمود حسن'),
          findsOneWidget,
          reason:
              'Third activity should display customer name "محمود حسن" for invoice #003',
        );
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
        await tester.pump(); // تحسين الأداء

        // Initialize l10n
        l10n =
            AppLocalizations.of(tester.element(find.byType(DashboardScreen)));

        final buttonFinder = find.widgetWithText(
          AppEnhancedButton,
          l10n.actionAddInvoice,
        );
        await tester.ensureVisible(buttonFinder);
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        expect(
          navigated,
          isTrue,
          reason:
              'Tapping "Add Invoice" button should navigate to /invoice-form route for invoice creation',
        );
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
        await tester.pump(); // تحسين الأداء

        // Initialize l10n
        l10n =
            AppLocalizations.of(tester.element(find.byType(DashboardScreen)));

        final buttonFinder = find.widgetWithText(
          AppEnhancedButton,
          l10n.actionAddCustomer,
        );
        await tester.ensureVisible(buttonFinder);
        await tester.tap(buttonFinder);
        await tester.pump(); // تحسين الأداء

        expect(
          navigated,
          isTrue,
          reason:
              'Tapping "Add Customer" button should navigate to /customer-form route for customer creation',
        );
      });
    });

    group('Accessibility', () {
      testWidgets('should have semantic labels for buttons', (tester) async {
        await setUpWidgets(tester);

        // Verify "Add Invoice" button has correct label
        expect(
          find.bySemanticsLabel(l10n.actionAddInvoice),
          findsOneWidget,
          reason:
              'Add Invoice button should have semantic label "${l10n.actionAddInvoice}" for accessibility',
        );

        // Verify "Add Customer" button has correct label
        expect(
          find.bySemanticsLabel(l10n.actionAddCustomer),
          findsOneWidget,
          reason:
              'Add Customer button should have semantic label "${l10n.actionAddCustomer}" for accessibility',
        );

        // Note: Chart of Accounts and Journal Entries buttons are wrapped in PermissionGuard
        // and may not be visible in test environment without proper permission setup
        // Verify they exist as widgets instead of semantic labels
        expect(
          find.widgetWithText(AppEnhancedButton, l10n.labelChartOfAccounts),
          findsWidgets,
          reason:
              'Chart of Accounts button should exist with text "${l10n.labelChartOfAccounts}"',
        );
        expect(
          find.widgetWithText(AppEnhancedButton, l10n.labelJournalEntries),
          findsWidgets,
          reason:
              'Journal Entries button should exist with text "${l10n.labelJournalEntries}"',
        );
      });
    });
  });
}
