import 'package:basir_app/features/assets/domain/entities/asset_category.dart';
import 'package:isar/isar.dart';

part 'asset_category_model.g.dart';

/// نموذج فئة الأصل لقاعدة بيانات Isar
@Collection()
class AssetCategoryModel {
  /// إنشاء نموذج فئة الأصل
  AssetCategoryModel();

  /// تحويل الكيان إلى نموذج
  factory AssetCategoryModel.fromEntity(AssetCategory category) {
    final model = AssetCategoryModel();
    model.id = category.id ?? '';
    model.nameAr = category.nameAr;
    model.nameEn = category.nameEn;
    model.defaultDepreciationMethod = category.defaultDepreciationMethod;
    model.defaultUsefulLifeYears = category.defaultUsefulLifeYears;
    return model;
  }

  /// معرف Isar التلقائي
  Id isarId = Isar.autoIncrement;

  /// المعرف الفريد (UUID)
  @Index(unique: true)
  late String id;

  /// الاسم بالعربية
  late String nameAr;

  /// الاسم بالإنجليزية
  late String nameEn;

  /// طريقة الاستهلاك الافتراضية
  late String defaultDepreciationMethod;

  /// العمر الافتراضي بالسنوات
  late int defaultUsefulLifeYears;

  /// معرف المستخدم المرتبط
  String? userId;

  /// تحويل النموذج إلى كيان
  AssetCategory toEntity() => AssetCategory(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        defaultDepreciationMethod: defaultDepreciationMethod,
        defaultUsefulLifeYears: defaultUsefulLifeYears,
      );
}
