import 'package:basir_app/features/inventory/data/models/warehouse_transfer_model.dart';
import 'package:basir_app/features/inventory/domain/entities/warehouse_transfer.dart';
import 'package:basir_app/features/inventory/domain/repositories/warehouse_transfer_repository.dart';
import 'package:isar/isar.dart';

/// تطبيق مستودع تحويلات المخزون باستخدام Isar
class WarehouseTransferRepositoryImpl implements WarehouseTransferRepository {
  /// إنشاء نسخة من المستودع
  WarehouseTransferRepositoryImpl({
    required this.isar,
    required this.userId,
    this.warehouseId,
  });

  /// كائن Isar للاتصال بقاعدة البيانات
  final Isar isar;

  /// معرف المستخدم الحالي
  final String? userId;

  /// معرف المستودع الحالي للاختزال
  final String? warehouseId;

  @override
  Future<List<WarehouseTransfer>> getAllTransfers() async {
    final models = await isar.warehouseTransferModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .group(
          (q) => q
              .sourceWarehouseIdEqualTo(warehouseId ?? '')
              .or()
              .destinationWarehouseIdEqualTo(warehouseId ?? '')
              .or()
              .sourceWarehouseIdIsNull(),
        )
        .sortByDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<WarehouseTransfer?> getTransferById(String id) async {
    final model = await isar.warehouseTransferModels
        .filter()
        .idEqualTo(id)
        .and()
        .userIdEqualTo(userId)
        .findFirst();
    return model?.toEntity();
  }

  @override
  Future<void> addTransfer(WarehouseTransfer transfer) async {
    final model = WarehouseTransferModel.fromEntity(
      transfer.copyWith(userId: userId),
    );
    await isar.writeTxn(() => isar.warehouseTransferModels.put(model));
  }

  @override
  Future<void> updateTransfer(WarehouseTransfer transfer) async {
    final existing = await getTransferById(transfer.id);
    if (existing == null) throw Exception('Transfer not found');

    final model = WarehouseTransferModel.fromEntity(
      transfer.copyWith(userId: userId),
    );
    await isar.writeTxn(() => isar.warehouseTransferModels.put(model));
  }

  @override
  Future<void> deleteTransfer(String id) async {
    await isar.writeTxn(() async {
      final model = await isar.warehouseTransferModels
          .filter()
          .idEqualTo(id)
          .and()
          .userIdEqualTo(userId)
          .findFirst();
      if (model != null) {
        await isar.warehouseTransferModels.delete(model.isarId!);
      }
    });
  }
}
