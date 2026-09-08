/// العقد الموحد لنتائج عمليات الخدمات عالية الأثر في نظام بصير المحاسبي.
///
/// القرارات عالية الأثر (الترحيل، تعديل المخزون، الضريبة) تمر عبر طبقة
/// خدمات تعيد `OperationResult` قابلة للاختبار؛ العرض يستقبل قواعد صالحة
/// من طبقة الخدمات ولا يقرر السياسة بنفسه.
///
/// المرجع: خطة تنفيذ بصير — المعيار 2 (العقود موحدة).
library;

import 'package:basir_accounting_system/core/domain/contracts/audit_entry.dart';
import 'package:flutter/foundation.dart';

/// نتيجة عملية خدمة موحدة: نجاح يحمل القيمة، وفشل يحمل الرسالة والسبب.
///
/// [value] موجود فقط عند [success] = true، و[message] موجود فقط عند
/// [success] = false. السجل التدقيقي [auditTrail] اختياري ويُعاد دائمًا
/// مع عمليات الترحيل والعكس لربط النتيجة بأحداث قابلة للتدقيق.
@immutable
class OperationResult<T> {
  /// يبني نتيجة ناجحة تحمل [value] مع رسالة تأكيد اختيارية.
  const OperationResult.success({
    required this.value,
    this.message,
    this.cause,
    this.auditTrail,
  }) : success = true;

  /// يبني نتيجة فاشلة مع [message] إلزامية وسبب برمجي اختياري.
  const OperationResult.failure({
    required this.message,
    this.cause,
    this.auditTrail,
  })  : success = false,
        value = null;

  /// هل انتهت العملية بنجاح؟
  final bool success;

  /// القيمة الناتجة عند النجاح (صفري عند الفشل).
  final T? value;

  /// رسالة الخطأ الإنسانية عند الفشل (فارغة عند النجاح).
  final String? message;

  /// السبب البرمجي الخام للفشل (استثناء أو رمز خطأ) — للتحليل لا للعرض.
  final Object? cause;

  /// سلسلة أحداث التدقيق المرتبطة بالعملية (إن وُجدت).
  final List<AuditEntry>? auditTrail;

  /// هل النتيجة ناجحة وتحمل قيمة غير صفرية؟
  bool get hasValue => success && value != null;

  /// هل النتيجة ناجحة وتحمل سجل تدقيق غير فارغ؟
  bool get hasAuditTrail => auditTrail != null && auditTrail!.isNotEmpty;

  /// يتحقق من النجاح أو يرمي [OperationFailedException] برسالة الخطأ.
  T getOrThrow() {
    if (success && value != null) {
      return value as T;
    }
    throw OperationFailedException(
      message ?? 'فشلت العملية دون رسالة تفسيرية',
      cause,
    );
  }

  /// يحوّل النتيجة إلى قيمة عبر [onSuccess]/[onFailure] دون رمي استثناءات.
  R fold<R>(
    R Function(T value) onSuccess,
    R Function(String message) onFailure,
  ) {
    if (success) {
      return onSuccess(value as T);
    }
    return onFailure(message ?? 'فشلت العملية دون رسالة تفسيرية');
  }

  @override
  String toString() => success
      ? 'OperationResult.success(message: $message)'
      : 'OperationResult.failure(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationResult &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          value == other.value &&
          message == other.message;

  @override
  int get hashCode => Object.hash(success, value, message);
}

/// استثناء العملية الفاشلة — يُرمي فقط عبر `getOrThrow`.
class OperationFailedException implements Exception {
  const OperationFailedException(this.message, [this.cause]);

  /// رسالة الخطأ الإنسانية.
  final String message;

  /// السبب البرمجي الخام.
  final Object? cause;

  @override
  String toString() => 'OperationFailedException: $message';
}
