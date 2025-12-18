import 'package:flutter/material.dart';

/// نظام مقاييس الخطوط لضمان عرض النصوص بشكل صحيح بدون قص.
///
/// يوفر هذا النظام حسابات دقيقة لارتفاع الخطوط والـ padding المطلوب
/// لضمان عدم قص النصوص في جميع الحالات، خاصة مع خط Cairo العربي.
///
/// مثال:
/// ```dart
/// final metrics = AppFontMetrics.forFont('Cairo', 16.0,);
/// final requiredHeight = metrics.calculateRequiredHeight(
///   textScaleFactor: 1.5,
///,);
/// ```
@immutable
class AppFontMetrics {
  /// ينشئ مقاييس خط جديدة.
  const AppFontMetrics({
    required this.fontFamily,
    required this.fontSize,
    required this.lineHeight,
    required this.ascent,
    required this.descent,
  });

  /// مقاييس خط Cairo الافتراضية.
  ///
  /// خط Cairo يحتاج line-height أكبر (1.4) لتجنب القص العمودي.
  factory AppFontMetrics.cairo(double fontSize) => AppFontMetrics(
        fontFamily: 'Cairo',
        fontSize: fontSize,
        lineHeight: 1.4, // أعلى من الافتراضي لخط Cairo
        ascent: 0.85,
        descent: 0.25,
      );

  /// مقاييس خط Roboto الافتراضية.
  factory AppFontMetrics.roboto(double fontSize) => AppFontMetrics(
        fontFamily: 'Roboto',
        fontSize: fontSize,
        lineHeight: 1.3,
        ascent: 0.75,
        descent: 0.25,
      );

  /// مقاييس خط النظام الافتراضية.
  factory AppFontMetrics.system(double fontSize) => AppFontMetrics(
        fontFamily: 'System',
        fontSize: fontSize,
        lineHeight: 1.3,
        ascent: 0.75,
        descent: 0.25,
      );

  /// اسم الخط
  final String fontFamily;

  /// حجم الخط الأساسي
  final double fontSize;

  /// ارتفاع السطر (line-height) كنسبة من حجم الخط
  final double lineHeight;

  /// المسافة الإضافية فوق النص (ascent)
  final double ascent;

  /// المسافة الإضافية تحت النص (descent)
  final double descent;

  /// يحسب الارتفاع الفعلي المطلوب للنص.
  ///
  /// [textScaleFactor] عامل تكبير النص من إعدادات النظام (1.0-2.0).
  ///
  /// Returns الارتفاع بالبكسل المطلوب لعرض النص بدون قص.
  double calculateRequiredHeight({double textScaleFactor = 1.0}) {
    final scaledFontSize = fontSize * textScaleFactor;
    return scaledFontSize * lineHeight;
  }

  /// يحسب الـ padding الرأسي المطلوب.
  ///
  /// [textScaleFactor] عامل تكبير النص من إعدادات النظام.
  /// [minPadding] الحد الأدنى للـ padding (افتراضي 12px).
  ///
  /// Returns EdgeInsets للـ padding الرأسي المطلوب.
  EdgeInsets calculateVerticalPadding({
    double textScaleFactor = 1.0,
    double minPadding = 12.0,
  }) {
    final scaledFontSize = fontSize * textScaleFactor;
    final textHeight = scaledFontSize * lineHeight;

    // حساب padding إضافي بناءً على حجم النص
    final extraPadding = (textHeight - scaledFontSize) / 2;
    final totalPadding = minPadding + extraPadding;

    return EdgeInsets.symmetric(
      vertical: totalPadding,
    );
  }

  /// يحسب الـ padding الكامل (أفقي ورأسي).
  ///
  /// [textScaleFactor] عامل تكبير النص.
  /// [minVerticalPadding] الحد الأدنى للـ padding الرأسي.
  /// [horizontalPadding] الـ padding الأفقي.
  ///
  /// Returns EdgeInsets للـ padding الكامل.
  EdgeInsets calculatePadding({
    double textScaleFactor = 1.0,
    double minVerticalPadding = 12.0,
    double horizontalPadding = 16.0,
  }) {
    final verticalPadding = calculateVerticalPadding(
      textScaleFactor: textScaleFactor,
      minPadding: minVerticalPadding,
    );

    return EdgeInsets.symmetric(
      vertical: verticalPadding.top,
      horizontal: horizontalPadding,
    );
  }

  /// يحسب الارتفاع الأدنى للزر.
  ///
  /// [textScaleFactor] عامل تكبير النص.
  /// [minHeight] الحد الأدنى للارتفاع (افتراضي 48px).
  ///
  /// Returns الارتفاع الأدنى المطلوب بالبكسل.
  double calculateMinButtonHeight({
    double textScaleFactor = 1.0,
    double minHeight = 48.0,
  }) {
    final requiredHeight = calculateRequiredHeight(
      textScaleFactor: textScaleFactor,
    );
    final padding = calculateVerticalPadding(
      textScaleFactor: textScaleFactor,
    );

    final totalHeight = requiredHeight + padding.top + padding.bottom;

    // التأكد من عدم النزول تحت الحد الأدنى
    return totalHeight > minHeight ? totalHeight : minHeight;
  }

  /// يتحقق من أن الارتفاع المعطى كافٍ للنص.
  ///
  /// [height] الارتفاع المتاح.
  /// [textScaleFactor] عامل تكبير النص.
  ///
  /// Returns true إذا كان الارتفاع كافياً، false إذا كان هناك خطر قص.
  bool isHeightSufficient({
    required double height,
    double textScaleFactor = 1.0,
  }) {
    final minRequired = calculateMinButtonHeight(
      textScaleFactor: textScaleFactor,
    );
    return height >= minRequired;
  }

  /// ينشئ TextStyle مع المقاييس الصحيحة.
  ///
  /// [color] لون النص.
  /// [fontWeight] وزن الخط.
  ///
  /// Returns TextStyle مع line-height صحيح.
  TextStyle toTextStyle({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        height: lineHeight,
        color: color,
        fontWeight: fontWeight,
        fontFamilyFallback: const ['Roboto', 'Arial'],
      );

  @override
  String toString() => 'AppFontMetrics('
      'fontFamily: $fontFamily, '
      'fontSize: $fontSize, '
      'lineHeight: $lineHeight, '
      'ascent: $ascent, '
      'descent: $descent'
      ')';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppFontMetrics &&
        other.fontFamily == fontFamily &&
        other.fontSize == fontSize &&
        other.lineHeight == lineHeight &&
        other.ascent == ascent &&
        other.descent == descent;
  }

  @override
  int get hashCode => Object.hash(
        fontFamily,
        fontSize,
        lineHeight,
        ascent,
        descent,
      );
}

/// مساعدات لمقاييس الخطوط الشائعة.
class FontMetricsHelper {
  FontMetricsHelper._();

  /// مقاييس خط Cairo لأحجام مختلفة.
  static final Map<double, AppFontMetrics> cairoMetrics = {
    12.0: AppFontMetrics.cairo(12),
    13.0: AppFontMetrics.cairo(13),
    14.0: AppFontMetrics.cairo(14),
    15.0: AppFontMetrics.cairo(15),
    16.0: AppFontMetrics.cairo(16),
    18.0: AppFontMetrics.cairo(18),
    20.0: AppFontMetrics.cairo(20),
    22.0: AppFontMetrics.cairo(22),
    24.0: AppFontMetrics.cairo(24),
  };

  /// يحصل على مقاييس خط Cairo لحجم معين.
  ///
  /// إذا لم يكن الحجم موجوداً في الـ cache، يتم إنشاؤه.
  static AppFontMetrics getCairoMetrics(double fontSize) =>
      cairoMetrics[fontSize] ??
      AppFontMetrics.cairo(
        fontSize,
      );

  /// يحسب الارتفاع المطلوب لنص بخط Cairo.
  static double calculateCairoHeight({
    required double fontSize,
    double textScaleFactor = 1.0,
  }) {
    final metrics = getCairoMetrics(
      fontSize,
    );
    return metrics.calculateRequiredHeight(
      textScaleFactor: textScaleFactor,
    );
  }

  /// يحسب padding لنص بخط Cairo.
  static EdgeInsets calculateCairoPadding({
    required double fontSize,
    double textScaleFactor = 1.0,
    double minVerticalPadding = 12.0,
    double horizontalPadding = 16.0,
  }) {
    final metrics = getCairoMetrics(
      fontSize,
    );
    return metrics.calculatePadding(
      textScaleFactor: textScaleFactor,
      minVerticalPadding: minVerticalPadding,
      horizontalPadding: horizontalPadding,
    );
  }
}
