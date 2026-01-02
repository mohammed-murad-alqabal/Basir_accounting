import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// رسوم بيانية للوحة التحكم (Dashboard Charts)
class DashboardCharts extends ConsumerWidget {
  /// إنشاء مكون الرسوم البيانية
  const DashboardCharts({required this.data, super.key});

  /// بيانات لوحة التحكم المطلوب عرضها
  final DashboardData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIcons = ref.watch(appIconsProvider);

    return Column(
      children: [
        _buildSectionTitle(
          context,
          context.l10n.dashboardStatsTitle,
          appIcons.analytics,
        ),
        const SizedBox(height: Spacing.md),
        _buildSalesPerformanceCard(context),
        const SizedBox(height: Spacing.lg),
        _buildRevenueDistributionCard(context),
      ],
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    IconData icon,
  ) =>
      Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: Spacing.xs),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppTypography.titleMedium,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      );

  Widget _buildSalesPerformanceCard(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.md),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.dashboardStatsTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppTypography.bodyLarge,
              ),
            ),
            const SizedBox(height: Spacing.xl),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final keys = <credential-fixture>();
                          if (value.toInt() < keys.length) {
                            return Text(
                              keys[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.salesTrend.values
                          .toList()
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: primaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueDistributionCard(BuildContext context) => Card(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.dashboardStatsTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.bodyLarge,
                ),
              ),
              const SizedBox(height: Spacing.xl),
              SizedBox(
                height: 150,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        value: data.paidRevenue,
                        title: '',
                        color: AppColors.success,
                        radius: 20,
                      ),
                      PieChartSectionData(
                        value: data.pendingRevenue,
                        title: '',
                        color: AppColors.warning,
                        radius: 20,
                      ),
                      PieChartSectionData(
                        value: data.overdueRevenue,
                        title: '',
                        color: AppColors.error,
                        radius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Spacing.md),
              _buildLegend(context),
            ],
          ),
        ),
      );

  Widget _buildLegend(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(context.l10n.statusPaid, AppColors.success),
          _buildLegendItem(context.l10n.statusPending, AppColors.warning),
          _buildLegendItem(context.l10n.statusOverdue, AppColors.error),
        ],
      );

  Widget _buildLegendItem(String label, Color color) => Row(
        children: [
          Container(width: 10, height: 10, color: color),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      );
}
