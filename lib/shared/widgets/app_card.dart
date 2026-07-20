import 'dart:async';

import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/responsive_text.dart';
import 'package:flutter/material.dart' hide Durations;
import 'package:flutter/services.dart';

/// بطاقة تطبيق موحدة (Unified App Card)
///
/// مكون بطاقة محسّن يستخدم جميع Design Tokens
/// مع دعم haptic feedback وحركات سلسة
///
/// الميزات:
/// - استخدام CardColors و Spacing tokens
/// - دعم haptic feedback
/// - Scale animation عند الضغط
/// - توافق كامل مع WCAG
///
/// Example:
/// ```dart
/// AppCard(
///   child: Text('محتوى البطاقة'),
///   onTap: () => print('Tapped'),
/// )
/// ```
class AppCard extends StatefulWidget {
  /// إنشاء بطاقة مخصصة
  const AppCard({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.borderColor,
    this.hapticFeedback = true,
    this.isSelected = false,
  });

  /// محتوي البطاقة
  final Widget child;

  /// الحشوة الداخلية (افتراضي: Spacing.md)
  final EdgeInsetsGeometry? padding;

  /// الهامش الخارجي (افتراضي: zero)
  final EdgeInsetsGeometry? margin;

  /// دالة عند الضغط
  final VoidCallback? onTap;

  /// لون الخلفية (افتراضي: CardColors.background)
  final Color? backgroundColor;

  /// الارتفاع (افتراضي: Elevation.sm)
  final double? elevation;

  /// ركن التدوير (افتراضي: Radii.borderRadiusMd)
  final BorderRadius? borderRadius;

  /// لون الحدود (اختياري)
  final Color? borderColor;

  /// تفعیل haptic feedback
  final bool hapticFeedback;

  /// حالة التحقق
  final bool isSelected;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: Durations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: TransformScales.normal,
      end: TransformScales.pressed,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: AnimationCurves.decelerate,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      unawaited(_scaleController.forward());
    }
  }

  void _handleTapUp(TapUpDetails details) {
    unawaited(_scaleController.reverse());
  }

  void _handleTapCancel() {
    unawaited(_scaleController.reverse());
  }

  void _handleTap() {
    if (widget.onTap != null) {
      if (widget.hapticFeedback) {
        unawaited(HapticFeedback.lightImpact());
      }
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final effectiveBackgroundColor =
        widget.backgroundColor ?? CardColors.background;
    final effectiveBorderRadius = widget.borderRadius ?? Radii.borderRadiusMd;
    final effectiveElevation = widget.elevation ?? Elevation.sm;
    final effectivePadding = widget.padding ?? Spacing.paddingMd;

    final Widget card = Container(
      margin: widget.margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: widget.isSelected
              ? BorderContrastDesign.getBorderFocused(brightness)
              : (widget.borderColor ??
                  BorderContrastDesign.getBorderNormal(brightness)),
          width: widget.isSelected ? BorderWidths.normal : BorderWidths.thin,
        ),
        boxShadow: effectiveElevation > 0
            ? [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: effectiveElevation * 2,
                  offset: Offset(0, effectiveElevation),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Padding(padding: effectivePadding, child: widget.child),
      ),
    );

    if (widget.onTap != null) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: Semantics(
          button: true,
          enabled: true,
          label: 'بطاقة تفاعلية',
          selected: widget.isSelected,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: _handleTap,
            behavior: HitTestBehavior.opaque,
            child: card,
          ),
        ),
      );
    }

    return Semantics(container: true, child: card);
  }
}

/// بطاقة قائمة موحدة (Unified App List Card)
class AppListCard extends StatelessWidget {
  /// إنشاء بطاقة قائمة
  const AppListCard({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.leading,
    this.backgroundColor,
    this.isSelected = false,
  });

  /// العنوان
  final String title;

  /// العنوان الفرعي
  final String? subtitle;

  /// ودجت في النهاية (String أو Widget)
  final dynamic trailing;

  /// دالة عند الضغط
  final VoidCallback? onTap;

  /// دالة عند الضغط المطول
  final VoidCallback? onLongPress;

  /// ودجت في البداية
  final Widget? leading;

  /// لون الخلفية
  final Color? backgroundColor;

  /// حالة التحديد
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    Widget? trailingWidget;
    if (trailing is String) {
      trailingWidget = ResponsiveText(
        trailing as String,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeights.semiBold,
          color: AppColors.primary,
        ),
        maxLines: 1,
        autoScale: true,
      );
    } else if (trailing is Widget) {
      trailingWidget = trailing as Widget;
    }

    return GestureDetector(
      onLongPress: onLongPress,
      child: AppCard(
        onTap: onTap,
        backgroundColor: backgroundColor,
        isSelected: isSelected,
        margin: const EdgeInsets.only(bottom: Spacing.sm),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: Spacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ResponsiveText(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeights.semiBold,
                    ),
                    maxLines: 1,
                    autoScale: true,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: Spacing.xs),
                    ResponsiveText(
                      subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ),
            if (trailingWidget != null) ...[
              const SizedBox(width: Spacing.md),
              trailingWidget,
            ],
          ],
        ),
      ),
    );
  }
}

/// بطاقة إحصائية موحدة (Unified App Stat Card)
class AppStatCard extends StatelessWidget {
  /// إنشاء بطاقة إحصائية
  const AppStatCard({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.iconColor,
    this.backgroundColor,
  });

  /// التسمية
  final String label;

  /// القيمة
  final String value;

  /// الأيقونة
  final IconData icon;

  /// لون الأيقونة
  final Color? iconColor;

  /// لون الخلفية
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => AppCard(
        backgroundColor: backgroundColor,
        padding: Spacing.paddingSm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: IconSizes.md,
            ),
            const SizedBox(height: Spacing.xs),
            Flexible(
              child: ResponsiveText(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ResponsiveText(
                  value,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeights.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
}
