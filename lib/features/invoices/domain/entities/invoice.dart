/// كيان الفاتورة (Invoice Entity)
///
/// يمثل بيانات الفاتورة الأساسية في طبقة المجال (Domain Layer).
/// يحتوي على جميع المعلومات المتعلقة بالفاتورة وبنودها، وحقول ZATCA.
library;

import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

/// بند الفاتورة (Invoice Item)
///
/// يمثل بنداً واحداً في الفاتورة مع الكمية والسعر.
@freezed
class InvoiceItem with _$InvoiceItem {
  /// إنشاء بند فاتورة جديد
  const factory InvoiceItem({
    required String id,
    required String name,
    required double quantity,
    required double price,

    /// إجمالي البند (المحسوب والمخزن)
    /// quantity * price
    required double total,

    /// الوصف (اختياري)
    String? description,

    /// مبلغ الضريبة للبند (اختياري إذا كان مفصلاً)
    @Default(0.0) double taxAmount,
  }) = _InvoiceItem;

  /// إنشاء بند فاتورة من JSON
  factory InvoiceItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemFromJson(json);

  const InvoiceItem._();
}

/// الفاتورة (Invoice)
///
/// كيان رئيسي يمثل فاتورة كاملة مع جميع بنودها وتفاصيلها.
/// متوافق مع معايير ZATCA والفاتورة الإلكترونية السعودية.
@freezed
class Invoice with _$Invoice {
  /// إنشاء فاتورة جديدة
  const factory Invoice({
    /// معرف الفاتورة الفريد (UUID)
    required String id,

    /// رقم الفاتورة التسلسلي (للعرض)
    /// مثال: INV-2025-0001
    required String invoiceNumber,

    /// معرف العميل
    required String customerId,
    required String customerName,

    /// قائمة بنود الفاتورة
    required List<InvoiceItem> items,

    /// تواريخ
    required DateTime issuedDate,
    required DateTime dueDate,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// الحالة
    required InvoiceStatus status,

    /// مبالغ (Persisted for Data Integrity)
    required double subtotalAmount,
    required double taxAmount,
    required double discountAmount,
    required double totalAmount,
    required double paidAmount,

    /// نسب
    required double taxRate,
    DateTime? paidDate,
    @Default(0.0) double discountRate,

    /// العملة
    @Default('SAR') String currency,

    /// معلومات إضافية
    String? notes,
    String? terms,

    /// بيانات ZATCA (الفاتورة الإلكترونية)
    String? zatcaUuid,
    String? zatcaHash,
    String? qrCode,
    String? xmlContent,
    String? zatcaDeviceId,
    @Default(0) int zatcaCounter,

    /// معرف المستخدم لغرض عزل البيانات
    String? userId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// تاريخ آخر تحديث من السيرفر
    DateTime? serverUpdatedAt,

    /// هل السجل محذوف (حذف ناعم)
    @Default(false) bool isDeleted,
  }) = _Invoice;

  /// إنشاء فاتورة من JSON
  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  const Invoice._();

  /// المتبقي للدفع
  double get remainingAmount => totalAmount - paidAmount;

  /// هل الفاتورة متأخرة؟
  bool get isOverdue {
    if (status == InvoiceStatus.paid || status == InvoiceStatus.cancelled) {
      return false;
    }
    return DateTime.now().isAfter(dueDate);
  }
}
