import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:flutter/material.dart';

/// امتدادات الفاتورة لربط البيانات بالواجهة
extension InvoiceUiExtensions on Invoice {
  /// الحصول على لون الحالة
  Color getStatusColor(ColorScheme colorScheme) {
    switch (status) {
      case 'paid':
        return AppColors.success;
      case 'overdue':
        return AppColors.error;
      case 'issued':
        return AppColors.info;
      case 'draft':
        return AppColors.textHint;
      case 'cancelled':
        return AppColors.textDisabled;
      default:
        return AppColors.textHint;
    }
  }

  /// الحصول على أيقونة الحالة
  IconData getStatusIcon(AppIcons appIcons) {
    switch (status) {
      case 'paid':
        return appIcons.check;
      case 'overdue':
        return appIcons.error;
      case 'issued':
        return appIcons.send;
      case 'draft':
        return appIcons.edit;
      case 'cancelled':
        return appIcons.close;
      default:
        return appIcons.info;
    }
  }
}
