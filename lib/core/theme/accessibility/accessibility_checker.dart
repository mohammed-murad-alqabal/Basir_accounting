import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// أداة للتحقق من إمكانية الوصول (Accessibility) في التطبيق
///
/// توفر دوال للتحقق من:
/// - تباين الألوان (Color Contrast)
/// - أحجام مساحات النقر (Touch Target Sizes)
/// - أحجام الخطوط (Font Sizes)
///
/// جميع الفحوصات تعمل فقط في وضع التطوير (Debug Mode)
/// وتطبع تحذيرات في Console عند عدم الامتثال للمعايير
class AccessibilityChecker {
  /// يتحقق من تباين الألوان بين لونين
  ///
  /// [foreground] لون المقدمة (النص أو العنصر)
  /// [background] لون الخلفية
  /// [minRatio] الحد الأدنى لنسبة التباين (افتراضي: 4.5:1)
  ///
  /// Returns: true إذا كان التباين مقبول، false إذا كان أقل من الحد الأدنى
  ///
  /// معايير WCAG 2.1 Level AA:
  /// - نصوص عادية: 4.5:1
  /// - نصوص كبيرة (18pt+ أو 14pt bold+): 3:1
  /// - عناصر تفاعلية: 3:1
  ///
  /// Example:
  /// ```dart
  /// final hasContrast = AccessibilityChecker.checkContrast(
  ///   Colors.black,
  ///   Colors.white,
  ///   minRatio: 4.5,
  ///,);
  /// ```
  static bool checkContrast(
    Color foreground,
    Color background, {
    double minRatio = 4.5,
  }) {
    final ratio = calculateContrastRatio(
      foreground,
      background,
    );

    if (ratio < minRatio) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ تحذير إمكانية الوصول: التباين منخفض\n'
          '   التباين الحالي: ${ratio.toStringAsFixed(2)}:1\n'
          '   الحد الأدنى المطلوب: ${minRatio.toStringAsFixed(2)}:1\n'
          '   لون المقدمة: $foreground\n'
          '   لون الخلفية: $background',
        );
      }
      return false;
    }

    return true;
  }

  /// يحسب نسبة التباين بين لونين
  ///
  /// [color1] اللون الأول
  /// [color2] اللون الثاني
  ///
  /// Returns: نسبة التباين (من 1:1 إلى 21:1)
  ///
  /// الحساب يتبع معادلة WCAG 2.1:
  /// (L1 + 0.05) / (L2 + 0.05)
  /// حيث L1 هو السطوع النسبي للون الأفتح
  /// و L2 هو السطوع النسبي للون الأغمق
  ///
  /// Example:
  /// ```dart
  /// final ratio = AccessibilityChecker.calculateContrastRatio(
  ///   Colors.black,
  ///   Colors.white,
  ///,);
  /// debugPrint('نسبة التباين: $ratio:1',); // 21:1
  /// ```
  static double calculateContrastRatio(Color color1, Color color2) {
    final l1 = _relativeLuminance(
      color1,
    );
    final l2 = _relativeLuminance(
      color2,
    );

    final lighter = max(
      l1,
      l2,
    );
    final darker = min(
      l1,
      l2,
    );

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// يحسب السطوع النسبي للون (Relative Luminance)
  ///
  /// [color] اللون المراد حساب سطوعه
  ///
  /// Returns: قيمة السطوع النسبي (من 0 إلى 1)
  ///
  /// الحساب يتبع معادلة WCAG 2.1:
  /// L = 0.2126 * R + 0.7152 * G + 0.0722 * B
  /// حيث R, G, B هي قيم الألوان المُخطّطة (linearized)
  static double _relativeLuminance(Color color) {
    final r = _linearize(
      ((color.r * 255.0).round() & 0xff) / 255,
    );
    final g = _linearize(
      ((color.g * 255.0).round() & 0xff) / 255,
    );
    final b = _linearize(
      ((color.b * 255.0).round() & 0xff) / 255,
    );

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// يُخطّط قيمة لون (Linearize)
  ///
  /// [value] قيمة اللون (من 0 إلى 1)
  ///
  /// Returns: القيمة المُخطّطة
  ///
  /// التخطيط يتبع معادلة sRGB:
  /// - إذا كانت القيمة <= 0.03928: value / 12.92
  /// - وإلا: ((value + 0.055) / 1.055) ^ 2.4
  static double _linearize(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    }
    return pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  /// يتحقق من حجم مساحة النقر (Touch Target Size)
  ///
  /// [size] حجم العنصر القابل للنقر
  /// [minSize] الحد الأدنى للحجم (افتراضي: 48px)
  ///
  /// Returns: true إذا كان الحجم مقبول، false إذا كان أقل من الحد الأدنى
  ///
  /// معايير WCAG 2.1 Level AA:
  /// - الحد الأدنى لمساحة النقر: 48x48px
  ///
  /// Example:
  /// ```dart
  /// final isValid = AccessibilityChecker.checkTouchTarget(
  ///   Size(44, 44),
  ///   minSize: 48.0,
  ///,);
  /// ```
  static bool checkTouchTarget(Size size, {double minSize = 48.0}) {
    if (size.width < minSize || size.height < minSize) {
      if (kDebugMode) {
        final width = size.width.toStringAsFixed(
          1,
        );
        final height = size.height.toStringAsFixed(
          1,
        );
        final currentSize = '$width x $height';
        final minSizeStr = minSize.toStringAsFixed(
          1,
        );
        debugPrint(
          '⚠️ تحذير إمكانية الوصول: مساحة النقر صغيرة\n'
          '   الحجم الحالي: ${currentSize}px\n'
          '   الحد الأدنى المطلوب: ${minSizeStr}px',
        );
      }
      return false;
    }

    return true;
  }

  /// يتحقق من حجم الخط (Font Size)
  ///
  /// [fontSize] حجم الخط بالبكسل
  /// [minSize] الحد الأدنى للحجم (افتراضي: 15px)
  ///
  /// Returns: true إذا كان الحجم مقبول، false إذا كان أقل من الحد الأدنى
  ///
  /// معايير WCAG 2.1 Level AA:
  /// - الحد الأدنى للنصوص العادية: 15px (تقريباً 12pt)
  /// - الحد الأدنى للنصوص الثانوية: 13px (تقريباً 10pt)
  ///
  /// Example:
  /// ```dart
  /// final isValid = AccessibilityChecker.checkFontSize(
  ///   14.0,
  ///   minSize: 15.0,
  ///,);
  /// ```
  static bool checkFontSize(double fontSize, {double minSize = 15.0}) {
    if (fontSize < minSize) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ تحذير إمكانية الوصول: حجم الخط صغير\n'
          '   الحجم الحالي: ${fontSize.toStringAsFixed(1)}px\n'
          '   الحد الأدنى المطلوب: ${minSize.toStringAsFixed(1)}px',
        );
      }
      return false;
    }

    return true;
  }

  /// يتحقق من ارتفاع السطر (Line Height)
  ///
  /// [lineHeight] ارتفاع السطر (نسبة من حجم الخط)
  /// [minHeight] الحد الأدنى للارتفاع (افتراضي: 1.5)
  ///
  /// Returns: true إذا كان الارتفاع مقبول، false إذا كان أقل من الحد الأدنى
  ///
  /// معايير WCAG 2.1 Level AA:
  /// - الحد الأدنى لارتفاع السطر: 1.5
  ///
  /// Example:
  /// ```dart
  /// final isValid = AccessibilityChecker.checkLineHeight(
  ///   1.3,
  ///   minHeight: 1.5,
  ///,);
  /// ```
  static bool checkLineHeight(double lineHeight, {double minHeight = 1.5}) {
    if (lineHeight < minHeight) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ تحذير إمكانية الوصول: ارتفاع السطر منخفض\n'
          '   الارتفاع الحالي: ${lineHeight.toStringAsFixed(2)}\n'
          '   الحد الأدنى المطلوب: ${minHeight.toStringAsFixed(2)}',
        );
      }
      return false;
    }

    return true;
  }

  /// يتحقق من جميع معايير إمكانية الوصول لنص
  ///
  /// [textStyle] نمط النص المراد فحصه
  /// [backgroundColor] لون الخلفية
  /// [isLargeText] هل النص كبير (18pt+ أو 14pt bold+)
  ///
  /// Returns: true إذا كان النص يمتثل لجميع المعايير
  ///
  /// Example:
  /// ```dart
  /// final isAccessible = <credential-fixture>(
  ///   TextStyle(fontSize: 16, color: Colors.black),
  ///   Colors.white,
  ///   isLargeText: false,
  ///,);
  /// ```
  static bool checkTextAccessibility(
    TextStyle textStyle,
    Color backgroundColor, {
    bool isLargeText = false,
  }) {
    var isValid = true;

    // التحقق من حجم الخط
    if (textStyle.fontSize != null) {
      final minFontSize = isLargeText ? 13.0 : 15.0;
      if (!checkFontSize(textStyle.fontSize!, minSize: minFontSize)) {
        isValid = false;
      }
    }

    // التحقق من ارتفاع السطر
    if (textStyle.height != null) {
      if (!checkLineHeight(textStyle.height!)) {
        isValid = false;
      }
    }

    // التحقق من التباين
    if (textStyle.color != null) {
      final minRatio = isLargeText ? 3.0 : 4.5;
      if (!checkContrast(
        textStyle.color!,
        backgroundColor,
        minRatio: minRatio,
      )) {
        isValid = false;
      }
    }

    return isValid;
  }

  /// يطبع ملخص لجميع فحوصات إمكانية الوصول
  ///
  /// يستخدم لعرض معلومات مفصلة عن حالة إمكانية الوصول في التطبيق
  ///
  /// Example:
  /// ```dart
  /// AccessibilityChecker.printSummary();
  /// ```
  static void printSummary() {
    if (kDebugMode) {
      debugPrint(
        '\n'
        '═══════════════════════════════════════════════════════════\n'
        '  ملخص معايير إمكانية الوصول (WCAG 2.1 Level AA)\n'
        '═══════════════════════════════════════════════════════════\n'
        '\n'
        '📊 معايير التباين:\n'
        '   • نصوص عادية: 4.5:1 أو أعلى\n'
        '   • نصوص كبيرة: 3:1 أو أعلى\n'
        '   • عناصر تفاعلية: 3:1 أو أعلى\n'
        '\n'
        '📏 معايير الأحجام:\n'
        '   • حجم الخط الأساسي: 15px أو أكبر\n'
        '   • ارتفاع السطر: 1.5 أو أعلى\n'
        '   • مساحة النقر: 48x48px أو أكبر\n'
        '\n'
        '✅ للتحقق من الامتثال:\n'
        '   • استخدم AccessibilityChecker.checkContrast()\n'
        '   • استخدم AccessibilityChecker.checkTouchTarget()\n'
        '   • استخدم AccessibilityChecker.checkFontSize()\n'
        '\n'
        '═══════════════════════════════════════════════════════════\n',
      );
    }
  }
}
