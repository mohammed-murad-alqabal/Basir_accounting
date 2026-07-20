import 'dart:math';

import 'package:flutter/material.dart';

/// Calculates contrast ratios and color transformations for interactive states
class StateContrastCalculator {
  /// Calculate relative luminance as per WCAG 2.1
  static double calculateRelativeLuminance(Color color) {
    final r = _linearize(color.red / 255.0);
    final g = _linearize(color.green / 255.0);
    final b = _linearize(color.blue / 255.0);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _linearize(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    } else {
      return pow((value + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  /// Calculate contrast ratio between two colors
  static double calculateContrastRatio(Color foreground, Color background) {
    final l1 = calculateRelativeLuminance(foreground);
    final l2 = calculateRelativeLuminance(background);

    final lighter = max(l1, l2);
    final darker = min(l1, l2);

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Darken a color by [percentage] (0.0 to 1.0)
  static Color darken(Color color, double percentage) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness * (1 - percentage)).clamp(0.0, 1.0)).toColor();
  }

  /// Lighten a color by [percentage] (0.0 to 1.0)
  static Color lighten(Color color, double percentage) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness(
          (hsl.lightness + (1 - hsl.lightness) * percentage).clamp(0.0, 1.0),
        )
        .toColor();
  }

  /// Calculates Delta E (CIE76) between two colors for visual difference check
  static double calculateDeltaE(Color color1, Color color2) {
    final lab1 = _rgbToLab(color1);
    final lab2 = _rgbToLab(color2);

    final deltaL = lab1.l - lab2.l;
    final deltaA = lab1.a - lab2.a;
    final deltaB = lab1.b - lab2.b;

    return sqrt(deltaL * deltaL + deltaA * deltaA + deltaB * deltaB);
  }

  static _LabColor _rgbToLab(Color color) {
    var r = color.red / 255.0;
    var g = color.green / 255.0;
    var b = color.blue / 255.0;

    r = r > 0.04045 ? pow((r + 0.055) / 1.055, 2.4).toDouble() : r / 12.92;
    g = g > 0.04045 ? pow((g + 0.055) / 1.055, 2.4).toDouble() : g / 12.92;
    b = b > 0.04045 ? pow((b + 0.055) / 1.055, 2.4).toDouble() : b / 12.92;

    var x = r * 0.4124 + g * 0.3576 + b * 0.1805;
    var y = r * 0.2126 + g * 0.7152 + b * 0.0722;
    var z = r * 0.0193 + g * 0.1192 + b * 0.9505;

    const xn = 0.95047;
    const yn = 1;
    const zn = 1.08883;

    x = x / xn;
    y = y / yn;
    z = z / zn;

    x = x > 0.008856 ? pow(x, 1 / 3).toDouble() : (7.787 * x) + (16 / 116);
    y = y > 0.008856 ? pow(y, 1 / 3).toDouble() : (7.787 * y) + (16 / 116);
    z = z > 0.008856 ? pow(z, 1 / 3).toDouble() : (7.787 * z) + (16 / 116);

    return _LabColor(
      116 * y - 16,
      500 * (x - y),
      200 * (y - z),
    );
  }

  /// Check if two colors have a minimum visual difference
  static bool hasMinimumVisualDifference(
    Color color1,
    Color color2, {
    double threshold = 10.0,
  }) =>
      calculateDeltaE(color1, color2) >= threshold;
}

class _LabColor {
  _LabColor(this.l, this.a, this.b);
  final double l;
  final double a;
  final double b;
}
