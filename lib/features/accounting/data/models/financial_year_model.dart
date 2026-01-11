import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:isar/isar.dart';

part 'financial_year_model.g.dart';

/// نموذج بيانات السنة المالية للتخزين في قاعدة بيانات Isar.
@collection
class FinancialYearModel {
  /// المعرف الداخلي لقاعدة البيانات.
  Id? isarId;

  /// معرف السنة المالية الفريد.
  @Index(unique: true, replace: true)
  late String id;

  /// اسم السنة المالية (مثال: "2024").
  late String name;

  /// تاريخ بداية السنة المالية.
  late DateTime startDate;

  /// تاريخ نهاية السنة المالية.
  late DateTime endDate;

  /// هل السنة المالية مغلقة؟
  late bool isClosed;

  /// تاريخ الإغلاق (إذا كانت مغلقة).
  DateTime? closedAt;

  /// المستخدم الذي قام بالإغلاق.
  String? closedBy;

  /// قائمة معرفات الفترات (الأشهر) المقفلة.
  List<String> lockedPeriodIds = [];

  /// معرف المستخدم (لعزل البيانات).
  @Index()
  String? userId;

  /// حالة المزامنة
  @enumerated
  late SyncStatus syncStatus;

  /// تاريخ آخر تحديث من السيرفر
  DateTime? serverUpdatedAt;

  /// هل السجل محذوف
  late bool isDeleted;

  /// تحويل من Entity إلى Model
  static FinancialYearModel fromEntity(FinancialYear entity) =>
      FinancialYearModel()
        ..id = entity.id
        ..name = entity.name
        ..startDate = entity.startDate
        ..endDate = entity.endDate
        ..isClosed = entity.isClosed
        ..closedAt = entity.closedAt
        ..closedBy = entity.closedBy
        ..lockedPeriodIds = List.from(entity.lockedPeriodIds)
        ..userId = entity.userId
        ..syncStatus = entity.syncStatus
        ..serverUpdatedAt = entity.serverUpdatedAt
        ..isDeleted = entity.isDeleted;

  /// تحويل من Model إلى Entity
  FinancialYear toEntity() => FinancialYear(
        id: id,
        name: name,
        startDate: startDate,
        endDate: endDate,
        isClosed: isClosed,
        closedAt: closedAt,
        closedBy: closedBy,
        lockedPeriodIds: List.from(lockedPeriodIds),
        userId: userId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
      );
}
