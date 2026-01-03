import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/theme/tokens/app_icons.dart';
import 'package:basir_app/features/customers/domain/entities/customer.dart';
import 'package:basir_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_app/l10n/app_localizations.dart';
import 'package:basir_app/shared/widgets/index.dart';
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

    setUp(() {
      mockInvoiceRepo = MockInvoiceRepository();
      mockCustomerRepo = MockCustomerRepository();
      mockAccountingRepo = MockAccountingRepository();

      // إعداد البيانات المتوقعة للاختبارات
      final now = DateTime.now();
      final invoices = [
        Invoice(
          id: '#001',
          invoiceNumber: '#001',
          customerId: 'c1',
          customerName: 'أحمد محمد',
          items: [
            const InvoiceItem(
              id: 'i1',
              name: 'Test',
              quantity: 1,
              price: 1500,
              total: 1500,
            ),
          ],
          status: InvoiceStatus.paid,
          issuedDate: now,
          dueDate: now.add(const Duration(days: 30)),
          createdAt: now,
          updatedAt: now,
          taxRate: 0,
          subtotalAmount: 1500,
          taxAmount: 0,
          totalAmount: 1500,
          paidAmount: 1500,
          discountAmount: 0,
        ),
        Invoice(
          id: '#002',
          invoiceNumber: '#002',
          customerId: 'c2',
          customerName: 'سارة علي',
          items: [
            const InvoiceItem(
              id: 'i2',
              name: 'Test',
              quantity: 1,
              price: 2300,
              total: 2300,
            ),
          ],
          status: InvoiceStatus.sent,
          issuedDate: now,
          dueDate: now.add(const Duration(days: 30)),
          createdAt: now.subtract(const Duration(minutes: 5)),
          updatedAt: now,
          taxRate: 0,
          subtotalAmount: 2300,
          taxAmount: 0,
          totalAmount: 2300,
          paidAmount: 0,
          discountAmount: 0,
        ),
        Invoice(
          id: '#003',
          invoiceNumber: '#003',
          customerId: 'c3',
          customerName: 'محمود حسن',
          items: [
            const InvoiceItem(
              id: 'i3',
              name: 'Test',
              quantity: 1,
              price: 1800,
              total: 1800,
            ),
          ],
          status: InvoiceStatus.overdue,
          issuedDate: now,
          dueDate: now.subtract(const Duration(days: 1)),
          createdAt: now.subtract(const Duration(minutes: 10)),
          updatedAt: now,
          taxRate: 0,
          subtotalAmount: 1800,
          taxAmount: 0,
          totalAmount: 1800,
          paidAmount: 0,
          discountAmount: 0,
        ),
      ];

      // إضافة فواتير إضافية لتصل لـ 24
      for (var i = 4; i <= 24; i++) {
        invoices.add(
          Invoice(
            id: '#0${i.toString().padLeft(2, '0')}',
            invoiceNumber: '#0${i.toString().padLeft(2, '0')}',
            customerId: 'c1',
            customerName: 'Customer',
            items: [],
            status: InvoiceStatus.sent,
            issuedDate: now,
            dueDate: now,
            createdAt: now.subtract(Duration(hours: i)),
            updatedAt: now,
            taxRate: 0,
            subtotalAmount: 0,
            taxAmount: 0,
            totalAmount: 0,
            paidAmount: 0,
            discountAmount: 0,
          ),
        );
      }

      mockInvoiceRepo.setInvoices(invoices);

      // إعداد 12 عميل
      final customers = List.generate(
        12,
        (i) => Customer(
          id: 'c$i',
          name: 'Customer $i',
          phone: '050',
          createdAt: now,
          updatedAt: now,
        ),
      );
      mockCustomerRepo.setCustomers(customers);
    });

    Widget createTestWidget({
      Map<String, WidgetBuilder>? routes,
    }) =>
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
      // الانتظار حتى اكتمال AsyncNotifier
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();
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
          find.widgetWithText(AppButton, l10n.actionAddInvoice),
          findsOneWidget,
        );
      });

      testWidgets('should display new customer button', (tester) async {
        await setUpWidgets(tester);
        expect(
          find.widgetWithText(AppButton, l10n.actionAddCustomer),
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

      testWidgets('should display first activity (paid invoice)',
          (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.invoiceTitle('#001')), findsOneWidget);
        expect(find.text('أحمد محمد'), findsOneWidget);
      });

      testWidgets('should display second activity (pending invoice)',
          (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.invoiceTitle('#002')), findsOneWidget);
        expect(find.text('سارة علي'), findsOneWidget);
      });

      testWidgets('should display third activity (overdue invoice)',
          (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.invoiceTitle('#003')), findsOneWidget);
        expect(find.text('محمود حسن'), findsOneWidget);
      });
    });

    testWidgets(
      'New Invoice button should navigate to form',
      (tester) async {
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
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump();

        // Scroll to make the button visible
        final buttonFinder =
            find.widgetWithText(AppButton, l10n.actionAddInvoice);
        await tester.ensureVisible(buttonFinder);
        await tester.pump();

        await tester.tap(buttonFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(navigated, isTrue);
      },
    );

    testWidgets(
      'New Customer button should navigate to form',
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
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump();

        // Scroll to make the button visible
        final buttonFinder =
            find.widgetWithText(AppButton, l10n.actionAddCustomer);
        await tester.ensureVisible(buttonFinder);
        await tester.pump();

        await tester.tap(buttonFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(navigated, isTrue);
      },
    );

    group('Accessibility', () {
      testWidgets('should have semantic labels for buttons', (tester) async {
        await setUpWidgets(tester);

        // Verify "Add Invoice" button has correct label
        expect(
          find.bySemanticsLabel(l10n.actionAddInvoice),
          findsOneWidget,
        );

        // Verify "Add Customer" button has correct label
        expect(
          find.bySemanticsLabel(l10n.actionAddCustomer),
          findsOneWidget,
        );

        // Verify Accounting buttons have their custom semantic labels
        expect(find.bySemanticsLabel('فتح دليل الحسابات'), findsOneWidget);
        expect(find.bySemanticsLabel('عرض القيود اليومية'), findsOneWidget);
      });
    });
  });
}
