import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/accounting/domain/entities/financial_voucher.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';

part 'financial_voucher_model.g.dart';

/// نموذج قاعدة البيانات للسند المالي (Financial Voucher Model)
/// يستخدم لتخزين السندات المالية في قاعدة بيانات Isar.
@collection
class FinancialVoucherModel {
  /// إنشاء نموذج فارغ (مطلوب من Isar).
  FinancialVoucherModel();

  /// إنشاء نموذج من كيان السند المالي.
  FinancialVoucherModel.fromEntity(FinancialVoucher voucher) {
    id = voucher.id;
    referenceNumber = voucher.referenceNumber;
    date = voucher.date;
    type = voucher.type;
    paymentMethod = voucher.paymentMethod;
    amount = voucher.amount.toString();
    accountId = voucher.accountId;
    treasuryAccountId = voucher.treasuryAccountId;
    description = voucher.description;
    createdAt = voucher.createdAt;
    personName = voucher.personName;
    isPosted = voucher.isPosted;
    journalEntryId = voucher.journalEntryId;
    userId = voucher.userId;
    syncStatus = voucher.syncStatus;
    serverUpdatedAt = voucher.serverUpdatedAt;
    isDeleted = voucher.isDeleted;
  }

  /// المعرف التلقائي لـ Isar.
  Id isarId = Isar.autoIncrement;

  /// معرف السند الفريد.
  @Index(unique: true)
  late String id;

  /// رقم المرجع.
  @Index()
  late String referenceNumber;

  /// تاريخ السند.
  @Index()
  late DateTime date;

  /// نوع السند (قبض/صرف).
  @enumerated
  late VoucherType type;

  /// طريقة الدفع (نقدي/بنكي).
  @enumerated
  late PaymentMethod paymentMethod;

  /// المبلغ (يخزن كنص للحفاظ على دقة Decimal).
  late String amount;

  /// معرف الحساب المقابل.
  late String accountId;

  /// معرف حساب الخزينة/البنك.
  late String treasuryAccountId;

  /// وصف السند.
  late String description;

  /// تاريخ الإنشاء.
  late DateTime createdAt;

  /// اسم الشخص (اختياري).
  String? personName;

  /// هل تم ترحيل السند للدفاتر المحاسبية.
  bool isPosted = false;

  /// معرف قيد اليومية المرتبط (إن وجد).
  String? journalEntryId;

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

  /// تحويل النموذج إلى كيان سند مالي.
  FinancialVoucher toEntity() => FinancialVoucher(
        id: id,
        referenceNumber: referenceNumber,
        date: date,
        type: type,
        paymentMethod: paymentMethod,
        amount: Decimal.parse(amount),
        accountId: accountId,
        treasuryAccountId: treasuryAccountId,
        description: description,
        createdAt: createdAt,
        personName: personName,
        isPosted: isPosted,
        journalEntryId: journalEntryId,
        userId: userId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
      );
}
