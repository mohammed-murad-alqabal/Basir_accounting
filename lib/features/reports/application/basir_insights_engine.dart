import 'package:basir_accounting_system/features/reports/domain/entities/financial_kpi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'basir_insights_engine.g.dart';

/// محرك الرؤى المالية (Basir Insights Engine)
///
/// يقوم بتحليل مؤشرات الأداء المالي وتقديم نصائح برمجية آلية
/// منبثقة من وكلاء الذكاء الاصطناعي (Cognitive Agents).
@riverpod
class BasirInsightsEngine extends _$BasirInsightsEngine {
  @override
  void build() {}

  /// توليد رؤى قابلة للتنفيذ بناءً على مؤشرات الأداء المالي.
  List<AgentInsight> generateInsights(List<FinancialKpi> kpis) {
    final insights = <AgentInsight>[];
    final now = DateTime.now();

    for (final kpi in kpis) {
      // 1. Financial Strategist Insights
      if (kpi.name == 'Current Ratio' && kpi.value < 1.2) {
        insights.add(
          AgentInsight(
            id: 'insight-liquidity-${now.millisecondsSinceEpoch}',
            source: AgentSource.strategist,
            riskLevel: InsightRiskLevel.high,
            title: 'انخفاض السيولة النقدية',
            description:
                'نسبة التداول الحالية (${kpi.value}) أقل من المعدل الآمن (1.5). '
                'يوصى بتأجيل المدفوعات غير الضرورية.',
            timestamp: now,
            actionLabel: 'تحليل التدفق النقدي',
            actionRoute: '/reports/financial',
          ),
        );
      }

      if (kpi.name == 'Burn Rate' && kpi.trend > 0.1) {
        insights.add(
          AgentInsight(
            id: 'insight-burn-${now.millisecondsSinceEpoch}',
            source: AgentSource.strategist,
            riskLevel: InsightRiskLevel.medium,
            title: 'تسارع في معدل الاستنزاف',
            description:
                'معدل الاستنزاف النقدي زاد بنسبة ${(kpi.trend * 100).toStringAsFixed(0)}%. '
                'يجب مراجعة المصاريف التشغيلية فوراً.',
            timestamp: now,
            actionLabel: 'مراجعة الميزانية',
            actionRoute: '/reports/budget',
          ),
        );
      }

      if (kpi.name == 'Profit Margin' && kpi.value > 20) {
        insights.add(
          AgentInsight(
            id: 'insight-profit-${now.millisecondsSinceEpoch}',
            source: AgentSource.strategist,
            riskLevel: InsightRiskLevel.info,
            title: 'أداء ربحي ممتاز',
            description: 'هامش الربح (${kpi.value}%) يتجاوز المتوسط المستهدف.',
            timestamp: now,
          ),
        );
      }

      // 2. Tax Expert Insights
      if (kpi.name == 'VAT Liability' && kpi.trend > 0.15) {
        insights.add(
          AgentInsight(
            id: 'insight-vat-${now.millisecondsSinceEpoch}',
            source: AgentSource.tax,
            riskLevel: InsightRiskLevel.medium,
            title: 'زيادة التزامات الضريبة',
            description: 'ارتفعت مستحقات الزكاة والضريبة بشكل ملحوظ. '
                'تأكد من توفر السيولة لسداد الإقرار القادم.',
            timestamp: now,
            actionLabel: 'تقرير الضريبة الذكي',
            actionRoute: '/reports/tax-smart',
          ),
        );
      }
    }

    // Default Insight if empty
    if (insights.isEmpty) {
      insights.add(
        AgentInsight(
          id: 'insight-stable-${now.millisecondsSinceEpoch}',
          source: AgentSource.strategist,
          riskLevel: InsightRiskLevel.info,
          title: 'الوضع المالي مستقر',
          description: 'لا توجد تنبيهات حرجة حالياً. استمر في مراقبة الأداء.',
          timestamp: now,
        ),
      );
    }

    return insights;
  }
}
