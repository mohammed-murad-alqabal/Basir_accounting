import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/features/accounting/application/financial_reporting_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// رسم بياني يوضح توزيع المصروفات (Pie Chart)
class ExpenseCompositionChart extends ConsumerStatefulWidget {
  /// إنشاء الرسم البياني
  const ExpenseCompositionChart({super.key});

  @override
  @override
  ConsumerState<ExpenseCompositionChart> createState() =>
      _ExpenseCompositionChartState();
}

class _ExpenseCompositionChartState
    extends ConsumerState<ExpenseCompositionChart> {
  late Future<Map<String, double>> _compositionFuture;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _compositionFuture = _compositionFuture = ref
        .read(financialReportingServiceProvider.notifier)
        .getExpenseComposition();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, double>>(
        future: _compositionFuture,
        builder: (context, snapshot) {
          // ... existing builder logic ...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? {};
          if (data.isEmpty || data.values.every((v) => v == 0)) {
            return Center(child: Text(context.l10n.noExpenseDataMessage));
          }

          return Row(
            children: <Widget>[
              const SizedBox(height: 18),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: _showingSections(data),
                    ),
                  ),
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              const SizedBox(width: 28),
            ],
          );
        },
      );

  List<PieChartSectionData> _showingSections(Map<String, double> data) {
    final sections = <PieChartSectionData>[];
    final keys = data.keys.toList();
    final total = data.values.fold<double>(0, (sum, val) => sum + val);

    // Color palette
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.teal,
    ];

    for (var i = 0; i < keys.length; i++) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final rawKey = keys[i];
      final key = rawKey.isEmpty ? context.l10n.otherExpensesLabel : rawKey;
      final value = data[rawKey]!;
      final percentage = (value / total * 100).toStringAsFixed(1);
      final color = colors[i % colors.length];

      sections.add(
        PieChartSectionData(
          color: color,
          value: value,
          title: '$percentage%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [Shadow(blurRadius: 2)],
          ),
          badgeWidget: _Badge(key, size: 40, borderColor: color),
          badgePositionPercentageOffset: .98,
        ),
      );
    }
    return sections;
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, {required this.size, required this.borderColor});
  final String text;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: PieChart.defaultDuration,
        width: size * 2, // Wider for text
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size / 2),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              offset: const Offset(3, 3),
              blurRadius: 3,
            ),
          ],
        ),
        padding: const EdgeInsets.all(4),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
}
