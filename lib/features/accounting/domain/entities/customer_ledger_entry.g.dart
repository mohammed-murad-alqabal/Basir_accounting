// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_ledger_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerLedgerEntryImpl _$$CustomerLedgerEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomerLedgerEntryImpl(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      entryNumber: json['entryNumber'] as String,
      entryDate: DateTime.parse(json['entryDate'] as String),
      description: json['description'] as String,
      debit: Decimal.fromJson(json['debit'] as String),
      credit: Decimal.fromJson(json['credit'] as String),
      balance: Decimal.fromJson(json['balance'] as String),
      sourceDocument: json['sourceDocument'] as String,
      sourceId: json['sourceId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      reference: json['reference'] as String?,
      createdBy: json['createdBy'] as String?,
      userId: json['userId'] as String?,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
    );

Map<String, dynamic> _$$CustomerLedgerEntryImplToJson(
        _$CustomerLedgerEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'entryNumber': instance.entryNumber,
      'entryDate': instance.entryDate.toIso8601String(),
      'description': instance.description,
      'debit': instance.debit,
      'credit': instance.credit,
      'balance': instance.balance,
      'sourceDocument': instance.sourceDocument,
      'sourceId': instance.sourceId,
      'createdAt': instance.createdAt.toIso8601String(),
      'reference': instance.reference,
      'createdBy': instance.createdBy,
      'userId': instance.userId,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingPush: 'pendingPush',
  SyncStatus.pendingPull: 'pendingPull',
  SyncStatus.conflict: 'conflict',
};
