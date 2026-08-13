// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      type: $enumDecode(_$AccountTypeEnumMap, json['type']),
      nature: $enumDecode(_$AccountNatureEnumMap, json['nature']),
      balance: Decimal.fromJson(json['balance'] as String),
      subType: json['subType'] as String? ?? '',
      ifrs18Category:
          $enumDecodeNullable(_$Ifrs18CategoryEnumMap, json['ifrs18Category']),
      isParent: json['isParent'] as bool? ?? false,
      parentId: json['parentId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isSystem: json['isSystem'] as bool? ?? false,
      userId: json['userId'] as String?,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
      serverUpdatedAt: json['serverUpdatedAt'] == null
          ? null
          : DateTime.parse(json['serverUpdatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'type': _$AccountTypeEnumMap[instance.type]!,
      'nature': _$AccountNatureEnumMap[instance.nature]!,
      'balance': instance.balance,
      'subType': instance.subType,
      'ifrs18Category': _$Ifrs18CategoryEnumMap[instance.ifrs18Category],
      'isParent': instance.isParent,
      'parentId': instance.parentId,
      'isActive': instance.isActive,
      'isSystem': instance.isSystem,
      'userId': instance.userId,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'serverUpdatedAt': instance.serverUpdatedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
    };

const _$AccountTypeEnumMap = {
  AccountType.asset: 'asset',
  AccountType.liability: 'liability',
  AccountType.equity: 'equity',
  AccountType.revenue: 'revenue',
  AccountType.expense: 'expense',
};

const _$AccountNatureEnumMap = {
  AccountNature.debit: 'debit',
  AccountNature.credit: 'credit',
};

const _$Ifrs18CategoryEnumMap = {
  Ifrs18Category.operating: 'operating',
  Ifrs18Category.investing: 'investing',
  Ifrs18Category.financing: 'financing',
  Ifrs18Category.incomeTax: 'incomeTax',
  Ifrs18Category.discontinued: 'discontinued',
  Ifrs18Category.none: 'none',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingPush: 'pendingPush',
  SyncStatus.pendingPull: 'pendingPull',
  SyncStatus.conflict: 'conflict',
};
