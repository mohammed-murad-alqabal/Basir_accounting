import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/inventory/domain/entities/warehouse_transfer.dart';
import 'package:isar/isar.dart';

part 'warehouse_transfer_model.g.dart';

/// نموذج صنف التحويل (Embedded)
@embedded
class TransferItemModel {
  /// إنشاء نموذج صنف تحويل فارغ
  TransferItemModel();

  /// إنشاء نموذج من كائن Entity
  factory TransferItemModel.fromEntity(TransferItem entity) =>
      TransferItemModel()
        ..itemId = entity.itemId
        ..itemName = entity.itemName
        ..quantity = entity.quantity
        ..unit = entity.unit
        ..note = entity.note;

  /// معرف الصنف
  late String itemId;

  /// اسم الصنف وقت التحويل
  late String itemName;

  /// الكمية المحولة
  late double quantity;

  /// الوحدة (اختياري)
  String? unit;

  /// ملاحظة على الصنف (اختياري)
  String? note;

  /// تحويل النموذج إلى كائن Entity
  TransferItem toEntity() => TransferItem(
        itemId: itemId,
        itemName: itemName,
        quantity: quantity,
        unit: unit,
        note: note,
      );
}

/// نموذج تحويل المخزون لقاعدة بيانات Isar
@collection
class WarehouseTransferModel {
  /// إنشاء نموذج تحويل مخزون فارغ
  WarehouseTransferModel();

  /// إنشاء نموذج من كائن Entity
  factory WarehouseTransferModel.fromEntity(WarehouseTransfer entity) =>
      WarehouseTransferModel()
        ..id = entity.id
        ..transferNumber = entity.transferNumber
        ..sourceWarehouseId = entity.sourceWarehouseId
        ..destinationWarehouseId = entity.destinationWarehouseId
        ..date = entity.date
        ..status = entity.status
        ..items = entity.items.map(TransferItemModel.fromEntity).toList()
        ..remarks = entity.remarks
        ..userId = entity.userId
        ..syncStatus = entity.syncStatus
        ..createdAt = entity.createdAt
        ..updatedAt = entity.updatedAt;

  /// المعرف الخاص بـ Isar
  Id? isarId;

  /// المعرف الفريد للتحويل
  @Index(unique: true, replace: true)
  String? id;

  /// رقم التحويل المرجعي
  @Index(type: IndexType.value)
  late String transferNumber;

  /// معرف مستودع المصدر
  @Index()
  String? sourceWarehouseId;

  /// معرف مستودع الوجهة
  @Index()
  String? destinationWarehouseId;

  /// تاريخ التحويل
  @Index()
  late DateTime date;

  /// حالة التحويل
  @Enumerated(EnumType.name)
  late TransferStatus status;

  /// قائمة الأصناف المحولة
  late List<TransferItemModel> items;

  /// ملاحظات إضافية
  String? remarks;

  /// معرف المستخدم
  String? userId;

  /// حالة المزامنة
  @Enumerated(EnumType.name)
  SyncStatus syncStatus = SyncStatus.synced;

  /// تاريخ الإنشاء
  late DateTime createdAt;

  /// تاريخ التحديث
  late DateTime updatedAt;

  /// تحويل النموذج إلى كائن Entity
  WarehouseTransfer toEntity() => WarehouseTransfer(
        id: id ?? '',
        transferNumber: transferNumber,
        sourceWarehouseId: sourceWarehouseId ?? '',
        destinationWarehouseId: destinationWarehouseId ?? '',
        date: date,
        status: status,
        items: items.map((e) => e.toEntity()).toList(),
        remarks: remarks,
        userId: userId,
        syncStatus: syncStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
