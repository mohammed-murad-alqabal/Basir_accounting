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

import 'package:basir_app/core/theme/tokens/index.dart';
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
        error: AppColors.error,
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
        primary: AppPalette.navyDeep, // Maximum contrast
        secondary: AppPalette.greenForest, // Maximum contrast
        onSecondary: AppPalette.white,
        error: AppPalette.redBurgundy,
        outline: AppPalette.charcoal,
      );

  static ColorScheme get _highContrastDarkColorScheme => const ColorScheme.dark(
        primary: AppPalette.blueSky, // High visibility
        secondary: AppPalette.greenEmerald, // High visibility
        error: AppPalette.redAlert,
        surface: AppPalette.darkBackground,
        outline: AppPalette.darkTextPrimary,
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
            ? AppPalette.darkBackground // Professional Deep Navy
            : AppColors.background,

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
          titleTextStyle: AppTextStyles.titleLarge.copyWith(
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
              ? AppPalette.darkSurface
              : colorScheme.surface,
          elevation: Elevation.sm,
          shape:
              const RoundedRectangleBorder(borderRadius: Radii.borderRadiusMd),
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
                borderRadius: Radii.borderRadiusMd,),
            textStyle: AppTextStyles.labelLarge,
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
                borderRadius: Radii.borderRadiusMd,),
            side: BorderSide(
              color: colorScheme.outline,
              width: BorderWidths.normal,
            ),
            textStyle: AppTextStyles.labelLarge,
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
                borderRadius: Radii.borderRadiusMd,),
            textStyle: AppTextStyles.labelLarge,
          ),
        ),

        // Floating Action Button
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: Elevation.md,
          shape:
              const RoundedRectangleBorder(borderRadius: Radii.borderRadiusLg),
        ),

        // Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.brightness == Brightness.dark
              ? AppPalette.darkSurface
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
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          errorStyle:
              AppTextStyles.bodySmall.copyWith(color: colorScheme.error),
        ),

        // Icons
        iconTheme:
            IconThemeData(color: colorScheme.onSurface, size: IconSizes.md),

        // Divider
        dividerTheme: DividerThemeData(
          color: colorScheme.outlineVariant,
          thickness: BorderWidths.thin,
          space: Spacing.md,
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: colorScheme.brightness == Brightness.dark
              ? AppPalette.darkSurface
              : colorScheme.surface,
          elevation: Elevation.xl,
          shape:
              const RoundedRectangleBorder(borderRadius: Radii.borderRadiusXl),
          titleTextStyle: AppTextStyles.headlineSmall.copyWith(
            color: colorScheme.onSurface,
          ),
          contentTextStyle: AppTextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),

        // Bottom Sheet
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: colorScheme.brightness == Brightness.dark
              ? AppPalette.darkSurface
              : colorScheme.surface,
          elevation: Elevation.lg,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xl)),
          ),
        ),

        // Bottom Navigation
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: colorScheme.brightness == Brightness.dark
              ? AppPalette.darkSurface
              : colorScheme.surface,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurfaceVariant,
          selectedLabelStyle: AppTextStyles.labelSmall,
          unselectedLabelStyle: AppTextStyles.labelSmall,
          type: BottomNavigationBarType.fixed,
          elevation: Elevation.sm,
        ),
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // ColorScheme الفاتح
  // ═══════════════════════════════════════════════════════════════════════════

  static ColorScheme get _lightColorScheme => const ColorScheme.light(
        // الألوان الأساسية
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryDark,

        // الألوان الثانوية
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnDark,
        secondaryContainer: AppColors.secondaryLight,
        onSecondaryContainer: AppColors.secondaryDark,

        // الألوان الإضافية
        tertiary: AppColors.info,
        onTertiary: AppColors.textOnDark,
        tertiaryContainer: AppColors.infoLight,
        onTertiaryContainer: AppColors.info,

        // ألوان الخطأ
        error: AppColors.error,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.error,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.textSecondary,

        // الحدود
        outline: AppColors.border,
        outlineVariant: AppColors.borderLight,

        // الظلال
        shadow: AppColors.shadow,
        scrim: AppColors.overlay,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // ColorScheme الداكن
  // ═══════════════════════════════════════════════════════════════════════════

  static ColorScheme get _darkColorScheme => const ColorScheme.dark(
        // الألوان الأساسية - Professional Blue for Dark Mode
        primary: AppPalette.blueCorporate,
        onPrimary: AppPalette.white,
        primaryContainer: AppPalette.navyDeep,
        onPrimaryContainer: AppPalette.blueLight,

        // الألوان الثانوية - Accounting Green
        secondary: AppPalette.greenEmerald,
        onSecondary: AppPalette.white,
        secondaryContainer: AppPalette.greenForest,
        onSecondaryContainer: AppPalette.greenLight,

        // الخلفيات والأسطح - Professional Deep Navy
        surface: AppPalette.darkSurface,
        onSurface: AppPalette.darkTextPrimary,
        surfaceContainerHighest: AppPalette.darkBorder,
        onSurfaceVariant: Color(0xFFCBD5E1), // Slate 300
        // الأخطاء
        error: Color(0xFFEF4444), // Red 500
        onError: Colors.white,
        errorContainer: Color(0xFF7F1D1D), // Red 900
        // الحدود
        outline: Color(0xFF475569), // Slate 500
        outlineVariant: Color(0xFF334155), // Slate 700
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // TextTheme الموحد
  // ═══════════════════════════════════════════════════════════════════════════

  static TextTheme get _textTheme => const TextTheme(
        // العناوين الكبيرة
        displayLarge: AppTextStyles.headlineLarge,
        displayMedium: AppTextStyles.headlineMedium,
        displaySmall: AppTextStyles.headlineSmall,

        // العناوين
        headlineLarge: AppTextStyles.headlineMedium,
        headlineMedium: AppTextStyles.headlineSmall,
        headlineSmall: AppTextStyles.titleLarge,

        // العناوين الرئيسية
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,

        // النصوص
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,

        // التسميات
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      );
}
