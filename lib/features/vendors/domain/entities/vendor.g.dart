// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorImpl _$$VendorImplFromJson(Map<String, dynamic> json) => _$VendorImpl(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      payableAccountId: json['payableAccountId'] as String?,
      vatNumber: json['vatNumber'] as String?,
      registrationNumber: json['registrationNumber'] as String?,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      userId: json['userId'] as String?,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
      serverUpdatedAt: json['serverUpdatedAt'] == null
          ? null
          : DateTime.parse(json['serverUpdatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$VendorImplToJson(_$VendorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'notes': instance.notes,
      'payableAccountId': instance.payableAccountId,
      'vatNumber': instance.vatNumber,
      'registrationNumber': instance.registrationNumber,
      'balance': instance.balance,
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
