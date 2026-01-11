import 'package:basir_accounting_system/features/assets/domain/entities/asset_category.dart';
import 'package:basir_accounting_system/features/assets/domain/entities/fixed_asset.dart';

/// واجهة مستودع الأصول (Asset Repository Interface)
abstract class AssetRepository {
  /// جلب جميع الأصول الثابتة
  Future<List<FixedAsset>> getAllAssets();

  /// جلب جميع فئات الأصول
  Future<List<AssetCategory>> getAllCategories();

  /// إضافة أصل ثابت جديد
  Future<void> addAsset(FixedAsset asset);

  /// إضافة فئة أصل جديدة
  Future<void> addCategory(AssetCategory category);

  /// تحديث بيانات أصل ثابت
  Future<void> updateAsset(FixedAsset asset);

  /// تحديث بيانات فئة أصل
  Future<void> updateCategory(AssetCategory category);

  /// حذف أصل ثابت
  Future<void> deleteAsset(String id);

  /// حذف فئة أصل
  Future<void> deleteCategory(String id);

  /// البحث عن الأصول
  Future<List<FixedAsset>> searchAssets(String query);
}
