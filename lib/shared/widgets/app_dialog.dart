import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';

/// نوع الحوار (Dialog Type)
enum AppDialogType {
  confirmation,
  info,
  success,
  error,
  warning,
}

/// حوار (Dialog) موحد للتطبيق
///
/// يوفر تجربة حوار بريميوم ومتسقة عبر جميع الشاشات
/// مع دعم للوضع الليلي وتباين كامل (WCAG AA)
abstract final class AppDialog {
  /// عرض حوار تأكيد
  static Future<bool> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'تأكيد',
    String cancelLabel = 'إلغاء',
    IconData? icon,
  }) =>
      _show(
        context,
        title,
        message,
        AppDialogType.confirmation,
        confirmLabel,
        cancelLabel,
        icon,
      );

  /// عرض حوار معلومات
  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'موافق',
    IconData? icon,
  }) =>
      _show(
        context,
        title,
        message,
        AppDialogType.info,
        confirmLabel,
        null,
        icon,
      );

  /// عرض حوار نجاح
  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'موافق',
    IconData? icon,
  }) =>
      _show(
        context,
        title,
        message,
        AppDialogType.success,
        confirmLabel,
        null,
        icon,
      );

  /// عرض حوار خطأ
  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'موافق',
    IconData? icon,
  }) =>
      _show(
        context,
        title,
        message,
        AppDialogType.error,
        confirmLabel,
        null,
        icon,
      );

  /// عرض حوار تحذير
  static Future<bool> showWarning(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'موافق',
    String cancelLabel = 'إلغاء',
    IconData? icon,
  }) =>
      _show(
        context,
        title,
        message,
        AppDialogType.warning,
        confirmLabel,
        cancelLabel,
        icon,
      );

  static Future<bool> _show(
    BuildContext context,
    String title,
    String message,
    AppDialogType type,
    String confirmLabel,
    String? cancelLabel,
    IconData? icon,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color accentColor;
    IconData defaultIcon;

    switch (type) {
      case AppDialogType.confirmation:
        accentColor = isDark ? AppPalette.blueCorporate : AppColors.primary;
        defaultIcon = Icons.help_outline;
      case AppDialogType.info:
        accentColor = isDark ? AppPalette.blueSky : AppColors.info;
        defaultIcon = Icons.info_outline;
      case AppDialogType.success:
        accentColor = isDark ? AppPalette.greenEmerald : AppColors.success;
        defaultIcon = Icons.check_circle_outline;
      case AppDialogType.error:
        accentColor = isDark ? AppPalette.redAlert : AppColors.error;
        defaultIcon = Icons.error_outline;
      case AppDialogType.warning:
        accentColor = isDark ? Colors.orange[600]! : AppColors.warning;
        defaultIcon = Icons.warning_amber_outlined;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: Radii.borderRadiusXl,
        ),
        elevation: Elevation.xl,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? defaultIcon,
                color: accentColor,
                size: 64,
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                title,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeights.bold,
                  color: isDark
                      ? AppPalette.darkTextPrimary
                      : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.md),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppPalette.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (cancelLabel != null) ...[
                    Flexible(
                      child: AppEnhancedButton(
                        label: cancelLabel,
                        type: AppEnhancedButtonType.outlined,
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                  ],
                  Flexible(
                    child: AppEnhancedButton(
                      label: confirmLabel,
                      type: type == AppDialogType.error
                          ? AppEnhancedButtonType.danger
                          : type == AppDialogType.success
                              ? AppEnhancedButtonType.secondary
                              : AppEnhancedButtonType.primary,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return result ?? false;
  }
}
