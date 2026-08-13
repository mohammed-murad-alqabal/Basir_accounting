/// حالات الوثيقة التجارية الست الموحدة لنظام بصير المحاسبي.
///
/// كل وثيقة (فاتورة، سند، مرتجع...) تمر عبر دورة حياة مضبوطة، ولا يجوز
/// حذف وثيقة مرحّلة؛ بل تنشأ وثيقة إلغاء أو عكس وفق الصلاحية.
///
/// المرجع: مخطط UI/UX التنفيذي — القسم 6 (حالات الوثائق والأثر المحاسبي).
library;

import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:basir_accounting_system/core/theme/tokens/app_colors.dart';

/// حالة الوثيقة التجارية مع دلالتها وأثرها المحاسبي.
///
/// كل حالة تحدد: المعنى، الأثر على الدفاتر/المخزون، والإجراء التالي المسموح.
/// الألوان والنصوص تأتي من نظام الرموز والتعريب ولا يجوز تحديد حالة بلون وحده.
enum DocumentStatus {
  /// مسودة: غير مكتملة أو قابلة للتعديل — لا أثر على الدفاتر أو المخزون.
  draft,

  /// بانتظار الاعتماد: تحتاج صاحب صلاحية أو تحقق — أثر معلّق.
  pendingApproval,

  /// معتمدة: صالحة للتنفيذ — أثرها بحسب سياسة المؤسسة.
  approved,

  /// مرحلة: قيد/مخزون منشأ وغير قابل لتعديل جوهري — أثر مثبت.
  posted,

  /// ملغاة: ألغيت بسبب موثق — لا أثر أو أثر عكسي معلن.
  cancelled,

  /// معكوسة: تم تصحيحها بوثيقة عكسية — أثر عكسي قابل للتدقيق.
  reversed;

  /// مسمّى الحالة بالعربية كما يظهر في الشارة.
  String get localizedLabel {
    switch (this) {
      case DocumentStatus.draft:
        return 'مسودة';
      case DocumentStatus.pendingApproval:
        return 'بانتظار الاعتماد';
      case DocumentStatus.approved:
        return 'معتمدة';
      case DocumentStatus.posted:
        return 'مرحّلة';
      case DocumentStatus.cancelled:
        return 'ملغاة';
      case DocumentStatus.reversed:
        return 'معكوسة';
    }
  }

  /// مسمّى الحالة وفق لغة سياق العرض الحالي.
  String localizedLabelOf(BuildContext context) {
    switch (this) {
      case DocumentStatus.draft:
        return AppLocalizations.of(context).workStatusDraft;
      case DocumentStatus.pendingApproval:
        return AppLocalizations.of(context).workStatusPendingApproval;
      case DocumentStatus.approved:
        return AppLocalizations.of(context).workStatusApproved;
      case DocumentStatus.posted:
        return AppLocalizations.of(context).workStatusPosted;
      case DocumentStatus.cancelled:
        return AppLocalizations.of(context).workStatusCancelled;
      case DocumentStatus.reversed:
        return AppLocalizations.of(context).workStatusReversed;
    }
  }

  /// اللون الدلالي للحالة وفق هوية بصير.
  ///
  /// ملاحظة تنفيذية: اللون مرافق دائمًا للنص والأيقونة؛ لا تُعرض حالة بلون وحده.
  Color get semanticColor {
    switch (this) {
      case DocumentStatus.draft:
        return AppColors.textHint;
      case DocumentStatus.pendingApproval:
        return AppColors.warning;
      case DocumentStatus.approved:
        return AppColors.info;
      case DocumentStatus.posted:
        return AppColors.success;
      case DocumentStatus.cancelled:
        return AppColors.error;
      case DocumentStatus.reversed:
        return AppColors.statusPending;
    }
  }

  /// الأيقونة المرافقة للحالة داخل الشارة.
  IconData get semanticIcon {
    switch (this) {
      case DocumentStatus.draft:
        return Icons.edit_note_outlined;
      case DocumentStatus.pendingApproval:
        return Icons.hourglass_top_outlined;
      case DocumentStatus.approved:
        return Icons.check_circle_outline;
      case DocumentStatus.posted:
        return Icons.receipt_long_outlined;
      case DocumentStatus.cancelled:
        return Icons.cancel_outlined;
      case DocumentStatus.reversed:
        return Icons.undo_outlined;
    }
  }
}
