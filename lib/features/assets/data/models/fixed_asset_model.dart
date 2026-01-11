import 'package:basir_accounting_system/features/assets/domain/entities/fixed_asset.dart';
import 'package:isar/isar.dart';

part 'fixed_asset_model.g.dart';

/// نموذج الأصل الثابت لقاعدة بيانات Isar
@Collection()
class FixedAssetModel {
  /// إنشاء نموذج أصل ثابت
  FixedAssetModel();

  /// تحويل الكيان إلى نموذج
  factory FixedAssetModel.fromEntity(FixedAsset asset) => FixedAssetModel()
    ..id = asset.id ?? ''
    ..code = asset.code
    ..nameAr = asset.nameAr
    ..nameEn = asset.nameEn
    ..categoryId = asset.categoryId
    ..acquisitionDate = asset.acquisitionDate
    ..cost = asset.cost
    ..residualValue = asset.residualValue
    ..usefulLifeYears = asset.usefulLifeYears
    ..depreciationMethod = asset.depreciationMethod
    ..assetAccountId = asset.assetAccountId
    ..depreciationAccountId = asset.depreciationAccountId
    ..accumDepreciationAccountId = asset.accumDepreciationAccountId
    ..accumulatedDepreciation = asset.accumulatedDepreciation
    ..isActive = asset.isActive;

  /// معرف Isar التلقائي
  Id isarId = Isar.autoIncrement;

  /// المعرف الفريد (UUID)
  @Index(unique: true)
  late String id;

  /// كود الأصل (SKU)
  @Index(unique: true)
  late String code;

  /// الاسم بالعربية
  late String nameAr;

  /// الاسم بالإنجليزية
  late String nameEn;

  /// معرف الفئة
  late String categoryId;

  /// تاريخ الاستحواذ
  late DateTime acquisitionDate;

  /// التكلفة التاريخية
  late double cost;

  /// القيمة المتبقية
  late double residualValue;

  /// العمر الإنتاجي بالسنوات
  late int usefulLifeYears;

  /// طريقة الاستهلاك
  late String depreciationMethod;

  /// معرف حساب الأصل
  late String assetAccountId;

  /// معرف حساب الاستهلاك
  late String depreciationAccountId;

  /// معرف حساب مجمع الاستهلاك
  late String accumDepreciationAccountId;

  /// مجمع الاستهلاك الحالي
  late double accumulatedDepreciation;

  /// هل الأصل نشط
  late bool isActive;

  /// معرف المستخدم
  String? userId;

  /// تحويل النموذج إلى كيان
  FixedAsset toEntity() => FixedAsset(
        id: id,
        code: code,
        nameAr: nameAr,
        nameEn: nameEn,
        categoryId: categoryId,
        acquisitionDate: acquisitionDate,
        cost: cost,
        residualValue: residualValue,
        usefulLifeYears: usefulLifeYears,
        depreciationMethod: depreciationMethod,
        assetAccountId: assetAccountId,
        depreciationAccountId: depreciationAccountId,
        accumDepreciationAccountId: accumDepreciationAccountId,
        accumulatedDepreciation: accumulatedDepreciation,
        isActive: isActive,
      );
}
