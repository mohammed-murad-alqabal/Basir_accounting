import 'package:basir_accounting_system/core/theme/accessibility/state_contrast_calculator.dart';
import 'package:flutter/material.dart';

/// Safe opacity and compositing design system
abstract final class OpacityCompositingDesign {
  /// Calculate composited color after applying opacity
  static Color calculateCompositedColor({
    required Color foreground,
    required Color background,
    required double opacity,
  }) {
    final fgR = foreground.r;
    final fgG = foreground.g;
    final fgB = foreground.b;
    final bgR = background.r;
    final bgG = background.g;
    final bgB = background.b;

    final r = (fgR * opacity + bgR * (1.0 - opacity)).clamp(0.0, 1.0);
    final g = (fgG * opacity + bgG * (1.0 - opacity)).clamp(0.0, 1.0);
    final b = (fgB * opacity + bgB * (1.0 - opacity)).clamp(0.0, 1.0);

    return Color.fromARGB(
      255,
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
    );
  }

  /// Verify that text on composited background meets contrast requirements
  static bool verifyCompositedContrast({
    required Color textColor,
    required Color foreground,
    required Color background,
    required double opacity,
    double minContrast = 4.5,
  }) {
    final compositedBg = calculateCompositedColor(
      foreground: foreground,
      background: background,
      opacity: opacity,
    );
    final contrast = StateContrastCalculator.calculateContrastRatio(textColor, compositedBg);
    return contrast >= minContrast;
  }

  /// Build a widget with safe opacity that meets contrast requirements
  static Widget buildSafeOpacityWidget({
    required Widget child,
    required double opacity,
    required Color textColor,
    required Color background,
  }) {
    final meetsContrast = verifyCompositedContrast(
      textColor: textColor,
      foreground: Colors.black,
      background: background,
      opacity: opacity,
    );

    if (!meetsContrast) {
      return child; // Return without opacity if contrast fails
    }

    return Opacity(opacity: opacity, child: child);
  }

  /// Build a safe overlay that ensures text remains readable underneath
  static Widget buildSafeOverlay({
    required Widget child,
    required Color overlayColor,
    required double overlayOpacity,
    required Color textColorUnderneath,
    required Color backgroundUnderneath,
  }) {
    final meetsContrast = verifyCompositedContrast(
      textColor: textColorUnderneath,
      foreground: overlayColor,
      background: backgroundUnderneath,
      opacity: overlayOpacity,
    );

    final effectiveOpacity = meetsContrast ? overlayOpacity : 0.0;

    return Opacity(
      opacity: effectiveOpacity,
      child: ColoredBox(
        color: overlayColor,
        child: child,
      ),
    );
  }
}
