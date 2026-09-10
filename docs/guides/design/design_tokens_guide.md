# دليل Design Tokens - نظام الألوان والتصميم

**تاريخ:** 25 ديسمبر 2025  
**الإصدار:** 1.0  
**المشروع:** بصير

---

## 📋 نظرة عامة

نظام Design Tokens هو أساس الهوية البصرية الموحدة لتطبيق بصير. يوفر هذا النظام مجموعة متسقة ومتكاملة من القيم التصميمية التي تضمن تجربة مستخدم متناسقة عبر جميع أجزاء التطبيق.

### الهيكل الثلاثي

```
١. Primitive Tokens  → قيم خام أساسية
٢. Semantic Tokens   → معاني تصميمية
٣. Context Tokens    → سياقات محددة
```

---

## 🎨 الألوان (Colors)

### المستوى الأول: Primitive Colors

الألوان الخام الأساسية المستخدمة في النظام:

```dart
import 'package:basir_app/core/theme/tokens/color_tokens.dart';

// الألوان الرئيسية
PrimitiveColors.blue500    // #2196F3 - الأزرق الأساسي
PrimitiveColors.blue700    // #1976D2 - أزرق داكن
PrimitiveColors.green500   // #4CAF50 - الأخضر
PrimitiveColors.red500     // #F44336 - الأحمر
PrimitiveColors.orange500  // #FF9800 - البرتقالي

// الدرجات الرمادية
PrimitiveColors.gray50     // #FAFAFA - رمادي فاتح جداً
PrimitiveColors.gray900    // #212121 - رمادي داكن جداً
```

### المستوى الثاني: Semantic Colors

الألوان ذات المعنى التصميمي:

```dart
// الألوان الأساسية
AppColors.primary         // اللون الأساسي للتطبيق
AppColors.secondary       // اللون الثانوي
AppColors.background      // خلفية التطبيق
AppColors.surface         // سطح البطاقات والعناصر
AppColors.textPrimary     // النص الأساسي
AppColors.textSecondary   // النص الثانوي

// ألوان الحالات
AppColors.success         // النجاح (أخضر)
AppColors.error           // الخطأ (أحمر)
AppColors.warning         // التحذير (برتقالي)
AppColors.info            // المعلومات (أزرق)
```

**نسب التباين (WCAG 2.1 AA):**

- Background vs TextPrimary: **16.22:1** ⭐
- Background vs TextSecondary: **8.26:1** ✅
- Surface vs TextPrimary: **17.40:1** ⭐

### المستوى الثالث: Context Colors

ألوان خاصة بسياقات محددة:

#### ButtonColors

```dart
// الأزرار الأساسية
ButtonColors.primaryBackground     // خلفية الزر الأساسي
ButtonColors.primaryForeground     // نص الزر الأساسي (تباين: 7.04:1)

// الأزرار الثانوية
ButtonColors.secondaryBackground
ButtonColors.secondaryForeground   // (تباين: 5.14:1)

// أزرار الخطر
ButtonColors.dangerBackground
ButtonColors.dangerForeground      // (تباين: 5.62:1)
```

#### InputColors

```dart
InputColors.background             // خلفية حقل الإدخال
InputColors.border                 // حدود الحقل
InputColors.borderFocused          // الحدود عند التركيز
InputColors.label                  // لون التسمية
InputColors.text                   // لون النص المدخل
InputColors.hint                   // لون النص التوضيحي
InputColors.error                  // لون الخطأ
```

### مثال عملي: استخدام الألوان

```dart
import 'package:basir_app/core/theme/tokens/index.dart';

Container(
  color: AppColors.surface,
  child: Text(
    'مرحباً',
    style: TextStyle(
      color: AppColors.textPrimary,
    ),
  ),
)
```

---

## ✍️ الطباعة (AppTypography.

### عائلات الخطوط

```dart
FontFamilies.arabic     // 'Cairo' - للغة العربية
FontFamilies.english    // 'Roboto' - للإنجليزية
FontFamilies.numbers    // 'Roboto Mono' - للأرقام والمبالغ
```

### أحجام الخطوط (Type Scale)

```dart
// العناوين الكبيرة
AppTypography.headlineLarge    // 34px
AppTypography.headlineMedium   // 28px
AppTypography.headlineSmall    // 24px

// العناوين الرئيسية
AppTypography.titleLarge       // 22px
AppTypography.titleMedium      // 18px
AppTypography.titleSmall       // 16px

// النصوص
AppTypography.bodyLarge        // 17px
AppTypography.bodyMedium       // 15px
AppTypography.bodySmall        // 13px

// التسميات
AppTypography.labelLarge       // 15px
AppTypography.labelMedium      // 13px
AppTypography.labelSmall       // 12px
```

### أوزان الخطوط

```dart
FontWeights.light          // 300
FontWeights.regular        // 400
FontWeights.medium         // 500
FontWeights.semiBold       // 600
FontWeights.bold           // 700
FontWeights.extraBold      // 800
```

### TextStyles الجاهزة

```dart
// استخدام مباشر للأنماط الجاهزة
Text(
  'عنوان رئيسي',
  style: TextStyles.headlineLarge,
)

Text(
  'نص عادي',
  style: TextStyles.bodyMedium,
)

Text(
  'تسمية',
  style: TextStyles.labelSmall,
)
```

### مثال: تخصيص نمط النص

```dart
Text(
  'نص مخصص',
  style: TextStyles.bodyLarge.copyWith(
    color: AppColors.primary,
    fontWeight: FontWeights.semiBold,
  ),
)
```

---

## 📐 المسافات (Spacing)

### نظام 8-Point Grid

جميع المسافات هي مضاعفات الرقم 4:

```dart
Spacing.xs      // 4px
Spacing.sm      // 8px
Spacing.md      // 16px
Spacing.lg      // 24px
Spacing.xl      // 32px
Spacing.xxl     // 48px
Spacing.xxxl    // 64px
```

### Border Radius

```dart
Radii.xs        // 4px
Radii.sm        // 8px
Radii.md        // 12px
Radii.lg        // 16px
Radii.xl        // 20px
Radii.xxl       // 24px
Radii.full      // 9999px (دائري كامل)
```

### أحجام الأيقونات

```dart
IconSizes.xs    // 16px
IconSizes.sm    // 20px
IconSizes.md    // 24px
IconSizes.lg    // 28px
IconSizes.xl    // 32px
IconSizes.xxl   // 40px
```

### Touch Targets (إمكانية الوصول)

**الحد الأدنى: 44x44px** (WCAG 2.1 AA)

```dart
TouchTargets.minTouchTarget    // 44px
TouchTargets.buttonHeightSm    // 44px
TouchTargets.buttonHeightMd    // 48px
TouchTargets.buttonHeightLg    // 52px
TouchTargets.inputHeight       // 56px
TouchTargets.appBarHeight      // 56px
TouchTargets.bottomNavHeight   // 64px
```

### مثال: تباعد متسق

```dart
Padding(
  padding: EdgeInsets.all(Spacing.md),
  child: Column(
    spacing: Spacing.sm,
    children: [
      // محتوى...
    ],
  ),
)
```

---

## 🎬 الحركات (Animations)

### المدد الزمنية

```dart
Durations.instant     // 100ms - فوري
Durations.fast        // 200ms - سريع
Durations.normal      // 300ms - عادي
Durations.slow        // 500ms - بطيء
```

### منحنيات التسارع

```dart
AnimationCurves.standard        // Curves.easeInOut
AnimationCurves.emphasized      // Curves.easeOutCubic
AnimationCurves.decelerate      // Curves.easeOut
AnimationCurves.accelerate      // Curves.easeIn
```

### مثال: حركة سلسة

```dart
AnimatedContainer(
  duration: Durations.normal,
  curve: AnimationCurves.emphasized,
  width: isExpanded ? 200 : 100,
  height: isExpanded ? 200 : 100,
)
```

---

## 🔧 أفضل الممارسات

### ✅ افعل

```dart
// ✅ استخدم التوكنات دائماً
color: AppColors.primary

// ✅ استخدم TextStyles الجاهزة
style: TextStyles.bodyMedium

// ✅ استخدم Spacing للتباعد
padding: EdgeInsets.all(Spacing.md)
```

### ❌ لا تفعل

```dart
// ❌ لا تستخدم قيم hardcoded
color: Color(0xFF2196F3)

// ❌ لا تستخدم أحجام عشوائية
fontSize: 15.7

// ❌ لا تستخدم قيم غير متناسقة
padding: EdgeInsets.all(13)
```

---

## 📦 الاستيراد

### استيراد جميع التوكنات

```dart
import 'package:basir_app/core/theme/tokens/index.dart';
```

### استيراد محدد

```dart
import 'package:basir_app/core/theme/tokens/color_tokens.dart';
import 'package:basir_app/core/theme/tokens/typography_tokens.dart';
import 'package:basir_app/core/theme/tokens/spacing_tokens.dart';
```

---

## 🧪 التحقق التلقائي

جميع Design Tokens يتم التحقق منها تلقائياً عبر:

```bash
# اختبار التباين
flutter test test/core/theme/tokens_test.dart

# تقرير الجودة
dart scripts/generate_quality_report.dart
```

---

## 📚 مراجع إضافية

- [دليل المكونات](components_guide.md)
- [معايير إمكانية الوصول](../accessibility_standards.md)
- [الكود المصدري](file:///home/m/Projects/basir-app/lib/core/theme/tokens)

---

**آخر تحديث:** 25 ديسمبر 2025  
**الحالة:** ✅ معتمد للإنتاج
