/// تصنيفات IFRS 18 لقائمة الأرباح أو الخسائر.
enum Ifrs18Category {
  /// الدخل والمصروفات من الأنشطة التجارية الرئيسية.
  operating,

  /// الدخل والمصروفات من الاستثمارات في الشركات الزميلة/المشاريع المشتركة.
  investing,

  /// الدخل والمصروفات من أنشطة التمويل (القروض، إلخ).
  financing,

  /// مصروف أو دخل ضريبة الدخل.
  incomeTax,

  /// النتائج من العمليات المتوقفة.
  discontinued,

  /// لا ينطبق (للحسابات الميزانية مثلاً).
  none,
}

/// يمثل مقياس أداء الإدارة (MPM) حسب متطلبات IFRS 18.
class ManagementPerformanceMeasure {
  /// إنشاء مقياس أداء الإدارة.
  const ManagementPerformanceMeasure({
    required this.name,
    required this.description,
    required this.value,
    required this.reconciliationToIfrs,
  });

  /// اسم المقياس التدريري.
  final String name;

  /// شرح المقياس.
  final String description;

  /// قيمة المقياس.
  final double value;

  /// تسوية المقياس مع أرقام IFRS.
  final String reconciliationToIfrs;
}
