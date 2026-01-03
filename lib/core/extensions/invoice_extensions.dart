import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:flutter/material.dart';

/// امتدادات الفاتورة لربط البيانات بالواجهة
extension InvoiceUiExtensions on Invoice {
  /// الحصول على لون الحالة
  Color getStatusColor(ColorScheme colorScheme) {
    switch (status) {
      case InvoiceStatus.paid:
        return AppColors.success;
      case InvoiceStatus.overdue:
        return AppColors.error;
      case InvoiceStatus.sent:
        return AppColors.info;
      case InvoiceStatus.draft:
        return AppColors.textHint;
      case InvoiceStatus.cancelled:
        return AppColors.textDisabled;
      case InvoiceStatus.refunded:
        return AppColors.warning;
    }
  }

  /// الحصول على أيقونة الحالة
  IconData getStatusIcon(AppIcons appIcons) {
    switch (status) {
      case InvoiceStatus.paid:
        return appIcons.check;
      case InvoiceStatus.overdue:
        return appIcons.error;
      case InvoiceStatus.sent:
        return appIcons.send;
      case InvoiceStatus.draft:
        return appIcons.edit;
      case InvoiceStatus.cancelled:
        return appIcons.close;
      case InvoiceStatus.refunded:
        return appIcons.refresh;
    }
  }
}
