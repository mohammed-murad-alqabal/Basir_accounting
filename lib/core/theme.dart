import 'package:flutter/material.dart';

/// نظام التصميم الموحد للتطبيق
/// يحتوي على الألوان والطباعة والأنماط الموحدة

/// ألوان التطبيق
///
/// يحتوي على جميع الألوان المستخدمة في التطبيق
/// لضمان التناسق في التصميم
class AppColors {
  /// اللون الأساسي للتطبيق (أزرق)
  static const Color primary = Color(0xFF007BFF);

  /// اللون الثانوي (أخضر)
  static const Color secondary = Color(0xFF28A745);

  /// لون الخلفية الرئيسية
  static const Color background = Color(0xFFF8F9FA);

  /// لون السطح (للبطاقات والعناصر)
  static const Color surface = Color(0xFFFFFFFF);

  /// لون الخطأ (أحمر)
  static const Color error = Color(0xFFDC3545);

  /// لون النص الأساسي (أسود داكن)
  static const Color textPrimary = Color(0xFF212529);

  /// لون النص الثانوي (رمادي)
  static const Color textSecondary = Color(0xFF6C757D);

  /// لون النص التوضيحي (رمادي فاتح)
  static const Color textHint = Color(0xFFADB5BD);

  /// لون الحدود
  static const Color border = Color(0xFFDEE2E6);

  /// لون الفواصل
  static const Color divider = Color(0xFFE9ECEF);

  /// لون النجاح (أخضر)
  static const Color success = Color(0xFF28A745);

  /// لون التحذير (أصفر)
  static const Color warning = Color(0xFFFFC107);

  /// لون المعلومات (أزرق فاتح)
  static const Color info = Color(0xFF17A2B8);
}

/// أحجام وأنواع الخطوط
///
/// يحتوي على جميع أحجام الخطوط وأنواعها المستخدمة في التطبيق
class AppTypography {
  /// حجم العنوان الكبير جداً (32px)
  static const double headlineLarge = 32;

  /// حجم العنوان الكبير (28px)
  static const double headlineMedium = 28;

  /// حجم العنوان الصغير (24px)
  static const double headlineSmall = 24;

  /// حجم العنوان الرئيسي الكبير (22px)
  static const double titleLarge = 22;

  /// حجم العنوان الرئيسي المتوسط (18px)
  static const double titleMedium = 18;

  /// حجم العنوان الرئيسي الصغير (16px)
  static const double titleSmall = 16;

  /// حجم النص الكبير (16px)
  static const double bodyLarge = 16;

  /// حجم النص المتوسط (14px)
  static const double bodyMedium = 14;

  /// حجم النص الصغير (12px)
  static const double bodySmall = 12;

  /// حجم التسمية الكبيرة (14px)
  static const double labelLarge = 14;

  /// حجم التسمية المتوسطة (12px)
  static const double labelMedium = 12;

  /// حجم التسمية الصغيرة (11px)
  static const double labelSmall = 11;

  /// خط اللغة العربية (Cairo)
  static const String arabicFont = 'Cairo';

  /// خط اللغة الإنجليزية (Roboto)
  static const String englishFont = 'Roboto';
}

/// المسافات القياسية
///
/// يحتوي على جميع المسافات المستخدمة في التطبيق
/// لضمان التناسق في التباعد بين العناصر
class AppSpacing {
  /// مسافة صغيرة جداً (4px)
  static const double xs = 4;

  /// مسافة صغيرة (8px)
  static const double sm = 8;

  /// مسافة متوسطة (16px)
  static const double md = 16;

  /// مسافة كبيرة (24px)
  static const double lg = 24;

  /// مسافة كبيرة جداً (32px)
  static const double xl = 32;

  /// مسافة كبيرة جداً جداً (48px)
  static const double xxl = 48;
}

/// نصف قطر الحواف
///
/// يحتوي على جميع قيم نصف قطر الحواف المستخدمة في التطبيق
/// لضمان التناسق في تدوير الزوايا
class AppBorderRadius {
  /// نصف قطر صغير جداً (4px)
  static const double xs = 4;

  /// نصف قطر صغير (8px)
  static const double sm = 8;

  /// نصف قطر متوسط (12px)
  static const double md = 12;

  /// نصف قطر كبير (16px)
  static const double lg = 16;

  /// نصف قطر كبير جداً (20px)
  static const double xl = 20;

  /// نصف قطر دائري كامل (999px)
  static const double full = 999;
}

/// إنشاء ثيم التطبيق
///
/// ينشئ [ThemeData] كامل للتطبيق مع جميع الأنماط والألوان
/// المحددة في نظام التصميم
///
/// Returns: [ThemeData] جاهز للاستخدام في MaterialApp
///
/// Example:
/// ```dart
/// MaterialApp(
///   theme: createAppTheme(),
///   home: MyHomePage(),
/// )
/// ```
ThemeData createAppTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.surface,
        // background: AppColors.background, // Deprecated - using surface instead
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: AppTypography.titleLarge,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textHint,
          fontSize: AppTypography.bodyMedium,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppTypography.bodyMedium,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          textStyle: const TextStyle(
            fontSize: AppTypography.labelLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          textStyle: const TextStyle(
            fontSize: AppTypography.labelLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppTypography.headlineLarge,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: AppTypography.headlineMedium,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: AppTypography.headlineSmall,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: AppTypography.titleLarge,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: AppTypography.titleMedium,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: AppTypography.titleMedium,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: AppTypography.titleSmall,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: AppTypography.bodyLarge,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppTypography.bodyLarge,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppTypography.bodyMedium,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: AppTypography.bodySmall,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: AppTypography.labelLarge,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: AppTypography.labelMedium,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: AppTypography.labelSmall,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: AppSpacing.md,
      ),
    );
