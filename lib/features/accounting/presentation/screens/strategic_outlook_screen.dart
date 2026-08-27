import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/application/strategic_forecast_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/strategic_outlook.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
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
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(strategicForecastNotifierProvider),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, StrategicOutlook outlook) =>
      SingleChildScrollView(
        padding: Spacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfidenceBar(context, outlook.confidenceScore),
            const SizedBox(height: Spacing.xl),
            _buildChartSection(
              context,
              context.l10n.labelPredictivePnL,
              _buildPnLChart(context, outlook.pnlForecast),
            ),
            const SizedBox(height: Spacing.xl),
            _buildInsightsSection(context, outlook.insights),
            const SizedBox(height: Spacing.xl),
            _buildChartSection(
              context,
              context.l10n.labelCashFlowProjection,
              _buildCashFlowChart(context, outlook.cashFlowForecast),
            ),
          ],
        ),
      );

  Widget _buildConfidenceBar(BuildContext context, double score) => GlassCard(
        child: Padding(
          padding: Spacing.paddingMd,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.labelConfidenceScore,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${(score * 100).toStringAsFixed(0)}%',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              LinearProgressIndicator(
                value: score,
                backgroundColor: AppColors.surface,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
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
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
            child: Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          GlassCard(
            child: Container(
              height: 250,
              padding: const EdgeInsets.fromLTRB(
                Spacing.md,
                Spacing.xl,
                Spacing.md,
                Spacing.md,
              ),
              child: chart,
            ),
          ),
        ],
      );

  Widget _buildPnLChart(BuildContext context, List<PredictiveMetric> forecast) {
    if (forecast.isEmpty) {
      return _buildCompactEmptyChartState(context);
    }

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
                  padding: const EdgeInsets.only(top: Spacing.xs),
                  child: Text(
                    DateFormat.MMM().format(forecast[index].period),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
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
            AppColors.success,
          ),
          _generateLine(
            forecast,
            (m) => m.expense.toDouble(),
            AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowChart(
    BuildContext context,
    List<PredictiveMetric> forecast,
  ) {
    if (forecast.isEmpty) {
      return _buildCompactEmptyChartState(context);
    }

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
                  padding: const EdgeInsets.only(top: Spacing.xs),
                  child: Text(
                    DateFormat.MMM().format(forecast[index].period),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
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
                    ? AppColors.primary
                    : AppColors.warning,
                width: 12,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactEmptyChartState(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.insights_outlined,
              color: AppColors.textHint,
              size: IconSizes.lg,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              context.l10n.msgNoStrategicData,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

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
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
            child: Text(
              context.l10n.labelStrategicInsights,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          if (insights.isEmpty)
            AppEmptyState(
              title: context.l10n.msgNoStrategicData,
            )
          else
            ...insights.map((insight) => _buildInsightCard(context, insight)),
        ],
      );

  Widget _buildInsightCard(BuildContext context, StrategicInsight insight) {
    final color = insight.impact == InsightImpact.positive
        ? AppColors.success
        : insight.impact == InsightImpact.negative
            ? AppColors.error
            : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: GlassCard(
        child: Padding(
          padding: Spacing.paddingMd,
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
                    size: IconSizes.md,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    insight.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                insight.observation,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: Spacing.md),
              Container(
                padding: Spacing.paddingSm,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.warning,
                      size: IconSizes.sm,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Text(
                        insight.recommendation,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
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
