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
    final alpha = (opacity * 255).round();

    final r = ((foreground.r * alpha) + (background.r * (255 - alpha))) ~/ 255;
    final g = ((foreground.g * alpha) + (background.g * (255 - alpha))) ~/ 255;
    final b = ((foreground.b * alpha) + (background.b * (255 - alpha))) ~/ 255;

    return Color.fromARGB(255, r, g, b);
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
    final contrast =
        StateContrastCalculator.calculateContrastRatio(textColor, compositedBg);
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
