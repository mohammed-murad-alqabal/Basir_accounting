import 'package:flutter/material.dart';

/// Widget مخصص للنصوص يتعامل مع overflow تلقائياً
///
/// يوفر هذا الـ widget حلاً شاملاً لمشاكل overflow في النصوص
/// مع دعم كامل للغة العربية و RTL
///
/// الميزات:
/// - معالجة تلقائية لـ overflow
/// - دعم جميع أنواع النصوص (عناوين، نصوص، تسميات)
/// - تكيف تلقائي مع حجم الشاشة
/// - دعم RTL كامل
/// - إمكانية تخصيص كاملة
///
/// مثال:
/// ```dart
/// ResponsiveText(
///   'نص طويل جداً قد يسبب overflow',
///   style: Theme.of(context).textTheme.titleLarge,
///   maxLines: 2,
/// )
/// ```
class ResponsiveText extends StatelessWidget {
  /// ينشئ widget نص متجاوب
  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
    this.textDirection,
    this.minFontSize,
    this.maxFontSize,
    this.autoScale = false,
    this.softWrap = true,
    this.color,
    this.fontWeight,
    this.height,
    this.letterSpacing,
  });

  /// النص المراد عرضه
  final String text;

  /// نمط النص
  final TextStyle? style;

  /// الحد الأقصى لعدد الأسطر
  final int? maxLines;

  /// كيفية التعامل مع overflow
  final TextOverflow overflow;

  /// محاذاة النص
  final TextAlign? textAlign;

  /// اتجاه النص
  final TextDirection? textDirection;

  // تم إزالة textScaleFactor - استخدم textScaler في Flutter 3.16+
  // final double? textScaleFactor;

  /// الحد الأدنى لحجم الخط عند التصغير
  final double? minFontSize;

  /// الحد الأقصى لحجم الخط عند التكبير
  final double? maxFontSize;

  /// هل يتم تصغير النص تلقائياً ليتناسب مع المساحة
  final bool autoScale;

  /// هل يتم استخدام soft wrap
  final bool softWrap;

  /// لون النص
  final Color? color;

  /// وزن الخط
  final FontWeight? fontWeight;

  /// ارتفاع السطر
  final double? height;

  /// المسافة بين الحروف
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    // الحصول على النمط الأساسي
    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium;

    // تطبيق التخصيصات مع ضمان line-height كافي
    final finalStyle = baseStyle?.copyWith(
      color: color,
      fontWeight: fontWeight,
      height: height ?? 1.5, // ضمان line-height كافي (1.5 افتراضي)
      letterSpacing: letterSpacing,
    );

    // إذا كان autoScale مفعل، استخدم FittedBox
    if (autoScale) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: _getAlignment(),
        child: Text(
          text,
          style: finalStyle,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign ?? TextAlign.center, // محاذاة مركزية افتراضية
          textDirection: textDirection ?? TextDirection.rtl, // RTL افتراضي
          softWrap: softWrap,
        ),
      );
    }

    // استخدام Text عادي مع معالجة overflow
    return Text(
      text,
      style: finalStyle,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign ?? TextAlign.center, // محاذاة مركزية افتراضية
      textDirection: textDirection ?? TextDirection.rtl, // RTL افتراضي
      softWrap: softWrap,
    );
  }

  /// يحدد المحاذاة بناءً على textAlign
  Alignment _getAlignment() {
    if (textAlign == null) return Alignment.center;

    switch (textAlign!) {
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.start:
        return Alignment.centerLeft;
      case TextAlign.end:
        return Alignment.centerRight;
      case TextAlign.justify:
        return Alignment.center;
    }
  }
}

/// Widget للعناوين الكبيرة مع معالجة overflow تلقائية
///
/// يستخدم headlineLarge من Theme ويطبق auto-scaling تلقائياً
class ResponsiveHeadline extends StatelessWidget {
  /// ينشئ widget عنوان كبير متجاوب
  const ResponsiveHeadline(
    this.text, {
    super.key,
    this.maxLines = 2,
    this.textAlign,
    this.color,
  });

  /// النص المراد عرضه
  final String text;

  /// الحد الأقصى لعدد الأسطر
  final int? maxLines;

  /// محاذاة النص
  final TextAlign? textAlign;

  /// لون النص
  final Color? color;

  @override
  Widget build(BuildContext context) => ResponsiveText(
    text,
    style: Theme.of(context).textTheme.headlineLarge,
    maxLines: maxLines,
    textAlign: textAlign,
    color: color,
    autoScale: true,
  );
}

/// Widget للعناوين الفرعية مع معالجة overflow تلقائية
///
/// يستخدم titleLarge من Theme
class ResponsiveTitle extends StatelessWidget {
  /// ينشئ widget عنوان فرعي متجاوب
  const ResponsiveTitle(
    this.text, {
    super.key,
    this.maxLines = 2,
    this.textAlign,
    this.color,
  });

  /// النص المراد عرضه
  final String text;

  /// الحد الأقصى لعدد الأسطر
  final int? maxLines;

  /// محاذاة النص
  final TextAlign? textAlign;

  /// لون النص
  final Color? color;

  @override
  Widget build(BuildContext context) => ResponsiveText(
    text,
    style: Theme.of(context).textTheme.titleLarge,
    maxLines: maxLines,
    textAlign: textAlign,
    color: color,
  );
}

/// Widget للنصوص الأساسية مع معالجة overflow تلقائية
///
/// يستخدم bodyMedium من Theme
class ResponsiveBody extends StatelessWidget {
  /// ينشئ widget نص أساسي متجاوب
  const ResponsiveBody(
    this.text, {
    super.key,
    this.maxLines,
    this.textAlign,
    this.color,
  });

  /// النص المراد عرضه
  final String text;

  /// الحد الأقصى لعدد الأسطر
  final int? maxLines;

  /// محاذاة النص
  final TextAlign? textAlign;

  /// لون النص
  final Color? color;

  @override
  Widget build(BuildContext context) => ResponsiveText(
    text,
    style: Theme.of(context).textTheme.bodyMedium,
    maxLines: maxLines,
    textAlign: textAlign,
    color: color,
  );
}

/// Widget للتسميات مع معالجة overflow تلقائية
///
/// يستخدم labelLarge من Theme
class ResponsiveLabel extends StatelessWidget {
  /// ينشئ widget تسمية متجاوبة
  const ResponsiveLabel(
    this.text, {
    super.key,
    this.maxLines = 1,
    this.textAlign,
    this.color,
  });

  /// النص المراد عرضه
  final String text;

  /// الحد الأقصى لعدد الأسطر
  final int? maxLines;

  /// محاذاة النص
  final TextAlign? textAlign;

  /// لون النص
  final Color? color;

  @override
  Widget build(BuildContext context) => ResponsiveText(
    text,
    style: Theme.of(context).textTheme.labelLarge,
    maxLines: maxLines,
    textAlign: textAlign,
    color: color,
  );
}

/// Widget للنصوص الصغيرة (Caption) مع معالجة overflow تلقائية
///
/// يستخدم bodySmall من Theme
class ResponsiveCaption extends StatelessWidget {
  /// ينشئ widget نص صغير متجاوب
  const ResponsiveCaption(
    this.text, {
    super.key,
    this.maxLines = 2,
    this.textAlign,
    this.color,
  });

  /// النص المراد عرضه
  final String text;

  /// الحد الأقصى لعدد الأسطر
  final int? maxLines;

  /// محاذاة النص
  final TextAlign? textAlign;

  /// لون النص
  final Color? color;

  @override
  Widget build(BuildContext context) => ResponsiveText(
    text,
    style: Theme.of(context).textTheme.bodySmall,
    maxLines: maxLines,
    textAlign: textAlign,
    color: color,
  );
}
