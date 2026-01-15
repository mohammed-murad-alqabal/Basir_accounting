import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_kpi.freezed.dart';
part 'financial_kpi.g.dart';

/// الحالة الصحية لمؤشر الأداء المالي
enum KpiHealth {
  /// حالة جيدة
  healthy,

  /// حالة تنبيه
  warning,

  /// حالة حرجة
  critical,
}

/// مصدر الوكيل الذكي (Agent Source)
/// المكاتب المختلفة التي تصدر الرؤى في النظام المعرفي.
enum AgentSource {
  /// الاستراتيجي المالي (Strategist)
  strategist,

  /// خبير الضرائب (Tax)
  tax,

  /// الحارس القضائي (Forensic)
  forensic,

  /// خبير العمليات (Operational)
  operational,

  /// خبير الاستدامة (Sustainability)
  sustainability,
}

/// مستوى المخاطرة أو الأهمية (Insight Risk Level)
/// يحدد مدى خطورة الرؤية الصادرة من الوكيل.
enum InsightRiskLevel {
  /// معلومة عادية (Info)
  info,

  /// تنبيه منخفض (Low)
  low,

  /// تنبيه متوسط (Medium)
  medium,

  /// تنبيه مرتفع (High)
  high,

  /// حالة حرجة جداً (Critical)
  critical,
}

/// رؤية ذكية من وكيل (Agent Insight)
@freezed
class AgentInsight with _$AgentInsight {
  /// إنشاء رؤية جديدة من وكيل ذكي
  const factory AgentInsight({
    required String id,
    required AgentSource source,
    required InsightRiskLevel riskLevel,
    required String title,
    required String description,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
    String? actionLabel,
    String? actionRoute,
  }) = _AgentInsight;

  /// إنشاء رؤية من JSON
  factory AgentInsight.fromJson(Map<String, dynamic> json) =>
      _$AgentInsightFromJson(json);
}

/// نموذج مؤشر الأداء المالي (Financial KPI)
@freezed
class FinancialKpi with _$FinancialKpi {
  /// إنشاء مؤشر أداء مالي جديد
  const factory FinancialKpi({
    /// اسم المؤشر
    required String name,

    /// قيمة المؤشر
    required double value,

    /// وحدة القياس (مثل % أو SAR)
    required String unit,

    /// الاتجاه (التغير المئوي عن الفترة السابقة)
    required double trend,

    /// الحالة الصحية للمؤشر
    required KpiHealth health,

    /// وصف أو تحليل للمؤشر
    required String description,
  }) = _FinancialKpi;

  /// إنشاء مؤشر من JSON
  factory FinancialKpi.fromJson(Map<String, dynamic> json) =>
      _$FinancialKpiFromJson(json);
}
