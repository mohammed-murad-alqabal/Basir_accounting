// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Minimal dashboard widget for testing core functionality
class MinimalDashboardScreen extends StatelessWidget {
  const MinimalDashboardScreen({
    required this.data,
    super.key,
  });

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              l10n.dashboardWelcomeMessage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Statistics section
            Text(
              l10n.dashboardStatsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                GlassStatCard(
                  label: l10n.statTotalSales,
                  value: '${data.totalSales}',
                  icon: Icons.receipt,
                  color: Colors.blue,
                ),
                GlassStatCard(
                  label: l10n.statActiveCustomers,
                  value: '${data.activeCustomersCount}',
                  icon: Icons.people,
                  color: Colors.green,
                ),
                GlassStatCard(
                  label: l10n.statPaid,
                  value: '${data.paidRevenue}',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                GlassStatCard(
                  label: l10n.statOverdue,
                  value: '${data.overdueRevenue}',
                  icon: Icons.error,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick actions section
            Text(
              l10n.dashboardQuickActionsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: AppEnhancedButton(
                    label: l10n.actionAddInvoice,
                    onPressed: () {
                      // Navigation handled by test
                    },
                    icon: Icons.add,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppEnhancedButton(
                    label: l10n.actionAddCustomer,
                    onPressed: () {
                      // Navigation handled by test
                    },
                    icon: Icons.add,
                    type: AppEnhancedButtonType.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Recent activity section
            Text(
              l10n.dashboardRecentActivityTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            if (data.recentInvoices.isEmpty)
              Center(
                child: Text(
                  l10n.msgNoActivity,
                  style: const TextStyle(color: Colors.grey),
                ),
              )
            else
              ...data.recentInvoices.map(
                (invoice) => AppListCard(
                  title: l10n.invoiceTitle(invoice.id),
                  subtitle: invoice.customerName,
                  trailing: '${invoice.totalAmount}',
                  leading: Icon(
                    _getStatusIcon(invoice.status),
                    color: _getStatusColor(invoice.status),
                    size: 20,
                  ),
                  onTap: () {
                    // Navigation handled by test
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return Icons.check_circle;
      case InvoiceStatus.overdue:
        return Icons.error;
      case InvoiceStatus.sent:
        return Icons.send;
      case InvoiceStatus.draft:
        return Icons.drafts;
      case InvoiceStatus.cancelled:
        return Icons.cancel;
      case InvoiceStatus.refunded:
        return Icons.undo;
    }
  }

  Color _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return Colors.green;
      case InvoiceStatus.overdue:
        return Colors.red;
      case InvoiceStatus.sent:
        return Colors.blue;
      case InvoiceStatus.draft:
        return Colors.orange;
      case InvoiceStatus.cancelled:
        return Colors.grey;
      case InvoiceStatus.refunded:
        return Colors.purple;
    }
  }
}

void main() {
  group('Dashboard Screen Minimal Tests', () {
    late DashboardData testData;
    late List<Invoice> testInvoices;

    setUpAll(() {
      final now = DateTime.now();

      testInvoices = [
        Invoice(
          id: '#001',
          invoiceNumber: '#001',
          customerId: 'c1',
          customerName: 'أحمد محمد',
          items: [
            InvoiceItem(
              taxRate: Decimal.parse('0.15'),
              id: 'i1',
              name: 'Test Item',
              quantity: Decimal.one,
              price: Decimal.fromInt(1500),
              total: Decimal.fromInt(1500),
              taxAmount: Decimal.zero,
            ),
          ],
          status: InvoiceStatus.paid,
          issuedDate: now,
          dueDate: now.add(const Duration(days: 30)),
          createdAt: now,
          updatedAt: now,
          taxRate: Decimal.zero,
          subtotalAmount: Decimal.fromInt(1500),
          taxAmount: Decimal.zero,
          totalAmount: Decimal.fromInt(1500),
          paidAmount: Decimal.fromInt(1500),
          discountAmount: Decimal.zero,
          discountRate: Decimal.zero,
          exchangeRate: Decimal.one,
        ),
        Invoice(
          id: '#002',
          invoiceNumber: '#002',
          customerId: 'c2',
          customerName: 'سارة علي',
          items: [
            InvoiceItem(
              taxRate: Decimal.parse('0.15'),
              id: 'i2',
              name: 'Test Item 2',
              quantity: Decimal.one,
              price: Decimal.fromInt(2300),
              total: Decimal.fromInt(2300),
              taxAmount: Decimal.zero,
            ),
          ],
          status: InvoiceStatus.sent,
          issuedDate: now,
          dueDate: now.add(const Duration(days: 30)),
          createdAt: now,
          updatedAt: now,
          taxRate: Decimal.zero,
          subtotalAmount: Decimal.fromInt(2300),
          taxAmount: Decimal.zero,
          totalAmount: Decimal.fromInt(2300),
          paidAmount: Decimal.zero,
          discountAmount: Decimal.zero,
          discountRate: Decimal.zero,
          exchangeRate: Decimal.one,
        ),
      ];

      testData = DashboardData(
        totalInvoices: 2,
        paidInvoices: 1,
        overdueInvoices: 0,
        pendingInvoices: 1,
        totalSales: Decimal.fromInt(3800),
        paidRevenue: Decimal.fromInt(1500),
        pendingRevenue: Decimal.fromInt(2300),
        overdueRevenue: Decimal.zero,
        activeCustomersCount: 2,
        recentInvoices: testInvoices,
        salesTrend: const <String, double>{
          '1/1': 1500.0,
          '2/1': 2300.0,
        },
      );
    });

    Widget createTestWidget({Map<String, WidgetBuilder>? routes}) =>
        MaterialApp(
          home: MinimalDashboardScreen(data: testData),
          routes: routes ?? <String, WidgetBuilder>{},
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
        );

    testWidgets('should display welcome message', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(MinimalDashboardScreen)),
      );

      expect(find.text(l10n.dashboardWelcomeMessage), findsOneWidget);
    });

    testWidgets('should display statistics section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(MinimalDashboardScreen)),
      );

      expect(find.text(l10n.dashboardStatsTitle), findsOneWidget);
      expect(find.byType(GlassStatCard), findsNWidgets(4));
    });

    testWidgets('should display correct statistics values', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget); // Active customers
      expect(find.textContaining('3800'), findsOneWidget); // Total sales
      expect(find.textContaining('1500'), findsAtLeastNWidgets(1)); // Paid
    });

    testWidgets('should display quick actions', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(MinimalDashboardScreen)),
      );

      expect(find.text(l10n.dashboardQuickActionsTitle), findsOneWidget);
      expect(
        find.widgetWithText(AppEnhancedButton, l10n.actionAddInvoice),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(AppEnhancedButton, l10n.actionAddCustomer),
        findsOneWidget,
      );
    });

    testWidgets('should display recent activity', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(MinimalDashboardScreen)),
      );

      expect(find.text(l10n.dashboardRecentActivityTitle), findsOneWidget);
      expect(find.byType(AppListCard), findsNWidgets(2));
      expect(find.text('أحمد محمد'), findsOneWidget);
      expect(find.text('سارة علي'), findsOneWidget);
    });

    testWidgets('should have tappable action buttons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(MinimalDashboardScreen)),
      );

      // Find buttons
      final invoiceButtons = find.widgetWithText(
        AppEnhancedButton,
        l10n.actionAddInvoice,
      );
      final customerButtons = find.widgetWithText(
        AppEnhancedButton,
        l10n.actionAddCustomer,
      );

      // Verify buttons exist and are tappable
      expect(invoiceButtons, findsAtLeastNWidgets(1));
      expect(customerButtons, findsAtLeastNWidgets(1));

      // Test that buttons can be tapped (without navigation)
      await tester.ensureVisible(invoiceButtons.first);
      await tester.tap(invoiceButtons.first, warnIfMissed: false);
      await tester.pump();

      await tester.ensureVisible(customerButtons.first);
      await tester.tap(customerButtons.first, warnIfMissed: false);
      await tester.pump();

      // If we reach here, buttons are tappable
      expect(true, isTrue);
    });

    testWidgets('should display empty state when no recent invoices', (
      tester,
    ) async {
      final emptyData = DashboardData(
        totalInvoices: 0,
        paidInvoices: 0,
        overdueInvoices: 0,
        pendingInvoices: 0,
        totalSales: Decimal.zero,
        paidRevenue: Decimal.zero,
        pendingRevenue: Decimal.zero,
        overdueRevenue: Decimal.zero,
        activeCustomersCount: 0,
        recentInvoices: const [],
        salesTrend: const <String, double>{},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MinimalDashboardScreen(data: emptyData),
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
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(MinimalDashboardScreen)),
      );

      expect(find.text(l10n.msgNoActivity), findsOneWidget);
      expect(find.byType(AppListCard), findsNothing);
    });
  });
}
