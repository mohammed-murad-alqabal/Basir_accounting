import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
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
    description = entity.description;
    status = entity.status;
    lines = entity.lines.map(JournalEntryLineModel.fromEntity).toList();
    sourceDocument = entity.sourceDocument;
    sourceId = entity.sourceId;
    createdBy = entity.createdBy;
    createdAt = entity.createdAt;
    updatedAt = entity.updatedAt;
    userId = entity.userId;
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
  late DateTime date;

  /// الوصف.
  late String description;

  /// حالة القيد.
  @enumerated
  late JournalEntryStatus status;

  /// بنود القيد (مضمنة).
  late List<JournalEntryLineModel> lines;

  /// المستند المصدر.
  late String sourceDocument;

  /// معرف المستند المصدر.
  late String sourceId;

  /// معرف المستخدم الذي أنشأ القيد.
  late String createdBy;

  /// تاريخ الإنشاء.
  late DateTime createdAt;

  /// تاريخ آخر تحديث.
  late DateTime updatedAt;

  /// معرف المستخدم (لعزل البيانات).
  @Index()
  String? userId;

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
        date: date,
        description: description,
        status: status,
        lines: lines.map((l) => l.toEntity()).toList(),
        sourceDocument: sourceDocument,
        sourceId: sourceId,
        createdBy: createdBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
        userId: userId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
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
    costCenterId = entity.costCenterId;
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

  /// مركز التكلفة المرتبط.
  String? costCenterId;

  /// تحويل النموذج إلى كيان.
  JournalEntryLine toEntity() => JournalEntryLine(
        accountId: accountId,
        accountName: accountName,
        debit: Decimal.parse(debit),
        credit: Decimal.parse(credit),
        description: description,
        costCenterId: costCenterId,
      );
}
