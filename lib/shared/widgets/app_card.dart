import 'dart:async';

import 'package:basir_accounting_system/core/theme/border_contrast_design.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/responsive_text.dart';
import 'package:flutter/material.dart' hide Durations;
import 'package:flutter/services.dart';

/// شارة الحالة للبطاقة (Card Status Badge)
enum CardBadgeStatus {
  success,
  error,
  warning,
  info,
  custom,
}

/// بطاقة تطبيق موحدة (Unified App Card)
///
/// مكون بطاقة محسّن يستخدم جميع Design Tokens
/// مع دعم haptic feedback وحركات سلسة وشارات الحالة
///
/// الميزات:
/// - استخدام CardColors و Spacing tokens
/// - دعم haptic feedback
/// - Scale animation عند الضغط
/// - دعم شارات الحالة (Badges) في الزوايا
/// - تغيير بصري واضح عند Hover و Press
/// - توافق كامل مع WCAG
///
/// Example:
/// ```dart
/// AppCard(
///   child: Text('محتوى البطاقة'),
///   onTap: () => print('Tapped'),
///   badgeText: 'جديد',
///   badgeStatus: CardBadgeStatus.success,
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
    this.onLongPress,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.borderColor,
    this.hapticFeedback = true,
    this.isSelected = false,
    this.badgeText,
    this.badgeStatus = CardBadgeStatus.info,
    this.badgeColor,
    this.badgeTextColor,
    this.badgeAlignment = AlignmentDirectional.topEnd,
    this.statusColor,
    this.semanticLabel,
  });

  /// محتوي البطاقة
  final Widget child;

  /// الحشوة الداخلية (افتراضي: Spacing.md)
  final EdgeInsetsGeometry? padding;

  /// الهامش الخارجي (افتراضي: zero)
  final EdgeInsetsGeometry? margin;

  /// دالة عند الضغط
  final VoidCallback? onTap;

  /// دالة عند الضغط المطول
  final VoidCallback? onLongPress;

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

  /// نص الشارة (Badge) في الزاوية - اختياري
  final String? badgeText;

  /// نوع حالة الشارة
  final CardBadgeStatus badgeStatus;

  /// لون مخصص للشارة (يستخدم إذا كان badgeStatus = CardBadgeStatus.custom)
  final Color? badgeColor;

  /// لون نص مخصص للشارة
  final Color? badgeTextColor;

  /// موضع الشارة على البطاقة
  final AlignmentGeometry badgeAlignment;

  /// لون شريط حالة على الحافة (للحالات المرئية السريعة)
  final Color? statusColor;

  /// تسمية وصفية لقارئ الشاشات
  final String? semanticLabel;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  static const double _hoverElevationBoost = 2;
  static const double _hoverScale = 1.01;

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

  void _handleLongPress() {
    if (widget.onLongPress != null) {
      if (widget.hapticFeedback) {
        unawaited(HapticFeedback.mediumImpact());
      }
      widget.onLongPress!();
    }
  }

  Color _getBadgeBackgroundColor() {
    switch (widget.badgeStatus) {
      case CardBadgeStatus.success:
        return AppColors.success;
      case CardBadgeStatus.error:
        return AppColors.error;
      case CardBadgeStatus.warning:
        return AppColors.warning;
      case CardBadgeStatus.info:
        return AppColors.info;
      case CardBadgeStatus.custom:
        return widget.badgeColor ?? AppColors.primary;
    }
  }

  Color _getBadgeForegroundColor() {
    if (widget.badgeTextColor != null) return widget.badgeTextColor!;
    return AppColors.onPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final effectiveBackgroundColor = widget.backgroundColor ?? CardColors.background;
    final effectiveBorderRadius = widget.borderRadius ?? Radii.borderRadiusMd;
    final baseElevation = widget.elevation ?? Elevation.sm;
    final effectiveElevation = _isHovered ? baseElevation + _hoverElevationBoost : baseElevation;
    final effectivePadding = widget.padding ?? Spacing.paddingMd;

    Widget cardContent = Padding(
      padding: effectivePadding,
      child: widget.child,
    );

    if (widget.statusColor != null) {
      cardContent = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: BorderWidths.thick,
            decoration: BoxDecoration(
              color: widget.statusColor,
              borderRadius: BorderRadiusDirectional.horizontal(
                start: Radius.circular(
                  effectiveBorderRadius.resolve(Directionality.of(context)).topLeft.x - 1,
                ),
              ),
            ),
          ),
          Expanded(child: cardContent),
        ],
      );
    }

    if (widget.badgeText != null && widget.badgeText!.isNotEmpty) {
      cardContent = Stack(
        clipBehavior: Clip.none,
        children: [
          cardContent,
          PositionedDirectional(
            top: widget.badgeAlignment == AlignmentDirectional.topEnd ||
                    widget.badgeAlignment == AlignmentDirectional.topStart
                ? -Spacing.sm
                : null,
            bottom: widget.badgeAlignment == AlignmentDirectional.bottomEnd ||
                    widget.badgeAlignment == AlignmentDirectional.bottomStart
                ? -Spacing.sm
                : null,
            end: widget.badgeAlignment == AlignmentDirectional.topEnd ||
                    widget.badgeAlignment == AlignmentDirectional.bottomEnd
                ? -Spacing.sm
                : null,
            start: widget.badgeAlignment == AlignmentDirectional.topStart ||
                    widget.badgeAlignment == AlignmentDirectional.bottomStart
                ? -Spacing.sm
                : null,
            child: Semantics(
              label: 'شارة الحالة: ${widget.badgeText}',
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: _getBadgeBackgroundColor(),
                  borderRadius: BorderRadius.circular(Radii.lg),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      offset: Offset(0, Elevation.sm / 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.badgeText!,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _getBadgeForegroundColor(),
                    fontWeight: FontWeights.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final Widget card = AnimatedContainer(
      duration: Durations.fast,
      curve: AnimationCurves.fastOutSlowIn,
      margin: widget.margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: widget.isSelected
              ? BorderContrastDesign.getBorderFocused(brightness)
              : (widget.borderColor ?? BorderContrastDesign.getBorderNormal(brightness)),
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
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap != null ? _handleTap : null,
            onLongPress: widget.onLongPress != null ? _handleLongPress : null,
            onTapDown: (widget.onTap != null || widget.onLongPress != null) ? _handleTapDown : null,
            onTapUp: (widget.onTap != null || widget.onLongPress != null) ? _handleTapUp : null,
            onTapCancel:
                (widget.onTap != null || widget.onLongPress != null) ? _handleTapCancel : null,
            onHover: (widget.onTap != null || widget.onLongPress != null)
                ? (hovered) => setState(() => _isHovered = hovered)
                : null,
            borderRadius: effectiveBorderRadius,
            child: cardContent,
          ),
        ),
      ),
    );

    final hasInteraction = widget.onTap != null || widget.onLongPress != null;
    final semanticsLabel = widget.semanticLabel ?? (hasInteraction ? 'بطاقة تفاعلية' : 'بطاقة');

    if (hasInteraction) {
      return Semantics(
        button: true,
        enabled: true,
        label: semanticsLabel,
        selected: widget.isSelected,
        child: AnimatedScale(
          duration: Durations.fast,
          curve: AnimationCurves.fastOutSlowIn,
          scale: _isHovered ? _hoverScale : 1.0,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: card,
          ),
        ),
      );
    }

    return Semantics(
      container: true,
      label: semanticsLabel,
      child: card,
    );
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

    final semanticLabel = [
      title,
      if (subtitle != null) subtitle,
      if (trailing is String) trailing as String,
    ].join(' - ');

    return Semantics(
      container: true,
      button: onTap != null || onLongPress != null,
      label: semanticLabel,
      selected: isSelected,
      child: AppCard(
        onTap: onTap,
        onLongPress: onLongPress,
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
