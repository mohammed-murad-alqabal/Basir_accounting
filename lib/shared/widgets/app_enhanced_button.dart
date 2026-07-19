import 'dart:async';

import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/overflow_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// نوع الزر المحسّن
enum AppEnhancedButtonType {
  /// زر أساسي - تدرج لوني بريميوم
  primary,

  /// زر ثانوي - لون ثانوي
  secondary,

  /// زر محدد - حدود فقط
  outlined,

  /// زر نصي - بدون خلفية
  text,

  /// زر خطر - لون خطأ
  danger,
}

/// زر محسّن (Enhanced Button)
///
/// يقدم تجربة بصرية فائقة مع دعم للتدرجات اللونية (Gradients) وتأثيرات
/// الظلال المتقدمة، مع ضمان مرونة النصوص ودعم إمكانية الوصول.
class AppEnhancedButton extends StatefulWidget {
  /// المنشئ
  const AppEnhancedButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.type = AppEnhancedButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.width,
    this.height = 54,
    this.elevation,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
  });

  /// نص الزر
  final String label;

  /// الإجراء عند الضغط
  final VoidCallback? onPressed;

  /// نوع الزر
  final AppEnhancedButtonType type;

  /// أيقونة اختيارية
  final IconData? icon;

  /// حالة التحميل
  final bool isLoading;

  /// تدرج لوني للخلفية (اختياري - يتجاوز النوع)
  final Gradient? gradient;

  /// لون الخلفية (اختياري - يتجاوز النوع)
  final Color? backgroundColor;

  /// لون النص والأيقونة (اختياري - يتجاوز النوع)
  final Color? foregroundColor;

  /// تدوير الحواف
  final BorderRadius? borderRadius;

  /// العرض
  final double? width;

  /// الارتفاع
  final double height;

  /// مقدار الارتفاع (الظل)
  final double? elevation;

  /// عدد الأسطر الأقصى للنص
  final int maxLines;

  /// محاذاة النص
  final TextAlign textAlign;

  @override
  State<AppEnhancedButton> createState() => _AppEnhancedButtonState();
}

// ignore: lines_longer_than_80_chars
class _AppEnhancedButtonState extends State<AppEnhancedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(
      begin: 1,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      unawaited(_controller.forward());
      unawaited(HapticFeedback.selectionClick());
    }
  }

  void _onTapUp(TapUpDetails details) {
    unawaited(_controller.reverse());
  }

  void _onTapCancel() {
    unawaited(_controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    final gradient = widget.gradient ?? _getDefaultGradient(isEnabled);
    final bgColor = widget.backgroundColor ?? _getDefaultBgColor(isEnabled);
    final fgColor = widget.foregroundColor ?? _getDefaultFgColor(isEnabled);
    final elevation = widget.elevation ?? _getDefaultElevation();

    // Calculate shadow color separately to avoid long line
    final shadowBase = widget.backgroundColor ?? _getShadowColor();
    final shadowColor = shadowBase.withValues(alpha: 0.25);

    final textStyle = AppTextStyles.titleMedium.copyWith(
      color: fgColor,
      fontWeight: FontWeights.bold,
    );

    final mouseCursor = isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden;

    return OverflowDetector(
      name: 'AppEnhancedButton(${widget.label})',
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: mouseCursor,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: isEnabled ? widget.onPressed : null,
            child: ScaleTransition(
              scale: _scale,
              child: Container(
                width: widget.width ?? double.infinity,
                constraints: BoxConstraints(minHeight: widget.height),
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                decoration: BoxDecoration(
                  color: gradient == null
                      ? _isHovered && isEnabled
                          ? bgColor.withValues(alpha: 0.9)
                          : bgColor
                      : null,
                  gradient: gradient == null
                      ? null
                      : _isHovered && isEnabled
                          ? _darkenGradient(gradient)
                          : gradient,
                  borderRadius: widget.borderRadius ?? Radii.borderRadiusMd,
                  border: widget.type == AppEnhancedButtonType.outlined
                      ? Border.all(
                          color: _isFocused ? AppColors.primaryDark : fgColor,
                          width: _isFocused ? 2.0 : 1.5,
                        )
                      : _isFocused
                          ? Border.all(color: AppColors.primaryDark, width: 2)
                          : null,
                  boxShadow: isEnabled && elevation > 0
                      ? [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: elevation * 2,
                            offset: Offset(0, elevation),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  type: MaterialType.transparency,
                  borderRadius: widget.borderRadius ?? Radii.borderRadiusMd,
                  child: InkWell(
                    onTap: isEnabled ? widget.onPressed : null,
                    customBorder: RoundedRectangleBorder(
                      borderRadius: widget.borderRadius ?? Radii.borderRadiusMd,
                    ),
                    child: Center(
                      child: widget.isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  fgColor,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Spacing.xs,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.icon != null) ...[
                                    Icon(
                                      widget.icon,
                                      color: fgColor,
                                      size: 22,
                                    ),
                                    const SizedBox(width: Spacing.sm),
                                  ],
                                  Flexible(
                                    child: Text(
                                      widget.label,
                                      style: textStyle,
                                      textAlign: widget.textAlign,
                                      maxLines: widget.maxLines,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Gradient _darkenGradient(Gradient original) {
    if (original is LinearGradient) {
      final originalColors = original.colors;
      final modifiedColors = originalColors.map((color) => color.withValues(alpha: 0.9)).toList();
      return LinearGradient(
        colors: modifiedColors,
        begin: original.begin,
        end: original.end,
      );
    }
    return original;
  }

  Gradient? _getDefaultGradient(bool isEnabled) {
    if (!isEnabled) return null;
    return switch (widget.type) {
      AppEnhancedButtonType.primary => AppGradients.primary,
      _ => null,
    };
  }

  Color _getDefaultBgColor(bool isEnabled) {
    if (!isEnabled) return AppColors.disabled.withValues(alpha: 0.6);
    return switch (widget.type) {
      AppEnhancedButtonType.primary => AppColors.primary,
      AppEnhancedButtonType.secondary => AppColors.secondary,
      AppEnhancedButtonType.danger => AppColors.error,
      AppEnhancedButtonType.outlined => Colors.transparent,
      AppEnhancedButtonType.text => Colors.transparent,
    };
  }

  Color _getDefaultFgColor(bool isEnabled) {
    if (!isEnabled) return AppColors.textDisabled;
    return switch (widget.type) {
      AppEnhancedButtonType.outlined => AppColors.primary,
      AppEnhancedButtonType.text => AppColors.primary,
      _ => Colors.white,
    };
  }

  double _getDefaultElevation() => switch (widget.type) {
        AppEnhancedButtonType.outlined => 0,
        AppEnhancedButtonType.text => 0,
        _ => 4.0,
      };

  Color _getShadowColor() => switch (widget.type) {
        AppEnhancedButtonType.primary => AppColors.primary,
        AppEnhancedButtonType.secondary => AppColors.secondary,
        AppEnhancedButtonType.danger => AppColors.error,
        _ => Colors.transparent,
      };
}
