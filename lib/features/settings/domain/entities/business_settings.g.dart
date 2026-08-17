// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessSettingsImpl _$$BusinessSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessSettingsImpl(
      id: json['id'] as String,
      companyName: json['companyName'] as String,
      taxNumber: json['taxNumber'] as String?,
      address: json['address'] as String?,
      logoUrl: json['logoUrl'] as String?,
      defaultTaxRate: (json['defaultTaxRate'] as num?)?.toDouble() ?? 15.0,
      currencyCode: json['currencyCode'] as String? ?? 'SAR',
      currencySymbol: json['currencySymbol'] as String? ?? 'ر.س',
      userId: json['userId'] as String?,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
      serverUpdatedAt: json['serverUpdatedAt'] == null
          ? null
          : DateTime.parse(json['serverUpdatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$BusinessSettingsImplToJson(
        _$BusinessSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyName': instance.companyName,
      'taxNumber': instance.taxNumber,
      'address': instance.address,
      'logoUrl': instance.logoUrl,
      'defaultTaxRate': instance.defaultTaxRate,
      'currencyCode': instance.currencyCode,
      'currencySymbol': instance.currencySymbol,
      'userId': instance.userId,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'serverUpdatedAt': instance.serverUpdatedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
    };

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingPush: 'pendingPush',
  SyncStatus.pendingPull: 'pendingPull',
  SyncStatus.conflict: 'conflict',
};
