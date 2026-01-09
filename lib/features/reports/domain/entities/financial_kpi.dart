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
