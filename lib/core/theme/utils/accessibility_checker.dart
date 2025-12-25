import 'package:flutter/material.dart';

/// فحص إمكانية الوصول (Accessibility Checker)
///
/// مجموعة من الأدوات للتحقق من توافق الواجهة مع معايير إمكانية الوصول
class AccessibilityChecker {
  /// التحقق من تباين النص (WCAG Contrast Ratio)
  ///
  /// يحسب نسبة التباين بين لون النص ولون الخلفية
  ///
  /// **معايير WCAG 2.1:**
  /// - AA: 4.5:1 للنص العادي، 3:1 للنص الكبير
  /// - AAA: 7:1 للنص العادي، 4.5:1 للنص الكبير
  static double calculateContrastRatio(Color foreground, Color background) {
    final l1 = foreground.computeLuminance();
    final l2 = background.computeLuminance();

    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// التحقق من التباين بين لونين
  ///
  /// **Parameters:**
  /// - [foreground]: لون المقدمة (النص)
  /// - [background]: لون الخلفية
  /// - [minRatio]: الحد الأدنى للتباين (افتراضي 4.5)
  ///
  /// **Returns:** true إذا كان التباين كافياً
  static bool checkContrast(
    Color foreground,
    Color background, {
    double minRatio = 4.5,
  }) {
    final ratio = calculateContrastRatio(foreground, background);
    return ratio >= minRatio;
  }

  /// التحقق من حجم هدف اللمس (Touch Target)
  ///
  /// **Parameters:**
  /// - [size]: حجم العنصر
  /// - [minSize]: الحد الأدنى للحجم (افتراضي 48)
  ///
  /// **Returns:** true إذا كان الحجم كافياً
  static bool checkTouchTarget(Size size, {double minSize = 48}) =>
      size.width >= minSize && size.height >= minSize;

  /// التحقق من حجم الخط
  ///
  /// **Parameters:**
  /// - [fontSize]: حجم الخط
  /// - [minSize]: الحد الأدنى للحجم (افتراضي 16)
  ///
  /// **Returns:** true إذا كان حجم الخط كافياً
  static bool checkFontSize(double fontSize, {double minSize = 16}) =>
      fontSize >= minSize;

  /// التحقق من ارتفاع السطر (Line Height)
  ///
  /// **Parameters:**
  /// - [lineHeight]: ارتفاع السطر
  /// - [minHeight]: الحد الأدنى للارتفاع (افتراضي 1.5)
  ///
  /// **Returns:** true إذا كان ارتفاع السطر كافياً
  static bool checkLineHeight(double lineHeight, {double minHeight = 1.5}) =>
      lineHeight >= minHeight;

  /// التحقق من إمكانية وصول النص بشكل شامل
  ///
  /// يفحص حجم الخط، ارتفاع السطر، والتباين
  ///
  /// **Parameters:**
  /// - [style]: نمط النص
  /// - [backgroundColor]: لون الخلفية
  /// - [isLargeText]: هل النص كبير (معايير أقل صرامة)
  ///
  /// **Returns:** true إذا كان النص يحقق معايير إمكانية الوصول
  static bool checkTextAccessibility(
    TextStyle style,
    Color backgroundColor, {
    bool isLargeText = false,
  }) {
    // Check font size
    final fontSize = style.fontSize ?? 14.0;
    if (!isLargeText && !checkFontSize(fontSize)) {
      return false;
    }

    // Check line height if specified
    if (style.height != null && !checkLineHeight(style.height!)) {
      return false;
    }

    // Check contrast if color is specified
    if (style.color != null) {
      final isLarge = isLargeText ||
          fontSize >= 18.0 ||
          (fontSize >= 14.0 && style.fontWeight == FontWeight.bold);
      final minRatio = isLarge ? 3.0 : 4.5;
      if (!checkContrast(style.color!, backgroundColor, minRatio: minRatio)) {
        return false;
      }
    }

    return true;
  }

  /// طباعة ملخص لفحوصات إمكانية الوصول
  static void printSummary() {
    // Placeholder for summary printing
    // In a real implementation, this would print statistics
  }
}
