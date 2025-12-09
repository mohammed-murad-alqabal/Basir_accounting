import 'package:basser_app/core/theme.dart';
import 'package:flutter/material.dart';

/// ألوان الوضع الليلي
///
/// يحتوي على جميع الألوان المستخدمة في الوضع الليلي
/// مع ضمان التباين العالي (WCAG AA)
class AppColorsDark {
  // ===== الألوان الأساسية =====

  /// اللون الأساسي للوضع الليلي (أزرق فاتح)
  static const Color primary = Color(0xFF64B5F6);

  /// اللون الأساسي الفاتح
  static const Color primaryLight = Color(0xFF1E3A5F);

  /// اللون الأساسي الداكن
  static const Color primaryDark = Color(0xFF90CAF9);

  /// اللون الثانوي (أخضر فاتح)
  static const Color secondary = Color(0xFF81C784);

  /// اللون الثانوي الفاتح
  static const Color secondaryLight = Color(0xFF1B3A1F);

  /// اللون الثانوي الداكن
  static const Color secondaryDark = Color(0xFFA5D6A7);

  // ===== ألوان الخلفية =====

  /// لون الخلفية الرئيسية (رمادي داكن جداً)
  static const Color background = Color(0xFF121212);

  /// لون السطح (للبطاقات والعناصر)
  static const Color surface = Color(0xFF1E1E1E);

  /// لون السطح الثانوي
  static const Color surfaceVariant = Color(0xFF2C2C2C);

  // ===== ألوان الحالة =====

  /// لون الخطأ (أحمر فاتح)
  static const Color error = Color(0xFFEF5350);

  /// لون الخطأ الفاتح
  static const Color errorLight = Color(0xFF3A1F1F);

  /// لون النجاح (أخضر فاتح)
  static const Color success = Color(0xFF66BB6A);

  /// لون النجاح الفاتح
  static const Color successLight = Color(0xFF1B3A1F);

  /// لون التحذير (برتقالي فاتح)
  static const Color warning = Color(0xFFFF9800);

  /// لون التحذير الفاتح
  static const Color warningLight = Color(0xFF3A2A1F);

  /// لون المعلومات (أزرق فاتح)
  static const Color info = Color(0xFF42A5F5);

  /// لون المعلومات الفاتح
  static const Color infoLight = Color(0xFF1E2F3A);

  // ===== ألوان النصوص =====

  /// لون النص الأساسي (أبيض)
  static const Color textPrimary = Color(0xFFE0E0E0);

  /// لون النص الثانوي (رمادي فاتح)
  static const Color textSecondary = Color(0xFFB0B0B0);

  /// لون النص التوضيحي (رمادي متوسط)
  static const Color textHint = Color(0xFF808080);

  /// لون النص المعطل
  static const Color textDisabled = Color(0xFF606060);

  /// لون النص على الخلفية الفاتحة
  static const Color textOnLight = Color(0xFF1A1A1A);

  // ===== ألوان الحدود والفواصل =====

  /// لون الحدود (رمادي متوسط)
  static const Color border = Color(0xFF404040);

  /// لون الحدود الفاتحة
  static const Color borderLight = Color(0xFF303030);

  /// لون الحدود الداكنة
  static const Color borderDark = Color(0xFF505050);

  /// لون الفواصل
  static const Color divider = Color(0xFF303030);

  // ===== ألوان إضافية =====

  /// لون الظل (شفاف)
  static const Color shadow = Color(0x33000000);

  /// لون التراكب (شفاف)
  static const Color overlay = Color(0x99000000);

  /// لون التركيز
  static const Color focus = Color(0xFF64B5F6);
}

/// إنشاء ثيم الوضع الليلي
///
/// ينشئ [ThemeData] كامل للوضع الليلي مع جميع الأنماط والألوان
///
/// Returns: [ThemeData] جاهز للاستخدام في MaterialApp
ThemeData createDarkTheme() {
  // استخدام خط Cairo المحلي (يعمل بدون إنترنت)
  const fontFamily = AppTypography.arabicFont;

  return ThemeData(
    fontFamily: fontFamily,
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColorsDark.primary,
      brightness: Brightness.dark,
      primary: AppColorsDark.primary,
      onPrimary: AppColorsDark.textOnLight,
      primaryContainer: AppColorsDark.primaryLight,
      onPrimaryContainer: AppColorsDark.primaryDark,
      secondary: AppColorsDark.secondary,
      onSecondary: AppColorsDark.textOnLight,
      secondaryContainer: AppColorsDark.secondaryLight,
      onSecondaryContainer: AppColorsDark.secondaryDark,
      error: AppColorsDark.error,
      onError: AppColorsDark.textOnLight,
      errorContainer: AppColorsDark.errorLight,
      onErrorContainer: AppColorsDark.error,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.textPrimary,
      surfaceContainerHighest: AppColorsDark.surfaceVariant,
      outline: AppColorsDark.border,
      outlineVariant: AppColorsDark.borderLight,
      shadow: AppColorsDark.shadow,
    ),
    scaffoldBackgroundColor: AppColorsDark.background,

    // ===== AppBar Theme =====
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsDark.surface,
      foregroundColor: AppColorsDark.textPrimary,
      elevation: 0,
      centerTitle: true,
      shadowColor: AppColorsDark.shadow,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: AppTypography.titleLarge,
        fontWeight: AppTypography.semiBold,
        color: AppColorsDark.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(color: AppColorsDark.textPrimary, size: 24),
    ),

    // ===== Card Theme =====
    cardTheme: CardThemeData(
      color: AppColorsDark.surface,
      elevation: 0,
      shadowColor: AppColorsDark.shadow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        side: const BorderSide(color: AppColorsDark.border),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    ),

    // ===== Input Decoration Theme =====
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsDark.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColorsDark.border, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColorsDark.border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColorsDark.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColorsDark.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColorsDark.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(
          color: AppColorsDark.borderLight,
          width: 1.5,
        ),
      ),
      hintStyle: const TextStyle(
        color: AppColorsDark.textHint,
        fontSize: AppTypography.bodyMedium,
        fontWeight: AppTypography.regular,
        height: AppTypography.bodyLineHeight,
      ),
      labelStyle: const TextStyle(
        color: AppColorsDark.textSecondary,
        fontSize: AppTypography.bodyMedium,
        fontWeight: AppTypography.medium,
        height: AppTypography.labelLineHeight,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColorsDark.primary,
        fontSize: AppTypography.bodySmall,
        fontWeight: AppTypography.medium,
      ),
      errorStyle: const TextStyle(
        color: AppColorsDark.error,
        fontSize: AppTypography.bodySmall,
        fontWeight: AppTypography.regular,
        height: AppTypography.labelLineHeight,
      ),
    ),

    // ===== Button Themes =====
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsDark.primary,
        foregroundColor: AppColorsDark.textOnLight,
        disabledBackgroundColor: AppColorsDark.borderLight,
        disabledForegroundColor: AppColorsDark.textDisabled,
        elevation: 0,
        shadowColor: AppColorsDark.shadow,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        textStyle: const TextStyle(
          fontSize: AppTypography.labelLarge,
          fontWeight: AppTypography.semiBold,
          height: AppTypography.labelLineHeight,
          letterSpacing: 0.5,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColorsDark.primary,
        disabledForegroundColor: AppColorsDark.textDisabled,
        side: const BorderSide(color: AppColorsDark.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 2,
        ),
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        textStyle: const TextStyle(
          fontSize: AppTypography.labelLarge,
          fontWeight: AppTypography.semiBold,
          height: AppTypography.labelLineHeight,
          letterSpacing: 0.5,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorsDark.primary,
        disabledForegroundColor: AppColorsDark.textDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        minimumSize: const Size(64, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
        textStyle: const TextStyle(
          fontSize: AppTypography.labelLarge,
          fontWeight: AppTypography.medium,
          height: AppTypography.labelLineHeight,
          letterSpacing: 0.25,
        ),
      ),
    ),

    // ===== FloatingActionButton Theme =====
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColorsDark.primary,
      foregroundColor: AppColorsDark.textOnLight,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 6,
      highlightElevation: 8,
      shape: CircleBorder(),
      iconSize: 24,
    ),

    // ===== Icon Theme =====
    iconTheme: const IconThemeData(color: AppColorsDark.textPrimary, size: 24),

    // ===== Text Theme مع خط Cairo المحلي =====
    // استخدام خط Cairo من assets/fonts/ لضمان عمله بدون إنترنت
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: AppTypography.headlineLarge,
        fontWeight: AppTypography.bold,
        color: AppColorsDark.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: AppTypography.headlineMedium,
        fontWeight: AppTypography.bold,
        color: AppColorsDark.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: -0.25,
      ),
      displaySmall: TextStyle(
        fontSize: AppTypography.headlineSmall,
        fontWeight: AppTypography.bold,
        color: AppColorsDark.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        fontSize: AppTypography.titleLarge,
        fontWeight: AppTypography.semiBold,
        color: AppColorsDark.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        fontSize: AppTypography.titleMedium,
        fontWeight: AppTypography.semiBold,
        color: AppColorsDark.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: 0.15,
      ),
      headlineSmall: TextStyle(
        fontSize: AppTypography.titleSmall,
        fontWeight: AppTypography.semiBold,
        color: AppColorsDark.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: 0.15,
      ),
      titleLarge: TextStyle(
        fontSize: AppTypography.titleMedium,
        fontWeight: AppTypography.semiBold,
        color: AppColorsDark.textPrimary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        fontSize: AppTypography.titleSmall,
        fontWeight: AppTypography.medium,
        color: AppColorsDark.textPrimary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: AppTypography.bodyLarge,
        fontWeight: AppTypography.medium,
        color: AppColorsDark.textPrimary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontSize: AppTypography.bodyLarge,
        fontWeight: AppTypography.regular,
        color: AppColorsDark.textPrimary,
        height: AppTypography.bodyLineHeight,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTypography.bodyMedium,
        fontWeight: AppTypography.regular,
        color: AppColorsDark.textPrimary,
        height: AppTypography.bodyLineHeight,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: AppTypography.bodySmall,
        fontWeight: AppTypography.regular,
        color: AppColorsDark.textSecondary,
        height: AppTypography.bodyLineHeight,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontSize: AppTypography.labelLarge,
        fontWeight: AppTypography.medium,
        color: AppColorsDark.textPrimary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: AppTypography.labelMedium,
        fontWeight: AppTypography.medium,
        color: AppColorsDark.textSecondary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: AppTypography.labelSmall,
        fontWeight: AppTypography.medium,
        color: AppColorsDark.textSecondary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.5,
      ),
    ),

    // ===== Divider Theme =====
    dividerTheme: const DividerThemeData(
      color: AppColorsDark.divider,
      thickness: 1,
      space: AppSpacing.md,
    ),

    // ===== ListTile Theme =====
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      minLeadingWidth: 40,
      iconColor: AppColorsDark.textSecondary,
      textColor: AppColorsDark.textPrimary,
    ),

    // ===== Chip Theme =====
    chipTheme: ChipThemeData(
      backgroundColor: AppColorsDark.surfaceVariant,
      deleteIconColor: AppColorsDark.textSecondary,
      disabledColor: AppColorsDark.borderLight,
      selectedColor: AppColorsDark.primaryLight,
      secondarySelectedColor: AppColorsDark.secondaryLight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      labelStyle: const TextStyle(
        fontSize: AppTypography.labelMedium,
        fontWeight: AppTypography.medium,
        color: AppColorsDark.textPrimary,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: AppTypography.labelMedium,
        fontWeight: AppTypography.medium,
        color: AppColorsDark.textSecondary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
    ),

    // ===== Dialog Theme =====
    dialogTheme: DialogThemeData(
      backgroundColor: AppColorsDark.surface,
      elevation: 8,
      shadowColor: AppColorsDark.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      titleTextStyle: const TextStyle(
        fontSize: AppTypography.titleLarge,
        fontWeight: AppTypography.semiBold,
        color: AppColorsDark.textPrimary,
        height: AppTypography.headlineLineHeight,
      ),
      contentTextStyle: const TextStyle(
        fontSize: AppTypography.bodyMedium,
        fontWeight: AppTypography.regular,
        color: AppColorsDark.textSecondary,
        height: AppTypography.bodyLineHeight,
      ),
    ),

    // ===== SnackBar Theme =====
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColorsDark.surfaceVariant,
      contentTextStyle: const TextStyle(
        fontSize: AppTypography.bodyMedium,
        fontWeight: AppTypography.regular,
        color: AppColorsDark.textPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    ),

    // ===== Bottom Sheet Theme =====
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColorsDark.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.lg),
        ),
      ),
    ),

    // ===== Progress Indicator Theme =====
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColorsDark.primary,
      linearTrackColor: AppColorsDark.borderLight,
      circularTrackColor: AppColorsDark.borderLight,
    ),

    // ===== Switch Theme =====
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsDark.primary;
        }
        return AppColorsDark.borderDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsDark.primaryLight;
        }
        return AppColorsDark.borderLight;
      }),
    ),

    // ===== Checkbox Theme =====
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsDark.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColorsDark.textOnLight),
      side: const BorderSide(color: AppColorsDark.border, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.xs),
      ),
    ),

    // ===== Radio Theme =====
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColorsDark.primary;
        }
        return AppColorsDark.border;
      }),
    ),
  );
}
