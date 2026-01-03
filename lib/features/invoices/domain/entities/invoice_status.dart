/// حالات الفاتورة (Invoice Status)
///
/// تمثل حالات دورة حياة الفاتورة في النظام.
/// تتوافق مع معايير ZATCA والفواتير الضريبية.
library;

import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// حالة الفاتورة
enum InvoiceStatus {
  /// مسودة: لم يتم إصدارها بعد
  @JsonValue('draft')
  draft,

  /// صادرة/مرسلة: تم إصدارها وإرسالها للعميل
  @JsonValue('sent')
  sent, // Maps to 'issued' in old logic, but 'sent' matches Archive

  /// مدفوعة: تم استلام المبلغ بالكامل
  @JsonValue('paid')
  paid,

  /// متأخرة: تجاوزت تاريخ الاستحقاق ولم تدفع
  @JsonValue('overdue')
  overdue,

  /// ملغاة: تم إلغاؤها ولا يعتد بها
  @JsonValue('cancelled')
  cancelled,

  /// مرتجعة: تم إصدار إشعار دائن لها (إضافي للضرورة المحاسبية)
  @JsonValue('refunded')
  refunded;

  /// هل الفاتورة قابلة للتعديل؟
  bool get isEditable => this == InvoiceStatus.draft;

  /// هل الفاتورة نهائية (لا يمكن حذفها)؟
  bool get isFinal => this != InvoiceStatus.draft;

  /// تعيد النص الوصفي للحالة المعرب أو المترجم
  String toDisplayString(BuildContext context) {
    switch (this) {
      case InvoiceStatus.draft:
        return context.l10n.filterDraft;
      case InvoiceStatus.sent:
        return context.l10n.statusPending;
      case InvoiceStatus.paid:
        return context.l10n.statusPaid;
      case InvoiceStatus.overdue:
        return context.l10n.statusOverdue;
      case InvoiceStatus.cancelled:
        return context.l10n.statusCancelled;
      case InvoiceStatus.refunded:
        return 'مرتجعة'; // TODO(User): add to l10n
    }
  }
}
