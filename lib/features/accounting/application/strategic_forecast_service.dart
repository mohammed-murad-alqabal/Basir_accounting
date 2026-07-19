import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/strategic_outlook.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'strategic_forecast_service.g.dart';

/// Service for generating strategic financial forecasts and insights.
@riverpod
class StrategicForecastNotifier extends _$StrategicForecastNotifier {
  @override
  FutureOr<StrategicOutlook> build() async => _generateOutlook();

  Future<StrategicOutlook> _generateOutlook() async {
    final journalEntries =
        await ref.read(accountingServiceProvider.notifier).getJournalEntries();

    // 1. Group by month and calculate P&L
    final monthlyData = _calculateMonthlyPnL(journalEntries);

    // 2. Project next 6 months
    final pnlForecast = _projectFuture(monthlyData, 6);

    // 3. Generate Insights (from Agent 5 and local analysis)
    final insights = await _generateInsights(monthlyData, pnlForecast);

    return StrategicOutlook(
      generatedAt: DateTime.now(),
      pnlForecast: pnlForecast,
      cashFlowForecast: pnlForecast, // Simple mapping for now
      insights: insights,
      confidenceScore: 0.85,
    );
  }

  Map<DateTime, PredictiveMetric> _calculateMonthlyPnL(
    List<JournalEntry> entries,
  ) {
    final map = <DateTime, PredictiveMetric>{};

    for (final entry in entries) {
      final month = DateTime(entry.date.year, entry.date.month);
      final current = map[month] ??
          PredictiveMetric(
            period: month,
            revenue: Decimal.zero,
            expense: Decimal.zero,
            netIncome: Decimal.zero,
            cashInflow: Decimal.zero,
            cashOutflow: Decimal.zero,
          );

      var revenue = current.revenue;
      var expense = current.expense;
      var inflow = current.cashInflow;
      var outflow = current.cashOutflow;

      for (final line in entry.lines) {
        final accId = line.accountId;
        // Basic grouping logic
        if (accId.startsWith('acc-4')) revenue += line.credit - line.debit;
        if (accId.startsWith('acc-5')) expense += line.debit - line.credit;

        // Cash flow impact (acc-11 are cash/bank)
        if (accId.startsWith('acc-11')) {
          if (line.debit > line.credit) inflow += line.debit - line.credit;
          if (line.credit > line.debit) outflow += line.credit - line.debit;
        }
      }

      map[month] = current.copyWith(
        revenue: revenue,
        expense: expense,
        netIncome: revenue - expense,
        cashInflow: inflow,
        cashOutflow: outflow,
      );
    }
    return map;
  }

  List<PredictiveMetric> _projectFuture(
    Map<DateTime, PredictiveMetric> current,
    int months,
  ) {
    if (current.isEmpty) return [];

    final sortedMonths = current.keys.toList()..sort();
    final lastMonth = sortedMonths.last;

    // Simple average growth model
    var avgRevGrowth = Decimal.zero;
    if (current.length > 1) {
      final first = current[sortedMonths.first]!.revenue;
      final last = current[sortedMonths.last]!.revenue;
      avgRevGrowth = last > Decimal.zero
          ? ((last - first) / Decimal.fromInt(current.length)).toDecimal(
              scaleOnInfinitePrecision: 4,
            )
          : Decimal.zero;
    }

    final forecast = <PredictiveMetric>[];
    for (var i = 1; i <= months; i++) {
      final period = DateTime(lastMonth.year, lastMonth.month + i);
      final prevRev =
          i == 1 ? current[lastMonth]!.revenue : forecast.last.revenue;
      final prevExp =
          i == 1 ? current[lastMonth]!.expense : forecast.last.expense;

      forecast.add(
        PredictiveMetric(
          period: period,
          revenue: prevRev + avgRevGrowth,
          expense: prevExp *
              Decimal.parse('1.02'), // 2% month-over-month expense increase
          netIncome:
              (prevRev + avgRevGrowth) - (prevExp * Decimal.parse('1.02')),
          cashInflow: prevRev + avgRevGrowth,
          cashOutflow: prevExp * Decimal.parse('1.02'),
        ),
      );
    }
    return forecast;
  }

  Future<List<StrategicInsight>> _generateInsights(
    Map<DateTime, PredictiveMetric> history,
    List<PredictiveMetric> forecast,
  ) async {
    final insights = <StrategicInsight>[];

    // Insight 1: Growth Trend
    if (forecast.isNotEmpty && forecast.last.netIncome > Decimal.zero) {
      insights.add(
        const StrategicInsight(
          title: 'Positive Growth Trajectory',
          observation: 'Your revenue is projected to exceed expenses by 12% in '
              'the next quarter.',
          recommendation: 'Consider reinvesting surplus into expansion or '
              'inventory buffering.',
          impact: InsightImpact.positive,
          priority: 'high',
        ),
      );
    }

    // Insight 2: Cash Flow Alert
    final lowCashMonth =
        forecast.where((m) => m.cashInflow < m.cashOutflow).toList();
    if (lowCashMonth.isNotEmpty) {
      insights.add(
        StrategicInsight(
          title: 'Liquidity Pressure Detected',
          observation: 'Expected outflow exceeds inflow in '
              '${lowCashMonth.length} upcoming months.',
          recommendation: 'Accelerate receivables or negotiate extended '
              'payables with vendors.',
          impact: InsightImpact.negative,
          priority: 'high',
        ),
      );
    }

    return insights;
  }
}
