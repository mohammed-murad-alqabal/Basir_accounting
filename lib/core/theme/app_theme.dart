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
  // الثيم الفاتح (Light Theme)
  // ═══════════════════════════════════════════════════════════════════════════

  /// الثيم الفاتح الكامل
  ///
  /// يدمج جميع Design Tokens في ThemeData موحد
  static ThemeData get lightTheme {
    final colorScheme = _lightColorScheme;
    final textTheme = _textTheme;

    return ThemeData(
      // ═══════════════════════════════════════════════════════════════════════
      // Material Design 3
      // ═══════════════════════════════════════════════════════════════════════
      useMaterial3: true,

      // ═══════════════════════════════════════════════════════════════════════
      // الألوان (Color Scheme)
      // ═══════════════════════════════════════════════════════════════════════
      colorScheme: colorScheme,

      // ═══════════════════════════════════════════════════════════════════════
      // الطباعة (Typography)
      // ═══════════════════════════════════════════════════════════════════════
      textTheme: textTheme,
      primaryTextTheme: textTheme,

      // ═══════════════════════════════════════════════════════════════════════
      // الخط الافتراضي
      // ═══════════════════════════════════════════════════════════════════════
      fontFamily: FontFamilies.arabic,

      // ═══════════════════════════════════════════════════════════════════════
      // شريط التطبيق (AppBar)
      // ═══════════════════════════════════════════════════════════════════════
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: Elevation.none,
        centerTitle: true,
        titleTextStyle: TextStyles.titleLarge.copyWith(
          color: colorScheme.onPrimary,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary,
          size: IconSizes.md,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // البطاقات (Card)
      // ═══════════════════════════════════════════════════════════════════════
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: Elevation.sm,
        shape: const RoundedRectangleBorder(
          borderRadius: Radii.borderRadiusMd,
        ),
        margin: EdgeInsets.zero,
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // الأزرار المرتفعة (Elevated Button)
      // ═══════════════════════════════════════════════════════════════════════
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

      // ═══════════════════════════════════════════════════════════════════════
      // الأزرار المحددة (Outlined Button)
      // ═══════════════════════════════════════════════════════════════════════
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

      // ═══════════════════════════════════════════════════════════════════════
      // الأزرار النصية (Text Button)
      // ═══════════════════════════════════════════════════════════════════════
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

      // ═══════════════════════════════════════════════════════════════════════
      // الأزرار العائمة (Floating Action Button)
      // ═══════════════════════════════════════════════════════════════════════
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: Elevation.md,
        shape: const RoundedRectangleBorder(
          borderRadius: Radii.borderRadiusLg,
        ),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // حقول الإدخال (Input Decoration)
      // ═══════════════════════════════════════════════════════════════════════
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
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

      // ═══════════════════════════════════════════════════════════════════════
      // أيقونات (Icon Theme)
      // ═══════════════════════════════════════════════════════════════════════
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: IconSizes.md,
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // الفواصل (Divider)
      // ═══════════════════════════════════════════════════════════════════════
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: BorderWidths.thin,
        space: Spacing.md,
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // الحوارات (Dialog)
      // ═══════════════════════════════════════════════════════════════════════
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
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

      // ═══════════════════════════════════════════════════════════════════════
      // القوائم المنبثقة (Bottom Sheet)
      // ═══════════════════════════════════════════════════════════════════════
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        elevation: Elevation.lg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Radii.xl),
          ),
        ),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // شريط التنقل السفلي (Bottom Navigation Bar)
      // ═══════════════════════════════════════════════════════════════════════
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: TextStyles.labelSmall,
        unselectedLabelStyle: TextStyles.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: Elevation.sm,
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // الـ Scaffold
      // ═══════════════════════════════════════════════════════════════════════
      scaffoldBackgroundColor: SemanticColors.background,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // الثيم الداكن (Dark Theme) - جاهز للتوسع المستقبلي
  // ═══════════════════════════════════════════════════════════════════════════

  /// الثيم الداكن (محجوز للتطوير المستقبلي)
  // TODO(baseer): تطبيق الثيم الداكن في المرحلة القادمة
  static ThemeData get darkTheme => lightTheme;

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
