import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/inventory/domain/entities/stock_movement.dart';
import 'package:isar/isar.dart';

part 'stock_movement_model.g.dart';

/// نموذج حركة المخزون لقاعدة بيانات Isar
@collection
class StockMovementModel {
  /// إنشاء نموذج حركة مخزون فارغ لارتباطات Isar
  StockMovementModel();

  /// إنشاء نموذج من كائن Entity
  factory StockMovementModel.fromEntity(StockMovement entity) =>
      StockMovementModel()
        ..id = entity.id
        ..itemId = entity.itemId
        ..warehouseId = entity.warehouseId
        ..type = entity.type
        ..quantity = entity.quantity
        ..unitCost = entity.unitCost
        ..date = entity.date
        ..referenceId = entity.referenceId
        ..description = entity.description
        ..userId = entity.userId
        ..syncStatus = entity.syncStatus
        ..createdAt = entity.createdAt;

  /// المعرف الخاص بـ Isar
  Id? isarId;

  /// المعرف الفريد للحركة
  @Index(unique: true, replace: true)
  String? id;

  /// معرف الصنف
  @Index()
  late String itemId;

  /// معرف المستودع
  @Index()
  String? warehouseId;

  /// نوع الحركة (وارد/صادر)
  @Enumerated(EnumType.name)
  late StockMovementType type;

  /// الكمية
  late double quantity;

  /// تكلفة الوحدة
  late double unitCost;

  /// تاريخ الحركة
  @Index()
  late DateTime date;

  /// معرف المرجع (مثل معرف الفاتورة أو التحويل)
  @Index()
  String? referenceId;

  /// الوصف
  String? description;

  /// معرف المستخدم الذي قام بالحركة
  String? userId;

  /// حالة المزامنة
  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.synced;

  /// تاريخ الإنشاء
  late DateTime createdAt;

  /// تحويل النموذج إلى كائن Entity
  StockMovement toEntity() => StockMovement(
        id: id ?? '',
        itemId: itemId,
        warehouseId: warehouseId ?? '',
        type: type,
        quantity: quantity,
        unitCost: unitCost,
        date: date,
        referenceId: referenceId,
        description: description,
        userId: userId,
        syncStatus: syncStatus,
        createdAt: createdAt,
      );
}
