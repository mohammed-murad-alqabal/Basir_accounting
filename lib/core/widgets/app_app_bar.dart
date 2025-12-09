import 'package:basser_app/core/theme.dart';
import 'package:flutter/material.dart';

/// شريط التطبيق المخصص
///
/// شريط تطبيق (AppBar) مخصص مع تصميم موحد
///
/// Features:
/// - عنوان في المنتصف
/// - زر رجوع قابل للتخصيص
/// - إجراءات في النهاية (اختياري)
/// - ألوان قابلة للتخصيص
/// - بدون ظل (elevation: 0)
///
/// Example:
/// ```dart
/// AppAppBar(
///   title: 'العملاء',
///   actions: [
///     IconButton(
///       icon: Icon(Icons.add),
///       onPressed: () => addCustomer(),
///     ),
///   ],
/// )
/// ```
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// إنشاء شريط تطبيق مخصص
  ///
  /// Parameters:
  /// - [title]: عنوان الشريط (مطلوب)
  /// - [actions]: قائمة الإجراءات في النهاية (اختياري)
  /// - [onBackPressed]: دالة تُستدعى عند الضغط على زر الرجوع (اختياري)
  /// - [showBackButton]: إظهار زر الرجوع (افتراضي: true)
  /// - [backgroundColor]: لون الخلفية (افتراضي: AppColors.surface)
  /// - [foregroundColor]: لون النص والأيقونات (افتراضي: AppColors.textPrimary)
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
    iconTheme: const IconThemeData(size: 26),
    leading: showBackButton
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'رجوع',
            onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          )
        : null,
    actions: actions,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
  /// - [foregroundColor]: لون النص والأيقونات (افتراضي: AppColors.textPrimary)
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
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
