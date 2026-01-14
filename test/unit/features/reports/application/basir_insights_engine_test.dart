import 'package:basir_accounting_system/features/reports/application/basir_insights_engine.dart';
import 'package:basir_accounting_system/features/reports/domain/entities/financial_kpi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('BasirInsightsEngine generates high risk insight for low liquidity', () {
    final engine = container.read(basirInsightsEngineProvider.notifier);

    final kpis = [
      const FinancialKpi(
        name: 'Current Ratio',
        value: 1.1, // Below 1.2 threshold
        unit: 'x',
        trend: -0.05,
        health: KpiHealth.warning,
        description: 'Liquidity',
      ),
    ];

    final insights = engine.generateInsights(kpis);

    expect(insights.length, 1);
    final insight = insights.first;

    expect(insight.source, AgentSource.strategist);
    expect(insight.riskLevel, InsightRiskLevel.high);
    expect(insight.title, 'انخفاض السيولة النقدية');
  });

  test(
      'BasirInsightsEngine generates tax warning for stable but high liability',
      () {
    // NOTE: This test validates the logic: if VAT Liability trend > 0.15
    final engine = container.read(basirInsightsEngineProvider.notifier);

    final kpis = [
      const FinancialKpi(
        name: 'VAT Liability',
        value: 50000,
        unit: 'SAR',
        trend: 0.20, // > 0.15
        health: KpiHealth.warning,
        description: 'VAT Due',
      ),
    ];

    final insights = engine.generateInsights(kpis);

    expect(insights.length, 1);
    final insight = insights.first;

    expect(insight.source, AgentSource.tax);
    expect(insight.riskLevel, InsightRiskLevel.medium);
    expect(insight.title, 'زيادة التزامات الضريبة');
    expect(insight.actionRoute, '/reports/tax-smart');
  });

  test('BasirInsightsEngine returns default stable insight when healthy', () {
    final engine = container.read(basirInsightsEngineProvider.notifier);
    final kpis = <FinancialKpi>[]; // Empty or healthy list

    final insights = engine.generateInsights(kpis);

    expect(insights.length, 1);
    expect(insights.first.title, 'الوضع المالي مستقر');
    expect(insights.first.riskLevel, InsightRiskLevel.info);
  });
}
