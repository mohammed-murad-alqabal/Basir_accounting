/// نظام الثيمات الموحد (Theme Engine)
///
/// هذا الملف يجمع جميع Design Tokens في ThemeData موحد
/// متوافق مع Material Design 3
///
/// الهيكل:
/// - AppTheme: الفئة الرئيسية للثيمات
/// - lightTheme: الثيم الفاتح
/// - darkTheme: الثيم الداكن (جاهز للتوسع المستقبلي)
library;

import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// نظام الثيمات الموحد
///
/// يوفر ثيمات جاهزة للاستخدام المباشر في MaterialApp
///
/// Example:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.lightTheme,
///   darkTheme: AppTheme.darkTheme,
///   ...
/// )
/// ```
abstract final class AppTheme {
  // ═══════════════════════════════════════════════════════════════════════════
  // Dynamic Theme Factory (The Engine Core)
  // ═══════════════════════════════════════════════════════════════════════════

  /// إنشاء ثيم مخصص بناءً على الوضع واللون الأساسي والخط
  static ThemeData getTheme({
    required ThemeMode mode,
    Color? seedColor,
    String? fontFamily,
    double textScaleFactor = 1.0,
    bool highContrast = false,
  }) {
    final isDark = mode == ThemeMode.dark;

    // 1. تحديد ColorScheme
    ColorScheme colorScheme;
    if (seedColor != null) {
      colorScheme = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        // يمكننا تخصيص الألوان الأخرى للحفاظ على هوية العلامة التجارية
        error: SemanticColors.error,
        contrastLevel: highContrast ? 1.0 : 0.0,
      );
    } else {
      if (highContrast) {
        colorScheme = isDark
            ? _highContrastDarkColorScheme
            : _highContrastLightColorScheme;
      } else {
        colorScheme = isDark ? _darkColorScheme : _lightColorScheme;
      }
    }

    // 2. تحديد TextTheme وتطبيق الخط والحجم
    final scaledGenericTextTheme = _textTheme.apply(
      fontFamily: fontFamily ?? FontFamilies.arabic,
      fontSizeFactor: textScaleFactor,
    );

    // Apply high contrast adjustments to text if needed
    // (Material 3 handles much of this via colorScheme)

    final textTheme = isDark
        ? scaledGenericTextTheme.apply(
            displayColor: colorScheme.onSurface,
            bodyColor: colorScheme.onSurface,
            decorationColor: colorScheme.onSurface,
          )
        : scaledGenericTextTheme;

    // 3. بناء الـ ThemeData الكامل
    return _buildThemeData(colorScheme, textTheme, fontFamily);
  }

  /// الثيم الفاتح الافتراضي
  static ThemeData get lightTheme => getTheme(mode: ThemeMode.light);

  /// الثيم الداكن الافتراضي
  static ThemeData get darkTheme => getTheme(mode: ThemeMode.dark);

  // ═══════════════════════════════════════════════════════════════════════════
  // High Contrast Schemes
  // ═══════════════════════════════════════════════════════════════════════════

  static ColorScheme get _highContrastLightColorScheme =>
      const ColorScheme.light(
        primary: PrimitiveColors.blue900, // Darker blue
        secondary: PrimitiveColors.green900, // Darker green
        onSecondary: PrimitiveColors.white,
        error: PrimitiveColors.red700,
        outline: PrimitiveColors.black,
      );

  static ColorScheme get _highContrastDarkColorScheme => const ColorScheme.dark(
        primary: PrimitiveColors.blue100, // Brighter blue
        secondary: PrimitiveColors.green100, // Brighter green
        error: PrimitiveColors.red100,
        surface: PrimitiveColors.black,
        outline: PrimitiveColors.white,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // باني الثيم (Theme Builder)
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData _buildThemeData(
    ColorScheme colorScheme,
    TextTheme textTheme,
    String? fontFamily,
  ) =>
      ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        textTheme: textTheme,
        primaryTextTheme: textTheme,
        fontFamily: fontFamily ?? FontFamilies.arabic,
        scaffoldBackgroundColor: colorScheme.brightness == Brightness.dark
            ? colorScheme.surface
            : SemanticColors.background,

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.brightness == Brightness.dark
              ? colorScheme.surface
              : colorScheme.primary,
          foregroundColor: colorScheme.brightness == Brightness.dark
              ? colorScheme.onSurface
              : colorScheme.onPrimary,
          elevation: Elevation.none,
          centerTitle: true,
          titleTextStyle: TextStyles.titleLarge.copyWith(
            color: colorScheme.brightness == Brightness.dark
                ? colorScheme.onSurface
                : colorScheme.onPrimary,
          ),
          iconTheme: IconThemeData(
            color: colorScheme.brightness == Brightness.dark
                ? colorScheme.onSurface
                : colorScheme.onPrimary,
            size: IconSizes.md,
          ),
          systemOverlayStyle: colorScheme.brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.light,
        ),

        // Card
        cardTheme: CardThemeData(
          color: colorScheme.brightness == Brightness.dark
              ? PrimitiveColors.gray700
              : colorScheme.surface,
          elevation: Elevation.sm,
          shape: const RoundedRectangleBorder(
            borderRadius: Radii.borderRadiusMd,
          ),
          margin: EdgeInsets.zero,
        ),

        // Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: Elevation.sm,
            padding: Spacing.paddingHorizontalMd.copyWith(
              top: Spacing.md,
              bottom: Spacing.md,
            ),
            minimumSize: const Size(
              TouchTargets.buttonHeightMd,
              TouchTargets.buttonHeightMd,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: Radii.borderRadiusMd,
            ),
            textStyle: TextStyles.labelLarge,
          ),
        ),

        // Outlined Button
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.primary,
            padding: Spacing.paddingHorizontalMd.copyWith(
              top: Spacing.md,
              bottom: Spacing.md,
            ),
            minimumSize: const Size(
              TouchTargets.buttonHeightMd,
              TouchTargets.buttonHeightMd,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: Radii.borderRadiusMd,
            ),
            side: BorderSide(
              color: colorScheme.outline,
              width: BorderWidths.normal,
            ),
            textStyle: TextStyles.labelLarge,
          ),
        ),

        // Text Button
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            padding: Spacing.paddingHorizontalMd.copyWith(
              top: Spacing.sm,
              bottom: Spacing.sm,
            ),
            minimumSize: const Size(
              TouchTargets.buttonHeightMd,
              TouchTargets.buttonHeightMd,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: Radii.borderRadiusMd,
            ),
            textStyle: TextStyles.labelLarge,
          ),
        ),

        // Floating Action Button
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: Elevation.md,
          shape: const RoundedRectangleBorder(
            borderRadius: Radii.borderRadiusLg,
          ),
        ),

        // Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.brightness == Brightness.dark
              ? PrimitiveColors.gray700
              : colorScheme.surface,
          contentPadding: Spacing.paddingMd,
          border: OutlineInputBorder(
            borderRadius: Radii.borderRadiusMd,
            borderSide: BorderSide(
              color: colorScheme.outline,
              width: BorderWidths.normal,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: Radii.borderRadiusMd,
            borderSide: BorderSide(
              color: colorScheme.outline,
              width: BorderWidths.normal,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: Radii.borderRadiusMd,
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: BorderWidths.thick,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: Radii.borderRadiusMd,
            borderSide: BorderSide(
              color: colorScheme.error,
              width: BorderWidths.normal,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: Radii.borderRadiusMd,
            borderSide: BorderSide(
              color: colorScheme.error,
              width: BorderWidths.thick,
            ),
          ),
          labelStyle: TextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          hintStyle: TextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          errorStyle: TextStyles.bodySmall.copyWith(
            color: colorScheme.error,
          ),
        ),

        // Icons
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: IconSizes.md,
        ),

        // Divider
        dividerTheme: DividerThemeData(
          color: colorScheme.outlineVariant,
          thickness: BorderWidths.thin,
          space: Spacing.md,
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: colorScheme.brightness == Brightness.dark
              ? PrimitiveColors.gray700
              : colorScheme.surface,
          elevation: Elevation.xl,
          shape: const RoundedRectangleBorder(
            borderRadius: Radii.borderRadiusXl,
          ),
          titleTextStyle: TextStyles.headlineSmall.copyWith(
            color: colorScheme.onSurface,
          ),
          contentTextStyle: TextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),

        // Bottom Sheet
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: colorScheme.brightness == Brightness.dark
              ? PrimitiveColors.gray700
              : colorScheme.surface,
          elevation: Elevation.lg,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Radii.xl),
            ),
          ),
        ),

        // Bottom Navigation
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: colorScheme.brightness == Brightness.dark
              ? PrimitiveColors.gray900
              : colorScheme.surface,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurfaceVariant,
          selectedLabelStyle: TextStyles.labelSmall,
          unselectedLabelStyle: TextStyles.labelSmall,
          type: BottomNavigationBarType.fixed,
          elevation: Elevation.sm,
        ),
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // ColorScheme الفاتح
  // ═══════════════════════════════════════════════════════════════════════════

  static ColorScheme get _lightColorScheme => const ColorScheme.light(
        // الألوان الأساسية
        primary: SemanticColors.primary,
        primaryContainer: SemanticColors.primaryLight,
        onPrimaryContainer: SemanticColors.primaryDark,

        // الألوان الثانوية
        secondary: SemanticColors.secondary,
        onSecondary: SemanticColors.textOnDark,
        secondaryContainer: SemanticColors.secondaryLight,
        onSecondaryContainer: SemanticColors.secondaryDark,

        // الألوان الإضافية
        tertiary: SemanticColors.info,
        onTertiary: SemanticColors.textOnDark,
        tertiaryContainer: SemanticColors.infoLight,
        onTertiaryContainer: SemanticColors.info,

        // ألوان الخطأ
        error: SemanticColors.error,
        errorContainer: SemanticColors.errorLight,
        onErrorContainer: SemanticColors.error,
        onSurface: SemanticColors.textPrimary,
        surfaceContainerHighest: SemanticColors.surfaceVariant,
        onSurfaceVariant: SemanticColors.textSecondary,

        // الحدود
        outline: SemanticColors.border,
        outlineVariant: SemanticColors.borderLight,

        // الظلال
        shadow: SemanticColors.shadow,
        scrim: SemanticColors.overlay,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // ColorScheme الداكن
  // ═══════════════════════════════════════════════════════════════════════════

  static ColorScheme get _darkColorScheme => const ColorScheme.dark(
        // الألوان الأساسية - أفتح للوضع الداكن
        primary: PrimitiveColors.blue500, // أزرق متوسط
        onPrimary: PrimitiveColors.white,
        primaryContainer: PrimitiveColors.blue900,
        onPrimaryContainer: PrimitiveColors.blue100,

        // الألوان الثانوية
        secondary: PrimitiveColors.green600,
        onSecondary: PrimitiveColors.white,
        secondaryContainer: PrimitiveColors.green900,
        onSecondaryContainer: PrimitiveColors.green100,

        // الخلفيات والأسطح
        surface: PrimitiveColors.gray900, // خلفية داكنة جداً
        onSurface: PrimitiveColors.gray50, // نص فاتح جداً
        surfaceContainerHighest: PrimitiveColors.gray700,
        onSurfaceVariant: PrimitiveColors.gray300,

        // الأخطاء
        error: PrimitiveColors.red700,
        onError: PrimitiveColors.white,
        errorContainer: PrimitiveColors.red700,

        // الحدود
        outline: PrimitiveColors.gray600,
        outlineVariant: PrimitiveColors.gray700,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // TextTheme الموحد
  // ═══════════════════════════════════════════════════════════════════════════

  static TextTheme get _textTheme => const TextTheme(
        // العناوين الكبيرة
        displayLarge: TextStyles.headlineLarge,
        displayMedium: TextStyles.headlineMedium,
        displaySmall: TextStyles.headlineSmall,

        // العناوين
        headlineLarge: TextStyles.headlineMedium,
        headlineMedium: TextStyles.headlineSmall,
        headlineSmall: TextStyles.titleLarge,

        // العناوين الرئيسية
        titleLarge: TextStyles.titleLarge,
        titleMedium: TextStyles.titleMedium,
        titleSmall: TextStyles.titleSmall,

        // النصوص
        bodyLarge: TextStyles.bodyLarge,
        bodyMedium: TextStyles.bodyMedium,
        bodySmall: TextStyles.bodySmall,

        // التسميات
        labelLarge: TextStyles.labelLarge,
        labelMedium: TextStyles.labelMedium,
        labelSmall: TextStyles.labelSmall,
      );
}
