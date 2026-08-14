import 'dart:async';

import 'package:basir_accounting_system/features/accounting/application/strategic_forecast_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/strategic_outlook.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/strategic_outlook_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_error_widget.dart';
import 'package:basir_accounting_system/shared/widgets/app_loading_indicator.dart';
import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeStrategicForecastNotifier extends StrategicForecastNotifier {
  _FakeStrategicForecastNotifier(this.outlookFuture);

  final Future<StrategicOutlook> outlookFuture;

  @override
  FutureOr<StrategicOutlook> build() => outlookFuture;
}

PredictiveMetric _metric({required int month, required String netIncome}) =>
    PredictiveMetric(
      period: DateTime(2026, month),
      revenue: Decimal.parse('125000.00'),
      expense: Decimal.parse('78000.00'),
      netIncome: Decimal.parse(netIncome),
      cashInflow: Decimal.parse('132000.00'),
      cashOutflow: Decimal.parse('76000.00'),
    );

StrategicOutlook _outlook({
  List<PredictiveMetric>? pnlForecast,
  List<PredictiveMetric>? cashFlowForecast,
  List<StrategicInsight>? insights,
}) =>
    StrategicOutlook(
      generatedAt: DateTime(2026, 8, 14),
      pnlForecast: pnlForecast ??
          <PredictiveMetric>[_metric(month: 9, netIncome: '47000')],
      cashFlowForecast: cashFlowForecast ??
          <PredictiveMetric>[_metric(month: 9, netIncome: '-12000')],
      insights: insights ??
          const <StrategicInsight>[
            StrategicInsight(
              title: 'ارتفاع الإيرادات المتوقعة',
              observation: 'النمو المتوقع يدعم السيولة.',
              recommendation: 'استثمر في قنوات البيع الناجحة.',
              impact: InsightImpact.positive,
              priority: 'high',
            ),
            StrategicInsight(
              title: 'ضغط نقدي متوقع',
              observation: 'تحتاج المصروفات إلى مراقبة شهرية.',
              recommendation: 'راجع التزامات الموردين.',
              impact: InsightImpact.negative,
              priority: 'medium',
            ),
          ],
      confidenceScore: 0.87,
    );

Widget _testApp(Future<StrategicOutlook> outlookFuture) => ProviderScope(
      overrides: [
        strategicForecastNotifierProvider.overrideWith(
          () => _FakeStrategicForecastNotifier(outlookFuture),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const StrategicOutlookScreen(),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('يعرض مؤشر التحميل قبل اكتمال التوقع الاستراتيجي',
      (tester) async {
    final completer = Completer<StrategicOutlook>();

    await tester.pumpWidget(_testApp(completer.future));
    await tester.pump();

    expect(find.byType(AppLoadingIndicator), findsOneWidget);

    completer.complete(_outlook());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('يعرض الرسوم والرؤى وتصنيف الأثر عند وصول التوقعات',
      (tester) async {
    await tester
        .pumpWidget(_testApp(Future<StrategicOutlook>.value(_outlook())));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('87%'), findsOneWidget);
    expect(find.text('ارتفاع الإيرادات المتوقعة'), findsOneWidget);
    expect(find.text('ضغط نقدي متوقع'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.byType(BarChart), findsOneWidget);
    expect(find.byIcon(Icons.trending_up), findsOneWidget);
    expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
  });

  testWidgets('يعرض الحالات الفارغة للرسوم والرؤى عند غياب البيانات', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        Future<StrategicOutlook>.value(
          _outlook(
            pnlForecast: const <PredictiveMetric>[],
            cashFlowForecast: const <PredictiveMetric>[],
            insights: const <StrategicInsight>[],
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byIcon(Icons.insights_outlined), findsNWidgets(2));
    expect(find.byType(LineChart), findsNothing);
    expect(find.byType(BarChart), findsNothing);
  });

  testWidgets('يعرض خطأ مزود التوقعات ويتيح إعادة المحاولة', (tester) async {
    await tester.pumpWidget(
      _testApp(
        Future<StrategicOutlook>.delayed(
          Duration.zero,
          () => throw StateError('forecast repository unavailable'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(AppErrorWidget), findsOneWidget);
    expect(
        find.textContaining('forecast repository unavailable'), findsOneWidget);
  });
}
