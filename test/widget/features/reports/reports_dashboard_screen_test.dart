import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/aging_report_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/reports_dashboard_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReportingService extends Mock implements ReportingService {}

void main() {
  late MockReportingService mockReportingService;

  setUp(() {
    mockReportingService = MockReportingService();
  });

  Widget createWidgetUnderTest() => ProviderScope(
        overrides: [
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
          currentUserProfileProvider.overrideWith(
            (ref) => const BasirUser(
              id: 'test-user',
              email: 'test@example.com',
              displayName: 'Test User',
              role: UserRole.accountant,
              permissions: Permission.viewFinancials,
            ),
          ),
          nativeReportingServiceProvider
              .overrideWithValue(mockReportingService),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('ar')],
          locale: Locale('ar'),
          home: ReportsDashboardScreen(),
        ),
      );

  testWidgets('ReportsDashboardScreen shows all report sections', (
    tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('التقارير المالية'), findsOneWidget); // Dashboard section
    expect(
      find.text('تحليل السداد وأعمار الديون'),
      findsOneWidget,
    ); // New section
  });

  testWidgets('Navigation to Receivables Aging works', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final arButton = find.text('أعمار العملاء');
    expect(arButton, findsOneWidget);

    await tester.ensureVisible(arButton);
    await tester.tap(arButton);
    await tester.pumpAndSettle();

    expect(find.byType(AgingReportScreen), findsOneWidget);

    // Get l10n
    final l10n = AppLocalizations.of(
      tester.element(find.byType(AgingReportScreen)),
    );
    expect(find.text(l10n.receivablesAgingTitle), findsOneWidget);
  });

  testWidgets('Navigation to Payables Aging works', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final apButton = find.text('أعمار الموردين');
    expect(apButton, findsOneWidget);

    await tester.ensureVisible(apButton);
    await tester.tap(apButton);
    await tester.pumpAndSettle();

    expect(find.byType(AgingReportScreen), findsOneWidget);

    // Get l10n
    final l10n = AppLocalizations.of(
      tester.element(find.byType(AgingReportScreen)),
    );
    expect(find.text(l10n.payablesAgingTitle), findsOneWidget);
  });
}
