import 'package:basir_accounting_system/features/reports/domain/entities/financial_kpi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'basir_insights_engine.g.dart';

/// محرك الرؤى المالية (Basir Insights Engine)
///
/// يقوم بتحليل مؤشرات الأداء المالي وتقديم نصائح برمجية آلية.
@riverpod
class BasirInsightsEngine extends _$BasirInsightsEngine {
  @override
  void build() {}

  /// توليد رؤى قابلة للتنفيذ بناءً على مؤشرات الأداء المالي.
  List<String> generateInsights(List<FinancialKpi> kpis) {
    final insights = <String>[];

    for (final kpi in kpis) {
      if (kpi.name == 'Current Ratio' && kpi.value < 1.2) {
        insights.add(
          'تنبيه: نسبة السيولة منخفضة (${kpi.value}). '
          'قد تواجه صعوبة في سداد الالتزامات قصيرة الأجل.',
        );
      }

      if (kpi.name == 'Burn Rate' && kpi.trend > 0.1) {
        insights.add(
          'ملاحظة: معدل الاستنزاف النقدي زاد بنسبة '
          '${(kpi.trend * 100).toStringAsFixed(0)}%. '
          'يفضل مراجعة المصاريف التشغيلية.',
        );
      }

      if (kpi.name == 'Profit Margin' && kpi.value > 20) {
        insights.add(
          'أداء ممتاز: هامش الربح (${kpi.value}%) يتجاوز المتوسط المستهدف.',
        );
      }
    }

    if (insights.isEmpty) {
      insights.add('النظام المالي مستقر. استمر في مراقبة التدفقات النقدية.');
    }

    return insights;
  }
}
