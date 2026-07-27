# نظام الثيمات الموحد (Theme System)

**المشروع:** بصير - نظام المحاسبة الذكي  
**الإصدار:** 2.0  
**التاريخ:** 26 يوليو 2026  
**المؤلف:** فريق وكلاء تطوير مشروع بصير

---

## نظرة عامة

نظام الثيمات الموحد يوفر تصميماً متسقاً ومتيناً لتطبيق بصير، مع التركيز على:

- **إمكانية الوصول:** امتثال كامل لمعايير WCAG 2.1 Level AA
- **التباين:** جميع النصوص تحقق نسبة تباين ≥ 4.5:1
- **الأحجام:** مساحات نقر ≥ 48x48px وأيقونات ≥ 24px
- **السلاسة:** حركات انتقالية بين 150-350ms

---

## البنية المعمارية

```
lib/core/theme/
├── app_theme.dart              # الثيم الرئيسي (ThemeData)
├── app_state_colors.dart       # ألوان حالات العناصر
├── app_font_metrics.dart       # مقاييس خطوط Cairo
├── font_manager.dart           # مدير الخطوط مع fallback
├── glass_theme.dart            # ثيم Glassmorphism
├── border_contrast_design.dart # تصميم حدود محسّنة
├── disabled_state_design.dart  # تصميم الحالة المعطلة
├── selected_state_design.dart  # تصميم الحالة المحددة
├── enhanced_button_theme.dart  # ثيم الأزرار المحسّن
├── opacity_compositing_design.dart # معالجة الشفافية
├── accessibility/
│   └── state_contrast_calculator.dart # حاسبة التباين
├── tokens/                     # Design Tokens
│   ├── app_colors.dart         # نظام الألوان
│   ├── app_text_styles.dart    # أنماط النصوص
│   ├── app_dimensions.dart     # الأبعاد والمسافات
│   ├── app_animations.dart     # الحركات والانتقالات
│   ├── spacing.dart            # المسافات
│   ├── radii.dart              # نصف قطر الزوايا
│   ├── elevation.dart          # الظلال
│   ├── durations.dart          # مدد الحركات
│   ├── icon_sizes.dart         # أحجام الأيقونات
│   ├── touch_targets.dart      # مساحات النقر
│   └── ...                     # المزيد
└── utils/
    └── accessibility_checker.dart # أدوات فحص التباين
```

---

## الاستخدام السريع

### 1. تطبيق الثيم في MaterialApp

```dart
import 'package:basir_accounting_system/core/theme/app_theme.dart';

MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
  // ...
)
```

### 2. استخدام Design Tokens

```dart
import 'package:basir_accounting_system/core/theme/tokens/index.dart';

// الألوان
Container(
  color: AppColors.primary,
  child: Text(
    'نص بلون أساسي',
    style: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.onPrimary,
    ),
  ),
)

// المسافات
Padding(
  padding: Spacing.paddingMd,
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: Radii.borderRadiusMd,
    ),
  ),
)

// الحركات
AnimatedContainer(
  duration: Durations.short,
  curve: AnimationCurves.easeInOut,
)
```

---

## نظام الألوان (AppColors)

### الألوان الأساسية

| الاسم | الكود | الاستخدام | التباين |
|-------|-------|-----------|---------|
| `primary` | `#0056B3` | الأزرار، الروابط | 8.59:1 ✅ |
| `primaryLight` | `#E3F2FD` | الخلفيات المميزة | - |
| `secondary` | `#1E7E34` | الإجراءات الثانوية | 6.98:1 ✅ |
| `secondaryLight` | `#E8F5E9` | خلفيات النجاح | - |

### ألوان الحالة

| الاسم | الكود | الاستخدام | التباين |
|-------|-------|-----------|---------|
| `success` | `#2E7D32` | رسائل النجاح | 5.39:1 ✅ |
| `error` | `#C62828` | رسائل الخطأ | 7.27:1 ✅ |
| `warning` | `#D73502` | التحذيرات | 4.56:1 ✅ |
| `info` | `#0D47A1` | المعلومات | 8.59:1 ✅ |

### ألوان النصوص

| الاسم | الكود | الاستخدام | التباين |
|-------|-------|-----------|---------|
| `textPrimary` | `#000000` | النص الأساسي | 21:1 ✅ |
| `textSecondary` | `#4A4A4A` | النص الثانوي | 9.74:1 ✅ |
| `textHint` | `#5A5A5A` | النص التوضيحي | 4.54:1 ✅ |
| `textDisabled` | `#BDBDBD` | النص المعطل | 2.44:1 ⚠️ |

### مثال استخدام

```dart
// زر أساسي
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
  ),
  onPressed: () {},
  child: Text('تسجيل الدخول'),
)

// رسالة خطأ
Text(
  'حدث خطأ في العملية',
  style: AppTextStyles.bodyMedium.copyWith(
    color: AppColors.error,
  ),
)
```

---

## نظام النصوص (AppTextStyles)

### الأحجام والتسلسل الهرمي

| النمط | الحجم | الوزن | الاستخدام |
|-------|-------|-------|-----------|
| `displayLarge` | 57px | Bold | العناوين الرئيسية الكبيرة |
| `displayMedium` | 45px | Bold | العناوين الفرعية الكبيرة |
| `headlineLarge` | 32px | Bold | عناوين الشاشات |
| `headlineMedium` | 28px | SemiBold | عناوين الأقسام |
| `headlineSmall` | 24px | SemiBold | عناوين البطاقات |
| `titleLarge` | 22px | SemiBold | عناوين العناصر |
| `titleMedium` | 16px | Medium | عناوين فرعية |
| `bodyLarge` | 16px | Regular | النص الأساسي الكبير |
| `bodyMedium` | 14px | Regular | النص الأساسي |
| `bodySmall` | 12px | Regular | النص الثانوي |
| `labelLarge` | 14px | Medium | تسميات الأزرار |
| `labelMedium` | 12px | Medium | تسميات صغيرة |
| `labelSmall` | 11px | Medium | تسميات صغيرة جداً |

### ارتفاع الأسطر

```dart
// للنصوص القصيرة (عناوين، أزرار)
lineHeightTight = 1.2

// للنصوص الأساسية (فقرات)
lineHeightNormal = 1.5  // WCAG 2.1 AA minimum

// للنصوص الطويلة (مقالات)
lineHeightRelaxed = 1.8
```

### مثال استخدام

```dart
// عنوان شاشة
Text(
  'لوحة التحكم',
  style: AppTextStyles.headlineLarge,
)

// نص أساسي
Text(
  'مرحباً بك في نظام المحاسبة الذكي. يوفر النظام...',
  style: AppTextStyles.bodyMedium.copyWith(
    height: AppTextStyles.lineHeightNormal,
  ),
)
```

---

## نظام المسافات (Spacing)

### القيم الأساسية

| الاسم | القيمة | الاستخدام |
|-------|--------|-----------|
| `xs` | 4px | فجوات صغيرة جداً |
| `sm` | 8px | فجوات صغيرة |
| `md` | 16px | فجوات متوسطة (الافتراضية) |
| `lg` | 24px | فجوات كبيرة |
| `xl` | 32px | فجوات كبيرة جداً |
| `xxl` | 48px | فجوات ضخمة |

### Padding الجاهز

```dart
// padding موحد
Padding(padding: Spacing.paddingMd)

// padding أفقي فقط
Padding(padding: Spacing.paddingHorizontalMd)

// padding عمودي فقط
Padding(padding: Spacing.paddingVerticalMd)
```

### مثال استخدام

```dart
Column(
  children: [
    Container(
      padding: Spacing.paddingMd,
      child: Text('محتوى مع padding متوسط'),
    ),
    SizedBox(height: Spacing.lg), // فاصل كبير
    Container(
      padding: Spacing.paddingHorizontalMd,
      child: Text('محتوى مع padding أفقي'),
    ),
  ],
)
```

---

## نظام الأيقونات (IconSizes)

### الأحجام القياسية

| الاسم | الحجم | الاستخدام |
|-------|-------|-----------|
| `sm` | 16px | أيقونات صغيرة (badges) |
| `md` | 24px | الأيقونات الأساسية ✅ |
| `lg` | 32px | أيقونات كبيرة |
| `xl` | 48px | أيقونات ضخمة (empty states) |

### مثال استخدام

```dart
// أيقونة أساسية (24px)
Icon(
  Icons.home,
  size: IconSizes.md,
  color: AppColors.primary,
)

// أيقونة في زر
IconButton(
  icon: Icon(Icons.menu, size: IconSizes.md),
  onPressed: () {},
)
```

---

## نظام مساحات النقر (TouchTargets)

### الأحجام الدنيا

```dart
// الحد الأدنى لمساحة النقر (WCAG 2.1 AA)
TouchTargets.minimum = 48.0

// أحجام الأزرار
TouchTargets.buttonHeightSm = 40.0
TouchTargets.buttonHeightMd = 48.0  // الافتراضي
TouchTargets.buttonHeightLg = 56.0
```

### مثال استخدام

```dart
// زر بمساحة نقر كافية
InkWell(
  onTap: () {},
  child: Container(
    minWidth: TouchTargets.minimum,
    minHeight: TouchTargets.minimum,
    child: Icon(Icons.edit),
  ),
)
```

---

## نظام الحركات (Durations & Curves)

### المدد

| الاسم | المدة | الاستخدام |
|-------|-------|-----------|
| `short` | 200ms | تغييرات الحالة السريعة |
| `medium` | 300ms | الانتقالات العادية |
| `long` | 400ms | الانتقالات المعقدة |

### المنحنيات

```dart
AnimationCurves.easeIn      // بداية بطيئة
AnimationCurves.easeOut     // نهاية بطيئة
AnimationCurves.easeInOut   // بداية ونهاية بطيئة
AnimationCurves.bounceOut   // تأثير الارتداد
```

### مثال استخدام

```dart
AnimatedContainer(
  duration: Durations.medium,
  curve: AnimationCurves.easeInOut,
  width: isExpanded ? 200 : 100,
  child: Card(child: Text('محتوى')),
)
```

---

## نظام الحالات (Interactive States)

### الحالات المدعومة

```dart
enum InteractiveState {
  normal,    // الحالة العادية
  hovered,   // عند الحوم
  pressed,   // عند الضغط
  focused,   // عند التركيز
  selected,  // عند التحديد
  disabled,  // عند التعطيل
}
```

### ألوان الحالات

```dart
// ألوان الأزرار الأساسية
AppStateColors.primaryNormal    = #0056B3
AppStateColors.primaryHovered   = #004A9F  (10% أغمق)
AppStateColors.primaryPressed   = #003D82  (15% أغمق)
AppStateColors.primaryFocused   = #0056B3  (مع حد)
AppStateColors.primarySelected  = #E3F2FD  (خلفية فاتحة)
AppStateColors.primaryDisabled  = #D1D5DB  (معطل)

// overlay colors
AppStateColors.hoverOverlay     = #0A000000 (4% أسود)
AppStateColors.pressedOverlay   = #14000000 (8% أسود)
AppStateColors.selectedOverlay  = #1F2196F3 (12% أزرق)
```

### مثال استخدام

```dart
// زر مع جميع الحالات
ElevatedButton(
  style: EnhancedButtonTheme.createPrimaryButtonStyle(),
  onPressed: isEnabled ? _handlePress : null,
  child: Text('حفظ'),
)
```

---

## حدود الوصولية (AccessibilityChecker)

### فحص التباين

```dart
// فحص تباين لون مع خلفية
final hasContrast = AccessibilityChecker.checkContrast(
  AppColors.textPrimary,
  AppColors.surface,
  minRatio: 4.5,  // WCAG AA للنصوص العادية
);

// حساب نسبة التباين
final ratio = AccessibilityChecker.calculateContrastRatio(
  AppColors.textPrimary,
  AppColors.background,
);
print('نسبة التباين: $ratio:1');  // 19.5:1
```

### فحص مساحة النقر

```dart
// فحص مساحة نقر
final isValid = AccessibilityChecker.checkTouchTarget(
  Size(48, 48),
  minSize: 48.0,
);
```

### فحص حجم الخط

```dart
// فحص حجم خط
final isValid = AccessibilityChecker.checkFontSize(
  16.0,
  minSize: 15.0,  // الحد الأدنى للنص العربي
);
```

---

## الثيم الداكن (Dark Mode)

### الألوان الداكنة

```dart
// الثيم الداكن جاهز للاستخدام
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,  // أو ThemeMode.dark
)

// ألوان Dark Mode
AppPalette.blueCorporate    // الأزرق الداكن
AppPalette.greenEmerald    // الأخضر الداكن
AppPalette.darkBackground  // الخلفية الداكنة (#0F172A)
AppPalette.darkSurface     // السطح الداكن (#1E293B)
AppPalette.darkTextPrimary // النص الأساسي (#E2E8F0)
```

---

## أمثلة عملية

### 1. إنشاء زر أساسي محسّن

```dart
import 'package:basir_accounting_system/core/widgets/app_enhanced_button.dart';

AppEnhancedButton(
  text: 'حفظ التغييرات',
  onPressed: () => _saveChanges(),
  isPrimary: true,
  icon: Icons.save,
)

// زر معطل مع tooltip توضيحي
AppEnhancedButton(
  text: 'حذف',
  onPressed: null,  // معطل
  disabledReason: 'لا يمكن حذف فاتورة مُصدرة',
)
```

### 2. إنشاء بطاقة مع حالة

```dart
import 'package:basir_accounting_system/shared/widgets/app_card.dart';

AppCard(
  title: 'فاتورة رقم 123',
  subtitle: '15 يناير 2026',
  statusColor: AppColors.success,  // شريط حالة أخضر
  badge: CardBadgeStatus.success('مدفوعة'),
  onTap: () => _showInvoiceDetails(),
  child: Text('المبلغ: 1,500 ريال'),
)
```

### 3. إنشاء حقل إدخال محسّن

```dart
import 'package:basir_accounting_system/core/widgets/app_text_field.dart';

AppTextField(
  label: 'اسم العميل',
  hint: 'أدخل اسم العميل',
  errorText: _errorText,
  onChanged: (value) => _validateInput(value),
)
```

### 4. إنشاء رسالة Snackbar

```dart
import 'package:basir_accounting_system/shared/widgets/app_snackbar.dart';

// رسالة نجاح
AppSnackbar.showSuccess(context, 'تم حفظ الفاتورة بنجاح');

// رسالة خطأ
AppSnackbar.showError(context, 'فشل في الاتصال بالخادم');

// رسالة تحذير
AppSnackbar.showWarning(context, 'الفاتورة ستنتهي صلاحيتها قريباً');
```

### 5. إنشاء حالة فارغة

```dart
import 'package:basir_accounting_system/shared/widgets/app_empty_state.dart';

AppEmptyState(
  icon: Icons.inbox_outlined,
  title: 'لا توجد فواتير',
  description: 'قم بإنشاء فاتورة جديدة للبدء',
  actionLabel: 'إنشاء فاتورة',
  onActionPressed: () => _createInvoice(),
)
```

---

## أفضل الممارسات

### 1. استخدم Design Tokens دائماً

❌ **تجنب:**
```dart
Container(
  padding: EdgeInsets.all(16),
  child: Text(
    'نص',
    style: TextStyle(fontSize: 14),
  ),
)
```

✅ **استخدم:**
```dart
Container(
  padding: Spacing.paddingMd,
  child: Text(
    'نص',
    style: AppTextStyles.bodyMedium,
  ),
)
```

### 2. تحقق من التباين

```dart
// قبل استخدام لون جديد
if (kDebugMode) {
  assert(
    AppColors.hasMinimumContrast(myColor),
    'التباين غير كافٍ!',
  );
}
```

### 3. استخدم مساحات نقر كافية

❌ **تجنب:**
```dart
IconButton(
  icon: Icon(Icons.edit, size: 20),  // صغير جداً
  onPressed: () {},
)
```

✅ **استخدم:**
```dart
IconButton(
  icon: Icon(Icons.edit, size: IconSizes.md),  // 24px
  onPressed: () {},
  constraints: BoxConstraints(
    minWidth: TouchTargets.minimum,
    minHeight: TouchTargets.minimum,
  ),
)
```

### 4. استخدم الثيم بدلاً من الألوان الصلبة

❌ **تجنب:**
```dart
Container(
  color: Color(0xFF0056B3),
)
```

✅ **استخدم:**
```dart
Container(
  color: Theme.of(context).colorScheme.primary,
  // أو
  color: AppColors.primary,
)
```

---

## الاختبارات

### تشغيل اختبارات الخصائص

```bash
flutter test test/core/theme/tokens/properties/
```

### تشغيل اختبارات الوحدة

```bash
flutter test test/core/theme/
```

### تشغيل flutter analyze

```bash
flutter analyze
```

---

## المراجع

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Material Design 3](https://m3.material.io/)
- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [Google Fonts - Cairo](https://fonts.google.com/specimen/Cairo)

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 26 يوليو 2026  
**الإصدار:** 1.0
