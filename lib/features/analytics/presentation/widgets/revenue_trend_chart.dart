import 'package:basir_app/features/accounting/application/financial_reporting_service.dart';
import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

/// رسم بياني يوضح اتجاه الإيرادات (Line Chart)
class RevenueTrendChart extends ConsumerStatefulWidget {
  /// إنشاء الرسم البياني
  const RevenueTrendChart({super.key});

  @override
  ConsumerState<RevenueTrendChart> createState() => _RevenueTrendChartState();
}

class _RevenueTrendChartState extends ConsumerState<RevenueTrendChart> {
  late Future<Map<DateTime, Decimal>> _trendFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _trendFuture =
        ref.read(financialReportingServiceProvider.notifier).getRevenueTrend();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<DateTime, Decimal>>(
        future: _trendFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? {};
          if (data.values.every((v) => v == Decimal.zero)) {
            // Show empty state or flat line
            // allowing flat line for now
          }

          final sortedKeys = data.keys.toList()..sort();
          final spots = <FlSpot>[];
          double maxY = 0;

          for (var i = 0; i < sortedKeys.length; i++) {
            final date = sortedKeys[i];
            final value = data[date]!.toDouble();
            spots.add(FlSpot(i.toDouble(), value));
            if (value > maxY) maxY = value;
          }

          // Add some padding to maxY
          maxY = maxY * 1.2;
          if (maxY == 0) maxY = 100;

          return AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    horizontalInterval: maxY / 5,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) =>
                        const FlLine(color: Colors.grey, strokeWidth: 1),
                    getDrawingVerticalLine: (value) =>
                        const FlLine(color: Colors.grey, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < sortedKeys.length) {
                            final date = sortedKeys[index];
                            // Show month name (e.g. Jan, Feb or numeric 1, 2)
                            // Using numeric for compactness or simplified name
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                intl.DateFormat('MMM').format(date),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: maxY / 5,
                        getTitlesWidget: (value, meta) => Text(
                          _formatCurrency(value),
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.left,
                        ),
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  minX: 0,
                  maxX: sortedKeys.length.toDouble() - 1,
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [Colors.cyan, Colors.blue],
                      ),
                      barWidth: 5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan.withValues(alpha: 0.3),
                            Colors.blue.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

  String _formatCurrency(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(0);
  }
}
