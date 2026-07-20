import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// Border contrast design system
abstract final class BorderContrastDesign {
  /// Normal border color with sufficient contrast
  static const Color borderNormal = AppColors.border;

  /// Focused border color
  static const Color borderFocused = AppColors.primary;

  /// Error border color
  static const Color borderError = AppColors.error;

  /// Border widths
  static const double borderWidthNormal = 1;
  static const double borderWidthFocused = 2;
  static const double borderWidthError = 2;

  /// Build an enhanced border for inputs
  static OutlineInputBorder buildEnhancedInputBorder({
    Color? color,
    double? width,
    BorderRadius? radius,
    double circularRadius = 12,
  }) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: color ?? borderNormal,
          width: width ?? borderWidthNormal,
        ),
        borderRadius: radius ?? BorderRadius.circular(circularRadius),
      );

  /// Build an enhanced divider
  static Divider buildEnhancedDivider({
    Color? color,
    double thickness = 1.0,
  }) =>
      Divider(
        color: color ?? borderNormal,
        thickness: thickness,
      );
}
