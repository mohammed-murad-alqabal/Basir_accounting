import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/features/accounting/application/strategic_forecast_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/strategic_outlook.dart';
import 'package:basir_accounting_system/shared/widgets/glass_card.dart';
import 'package:basir_accounting_system/shared/widgets/glass_scaffold.dart';
import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Screen for visualizing strategic financial outlook and forecasting.
class StrategicOutlookScreen extends ConsumerWidget {
  /// Creates a [StrategicOutlookScreen].
  const StrategicOutlookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlookAsync = ref.watch(strategicForecastNotifierProvider);

    return GlassScaffold(
      title: context.l10n.titleStrategicOutlook,
      body: outlookAsync.when(
        data: (outlook) => _buildContent(context, outlook),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, StrategicOutlook outlook) =>
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfidenceBar(context, outlook.confidenceScore),
            const SizedBox(height: 24),
            _buildChartSection(
              context,
              context.l10n.labelPredictivePnL,
              _buildPnLChart(outlook.pnlForecast),
            ),
            const SizedBox(height: 24),
            _buildInsightsSection(context, outlook.insights),
            const SizedBox(height: 24),
            _buildChartSection(
              context,
              context.l10n.labelCashFlowProjection,
              _buildCashFlowChart(outlook.cashFlowForecast),
            ),
          ],
        ),
      );

  Widget _buildConfidenceBar(BuildContext context, double score) => GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.labelConfidenceScore,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '${(score * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: score,
                backgroundColor: Colors.white10,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      );

  Widget _buildChartSection(BuildContext context, String title, Widget chart) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            child: Container(
              height: 250,
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              child: chart,
            ),
          ),
        ],
      );

  Widget _buildPnLChart(List<PredictiveMetric> forecast) {
    if (forecast.isEmpty) return const Center(child: Text('No data'));

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= forecast.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat.MMM().format(forecast[index].period),
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          _generateLine(
            forecast,
            (m) => m.revenue.toDouble(),
            Colors.greenAccent,
          ),
          _generateLine(
            forecast,
            (m) => m.expense.toDouble(),
            Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowChart(List<PredictiveMetric> forecast) {
    if (forecast.isEmpty) return const Center(child: Text('No data'));

    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= forecast.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat.MMM().format(forecast[index].period),
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          forecast.length,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: forecast[i].netIncome.toDouble(),
                color: forecast[i].netIncome >= Decimal.zero
                    ? Colors.blueAccent
                    : Colors.orangeAccent,
                width: 12,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartBarData _generateLine(
    List<PredictiveMetric> forecast,
    double Function(PredictiveMetric) selector,
    Color color,
  ) =>
      LineChartBarData(
        spots: List.generate(
          forecast.length,
          (i) => FlSpot(i.toDouble(), selector(forecast[i])),
        ),
        isCurved: true,
        color: color,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: color.withValues(alpha: 0.1),
        ),
      );

  Widget _buildInsightsSection(
    BuildContext context,
    List<StrategicInsight> insights,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              context.l10n.labelStrategicInsights,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          if (insights.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  context.l10n.msgNoStrategicData,
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
            )
          else
            ...insights.map((insight) => _buildInsightCard(context, insight)),
        ],
      );

  Widget _buildInsightCard(BuildContext context, StrategicInsight insight) {
    final color = insight.impact == InsightImpact.positive
        ? Colors.greenAccent
        : insight.impact == InsightImpact.negative
            ? Colors.redAccent
            : Colors.blueAccent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    insight.impact == InsightImpact.positive
                        ? Icons.trending_up
                        : Icons.lightbulb_outline,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    insight.title,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                insight.observation,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.amberAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        insight.recommendation,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
