import 'package:basir_app/core/models/sync_status.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_voucher.freezed.dart';
part 'financial_voucher.g.dart';

/// أنواع السندات المالية (قبض/صرف).
enum VoucherType {
  /// سند قبض (Receipt)
  receipt,

  /// سند صرف (Payment)
  payment,
}

/// طرق الدفع المتاحة.
enum PaymentMethod {
  /// نقدي
  cash,

  /// بنكي / تحويل
  bank,

  /// شيك
  check,
}

/// وثيقة مالية تمثل سند صرف أو قبض.
@freezed
class FinancialVoucher with _$FinancialVoucher {
  /// إنشاء سند مالي جديد.
  const factory FinancialVoucher({
    /// معرف فريد للسند.
    required String id,

    /// رقم مرجعي للسند (مثال: PV-2024-001).
    required String referenceNumber,

    /// تاريخ الصرف أو القبض.
    required DateTime date,

    /// نوع السند (قبض أو صرف).
    required VoucherType type,

    /// وسيلة الدفع (نقد، بنك، شيك).
    required PaymentMethod paymentMethod,

    /// مبلغ السند.
    required Decimal amount,

    /// الحساب المتأثر (مثال: حساب العميل أو المورد).
    required String accountId,

    /// الحساب النقدي المتأثر (الخزينة أو البنك).
    required String treasuryAccountId,

    /// شرح السند.
    required String description,

    /// تاريخ الإنشاء في النظام.
    required DateTime createdAt,

    /// الاسم المرتبط (اسم الدافع أو المستفيد).
    String? personName,

    /// حالة الترحيل للمحاسبة.
    @Default(false) bool isPosted,

    /// معرف القيد المحاسبي المرتبط (بعد الترحيل).
    String? journalEntryId,

    /// معرف المستخدم صاحب السند (لعزل البيانات)
    String? userId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// تاريخ آخر تحديث من السيرفر
    DateTime? serverUpdatedAt,

    /// هل السجل محذوف (حذف ناعم)
    @Default(false) bool isDeleted,
  }) = _FinancialVoucher;

  /// التحويل من JSON
  factory FinancialVoucher.fromJson(Map<String, dynamic> json) => _$FinancialVoucherFromJson(json);
}
