# تصميم نظام الهوية البصرية الموحدة

**المشروع:** بصير MVP - نظام إدارة الفواتير والعملاء  
**التاريخ:** 6 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الإصدار:** 1.0  
**الحالة:** مسودة - قيد الإنشاء

---

## نظرة عامة (Overview)

### الهدف

تصميم وتطبيق نظام هوية بصرية موحد وشامل لمشروع بصير يحقق:

- **الاتساق البصري الكامل:** 100% التزام بمعايير الهوية عبر جميع المكونات
- **إمكانية الوصول الشاملة:** امتثال كامل لـ WCAG 2.1 Level AA
- **الأداء العالي:** ≥ 60 FPS مع استجابة < 100ms
- **القابلية للصيانة:** كود نظيف، موثق، وقابل للتوسع

### المبادئ التصميمية الأساسية والمتقدمة

#### المبادئ الأساسية (Core Principles)

```
الثقة (Trust) = الأزرق الداكن + التصميم المصرفي + الأمان البصري
الوضوح (Clarity) = التباين 4.5:1+ + المساحات البيضاء + التنظيم الهرمي
البساطة (Simplicity) = خط Cairo + الحد الأدنى من العناصر + التركيز على المحتوى

∴ بصير = الثقة + الوضوح + البساطة
```

#### المبادئ المتقدمة (Advanced Principles)

**1. الاتساق (Consistency)** - من Nielsen Norman Group

- **اتساق داخلي:** نفس العنصر يظهر بنفس الطريقة في كل مكان
- **اتساق خارجي:** توافق مع معايير المنصة (Material Design / iOS)
- **اتساق وظيفي:** نفس الإجراء ينتج نفس النتيجة دائماً
- **التطبيق:** جميع الأزرار الأساسية بنفس الارتفاع (48px)، نفس اللون، نفس الحركة

**2. القابلية للتنبؤ (Predictability)** - من Don Norman

- **توقع السلوك:** المستخدم يعرف ما سيحدث قبل التفاعل
- **ردود فعل متوقعة:** كل إجراء له نتيجة واضحة ومتوقعة
- **لا مفاجآت:** تجنب السلوكيات غير المتوقعة أو المربكة
- **التطبيق:** زر "حفظ" دائماً يحفظ، زر "إلغاء" دائماً يلغي

**3. التسلسل الهرمي البصري (Visual Hierarchy)** - من Gestalt Principles

- **الأهم أولاً:** العناصر الأكثر أهمية تكون أكبر وأوضح
- **التمييز بالحجم:** استخدام Type Scale للتمييز بين مستويات المعلومات
- **التمييز باللون:** الألوان الداكنة للمهم، الفاتحة للثانوي
- **التطبيق:** displayLarge (34px) للعناوين، bodyMedium (15px) للنصوص

**4. التغذية الراجعة (Feedback)** - من Material Design

- **رد فعل فوري:** كل إجراء له رد فعل خلال < 100ms
- **حالات واضحة:** loading (دوران)، success (✓ أخضر)، error (✗ أحمر)
- **Haptic feedback:** اهتزاز خفيف للإجراءات المهمة
- **التطبيق:** عند الضغط على زر: scale animation + haptic + تغيير لون

**5. التسامح مع الأخطاء (Error Tolerance)** - من Apple HIG

- **منع الأخطاء:** validation قبل الإرسال، تأكيد للإجراءات الخطرة
- **رسائل واضحة:** شرح المشكلة + الحل المقترح
- **سهولة التراجع:** زر "تراجع" واضح، إمكانية إلغاء الإجراءات
- **التطبيق:** "هل تريد حذف هذا العميل؟" مع زر "تراجع" واضح

**6. الكفاءة (Efficiency)** - من IBM Carbon

- **تقليل الخطوات:** الوصول للهدف بأقل عدد من النقرات
- **Shortcuts:** اختصارات للمستخدمين المتقدمين
- **الأداء:** استجابة < 100ms، تحميل < 1.5s
- **التطبيق:** FAB للإجراء الأكثر شيوعاً، swipe للحذف السريع

**7. إمكانية الوصول الشاملة (Inclusive Design)** - من Microsoft

- **التصميم للجميع:** دعم جميع القدرات من البداية
- **لا استبعاد:** screen readers، text scaling، high contrast
- **WCAG 2.1 AA:** تباين 4.5:1+، حجم 44x44px+، semantic labels
- **التطبيق:** كل أيقونة لها label، كل لون له بديل نصي

**8. السياق الثقافي (Cultural Context)** - للسوق العربي

- **احترام القيم:** ألوان وصور مناسبة ثقافياً
- **RTL كامل:** دعم كامل للعربية من اليمين لليسار
- **اللغة الواضحة:** عربية فصحى واضحة، لا عامية
- **التطبيق:** خط Cairo، أرقام هندية (123)، علامات ترقيم عربية (،؟)

**9. الاستدامة (Sustainability)** - من Green UX

- **تقليل الموارد:** const constructors، lazy loading، caching
- **الأداء:** 60 FPS = أقل استهلاك للبطارية
- **كود نظيف:** قابل للصيانة والتطوير على المدى الطويل
- **التطبيق:** استخدام const Text()، ListView.builder، image caching

**10. التدرج (Progressive Disclosure)** - من UX Best Practices

- **الأساسيات أولاً:** عرض المعلومات الأساسية فقط
- **إخفاء التعقيد:** الخيارات المتقدمة في قوائم منفصلة
- **تجنب الإرهاق:** لا تعرض كل شيء مرة واحدة
- **التطبيق:** نموذج إضافة عميل: الاسم والهاتف أولاً، التفاصيل في "المزيد"

#### معادلة التصميم الشاملة

```
تصميم بصير = (الثقة + الوضوح + البساطة) × الاتساق
              + القابلية للتنبؤ + التسلسل الهرمي
              + التغذية الراجعة + التسامح مع الأخطاء
              + الكفاءة + إمكانية الوصول
              + السياق الثقافي + الاستدامة + التدرج
```

### النهج التصميمي

**البناء على الموجود + التحسين + الإضافة**

- ✅ **الاستفادة من البنية الحالية:** Clean Architecture + Feature-First
- ✅ **تحسين المكونات الموجودة:** app_colors, app_text_styles, app_dimensions
- ✅ **إضافة مكونات جديدة:** Design Tokens, Theme Manager, Visual Testing
- ✅ **التكامل مع نظام الاختبارات:** 692 اختبار موجود + اختبارات بصرية جديدة

---

## البنية المعمارية (Architecture)

### التكامل مع البنية الحالية

```
lib/
├── core/
│   ├── theme/                          # ✅ موجود - سيتم تحسينه
│   │   ├── tokens/                     # ⭐ جديد - Design Tokens
│   │   │   ├── color_tokens.dart
│   │   │   ├── typography_tokens.dart
│   │   │   ├── spacing_tokens.dart
│   │   │   └── animation_tokens.dart
│   │   ├── app_colors.dart             # ✅ موجود - سيتم تحسينه
│   │   ├── app_text_styles.dart        # ✅ موجود - سيتم تحسينه
│   │   ├── app_dimensions.dart         # ✅ موجود - سيتم تحسينه
│   │   ├── app_animations.dart         # ✅ موجود
│   │   ├── app_theme.dart              # ⭐ جديد - Theme Manager
│   │   ├── theme_extensions.dart       # ⭐ جديد - Theme Extensions
│   │   └── accessibility/
│   │       ├── accessibility_checker.dart  # ✅ موجود
│   │       └── contrast_validator.dart     # ⭐ جديد
│   ├── widgets/                        # ✅ موجود - سيتم تحسينه
│   │   ├── app_button.dart             # ✅ موجود - سيتم تحسينه
│   │   ├── app_card.dart               # ✅ موجود - سيتم تحسينه
│   │   ├── app_text_field.dart         # ✅ موجود - سيتم تحسينه
│   │   ├── responsive_text.dart        # ✅ موجود
│   │   └── ...
│   └── design_system/                  # ⭐ جديد - نظام التصميم
│       ├── component_gallery.dart      # Storybook/Gallery
│       ├── design_tokens_viewer.dart   # عارض Design Tokens
│       └── contrast_tester.dart        # أداة اختبار التباين
└── test/
    ├── visual/                         # ⭐ جديد - اختبارات بصرية
    │   ├── golden/                     # Golden tests
    │   ├── snapshot/                   # Snapshot tests
    │   └── accessibility/              # اختبارات إمكانية الوصول
    └── brand_compliance/               # ⭐ جديد - اختبارات الالتزام
        ├── color_compliance_test.dart
        ├── typography_compliance_test.dart
        └── spacing_compliance_test.dart
```

### طبقات النظام

```
┌─────────────────────────────────────────────────────────────┐
│                    طبقة التطبيق (Application)                │
│  (Screens, Features, User Interactions)                     │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                  طبقة المكونات (Components)                  │
│  (AppButton, AppCard, AppTextField, ResponsiveText)         │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                  طبقة الثيمات (Theme Layer)                  │
│  (AppTheme, ThemeExtensions, ThemeManager)                  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              طبقة Design Tokens (Token Layer)               │
│  (ColorTokens, TypographyTokens, SpacingTokens)             │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│            طبقة القيم الأساسية (Primitive Values)            │
│  (Colors, Sizes, Weights, Spacing Values)                   │
└─────────────────────────────────────────────────────────────┘
```

---

## المكونات والواجهات (Components and Interfaces)

### 1. نظام Design Tokens

#### 1.1 ColorTokens

**الغرض:** تنظيم جميع الألوان كـ Design Tokens قابلة لإعادة الاستخدام

```dart
/// نظام Design Tokens للألوان
///
/// يوفر جميع الألوان المستخدمة في التطبيق كـ tokens ثابتة
/// مع ضمان التباين المناسب وفقاً لمعايير WCAG 2.1 Level AA
class ColorTokens {
  ColorTokens._();

  // ===== Primitive Colors (القيم الأساسية) =====

  /// الأزرق الداكن - اللون الأساسي
  static const Color blue900 = Color(0xFF0056B3);
  static const Color blue800 = Color(0xFF003D82);
  static const Color blue100 = Color(0xFFE3F2FD);

  /// الأخضر الداكن - اللون الثانوي
  static const Color green900 = Color(0xFF1E7E34);
  static const Color green800 = Color(0xFF155724);
  static const Color green100 = Color(0xFFE8F5E9);

  /// الأحمر الداكن - الأخطاء
  static const Color red900 = Color(0xFFC62828);
  static const Color red100 = Color(0xFFFFEBEE);

  /// الرمادي - النصوص والحدود
  static const Color gray900 = Color(0xFF000000);
  static const Color gray800 = Color(0xFF4A4A4A);
  static const Color gray600 = Color(0xFF616161);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray200 = Color(0xFFD1D5DB);
  static const Color gray100 = Color(0xFFF5F7FA);
  static const Color gray50 = Color(0xFFF8F9FA);

  /// الأبيض والأسود
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ===== Semantic Tokens (الألوان الدلالية) =====

  /// ألوان العلامة التجارية
  static const Color brandPrimary = blue900;
  static const Color brandSecondary = green900;

  /// ألوان الحالة
  static const Color statusSuccess = green900;
  static const Color statusError = red900;
  static const Color statusWarning = Color(0xFFBF360C);
  static const Color statusInfo = Color(0xFF0D47A1);

  /// ألوان النصوص
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray800;
  static const Color textHint = gray600;
  static const Color textDisabled = gray400;
  static const Color textOnDark = white;
  static const Color textOnPrimary = white;

  /// ألوان الخلفيات
  static const Color backgroundPrimary = gray100;
  static const Color backgroundSecondary = gray50;
  static const Color surfacePrimary = white;
  static const Color surfaceSecondary = gray50;

  /// ألوان الحدود
  static const Color borderPrimary = gray200;
  static const Color borderSecondary = gray400;
  static const Color borderFocus = Color(0xFF2196F3);

  /// ألوان التفاعل
  static const Color interactionHover = Color(0x0A000000);
  static const Color interactionPressed = Color(0x14000000);
  static const Color interactionFocus = Color(0x1F2196F3);
  static const Color interactionDisabled = Color(0x61000000);

  // ===== Context-Specific Tokens (ألوان سياقية) =====

  /// ألوان الأزرار
  static const Color buttonPrimaryBackground = brandPrimary;
  static const Color buttonPrimaryText = white;
  static const Color buttonSecondaryBackground = brandSecondary;
  static const Color buttonSecondaryText = white;
  static const Color buttonDangerBackground = statusError;
  static const Color buttonDangerText = white;

  /// ألوان البطاقات
  static const Color cardBackground = surfacePrimary;
  static const Color cardBorder = borderPrimary;
  static const Color cardShadow = Color(0x1A000000);

  /// ألوان حقول الإدخال
  static const Color inputBackground = surfacePrimary;
  static const Color inputBorder = borderPrimary;
  static const Color inputBorderFocus = borderFocus;
  static const Color inputBorderError = statusError;
  static const Color inputText = textPrimary;
  static const Color inputPlaceholder = textHint;
}
```

#### 1.2 TypographyTokens

**الغرض:** تنظيم جميع أنماط النصوص كـ Design Tokens

```dart
/// نظام Design Tokens للطباعة
///
/// يوفر جميع أنماط النصوص المستخدمة في التطبيق
/// مع التسلسل الهرمي الواضح والتحسين المعرفي للقراءة
class TypographyTokens {
  TypographyTokens._();

  // ===== Font Family =====
  static const String fontFamilyPrimary = 'Cairo';
  static const String fontFamilyFallback = 'Arial';

  // ===== Font Weights =====
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;

  // ===== Font Sizes =====
  static const double sizeDisplayLarge = 34.0;
  static const double sizeDisplayMedium = 28.0;
  static const double sizeDisplaySmall = 24.0;
  static const double sizeHeadlineLarge = 22.0;
  static const double sizeHeadlineMedium = 18.0;
  static const double sizeHeadlineSmall = 16.0;
  static const double sizeBodyLarge = 17.0;
  static const double sizeBodyMedium = 15.0;
  static const double sizeBodySmall = 13.0;
  static const double sizeLabelLarge = 15.0;
  static const double sizeLabelMedium = 13.0;
  static const double sizeLabelSmall = 12.0;

  // ===== Line Heights =====
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.3;

  // ===== Letter Spacing =====
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.25;
  static const double letterSpacingExtraWide = 0.5;

  // ===== Complete Text Styles (أنماط نصوص كاملة) =====

  /// Display Large - للعناوين الرئيسية الكبيرة
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeDisplayLarge,
    fontWeight: weightBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
  );

  /// Display Medium - للعناوين الرئيسية المتوسطة
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeDisplayMedium,
    fontWeight: weightBold,
    height: lineHeightTight,
    letterSpacing: -0.25,
  );

  /// Display Small - للعناوين الرئيسية الصغيرة
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeDisplaySmall,
    fontWeight: weightBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
  );

  /// Headline Large - لعناوين الأقسام الكبيرة
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeHeadlineLarge,
    fontWeight: weightSemiBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
  );

  /// Headline Medium - لعناوين البطاقات
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeHeadlineMedium,
    fontWeight: weightSemiBold,
    height: lineHeightTight,
    letterSpacing: 0.15,
  );

  /// Headline Small - للعناوين الصغيرة
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeHeadlineSmall,
    fontWeight: weightSemiBold,
    height: lineHeightTight,
    letterSpacing: 0.15,
  );

  /// Body Large - للنصوص الأساسية الكبيرة
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeBodyLarge,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingExtraWide,
  );

  /// Body Medium - للنصوص الأساسية (الافتراضي)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeBodyMedium,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
  );

  /// Body Small - للنصوص الثانوية
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeBodySmall,
    fontWeight: weightRegular,
    height: lineHeightNormal,
    letterSpacing: 0.4,
  );

  /// Label Large - لتسميات الأزرار الكبيرة
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeLabelLarge,
    fontWeight: weightMedium,
    height: lineHeightRelaxed,
    letterSpacing: 0.1,
  );

  /// Label Medium - للتسميات المتوسطة
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeLabelMedium,
    fontWeight: weightMedium,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingExtraWide,
  );

  /// Label Small - للتسميات الصغيرة
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: sizeLabelSmall,
    fontWeight: weightMedium,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingExtraWide,
  );
}
```

#### 1.3 SpacingTokens

**الغرض:** تنظيم جميع المسافات والأبعاد كـ Design Tokens

```dart
/// نظام Design Tokens للمسافات والأبعاد
///
/// يوفر نظام 8-point grid موحد لجميع المسافات والأبعاد
/// مع ضمان الاتساق الرياضي والتنظيم البصري
class SpacingTokens {
  SpacingTokens._();

  // ===== 8-Point Grid System =====

  /// المسافة الأساسية (4px) - نصف وحدة
  static const double unit0_5 = 4.0;

  /// المسافة الأساسية (8px) - وحدة واحدة
  static const double unit1 = 8.0;

  /// مسافة متوسطة (16px) - وحدتان
  static const double unit2 = 16.0;

  /// مسافة كبيرة (24px) - 3 وحدات
  static const double unit3 = 24.0;

  /// مسافة كبيرة جداً (32px) - 4 وحدات
  static const double unit4 = 32.0;

  /// مسافة كبيرة جداً جداً (48px) - 6 وحدات
  static const double unit6 = 48.0;

  // ===== Semantic Spacing (مسافات دلالية) =====

  /// مسافة صغيرة جداً
  static const double spacingXs = unit0_5;  // 4px

  /// مسافة صغيرة
  static const double spacingSm = unit1;    // 8px

  /// مسافة متوسطة (الافتراضي)
  static const double spacingMd = unit2;    // 16px

  /// مسافة كبيرة
  static const double spacingLg = unit3;    // 24px

  /// مسافة كبيرة جداً
  static const double spacingXl = unit4;    // 32px

  /// مسافة كبيرة جداً جداً
  static const double spacingXxl = unit6;   // 48px

  // ===== Border Radius =====

  /// نصف قطر صغير
  static const double radiusSm = 4.0;

  /// نصف قطر متوسط
  static const double radiusMd = 8.0;

  /// نصف قطر كبير (الافتراضي للمكونات)
  static const double radiusLg = 12.0;

  /// نصف قطر كبير جداً
  static const double radiusXl = 16.0;

  /// نصف قطر دائري كامل
  static const double radiusFull = 999.0;

  // ===== Elevation (الظلال) =====

  /// بدون ظل
  static const double elevationNone = 0.0;

  /// ظل صغير
  static const double elevationSm = 2.0;

  /// ظل متوسط
  static const double elevationMd = 4.0;

  /// ظل كبير
  static const double elevationLg = 8.0;

  /// ظل كبير جداً
  static const double elevationXl = 16.0;

  // ===== Component Sizes =====

  /// الحد الأدنى لمساحة اللمس (WCAG)
  static const double minTouchTarget = 48.0;

  /// الحد الأدنى لمساحة اللمس (iOS)
  static const double minTouchTargetIos = 44.0;

  /// ارتفاع زر صغير
  static const double buttonHeightSm = 32.0;

  /// ارتفاع زر متوسط
  static const double buttonHeightMd = 40.0;

  /// ارتفاع زر كبير (الافتراضي)
  static const double buttonHeightLg = 48.0;

  /// ارتفاع زر كبير جداً
  static const double buttonHeightXl = 56.0;

  /// ارتفاع حقل إدخال
  static const double inputHeight = 48.0;

  /// ارتفاع شريط التطبيق
  static const double appBarHeight = 56.0;

  /// ارتفاع شريط التنقل السفلي
  static const double bottomNavHeight = 56.0;

  // ===== Icon Sizes =====

  /// حجم أيقونة صغير جداً
  static const double iconXs = 18.0;

  /// حجم أيقونة صغير
  static const double iconSm = 22.0;

  /// حجم أيقونة متوسط (الافتراضي)
  static const double iconMd = 26.0;

  /// حجم أيقونة كبير
  static const double iconLg = 32.0;

  /// حجم أيقونة كبير جداً
  static const double iconXl = 40.0;

  /// حجم أيقونة كبير جداً جداً
  static const double iconXxl = 48.0;

  // ===== Container Widths =====

  /// عرض أقصى للمحتوى
  static const double maxContentWidth = 1200.0;

  /// عرض أقصى للنماذج
  static const double maxFormWidth = 600.0;

  /// عرض أقصى للبطاقات
  static const double maxCardWidth = 400.0;
}
```

#### 1.4 AnimationTokens

**الغرض:** تنظيم جميع الحركات والانتقالات كـ Design Tokens

```dart
/// نظام Design Tokens للحركات والانتقالات
///
/// يوفر جميع مدد الحركات ومنحنيات التسارع المستخدمة
/// مع ضمان الاتساق والسلاسة في جميع التفاعلات
class AnimationTokens {
  AnimationTokens._();

  // ===== Durations (المدد) =====

  /// مدة قصيرة جداً (100ms) - للتفاعلات الفورية
  static const Duration durationInstant = Duration(milliseconds: 100);

  /// مدة قصيرة (200ms) - للحركات السريعة
  static const Duration durationFast = Duration(milliseconds: 200);

  /// مدة متوسطة (300ms) - للحركات العادية (الافتراضي)
  static const Duration durationNormal = Duration(milliseconds: 300);

  /// مدة طويلة (500ms) - للحركات المعقدة
  static const Duration durationSlow = Duration(milliseconds: 500);

  // ===== Curves (منحنيات التسارع) =====

  /// منحنى قياسي - للحركات العادية
  static const Curve curveStandard = Curves.easeInOut;

  /// منحنى التسارع - للعناصر التي تدخل الشاشة
  static const Curve curveDecelerate = Curves.easeOut;

  /// منحنى التباطؤ - للعناصر التي تخرج من الشاشة
  static const Curve curveAccelerate = Curves.easeIn;

  /// منحنى حاد - للحركات السريعة
  static const Curve curveSharp = Curves.easeInOutCubic;

  // ===== Transition Types (أنواع الانتقالات) =====

  /// انتقال Fade - للظهور والاختفاء
  static const String transitionFade = 'fade';

  /// انتقال Slide - للانزلاق
  static const String transitionSlide = 'slide';

  /// انتقال Scale - للتكبير والتصغير
  static const String transitionScale = 'scale';

  /// انتقال مركب - Fade + Slide
  static const String transitionFadeSlide = 'fadeSlide';

  /// انتقال مركب - Fade + Scale
  static const String transitionFadeScale = 'fadeScale';
}
```

---

## 2. Theme Manager والتكامل (Theme Management & Integration)

### 2.1 AppTheme - مدير الثيمات الرئيسي

**الغرض:** توحيد جميع Design Tokens في ThemeData واحد

```dart
/// مدير الثيمات الرئيسي للتطبيق
///
/// يجمع جميع Design Tokens (ألوان، خطوط، مسافات) في ThemeData
/// موحد يمكن استخدامه في MaterialApp
class AppTheme {
  AppTheme._();

  /// الثيم الفاتح (الافتراضي)
  static ThemeData get lightTheme => ThemeData(
        // ===== الألوان =====
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: ColorTokens.brandPrimary,
          secondary: ColorTokens.brandSecondary,
          error: ColorTokens.statusError,
          surface: ColorTokens.surfacePrimary,
          background: ColorTokens.backgroundPrimary,
          onPrimary: ColorTokens.textOnPrimary,
          onSecondary: ColorTokens.textOnPrimary,
          onError: ColorTokens.textOnPrimary,
          onSurface: ColorTokens.textPrimary,
          onBackground: ColorTokens.textPrimary,
        ),

        // ===== الخطوط =====
        fontFamily: TypographyTokens.fontFamilyPrimary,
        textTheme: TextTheme(
          displayLarge: TypographyTokens.displayLarge,
          displayMedium: TypographyTokens.displayMedium,
          displaySmall: TypographyTokens.displaySmall,
          headlineLarge: TypographyTokens.headlineLarge,
          headlineMedium: TypographyTokens.headlineMedium,
          headlineSmall: TypographyTokens.headlineSmall,
          bodyLarge: TypographyTokens.bodyLarge,
          bodyMedium: TypographyTokens.bodyMedium,
          bodySmall: TypographyTokens.bodySmall,
          labelLarge: TypographyTokens.labelLarge,
          labelMedium: TypographyTokens.labelMedium,
          labelSmall: TypographyTokens.labelSmall,
        ),

        // ===== الأزرار =====
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(88, SpacingTokens.buttonHeightLg),
            padding: EdgeInsets.symmetric(
              horizontal: SpacingTokens.spacingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
            ),
            elevation: SpacingTokens.elevationNone,
          ),
        ),

        // ===== البطاقات =====
        cardTheme: CardTheme(
          elevation: SpacingTokens.elevationNone,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
            side: BorderSide(
              color: ColorTokens.borderPrimary,
              width: 1,
            ),
          ),
          margin: EdgeInsets.all(SpacingTokens.spacingSm),
        ),

        // ===== حقول الإدخال =====
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ColorTokens.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
            borderSide: BorderSide(color: ColorTokens.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
            borderSide: BorderSide(color: ColorTokens.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
            borderSide: BorderSide(
              color: ColorTokens.inputBorderFocus,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
            borderSide: BorderSide(color: ColorTokens.inputBorderError),
          ),
          contentPadding: EdgeInsets.all(SpacingTokens.spacingMd),
        ),

        // ===== AppBar =====
        appBarTheme: AppBarTheme(
          elevation: SpacingTokens.elevationNone,
          backgroundColor: ColorTokens.surfacePrimary,
          foregroundColor: ColorTokens.textPrimary,
          centerTitle: true,
          titleTextStyle: TypographyTokens.headlineMedium.copyWith(
            color: ColorTokens.textPrimary,
          ),
        ),
      );

  /// الثيم الداكن (مستقبلي)
  static ThemeData get darkTheme => lightTheme.copyWith(
        // سيتم تطبيقه في المستقبل
        brightness: Brightness.dark,
      );
}
```

### 2.2 ThemeExtensions - امتدادات مخصصة

**الغرض:** إضافة قيم مخصصة للثيم غير موجودة في ThemeData

```dart
/// امتدادات مخصصة للثيم
///
/// تضيف قيم إضافية للثيم مثل المسافات المخصصة،
/// الظلال، والألوان السياقية
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.spacing,
    required this.shadows,
    required this.contextColors,
  });

  final SpacingExtension spacing;
  final ShadowExtension shadows;
  final ContextColorsExtension contextColors;

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    SpacingExtension? spacing,
    ShadowExtension? shadows,
    ContextColorsExtension? contextColors,
  }) {
    return AppThemeExtension(
      spacing: spacing ?? this.spacing,
      shadows: shadows ?? this.shadows,
      contextColors: contextColors ?? this.contextColors,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      spacing: spacing.lerp(other.spacing, t),
      shadows: shadows.lerp(other.shadows, t),
      contextColors: contextColors.lerp(other.contextColors, t),
    );
  }
}
```

---

## 3. المكونات المحسّنة (Enhanced Components)

### 3.1 AppButton - الزر المحسّن

**التحسينات على المكون الموجود:**

```dart
/// زر محسّن مع دعم كامل للهوية البصرية
///
/// التحسينات:
/// - استخدام Design Tokens للألوان والمسافات
/// - دعم haptic feedback
/// - حركات سلسة (scale animation)
/// - ضمان حجم 48x48px (WCAG)
/// - دعم حالات متعددة (loading, disabled)
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    // الحصول على الألوان حسب النوع
    final colors = _getColors(type);

    // الحصول على الارتفاع حسب الحجم
    final height = _getHeight(size);

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : () {
          // Haptic feedback
          HapticFeedback.lightImpact();
          onPressed?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          disabledBackgroundColor: ColorTokens.interactionDisabled,
          elevation: SpacingTokens.elevationNone,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SpacingTokens.spacingMd,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: SpacingTokens.iconSm,
                height: SpacingTokens.iconSm,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(colors.foreground),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: SpacingTokens.iconSm),
                    SizedBox(width: SpacingTokens.spacingSm),
                  ],
                  Text(
                    text,
                    style: TypographyTokens.labelLarge,
                  ),
                ],
              ),
      ),
    );
  }

  _ButtonColors _getColors(AppButtonType type) {
    switch (type) {
      case AppButtonType.primary:
        return _ButtonColors(
          background: ColorTokens.buttonPrimaryBackground,
          foreground: ColorTokens.buttonPrimaryText,
        );
      case AppButtonType.secondary:
        return _ButtonColors(
          background: ColorTokens.buttonSecondaryBackground,
          foreground: ColorTokens.buttonSecondaryText,
        );
      case AppButtonType.danger:
        return _ButtonColors(
          background: ColorTokens.buttonDangerBackground,
          foreground: ColorTokens.buttonDangerText,
        );
    }
  }

  double _getHeight(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return SpacingTokens.buttonHeightSm;
      case AppButtonSize.medium:
        return SpacingTokens.buttonHeightMd;
      case AppButtonSize.large:
        return SpacingTokens.buttonHeightLg;
    }
  }
}

enum AppButtonType { primary, secondary, danger }
enum AppButtonSize { small, medium, large }

class _ButtonColors {
  final Color background;
  final Color foreground;
  _ButtonColors({required this.background, required this.foreground});
}
```

### 3.2 AppCard - البطاقة المحسّنة

**التحسينات على المكون الموجود:**

```dart
/// بطاقة محسّنة مع دعم كامل للهوية البصرية
///
/// التحسينات:
/// - استخدام Design Tokens للألوان والمسافات
/// - حركة hover سلسة
/// - ظل خفيف عند التفاعل
/// - دعم حالات متعددة (selected, disabled)
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.isSelected = false,
    this.showBorder = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool isSelected;
  final bool showBorder;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AnimationTokens.durationFast,
        curve: AnimationTokens.curveStandard,
        decoration: BoxDecoration(
          color: widget.isSelected
              ? ColorTokens.interactionFocus
              : ColorTokens.cardBackground,
          borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
          border: widget.showBorder
              ? Border.all(
                  color: widget.isSelected
                      ? ColorTokens.borderFocus
                      : ColorTokens.cardBorder,
                  width: widget.isSelected ? 2 : 1,
                )
              : null,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: ColorTokens.cardShadow,
                    blurRadius: SpacingTokens.elevationMd,
                    offset: Offset(0, SpacingTokens.elevationSm),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
            child: Padding(
              padding: widget.padding ??
                  EdgeInsets.all(SpacingTokens.spacingMd),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
```

### 3.3 AppTextField - حقل الإدخال المحسّن

**التحسينات على المكون الموجود:**

```dart
/// حقل إدخال محسّن مع دعم كامل للهوية البصرية
///
/// التحسينات:
/// - استخدام Design Tokens للألوان والمسافات
/// - validation مدمج
/// - حالات واضحة (normal, focus, error, disabled)
/// - دعم RTL كامل
/// - accessibility labels
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final int maxLines;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TypographyTokens.labelMedium.copyWith(
            color: ColorTokens.textSecondary,
          ),
        ),
        SizedBox(height: SpacingTokens.spacingXs),

        // TextField
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          maxLines: maxLines,
          onChanged: onChanged,
          textDirection: TextDirection.rtl,
          style: TypographyTokens.bodyMedium.copyWith(
            color: enabled
                ? ColorTokens.inputText
                : ColorTokens.textDisabled,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TypographyTokens.bodyMedium.copyWith(
              color: ColorTokens.inputPlaceholder,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: ColorTokens.textHint,
                    size: SpacingTokens.iconSm,
                  )
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled
                ? ColorTokens.inputBackground
                : ColorTokens.surfaceSecondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
              borderSide: BorderSide(color: ColorTokens.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
              borderSide: BorderSide(color: ColorTokens.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
              borderSide: BorderSide(
                color: ColorTokens.inputBorderFocus,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
              borderSide: BorderSide(color: ColorTokens.inputBorderError),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
              borderSide: BorderSide(
                color: ColorTokens.inputBorderError,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(SpacingTokens.spacingMd),
          ),
        ),
      ],
    );
  }
}
```

---

## 4. نظام التصميم التفاعلي (Interactive Design System)

### 4.1 ComponentGallery - معرض المكونات

**الغرض:** عرض جميع المكونات في gallery تفاعلي (Storybook)

```dart
/// معرض تفاعلي لجميع مكونات التطبيق
///
/// يعرض:
/// - جميع المكونات الأساسية
/// - جميع الحالات (default, hover, pressed, disabled, error)
/// - جميع الأحجام (small, medium, large)
/// - الكود القابل للنسخ
class ComponentGallery extends StatelessWidget {
  const ComponentGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معرض المكونات'),
      ),
      body: ListView(
        padding: EdgeInsets.all(SpacingTokens.spacingMd),
        children: [
          _buildSection(
            title: 'الأزرار (Buttons)',
            children: [
              _buildButtonExamples(),
            ],
          ),
          _buildSection(
            title: 'البطاقات (Cards)',
            children: [
              _buildCardExamples(),
            ],
          ),
          _buildSection(
            title: 'حقول الإدخال (Text Fields)',
            children: [
              _buildTextFieldExamples(),
            ],
          ),
          _buildSection(
            title: 'الألوان (Colors)',
            children: [
              _buildColorExamples(),
            ],
          ),
          _buildSection(
            title: 'الخطوط (Typography)',
            children: [
              _buildTypographyExamples(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TypographyTokens.headlineMedium,
        ),
        SizedBox(height: SpacingTokens.spacingMd),
        ...children,
        SizedBox(height: SpacingTokens.spacingXl),
      ],
    );
  }

  Widget _buildButtonExamples() {
    return Wrap(
      spacing: SpacingTokens.spacingSm,
      runSpacing: SpacingTokens.spacingSm,
      children: [
        // Primary Button
        AppButton(
          text: 'زر أساسي',
          onPressed: () {},
          type: AppButtonType.primary,
        ),
        // Secondary Button
        AppButton(
          text: 'زر ثانوي',
          onPressed: () {},
          type: AppButtonType.secondary,
        ),
        // Danger Button
        AppButton(
          text: 'زر خطر',
          onPressed: () {},
          type: AppButtonType.danger,
        ),
        // Loading Button
        AppButton(
          text: 'جاري التحميل',
          onPressed: () {},
          isLoading: true,
        ),
        // Disabled Button
        const AppButton(
          text: 'زر معطل',
          onPressed: null,
        ),
      ],
    );
  }

  Widget _buildCardExamples() {
    return Column(
      children: [
        AppCard(
          child: Text(
            'بطاقة عادية',
            style: TypographyTokens.bodyMedium,
          ),
        ),
        AppCard(
          isSelected: true,
          child: Text(
            'بطاقة محددة',
            style: TypographyTokens.bodyMedium,
          ),
        ),
        AppCard(
          onTap: () {},
          child: Text(
            'بطاقة قابلة للنقر',
            style: TypographyTokens.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldExamples() {
    return Column(
      children: [
        AppTextField(
          label: 'الاسم',
          hint: 'أدخل اسمك',
        ),
        SizedBox(height: SpacingTokens.spacingMd),
        AppTextField(
          label: 'البريد الإلكتروني',
          hint: 'example@email.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
        ),
        SizedBox(height: SpacingTokens.spacingMd),
        AppTextField(
          label: 'كلمة المرور',
          hint: 'أدخل كلمة المرور',
          obscureText: true,
          prefixIcon: Icons.lock_outlined,
        ),
      ],
    );
  }

  Widget _buildColorExamples() {
    return Wrap(
      spacing: SpacingTokens.spacingSm,
      runSpacing: SpacingTokens.spacingSm,
      children: [
        _buildColorSwatch('Primary', ColorTokens.brandPrimary),
        _buildColorSwatch('Secondary', ColorTokens.brandSecondary),
        _buildColorSwatch('Success', ColorTokens.statusSuccess),
        _buildColorSwatch('Error', ColorTokens.statusError),
        _buildColorSwatch('Warning', ColorTokens.statusWarning),
        _buildColorSwatch('Info', ColorTokens.statusInfo),
      ],
    );
  }

  Widget _buildColorSwatch(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(SpacingTokens.radiusMd),
            border: Border.all(color: ColorTokens.borderPrimary),
          ),
        ),
        SizedBox(height: SpacingTokens.spacingXs),
        Text(
          name,
          style: TypographyTokens.labelSmall,
        ),
      ],
    );
  }

  Widget _buildTypographyExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Large', style: TypographyTokens.displayLarge),
        Text('Display Medium', style: TypographyTokens.displayMedium),
        Text('Display Small', style: TypographyTokens.displaySmall),
        Text('Headline Large', style: TypographyTokens.headlineLarge),
        Text('Headline Medium', style: TypographyTokens.headlineMedium),
        Text('Headline Small', style: TypographyTokens.headlineSmall),
        Text('Body Large', style: TypographyTokens.bodyLarge),
        Text('Body Medium', style: TypographyTokens.bodyMedium),
        Text('Body Small', style: TypographyTokens.bodySmall),
        Text('Label Large', style: TypographyTokens.labelLarge),
        Text('Label Medium', style: TypographyTokens.labelMedium),
        Text('Label Small', style: TypographyTokens.labelSmall),
      ],
    );
  }
}
```

### 4.2 DesignTokensViewer - عارض Design Tokens

**الغرض:** عرض جميع Design Tokens مع معلومات تفصيلية

```dart
/// عارض تفاعلي لجميع Design Tokens
///
/// يعرض:
/// - جميع الألوان مع hex codes والتباين
/// - جميع أحجام الخطوط مع أمثلة حية
/// - جميع المسافات مع visualizations
class DesignTokensViewer extends StatelessWidget {
  const DesignTokensViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Design Tokens'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'الألوان'),
              Tab(text: 'الخطوط'),
              Tab(text: 'المسافات'),
              Tab(text: 'الحركات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ColorTokensTab(),
            _TypographyTokensTab(),
            _SpacingTokensTab(),
            _AnimationTokensTab(),
          ],
        ),
      ),
    );
  }
}

class _ColorTokensTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(SpacingTokens.spacingMd),
      children: [
        _buildColorSection('ألوان العلامة التجارية', [
          _ColorToken('Primary', ColorTokens.brandPrimary),
          _ColorToken('Secondary', ColorTokens.brandSecondary),
        ]),
        _buildColorSection('ألوان الحالة', [
          _ColorToken('Success', ColorTokens.statusSuccess),
          _ColorToken('Error', ColorTokens.statusError),
          _ColorToken('Warning', ColorTokens.statusWarning),
          _ColorToken('Info', ColorTokens.statusInfo),
        ]),
        _buildColorSection('ألوان النصوص', [
          _ColorToken('Primary', ColorTokens.textPrimary),
          _ColorToken('Secondary', ColorTokens.textSecondary),
          _ColorToken('Hint', ColorTokens.textHint),
          _ColorToken('Disabled', ColorTokens.textDisabled),
        ]),
      ],
    );
  }

  Widget _buildColorSection(String title, List<_ColorToken> tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TypographyTokens.headlineMedium),
        SizedBox(height: SpacingTokens.spacingMd),
        ...tokens.map((token) => _buildColorCard(token)),
        SizedBox(height: SpacingTokens.spacingLg),
      ],
    );
  }

  Widget _buildColorCard(_ColorToken token) {
    final hexCode = '#${token.color.value.toRadixString(16).substring(2).toUpperCase()}';
    final contrastRatio = _calculateContrast(token.color, ColorTokens.white);

    return AppCard(
      child: Row(
        children: [
          // Color Swatch
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: token.color,
              borderRadius: BorderRadius.circular(SpacingTokens.radiusMd),
              border: Border.all(color: ColorTokens.borderPrimary),
            ),
          ),
          SizedBox(width: SpacingTokens.spacingMd),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token.name,
                  style: TypographyTokens.labelLarge,
                ),
                Text(
                  hexCode,
                  style: TypographyTokens.bodySmall.copyWith(
                    color: ColorTokens.textSecondary,
                  ),
                ),
                Text(
                  'التباين: ${contrastRatio.toStringAsFixed(2)}:1',
                  style: TypographyTokens.bodySmall.copyWith(
                    color: contrastRatio >= 4.5
                        ? ColorTokens.statusSuccess
                        : ColorTokens.statusError,
                  ),
                ),
              ],
            ),
          ),

          // Copy Button
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: hexCode));
            },
          ),
        ],
      ),
    );
  }

  double _calculateContrast(Color foreground, Color background) {
    // حساب التباين وفق معادلة WCAG
    final l1 = _relativeLuminance(foreground);
    final l2 = _relativeLuminance(background);
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  double _relativeLuminance(Color color) {
    final r = _linearize(color.red / 255);
    final g = _linearize(color.green / 255);
    final b = _linearize(color.blue / 255);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  double _linearize(double channel) {
    return channel <= 0.03928
        ? channel / 12.92
        : pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }
}

class _ColorToken {
  final String name;
  final Color color;
  _ColorToken(this.name, this.color);
}
```

### 4.3 ContrastTester - أداة اختبار التباين

**الغرض:** أداة تفاعلية لاختبار التباين بين الألوان

```dart
/// أداة تفاعلية لاختبار التباين بين لونين
///
/// الميزات:
/// - Color picker لاختيار الألوان
/// - حساب تلقائي للتباين
/// - تقييم WCAG (AA، AAA)
/// - اقتراحات لتحسين التباين
class ContrastTester extends StatefulWidget {
  const ContrastTester({super.key});

  @override
  State<ContrastTester> createState() => _ContrastTesterState();
}

class _ContrastTesterState extends State<ContrastTester> {
  Color _foreground = ColorTokens.textPrimary;
  Color _background = ColorTokens.surfacePrimary;

  @override
  Widget build(BuildContext context) {
    final contrastRatio = _calculateContrast(_foreground, _background);
    final passesAA = contrastRatio >= 4.5;
    final passesAAA = contrastRatio >= 7.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار التباين'),
      ),
      body: ListView(
        padding: EdgeInsets.all(SpacingTokens.spacingMd),
        children: [
          // Preview
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: _background,
              borderRadius: BorderRadius.circular(SpacingTokens.radiusLg),
              border: Border.all(color: ColorTokens.borderPrimary),
            ),
            child: Center(
              child: Text(
                'نص تجريبي',
                style: TypographyTokens.displayMedium.copyWith(
                  color: _foreground,
                ),
              ),
            ),
          ),
          SizedBox(height: SpacingTokens.spacingLg),

          // Contrast Ratio
          AppCard(
            child: Column(
              children: [
                Text(
                  'نسبة التباين',
                  style: TypographyTokens.labelMedium,
                ),
                Text(
                  '${contrastRatio.toStringAsFixed(2)}:1',
                  style: TypographyTokens.displayLarge.copyWith(
                    color: passesAA
                        ? ColorTokens.statusSuccess
                        : ColorTokens.statusError,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SpacingTokens.spacingMd),

          // WCAG Compliance
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'امتثال WCAG',
                  style: TypographyTokens.headlineSmall,
                ),
                SizedBox(height: SpacingTokens.spacingSm),
                _buildComplianceRow('AA (نص عادي)', passesAA),
                _buildComplianceRow('AAA (نص عادي)', passesAAA),
                _buildComplianceRow('AA (نص كبير)', contrastRatio >= 3.0),
                _buildComplianceRow('AAA (نص كبير)', contrastRatio >= 4.5),
              ],
            ),
          ),
          SizedBox(height: SpacingTokens.spacingMd),

          // Color Pickers
          AppCard(
            child: Column(
              children: [
                _buildColorPicker(
                  'لون المقدمة',
                  _foreground,
                  (color) => setState(() => _foreground = color),
                ),
                SizedBox(height: SpacingTokens.spacingMd),
                _buildColorPicker(
                  'لون الخلفية',
                  _background,
                  (color) => setState(() => _background = color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceRow(String label, bool passes) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SpacingTokens.spacingXs),
      child: Row(
        children: [
          Icon(
            passes ? Icons.check_circle : Icons.cancel,
            color: passes ? ColorTokens.statusSuccess : ColorTokens.statusError,
            size: SpacingTokens.iconSm,
          ),
          SizedBox(width: SpacingTokens.spacingSm),
          Text(
            label,
            style: TypographyTokens.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(
    String label,
    Color color,
    ValueChanged<Color> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TypographyTokens.labelMedium),
        SizedBox(height: SpacingTokens.spacingXs),
        GestureDetector(
          onTap: () => _showColorPicker(color, onChanged),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(SpacingTokens.radiusMd),
              border: Border.all(color: ColorTokens.borderPrimary),
            ),
          ),
        ),
      ],
    );
  }

  void _showColorPicker(Color current, ValueChanged<Color> onChanged) {
    // تطبيق color picker
    // يمكن استخدام مكتبة flutter_colorpicker
  }

  double _calculateContrast(Color foreground, Color background) {
    // نفس الدالة من _ColorTokensTab
    final l1 = _relativeLuminance(foreground);
    final l2 = _relativeLuminance(background);
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  double _relativeLuminance(Color color) {
    final r = _linearize(color.red / 255);
    final g = _linearize(color.green / 255);
    final b = _linearize(color.blue / 255);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  double _linearize(double channel) {
    return channel <= 0.03928
        ? channel / 12.92
        : pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }
}
```

---

## 5. استراتيجية الاختبار (Testing Strategy)

### 5.1 اختبارات الالتزام بالهوية البصرية

**الغرض:** التحقق من الالتزام بمعايير الهوية البصرية

```dart
/// اختبارات الالتزام بالألوان
///
/// تتحقق من:
/// - استخدام ألوان من ColorTokens فقط
/// - تباين الألوان يلبي WCAG AA
/// - عدم وجود ألوان hardcoded
void main() {
  group('Color Compliance Tests', () {
    test('all colors should have minimum contrast ratio', () {
      // اختبار تباين النصوص الأساسية
      final textPrimaryContrast = _calculateContrast(
        ColorTokens.textPrimary,
        ColorTokens.surfacePrimary,
      );
      expect(textPrimaryContrast, greaterThanOrEqualTo(4.5));

      // اختبار تباين النصوص الثانوية
      final textSecondaryContrast = _calculateContrast(
        ColorTokens.textSecondary,
        ColorTokens.surfacePrimary,
      );
      expect(textSecondaryContrast, greaterThanOrEqualTo(4.5));

      // اختبار تباين الأزرار
      final buttonContrast = _calculateContrast(
        ColorTokens.buttonPrimaryText,
        ColorTokens.buttonPrimaryBackground,
      );
      expect(buttonContrast, greaterThanOrEqualTo(4.5));
    });

    test('no hardcoded colors should exist', () {
      // هذا الاختبار يتطلب تحليل static للكود
      // يمكن تطبيقه كـ custom lint rule
    });
  });

  group('Typography Compliance Tests', () {
    test('all text styles should use Cairo font', () {
      expect(TypographyTokens.displayLarge.fontFamily, 'Cairo');
      expect(TypographyTokens.bodyMedium.fontFamily, 'Cairo');
      expect(TypographyTokens.labelSmall.fontFamily, 'Cairo');
    });

    test('all text styles should have proper line height', () {
      // العناوين يجب أن تكون 1.2
      expect(TypographyTokens.displayLarge.height, 1.2);
      expect(TypographyTokens.headlineLarge.height, 1.2);

      // النصوص الأساسية يجب أن تكون 1.5
      expect(TypographyTokens.bodyMedium.height, 1.5);
      expect(TypographyTokens.bodySmall.height, 1.5);
    });
  });

  group('Spacing Compliance Tests', () {
    test('all spacing values should be multiples of 4', () {
      expect(SpacingTokens.spacingXs % 4, 0);
      expect(SpacingTokens.spacingSm % 4, 0);
      expect(SpacingTokens.spacingMd % 4, 0);
      expect(SpacingTokens.spacingLg % 4, 0);
    });

    test('button height should meet minimum touch target', () {
      expect(SpacingTokens.buttonHeightLg, greaterThanOrEqualTo(44));
      expect(SpacingTokens.minTouchTarget, greaterThanOrEqualTo(44));
    });
  });
}
```

### 5.2 اختبارات بصرية (Visual Regression Tests)

**الغرض:** اكتشاف أي تغيير غير مقصود في الواجهة

```dart
/// اختبارات Golden للمكونات
///
/// تلتقط snapshots بصرية وتقارنها مع المرجع
void main() {
  group('AppButton Golden Tests', () {
    testWidgets('primary button should match golden', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: AppButton(
                text: 'زر أساسي',
                onPressed: () {},
                type: AppButtonType.primary,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_primary.png'),
      );
    });

    testWidgets('disabled button should match golden', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: AppButton(
                text: 'زر معطل',
                onPressed: null,
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_disabled.png'),
      );
    });
  });

  group('AppCard Golden Tests', () {
    testWidgets('normal card should match golden', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: AppCard(
                child: Text('بطاقة عادية'),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(AppCard),
        matchesGoldenFile('goldens/app_card_normal.png'),
      );
    });
  });
}
```

### 5.3 اختبارات إمكانية الوصول (Accessibility Tests)

**الغرض:** التحقق من امتثال WCAG 2.1 Level AA

```dart
/// اختبارات إمكانية الوصول
void main() {
  group('Accessibility Tests', () {
    testWidgets('all interactive elements should have semantic labels',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'حفظ',
              onPressed: () {},
            ),
          ),
        ),
      );

      // التحقق من وجود semantic label
      final semantics = tester.getSemantics(find.byType(AppButton));
      expect(semantics.label, isNotEmpty);
    });

    testWidgets('all interactive elements should meet minimum size',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'حفظ',
              onPressed: () {},
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(AppButton));
      expect(size.height, greaterThanOrEqualTo(44));
    });

    testWidgets('text should scale properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaleFactor: 2.0),
            child: Scaffold(
              body: ResponsiveText('نص تجريبي'),
            ),
          ),
        ),
      );

      // التحقق من عدم وجود overflow
      expect(tester.takeException(), isNull);
    });
  });
}
```

### 5.4 اختبارات الأداء (Performance Tests)

**الغرض:** التحقق من تحقيق معايير الأداء

```dart
/// اختبارات الأداء
void main() {
  group('Performance Tests', () {
    testWidgets('button animation should maintain 60 FPS', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'اضغط',
              onPressed: () {},
            ),
          ),
        ),
      );

      // قياس الأداء أثناء الحركة
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      // التحقق من عدم وجود jank
      final binding = tester.binding as WidgetsFlutterBinding;
      expect(binding.hasScheduledFrame, isFalse);
    });

    test('color tokens should be const', () {
      // التحقق من أن جميع الألوان const
      expect(identical(ColorTokens.brandPrimary, ColorTokens.brandPrimary),
          isTrue);
    });
  });
}
```

---

## 6. معالجة الأخطاء والتحقق (Error Handling & Validation)

### 6.1 ContrastValidator - التحقق من التباين

```dart
/// أداة للتحقق من تباين الألوان
class ContrastValidator {
  /// يتحقق من تباين لونين
  ///
  /// Returns: true إذا كان التباين مقبول
  static bool validate({
    required Color foreground,
    required Color background,
    required double minRatio,
  }) {
    final ratio = calculateContrastRatio(foreground, background);
    return ratio >= minRatio;
  }

  /// يحسب نسبة التباين بين لونين
  static double calculateContrastRatio(
    Color foreground,
    Color background,
  ) {
    final l1 = _relativeLuminance(foreground);
    final l2 = _relativeLuminance(background);
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  static double _relativeLuminance(Color color) {
    final r = _linearize(color.red / 255);
    final g = _linearize(color.green / 255);
    final b = _linearize(color.blue / 255);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _linearize(double channel) {
    return channel <= 0.03928
        ? channel / 12.92
        : pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }

  /// يقترح لون بديل لتحسين التباين
  static Color suggestBetterColor({
    required Color original,
    required Color background,
    required double targetRatio,
  }) {
    // خوارزمية لاقتراح لون بديل
    // يمكن تطبيقها بتعديل HSL values
    return original;
  }
}
```

### 6.2 DesignTokenValidator - التحقق من Design Tokens

```dart
/// أداة للتحقق من صحة Design Tokens
class DesignTokenValidator {
  /// يتحقق من أن جميع المسافات مضاعفات 4
  static bool validateSpacing(double value) {
    return value % 4 == 0;
  }

  /// يتحقق من أن حجم العنصر يلبي الحد الأدنى
  static bool validateTouchTarget(Size size) {
    return size.width >= 44 && size.height >= 44;
  }

  /// يتحقق من أن الخط المستخدم هو Cairo
  static bool validateFont(String? fontFamily) {
    return fontFamily == TypographyTokens.fontFamilyPrimary;
  }

  /// يولد تقرير شامل بالمخالفات
  static ValidationReport generateReport(BuildContext context) {
    final violations = <String>[];

    // فحص الألوان
    // فحص الخطوط
    // فحص المسافات

    return ValidationReport(violations: violations);
  }
}

class ValidationReport {
  final List<String> violations;
  ValidationReport({required this.violations});

  bool get isValid => violations.isEmpty;
  int get violationCount => violations.length;
}
```

---

## 7. خطة التطبيق (Implementation Plan)

### 7.1 المرحلة 1: الأساسيات (أسبوع 1-2)

**الأهداف:**

- إنشاء Design Tokens الأساسية
- تحديث المكونات الموجودة
- إنشاء AppTheme

**المهام:**

1. **إنشاء Design Tokens** (3 أيام)

   - `lib/core/theme/tokens/color_tokens.dart`
   - `lib/core/theme/tokens/typography_tokens.dart`
   - `lib/core/theme/tokens/spacing_tokens.dart`
   - `lib/core/theme/tokens/animation_tokens.dart`

2. **تحديث AppColors** (1 يوم)

   - دمج ColorTokens مع AppColors الموجود
   - إضافة دوال التحقق من التباين
   - تحديث جميع الاستخدامات

3. **تحديث AppTextStyles** (1 يوم)

   - دمج TypographyTokens مع AppTextStyles
   - تطبيق Type Scale الكامل
   - تحديث جميع الاستخدامات

4. **تحديث AppDimensions** (1 يوم)

   - دمج SpacingTokens مع AppDimensions
   - تطبيق 8-point grid
   - تحديث جميع الاستخدامات

5. **إنشاء AppTheme** (2 أيام)
   - `lib/core/theme/app_theme.dart`
   - دمج جميع Tokens في ThemeData
   - اختبار التكامل

**المخرجات:**

- ✅ Design Tokens كاملة
- ✅ AppTheme موحد
- ✅ جميع المكونات الموجودة محدثة

### 7.2 المرحلة 2: المكونات المحسّنة (أسبوع 3-4)

**الأهداف:**

- تحسين المكونات الموجودة
- إضافة ميزات جديدة
- ضمان الالتزام بالمعايير

**المهام:**

1. **تحسين AppButton** (2 أيام)

   - إضافة haptic feedback
   - إضافة scale animation
   - إضافة حالة loading
   - اختبارات شاملة

2. **تحسين AppCard** (2 أيام)

   - إضافة hover effect
   - إضافة حالة selected
   - تحسين الظلال
   - اختبارات شاملة

3. **تحسين AppTextField** (2 أيام)

   - تحسين validation
   - إضافة حالات واضحة
   - تحسين RTL support
   - اختبارات شاملة

4. **تحسين ResponsiveText** (1 يوم)
   - تحسين text scaling
   - منع overflow
   - اختبارات شاملة

**المخرجات:**

- ✅ مكونات محسّنة بالكامل
- ✅ اختبارات شاملة (70%+ coverage)
- ✅ توثيق كامل

### 7.3 المرحلة 3: نظام التصميم التفاعلي (أسبوع 5-6)

**الأهداف:**

- إنشاء Component Gallery
- إنشاء Design Tokens Viewer
- إنشاء Contrast Tester

**المهام:**

1. **ComponentGallery** (3 أيام)

   - عرض جميع المكونات
   - عرض جميع الحالات
   - كود قابل للنسخ
   - navigation سهل

2. **DesignTokensViewer** (2 أيام)

   - عرض جميع الألوان
   - عرض جميع الخطوط
   - عرض جميع المسافات
   - معلومات تفصيلية

3. **ContrastTester** (2 أيام)
   - color picker تفاعلي
   - حساب تلقائي للتباين
   - تقييم WCAG
   - اقتراحات تحسين

**المخرجات:**

- ✅ نظام تصميم تفاعلي كامل
- ✅ أدوات مساعدة للمطورين
- ✅ توثيق حي

### 7.4 المرحلة 4: الاختبارات والجودة (أسبوع 7-8)

**الأهداف:**

- إنشاء اختبارات شاملة
- ضمان الالتزام بالمعايير
- تحسين الأداء

**المهام:**

1. **اختبارات الالتزام** (2 أيام)

   - color compliance tests
   - typography compliance tests
   - spacing compliance tests
   - accessibility tests

2. **اختبارات بصرية** (2 أيام)

   - golden tests لجميع المكونات
   - snapshot tests
   - visual regression tests

3. **اختبارات الأداء** (2 أيام)

   - performance profiling
   - optimization
   - benchmarking

4. **التوثيق النهائي** (2 أيام)
   - تحديث README
   - إنشاء دليل استخدام
   - إنشاء أمثلة

**المخرجات:**

- ✅ تغطية اختبارات 70%+
- ✅ أداء 60 FPS+
- ✅ توثيق شامل 95%+

---

## 8. المخاطر والتخفيف (Risks & Mitigation)

### 8.1 المخاطر التقنية

| الخطر                      | الاحتمالية | التأثير | التخفيف                                                                  |
| :------------------------- | :--------: | :-----: | :----------------------------------------------------------------------- |
| **صعوبة تحقيق 60 FPS**     |   متوسطة   |  عالي   | - استخدام const constructors<br>- profiling مستمر<br>- optimization مبكر |
| **مشاكل RTL**              |   منخفضة   |  متوسط  | - اختبارات RTL شاملة<br>- استخدام TextDirection.rtl<br>- مراجعة يدوية    |
| **تعارض مع الكود الموجود** |   متوسطة   |  متوسط  | - migration تدريجي<br>- backward compatibility<br>- deprecation warnings |

### 8.2 مخاطر الجودة

| الخطر                      | الاحتمالية | التأثير | التخفيف                                                       |
| :------------------------- | :--------: | :-----: | :------------------------------------------------------------ |
| **عدم الالتزام بالمعايير** |   متوسطة   |  عالي   | - lint rules صارمة<br>- اختبارات آلية<br>- code review إلزامي |
| **تغطية اختبارات منخفضة**  |   منخفضة   |  عالي   | - هدف 70%+ إلزامي<br>- CI/CD checks<br>- مراجعة دورية         |
| **توثيق ناقص**             |   منخفضة   |  متوسط  | - هدف 95%+ إلزامي<br>- DartDoc لكل API<br>- أمثلة حية         |

### 8.3 مخاطر الجدول الزمني

| الخطر               | الاحتمالية | التأثير | التخفيف                                                           |
| :------------------ | :--------: | :-----: | :---------------------------------------------------------------- |
| **تأخر في التطبيق** |   منخفضة   |  متوسط  | - تقسيم إلى مراحل<br>- أولويات واضحة<br>- مراجعة أسبوعية          |
| **scope creep**     |   متوسطة   |  متوسط  | - التزام بالمتطلبات<br>- change control<br>- موافقة على التغييرات |

---

## 9. مقاييس النجاح (Success Metrics)

### 9.1 مقاييس تقنية

| المقياس                    |  الهدف  | طريقة القياس            |
| :------------------------- | :-----: | :---------------------- |
| **Brand Compliance**       |  100%   | اختبارات آلية           |
| **WCAG AA Compliance**     |  100%   | أدوات فحص التباين       |
| **Test Coverage**          |  ≥ 70%  | flutter test --coverage |
| **Performance (FPS)**      |  ≥ 60   | Flutter DevTools        |
| **Response Time**          | < 100ms | قياس يدوي               |
| **Documentation Coverage** |  ≥ 95%  | مراجعة يدوية            |

### 9.2 مقاييس الجودة

| المقياس              | الهدف |     الحالة     |
| :------------------- | :---: | :------------: |
| **Linting Errors**   |   0   | 🔄 قيد التطبيق |
| **Linting Warnings** |   0   | 🔄 قيد التطبيق |
| **Code Smells**      |   0   | 🔄 قيد التطبيق |
| **Technical Debt**   | < 5%  | 🔄 قيد القياس  |

### 9.3 مقاييس تجربة المطور

| المقياس                    |   الهدف   | طريقة القياس          |
| :------------------------- | :-------: | :-------------------- |
| **Time to Add Component**  | < 4 ساعات | تتبع development time |
| **Learning Curve**         | < 5 دقائق | user testing للمطورين |
| **Developer Satisfaction** |   ≥ 4/5   | استبيانات داخلية      |

---

## 10. الخلاصة والخطوات التالية

### 10.1 ملخص التصميم

تم تصميم نظام هوية بصرية موحد وشامل لمشروع بصير يحقق:

✅ **الاتساق الكامل:** Design Tokens موحدة لجميع الألوان، الخطوط، والمسافات  
✅ **إمكانية الوصول:** امتثال 100% لـ WCAG 2.1 Level AA  
✅ **الأداء العالي:** 60 FPS مع استجابة < 100ms  
✅ **القابلية للصيانة:** كود نظيف، موثق، وقابل للتوسع  
✅ **التكامل السلس:** بناء على البنية الموجودة مع تحسينات شاملة

### 10.2 المكونات الرئيسية

**Design Tokens:**

- ColorTokens (3 مستويات: Primitive → Semantic → Context-Specific)
- TypographyTokens (12 نمط نص مع Type Scale كامل)
- SpacingTokens (8-point grid system)
- AnimationTokens (مدد ومنحنيات موحدة)

**Theme Management:**

- AppTheme (ThemeData موحد)
- ThemeExtensions (قيم مخصصة)

**Enhanced Components:**

- AppButton (محسّن مع haptic feedback وحركات)
- AppCard (محسّن مع hover effects)
- AppTextField (محسّن مع validation)

**Interactive Design System:**

- ComponentGallery (Storybook للمكونات)
- DesignTokensViewer (عارض Tokens)
- ContrastTester (أداة اختبار التباين)

**Testing Strategy:**

- Compliance Tests (الالتزام بالمعايير)
- Visual Regression Tests (Golden tests)
- Accessibility Tests (WCAG compliance)
- Performance Tests (60 FPS)

### 10.3 الخطوات التالية

1. **مراجعة التصميم** (1-2 أيام)

   - مراجعة شاملة من الفريق
   - تعديلات إن لزم الأمر
   - الموافقة النهائية

2. **إنشاء tasks.md** (1 يوم)

   - تقسيم التصميم إلى مهام
   - تحديد الأولويات
   - تقدير الوقت

3. **البدء بالتطبيق** (8 أسابيع)
   - المرحلة 1: الأساسيات
   - المرحلة 2: المكونات المحسّنة
   - المرحلة 3: نظام التصميم التفاعلي
   - المرحلة 4: الاختبارات والجودة

### 10.4 التوقعات

**بعد التطبيق الكامل:**

- ✅ نظام هوية بصرية موحد 100%
- ✅ امتثال WCAG 2.1 Level AA كامل
- ✅ أداء 60 FPS+ على جميع الأجهزة
- ✅ تغطية اختبارات 70%+
- ✅ توثيق شامل 95%+
- ✅ رضا المطورين 4/5+

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 6 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ مكتمل - جاهز للمراجعة

---

## ملحق: المراجع والموارد

### معايير ومواصفات

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Material Design 3](https://m3.material.io/)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)

### Design Systems الرائدة

- [Material Design System](https://m3.material.io/styles)
- [IBM Carbon Design System](https://carbondesignsystem.com/)
- [Atlassian Design System](https://atlassian.design/)
- [Shopify Polaris](https://polaris.shopify.com/)

### أبحاث ومقالات

- "Design Tokens: The Future of Design Systems" - Nathan Curtis
- "The Psychology of Color in UI Design" - Nielsen Norman Group
- "Typography in UI Design" - Material Design
- "8-Point Grid System" - Spec.fm

### أدوات وموارد

- [Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Color Blind Simulator](https://www.color-blindness.com/coblis-color-blindness-simulator/)
- [Flutter DevTools](https://docs.flutter.dev/tools/devtools)
- [Golden Toolkit](https://pub.dev/packages/golden_toolkit)
