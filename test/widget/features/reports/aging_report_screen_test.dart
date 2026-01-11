import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/aging_report_screen.dart';
import 'package:basir_accounting_system/features/reports/services/reporting_service.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/src/rust/api/reports.dart';
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

  Widget createWidgetUnderTest(AgingReportType type) => ProviderScope(
        overrides: [
          nativeReportingServiceProvider
              .overrideWithValue(mockReportingService),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar')],
          locale: const Locale('ar'),
          home: AgingReportScreen(reportType: type),
        ),
      );

  testWidgets('AgingReportScreen shows empty state when no data', (
    tester,
  ) async {
    when(
      () => mockReportingService.getReceivablesAging(
        asOfDate: any(named: 'asOfDate'),
      ),
    ).thenAnswer((_) async => []);

    await tester.pumpWidget(createWidgetUnderTest(AgingReportType.receivables));
    await tester.pumpAndSettle();

    expect(find.text('لا توجد بيانات لهذه الفترة'), findsOneWidget);
  });

  testWidgets('AgingReportScreen shows data table when data is present', (
    tester,
  ) async {
    final mockData = <AgingReportLineDto>[
      const AgingReportLineDto(
        partnerId: '1',
        partnerName: 'عميل 1',
        currentAmount: '1234',
        period130: '567',
        period3160: '0',
        period6190: '0',
        periodOver90: '0',
        totalAmount: '1801',
      ),
    ];

    when(
      () => mockReportingService.getReceivablesAging(
        asOfDate: any(named: 'asOfDate'),
      ),
    ).thenAnswer((_) async => mockData);

    await tester.pumpWidget(createWidgetUnderTest(AgingReportType.receivables));
    await tester.pumpAndSettle();

    expect(find.text('عميل 1'), findsOneWidget);
    expect(find.textContaining('1,234.00'), findsOneWidget);
    expect(find.textContaining('567.00'), findsOneWidget);
    expect(find.textContaining('1,801.00'), findsOneWidget);
  });
}
