import 'package:basir_app/features/assets/data/models/asset_category_model.dart';
import 'package:basir_app/features/assets/data/models/fixed_asset_model.dart';
import 'package:basir_app/features/assets/domain/entities/asset_category.dart';
import 'package:basir_app/features/assets/domain/entities/fixed_asset.dart';
import 'package:basir_app/features/assets/domain/repositories/asset_repository.dart';
import 'package:isar/isar.dart';

/// تطبيق مستودع الأصول (Asset Repository Implementation)
class AssetRepositoryImpl implements AssetRepository {
  /// إنشاء مستودع الأصول
  AssetRepositoryImpl({required this.isar, required this.userId});

  /// قاعدة بيانات Isar
  final Isar isar;

  /// معرف المستخدم الحالي
  final String? userId;

  @override
  Future<List<FixedAsset>> getAllAssets() async {
    try {
      final models =
          await isar.fixedAssetModels.filter().userIdEqualTo(userId).findAll();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw Exception('خطأ في جلب الأصول: $e');
    }
  }

  @override
  Future<List<AssetCategory>> getAllCategories() async {
    try {
      final models = await isar.assetCategoryModels
          .filter()
          .userIdEqualTo(userId)
          .findAll();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw Exception('خطأ في جلب الفئات: $e');
    }
  }

  @override
  Future<void> addAsset(FixedAsset asset) async {
    try {
      final model = FixedAssetModel.fromEntity(asset)..userId = userId;
      await isar.writeTxn(() => isar.fixedAssetModels.put(model));
    } catch (e) {
      throw Exception('خطأ في إضافة الأصل: $e');
    }
  }

  @override
  Future<void> addCategory(AssetCategory category) async {
    try {
      final model = AssetCategoryModel.fromEntity(category)..userId = userId;
      await isar.writeTxn(() => isar.assetCategoryModels.put(model));
    } catch (e) {
      throw Exception('خطأ في إضافة الفئة: $e');
    }
  }

  @override
  Future<void> updateAsset(FixedAsset asset) async {
    try {
      await isar.writeTxn(() async {
        final existing = await isar.fixedAssetModels
            .filter()
            .idEqualTo(asset.id ?? '')
            .and()
            .userIdEqualTo(userId)
            .findFirst();
        if (existing == null) throw Exception('الأصل غير موجود');

        final model = FixedAssetModel.fromEntity(asset)
          ..isarId = existing.isarId
          ..userId = userId;
        await isar.fixedAssetModels.put(model);
      });
    } catch (e) {
      throw Exception('خطأ في تحديث الأصل: $e');
    }
  }

  @override
  Future<void> updateCategory(AssetCategory category) async {
    try {
      await isar.writeTxn(() async {
        final existing = await isar.assetCategoryModels
            .filter()
            .idEqualTo(category.id ?? '')
            .and()
            .userIdEqualTo(userId)
            .findFirst();
        if (existing == null) throw Exception('الفئة غير موجودة');

        final model = AssetCategoryModel.fromEntity(category)
          ..isarId = existing.isarId
          ..userId = userId;
        await isar.assetCategoryModels.put(model);
      });
    } catch (e) {
      throw Exception('خطأ في تحديث الفئة: $e');
    }
  }

  @override
  Future<void> deleteAsset(String id) async {
    try {
      await isar.writeTxn(() async {
        final model = await isar.fixedAssetModels
            .filter()
            .idEqualTo(id)
            .and()
            .userIdEqualTo(userId)
            .findFirst();
        if (model != null) await isar.fixedAssetModels.delete(model.isarId);
      });
    } catch (e) {
      throw Exception('خطأ في حذف الأصل: $e');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await isar.writeTxn(() async {
        final model = await isar.assetCategoryModels
            .filter()
            .idEqualTo(id)
            .and()
            .userIdEqualTo(userId)
            .findFirst();
        if (model != null) await isar.assetCategoryModels.delete(model.isarId);
      });
    } catch (e) {
      throw Exception('خطأ في حذف الفئة: $e');
    }
  }

  @override
  Future<List<FixedAsset>> searchAssets(String query) async {
    try {
      final models = await isar.fixedAssetModels
          .filter()
          .userIdEqualTo(userId)
          .and()
          .group(
            (q) => q
                .nameArContains(query, caseSensitive: false)
                .or()
                .nameEnContains(query, caseSensitive: false)
                .or()
                .codeContains(query, caseSensitive: false),
          )
          .findAll();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw Exception('خطأ في البحث عن الأصول: $e');
    }
  }
}
