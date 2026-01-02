import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/theme/services/icon_customization_service.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شريط التطبيق الموحد للمشروع
class AppAppBar extends ConsumerWidget implements PreferredSizeWidget {
  /// إنشاء شريط تطبيق مخصص
  ///
  /// Parameters:
  /// - [title]: عنوان الشريط (مطلوب)
  /// - [actions]: قائمة الإجراءات في النهاية (اختياري)
  /// - [onBackPressed]: دالة تُستدعى عند الضغط على زر الرجوع (اختياري)
  /// - [showBackButton]: إظهار زر الرجوع (افتراضي: true)
  /// - [backgroundColor]: لون الخلفية (افتراضي: AppColors.surface)
  /// - [foregroundColor]: لون النص والأيقونات
  /// (افتراضي: AppColors.textPrimary)
  const AppAppBar({
    required this.title,
    super.key,
    this.actions,
    this.onBackPressed,
    this.showBackButton = true,
    this.backgroundColor = AppColors.surface,
    this.foregroundColor = AppColors.textPrimary,
  });

  /// عنوان شريط التطبيق
  final String title;

  /// قائمة الإجراءات (أزرار) في نهاية الشريط
  final List<Widget>? actions;

  /// دالة تُستدعى عند الضغط على زر الرجوع
  /// إذا كانت null، يتم استخدام Navigator.pop
  final VoidCallback? onBackPressed;

  /// إظهار أو إخفاء زر الرجوع
  final bool showBackButton;

  /// لون خلفية الشريط
  final Color? backgroundColor;

  /// لون النص والأيقونات
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIcons = ref.watch(appIconsProvider);

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppTypography.titleLarge,
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(size: 26),
      leading: showBackButton
          ? IconButton(
              icon: Icon(appIcons.back),
              tooltip: context.l10n.tooltipBack,
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: AppColors.primary.withValues(alpha: 0.1),
          height: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
        kToolbarHeight + 1.0,
      );
}

/// شريط تطبيق بسيط بدون زر رجوع
///
/// شريط تطبيق مبسط للشاشات الرئيسية
///
/// Features:
/// - عنوان في المنتصف
/// - بدون زر رجوع
/// - إجراءات في النهاية (اختياري)
/// - ألوان قابلة للتخصيص
/// - بدون ظل (elevation: 0)
///
/// Example:
/// ```dart
/// AppSimpleAppBar(
///   title: 'لوحة التحكم',
///   actions: [
///     IconButton(
///       icon: Icon(Icons.settings),
///       onPressed: () => openSettings(),
///     ),
///   ],
/// )
/// ```
class AppSimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// إنشاء شريط تطبيق بسيط
  ///
  /// Parameters:
  /// - [title]: عنوان الشريط (مطلوب)
  /// - [actions]: قائمة الإجراءات في النهاية (اختياري)
  /// - [backgroundColor]: لون الخلفية (افتراضي: AppColors.surface)
  /// - [foregroundColor]: لون النص والأيقونات
  /// (افتراضي: AppColors.textPrimary)
  const AppSimpleAppBar({
    required this.title,
    super.key,
    this.actions,
    this.backgroundColor = AppColors.surface,
    this.foregroundColor = AppColors.textPrimary,
  });

  /// عنوان شريط التطبيق
  final String title;

  /// قائمة الإجراءات (أزرار) في نهاية الشريط
  final List<Widget>? actions;

  /// لون خلفية الشريط
  final Color? backgroundColor;

  /// لون النص والأيقونات
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppTypography.titleLarge,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
          ),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: actions,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.primary.withValues(alpha: 0.1),
            height: 1,
          ),
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(
        kToolbarHeight + 1.0,
      );
}
