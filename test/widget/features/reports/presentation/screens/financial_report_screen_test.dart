import 'dart:async';

import 'package:basir_accounting_system/features/accounting/application/orchestrator_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/financial_report_screen.dart';
import 'package:basir_accounting_system/features/reports/presentation/widgets/report_line_item.dart';
import 'package:basir_accounting_system/features/reports/services/reporting_service.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/src/rust/api/reports.dart';
import 'package:basir_accounting_system/shared/widgets/app_error_widget.dart';
import 'package:basir_accounting_system/shared/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeReportingApi extends NativeReportingApi {
  _FakeReportingApi(this.reportFuture);

  final Future<FinancialReportDto> reportFuture;

  @override
  Future<FinancialReportDto> generateIncomeStatement({
    required String fromDate,
    required String toDate,
  }) =>
      reportFuture;

  @override
  Future<FinancialReportDto> generateBalanceSheet({
    required String asOfDate,
    Map<String, String>? fairValuationUpdates,
  }) =>
      reportFuture;
}

class _FakeOrchestratorService extends OrchestratorService {
  @override
  FutureOr<void> build() {}

  @override
  Future<List<AgentResult>> getPeriodInsights(
          DateTime from, DateTime to) async =>
      const [
        AgentResult(
          agentId: 'Standards Engine',
          isAllowed: true,
          rationale: 'IAS 1 presentation is consistent.',
          confidenceScore: 0.97,
        ),
      ];
}

FinancialReportDto _report() => const FinancialReportDto(
      title: 'Income Statement — Test Period',
      fromDate: '2026-01-01',
      toDate: '2026-08-14',
      generatedAt: '2026-08-14T10:00:00Z',
      lines: [
        FinancialReportLineDto(
          label: 'Revenue',
          amount: '12500.00',
          isTitle: false,
          isTotal: false,
          indentLevel: 0,
        ),
        FinancialReportLineDto(
          label: 'Net profit',
          amount: '4500.00',
          isTitle: false,
          isTotal: true,
          indentLevel: 0,
        ),
      ],
    );

Widget _testApp({
  required Future<FinancialReportDto> reportFuture,
  FinancialReportType type = FinancialReportType.incomeStatement,
}) =>
    ProviderScope(
      overrides: [
        nativeReportingServiceProvider.overrideWithValue(
          ReportingService(api: _FakeReportingApi(reportFuture)),
        ),
        orchestratorServiceProvider.overrideWith(_FakeOrchestratorService.new),
      ],
      child: MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FinancialReportScreen(reportType: type),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('يعرض مؤشر التحميل حتى وصول التقرير المالي', (tester) async {
    final completer = Completer<FinancialReportDto>();

    await tester.pumpWidget(_testApp(reportFuture: completer.future));
    await tester.pump();

    expect(find.byType(AppLoadingIndicator), findsOneWidget);

    completer.complete(_report());
    await tester.pumpAndSettle();

    expect(find.text('Income Statement — Test Period'), findsOneWidget);
  });

  testWidgets('يعرض بنود التقرير ورؤى الوكلاء بعد اكتمال البيانات',
      (tester) async {
    await tester.pumpWidget(_testApp(reportFuture: Future.value(_report())));
    await tester.pumpAndSettle();

    expect(find.text('Revenue'), findsOneWidget);
    expect(find.text('Net profit'), findsOneWidget);
    expect(find.byType(ReportLineItem), findsNWidgets(2));
    expect(find.text('Cognitive Hexagon Insights'), findsOneWidget);
    expect(find.text('Standards Engine'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('يعرض خطأ الخدمة ويعرض مبدل القيمة العادلة للميزانية', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        reportFuture: Future<FinancialReportDto>.delayed(
          Duration.zero,
          () => throw StateError('Native reporting service unavailable'),
        ),
        type: FinancialReportType.balanceSheet,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorWidget), findsOneWidget);
    expect(find.textContaining('Native reporting service unavailable'),
        findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);
  });
}
