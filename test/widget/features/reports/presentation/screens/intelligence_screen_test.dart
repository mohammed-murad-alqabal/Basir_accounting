import 'dart:async';

import 'package:basir_accounting_system/features/reports/application/financial_intelligence_service.dart';
import 'package:basir_accounting_system/features/reports/domain/entities/financial_kpi.dart';
import 'package:basir_accounting_system/features/reports/presentation/screens/intelligence_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFinancialIntelligenceService extends FinancialIntelligenceService {
  _FakeFinancialIntelligenceService({
    required this.kpisFuture,
    required this.cashFlowFuture,
  });

  final Future<List<FinancialKpi>> kpisFuture;
  final Future<List<double>> cashFlowFuture;

  @override
  void build() {}

  @override
  Future<List<FinancialKpi>> getFinancialKpis() => kpisFuture;

  @override
  Future<List<double>> getCashFlowTrend() => cashFlowFuture;
}

const _kpis = <FinancialKpi>[
  FinancialKpi(
    name: 'Current Ratio',
    value: 0.8,
    unit: 'x',
    trend: -0.15,
    health: KpiHealth.critical,
    description: 'Liquidity requires attention.',
  ),
  FinancialKpi(
    name: 'Burn Rate',
    value: 12000,
    unit: 'SAR/mo',
    trend: 0.2,
    health: KpiHealth.warning,
    description: 'Operating expenses are increasing.',
  ),
  FinancialKpi(
    name: 'Profit Margin',
    value: 28,
    unit: '%',
    trend: 0.05,
    health: KpiHealth.healthy,
    description: 'Profitability is strong.',
  ),
];

Widget _testApp({
  required Future<List<FinancialKpi>> kpisFuture,
  Future<List<double>>? cashFlowFuture,
}) =>
    ProviderScope(
      overrides: [
        financialIntelligenceServiceProvider.overrideWith(
          () => _FakeFinancialIntelligenceService(
            kpisFuture: kpisFuture,
            cashFlowFuture:
                cashFlowFuture ?? Future<List<double>>.value(<double>[]),
          ),
        ),
      ],
      child: const MaterialApp(home: IntelligenceScreen()),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('يعرض التحميل حتى اكتمال مؤشرات الأداء المالي', (tester) async {
    final completer = Completer<List<FinancialKpi>>();

    await tester.pumpWidget(_testApp(kpisFuture: completer.future));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(_kpis);
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('يعرض بطاقات المؤشرات والرؤى والرسم البياني للاتجاه', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        kpisFuture: Future<List<FinancialKpi>>.value(_kpis),
        cashFlowFuture: Future<List<double>>.value(<double>[1200, -600, 900]),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('انخفاض السيولة النقدية'), findsOneWidget);
    expect(find.text('تسارع في معدل الاستنزاف'), findsOneWidget);
    expect(find.text('أداء ربحي ممتاز'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Current Ratio', skipOffstage: false),
      300,
    );

    expect(find.text('Current Ratio', skipOffstage: false), findsOneWidget);
    expect(find.text('Burn Rate', skipOffstage: false), findsOneWidget);
    expect(find.text('Profit Margin', skipOffstage: false), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byType(LineChart),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byType(LineChart), findsOneWidget);
    expect(
        find.byIcon(Icons.trending_down, skipOffstage: false), findsOneWidget);
    expect(
        find.byIcon(Icons.trending_up, skipOffstage: false), findsNWidgets(2));
  });

  testWidgets('يعرض رسالة الخطأ عندما يفشل تحميل المؤشرات', (tester) async {
    await tester.pumpWidget(
      _testApp(
        kpisFuture: Future<List<FinancialKpi>>.delayed(
          Duration.zero,
          () => throw StateError('analytics repository unavailable'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('analytics repository unavailable'),
        findsOneWidget);
  });
}
