/// نظام أنماط النصوص الموحد للتطبيق
///
/// يحتوي على جميع أنماط النصوص المستخدمة في التطبيق
library;

import 'package:basir_accounting_system/core/theme/font_manager.dart';
import 'package:flutter/material.dart';

/// أنماط النصوص الموحدة للتطبيق
class AppTextStyles {
  AppTextStyles._();

  // أحجام الخطوط (للتوافق)

  /// حجم النص الكبير جداً (Display Large)
  static const double displayLargeSize = 57;

  /// حجم النص الكبير (Display Medium)
  static const double displayMediumSize = 45;

  /// حجم النص الصغير (Display Small)
  static const double displaySmallSize = 36;

  /// حجم العنوان الكبير (Headline Large)
  static const double headlineLargeSize = 32;

  /// حجم العنوان المتوسط (Headline Medium)
  static const double headlineMediumSize = 28;

  /// حجم العنوان الصغير (Headline Small)
  static const double headlineSmallSize = 24;

  /// حجم العنوان الفرعي الكبير (Title Large)
  static const double titleLargeSize = 22;

  /// حجم العنوان الفرعي المتوسط (Title Medium)
  static const double titleMediumSize = 16;

  /// حجم العنوان الفرعي الصغير (Title Small)
  static const double titleSmallSize = 14;

  /// حجم النص الأساسي الكبير (Body Large)
  static const double bodyLargeSize = 16;

  /// حجم النص الأساسي المتوسط (Body Medium)
  static const double bodyMediumSize = 14;

  /// حجم النص الأساسي الصغير (Body Small)
  static const double bodySmallSize = 12;

  /// حجم التسمية الكبيرة (Label Large)
  static const double labelLargeSize = 14;

  /// حجم التسمية المتوسطة (Label Medium)
  static const double labelMediumSize = 12;

  /// حجم التسمية الصغيرة (Label Small)
  static const double labelSmallSize = 11;

  // أوزان الخطوط

  /// وزن الخط الخفيف (Light - 300)
  static const FontWeight light = FontWeight.w300;

  /// وزن الخط العادي (Regular - 400)
  static const FontWeight regular = FontWeight.w400;

  /// وزن الخط المتوسط (Medium - 500)
  static const FontWeight medium = FontWeight.w500;

  /// وزن الخط شبه الغامق (Semi Bold - 600)
  static const FontWeight semiBold = FontWeight.w600;

  /// وزن الخط الغامق (Bold - 700)
  static const FontWeight bold = FontWeight.w700;

  // ارتفاع الأسطر

  /// ارتفاع السطر الضيق (1.2)
  static const double lineHeightTight = 1.2;

  /// ارتفاع السطر العادي (1.5)
  static const double lineHeightNormal = 1.5;

  /// ارتفاع السطر المريح (1.8)
  static const double lineHeightRelaxed = 1.8;

  // TextStyles الفعلية

  static TextStyle get displayLarge => FontManager.createSafeTextStyle(
        fontSize: displayLargeSize,
        fontWeight: bold,
      );

  static TextStyle get displayMedium => FontManager.createSafeTextStyle(
        fontSize: displayMediumSize,
        fontWeight: bold,
      );

  static TextStyle get displaySmall => FontManager.createSafeTextStyle(
        fontSize: displaySmallSize,
        fontWeight: bold,
      );

  static TextStyle get headlineLarge => FontManager.createSafeTextStyle(
        fontSize: headlineLargeSize,
        fontWeight: bold,
      );

  static TextStyle get headlineMedium => FontManager.createSafeTextStyle(
        fontSize: headlineMediumSize,
        fontWeight: semiBold,
      );

  static TextStyle get headlineSmall => FontManager.createSafeTextStyle(
        fontSize: headlineSmallSize,
        fontWeight: semiBold,
      );

  static TextStyle get titleLarge => FontManager.createSafeTextStyle(
        fontSize: titleLargeSize,
        fontWeight: semiBold,
      );

  static TextStyle get titleMedium => FontManager.createSafeTextStyle(
        fontSize: titleMediumSize,
        fontWeight: medium,
      );

  static TextStyle get titleSmall => FontManager.createSafeTextStyle(
        fontSize: titleSmallSize,
        fontWeight: medium,
      );

  static TextStyle get bodyLarge => FontManager.createSafeTextStyle(
        fontSize: bodyLargeSize,
        fontWeight: regular,
      );

  static TextStyle get bodyMedium => FontManager.createSafeTextStyle(
        fontSize: bodyMediumSize,
        fontWeight: regular,
      );

  static TextStyle get bodySmall => FontManager.createSafeTextStyle(
        fontSize: bodySmallSize,
        fontWeight: regular,
      );

  static TextStyle get labelLarge => FontManager.createSafeTextStyle(
        fontSize: labelLargeSize,
        fontWeight: medium,
      );

  static TextStyle get labelMedium => FontManager.createSafeTextStyle(
        fontSize: labelMediumSize,
        fontWeight: medium,
      );

  static TextStyle get labelSmall => FontManager.createSafeTextStyle(
        fontSize: labelSmallSize,
        fontWeight: medium,
      );
}

/// Alias for AppTextStyles for compatibility
typedef AppTypography = AppTextStyles;
