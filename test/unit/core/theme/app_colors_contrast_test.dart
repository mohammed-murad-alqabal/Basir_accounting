import 'package:basser_app/core/theme/accessibility/accessibility_checker.dart';
import 'package:basser_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// **Feature: ui-ux-improvements, Property 1: تباين النصوص العادية**
/// **Validates: Requirements 1.1, 2.5, 7.3, 7.5, 8.2, 9.4**
///
/// هذا الاختبار يتحقق من أن جميع النصوص العادية في التطبيق
/// تحقق نسبة تباين لا تقل عن 4.5:1 مع الخلفية وفقاً لمعايير
/// WCAG 2.1 Level AA
void main() {
  group('Property 1: تباين النصوص العادية', () {
    // الحد الأدنى لنسبة التباين للنصوص العادية
    const minContrastRatio = 4.5;

    /// يختبر أن جميع ألوان النصوص الأساسية تحقق التباين المطلوب
    /// مع الخلفية البيضاء (surface)
    test('لأي نص عادي معروض على خلفية بيضاء، '
        'يجب أن تكون نسبة التباين لا تقل عن 4.5:1', () {
      // ألوان النصوص الأساسية التي يجب اختبارها
      final textColors = [
        ('textPrimary', AppColors.textPrimary),
        ('textSecondary', AppColors.textSecondary),
        ('textHint', AppColors.textHint),
        ('onSurface', AppColors.onSurface),
      ];

      // الخلفية البيضاء (surface)
      const backgroundColor = AppColors.surface;

      // اختبار كل لون نص
      for (final (name, textColor) in textColors) {
        final ratio = AccessibilityChecker.calculateContrastRatio(
          textColor,
          backgroundColor,
        );

        expect(
          ratio,
          greaterThanOrEqualTo(minContrastRatio),
          reason:
              'لون النص $name (${_colorToHex(textColor)}) '
              'على خلفية بيضاء يجب أن يحقق تباين 4.5:1 أو أعلى. '
              'التباين الحالي: ${ratio.toStringAsFixed(2)}:1',
        );
      }
    });

    /// يختبر أن جميع ألوان النصوص تحقق التباين المطلوب
    /// مع الخلفية الرئيسية (background)
    test('لأي نص عادي معروض على الخلفية الرئيسية، '
        'يجب أن تكون نسبة التباين لا تقل عن 4.5:1', () {
      final textColors = [
        ('textPrimary', AppColors.textPrimary),
        ('textSecondary', AppColors.textSecondary),
        ('textHint', AppColors.textHint),
      ];

      const backgroundColor = AppColors.background;

      for (final (name, textColor) in textColors) {
        final ratio = AccessibilityChecker.calculateContrastRatio(
          textColor,
          backgroundColor,
        );

        expect(
          ratio,
          greaterThanOrEqualTo(minContrastRatio),
          reason:
              'لون النص $name (${_colorToHex(textColor)}) '
              'على الخلفية الرئيسية (${_colorToHex(backgroundColor)}) '
              'يجب أن يحقق تباين 4.5:1 أو أعلى. '
              'التباين الحالي: ${ratio.toStringAsFixed(2)}:1',
        );
      }
    });

    /// يختبر أن ألوان الحالة (error, success, warning, info)
    /// تحقق التباين المطلوب مع الخلفية البيضاء
    test('لأي نص حالة (خطأ، نجاح، تحذير، معلومة) معروض على خلفية بيضاء، '
        'يجب أن تكون نسبة التباين لا تقل عن 4.5:1', () {
      final stateColors = [
        ('error', AppColors.error),
        ('success', AppColors.success),
        ('warning', AppColors.warning),
        ('info', AppColors.info),
      ];

      const backgroundColor = AppColors.surface;

      for (final (name, stateColor) in stateColors) {
        final ratio = AccessibilityChecker.calculateContrastRatio(
          stateColor,
          backgroundColor,
        );

        expect(
          ratio,
          greaterThanOrEqualTo(minContrastRatio),
          reason:
              'لون الحالة $name (${_colorToHex(stateColor)}) '
              'على خلفية بيضاء يجب أن يحقق تباين 4.5:1 أو أعلى. '
              'التباين الحالي: ${ratio.toStringAsFixed(2)}:1',
        );
      }
    });

    /// يختبر أن الألوان الأساسية (primary, secondary)
    /// تحقق التباين المطلوب مع الخلفية البيضاء
    test('لأي نص بلون أساسي أو ثانوي معروض على خلفية بيضاء، '
        'يجب أن تكون نسبة التباين لا تقل عن 4.5:1', () {
      final brandColors = [
        ('primary', AppColors.primary),
        ('primaryDark', AppColors.primaryDark),
        ('secondary', AppColors.secondary),
        ('secondaryDark', AppColors.secondaryDark),
      ];

      const backgroundColor = AppColors.surface;

      for (final (name, brandColor) in brandColors) {
        final ratio = AccessibilityChecker.calculateContrastRatio(
          brandColor,
          backgroundColor,
        );

        expect(
          ratio,
          greaterThanOrEqualTo(minContrastRatio),
          reason:
              'اللون $name (${_colorToHex(brandColor)}) '
              'على خلفية بيضاء يجب أن يحقق تباين 4.5:1 أو أعلى. '
              'التباين الحالي: ${ratio.toStringAsFixed(2)}:1',
        );
      }
    });

    /// يختبر أن النصوص على الخلفيات الملونة تحقق التباين المطلوب
    test('لأي نص أبيض معروض على خلفية ملونة، '
        'يجب أن تكون نسبة التباين لا تقل عن 4.5:1', () {
      final coloredBackgrounds = [
        ('primary', AppColors.primary, AppColors.onPrimary),
        ('secondary', AppColors.secondary, AppColors.onSecondary),
        ('error', AppColors.error, AppColors.onError),
      ];

      for (final (name, backgroundColor, textColor) in coloredBackgrounds) {
        final ratio = AccessibilityChecker.calculateContrastRatio(
          textColor,
          backgroundColor,
        );

        expect(
          ratio,
          greaterThanOrEqualTo(minContrastRatio),
          reason:
              'النص على خلفية $name '
              '(${_colorToHex(textColor)} على '
              '${_colorToHex(backgroundColor)}) '
              'يجب أن يحقق تباين 4.5:1 أو أعلى. '
              'التباين الحالي: ${ratio.toStringAsFixed(2)}:1',
        );
      }
    });

    /// يختبر أن دالة hasMinimumContrast تعمل بشكل صحيح
    test('دالة AppColors.hasMinimumContrast يجب أن تعيد true '
        'لجميع ألوان النصوص الأساسية', () {
      final textColors = [
        AppColors.textPrimary,
        AppColors.textSecondary,
        AppColors.textHint,
      ];

      for (final textColor in textColors) {
        final hasContrast = AppColors.hasMinimumContrast(textColor);

        expect(
          hasContrast,
          isTrue,
          reason:
              'لون النص ${_colorToHex(textColor)} '
              'يجب أن يحقق التباين المطلوب',
        );
      }
    });

    /// يختبر أن دالة contrastRatio تحسب النسبة بشكل صحيح
    test('دالة AppColors.contrastRatio يجب أن تحسب نسبة التباين بدقة', () {
      // اختبار مع الأسود والأبيض (يجب أن يكون 21:1)
      final blackWhiteRatio = AppColors.contrastRatio(
        Colors.black,
        Colors.white,
      );

      expect(
        blackWhiteRatio,
        closeTo(21.0, 0.1),
        reason: 'نسبة التباين بين الأسود والأبيض يجب أن تكون 21:1',
      );

      // اختبار مع نفس اللون (يجب أن يكون 1:1)
      final sameColorRatio = AppColors.contrastRatio(Colors.blue, Colors.blue);

      expect(
        sameColorRatio,
        closeTo(1.0, 0.01),
        reason: 'نسبة التباين بين نفس اللون يجب أن تكون 1:1',
      );
    });

    /// يختبار أن جميع ألوان النصوص تحقق التباين المطلوب
    /// باستخدام دالة checkContrast
    test('دالة AccessibilityChecker.checkContrast يجب أن تعيد true '
        'لجميع ألوان النصوص الأساسية', () {
      final textColors = [
        AppColors.textPrimary,
        AppColors.textSecondary,
        AppColors.textHint,
      ];

      const backgroundColor = AppColors.surface;

      for (final textColor in textColors) {
        final hasContrast = AccessibilityChecker.checkContrast(
          textColor,
          backgroundColor,
        );

        expect(
          hasContrast,
          isTrue,
          reason:
              'لون النص ${_colorToHex(textColor)} '
              'يجب أن يحقق التباين المطلوب مع الخلفية',
        );
      }
    });
  });
}

/// دالة مساعدة لتحويل Color إلى Hex string
String _colorToHex(Color color) {
  final value =
      (color.a.toInt() << 24) |
      (color.r.toInt() << 16) |
      (color.g.toInt() << 8) |
      color.b.toInt();
  final hex = value.toRadixString(16).padLeft(8, '0').substring(2);
  return '#${hex.toUpperCase()}';
}
