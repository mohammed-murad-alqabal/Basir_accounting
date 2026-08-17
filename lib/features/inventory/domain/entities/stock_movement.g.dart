// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockMovementImpl _$$StockMovementImplFromJson(Map<String, dynamic> json) =>
    _$StockMovementImpl(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      warehouseId: json['warehouseId'] as String,
      type: $enumDecode(_$StockMovementTypeEnumMap, json['type']),
      quantity: (json['quantity'] as num).toDouble(),
      unitCost: (json['unitCost'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      referenceId: json['referenceId'] as String?,
      description: json['description'] as String?,
      userId: json['userId'] as String?,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
    );

Map<String, dynamic> _$$StockMovementImplToJson(_$StockMovementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'warehouseId': instance.warehouseId,
      'type': _$StockMovementTypeEnumMap[instance.type]!,
      'quantity': instance.quantity,
      'unitCost': instance.unitCost,
      'date': instance.date.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'referenceId': instance.referenceId,
      'description': instance.description,
      'userId': instance.userId,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$StockMovementTypeEnumMap = {
  StockMovementType.inbound: 'inbound',
  StockMovementType.outbound: 'outbound',
  StockMovementType.transfer: 'transfer',
  StockMovementType.adjustment: 'adjustment',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingPush: 'pendingPush',
  SyncStatus.pendingPull: 'pendingPull',
  SyncStatus.conflict: 'conflict',
};
