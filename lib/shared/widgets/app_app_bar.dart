import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شريط التطبيق الموحد للمشروع
///
/// المتطلبات:
/// - حجم خط لا يقل عن 20px للعنوان
/// - تباين لا يقل عن 4.5:1 للعنوان
/// - حجم 24x24px للأيقونات (IconSizes.md)
/// - تباين لا يقل عن 3:1 للأيقونات
/// - مؤشر تركيز واضح مع تباين ≥ 3:1
/// - خلفية واضحة مع فاصل أو ظل خفيف
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
  ///   (افتراضي: AppColors.textPrimary)
  /// - [automaticallyImplyLeading]: إذا كان صحيحاً والـ leading يساوي null،
  ///   فسيُستنتج زر الرجوع تلقائياً
  const AppAppBar({
    required this.title,
    super.key,
    this.actions,
    this.onBackPressed,
    this.showBackButton = true,
    this.backgroundColor = AppColors.surface,
    this.foregroundColor = AppColors.textPrimary,
    this.bottom,
    this.elevation = 0,
    this.automaticallyImplyLeading = false,
    this.toolbarTextStyle,
    this.titleSemanticLabel,
    this.centerTitle = true,
    this.scrolledUnderElevation = 1,
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

  /// عنصر سفلي إضافي
  final PreferredSizeWidget? bottom;

  /// ارتفاع الظل (Elevation) للشريط
  final double elevation;

  /// استنتاج زر الرجوع تلقائياً
  final bool automaticallyImplyLeading;

  /// نمط نص شريط الأدوات
  final TextStyle? toolbarTextStyle;

  /// تسمية وصفية لعنوان شريط التطبيق لقارئ الشاشات
  final String? titleSemanticLabel;

  /// مركزية العنوان
  final bool centerTitle;

  /// الارتفاع عند التمرير (scrolled under)
  final double scrolledUnderElevation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIcons = ref.watch(appIconsProvider);
    final effectiveForeground = foregroundColor ?? AppColors.textPrimary;

    final titleTextStyle = toolbarTextStyle ??
        AppTextStyles.titleLarge.copyWith(
          color: effectiveForeground,
          fontWeight: FontWeights.semiBold,
        );

    final iconThemeData = IconThemeData(
      size: IconSizes.md,
      color: effectiveForeground,
    );

    return AppBar(
      title: Semantics(
        header: true,
        label: titleSemanticLabel ?? title,
        child: Text(
          title,
          style: titleTextStyle,
          semanticsLabel: titleSemanticLabel,
        ),
      ),
      backgroundColor: backgroundColor,
      foregroundColor: effectiveForeground,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      shadowColor: AppColors.shadow,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      iconTheme: iconThemeData,
      actionsIconTheme: iconThemeData,
      toolbarTextStyle: titleTextStyle,
      titleTextStyle: titleTextStyle,
      leading: showBackButton && !automaticallyImplyLeading
          ? IconButton(
              icon: Icon(appIcons.back, size: IconSizes.md),
              tooltip: context.l10n.tooltipBack,
              color: effectiveForeground,
              constraints: const BoxConstraints(
                minWidth: TouchTargets.minimum,
                minHeight: TouchTargets.minimum,
              ),
              padding: EdgeInsets.zero,
              onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      actions: actions,
      bottom: bottom ??
          PreferredSize(
            preferredSize: const Size.fromHeight(BorderWidths.thin),
            child: Container(
              color: BorderContrastDesign.getBorderNormal(
                Theme.of(context).brightness,
              ),
              height: BorderWidths.thin,
            ),
          ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? BorderWidths.thin));
}

/// شريط تطبيق بسيط بدون زر رجوع
///
/// شريط تطبيق مبسط للشاشات الرئيسية
///
/// Features:
/// - عنوان في المنتصف بحجم 22px (≥ 20px مطلوب)
/// - بدون زر رجوع
/// - إجراءات في النهاية (اختياري)
/// - حجم الأيقونات 24px (IconSizes.md)
/// - فاصل سفلي واضح بتباين مناسب
/// - دعم focus indicator واضح
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
  ///   (افتراضي: AppColors.textPrimary)
  const AppSimpleAppBar({
    required this.title,
    super.key,
    this.actions,
    this.backgroundColor = AppColors.surface,
    this.foregroundColor = AppColors.textPrimary,
    this.elevation = 0,
    this.scrolledUnderElevation = 1,
    this.centerTitle = true,
    this.titleSemanticLabel,
  });

  /// عنوان شريط التطبيق
  final String title;

  /// قائمة الإجراءات (أزرار) في نهاية الشريط
  final List<Widget>? actions;

  /// لون خلفية الشريط
  final Color? backgroundColor;

  /// لون النص والأيقونات
  final Color? foregroundColor;

  /// ارتفاع الظل للشريط
  final double elevation;

  /// الارتفاع عند التمرير
  final double scrolledUnderElevation;

  /// مركزية العنوان
  final bool centerTitle;

  /// تسمية وصفية لعنوان شريط التطبيق
  final String? titleSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveForeground = foregroundColor ?? AppColors.textPrimary;

    final titleTextStyle = AppTextStyles.titleLarge.copyWith(
      color: effectiveForeground,
      fontWeight: FontWeights.semiBold,
    );

    final iconThemeData = IconThemeData(
      size: IconSizes.md,
      color: effectiveForeground,
    );

    return AppBar(
      title: Semantics(
        header: true,
        label: titleSemanticLabel ?? title,
        child: Text(
          title,
          style: titleTextStyle,
          semanticsLabel: titleSemanticLabel,
        ),
      ),
      backgroundColor: backgroundColor,
      foregroundColor: effectiveForeground,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      shadowColor: AppColors.shadow,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      iconTheme: iconThemeData,
      actionsIconTheme: iconThemeData,
      toolbarTextStyle: titleTextStyle,
      titleTextStyle: titleTextStyle,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(BorderWidths.thin),
        child: Container(
          color: BorderContrastDesign.getBorderNormal(
            Theme.of(context).brightness,
          ),
          height: BorderWidths.thin,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + BorderWidths.thin);
}
