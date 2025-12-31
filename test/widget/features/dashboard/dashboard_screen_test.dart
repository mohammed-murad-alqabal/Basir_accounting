/// اختبارات DashboardScreen
library;

import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/core/widgets/mastery_dashboard_widgets.dart';
import 'package:basser_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:basser_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardScreen', () {
    Widget createTestWidget({Map<String, WidgetBuilder>? routes}) =>
        ProviderScope(
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
      // We use pump() instead of pumpAndSettle() because the screen contains
      // an infinite shimmer animation (BasserShimmerLogo) which causes
      // pumpAndSettle to time out.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      l10n = AppLocalizations.of(tester.element(find.byType(DashboardScreen)));
    }

    testWidgets('should display app bar with title', (tester) async {
      await setUpWidgets(tester);
      expect(find.text(l10n.dashboardTitle), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display greeting message', (tester) async {
      await setUpWidgets(tester);
      expect(find.text(l10n.dashboardWelcomeMessage), findsOneWidget);
      expect(find.text(l10n.dashboardMotto), findsOneWidget);
    });

    group('Statistics Section', () {
      testWidgets('should display statistics title', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.dashboardStatsTitle), findsOneWidget);
      });

      testWidgets('should display 4 stat cards', (tester) async {
        await setUpWidgets(tester);
        expect(find.byType(GlassStatCard), findsNWidgets(4));
      });

      testWidgets('should display total invoices stat', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.statTotalInvoices), findsOneWidget);
        expect(find.text('24'), findsOneWidget);
      });

      testWidgets('should display customers stat', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.statActiveCustomers), findsOneWidget);
        expect(find.text('12'), findsOneWidget);
      });

      testWidgets('should display sales stat', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.statTotalSales), findsOneWidget);
        expect(find.text('5,240 ${l10n.hintCurrencySymbol}'), findsOneWidget);
      });

      testWidgets('should display overdue stat', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.statOverdueInvoices), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      });
    });

    group('Quick Actions Section', () {
      testWidgets('should display quick actions title', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.dashboardQuickActionsTitle), findsOneWidget);
      });

      testWidgets('should display new invoice button', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.actionAddInvoice), findsOneWidget);
        expect(find.byType(AppPrimaryButton), findsOneWidget);
      });

      testWidgets('should display new customer button', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.actionAddCustomer), findsOneWidget);
        expect(find.byType(AppSecondaryButton), findsOneWidget);
      });
    });

    group('Recent Activity Section', () {
      testWidgets('should display recent activity title', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.dashboardRecentActivityTitle), findsOneWidget);
      });

      testWidgets('should display 3 activity cards', (tester) async {
        await setUpWidgets(tester);
        expect(find.byType(AppListCard), findsNWidgets(3));
      });

      testWidgets('should display first activity (paid invoice)', (
        tester,
      ) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.invoiceTitle('#001')), findsOneWidget);
        expect(
          find.text('أحمد محمد - 1,500 ${l10n.hintCurrencySymbol}'),
          findsOneWidget,
        );
        expect(find.text(l10n.statusPaid), findsOneWidget);
      });

      testWidgets('should display second activity (pending invoice)', (
        tester,
      ) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.invoiceTitle('#002')), findsOneWidget);
        expect(
          find.text('سارة علي - 2,300 ${l10n.hintCurrencySymbol}'),
          findsOneWidget,
        );
        expect(find.text(l10n.statusPending), findsOneWidget);
      });

      testWidgets('should display third activity (overdue invoice)', (
        tester,
      ) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.invoiceTitle('#003')), findsOneWidget);
        expect(
          find.text('محمود حسن - 1,800 ${l10n.hintCurrencySymbol}'),
          findsOneWidget,
        );
        expect(find.text(l10n.statusOverdue), findsOneWidget);
      });
    });

    group('Bottom Navigation Bar', () {
      testWidgets('should display bottom navigation bar', (tester) async {
        await setUpWidgets(tester);
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      });

      testWidgets('should display 4 navigation items', (tester) async {
        await setUpWidgets(tester);
        expect(find.text(l10n.navHome), findsOneWidget);
        expect(find.text(l10n.navInvoices), findsOneWidget);
        expect(find.text(l10n.navCustomers), findsOneWidget);
        expect(find.text(l10n.navSettings), findsOneWidget);
      });
    });
  });
}
