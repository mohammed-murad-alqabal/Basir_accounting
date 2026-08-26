// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemporalJustificationImpl _$$TemporalJustificationImplFromJson(
        Map<String, dynamic> json) =>
    _$TemporalJustificationImpl(
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      effectiveDate: DateTime.parse(json['effectiveDate'] as String),
      recordingDate: DateTime.parse(json['recordingDate'] as String),
    );

Map<String, dynamic> _$$TemporalJustificationImplToJson(
        _$TemporalJustificationImpl instance) =>
    <String, dynamic>{
      'transactionDate': instance.transactionDate.toIso8601String(),
      'effectiveDate': instance.effectiveDate.toIso8601String(),
      'recordingDate': instance.recordingDate.toIso8601String(),
    };

_$StandardsJustificationImpl _$$StandardsJustificationImplFromJson(
        Map<String, dynamic> json) =>
    _$StandardsJustificationImpl(
      standardReference: json['standardReference'] as String,
      recognitionBasis: json['recognitionBasis'] as String?,
      measurementBasis: json['measurementBasis'] as String?,
    );

Map<String, dynamic> _$$StandardsJustificationImplToJson(
        _$StandardsJustificationImpl instance) =>
    <String, dynamic>{
      'standardReference': instance.standardReference,
      'recognitionBasis': instance.recognitionBasis,
      'measurementBasis': instance.measurementBasis,
    };

_$AuditLogEntryImpl _$$AuditLogEntryImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogEntryImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      action: json['action'] as String,
      rationale: json['rationale'] as String,
      actor: json['actor'] as String,
    );

Map<String, dynamic> _$$AuditLogEntryImplToJson(_$AuditLogEntryImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'action': instance.action,
      'rationale': instance.rationale,
      'actor': instance.actor,
    };

_$JournalEntryLineImpl _$$JournalEntryLineImplFromJson(
        Map<String, dynamic> json) =>
    _$JournalEntryLineImpl(
      accountId: json['accountId'] as String,
      accountName: json['accountName'] as String,
      debit: const DecimalJsonConverter().fromJson(json['debit'] as String),
      credit: const DecimalJsonConverter().fromJson(json['credit'] as String),
      description: json['description'] as String?,
      sourceDocumentRef: json['sourceDocumentRef'] as String?,
      costCenterId: json['costCenterId'] as String?,
      originalCurrency: json['originalCurrency'] as String?,
      exchangeRate: _$JsonConverterFromJson<String, Decimal>(
          json['exchangeRate'], const DecimalJsonConverter().fromJson),
      originalAmount: _$JsonConverterFromJson<String, Decimal>(
          json['originalAmount'], const DecimalJsonConverter().fromJson),
    );

Map<String, dynamic> _$$JournalEntryLineImplToJson(
        _$JournalEntryLineImpl instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'debit': const DecimalJsonConverter().toJson(instance.debit),
      'credit': const DecimalJsonConverter().toJson(instance.credit),
      'description': instance.description,
      'sourceDocumentRef': instance.sourceDocumentRef,
      'costCenterId': instance.costCenterId,
      'originalCurrency': instance.originalCurrency,
      'exchangeRate': _$JsonConverterToJson<String, Decimal>(
          instance.exchangeRate, const DecimalJsonConverter().toJson),
      'originalAmount': _$JsonConverterToJson<String, Decimal>(
          instance.originalAmount, const DecimalJsonConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

_$JournalEntryImpl _$$JournalEntryImplFromJson(Map<String, dynamic> json) =>
    _$JournalEntryImpl(
      id: json['id'] as String,
      referenceNumber: json['referenceNumber'] as String,
      date: DateTime.parse(json['date'] as String),
      temporal: TemporalJustification.fromJson(
          json['temporal'] as Map<String, dynamic>),
      standards: StandardsJustification.fromJson(
          json['standards'] as Map<String, dynamic>),
      description: json['description'] as String,
      status: $enumDecode(_$JournalEntryStatusEnumMap, json['status']),
      lines: (json['lines'] as List<dynamic>)
          .map((e) => JournalEntryLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      sourceDocument: json['sourceDocument'] as String,
      sourceId: json['sourceId'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      hash: json['hash'] as String?,
      previousHash: json['previousHash'] as String?,
      postedAt: json['postedAt'] == null
          ? null
          : DateTime.parse(json['postedAt'] as String),
      userId: json['userId'] as String?,
      warehouseId: json['warehouseId'] as String?,
      auditLogs: (json['auditLogs'] as List<dynamic>?)
              ?.map((e) => AuditLogEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
      serverUpdatedAt: json['serverUpdatedAt'] == null
          ? null
          : DateTime.parse(json['serverUpdatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$JournalEntryImplToJson(_$JournalEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referenceNumber': instance.referenceNumber,
      'date': instance.date.toIso8601String(),
      'temporal': instance.temporal.toJson(),
      'standards': instance.standards.toJson(),
      'description': instance.description,
      'status': _$JournalEntryStatusEnumMap[instance.status]!,
      'lines': instance.lines.map((e) => e.toJson()).toList(),
      'sourceDocument': instance.sourceDocument,
      'sourceId': instance.sourceId,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'hash': instance.hash,
      'previousHash': instance.previousHash,
      'postedAt': instance.postedAt?.toIso8601String(),
      'userId': instance.userId,
      'warehouseId': instance.warehouseId,
      'auditLogs': instance.auditLogs.map((e) => e.toJson()).toList(),
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'serverUpdatedAt': instance.serverUpdatedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
    };

const _$JournalEntryStatusEnumMap = {
  JournalEntryStatus.draft: 'draft',
  JournalEntryStatus.posted: 'posted',
  JournalEntryStatus.voided: 'voided',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingPush: 'pendingPush',
  SyncStatus.pendingPull: 'pendingPull',
  SyncStatus.conflict: 'conflict',
};
