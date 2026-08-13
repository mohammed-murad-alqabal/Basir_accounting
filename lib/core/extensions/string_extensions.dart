/// امتدادات مساعدة على النصوص لدعم بحث عربي مرن.
library;

/// تطبيع النص العربي: إزالة التشكيل (الحركات) وتوحيد أشكال الألف والهمزات
/// والهاء/التاء المربوطة، مما يتيح البحث بتهجئة مرنة.
///
/// مثال: "مؤسَّسة الأمل" و"مؤسسة الامال" و"مؤسسة الأمل" كلها تتطابق بعد
/// التطبيع مع الاستعلام "الامل".
extension StringArabicNormalization on String {
  /// يعيد نسخة مطبّعة من النص مناسبة للمقارنة والبحث.
  String normalizeArabic() {
    var normalized = this;

    // إزالة التشكيل (الحركات)
    normalized = normalized.replaceAll(
      RegExp(
        r'[\u0610-\u061A\u064B-\u0652\u0670\u06D6-\u06DC'
        r'\u06DF-\u06E8\u06EA-\u06ED]',
      ),
      '',
    );

    // توحيد أشكال الألف: أ إ آ ٱ -> ا
    normalized = normalized.replaceAll(RegExp('[أإآٱ]'), 'ا');

    // توحيد الألف المقصورة والياء: ى -> ي
    normalized = normalized.replaceAll('ى', 'ي');

    // توحيد الهاء والتاء المربوطة: ة -> ه
    normalized = normalized.replaceAll('ة', 'ه');

    // توحيد أشكال الهمزة المفردة
    normalized = normalized.replaceAll(RegExp('[ؤئ]'), 'ء');

    return normalized;
  }
}
