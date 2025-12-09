import 'package:flutter/material.dart';

/// نظام التصميم الموحد للتطبيق
/// يحتوي على الألوان والطباعة والأنماط الموحدة

/// ألوان التطبيق
///
/// يحتوي على جميع الألوان المستخدمة في التطبيق
/// لضمان التناسق في التصميم والتباين العالي (WCAG AA)
class AppColors {
  // ===== الألوان الأساسية =====

  /// اللون الأساسي للتطبيق (أزرق داكن محسّن للتباين)
  /// نسبة التباين: 4.5:1 على الأبيض
  static const Color primary = Color(0xFF0056B3);

  /// اللون الأساسي الفاتح (للخلفيات)
  static const Color primaryLight = Color(0xFFE3F2FD);

  /// اللون الأساسي الداكن (للنصوص)
  static const Color primaryDark = Color(0xFF003D82);

  /// اللون الثانوي (أخضر محسّن)
  /// نسبة التباين: 4.5:1 على الأبيض
  static const Color secondary = Color(0xFF1E7E34);

  /// اللون الثانوي الفاتح
  static const Color secondaryLight = Color(0xFFE8F5E9);

  /// اللون الثانوي الداكن
  static const Color secondaryDark = Color(0xFF155724);

  // ===== ألوان الخلفية =====

  /// لون الخلفية الرئيسية (رمادي فاتح جداً)
  static const Color background = Color(0xFFF5F7FA);

  /// لون السطح (للبطاقات والعناصر)
  static const Color surface = Color(0xFFFFFFFF);

  /// لون السطح الثانوي
  static const Color surfaceVariant = Color(0xFFF8F9FA);

  // ===== ألوان الحالة =====

  /// لون الخطأ (أحمر داكن محسّن)
  /// نسبة التباين: 4.5:1 على الأبيض
  static const Color error = Color(0xFFC62828);

  /// لون الخطأ الفاتح
  static const Color errorLight = Color(0xFFFFEBEE);

  /// لون النجاح (أخضر داكن محسّن)
  /// نسبة التباين: 4.5:1 على الأبيض
  static const Color success = Color(0xFF2E7D32);

  /// لون النجاح الفاتح
  static const Color successLight = Color(0xFFE8F5E9);

  /// لون التحذير (برتقالي داكن محسّن)
  /// نسبة التباين: 4.5:1 على الأبيض
  static const Color warning = Color(0xFFE65100);

  /// لون التحذير الفاتح
  static const Color warningLight = Color(0xFFFFF3E0);

  /// لون المعلومات (أزرق فاتح محسّن)
  /// نسبة التباين: 4.5:1 على الأبيض
  static const Color info = Color(0xFF0277BD);

  /// لون المعلومات الفاتح
  static const Color infoLight = Color(0xFFE1F5FE);

  // ===== ألوان النصوص =====

  /// لون النص الأساسي (أسود داكن جداً)
  /// نسبة التباين: 16:1 على الأبيض
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// لون النص الثانوي (رمادي داكن)
  /// نسبة التباين: 7:1 على الأبيض
  static const Color textSecondary = Color(0xFF4A4A4A);

  /// لون النص التوضيحي (رمادي متوسط)
  /// نسبة التباين: 4.5:1 على الأبيض
  static const Color textHint = Color(0xFF757575);

  /// لون النص المعطل
  static const Color textDisabled = Color(0xFFBDBDBD);

  /// لون النص على الخلفية الداكنة
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ===== ألوان الحدود والفواصل =====

  /// لون الحدود (رمادي متوسط)
  static const Color border = Color(0xFFD1D5DB);

  /// لون الحدود الفاتحة
  static const Color borderLight = Color(0xFFE5E7EB);

  /// لون الحدود الداكنة
  static const Color borderDark = Color(0xFF9CA3AF);

  /// لون الفواصل
  static const Color divider = Color(0xFFE5E7EB);

  // ===== ألوان إضافية =====

  /// لون الظل (شفاف)
  static const Color shadow = Color(0x1A000000);

  /// لون التراكب (شفاف)
  static const Color overlay = Color(0x66000000);

  /// لون التركيز
  static const Color focus = Color(0xFF2196F3);
}

/// أحجام وأنواع الخطوط
///
/// يحتوي على جميع أحجام الخطوط وأنواعها المستخدمة في التطبيق
/// محسّنة للقراءة وإمكانية الوصول
class AppTypography {
  // ===== أحجام العناوين =====

  /// حجم العنوان الكبير جداً (34px) - محسّن للقراءة
  static const double headlineLarge = 34;

  /// حجم العنوان الكبير (28px)
  static const double headlineMedium = 28;

  /// حجم العنوان الصغير (24px)
  static const double headlineSmall = 24;

  // ===== أحجام العناوين الرئيسية =====

  /// حجم العنوان الرئيسي الكبير (22px)
  static const double titleLarge = 22;

  /// حجم العنوان الرئيسي المتوسط (18px)
  static const double titleMedium = 18;

  /// حجم العنوان الرئيسي الصغير (16px)
  static const double titleSmall = 16;

  // ===== أحجام النصوص =====

  /// حجم النص الكبير (17px) - محسّن للقراءة
  static const double bodyLarge = 17;

  /// حجم النص المتوسط (15px) - محسّن للقراءة
  static const double bodyMedium = 15;

  /// حجم النص الصغير (13px)
  static const double bodySmall = 13;

  // ===== أحجام التسميات =====

  /// حجم التسمية الكبيرة (15px)
  static const double labelLarge = 15;

  /// حجم التسمية المتوسطة (13px)
  static const double labelMedium = 13;

  /// حجم التسمية الصغيرة (12px)
  static const double labelSmall = 12;

  // ===== أوزان الخطوط =====

  /// وزن خفيف
  static const FontWeight light = FontWeight.w300;

  /// وزن عادي
  static const FontWeight regular = FontWeight.w400;

  /// وزن متوسط
  static const FontWeight medium = FontWeight.w500;

  /// وزن نصف عريض
  static const FontWeight semiBold = FontWeight.w600;

  /// وزن عريض
  static const FontWeight bold = FontWeight.w700;

  /// وزن عريض جداً
  static const FontWeight extraBold = FontWeight.w800;

  // ===== ارتفاع الأسطر =====

  /// ارتفاع السطر للعناوين (1.2)
  static const double headlineLineHeight = 1.2;

  /// ارتفاع السطر للنصوص (1.5) - محسّن للقراءة
  static const double bodyLineHeight = 1.5;

  /// ارتفاع السطر للتسميات (1.3)
  static const double labelLineHeight = 1.3;

  // ===== الخطوط =====

  /// خط اللغة العربية (Cairo) - خط واضح وسهل القراءة
  static const String arabicFont = 'Cairo';

  /// خط اللغة الإنجليزية (Roboto)
  static const String englishFont = 'Roboto';

  /// خط الأرقام (Roboto Mono) - للأرقام والمبالغ
  static const String numberFont = 'Roboto Mono';
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

/// أحجام الأيقونات
///
/// يحتوي على جميع أحجام الأيقونات المستخدمة في التطبيق
class AppIconSize {
  /// حجم صغير جداً (18px) - محسّن للوضوح
  static const double xs = 18;

  /// حجم صغير (22px) - محسّن للوضوح
  static const double sm = 22;

  /// حجم متوسط (26px) - الحجم الافتراضي المحسّن
  static const double md = 26;

  /// حجم كبير (32px)
  static const double lg = 32;

  /// حجم كبير جداً (40px)
  static const double xl = 40;

  /// حجم كبير جداً جداً (48px)
  static const double xxl = 48;
}

/// الظلال
///
/// يحتوي على جميع أنماط الظلال المستخدمة في التطبيق
class AppShadows {
  /// ظل صغير
  static const List<BoxShadow> sm = [
    BoxShadow(color: AppColors.shadow, offset: Offset(0, 1), blurRadius: 2),
  ];

  /// ظل متوسط
  static const List<BoxShadow> md = [
    BoxShadow(color: AppColors.shadow, offset: Offset(0, 2), blurRadius: 4),
  ];

  /// ظل كبير
  static const List<BoxShadow> lg = [
    BoxShadow(color: AppColors.shadow, offset: Offset(0, 4), blurRadius: 8),
  ];

  /// ظل كبير جداً
  static const List<BoxShadow> xl = [
    BoxShadow(color: AppColors.shadow, offset: Offset(0, 8), blurRadius: 16),
  ];
}

/// مدة الحركات
///
/// يحتوي على جميع مدد الحركات المستخدمة في التطبيق
class AppDurations {
  /// مدة قصيرة جداً (100ms)
  static const Duration fast = Duration(milliseconds: 100);

  /// مدة قصيرة (200ms)
  static const Duration short = Duration(milliseconds: 200);

  /// مدة متوسطة (300ms)
  static const Duration medium = Duration(milliseconds: 300);

  /// مدة طويلة (500ms)
  static const Duration long = Duration(milliseconds: 500);
}

/// منحنيات الحركة
///
/// يحتوي على جميع منحنيات الحركة المستخدمة في التطبيق
class AppCurves {
  /// منحنى سهل
  static const Curve easeIn = Curves.easeIn;

  /// منحنى سهل للخارج
  static const Curve easeOut = Curves.easeOut;

  /// منحنى سهل للداخل والخارج
  static const Curve easeInOut = Curves.easeInOut;

  /// منحنى مرن
  static const Curve elastic = Curves.elasticOut;
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
ThemeData createAppTheme() {
  // استخدام خط Cairo المحلي (من assets/fonts/)
  // هذا يضمن عمل الخط بدون الحاجة للإنترنت
  const fontFamily = AppTypography.arabicFont;

  return ThemeData(
    fontFamily: fontFamily,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnDark,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textOnDark,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.secondaryDark,
      error: AppColors.error,
      onError: AppColors.textOnDark,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      outline: AppColors.border,
      outlineVariant: AppColors.borderLight,
      shadow: AppColors.shadow,
    ),
    scaffoldBackgroundColor: AppColors.background,

    // ===== AppBar Theme =====
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      shadowColor: AppColors.shadow,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: AppTypography.titleLarge,
        fontWeight: AppTypography.semiBold,
        color: AppColors.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary, size: 24),
    ),
    // ===== Card Theme =====
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shadowColor: AppColors.shadow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        side: const BorderSide(color: AppColors.border),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    ),
    // ===== Input Decoration Theme =====
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        borderSide: const BorderSide(color: AppColors.borderLight, width: 1.5),
      ),
      hintStyle: const TextStyle(
        color: AppColors.textHint,
        fontSize: AppTypography.bodyMedium,
        fontWeight: AppTypography.regular,
        height: AppTypography.bodyLineHeight,
      ),
      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: AppTypography.bodyMedium,
        fontWeight: AppTypography.medium,
        height: AppTypography.labelLineHeight,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.primary,
        fontSize: AppTypography.bodySmall,
        fontWeight: AppTypography.medium,
      ),
      errorStyle: const TextStyle(
        color: AppColors.error,
        fontSize: AppTypography.bodySmall,
        fontWeight: AppTypography.regular,
        height: AppTypography.labelLineHeight,
      ),
    ),
    // ===== Button Themes =====
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        disabledBackgroundColor: AppColors.borderLight,
        disabledForegroundColor: AppColors.textDisabled,
        elevation: 0,
        shadowColor: AppColors.shadow,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 4, // زيادة padding العمودي
        ),
        minimumSize: const Size(88, 52), // زيادة الحد الأدنى للارتفاع
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        textStyle: const TextStyle(
          fontSize: AppTypography.labelLarge,
          fontWeight: AppTypography.semiBold,
          height: 1.5, // زيادة line-height من 1.3 إلى 1.5
          letterSpacing: 0.5,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textDisabled,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md + 4, // زيادة padding العمودي
        ),
        minimumSize: const Size(88, 52), // زيادة الحد الأدنى للارتفاع
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        textStyle: const TextStyle(
          fontSize: AppTypography.labelLarge,
          fontWeight: AppTypography.semiBold,
          height: 1.5, // زيادة line-height من 1.3 إلى 1.5
          letterSpacing: 0.5,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2, // زيادة padding العمودي
        ),
        minimumSize: const Size(64, 44), // زيادة الحد الأدنى للارتفاع
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
        textStyle: const TextStyle(
          fontSize: AppTypography.labelLarge,
          fontWeight: AppTypography.medium,
          height: 1.5, // زيادة line-height من 1.3 إلى 1.5
          letterSpacing: 0.25,
        ),
      ),
    ),

    // ===== FloatingActionButton Theme =====
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnDark,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 6,
      highlightElevation: 8,
      shape: CircleBorder(),
      iconSize: 24,
    ),

    // ===== Icon Theme =====
    iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),
    // ===== Text Theme مع خط Cairo المحلي =====
    // استخدام خط Cairo من assets/fonts/ لضمان عمله بدون إنترنت
    textTheme: const TextTheme(
      // Display styles (للعناوين الكبيرة جداً)
      displayLarge: TextStyle(
        fontSize: AppTypography.headlineLarge,
        fontWeight: AppTypography.bold,
        color: AppColors.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: AppTypography.headlineMedium,
        fontWeight: AppTypography.bold,
        color: AppColors.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: -0.25,
      ),
      displaySmall: TextStyle(
        fontSize: AppTypography.headlineSmall,
        fontWeight: AppTypography.bold,
        color: AppColors.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: 0,
      ),

      // Headline styles (للعناوين)
      headlineLarge: TextStyle(
        fontSize: AppTypography.titleLarge,
        fontWeight: AppTypography.semiBold,
        color: AppColors.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        fontSize: AppTypography.titleMedium,
        fontWeight: AppTypography.semiBold,
        color: AppColors.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: 0.15,
      ),
      headlineSmall: TextStyle(
        fontSize: AppTypography.titleSmall,
        fontWeight: AppTypography.semiBold,
        color: AppColors.textPrimary,
        height: AppTypography.headlineLineHeight,
        letterSpacing: 0.15,
      ),

      // Title styles (للعناوين الفرعية)
      titleLarge: TextStyle(
        fontSize: AppTypography.titleMedium,
        fontWeight: AppTypography.semiBold,
        color: AppColors.textPrimary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        fontSize: AppTypography.titleSmall,
        fontWeight: AppTypography.medium,
        color: AppColors.textPrimary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: AppTypography.bodyLarge,
        fontWeight: AppTypography.medium,
        color: AppColors.textPrimary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.1,
      ),

      // Body styles (للنصوص الأساسية)
      bodyLarge: TextStyle(
        fontSize: AppTypography.bodyLarge,
        fontWeight: AppTypography.regular,
        color: AppColors.textPrimary,
        height: AppTypography.bodyLineHeight,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTypography.bodyMedium,
        fontWeight: AppTypography.regular,
        color: AppColors.textPrimary,
        height: AppTypography.bodyLineHeight,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: AppTypography.bodySmall,
        fontWeight: AppTypography.regular,
        color: AppColors.textSecondary,
        height: AppTypography.bodyLineHeight,
        letterSpacing: 0.4,
      ),

      // Label styles (للتسميات والأزرار)
      labelLarge: TextStyle(
        fontSize: AppTypography.labelLarge,
        fontWeight: AppTypography.medium,
        color: AppColors.textPrimary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: AppTypography.labelMedium,
        fontWeight: AppTypography.medium,
        color: AppColors.textSecondary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: AppTypography.labelSmall,
        fontWeight: AppTypography.medium,
        color: AppColors.textSecondary,
        height: AppTypography.labelLineHeight,
        letterSpacing: 0.5,
      ),
    ),

    // ===== Divider Theme =====
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
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
      iconColor: AppColors.textSecondary,
      textColor: AppColors.textPrimary,
    ),

    // ===== Chip Theme =====
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      deleteIconColor: AppColors.textSecondary,
      disabledColor: AppColors.borderLight,
      selectedColor: AppColors.primaryLight,
      secondarySelectedColor: AppColors.secondaryLight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      labelStyle: const TextStyle(
        fontSize: AppTypography.labelMedium,
        fontWeight: AppTypography.medium,
        color: AppColors.textPrimary,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: AppTypography.labelMedium,
        fontWeight: AppTypography.medium,
        color: AppColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
    ),

    // ===== Dialog Theme =====
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      elevation: 8,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      titleTextStyle: const TextStyle(
        fontSize: AppTypography.titleLarge,
        fontWeight: AppTypography.semiBold,
        color: AppColors.textPrimary,
        height: AppTypography.headlineLineHeight,
      ),
      contentTextStyle: const TextStyle(
        fontSize: AppTypography.bodyMedium,
        fontWeight: AppTypography.regular,
        color: AppColors.textSecondary,
        height: AppTypography.bodyLineHeight,
      ),
    ),

    // ===== SnackBar Theme =====
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: const TextStyle(
        fontSize: AppTypography.bodyMedium,
        fontWeight: AppTypography.regular,
        color: AppColors.textOnDark,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    ),

    // ===== Bottom Sheet Theme =====
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.lg),
        ),
      ),
    ),

    // ===== Progress Indicator Theme =====
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.borderLight,
      circularTrackColor: AppColors.borderLight,
    ),

    // ===== Switch Theme =====
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.borderDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }
        return AppColors.borderLight;
      }),
    ),

    // ===== Checkbox Theme =====
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.textOnDark),
      side: const BorderSide(color: AppColors.border, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.xs),
      ),
    ),

    // ===== Radio Theme =====
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.border;
      }),
    ),
  );
}
