// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemImpl _$$InventoryItemImplFromJson(Map<String, dynamic> json) =>
    _$InventoryItemImpl(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sku: json['sku'] as String?,
      description: json['description'] as String?,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      currentQuantity: (json['currentQuantity'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String?,
      categoryId: json['categoryId'] as String?,
      valuationMethod: $enumDecodeNullable(
              _$ValuationMethodEnumMap, json['valuationMethod']) ??
          ValuationMethod.weightedAverage,
      assetAccountId: json['assetAccountId'] as String?,
      cogsAccountId: json['cogsAccountId'] as String?,
      revenueAccountId: json['revenueAccountId'] as String?,
      primaryAccountId: json['primaryAccountId'] as String?,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
      serverUpdatedAt: json['serverUpdatedAt'] == null
          ? null
          : DateTime.parse(json['serverUpdatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
      userId: json['userId'] as String?,
      warehouseId: json['warehouseId'] as String?,
      barcode: json['barcode'] as String?,
      taxCategory: json['taxCategory'] as String? ?? 'S',
    );

Map<String, dynamic> _$$InventoryItemImplToJson(_$InventoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'sku': instance.sku,
      'description': instance.description,
      'purchasePrice': instance.purchasePrice,
      'salePrice': instance.salePrice,
      'currentQuantity': instance.currentQuantity,
      'unit': instance.unit,
      'categoryId': instance.categoryId,
      'valuationMethod': _$ValuationMethodEnumMap[instance.valuationMethod]!,
      'assetAccountId': instance.assetAccountId,
      'cogsAccountId': instance.cogsAccountId,
      'revenueAccountId': instance.revenueAccountId,
      'primaryAccountId': instance.primaryAccountId,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'serverUpdatedAt': instance.serverUpdatedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'userId': instance.userId,
      'warehouseId': instance.warehouseId,
      'barcode': instance.barcode,
      'taxCategory': instance.taxCategory,
    };

const _$ValuationMethodEnumMap = {
  ValuationMethod.fifo: 'fifo',
  ValuationMethod.weightedAverage: 'weightedAverage',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingPush: 'pendingPush',
  SyncStatus.pendingPull: 'pendingPull',
  SyncStatus.conflict: 'conflict',
};
