import 'package:basir_accounting_system/features/inventory/data/models/warehouse_model.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/warehouse.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/warehouse_repository.dart';
import 'package:isar/isar.dart';

/// تطبيق مستودع المستودعات باستخدام Isar
class WarehouseRepositoryImpl implements WarehouseRepository {
  /// إنشاء نسخة من المستودع
  WarehouseRepositoryImpl({
    required this.isar,
    this.userId,
  });

  /// كائن Isar للاتصال بقاعدة البيانات
  final Isar isar;

  /// معرف المستخدم الحالي
  final String? userId;

  @override
  Future<List<Warehouse>> getAllWarehouses() async {
    final query = isar.warehouseModels.filter().userIdEqualTo(userId);
    final models = await query.findAll();
    return models.map(_toEntity).toList();
  }

  @override
  Future<Warehouse?> getWarehouseById(String id) async {
    final model = await isar.warehouseModels
        .filter()
        .idEqualTo(id)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<void> addWarehouse(Warehouse warehouse) async {
    final model = _fromEntity(warehouse.copyWith(userId: userId));
    await isar.writeTxn(() => isar.warehouseModels.put(model));
  }

  @override
  Future<void> updateWarehouse(Warehouse warehouse) async {
    final existing = await getWarehouseById(warehouse.id);
    if (existing == null) throw Exception('Warehouse not found');

    final model = _fromEntity(warehouse.copyWith(userId: userId));
    await isar.writeTxn(() => isar.warehouseModels.put(model));
  }

  @override
  Future<void> deleteWarehouse(String id) async {
    await isar.writeTxn(() async {
      final model = await isar.warehouseModels
          .filter()
          .idEqualTo(id)
          .and()
          .userIdEqualTo(userId)
          .findFirst();
      if (model != null) {
        await isar.warehouseModels.delete(model.isarId!);
      }
    });
  }

  Warehouse _toEntity(WarehouseModel model) => Warehouse(
        id: model.id,
        nameAr: model.nameAr,
        nameEn: model.nameEn,
        location: model.location,
        userId: model.userId,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      );

  WarehouseModel _fromEntity(Warehouse entity) => WarehouseModel()
    ..id = entity.id
    ..nameAr = entity.nameAr
    ..nameEn = entity.nameEn
    ..location = entity.location
    ..userId = entity.userId
    ..createdAt = entity.createdAt
    ..updatedAt = entity.updatedAt;
}
