import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';

part 'journal_entry_model.g.dart';

/// نموذج بيانات القيد المحاسبي للتخزين في Isar.
@collection
class JournalEntryModel {
  /// مُنشئ افتراضي.
  JournalEntryModel();

  /// إنشاء نموذج من كيان.
  JournalEntryModel.fromEntity(JournalEntry entity) {
    id = entity.id;
    referenceNumber = entity.referenceNumber;
    date = entity.date;
    temporal = TemporalJustificationModel.fromEntity(entity.temporal);
    standards = StandardsJustificationModel.fromEntity(entity.standards);
    description = entity.description;
    status = entity.status;
    lines = entity.lines.map(JournalEntryLineModel.fromEntity).toList();
    auditLogs = entity.auditLogs.map(AuditLogEntryModel.fromEntity).toList();
    sourceDocument = entity.sourceDocument;
    sourceId = entity.sourceId;
    hash = entity.hash;
    previousHash = entity.previousHash;
    createdBy = entity.createdBy;
    createdAt = entity.createdAt;
    updatedAt = entity.updatedAt;
    postedAt = entity.postedAt;
    userId = entity.userId;
    warehouseId = entity.warehouseId;
    syncStatus = entity.syncStatus;
    serverUpdatedAt = entity.serverUpdatedAt;
    isDeleted = entity.isDeleted;
  }

  /// المعرف الداخلي لـ Isar.
  Id? isarId;

  /// المعرف الفريد.
  @Index(unique: true, replace: true)
  late String id;

  /// الرقم المرجعي.
  @Index(unique: true)
  late String referenceNumber;

  /// تاريخ القيد.
  @Index()
  late DateTime date;

  /// التبرير الزمني.
  late TemporalJustificationModel temporal;

  /// تبرير المعايير.
  late StandardsJustificationModel standards;

  /// الوصف.
  late String description;

  /// حالة القيد.
  @Index()
  @enumerated
  late JournalEntryStatus status;

  /// بنود القيد (مضمنة).
  late List<JournalEntryLineModel> lines;

  /// سجل التدقيق المحلي المضمن.
  ///
  /// يمثل هذا المسار سجل التطبيق المحلي فقط، ولا يعادل تلقائيًا سلسلة
  /// `audit_log` في PostgreSQL.
  List<AuditLogEntryModel> auditLogs = [];

  /// المستند المصدر.
  late String sourceDocument;

  /// معرف المستند المصدر.
  late String sourceId;

  /// بصمة سلامة البيانات.
  String? hash;

  /// بصمة السجل السابق.
  String? previousHash;

  /// معرف المستخدم الذي أنشأ القيد.
  late String createdBy;

  /// تاريخ الإنشاء.
  late DateTime createdAt;

  /// تاريخ آخر تحديث.
  late DateTime updatedAt;

  /// تاريخ النشر.
  DateTime? postedAt;

  /// معرف المستخدم (لعزل البيانات).
  @Index()
  String? userId;

  /// معرف المستودع.
  @Index()
  String? warehouseId;

  /// حالة المزامنة
  @enumerated
  late SyncStatus syncStatus;

  /// تاريخ آخر تحديث من السيرفر
  DateTime? serverUpdatedAt;

  /// هل القيد محذوف
  late bool isDeleted;

  /// تحويل النموذج إلى كيان.
  JournalEntry toEntity() => JournalEntry(
        id: id,
        referenceNumber: referenceNumber,
        date: date.toUtc(),
        temporal: temporal.toEntity(),
        standards: standards.toEntity(),
        description: description,
        status: status,
        lines: lines.map((l) => l.toEntity()).toList(),
        auditLogs: auditLogs.map((log) => log.toEntity()).toList(),
        sourceDocument: sourceDocument,
        sourceId: sourceId,
        hash: hash,
        previousHash: previousHash,
        createdBy: createdBy,
        createdAt: createdAt.toUtc(),
        updatedAt: updatedAt.toUtc(),
        postedAt: postedAt?.toUtc(),
        userId: userId,
        warehouseId: warehouseId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt?.toUtc(),
        isDeleted: isDeleted,
      );
}

/// نموذج التبرير الزمني المضمن.
@embedded
class TemporalJustificationModel {
  /// إنشاء نموذج فارغ.
  TemporalJustificationModel();

  /// إنشاء نموذج من كيان.
  TemporalJustificationModel.fromEntity(TemporalJustification entity) {
    transactionDate = entity.transactionDate;
    effectiveDate = entity.effectiveDate;
    recordingDate = entity.recordingDate;
  }

  /// تاريخ العملية.
  late DateTime transactionDate;

  /// تاريخ السريان.
  late DateTime effectiveDate;

  /// تاريخ التسجيل.
  late DateTime recordingDate;

  /// تحويل إلى كيان.
  TemporalJustification toEntity() => TemporalJustification(
        transactionDate: transactionDate.toUtc(),
        effectiveDate: effectiveDate.toUtc(),
        recordingDate: recordingDate.toUtc(),
      );
}

/// نموذج تبرير المعايير المضمن.
@embedded
class StandardsJustificationModel {
  /// إنشاء نموذج فارغ.
  StandardsJustificationModel();

  /// إنشاء نموذج من كيان.
  StandardsJustificationModel.fromEntity(StandardsJustification entity) {
    standardReference = entity.standardReference;
    recognitionBasis = entity.recognitionBasis;
    measurementBasis = entity.measurementBasis;
  }

  /// مرجع المعيار المحاسبي.
  late String standardReference;

  /// أساس الاعتراف.
  String? recognitionBasis;

  /// أساس القياس.
  String? measurementBasis;

  /// تحويل إلى كيان.
  StandardsJustification toEntity() => StandardsJustification(
        standardReference: standardReference,
        recognitionBasis: recognitionBasis,
        measurementBasis: measurementBasis,
      );
}

/// نموذج سجل التدقيق المحلي المضمن.
@embedded
class AuditLogEntryModel {
  /// إنشاء نموذج فارغ.
  AuditLogEntryModel();

  /// إنشاء نموذج تدقيق من كيان النطاق.
  AuditLogEntryModel.fromEntity(AuditLogEntry entity) {
    timestamp = entity.timestamp;
    action = entity.action;
    rationale = entity.rationale;
    actor = entity.actor;
  }

  /// وقت وقوع الحدث.
  late DateTime timestamp;

  /// رمز أو وصف الفعل.
  late String action;

  /// التبرير المسجل للحدث.
  late String rationale;

  /// الفاعل الذي أنشأ الحدث.
  late String actor;

  /// تحويل النموذج إلى كيان النطاق.
  AuditLogEntry toEntity() => AuditLogEntry(
        timestamp: timestamp.toUtc(),
        action: action,
        rationale: rationale,
        actor: actor,
      );
}

/// نموذج بند القيد المحاسبي المضمن.
@embedded
class JournalEntryLineModel {
  /// مُنشئ افتراضي.
  JournalEntryLineModel();

  /// إنشاء نموذج بند من كيان.
  JournalEntryLineModel.fromEntity(JournalEntryLine entity) {
    accountId = entity.accountId;
    accountName = entity.accountName;
    debit = entity.debit.toString();
    credit = entity.credit.toString();
    description = entity.description;
    sourceDocumentRef = entity.sourceDocumentRef;
    costCenterId = entity.costCenterId;
    originalCurrency = entity.originalCurrency;
    exchangeRate = entity.exchangeRate?.toString();
    originalAmount = entity.originalAmount?.toString();
  }

  /// معرف الحساب.
  late String accountId;

  /// اسم الحساب.
  late String accountName;

  /// مبلغ المدين (مخزن كنص للـ Decimal).
  late String debit;

  /// مبلغ الدائن (مخزن كنص للـ Decimal).
  late String credit;

  /// الوصف لللبند.
  String? description;

  /// مرجع المستند المصدر.
  String? sourceDocumentRef;

  /// مركز التكلفة المرتبط.
  String? costCenterId;

  /// العملة الأصلية.
  String? originalCurrency;

  /// سعر الصرف (كمت نص).
  String? exchangeRate;

  /// المبلغ بالعملة الأصلية (كنص).
  String? originalAmount;

  /// تحويل النموذج إلى كيان.
  JournalEntryLine toEntity() => JournalEntryLine(
        accountId: accountId,
        accountName: accountName,
        debit: Decimal.parse(debit),
        credit: Decimal.parse(credit),
        description: description,
        sourceDocumentRef: sourceDocumentRef,
        costCenterId: costCenterId,
        originalCurrency: originalCurrency,
        exchangeRate:
            exchangeRate != null ? Decimal.parse(exchangeRate!) : null,
        originalAmount:
            originalAmount != null ? Decimal.parse(originalAmount!) : null,
      );
}
