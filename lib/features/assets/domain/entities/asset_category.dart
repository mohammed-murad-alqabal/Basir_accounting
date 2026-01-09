import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_category.freezed.dart';
part 'asset_category.g.dart';

/// فئة الأصل (Asset Category)
///
/// تمثل تصنيفاً للأصول الثابتة (مثلاً: عقارات، آلات)
/// مع دعم التسمية ثنائية اللغة.
@freezed
class AssetCategory with _$AssetCategory {
  /// إنشاء فئة أصل جديدة.
  const factory AssetCategory({
    /// اسم الفئة بالعربية
    required String nameAr,

    /// اسم الفئة بالإنجليزية
    required String nameEn,

    /// طريقة الإهلاك الافتراضية
    required String defaultDepreciationMethod,

    /// العمر الإنتاجي الافتراضي (بالسنوات)
    required int defaultUsefulLifeYears,

    /// معرف فريد للفئة
    String? id,
  }) = _AssetCategory;

  /// إنشاء فئة من JSON.
  factory AssetCategory.fromJson(Map<String, dynamic> json) {
    final result = _$AssetCategoryFromJson(json);
    return result;
  }
}
