/// نظام أنماط النصوص الموحد للتطبيق
///
/// يحتوي على جميع أنماط النصوص المستخدمة في التطبيق
library;

import 'package:flutter/material.dart';

/// أنماط النصوص الموحدة للتطبيق
class AppTextStyles {
  AppTextStyles._();

  // أحجام الخطوط

  /// حجم النص الكبير جداً (Display Large)
  static const double displayLarge = 57;

  /// حجم النص الكبير (Display Medium)
  static const double displayMedium = 45;

  /// حجم النص الصغير (Display Small)
  static const double displaySmall = 36;

  /// حجم العنوان الكبير (Headline Large)
  static const double headlineLarge = 32;

  /// حجم العنوان المتوسط (Headline Medium)
  static const double headlineMedium = 28;

  /// حجم العنوان الصغير (Headline Small)
  static const double headlineSmall = 24;

  /// حجم العنوان الفرعي الكبير (Title Large)
  static const double titleLarge = 22;

  /// حجم العنوان الفرعي المتوسط (Title Medium)
  static const double titleMedium = 16;

  /// حجم العنوان الفرعي الصغير (Title Small)
  static const double titleSmall = 14;

  /// حجم النص الأساسي الكبير (Body Large)
  static const double bodyLarge = 16;

  /// حجم النص الأساسي المتوسط (Body Medium)
  static const double bodyMedium = 14;

  /// حجم النص الأساسي الصغير (Body Small)
  static const double bodySmall = 12;

  /// حجم التسمية الكبيرة (Label Large)
  static const double labelLarge = 14;

  /// حجم التسمية المتوسطة (Label Medium)
  static const double labelMedium = 12;

  /// حجم التسمية الصغيرة (Label Small)
  static const double labelSmall = 11;

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
}
