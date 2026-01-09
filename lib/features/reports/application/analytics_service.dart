import 'package:basir_app/features/reports/domain/entities/financial_kpi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

@Riverpod(keepAlive: true)
class AnalyticsService extends _$AnalyticsService {
  @override
  FutureOr<void> build() {}

  /// Calculates key financial ratios and indicators.
  Future<List<FinancialKpi>> getFinancialKpis() async {
    // In a real scenario, we'd fetch actual balances from the repository.
    // For now, we simulate KPI calculation logic.

    // Example: Current Ratio = Current Assets / Current Liabilities
    // Burn Rate = Monthly Expenses - Monthly Revenue

    return [
      const FinancialKpi(
        name: 'Current Ratio',
        value: 1.8,
        unit: 'x',
        trend: 0.05,
        health: KpiHealth.healthy,
        description: 'Measures ability to pay short-term obligations.',
      ),
      const FinancialKpi(
        name: 'Burn Rate',
        value: 12500,
        unit: 'SAR/mo',
        trend: -0.12,
        health: KpiHealth.warning,
        description: 'Monthly negative cash flow.',
      ),
      const FinancialKpi(
        name: 'Profit Margin',
        value: 24.5,
        unit: '%',
        trend: 0.02,
        health: KpiHealth.healthy,
        description: 'Net income as a percentage of revenue.',
      ),
    ];
  }
}
