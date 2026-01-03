/// أنواع مقاييس الاستدامة حسب معايير ISSB (IFRS S1 & S2).
enum SustainabilityMetricType {
  /// انبعاثات الغازات الدفيئة المباشرة.
  emissionsScope1,

  /// انبعاثات الغازات الدفيئة غير المباشرة من الكهرباء المشتراة، إلخ.
  emissionsScope2,

  /// انبعاثات الغازات الدفيئة غير المباشرة الأخرى في سلسلة القيمة.
  emissionsScope3,

  /// المخاطر الفيزيائية المتعلقة بالمناخ.
  physicalClimateRisk,

  /// مخاطر الانتقال المتعلقة بالمناخ.
  transitionClimateRisk,

  /// مقاييس الموارد الطبيعية والتنوع البيولوجي.
  naturalResources,
}

/// يمثل قياساً محدداً للاستدامة مرتبطاً بفترة مالية.
class SustainabilityMetric {
  /// إنشاء مقياس استدامة.
  const SustainabilityMetric({
    required this.type,
    required this.value,
    required this.unit,
    required this.measuredAt,
    required this.methodology,
  });

  /// نوع المقياس.
  final SustainabilityMetricType type;

  /// القيمة الرقمية للقياس.
  final double value;

  /// وحدة القياس (مثال: طن من ثاني أكسيد الكربون).
  final String unit;

  /// تاريخ ووقت القياس.
  final DateTime measuredAt;

  /// المنهجية المستخدمة في القياس.
  final String methodology;
}
