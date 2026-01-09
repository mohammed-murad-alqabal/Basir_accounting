import 'package:basir_app/features/reports/application/analytics_service.dart';
import 'package:basir_app/features/reports/application/basir_insights_engine.dart';
import 'package:basir_app/features/reports/domain/entities/financial_kpi.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntelligenceScreen extends ConsumerWidget {
  const IntelligenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpisAsync =
        ref.watch(analyticsServiceProvider.notifier).getFinancialKpis();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الذكاء المالي (Analytics Hub)'),
      ),
      body: FutureBuilder<List<FinancialKpi>>(
        future: kpisAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final kpis = snapshot.data ?? [];
          final insights = ref
              .read(basirInsightsEngineProvider.notifier)
              .generateInsights(kpis);

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(analyticsServiceProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInsightsSection(context, insights),
                const SizedBox(height: 24),
                _buildKpiGrid(context, kpis),
                const SizedBox(height: 24),
                _buildTrendChart(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInsightsSection(BuildContext context, List<String> insights) =>
      Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'رؤى بصير (AI Insights)',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...insights.map(
                (insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(insight)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildKpiGrid(BuildContext context, List<FinancialKpi> kpis) =>
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: kpis.length,
        itemBuilder: (context, index) {
          final kpi = kpis[index];
          return _buildKpiCard(context, kpi);
        },
      );

  Widget _buildKpiCard(BuildContext context, FinancialKpi kpi) {
    final color = kpi.health == KpiHealth.healthy
        ? Colors.green
        : (kpi.health == KpiHealth.warning ? Colors.orange : Colors.red);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(kpi.name, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              '${kpi.value.toStringAsFixed(kpi.unit == 'x' ? 1 : 0)} ${kpi.unit}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  kpi.trend >= 0 ? Icons.trending_up : Icons.trending_down,
                  size: 14,
                  color: kpi.trend >= 0 ? Colors.green : Colors.red,
                ),
                Text(
                  ' ${(kpi.trend * 100).abs().toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: kpi.trend >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendChart(BuildContext context) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اتجاه التدفق النقدي (Cash Flow Trend)',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 10),
                          FlSpot(1, 15),
                          FlSpot(2, 12),
                          FlSpot(3, 22),
                          FlSpot(4, 18),
                          FlSpot(5, 30),
                        ],
                        isCurved: true,
                        color: Theme.of(context).colorScheme.primary,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
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
