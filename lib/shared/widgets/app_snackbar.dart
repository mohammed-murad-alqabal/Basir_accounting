import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// نوع الرسالة (Snackbar Type)
enum AppSnackbarType {
  success,
  error,
  warning,
  info,
}

/// رسالة (Snackbar) موحدة للتطبيق
///
/// يوفر تجربة رسائل بريميوم ومتسقة عبر جميع الشاشات
/// مع دعم للوضع الليلي وتباين كامل (WCAG AA)
abstract final class AppSnackbar {
  /// عرض رسالة بنجاح
  static void showSuccess(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) =>
      _show(
        context,
        message,
        AppSnackbarType.success,
        actionLabel,
        onActionPressed,
      );

  /// عرض رسالة خطأ
  static void showError(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) =>
      _show(
        context,
        message,
        AppSnackbarType.error,
        actionLabel,
        onActionPressed,
      );

  /// عرض رسالة تحذير
  static void showWarning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) =>
      _show(
        context,
        message,
        AppSnackbarType.warning,
        actionLabel,
        onActionPressed,
      );

  /// عرض رسالة معلومات
  static void showInfo(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) =>
      _show(
        context,
        message,
        AppSnackbarType.info,
        actionLabel,
        onActionPressed,
      );

  static void _show(
    BuildContext context,
    String message,
    AppSnackbarType type,
    String? actionLabel,
    VoidCallback? onActionPressed,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor;
    Color foregroundColor;
    IconData icon;

    switch (type) {
      case AppSnackbarType.success:
        backgroundColor = isDark ? AppPalette.greenForest : AppColors.success;
        foregroundColor = AppColors.textOnDark;
        icon = Icons.check_circle;
      case AppSnackbarType.error:
        backgroundColor = isDark ? AppPalette.redBurgundy : AppColors.error;
        foregroundColor = AppColors.textOnDark;
        icon = Icons.error;
      case AppSnackbarType.warning:
        backgroundColor = isDark ? Colors.orange[800]! : AppColors.warning;
        foregroundColor = AppColors.textOnDark;
        icon = Icons.warning;
      case AppSnackbarType.info:
        backgroundColor = isDark ? AppPalette.navyDeep : AppColors.info;
        foregroundColor = AppColors.textOnDark;
        icon = Icons.info;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: foregroundColor, size: IconSizes.md),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                message,
                style:
                    AppTextStyles.bodyMedium.copyWith(color: foregroundColor),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: Radii.borderRadiusMd,
        ),
        elevation: Elevation.md,
        action: actionLabel != null && onActionPressed != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: foregroundColor,
                onPressed: onActionPressed,
              )
            : null,
      ),
    );
  }
}
