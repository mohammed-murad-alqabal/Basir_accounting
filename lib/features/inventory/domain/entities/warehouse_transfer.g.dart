// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferItemImpl _$$TransferItemImplFromJson(Map<String, dynamic> json) =>
    _$TransferItemImpl(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$TransferItemImplToJson(_$TransferItemImpl instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'note': instance.note,
    };

_$WarehouseTransferImpl _$$WarehouseTransferImplFromJson(
        Map<String, dynamic> json) =>
    _$WarehouseTransferImpl(
      id: json['id'] as String,
      transferNumber: json['transferNumber'] as String,
      sourceWarehouseId: json['sourceWarehouseId'] as String,
      destinationWarehouseId: json['destinationWarehouseId'] as String,
      date: DateTime.parse(json['date'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => TransferItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: $enumDecodeNullable(_$TransferStatusEnumMap, json['status']) ??
          TransferStatus.completed,
      remarks: json['remarks'] as String?,
      userId: json['userId'] as String?,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
    );

Map<String, dynamic> _$$WarehouseTransferImplToJson(
        _$WarehouseTransferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transferNumber': instance.transferNumber,
      'sourceWarehouseId': instance.sourceWarehouseId,
      'destinationWarehouseId': instance.destinationWarehouseId,
      'date': instance.date.toIso8601String(),
      'items': instance.items,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'status': _$TransferStatusEnumMap[instance.status]!,
      'remarks': instance.remarks,
      'userId': instance.userId,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$TransferStatusEnumMap = {
  TransferStatus.draft: 'draft',
  TransferStatus.pending: 'pending',
  TransferStatus.inTransit: 'inTransit',
  TransferStatus.completed: 'completed',
  TransferStatus.cancelled: 'cancelled',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingPush: 'pendingPush',
  SyncStatus.pendingPull: 'pendingPull',
  SyncStatus.conflict: 'conflict',
};
