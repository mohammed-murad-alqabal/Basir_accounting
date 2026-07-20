import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';

/// Border contrast design system
abstract final class BorderContrastDesign {
  /// Normal border color (light mode)
  static const Color borderNormalLight = AppColors.border;

  /// Normal border color (dark mode)
  static const Color borderNormalDark = AppPalette.darkBorder;

  /// Focused border color (light mode)
  static const Color borderFocusedLight = AppColors.primary;

  /// Focused border color (dark mode)
  static const Color borderFocusedDark = AppPalette.blueCorporate;

  /// Error border color (light mode)
  static const Color borderErrorLight = AppColors.error;

  /// Error border color (dark mode)
  static const Color borderErrorDark = AppColors.error;

  /// Get normal border color by brightness
  static Color getBorderNormal(Brightness brightness) =>
      brightness == Brightness.light ? borderNormalLight : borderNormalDark;

  /// Get focused border color by brightness
  static Color getBorderFocused(Brightness brightness) =>
      brightness == Brightness.light ? borderFocusedLight : borderFocusedDark;

  /// Get error border color by brightness
  static Color getBorderError(Brightness brightness) =>
      brightness == Brightness.light ? borderErrorLight : borderErrorDark;

  /// Normal border color with sufficient contrast (legacy, for backward compatibility)
  static const Color borderNormal = AppColors.border;

  /// Focused border color (legacy, for backward compatibility)
  static const Color borderFocused = AppColors.primary;

  /// Error border color (legacy, for backward compatibility)
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
