import 'dart:async';

import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// زر محسّن (Enhanced Button)
///
/// يقدم تجربة بصرية فائقة مع دعم للتدرجات اللونية (Gradients) وتأثيرات الظلال المتقدمة.
class AppEnhancedButton extends StatefulWidget {
  /// المنشئ
  const AppEnhancedButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.width,
    this.height = 54,
    this.elevation = 4,
  });

  /// نص الزر
  final String label;

  /// الإجراء عند الضغط
  final VoidCallback? onPressed;

  /// أيقونة اختيارية
  final IconData? icon;

  /// حالة التحميل
  final bool isLoading;

  /// تدرج لوني للخلفية
  final Gradient? gradient;

  /// لون الخلفية (إذا لم يتوفر gradient)
  final Color? backgroundColor;

  /// لون النص والأيقونة
  final Color? foregroundColor;

  /// تدوير الحواف
  final BorderRadius? borderRadius;

  /// العرض
  final double? width;

  /// الارتفاع
  final double height;

  /// مقدار الارتفاع (الظل)
  final double elevation;

  @override
  State<AppEnhancedButton> createState() => _AppEnhancedButtonState();
}

class _AppEnhancedButtonState extends State<AppEnhancedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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

    final effectiveGradient =
        widget.gradient ?? (isEnabled ? AppGradients.primary : null);

    final effectiveBgColor = widget.backgroundColor ??
        (isEnabled ? AppColors.primary : AppColors.disabled);

    final effectiveFgColor = widget.foregroundColor ?? Colors.white;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isEnabled ? widget.onPressed : null,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: effectiveGradient == null ? effectiveBgColor : null,
            gradient: effectiveGradient,
            borderRadius: widget.borderRadius ?? Radii.borderRadiusMd,
            boxShadow: isEnabled && widget.elevation > 0
                ? [
                    BoxShadow(
                      color: (widget.backgroundColor ?? AppColors.primary)
                          .withValues(alpha: 0.3),
                      blurRadius: widget.elevation * 2,
                      offset: Offset(0, widget.elevation),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(effectiveFgColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: effectiveFgColor, size: 22),
                        const SizedBox(width: Spacing.sm),
                      ],
                      Text(
                        widget.label,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: effectiveFgColor,
                          fontWeight: FontWeights.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
