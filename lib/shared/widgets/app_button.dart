import 'dart:async';

import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/shared/widgets/overflow_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// نوع الزر
enum AppButtonType {
  primary,
  secondary,
  outlined,
  text,
  danger,
}

/// حجم الزر
enum AppButtonSize {
  small,
  medium,
  large,
}

/// زر التطبيق الأساسي
class AppButton extends StatefulWidget {
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
    this.textAlign = TextAlign.center,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final bool hapticFeedback;
  final double? width;
  final double? height;
  final Color? color;
  final double? fontSize;
  final String? tooltip;
  final String? semanticLabel;
  final int maxLines;
  final TextAlign textAlign;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;
    final Color bgColor = widget.color ?? _getDefaultBgColor(isEnabled);
    final Color fgColor = _getDefaultFgColor(isEnabled);

    return GestureDetector(
      onTapDown: (_) => isEnabled ? _scaleController.forward() : null,
      onTapUp: (_) => isEnabled ? _scaleController.reverse() : null,
      onTapCancel: () => isEnabled ? _scaleController.reverse() : null,
      onTap: isEnabled ? widget.onPressed : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.isFullWidth ? double.infinity : widget.width,
          height: widget.height ?? _getDefaultHeight(),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: widget.type == AppButtonType.outlined 
                ? Border.all(color: AppColors.primary, width: 2) 
                : null,
            boxShadow: isEnabled && widget.type != AppButtonType.text && widget.type != AppButtonType.outlined
                ? [BoxShadow(color: bgColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                : null,
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: fgColor),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: fgColor, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: fgColor,
                          fontSize: widget.fontSize ?? 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Color _getDefaultBgColor(bool isEnabled) {
    if (!isEnabled) return Colors.grey.shade300;
    return switch (widget.type) {
      AppButtonType.primary => AppColors.primary,
      AppButtonType.secondary => AppColors.secondary,
      AppButtonType.danger => Colors.red,
      _ => Colors.transparent,
    };
  }

  Color _getDefaultFgColor(bool isEnabled) {
    if (!isEnabled) return Colors.grey.shade600;
    if (widget.type == AppButtonType.outlined || widget.type == AppButtonType.text) {
      return AppColors.primary;
    }
    return Colors.white;
  }

  double _getDefaultHeight() {
    return switch (widget.size) {
      AppButtonSize.small => 36,
      AppButtonSize.medium => 48,
      AppButtonSize.large => 56,
    };
  }
}

/// مكون متوافق مع AppPrimaryButton
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      type: AppButtonType.primary,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
    );
  }
}

/// مكون متوافق مع AppSecondaryButton
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      type: AppButtonType.secondary,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
    );
  }
}

/// مكون متوافق مع AppTextButton
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      type: AppButtonType.text,
      icon: icon,
    );
  }
}
