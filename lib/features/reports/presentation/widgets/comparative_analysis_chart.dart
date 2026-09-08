import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// A glassmorphic chart for comparative financial analysis.
///
/// Visualizes Current vs Prior periods or Budget vs Actuals using
/// a premium bar chart representation.
class ComparativeAnalysisChart extends StatelessWidget {
  /// Creates a comparative analysis chart.
  const ComparativeAnalysisChart({
    required this.currentData,
    required this.priorData,
    required this.labels,
    required this.title,
    super.key,
  });

  /// The numerical data points for the "Current" period.
  final List<double> currentData;

  /// The numerical data points for the "Prior" period.
  final List<double> priorData;

  /// Labels for the X-axis (e.g., Months or Categories).
  final List<String> labels;

  /// The title of the analysis (e.g., "Revenue Comparison").
  final String title;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.1),
          borderRadius: Radii.borderRadiusLg,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: Spacing.xs,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildLegend(),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _calculateMaxY(),
                  barTouchData: const BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= labels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[index],
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    currentData.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: currentData[index],
                          color: AppColors.primary,
                          width: 8,
                          borderRadius: Radii.borderRadiusXs,
                        ),
                        BarChartRodData(
                          toY: priorData[index],
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 8,
                          borderRadius: Radii.borderRadiusXs,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildLegend() => Row(
        children: [
          _buildLegendItem('Current', AppColors.primary),
          const SizedBox(width: Spacing.sm),
          _buildLegendItem('Prior', AppColors.primary.withValues(alpha: 0.3)),
        ],
      );

  Widget _buildLegendItem(String label, Color color) => Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: Radii.borderRadiusSm,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
          ),
        ],
      );

  double _calculateMaxY() {
    double maxVal = 0;
    for (final v in currentData) {
      if (v > maxVal) maxVal = v;
    }
    for (final v in priorData) {
      if (v > maxVal) maxVal = v;
    }
    return maxVal * 1.2;
  }
}
