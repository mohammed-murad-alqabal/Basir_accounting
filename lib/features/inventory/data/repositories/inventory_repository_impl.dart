import 'package:basir_app/features/inventory/data/models/inventory_item_model.dart';
import 'package:basir_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:isar/isar.dart';

/// تطبيق مستودع المخزون (Inventory Repository Implementation)
class InventoryRepositoryImpl implements InventoryRepository {
  /// إنشاء تطبيق مستودع المخزون
  InventoryRepositoryImpl({required this.isar, required this.userId});

  /// كائن قاعدة البيانات Isar
  final Isar isar;

  /// معرف المستخدم الحالي
  final String? userId;

  @override
  Future<List<InventoryItem>> getAllItems() async {
    try {
      final models = await isar.inventoryItemModels
          .filter()
          .userIdEqualTo(userId)
          .and()
          .isDeletedEqualTo(false)
          .findAll();
      return models.map((model) => model.toEntity()).toList();
    } on Exception catch (e) {
      throw Exception('خطأ في جلب أصناف المخزون: $e');
    }
  }

  @override
  Future<InventoryItem?> getItemById(String id) async {
    try {
      final model = await isar.inventoryItemModels
          .filter()
          .idEqualTo(id)
          .and()
          .userIdEqualTo(userId)
          .findFirst();
      return model?.toEntity();
    } on Exception catch (e) {
      throw Exception('خطأ في جلب صنف المخزون: $e');
    }
  }

  @override
  Future<List<InventoryItem>> searchItems(String query) async {
    try {
      final models = await isar.inventoryItemModels
          .filter()
          .userIdEqualTo(userId)
          .and()
          .isDeletedEqualTo(false)
          .and()
          .group(
            (q) => q
                .nameArContains(query, caseSensitive: false)
                .or()
                .nameEnContains(query, caseSensitive: false)
                .or()
                .skuContains(query, caseSensitive: false),
          )
          .findAll();
      return models.map((model) => model.toEntity()).toList();
    } on Exception catch (e) {
      throw Exception('خطأ في البحث عن أصناف المخزون: $e');
    }
  }

  @override
  Future<void> addItem(InventoryItem item) async {
    try {
      final model = InventoryItemModel.fromEntity(
        item.copyWith(userId: userId),
      );
      await isar.writeTxn(() async {
        await isar.inventoryItemModels.put(model);
      });
    } on Exception catch (e) {
      throw Exception('خطأ في إضافة صنف المخزون: $e');
    }
  }

  @override
  Future<void> updateItem(InventoryItem item) async {
    try {
      await isar.writeTxn(() async {
        final existingModel = await isar.inventoryItemModels
            .filter()
            .idEqualTo(item.id)
            .and()
            .userIdEqualTo(userId)
            .findFirst();

        if (existingModel == null) {
          throw Exception('صنف المخزون غير موجود: ${item.id}');
        }

        final model = InventoryItemModel.fromEntity(
          item.copyWith(userId: userId),
        )..isarId = existingModel.isarId;

        await isar.inventoryItemModels.put(model);
      });
    } on Exception catch (e) {
      throw Exception('خطأ في تحديث صنف المخزون: $e');
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      await isar.writeTxn(() async {
        final model = await isar.inventoryItemModels
            .filter()
            .idEqualTo(id)
            .and()
            .userIdEqualTo(userId)
            .findFirst();
        if (model != null) {
          await isar.inventoryItemModels.put(
            model
              ..isDeleted = true
              ..updatedAt = DateTime.now(),
          );
        }
      });
    } on Exception catch (e) {
      throw Exception('خطأ في حذف صنف المخزون: $e');
    }
  }
}
