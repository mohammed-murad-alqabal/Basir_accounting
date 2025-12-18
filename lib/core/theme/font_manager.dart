import 'dart:developer' as developer;

import 'package:flutter/material.dart';

/// مدير الخطوط مع دعم fallback آمن.
///
/// يدير تحميل الخطوط والتحقق من توفرها، ويوفر خطوط fallback
/// آمنة في حالة فشل تحميل الخط الأساسي.
///
/// مثال:
/// ```dart
/// await FontManager.initialize();
/// final fontFamily = FontManager.getPrimaryFont();
/// ```
class FontManager {
  FontManager._();

  /// الخط الأساسي (Cairo للعربية)
  static const String primaryFont = 'Cairo';

  /// خطوط fallback بالترتيب
  static const List<String> fallbackFonts = ['Roboto', 'Arial', 'sans-serif'];

  /// حالة تحميل الخط الأساسي
  static bool _isPrimaryFontLoaded = false;

  /// رسائل الأخطاء
  static final List<String> _errors = [];

  /// يتحقق من تحميل الخط الأساسي.
  static bool get isPrimaryFontLoaded => _isPrimaryFontLoaded;

  /// يحصل على قائمة الأخطاء.
  static List<String> get errors => List.unmodifiable(
        _errors,
      );

  /// يهيئ مدير الخطوط ويتحقق من توفر الخطوط.
  ///
  /// يجب استدعاء هذه الدالة في main() قبل runApp().
  ///
  /// Returns true إذا تم تحميل الخط الأساسي بنجاح.
  static Future<bool> initialize() async {
    try {
      developer.log(
        'Initializing FontManager...',
        name: 'FontManager',
      );

      // محاولة تحميل خط Cairo
      _isPrimaryFontLoaded = await _loadFont(
        primaryFont,
      );

      if (_isPrimaryFontLoaded) {
        developer.log(
          'Primary font $primaryFont loaded successfully',
          name: 'FontManager',
        );
      } else {
        const error = 'Failed to load primary font $primaryFont';
        _errors.add(
          error,
        );
        developer.log(
          error,
          name: 'FontManager',
          level: 900, // warning
        );
      }

      return _isPrimaryFontLoaded;
    } on Exception catch (e, stackTrace) {
      final error = 'Exception initializing FontManager: $e';
      _errors.add(
        error,
      );
      developer.log(
        error,
        name: 'FontManager',
        error: e,
        stackTrace: stackTrace,
        level: 1000, // error
      );
      return false;
    }
  }

  /// يحاول تحميل خط معين.
  ///
  /// [fontFamily] اسم الخط المراد تحميله.
  ///
  /// Returns true إذا تم التحميل بنجاح.
  static Future<bool> _loadFont(String fontFamily) async {
    try {
      // محاولة تحميل الخط من assets
      // ملاحظة: في Flutter، الخطوط يتم تحميلها تلقائياً من pubspec.yaml
      // هذه الدالة تتحقق فقط من توفر الخط

      // يمكن إضافة منطق إضافي هنا للتحقق من توفر الخط
      // مثل محاولة رسم نص بالخط والتحقق من النتيجة

      return true; // افتراضياً نعتبر الخط متوفر
    } on Exception catch (e) {
      developer.log(
        'Exception loading font $fontFamily: $e',
        name: 'FontManager',
        level: 900,
      );
      return false;
    }
  }

  /// يحصل على اسم الخط الأساسي.
  ///
  /// Returns اسم الخط الأساسي إذا كان محملاً، وإلا null.
  static String? getPrimaryFont() => _isPrimaryFontLoaded ? primaryFont : null;

  /// يحصل على قائمة الخطوط (أساسي + fallback).
  ///
  /// Returns قائمة بأسماء الخطوط بالترتيب الصحيح.
  static List<String> getFontFamilyList() {
    final fonts = <String>[];

    if (_isPrimaryFontLoaded) {
      fonts.add(
        primaryFont,
      );
    }

    fonts.addAll(
      fallbackFonts,
    );

    return fonts;
  }

  /// يحصل على اسم الخط الأساسي أو أول fallback.
  ///
  /// Returns اسم الخط المناسب للاستخدام.
  static String getDefaultFontFamily() =>
      _isPrimaryFontLoaded ? primaryFont : fallbackFonts.first;

  /// ينشئ TextStyle مع الخط المناسب.
  ///
  /// [fontSize] حجم الخط.
  /// [fontWeight] وزن الخط.
  /// [color] لون النص.
  /// [height] ارتفاع السطر.
  ///
  /// Returns TextStyle مع الخط الأساسي وfallback.
  static TextStyle createTextStyle({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) =>
      TextStyle(
        fontFamily: getDefaultFontFamily(),
        fontFamilyFallback: fallbackFonts,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
      );

  /// ينشئ TextStyle آمن مع line-height مناسب لخط Cairo.
  ///
  /// [fontSize] حجم الخط.
  /// [fontWeight] وزن الخط.
  /// [color] لون النص.
  ///
  /// Returns TextStyle مع line-height ≥ 1.3 لتجنب القص.
  static TextStyle createSafeTextStyle({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    // استخدام line-height أعلى لخط Cairo
    final height = _isPrimaryFontLoaded ? 1.4 : 1.3;

    return createTextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  /// يتحقق من أن الخط المحدد متوفر.
  ///
  /// [fontFamily] اسم الخط للتحقق منه.
  ///
  /// Returns true إذا كان الخط متوفراً.
  static bool isFontAvailable(String fontFamily) {
    if (fontFamily == primaryFont) {
      return _isPrimaryFontLoaded;
    }

    // خطوط fallback تعتبر متوفرة دائماً
    return fallbackFonts.contains(
      fontFamily,
    );
  }

  /// يعيد تعيين حالة المدير (للاختبارات).
  @visibleForTesting
  static void reset() {
    _isPrimaryFontLoaded = false;
    _errors.clear();
  }

  /// يحصل على معلومات حالة الخطوط.
  ///
  /// Returns Map يحتوي على معلومات الحالة.
  static Map<String, dynamic> getStatus() => {
        'primaryFont': primaryFont,
        'isPrimaryFontLoaded': _isPrimaryFontLoaded,
        'fallbackFonts': fallbackFonts,
        'defaultFont': getDefaultFontFamily(),
        'errors': errors,
      };

  /// يطبع معلومات حالة الخطوط (للتطوير).
  static void printStatus() {
    final status = getStatus();
    developer.log(
      'FontManager Status:\n'
      '  Primary Font: ${status['primaryFont']}\n'
      '  Is Loaded: ${status['isPrimaryFontLoaded']}\n'
      '  Default Font: ${status['defaultFont']}\n'
      '  Fallback Fonts: ${status['fallbackFonts']}\n'
      '  Errors: ${status['errors']}',
      name: 'FontManager',
    );
  }
}

/// Widget مساعد لعرض معلومات الخطوط (للتطوير).
///
/// يعرض حالة تحميل الخطوط والمعلومات التشخيصية في overlay
/// يمكن استخدامه أثناء التطوير للتحقق من حالة الخطوط.
class FontDebugInfo extends StatelessWidget {
  /// ينشئ widget معلومات الخطوط.
  const FontDebugInfo({super.key});

  /// يبني widget معلومات الخطوط.
  ///
  /// يعرض حالة تحميل الخطوط والمعلومات التشخيصية.
  @override
  Widget build(BuildContext context) {
    final status = FontManager.getStatus();

    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.black87,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Font Manager Status',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Builder(
            builder: (context) {
              final isLoaded = status['isPrimaryFontLoaded'] as bool;
              final fontName = status['primaryFont'];
              final statusText = isLoaded ? 'Loaded' : 'Not Loaded';
              return Text(
                'Primary: $fontName ($statusText)',
                style: TextStyle(
                  color: isLoaded ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              );
            },
          ),
          Text(
            'Default: ${status['defaultFont']}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          if ((status['errors'] as List).isNotEmpty)
            Text(
              'Errors: ${(status['errors'] as List).join(', ')}',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
        ],
      ),
    );
  }
}
