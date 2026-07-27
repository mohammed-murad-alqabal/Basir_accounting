// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/features/reports/application/basir_insights_engine.dart';
import 'package:basir_accounting_system/features/reports/application/financial_intelligence_service.dart';
import 'package:basir_accounting_system/features/reports/application/simulation_service.dart';
import 'package:basir_accounting_system/features/reports/domain/entities/financial_kpi.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة الذكاء المالي (Intelligence Screen)
///
/// تعرض مؤشرات الأداء المالي والرؤى الناتجة عن محرك التحليلات.
class IntelligenceScreen extends ConsumerWidget {
  /// إنشاء شاشة الذكاء المالي.
  const IntelligenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpisAsync = ref
        .watch(financialIntelligenceServiceProvider.notifier)
        .getFinancialKpis();

    return GlassScaffold(
      title: 'الذكاء المالي (Analytics Hub)',
      actions: [
        IconButton(
          icon: const Icon(Icons.auto_fix_high),
          tooltip: 'بذر بيانات تجريبية',
          onPressed: () async {
            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
            await ref
                .read(financialSimulationServiceProvider.notifier)
                .seedRealisticData();
            if (context.mounted) {
              Navigator.pop(context);
              ref.invalidate(financialIntelligenceServiceProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم بذر البيانات بنجاح')),
              );
            }
          },
        ),
      ],
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
            onRefresh: () async =>
                ref.refresh(financialIntelligenceServiceProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInsightsSection(context, insights),
                const SizedBox(height: 24),
                _buildKpiGrid(context, kpis),
                const SizedBox(height: 24),
                FutureBuilder<List<double>>(
                  future: ref
                      .read(financialIntelligenceServiceProvider.notifier)
                      .getCashFlowTrend(),
                  builder: (context, trendSnapshot) {
                    if (trendSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return _buildTrendChart(context, trendSnapshot.data ?? []);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInsightsSection(
    BuildContext context,
    List<AgentInsight> insights,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'رؤى الوكلاء الأذكياء (Agent Insights)',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...insights.map((insight) => _buildInsightCard(context, insight)),
        ],
      );

  Widget _buildInsightCard(BuildContext context, AgentInsight insight) {
    // Determine color and icon based on risk and source
    final color = _getRiskColor(insight.riskLevel);
    final icon = _getAgentIcon(insight.source);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insight.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        _getAgentName(insight.source),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
                if (insight.riskLevel != InsightRiskLevel.info)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getRiskLabel(insight.riskLevel),
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(insight.description),
            if (insight.actionLabel != null && insight.actionRoute != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: () {
                    // Navigation logic would go here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Navigating to ${insight.actionRoute}...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(insight.actionLabel!),
                  style: TextButton.styleFrom(
                    foregroundColor: color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getRiskColor(InsightRiskLevel level) {
    switch (level) {
      case InsightRiskLevel.critical:
        return Colors.red.shade900;
      case InsightRiskLevel.high:
        return Colors.red;
      case InsightRiskLevel.medium:
        return Colors.orange;
      case InsightRiskLevel.low:
        return Colors.amber;
      case InsightRiskLevel.info:
        return Colors.blue;
    }
  }

  IconData _getAgentIcon(AgentSource source) {
    switch (source) {
      case AgentSource.strategist:
        return Icons.trending_up;
      case AgentSource.tax:
        return Icons.account_balance;
      case AgentSource.forensic:
        return Icons.security;
      case AgentSource.operational:
        return Icons.inventory_2;
      case AgentSource.sustainability:
        return Icons.eco;
    }
  }

  String _getAgentName(AgentSource source) {
    switch (source) {
      case AgentSource.strategist:
        return 'المسؤول الاستراتيجي';
      case AgentSource.tax:
        return 'خبير الضرائب';
      case AgentSource.forensic:
        return 'الحارس القضائي';
      case AgentSource.operational:
        return 'خبير العمليات';
      case AgentSource.sustainability:
        return 'خبير الاستدامة';
    }
  }

  String _getRiskLabel(InsightRiskLevel level) {
    switch (level) {
      case InsightRiskLevel.critical:
        return 'حرج جداً';
      case InsightRiskLevel.high:
        return 'عالي الخطورة';
      case InsightRiskLevel.medium:
        return 'متوسط الخطورة';
      case InsightRiskLevel.low:
        return 'منخفص الخطورة';
      case InsightRiskLevel.info:
        return 'معلومة';
    }
  }

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
              '${kpi.value.toStringAsFixed(kpi.unit == 'x' ? 1 : 0)} '
              '${kpi.unit}',
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

  Widget _buildTrendChart(BuildContext context, List<double> trend) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اتجاه التدفق النقدي (30 يوم)',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: trend.isEmpty
                    ? const Center(
                        child: Text('لا توجد بيانات كافية للرسم البياني'),
                      )
                    : LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: trend
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                                  .toList(),
                              isCurved: true,
                              color: Theme.of(context).colorScheme.primary,
                              barWidth: 4,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
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
