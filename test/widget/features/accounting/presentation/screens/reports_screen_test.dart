import 'package:basir_accounting_system/features/accounting/presentation/screens/reports_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSubject(NavigatorObserver observer) => ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          navigatorObservers: [observer],
          home: const ReportingOverviewScreen(),
        ),
      );

  testWidgets('يعرض مركز التقارير وينتقل إلى كل بطاقة تقرير', (tester) async {
    final observer = _NavigationObserver();
    await tester.pumpWidget(buildSubject(observer));
    await tester.pump();

    expect(find.byType(AppCard), findsNWidgets(4));

    const reportIcons = [
      Icons.account_balance_rounded,
      Icons.pie_chart_rounded,
      Icons.assessment_rounded,
      Icons.money_rounded,
      Icons.timer_rounded,
    ];

    for (var index = 0; index < reportIcons.length; index++) {
      final reportIcon = find.byIcon(reportIcons[index]);
      await tester.scrollUntilVisible(reportIcon, 160);
      expect(reportIcon, findsOneWidget);
      await tester.tap(reportIcon);
      await tester.pump();
      expect(observer.pushedRoutes, index + 1);
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pump();
      expect(find.byType(ReportingOverviewScreen), findsOneWidget);
    }
  });
}

class _NavigationObserver extends NavigatorObserver {
  int pushedRoutes = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) pushedRoutes++;
    super.didPush(route, previousRoute);
  }
}
