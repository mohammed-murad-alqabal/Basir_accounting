// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_year.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinancialYearImpl _$$FinancialYearImplFromJson(Map<String, dynamic> json) =>
    _$FinancialYearImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isClosed: json['isClosed'] as bool? ?? false,
      closedAt: json['closedAt'] == null
          ? null
          : DateTime.parse(json['closedAt'] as String),
      closedBy: json['closedBy'] as String?,
      lockedPeriodIds: (json['lockedPeriodIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      userId: json['userId'] as String?,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
      serverUpdatedAt: json['serverUpdatedAt'] == null
          ? null
          : DateTime.parse(json['serverUpdatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$FinancialYearImplToJson(_$FinancialYearImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'isClosed': instance.isClosed,
      'closedAt': instance.closedAt?.toIso8601String(),
      'closedBy': instance.closedBy,
      'lockedPeriodIds': instance.lockedPeriodIds,
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
