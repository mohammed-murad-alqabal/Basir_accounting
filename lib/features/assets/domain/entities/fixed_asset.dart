import 'package:freezed_annotation/freezed_annotation.dart';

part 'fixed_asset.freezed.dart';
part 'fixed_asset.g.dart';

/// كيان الأصل الثابت (Fixed Asset Entity)
///
/// يمثل أصلاً ثابتاً (مثلاً: سيارة، مبنى)
/// مع دعم التسمية ثنائية اللغة وحساب الإهلاك.
@freezed
class FixedAsset with _$FixedAsset {
  /// إنشاء كيان أصل ثابت جديد.
  const factory FixedAsset({
    /// كود الأصل (مثلاً: AST-001)
    required String code,

    /// الاسم بالعربية
    required String nameAr,

    /// الاسم بالإنجليزية
    required String nameEn,

    /// معرف الفئة
    required String categoryId,

    /// تاريخ الاستحواذ
    required DateTime acquisitionDate,

    /// التكلفة التاريخية
    required double cost,

    /// القيمة المتبقية (الخرداة)
    required double residualValue,

    /// العمر الإنتاجي بالسنوات
    required int usefulLifeYears,

    /// طريقة الإهلاك
    required String depreciationMethod,

    /// معرف حساب الأصل
    required String assetAccountId,

    /// معرف حساب مصروف الإهلاك
    required String depreciationAccountId,

    /// معرف حساب مجمع الإهلاك
    required String accumDepreciationAccountId,

    /// مجمع الإهلاك الحالي
    @Default(0.0) double accumulatedDepreciation,

    /// معرف فريد للأصل
    String? id,

    /// هل الأصل ما زال نشطاً (قيد الاستخدام)
    @Default(true) bool isActive,
  }) = _FixedAsset;

  /// إنشاء أصل ثابت من JSON.
  factory FixedAsset.fromJson(Map<String, dynamic> json) {
    final result = _$FixedAssetFromJson(json);
    return result;
  }
  const FixedAsset._();

  /// الحصول على الاسم حسب اللغة
  String name({required bool isArabic}) => isArabic ? nameAr : nameEn;
}
