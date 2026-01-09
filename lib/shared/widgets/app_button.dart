/// زر التطبيق المتقدم (Advanced App Button)
///
/// مكون زر محسّن يستخدم جميع Design Tokens
/// مع دعم haptic feedback وحركات سلسة
///
/// الميزات:
/// - 3 أنواع أساسية: Primary, Secondary, Outlined (بالإضافة لـ Text و Danger)
/// - 3 أحجام: Small, Medium, Large
/// - حالة loading مدمجة
/// - Scale animation عند الضغط
/// - Haptic feedback
/// - ضمان WCAG (≥ 44x44px)
/// - دعم ResponsiveText لمنع قص النصوص
library;

import 'dart:async';

import 'package:basir_app/core/theme/app_font_metrics.dart';
import 'package:basir_app/core/theme/font_manager.dart';
// ignore_for_file: deprecated_member_use_from_same_package
// Intentionally using deprecated member
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/shared/widgets/overflow_detector.dart';
import 'package:flutter/material.dart' hide Durations;
import 'package:flutter/services.dart';

/// نوع الزر
enum AppButtonType {
  /// زر أساسي - للإجراءات الرئيسية
  primary,

  /// زر ثانوي - للإجراءات الثانوية
  secondary,

  /// زر محدد - للإجراءات البديلة
  outlined,

  /// زر نصي - للإجراءات الخفيفة
  text,

  /// زر خطر - للإجراءات الحرجة
  danger,
}

/// حجم الزر
enum AppButtonSize {
  /// صغير - 36px height
  small,

  /// متوسط - 44px height (افتراضي)
  medium,

  /// كبير - 52px height
  large,
}

/// زر التطبيق المتقدم
///
/// Example:
/// ```dart
/// AppButton(
///   label: 'حفظ',
///   onPressed: () => print('Saved'),
///   type: AppButtonType.primary,
///   size: AppButtonSize.medium,
/// )
/// ```
/// ```
@Deprecated('Use AppEnhancedButton instead')
class AppButton extends StatefulWidget {
  /// إنشاء زر مخصص متقدم
  @Deprecated('Use AppEnhancedButton instead')
  const AppButton({
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.hapticFeedback = true,
    this.width,
    this.height,
    this.color,
    this.fontSize,
    this.tooltip,
    this.semanticLabel,
    this.maxLines = 1,
    super.key,
  });

  /// نص الزر
  final String label;

  /// الإجراء عند الضغط
  final VoidCallback? onPressed;

  /// نوع الزر
  final AppButtonType type;

  /// حجم الزر
  final AppButtonSize size;

  /// أيقونة اختيارية
  final IconData? icon;

  /// حالة التحميل
  final bool isLoading;

  /// عرض كامل
  final bool isFullWidth;

  /// تفعيل haptic feedback
  final bool hapticFeedback;

  /// عرض مخصص
  final double? width;

  /// ارتفاع مخصص
  final double? height;

  /// لون مخصص (للخلفية أو النص حسب النوع)
  final Color? color;

  /// حجم خط مخصص
  final double? fontSize;

  /// نص تلميح
  final String? tooltip;

  /// تسمية للوصول (accessibility)
  final String? semanticLabel;

  /// عدد الأسطر الأقصى للنص
  final int maxLines;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
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
    if (widget.onPressed != null && !widget.isLoading) {
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
    if (widget.onPressed != null && !widget.isLoading) {
      if (widget.hapticFeedback) {
        unawaited(HapticFeedback.lightImpact());
      }
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    final textScaleFactor = MediaQuery.of(context).textScaler.scale(1);

    // Cairo-optimized metrics
    final fontSize = widget.fontSize ?? _getFontSizeValue();
    final fontMetrics = FontMetricsHelper.getCairoMetrics(fontSize);
    final padding = fontMetrics.calculatePadding(
      textScaleFactor: textScaleFactor,
      minVerticalPadding: _getMinVerticalPadding(),
      horizontalPadding: _getHorizontalPaddingValue(),
    );
    final minHeight = fontMetrics.calculateMinButtonHeight(
      textScaleFactor: textScaleFactor,
      minHeight: widget.height ?? _getHeight(),
    );

    Widget button = ScaleTransition(
      scale: _scaleAnimation,
      child: Semantics(
        container: true,
        button: true,
        enabled: isEnabled,
        label: widget.semanticLabel ?? widget.label,
        onTap: isEnabled ? _handleTap : null,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: _handleTap,
          child: AnimatedContainer(
            /// (Default: [Durations.short3] for scale,
            /// [Durations.medium1] for color)
            duration: Durations.short,
            curve: AnimationCurves.decelerate,
            width:
                widget.width ?? (widget.isFullWidth ? double.infinity : null),
            constraints: BoxConstraints(minHeight: minHeight),
            padding: padding,
            decoration: _getDecoration(colorScheme, isEnabled),
            child: ExcludeSemantics(
              child: _buildContent(colorScheme, isEnabled),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      button = Tooltip(message: widget.tooltip, child: button);
    }

    return OverflowDetector(
      name: 'AppButton(${widget.label})',
      child: button,
    );
  }

  double _getFontSizeValue() => switch (widget.size) {
        AppButtonSize.small => 14,
        AppButtonSize.medium => 16,
        AppButtonSize.large => 18,
      };

  double _getMinVerticalPadding() => switch (widget.size) {
        AppButtonSize.small => 8,
        AppButtonSize.medium => 12,
        AppButtonSize.large => 16,
      };

  double _getHorizontalPaddingValue() => switch (widget.size) {
        AppButtonSize.small => 12,
        AppButtonSize.medium => 16,
        AppButtonSize.large => 20,
      };

  double _getHeight() => switch (widget.size) {
        AppButtonSize.small => TouchTargets.buttonHeightSm,
        AppButtonSize.medium => TouchTargets.buttonHeightMd,
        AppButtonSize.large => TouchTargets.buttonHeightLg,
      };

  BoxDecoration _getDecoration(ColorScheme colorScheme, bool isEnabled) {
    final backgroundColor = _getBackgroundColor(colorScheme, isEnabled);
    final borderColor = _getBorderColor(colorScheme, isEnabled);

    return BoxDecoration(
      color: backgroundColor,
      borderRadius: Radii.borderRadiusMd,
      border: widget.type == AppButtonType.outlined
          ? Border.all(
              color: borderColor,
              width: BorderWidths.normal,
            )
          : null,
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme, bool isEnabled) {
    if (!isEnabled) {
      return colorScheme.onSurface.withValues(alpha: Opacities.disabled);
    }

    return switch (widget.type) {
      AppButtonType.primary => widget.color ?? colorScheme.primary,
      AppButtonType.secondary => widget.color ?? colorScheme.secondary,
      AppButtonType.danger => widget.color ?? colorScheme.error,
      AppButtonType.outlined || AppButtonType.text => Colors.transparent,
    };
  }

  Color _getBorderColor(ColorScheme colorScheme, bool isEnabled) {
    if (!isEnabled) {
      return colorScheme.onSurface.withValues(alpha: Opacities.disabled);
    }

    return switch (widget.type) {
      AppButtonType.outlined => widget.color ?? colorScheme.primary,
      _ => Colors.transparent,
    };
  }

  Color _getForegroundColor(ColorScheme colorScheme, bool isEnabled) {
    if (!isEnabled) {
      return colorScheme.onSurface.withValues(alpha: Opacities.disabled);
    }

    return switch (widget.type) {
      AppButtonType.primary ||
      AppButtonType.secondary ||
      AppButtonType.danger =>
        colorScheme.onPrimary,
      AppButtonType.outlined ||
      AppButtonType.text =>
        widget.color ?? colorScheme.primary,
    };
  }

  Widget _buildContent(ColorScheme colorScheme, bool isEnabled) {
    if (widget.isLoading) {
      return _buildLoadingIndicator(colorScheme, isEnabled);
    }

    final foregroundColor = _getForegroundColor(colorScheme, isEnabled);
    final textStyle = _getTextStyle().copyWith(
      color: foregroundColor,
      height: FontManager.isPrimaryFontLoaded ? 1.4 : 1.3,
    );

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            size: _getIconSize(),
            color: foregroundColor,
          ),
          const SizedBox(width: Spacing.sm),
          Flexible(
            child: Text(
              widget.label,
              style: textStyle,
              textAlign: TextAlign.center,
              maxLines: widget.maxLines,
              overflow: TextOverflow.visible,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      );
    }

    return Center(
      child: Text(
        widget.label,
        style: textStyle,
        textAlign: TextAlign.center,
        maxLines: widget.maxLines,
        overflow: TextOverflow.visible,
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildLoadingIndicator(ColorScheme colorScheme, bool isEnabled) {
    final foregroundColor = _getForegroundColor(colorScheme, isEnabled);

    return Center(
      child: SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      ),
    );
  }

  TextStyle _getTextStyle() {
    final baseStyle = switch (widget.size) {
      AppButtonSize.small => AppTextStyles.labelMedium,
      AppButtonSize.medium => AppTextStyles.labelLarge,
      AppButtonSize.large => AppTextStyles.titleSmall,
    };

    if (widget.fontSize != null) {
      return baseStyle.copyWith(fontSize: widget.fontSize);
    }

    return baseStyle;
  }

  double _getIconSize() => switch (widget.size) {
        AppButtonSize.small => IconSizes.sm,
        AppButtonSize.medium => IconSizes.md,
        AppButtonSize.large => IconSizes.lg,
      };
}

// ═══════════════════════════════════════════════════════════════════════════
// Backward Compatibility Wrappers (دوال متوافقة مع الإصدارات السابقة)
// ═══════════════════════════════════════════════════════════════════════════

/// مغلف لـ AppPrimaryButton للحفاظ على التوافق مع الكود الموجود
@Deprecated('Use AppEnhancedButton instead')
class AppPrimaryButton extends StatelessWidget {
  /// إنشاء زر أساسي متوافق مع الإصدارات السابقة
  @Deprecated('Use AppEnhancedButton instead')
  const AppPrimaryButton({
    @Deprecated('Use label instead') String? text,
    String? label,
    this.onPressed,
    super.key,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.tooltip,
    this.semanticLabel,
  }) : label = label ?? text ?? '';

  /// نص الزر
  final String label;

  /// دالة عند الضغط
  final VoidCallback? onPressed;

  /// حالة التحميل
  final bool isLoading;

  /// أيقونة اختيارية
  final IconData? icon;

  /// العرض
  final double? width;

  /// الارتفاع
  final double? height;

  /// نص التلميح
  final String? tooltip;

  /// تسمية إمكانية الوصول
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => AppButton(
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        icon: icon,
        width: width,
        height: height,
        isFullWidth: width == double.infinity,
      );
}

/// مغلف لـ AppSecondaryButton للحفاظ على التوافق مع الكود الموجود
@Deprecated('Use AppEnhancedButton instead')
class AppSecondaryButton extends StatelessWidget {
  /// إنشاء زر ثانوي متوافق مع الإصدارات السابقة
  @Deprecated('Use AppEnhancedButton instead')
  const AppSecondaryButton({
    @Deprecated('Use label instead') String? text,
    String? label,
    this.onPressed,
    super.key,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.tooltip,
    this.semanticLabel,
  }) : label = label ?? text ?? '';

  /// نص الزر
  final String label;

  /// دالة عند الضغط
  final VoidCallback? onPressed;

  /// حالة التحميل
  final bool isLoading;

  /// أيقونة اختيارية
  final IconData? icon;

  /// العرض
  final double? width;

  /// الارتفاع
  final double? height;

  /// نص التلميح
  final String? tooltip;

  /// تسمية إمكانية الوصول
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => AppButton(
        label: label,
        onPressed: onPressed,
        type: AppButtonType.outlined,
        isLoading: isLoading,
        icon: icon,
        width: width,
        height: height,
        isFullWidth: width == double.infinity,
      );
}

/// مغلف لـ AppTextButton للحفاظ على التوافق مع الكود الموجود
@Deprecated('Use AppEnhancedButton instead')
class AppTextButton extends StatelessWidget {
  /// إنشاء زر نصي متوافق مع الإصدارات السابقة
  @Deprecated('Use AppEnhancedButton instead')
  const AppTextButton({
    @Deprecated('Use label instead') String? text,
    String? label,
    this.onPressed,
    super.key,
    this.color,
    this.fontSize,
    this.icon,
  }) : label = label ?? text ?? '';

  /// نص الزر
  final String label;

  /// دالة عند الضغط
  final VoidCallback? onPressed;

  /// لون النص
  final Color? color;

  /// حجم الخط
  final double? fontSize;

  /// أيقونة اختيارية
  final IconData? icon;

  @override
  Widget build(BuildContext context) => AppButton(
        label: label,
        onPressed: onPressed,
        type: AppButtonType.text,
        icon: icon,
        color: color,
        fontSize: fontSize,
      );
}
