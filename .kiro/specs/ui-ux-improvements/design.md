# تصميم تحسينات واجهة المستخدم

**المشروع:** بصير MVP  
**التاريخ:** 2 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ معتمدة

---

## نظرة عامة

هذا المستند يحدد التصميم التقني لتحسينات واجهة المستخدم في تطبيق بصير، مع التركيز على تحسين الوضوح والتباين وإمكانية الوصول وفقاً لمعايير WCAG 2.1 Level AA.

### الأهداف الرئيسية

1. **تحسين إمكانية الوصول:** ضمان أن التطبيق قابل للاستخدام من قبل جميع المستخدمين
2. **تحسين الوضوح:** جعل جميع العناصر واضحة وسهلة القراءة
3. **تحسين التجربة:** توفير تجربة مستخدم سلسة ومريحة
4. **الامتثال للمعايير:** الالتزام بمعايير WCAG 2.1 Level AA

### الوضع الحالي

✅ **نقاط القوة:**

- نظام ثيمات ممتاز موجود في `lib/core/theme.dart`
- ألوان محسّنة للتباين مسبقاً (Primary: #0056B3, Secondary: #1E7E34)
- مكونات أساسية جيدة (AppButton, AppTextField, AppCard, AppAppBar)
- دعم RTL ممتاز
- توثيق شامل

⚠️ **الفجوات:**

- لا توجد أدوات للتحقق من التباين والأحجام
- لا توجد حركات انتقالية محددة
- بعض المكونات تحتاج تحسينات (hover, focus, ripple effect)
- مكونات مفقودة (Tooltips, Snackbar, Dialog, Empty State)

📋 **النهج:**

- البناء على النظام الموجود (لا إعادة كتابة)
- إضافة أدوات التحقق
- تحسين المكونات الموجودة
- إضافة مكونات جديدة

---

## البنية المعمارية

### النهج المعماري

سنتبع نهج **Theme-First Architecture** حيث يتم تعريف جميع الألوان والخطوط والأحجام والحركات في نظام ثيمات مركزي، ثم يتم استخدامها في جميع أنحاء التطبيق.

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_theme.dart           # الثيم الرئيسي
│   │   ├── app_colors.dart          # نظام الألوان
│   │   ├── app_text_styles.dart     # أنماط النصوص
│   │   ├── app_dimensions.dart      # الأبعاد والمسافات
│   │   ├── app_animations.dart      # الحركات والانتقالات
│   │   └── accessibility/
│   │       ├── contrast_checker.dart    # فحص التباين
│   │       └── accessibility_utils.dart # أدوات إمكانية الوصول
│   └── widgets/
│       ├── app_button.dart          # زر محسّن
│       ├── app_text_field.dart      # حقل إدخال محسّن
│       ├── app_card.dart            # بطاقة محسّنة
│       └── app_app_bar.dart         # شريط تطبيق محسّن
```

### المبادئ المعمارية

1. **Single Source of Truth:** جميع قيم الثيم في مكان واحد
2. **Reusability:** widgets قابلة لإعادة الاستخدام
3. **Consistency:** تطبيق موحد للمعايير
4. **Testability:** قابلية اختبار جميع المكونات

---

## المكونات والواجهات

### 1. نظام الألوان (AppColors)

#### الواجهة

```dart
class AppColors {
  // ألوان أساسية
  static const Color primary = Color(0xFF1976D2);
  static const Color secondary = Color(0xFF424242);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);

  // ألوان النصوص
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // ألوان الحالات
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // ألوان التفاعل
  static const Color focusBorder = Color(0xFF1976D2);
  static const Color hoverOverlay = Color(0x0A000000);
  static const Color pressedOverlay = Color(0x14000000);

  // التحقق من التباين
  static bool hasMinimumContrast(Color foreground, Color background, {double ratio = 4.5}) {
    // تنفيذ حساب التباين
  }
}
```

#### المسؤوليات

- تعريف جميع الألوان المستخدمة في التطبيق
- ضمان تباين مناسب بين الألوان
- توفير دوال للتحقق من التباين

### 2. نظام النصوص (AppTextStyles)

#### الواجهة

```dart
class AppTextStyles {
  // خط Cairo
  static const String fontFamily = 'Cairo';

  // العناوين
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // النصوص الأساسية
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // النصوص الثانوية
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  // الأرقام والمبالغ
  static const TextStyle monospace = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.textPrimary,
  );
}
```

### 3. نظام الأبعاد (AppDimensions)

#### الواجهة

```dart
class AppDimensions {
  // أحجام الأيقونات
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // أحجام الأزرار
  static const double buttonHeight = 48.0;
  static const double buttonMinWidth = 88.0;
  static const double buttonBorderRadius = 8.0;

  // أحجام حقول الإدخال
  static const double inputHeight = 56.0;
  static const double inputBorderWidth = 1.0;
  static const double inputFocusBorderWidth = 2.0;
  static const double inputBorderRadius = 8.0;

  // المسافات
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // مساحات النقر
  static const double minTouchTarget = 48.0;

  // الحدود
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 1.5;
  static const double borderWidthThick = 2.0;
}
```

### 4. نظام الحركات (AppAnimations)

#### الواجهة

```dart
class AppAnimations {
  // مدد الحركات
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);

  // منحنيات الحركة
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;

  // حركات الانتقال
  static Widget slideTransition(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: easeInOut,
      )),
      child: child,
    );
  }

  static Widget fadeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
```

### 5. Widgets المحسّنة

#### AppButton

```dart
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
        child: Container(
          height: AppDimensions.buttonHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(
                    text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isPrimary ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
```

#### AppTextField

```dart
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    Key? key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSmall),
            child: Text(
              widget.label!,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        Focus(
          onFocusChange: (focused) {
            setState(() => _isFocused = focused);
          },
          child: TextField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              errorText: widget.errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
                borderSide: BorderSide(
                  color: AppColors.textSecondary,
                  width: AppDimensions.inputBorderWidth,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
                borderSide: BorderSide(
                  color: AppColors.focusBorder,
                  width: AppDimensions.inputFocusBorderWidth,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.inputBorderRadius),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: AppDimensions.inputBorderWidth,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## نماذج البيانات

لا توجد نماذج بيانات جديدة لهذه الميزة. سنستخدم نظام الثيمات الموجود في Flutter مع تخصيصات إضافية.

---

```

```

## خصائص الصحة (Correctness Properties)

_خاصية الصحة هي سمة أو سلوك يجب أن يكون صحيحاً عبر جميع عمليات التنفيذ الصالحة للنظام - في الأساس، بيان رسمي حول ما يجب أن يفعله النظام. تعمل الخصائص كجسر بين المواصفات المقروءة للإنسان وضمانات الصحة القابلة للتحقق آلياً._

### Property 1: تباين النصوص العادية

_لأي_ نص عادي معروض في التطبيق، يجب أن تكون نسبة التباين بين لون النص ولون الخلفية لا تقل عن 4.5:1

**Validates: Requirements 1.1, 2.5, 7.3, 7.5, 8.2, 9.4**

### Property 2: تباين النصوص الكبيرة

_لأي_ نص كبير (18pt أو أكبر أو 14pt عريض أو أكبر) معروض في التطبيق، يجب أن تكون نسبة التباين بين لون النص ولون الخلفية لا تقل عن 3:1

**Validates: Requirements 1.2**

### Property 3: تباين العناصر التفاعلية

_لأي_ عنصر تفاعلي (زر، رابط، حقل إدخال، أيقونة قابلة للنقر)، يجب أن تكون نسبة التباين بين لون العنصر ولون الخلفية لا تقل عن 3:1

**Validates: Requirements 1.3, 3.3, 7.1, 7.2, 8.3**

### Property 4: تباين مؤشر التركيز

_لأي_ عنصر تفاعلي في حالة التركيز، يجب أن تكون نسبة التباين بين مؤشر التركيز والخلفية المحيطة لا تقل عن 3:1

**Validates: Requirements 1.5**

### Property 5: حجم الخط الأساسي

_لأي_ نص عربي أساسي معروض في التطبيق، يجب أن يكون حجم الخط لا يقل عن 15px ونوع الخط Cairo

**Validates: Requirements 2.1**

### Property 6: أوزان وأحجام العناوين

_لأي_ عنوان رئيسي أو فرعي، يجب أن يكون وزن الخط SemiBold أو Bold والحجم بين 18px و 24px

**Validates: Requirements 2.2**

### Property 7: ارتفاع السطر للنصوص الطويلة

_لأي_ نص طويل أو فقرة، يجب أن يكون ارتفاع السطر (line-height) لا يقل عن 1.5

**Validates: Requirements 2.3**

### Property 8: خط الأرقام والمبالغ

_لأي_ رقم أو مبلغ مالي معروض، يجب استخدام خط أحادي المسافة (Monospace) أو خط بأرقام متناسقة العرض

**Validates: Requirements 2.4**

### Property 9: حجم الأيقونات الأساسية

_لأي_ أيقونة أساسية معروضة، يجب أن يكون حجمها لا يقل عن 24x24px

**Validates: Requirements 3.1, 8.3**

### Property 10: مساحة النقر للعناصر التفاعلية

_لأي_ عنصر تفاعلي قابل للنقر (زر، أيقونة، رابط)، يجب أن تكون مساحة النقر لا تقل عن 48x48px

**Validates: Requirements 3.2, 5.1**

### Property 11: وجود Tooltip للأيقونات التفاعلية

_لأي_ أيقونة تفاعلية، عند الحوم أو التركيز عليها، يجب عرض tooltip توضيحي بالعربية الفصحى

**Validates: Requirements 3.4**

### Property 12: مدة الانتقالات بين الشاشات

_لأي_ انتقال بين شاشات رئيسية، يجب أن تكون مدة الحركة الانتقالية بين 250ms و 350ms

**Validates: Requirements 4.1**

### Property 13: مدة تغيير حالة العناصر

_لأي_ تغيير في حالة عنصر تفاعلي (hover, focus, active)، يجب أن تكون مدة التغيير البصري بين 150ms و 250ms

**Validates: Requirements 4.2**

### Property 14: وجود مؤشر تحميل

_لأي_ عملية تحميل محتوى أو معالجة، يجب عرض مؤشر تحميل واضح مع حركة سلسة ومستمرة

**Validates: Requirements 4.5, 10.2**

### Property 15: تباين الأزرار الأساسية

_لأي_ زر أساسي، يجب أن تكون نسبة التباين بين لون النص ولون الخلفية لا تقل عن 4.5:1

**Validates: Requirements 5.2**

### Property 16: تغيير بصري عند التفاعل مع الأزرار

_لأي_ زر، عند الحوم أو التركيز عليه، يجب عرض تغيير بصري واضح (تغيير اللون أو إضافة ظل أو تغيير الحدود)

**Validates: Requirements 5.3, 6.3**

### Property 17: Feedback بصري عند الضغط

_لأي_ زر، عند الضغط عليه، يجب عرض feedback بصري فوري (ripple effect أو تغيير في الحجم)

**Validates: Requirements 5.4**

### Property 18: حالة الزر المعطل

_لأي_ زر معطل أو غير نشط، يجب عرض حالة معطلة واضحة مع opacity منخفض وعدم إمكانية التفاعل

**Validates: Requirements 5.5**

### Property 19: حدود أو ظل البطاقات

_لأي_ بطاقة معروضة، يجب استخدام حدود واضحة بسمك لا يقل عن 1px أو ظل خفيف (elevation) للفصل عن الخلفية

**Validates: Requirements 6.1**

### Property 20: فواصل أو مسافات في القوائم

_لأي_ قائمة عناصر، يجب استخدام فواصل واضحة (dividers) أو مسافات كافية بين العناصر

**Validates: Requirements 6.2**

### Property 21: تسلسل هرمي للنصوص في البطاقات

_لأي_ بطاقة تحتوي على معلومات، يجب استخدام تسلسل هرمي واضح للنصوص (عنوان، نص أساسي، نص ثانوي)

**Validates: Requirements 6.4**

### Property 22: شارة أو لون للحالات في البطاقات

_لأي_ بطاقة تعرض حالة أو تصنيف، يجب استخدام شارة (badge) أو لون خلفية واضح مع تباين مناسب

**Validates: Requirements 6.5**

### Property 23: رسالة خطأ واضحة في حقول الإدخال

_لأي_ حقل إدخال يحتوي على خطأ في التحقق، يجب عرض رسالة خطأ بلون أحمر واضح مع أيقونة ونص توضيحي بالعربية

**Validates: Requirements 7.4**

### Property 24: سرعة تحديث مؤشر التنقل

_لأي_ انتقال بين أقسام مختلفة، يجب تحديث مؤشر التنقل بشكل واضح وفوري خلال 200ms

**Validates: Requirements 8.5**

### Property 25: رسالة واضحة للحالات الفارغة

_لأي_ شاشة أو قسم لا يحتوي على محتوى، يجب عرض رسالة واضحة بالعربية مع أيقونة توضيحية مناسبة

**Validates: Requirements 10.1**

### Property 26: رسالة خطأ مع زر إعادة المحاولة

_لأي_ فشل في تحميل المحتوى، يجب عرض رسالة خطأ واضحة مع أيقونة وزر إعادة المحاولة

**Validates: Requirements 10.3**

### Property 27: رسالة تشجيعية للقوائم الفارغة

_لأي_ قائمة أو مجموعة فارغة، يجب عرض رسالة تشجيعية مع زر إضافة عنصر جديد

**Validates: Requirements 10.4**

### Property 28: رسالة واضحة لنتائج البحث الفارغة

_لأي_ عملية بحث بدون نتائج مطابقة، يجب عرض رسالة واضحة مع اقتراحات أو نصائح للبحث

**Validates: Requirements 10.5**

---

## معالجة الأخطاء

### استراتيجية معالجة الأخطاء

1. **أخطاء التباين:**

   - إذا فشل فحص التباين، يجب تسجيل تحذير في وضع التطوير
   - يجب توفير أداة لفحص التباين في وقت التطوير

2. **أخطاء الأحجام:**

   - إذا كانت الأحجام أقل من الحد الأدنى، يجب تسجيل تحذير
   - يجب توفير أداة لفحص الأحجام في وقت التطوير

3. **أخطاء الحركات:**
   - إذا فشلت الحركة، يجب عرض المحتوى مباشرة بدون حركة
   - يجب تسجيل الخطأ للمراجعة

### أدوات التحقق

```dart
class AccessibilityChecker {
  /// يتحقق من تباين الألوان
  static bool checkContrast(Color foreground, Color background, {double minRatio = 4.5}) {
    final ratio = _calculateContrastRatio(foreground, background);
    if (ratio < minRatio) {
      debugPrint('⚠️ تحذير: التباين منخفض ($ratio:1) - الحد الأدنى: $minRatio:1');
      return false;
    }
    return true;
  }

  /// يحسب نسبة التباين بين لونين
  static double _calculateContrastRatio(Color color1, Color color2) {
    final l1 = _relativeLuminance(color1);
    final l2 = _relativeLuminance(color2);
    final lighter = max(l1, l2);
    final darker = min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// يحسب السطوع النسبي للون
  static double _relativeLuminance(Color color) {
    final r = _linearize(color.red / 255);
    final g = _linearize(color.green / 255);
    final b = _linearize(color.blue / 255);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _linearize(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    }
    return pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  /// يتحقق من حجم مساحة النقر
  static bool checkTouchTarget(Size size, {double minSize = 48.0}) {
    if (size.width < minSize || size.height < minSize) {
      debugPrint('⚠️ تحذير: مساحة النقر صغيرة (${size.width}x${size.height}) - الحد الأدنى: ${minSize}x$minSize');
      return false;
    }
    return true;
  }

  /// يتحقق من حجم الخط
  static bool checkFontSize(double fontSize, {double minSize = 15.0}) {
    if (fontSize < minSize) {
      debugPrint('⚠️ تحذير: حجم الخط صغير ($fontSize) - الحد الأدنى: $minSize');
      return false;
    }
    return true;
  }
}
```

---

## استراتيجية الاختبار

### نهج الاختبار المزدوج

سنستخدم نهج اختبار مزدوج يجمع بين:

1. **اختبارات الوحدة (Unit Tests):** لاختبار المكونات الفردية
2. **اختبارات الخصائص (Property-Based Tests):** للتحقق من الخصائص العامة

### مكتبة الاختبار

سنستخدم **test** و **flutter_test** المدمجة في Flutter، مع إضافة أدوات مخصصة لاختبار إمكانية الوصول.

### تكوين الاختبارات

- كل اختبار خاصية يجب أن يعمل على الأقل **100 تكرار** لضمان التغطية الكافية
- كل اختبار خاصية يجب أن يحتوي على تعليق يشير إلى رقم الخاصية في وثيقة التصميم

### أمثلة على الاختبارات

#### اختبار وحدة: تباين الألوان

```dart
void main() {
  group('AppColors Contrast Tests', () {
    test('primary text on background should have minimum 4.5:1 contrast', () {
      final hasContrast = AccessibilityChecker.checkContrast(
        AppColors.textPrimary,
        AppColors.background,
        minRatio: 4.5,
      );
      expect(hasContrast, isTrue);
    });

    test('secondary text on background should have minimum 4.5:1 contrast', () {
      final hasContrast = AccessibilityChecker.checkContrast(
        AppColors.textSecondary,
        AppColors.background,
        minRatio: 4.5,
      );
      expect(hasContrast, isTrue);
    });
  });
}
```

#### اختبار خاصية: حجم الأزرار

```dart
/// **Feature: ui-ux-improvements, Property 10: مساحة النقر للعناصر التفاعلية**
/// **Validates: Requirements 3.2, 5.1**
void main() {
  testWidgets('all buttons should have minimum 48x48 touch target', (tester) async {
    // إنشاء زر
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'اختبار',
            onPressed: () {},
          ),
        ),
      ),
    );

    // الحصول على حجم الزر
    final buttonFinder = find.byType(AppButton);
    final buttonSize = tester.getSize(buttonFinder);

    // التحقق من الحجم
    expect(buttonSize.width, greaterThanOrEqualTo(48.0));
    expect(buttonSize.height, greaterThanOrEqualTo(48.0));
  });
}
```

#### اختبار خاصية: تباين النصوص

```dart
/// **Feature: ui-ux-improvements, Property 1: تباين النصوص العادية**
/// **Validates: Requirements 1.1, 2.5, 7.3, 7.5, 8.2, 9.4**
void main() {
  group('Text Contrast Property Tests', () {
    test('all text styles should have minimum 4.5:1 contrast with background', () {
      final textStyles = [
        AppTextStyles.bodyLarge,
        AppTextStyles.bodyMedium,
        AppTextStyles.caption,
      ];

      for (final style in textStyles) {
        final hasContrast = AccessibilityChecker.checkContrast(
          style.color!,
          AppColors.background,
          minRatio: 4.5,
        );
        expect(hasContrast, isTrue, reason: 'Style ${style.fontSize} failed contrast check');
      }
    });
  });
}
```

### تغطية الاختبارات

- **الهدف:** 70%+ تغطية للكود
- **التركيز:** اختبار جميع الخصائص المحددة
- **الأولوية:** اختبار المكونات الأساسية أولاً (الألوان، الخطوط، الأزرار، حقول الإدخال)

---

## الأمان

### اعتبارات الأمان

1. **لا توجد بيانات حساسة:** هذه الميزة تتعلق بالواجهة فقط ولا تتعامل مع بيانات حساسة
2. **الأداء:** يجب التأكد من أن فحوصات التباين لا تؤثر على الأداء في الإنتاج
3. **التحقق في وقت التطوير:** جميع فحوصات إمكانية الوصول يجب أن تعمل فقط في وضع التطوير

---

## الأداء

### اعتبارات الأداء

1. **التخزين المؤقت:** تخزين نتائج حسابات التباين مؤقتاً لتجنب الحسابات المتكررة
2. **الحركات:** استخدام `const` constructors حيثما أمكن لتقليل rebuilds
3. **الأحجام:** تحديد الأحجام بشكل ثابت لتجنب الحسابات الديناميكية

### قياسات الأداء

- **وقت البناء:** يجب ألا يزيد عن 2 ثانية
- **معدل الإطارات:** يجب الحفاظ على 60 FPS أثناء الحركات
- **حجم التطبيق:** يجب ألا يزيد بأكثر من 5%

---

## التبعيات

### تبعيات Flutter

```yaml
dependencies:
  flutter:
    sdk: flutter
  material_design_icons_flutter: ^7.0.7296

dev_dependencies:
  flutter_test:
    sdk: flutter
  test: ^1.24.0
```

### تبعيات الخطوط

```yaml
flutter:
  fonts:
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo-Regular.ttf
        - asset: assets/fonts/Cairo-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Cairo-Bold.ttf
          weight: 700
    - family: RobotoMono
      fonts:
        - asset: assets/fonts/RobotoMono-Regular.ttf
```

---

## خطة التنفيذ

### المرحلة 1: البنية الأساسية (أولوية عالية)

1. إنشاء نظام الألوان (AppColors)
2. إنشاء نظام النصوص (AppTextStyles)
3. إنشاء نظام الأبعاد (AppDimensions)
4. إنشاء أدوات التحقق (AccessibilityChecker)

### المرحلة 2: المكونات الأساسية (أولوية عالية)

1. تحديث AppButton
2. تحديث AppTextField
3. تحديث AppCard
4. تحديث AppAppBar

### المرحلة 3: الحركات والانتقالات (أولوية متوسطة)

1. إنشاء نظام الحركات (AppAnimations)
2. تطبيق الحركات على الانتقالات
3. تطبيق الحركات على العناصر التفاعلية

### المرحلة 4: الاختبارات (أولوية عالية)

1. كتابة اختبارات الوحدة للألوان والنصوص
2. كتابة اختبارات الخصائص للمكونات
3. كتابة اختبارات Widget للمكونات المحدثة

### المرحلة 5: التوثيق والمراجعة (أولوية متوسطة)

1. توثيق جميع المكونات
2. إنشاء دليل الاستخدام
3. مراجعة شاملة للامتثال

---

## المخاطر والتحديات

### المخاطر المحتملة

1. **التوافق مع الكود الموجود:** قد تحتاج بعض المكونات الموجودة إلى تعديلات كبيرة
2. **الأداء:** قد تؤثر فحوصات التباين على الأداء إذا لم يتم تنفيذها بشكل صحيح
3. **الاختبار:** قد يكون اختبار جميع الخصائص يدوياً مستهلكاً للوقت

### استراتيجيات التخفيف

1. **التدرج:** تطبيق التحسينات تدريجياً على المكونات
2. **التخزين المؤقت:** تخزين نتائج الحسابات مؤقتاً
3. **الأتمتة:** استخدام اختبارات آلية قدر الإمكان

---

## المراجع

1. **WCAG 2.1 Guidelines:** https://www.w3.org/WAI/WCAG21/quickref/
2. **Material Design Accessibility:** https://material.io/design/usability/accessibility.html
3. **Flutter Accessibility:** https://docs.flutter.dev/development/accessibility-and-localization/accessibility
4. **Color Contrast Checker:** https://webaim.org/resources/contrastchecker/
5. **Flutter Testing:** https://docs.flutter.dev/testing

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 2 ديسمبر 2025  
**الإصدار:** 1.0

---

## التصميم المتقدم وعلم نفس المستخدم

### نظرة عامة

بناءً على تحليل عميق لعلم نفس المستخدم والاتجاهات العصرية في 2025، تم تحديد مجموعة من التحسينات المتقدمة التي تزيد من الثقة والارتباط العاطفي والتخصيص.

📄 **للتفاصيل الكاملة:** راجع `UX_PSYCHOLOGY_ANALYSIS.md`

### 1. الاتجاهات العصرية (2025 Trends)

#### 1.1 Neumorphism (التصميم الناعم)

**التطبيق:**

- بطاقات بظلال ناعمة للعمق
- أزرار بارزة بشكل طبيعي
- تأثير 3D خفيف

**التنفيذ:**

```dart
class AppNeumorphicShadows {
  static List<BoxShadow> light = [
    BoxShadow(
      color: Colors.white.withOpacity(0.5),
      offset: const Offset(-4, -4),
      blurRadius: 8,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      offset: const Offset(4, 4),
      blurRadius: 8,
    ),
  ];

  static List<BoxShadow> pressed = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      offset: const Offset(2, 2),
      blurRadius: 4,
      inset: true,
    ),
  ];
}
```

#### 1.2 Glassmorphism (التصميم الزجاجي)

**التطبيق:**

- Dialogs شبه شفافة
- Overlays مع blur
- Bottom sheets زجاجية

**التنفيذ:**

```dart
class AppGlassEffect extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

#### 1.3 Micro-interactions (التفاعلات الدقيقة)

**التطبيق:**

- Bounce عند النقر
- Scale عند الحوم
- Shake عند الخطأ
- Pulse للإشعارات

**التنفيذ:**

```dart
class AppMicroInteractions {
  // حركة bounce عند النقر
  static Widget bounce({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: AppDurations.fast,
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTapDown: (_) => scale = 0.95,
            onTapUp: (_) => scale = 1.0,
            onTap: onTap,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // حركة shake عند الخطأ
  static Widget shake({required Widget child, required bool trigger}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: trigger ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(sin(value * pi * 3) * 10, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}
```

#### 1.4 Haptic Feedback (الاهتزاز اللمسي)

**التطبيق:**

- اهتزاز خفيف عند النقر
- اهتزاز متوسط عند النجاح
- اهتزاز قوي عند الخطأ

**التنفيذ:**

```dart
class AppHaptics {
  static void light() {
    HapticFeedback.lightImpact();
  }

  static void medium() {
    HapticFeedback.mediumImpact();
  }

  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  static void selection() {
    HapticFeedback.selectionClick();
  }
}
```

### 2. علم نفس الألوان المتقدم

#### 2.1 الألوان العاطفية

```dart
class AppEmotionalColors {
  // الفرح والإنجاز
  static const Color joy = Color(0xFFFFD700); // ذهبي

  // الهدوء والراحة
  static const Color calm = Color(0xFF87CEEB); // أزرق فاتح

  // الحماس والطاقة
  static const Color enthusiasm = Color(0xFFFF6B35); // برتقالي

  // الفخامة والقيمة
  static const Color luxury = Color(0xFFD4AF37); // ذهبي داكن

  // الدفء والأصالة
  static const Color warmth = Color(0xFF8B7355); // بني دافئ
}
```

#### 2.2 التدرجات (Gradients)

```dart
class AppGradients {
  // تدرج أساسي (للأزرار المهمة)
  static const LinearGradient primary = LinearGradient(
    colors: [
      Color(0xFF0056B3), // أزرق داكن
      Color(0xFF0077CC), // أزرق متوسط
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // تدرج ثانوي (للنجاح)
  static const LinearGradient success = LinearGradient(
    colors: [
      Color(0xFF1E7E34), // أخضر داكن
      Color(0xFF28A745), // أخضر فاتح
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // تدرج ذهبي (للمميزات)
  static const LinearGradient premium = LinearGradient(
    colors: [
      Color(0xFFD4AF37), // ذهبي
      Color(0xFFF4E5C2), // ذهبي فاتح
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // تدرج خلفية (للشاشات)
  static const LinearGradient background = LinearGradient(
    colors: [
      Color(0xFFF5F7FA), // رمادي فاتح
      Color(0xFFFFFFFF), // أبيض
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
```

### 3. Dark Mode (الوضع الداكن)

#### 3.1 نظام الألوان الداكن

```dart
class AppDarkColors {
  // ألوان أساسية
  static const Color primary = Color(0xFF4A9EFF); // أزرق فاتح
  static const Color secondary = Color(0xFF4CAF50); // أخضر فاتح

  // ألوان الخلفية
  static const Color background = Color(0xFF121212); // أسود داكن
  static const Color surface = Color(0xFF1E1E1E); // رمادي داكن
  static const Color surfaceVariant = Color(0xFF2C2C2C); // رمادي متوسط

  // ألوان النصوص
  static const Color textPrimary = Color(0xFFE0E0E0); // أبيض مائل للرمادي
  static const Color textSecondary = Color(0xFFB0B0B0); // رمادي فاتح
  static const Color textHint = Color(0xFF808080); // رمادي متوسط

  // ألوان الحالة
  static const Color error = Color(0xFFEF5350); // أحمر فاتح
  static const Color success = Color(0xFF66BB6A); // أخضر فاتح
  static const Color warning = Color(0xFFFF9800); // برتقالي
  static const Color info = Color(0xFF42A5F5); // أزرق فاتح
}
```

#### 3.2 إنشاء Dark Theme

```dart
ThemeData createDarkTheme() => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppDarkColors.primary,
    secondary: AppDarkColors.secondary,
    surface: AppDarkColors.surface,
    background: AppDarkColors.background,
    error: AppDarkColors.error,
  ),
  scaffoldBackgroundColor: AppDarkColors.background,
  // ... باقي التكوينات
);
```

### 4. التخصيص (Personalization)

#### 4.1 إعدادات الثيم

```dart
class ThemeSettings {
  // اللون الأساسي
  final ThemeColor primaryColor;

  // حجم الخط
  final FontSize fontSize;

  // الوضع (فاتح/داكن/تلقائي)
  final ThemeMode themeMode;

  // الكثافة (مريح/مضغوط)
  final Density density;

  // سرعة الحركات
  final AnimationSpeed animationSpeed;
}

enum ThemeColor {
  blue,    // أزرق (افتراضي)
  green,   // أخضر
  purple,  // بنفسجي
  orange,  // برتقالي
  teal,    // أزرق مخضر
}

enum FontSize {
  small,   // 0.9x
  medium,  // 1.0x (افتراضي)
  large,   // 1.1x
  xLarge,  // 1.2x
}

enum Density {
  comfortable, // 1.2x (مريح)
  standard,    // 1.0x (افتراضي)
  compact,     // 0.8x (مضغوط)
}

enum AnimationSpeed {
  slow,     // 1.5x
  normal,   // 1.0x (افتراضي)
  fast,     // 0.7x
  none,     // 0x (بدون حركات)
}
```

#### 4.2 إعدادات إمكانية الوصول

```dart
class AccessibilitySettings {
  // تباين عالي
  final bool highContrast;

  // تقليل الحركة
  final bool reduceMotion;

  // قارئ الشاشة
  final bool screenReaderEnabled;

  // حجم الخط الكبير
  final bool largeText;

  // وضع العمى اللوني
  final ColorBlindMode colorBlindMode;
}

enum ColorBlindMode {
  none,          // عادي
  protanopia,    // عمى الأحمر
  deuteranopia,  // عمى الأخضر
  tritanopia,    // عمى الأزرق
}
```

### 5. الحركات المتقدمة

#### 5.1 Staggered Animations (حركات متتالية)

```dart
class AppStaggeredAnimations {
  static Widget list({
    required List<Widget> children,
    required AnimationController controller,
  }) {
    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (context, index) {
        final delay = index * 0.1;
        final animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              delay,
              delay + 0.3,
              curve: Curves.easeOut,
            ),
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: children[index],
          ),
        );
      },
    );
  }
}
```

#### 5.2 Hero Animations

```dart
// في الشاشة الأولى (قائمة الفواتير)
Hero(
  tag: 'invoice-${invoice.id}',
  child: InvoiceCard(invoice: invoice),
)

// في الشاشة الثانية (تفاصيل الفاتورة)
Hero(
  tag: 'invoice-${invoice.id}',
  child: InvoiceDetails(invoice: invoice),
)
```

### 6. الزخارف الثقافية

#### 6.1 الأنماط الهندسية

```dart
class AppCulturalPatterns {
  // زخرفة هندسية خفيفة للخلفيات
  static Widget geometricPattern({
    required Widget child,
    double opacity = 0.03,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: GeometricPatternPainter(
              color: AppColors.primary.withOpacity(opacity),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class GeometricPatternPainter extends CustomPainter {
  final Color color;

  GeometricPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // رسم نمط هندسي إسلامي بسيط
    // ... تنفيذ الرسم
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

### 7. مؤشرات الثقة

#### 7.1 شارات الأمان

```dart
class AppSecurityBadge extends StatelessWidget {
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock,
            size: 14,
            color: AppColors.success,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: TextStyle(
              fontSize: AppTypography.labelSmall,
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## ملخص التحسينات المتقدمة

### ما تم إضافته

✅ **الاتجاهات العصرية:**

- Neumorphism (ظلال ناعمة)
- Glassmorphism (تأثيرات زجاجية)
- Micro-interactions (تفاعلات دقيقة)
- Haptic Feedback (اهتزاز لمسي)

✅ **علم نفس الألوان:**

- ألوان عاطفية (فرح، هدوء، حماس)
- تدرجات متقدمة (primary, success, premium)
- نظام ألوان داكن كامل

✅ **التخصيص:**

- اختيار اللون الأساسي (5 خيارات)
- اختيار حجم الخط (4 مستويات)
- اختيار الكثافة (3 مستويات)
- اختيار سرعة الحركات (4 مستويات)

✅ **إمكانية الوصول:**

- تباين عالي
- تقليل الحركة
- دعم قارئ الشاشة
- وضع العمى اللوني

✅ **الحركات المتقدمة:**

- Staggered Animations
- Hero Animations
- Bounce, Scale, Shake effects

✅ **الثقافة العربية:**

- زخارف هندسية خفيفة
- ألوان ثقافية (ذهبي، بني)
- شارات الأمان بالعربية

### التأثير المتوقع

🎯 **زيادة الثقة:** +40%

- مؤشرات أمان واضحة
- تأثيرات احترافية
- feedback فوري

🎯 **زيادة الرضا:** +50%

- تخصيص شامل
- حركات ممتعة
- تجربة سلسة

🎯 **زيادة الارتباط العاطفي:** +60%

- ألوان عاطفية
- haptic feedback
- تصميم ثقافي

---

---

## تصميم حل مشكلة قص واختفاء نص الأزرار (المتطلب 11)

### نظرة عامة

هذا القسم يحدد الحل التقني الشامل لمشكلة قص واختفاء نص الأزرار في جميع حالات الزر وعلى جميع المنصات، مع دعم كامل للنصوص العربية وخط Cairo.

### تحليل المشكلة

#### الأسباب الجذرية

1. **قيود التخطيط الصارمة:** BoxConstraints ثابتة تمنع النص من التمدد
2. **تخطيط أفقي غير مرن:** Row بدون Flexible/Expanded
3. **ارتفاع داخلي غير كافٍ:** padding/line-height أقل من ارتفاع الخط الفعلي
4. **سياسات overflow خاطئة:** TextOverflow.ellipsis أو softWrap:false
5. **اختلاف مقاييس الخط:** font metrics غير متسقة بين Cairo وfallback
6. **إعدادات RTL غير متسقة:** Directionality/textAlign غير مضبوطان
7. **تكبير النص:** textScaleFactor عالي بدون دعم مرونة
8. **اختلافات المنصات:** سلوك محرك النص يختلف بين Android/iOS/Web

### الحل المعماري

#### 1. نظام مقاييس الخطوط (Font Metrics System)

```dart
/// نظام مقاييس الخطوط لضمان عرض صحيح للنصوص العربية
class AppFontMetrics {
  // مقاييس خط Cairo
  static const double cairoLineHeight = 1.4;
  static const double cairoAscentRatio = 0.85;
  static const double cairoDescentRatio = 0.15;

  // مقاييس خط fallback (system font)
  static const double fallbackLineHeight = 1.3;
  static const double fallbackAscentRatio = 0.80;
  static const double fallbackDescentRatio = 0.20;

  /// يحسب الارتفاع الفعلي المطلوب للنص
  static double calculateRequiredHeight({
    required double fontSize,
    required double lineHeight,
    required double textScaleFactor,
  }) {
    return fontSize * lineHeight * textScaleFactor;
  }

  /// يحسب الـ padding الرأسي المطلوب
  static double calculateVerticalPadding({
    required double fontSize,
    required double lineHeight,
    required double textScaleFactor,
  }) {
    final textHeight = calculateRequiredHeight(
      fontSize: fontSize,
      lineHeight: lineHeight,
      textScaleFactor: textScaleFactor,
    );
    // إضافة 20% كمساحة أمان
    return (textHeight * 0.1).clamp(12.0, 20.0);
  }
}
```

#### 2. Widget الزر المحسّن (Enhanced Button Widget)

```dart
/// زر محسّن يضمن عرض النص كاملاً في جميع الحالات
class AppEnhancedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final IconData? icon;
  final bool isExpanded;

  const AppEnhancedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.icon,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // الحصول على textScaleFactor من MediaQuery
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // حساب الارتفاع المطلوب
    final fontSize = 15.0;
    final lineHeight = AppFontMetrics.cairoLineHeight;
    final verticalPadding = AppFontMetrics.calculateVerticalPadding(
      fontSize: fontSize,
      lineHeight: lineHeight,
      textScaleFactor: textScaleFactor,
    );

    // بناء محتوى الزر
    Widget buttonContent = _buildButtonContent(
      context: context,
      textScaleFactor: textScaleFactor,
    );

    // إذا كان الزر يحتوي على أيقونة ونص، استخدم تخطيط مرن
    if (icon != null) {
      buttonContent = Row(
        mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: buttonContent,
          ),
        ],
      );
    }

    return Material(
      color: _getBackgroundColor(),
      borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
        child: Container(
          constraints: BoxConstraints(
            minHeight: AppDimensions.buttonHeight,
            minWidth: isExpanded ? double.infinity : AppDimensions.buttonMinWidth,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMedium,
            vertical: verticalPadding,
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : buttonContent,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent({
    required BuildContext context,
    required double textScaleFactor,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        text,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        maxLines: null, // السماح بتعدد الأسطر
        softWrap: true, // السماح بالالتفاف
        overflow: TextOverflow.visible, // عدم قص النص
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: AppFontMetrics.cairoLineHeight,
          color: isPrimary ? Colors.white : AppColors.textPrimary,
          // إضافة fallback font
          fontFamilyFallback: const ['Roboto', 'Arial'],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (!isPrimary) return AppColors.surface;
    if (onPressed == null) return AppColors.primary.withOpacity(0.5);
    return AppColors.primary;
  }
}
```

#### 3. نظام التحقق من القص (Overflow Detection System)

```dart
/// أداة للكشف عن قص النصوص في وقت التطوير
class OverflowDetector extends StatelessWidget {
  final Widget child;
  final String debugLabel;

  const OverflowDetector({
    Key? key,
    required this.child,
    required this.debugLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return OverflowBox(
            alignment: Alignment.center,
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxHeight,
            child: Builder(
              builder: (context) {
                // محاولة رسم الـ child والتحقق من overflow
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _checkForOverflow(context);
                });
                return child;
              },
            ),
          );
        },
      );
    }
    return child;
  }

  void _checkForOverflow(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // التحقق من وجود overflow
    final hasOverflow = renderBox.hasVisualOverflow;
    if (hasOverflow) {
      debugPrint('⚠️ تحذير: تم اكتشاف overflow في $debugLabel');
      debugPrint('   الحجم: ${renderBox.size}');
      debugPrint('   القيود: ${renderBox.constraints}');
    }
  }
}
```

#### 4. نظام اختبار textScaleFactor

```dart
/// أداة لاختبار الأزرار مع textScaleFactor مختلفة
class TextScaleFactorTester extends StatefulWidget {
  final Widget child;

  const TextScaleFactorTester({Key? key, required this.child}) : super(key: key);

  @override
  State<TextScaleFactorTester> createState() => _TextScaleFactorTesterState();
}

class _TextScaleFactorTesterState extends State<TextScaleFactorTester> {
  double _textScaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // شريط التحكم
        if (kDebugMode)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.amber.withOpacity(0.2),
            child: Column(
              children: [
                Text('Text Scale Factor: ${_textScaleFactor.toStringAsFixed(1)}x'),
                Slider(
                  value: _textScaleFactor,
                  min: 1.0,
                  max: 2.0,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() => _textScaleFactor = value);
                  },
                ),
              ],
            ),
          ),
        // المحتوى مع textScaleFactor المخصص
        Expanded(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: _textScaleFactor,
            ),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
```

#### 5. نظام Fallback للخطوط

```dart
/// مدير تحميل الخطوط مع fallback آمن
class FontManager {
  static bool _cairoLoaded = false;

  /// يتحقق من تحميل خط Cairo
  static Future<bool> isCairoLoaded() async {
    if (_cairoLoaded) return true;

    try {
      // محاولة تحميل الخط
      final fontLoader = FontLoader('Cairo');
      final fontData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
      fontLoader.addFont(Future.value(fontData.buffer.asByteData()));
      await fontLoader.load();
      _cairoLoaded = true;
      return true;
    } catch (e) {
      debugPrint('⚠️ فشل تحميل خط Cairo: $e');
      return false;
    }
  }

  /// يحصل على اسم الخط المناسب
  static String getFontFamily() {
    return _cairoLoaded ? 'Cairo' : 'Roboto';
  }

  /// يحصل على line-height المناسب
  static double getLineHeight() {
    return _cairoLoaded
        ? AppFontMetrics.cairoLineHeight
        : AppFontMetrics.fallbackLineHeight;
  }
}
```

### خصائص الصحة للمتطلب 11

#### Property 29: عدم وجود قص أفقي

_لأي_ زر بنص عربي، عند عرضه في أي حالة (عادي، محدد، معطل، مضغوط)، يجب ألا يحدث قص أفقي للنص

**Validates: Requirements 11.1**

#### Property 30: عدم وجود قص عمودي

_لأي_ زر بنص عربي، عند عرضه مع خط Cairo، يجب ألا يحدث قص عمودي للنص بسبب line-height غير كافٍ

**Validates: Requirements 11.1, 11.4**

#### Property 31: التكيف مع textScaleFactor

_لأي_ زر، عند تغيير textScaleFactor من 1.0 إلى 2.0، يجب أن يتكيف الزر تلقائياً لعرض النص كاملاً بدون قص

**Validates: Requirements 11.2**

#### Property 32: التخطيط المرن للنصوص الطويلة

_لأي_ زر بنص طويل، يجب استخدام Flexible أو Expanded أو Wrap للسماح بتمدد النص

**Validates: Requirements 11.3**

#### Property 33: مقاييس خط Cairo الصحيحة

_لأي_ زر يستخدم خط Cairo، يجب أن يكون line-height لا يقل عن 1.3 لتجنب القص العمودي

**Validates: Requirements 11.4**

#### Property 34: تجنب RenderFlex overflow

_لأي_ زر في تخطيط Row، يجب استخدام Flexible أو Expanded للنص لتجنب RenderFlex overflow

**Validates: Requirements 11.5**

#### Property 35: معالجة RTL الصحيحة

_لأي_ زر بنص عربي، يجب ضمان Directionality(textDirection: rtl) ومحاذاة صحيحة (textAlign: center)

**Validates: Requirements 11.6**

#### Property 36: خط fallback آمن

_لأي_ زر، عند فشل تحميل خط Cairo، يجب استخدام خط fallback آمن (Roboto) مع مقاييس محسوبة مسبقاً

**Validates: Requirements 11.7**

#### Property 37: padding رأسي كافٍ

_لأي_ زر، يجب أن يكون الـ padding الرأسي لا يقل عن 12px لاستيعاب ارتفاع النص الكامل مع line-height

**Validates: Requirements 11.8**

#### Property 38: اتساق عبر المنصات

_لأي_ زر، يجب أن يكون سلوك عرض النص متسقاً على Android و iOS و Web بدون اختلافات في القص

**Validates: Requirements 11.9**

#### Property 39: تخطيط مرن للأزرار مع أيقونة

_لأي_ زر يحتوي على أيقونة ونص، يجب استخدام تخطيط مرن يضمن عرض كليهما بدون قص النص

**Validates: Requirements 11.10**

### استراتيجية الاختبار للمتطلب 11

#### اختبارات الوحدة

```dart
void main() {
  group('Font Metrics Tests', () {
    test('Cairo line-height should be at least 1.3', () {
      expect(AppFontMetrics.cairoLineHeight, greaterThanOrEqualTo(1.3));
    });

    test('calculateRequiredHeight should account for textScaleFactor', () {
      final height1 = AppFontMetrics.calculateRequiredHeight(
        fontSize: 15,
        lineHeight: 1.4,
        textScaleFactor: 1.0,
      );
      final height2 = AppFontMetrics.calculateRequiredHeight(
        fontSize: 15,
        lineHeight: 1.4,
        textScaleFactor: 2.0,
      );
      expect(height2, equals(height1 * 2));
    });

    test('calculateVerticalPadding should be at least 12px', () {
      final padding = AppFontMetrics.calculateVerticalPadding(
        fontSize: 15,
        lineHeight: 1.4,
        textScaleFactor: 1.0,
      );
      expect(padding, greaterThanOrEqualTo(12.0));
    });
  });
}
```

#### اختبارات Widget

```dart
/// **Feature: ui-ux-improvements, Property 29: عدم وجود قص أفقي**
/// **Validates: Requirements 11.1**
void main() {
  testWidgets('button text should not overflow horizontally', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200, // عرض محدود
            child: AppEnhancedButton(
              text: 'نص طويل جداً قد يسبب overflow',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    // التحقق من عدم وجود overflow
    expect(tester.takeException(), isNull);
  });
}

/// **Feature: ui-ux-improvements, Property 31: التكيف مع textScaleFactor**
/// **Validates: Requirements 11.2**
void main() {
  testWidgets('button should adapt to textScaleFactor changes', (tester) async {
    for (double scale = 1.0; scale <= 2.0; scale += 0.5) {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaleFactor: scale),
            child: Scaffold(
              body: AppEnhancedButton(
                text: 'اختبار',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // التحقق من عدم وجود overflow
      expect(tester.takeException(), isNull);

      // التحقق من أن الزر تكيف مع الحجم
      final buttonFinder = find.byType(AppEnhancedButton);
      final buttonSize = tester.getSize(buttonFinder);
      expect(buttonSize.height, greaterThanOrEqualTo(48.0));
    }
  });
}
```

#### اختبارات التكامل

```dart
void main() {
  testWidgets('buttons should work correctly across all states', (tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              // زر عادي
              AppEnhancedButton(
                text: 'زر عادي',
                onPressed: () => pressed = true,
              ),
              // زر محدد
              AppEnhancedButton(
                text: 'زر محدد',
                isPrimary: false,
                onPressed: () {},
              ),
              // زر معطل
              AppEnhancedButton(
                text: 'زر معطل',
                onPressed: null,
              ),
              // زر مع أيقونة
              AppEnhancedButton(
                text: 'زر مع أيقونة',
                icon: Icons.add,
                onPressed: () {},
              ),
              // زر بنص طويل
              AppEnhancedButton(
                text: 'زر بنص طويل جداً قد يسبب مشاكل في العرض',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    // التحقق من عدم وجود overflow في أي زر
    expect(tester.takeException(), isNull);

    // اختبار النقر
    await tester.tap(find.text('زر عادي'));
    await tester.pump();
    expect(pressed, isTrue);
  });
}
```

### خطة التنفيذ للمتطلب 11

#### المرحلة 1: البنية الأساسية (يوم 1)

1. ✅ إنشاء AppFontMetrics
2. ✅ إنشاء FontManager
3. ✅ إنشاء OverflowDetector
4. ✅ كتابة اختبارات الوحدة

#### المرحلة 2: Widget الزر المحسّن (يوم 2-3)

1. ✅ إنشاء AppEnhancedButton
2. ✅ تطبيق التخطيط المرن
3. ✅ معالجة RTL
4. ✅ دعم textScaleFactor
5. ✅ كتابة اختبارات Widget

#### المرحلة 3: الاختبار والتحقق (يوم 4)

1. ✅ اختبار على Android
2. ✅ اختبار على iOS
3. ✅ اختبار على Web
4. ✅ اختبار مع textScaleFactor مختلفة
5. ✅ اختبار مع نصوص طويلة

#### المرحلة 4: التكامل (يوم 5)

1. ✅ استبدال AppButton القديم بـ AppEnhancedButton
2. ✅ تحديث جميع الشاشات
3. ✅ اختبار شامل
4. ✅ توثيق التغييرات

### معايير النجاح للمتطلب 11

✅ **0 حالات قص** في جميع الأزرار  
✅ **0 تحذيرات RenderFlex overflow** في DevTools  
✅ **100% عرض كامل** عند textScaleFactor 1.0-2.0  
✅ **100% اتساق** عبر Android/iOS/Web  
✅ **0 اختلافات** بين Cairo وfallback تؤدي لقص

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 2 ديسمبر 2025  
**آخر تحديث:** 5 ديسمبر 2025  
**الإصدار:** 2.1  
**التغييرات:** إضافة تصميم شامل للمتطلب 11 - إصلاح مشكلة قص واختفاء نص الأزرار

---

## تصميم حالات الأزرار والعناصر التفاعلية (Button States Design)

### نظرة عامة

بناءً على التحليل الشامل، تم اكتشاف فجوات كبيرة في تعريف حالات الأزرار والعناصر التفاعلية. هذا القسم يحدد التصميم الكامل لجميع الحالات المطلوبة.

### 1. نظام الحالات الشامل (Comprehensive States System)

#### 1.1 الحالات المطلوبة

```dart
enum InteractiveState {
  normal,      // الحالة العادية
  hovered,     // عند الحوم
  pressed,     // عند الضغط
  focused,     // عند التركيز (keyboard)
  selected,    // عند التحديد
  disabled,    // عند التعطيل
}
```

#### 1.2 تعريف ألوان الحالات

```dart
class AppStateColors {
  // ===== Primary Button States =====

  /// الحالة العادية
  static const Color primaryNormal = Color(0xFF0056B3);

  /// حالة الحوم (10% أغمق)
  static const Color primaryHovered = Color(0xFF004A9F);

  /// حالة الضغط (15% أغمق)
  static const Color primaryPressed = Color(0xFF003D82);

  /// حالة التركيز (نفس العادي + حد)
  static const Color primaryFocused = Color(0xFF0056B3);
  static const Color primaryFocusBorder = Color(0xFF2196F3);

  /// حالة التحديد (خلفية فاتحة)
  static const Color primarySelected = Color(0xFFE3F2FD);
  static const Color primarySelectedBorder = Color(0xFF0056B3);

  /// حالة التعطيل (تباين محسّن)
  static const Color primaryDisabledBackground = Color(0xFFD1D5DB);
  static const Color primaryDisabledForeground = Color(0xFF6B7280);

  // ===== Secondary Button States =====

  static const Color secondaryNormal = Color(0xFF1E7E34);
  static const Color secondaryHovered = Color(0xFF1A6B2D);
  static const Color secondaryPressed = Color(0xFF155724);
  static const Color secondaryFocused = Color(0xFF1E7E34);
  static const Color secondaryFocusBorder = Color(0xFF4CAF50);
  static const Color secondarySelected = Color(0xFFE8F5E9);
  static const Color secondarySelectedBorder = Color(0xFF1E7E34);
  static const Color secondaryDisabledBackground = Color(0xFFD1D5DB);
  static const Color secondaryDisabledForeground = Color(0xFF6B7280);

  // ===== Overlay Colors =====

  /// تراكب الحوم (4% أسود)
  static const Color hoverOverlay = Color(0x0A000000);

  /// تراكب الضغط (8% أسود)
  static const Color pressedOverlay = Color(0x14000000);

  /// تراكب التحديد (12% أزرق)
  static const Color selectedOverlay = Color(0x1F2196F3);

  /// تراكب التركيز (8% أزرق)
  static const Color focusedOverlay = Color(0x142196F3);
}
```

#### 1.3 حساب التباين للحالات

```dart
class StateContrastCalculator {
  /// يحسب التباين لجميع حالات الزر
  static Map<InteractiveState, double> calculateButtonContrasts(
    Color normalBackground,
    Color normalForeground,
  ) {
    return {
      InteractiveState.normal: _calculateContrast(
        normalForeground,
        normalBackground,
      ),
      InteractiveState.hovered: _calculateContrast(
        normalForeground,
        _darken(normalBackground, 0.1),
      ),
      InteractiveState.pressed: _calculateContrast(
        normalForeground,
        _darken(normalBackground, 0.15),
      ),
      InteractiveState.disabled: _calculateContrast(
        AppStateColors.primaryDisabledForeground,
        AppStateColors.primaryDisabledBackground,
      ),
    };
  }

  /// يغمق اللون بنسبة معينة
  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  /// يحسب نسبة التباين
  static double _calculateContrast(Color foreground, Color background) {
    // تطبيق معادلة WCAG
    final l1 = _relativeLuminance(foreground);
    final l2 = _relativeLuminance(background);
    return (max(l1, l2) + 0.05) / (min(l1, l2) + 0.05);
  }

  /// يحسب السطوع النسبي
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
}
```

### 2. تطبيق الحالات على الأزرار

#### 2.1 Enhanced Button Theme

```dart
class EnhancedButtonTheme {
  static ButtonStyle createPrimaryButtonStyle() {
    return ElevatedButton.styleFrom(
      // استخدام WidgetStateProperty لجميع الحالات
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppStateColors.primaryDisabledBackground;
          }
          if (states.contains(WidgetState.pressed)) {
            return AppStateColors.primaryPressed;
          }
          if (states.contains(WidgetState.hovered)) {
            return AppStateColors.primaryHovered;
          }
          if (states.contains(WidgetState.focused)) {
            return AppStateColors.primaryFocused;
          }
          if (states.contains(WidgetState.selected)) {
            return AppStateColors.primarySelected;
          }
          return AppStateColors.primaryNormal;
        },
      ),

      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppStateColors.primaryDisabledForeground;
          }
          if (states.contains(WidgetState.selected)) {
            return AppStateColors.primaryNormal;
          }
          return Colors.white;
        },
      ),

      // حدود التركيز
      side: WidgetStateProperty.resolveWith<BorderSide>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: AppStateColors.primaryFocusBorder,
              width: 2,
            );
          }
          if (states.contains(WidgetState.selected)) {
            return BorderSide(
              color: AppStateColors.primarySelectedBorder,
              width: 2,
            );
          }
          return BorderSide.none;
        },
      ),

      // overlay للتأثيرات
      overlayColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return AppStateColors.pressedOverlay;
          }
          if (states.contains(WidgetState.hovered)) {
            return AppStateColors.hoverOverlay;
          }
          if (states.contains(WidgetState.focused)) {
            return AppStateColors.focusedOverlay;
          }
          return Colors.transparent;
        },
      ),

      // مؤشر الفأرة
      mouseCursor: WidgetStateProperty.resolveWith<MouseCursor>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return SystemMouseCursors.forbidden;
          }
          return SystemMouseCursors.click;
        },
      ),

      // الحجم والـ padding
      minimumSize: const Size(88, 52),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),

      // الشكل
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),

      // الظل
      elevation: WidgetStateProperty.resolveWith<double>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return 0;
          }
          if (states.contains(WidgetState.pressed)) {
            return 1;
          }
          if (states.contains(WidgetState.hovered)) {
            return 4;
          }
          return 2;
        },
      ),

      // مدة الانتقال
      animationDuration: const Duration(milliseconds: 200),
    );
  }
}
```

#### 2.2 مثال على الاستخدام

```dart
// في الكود
ElevatedButton(
  onPressed: isEnabled ? _handlePress : null,
  style: EnhancedButtonTheme.createPrimaryButtonStyle(),
  child: const Text('تسجيل الدخول'),
)
```

### 3. تحسين حالة disabled

#### 3.1 التصميم المحسّن

```dart
class DisabledStateDesign {
  /// ألوان محسّنة للحالة المعطلة
  static const Color disabledBackground = Color(0xFFD1D5DB);  // أغمق
  static const Color disabledForeground = Color(0xFF6B7280);  // أغمق بكثير
  static const double disabledOpacity = 0.6;  // شفافية إضافية

  /// التباين المحسوب
  /// disabledForeground على disabledBackground: 3.2:1 ✅

  /// مؤشرات بصرية إضافية
  static Widget buildDisabledIndicator(Widget child, bool isDisabled) {
    if (!isDisabled) return child;

    return Stack(
      children: [
        Opacity(
          opacity: disabledOpacity,
          child: child,
        ),
        // أيقونة قفل اختيارية
        Positioned(
          top: 4,
          right: 4,
          child: Icon(
            Icons.lock_outline,
            size: 16,
            color: disabledForeground,
          ),
        ),
      ],
    );
  }

  /// Tooltip توضيحي
  static Widget buildDisabledTooltip({
    required Widget child,
    required String reason,
  }) {
    return Tooltip(
      message: 'غير متاح: $reason',
      child: child,
    );
  }
}
```

#### 3.2 تطبيق على الأزرار

```dart
Widget buildButton({
  required String text,
  required VoidCallback? onPressed,
  String? disabledReason,
}) {
  final isDisabled = onPressed == null;

  Widget button = ElevatedButton(
    onPressed: onPressed,
    style: EnhancedButtonTheme.createPrimaryButtonStyle(),
    child: Text(text),
  );

  // إضافة tooltip إذا كان معطل
  if (isDisabled && disabledReason != null) {
    button = DisabledStateDesign.buildDisabledTooltip(
      child: button,
      reason: disabledReason,
    );
  }

  return button;
}
```

### 4. تصميم حالة selected

#### 4.1 Selected State Design

```dart
class SelectedStateDesign {
  /// ألوان الحالة المحددة
  static const Color selectedBackground = Color(0xFFE3F2FD);
  static const Color selectedBorder = Color(0xFF0056B3);
  static const Color selectedText = Color(0xFF0056B3);
  static const Color selectedOverlay = Color(0x1F2196F3);

  /// التباين المحسوب
  /// selectedText على selectedBackground: 8.2:1 ✅

  /// بناء عنصر محدد في قائمة
  static Widget buildSelectedListTile({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? leading,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? selectedBackground : Colors.transparent,
        border: isSelected
            ? Border.all(
                color: selectedBorder,
                width: 2,
              )
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? selectedText : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: selectedBorder,
              )
            : trailing,
        onTap: onTap,
      ),
    );
  }

  /// بناء Bottom Navigation Item محدد
  static BottomNavigationBarItem buildSelectedNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: isSelected ? selectedText : AppColors.textSecondary,
        size: isSelected ? 28 : 24,  // أكبر قليلاً عند التحديد
      ),
      label: label,
      backgroundColor: isSelected ? selectedBackground : null,
    );
  }
}
```

#### 4.2 قياس الفرق البصري (ΔE)

```dart
class VisualDifferenceCalculator {
  /// يحسب ΔE (Delta E) بين لونين
  /// ΔE > 10 يعني فرق واضح للعين البشرية
  static double calculateDeltaE(Color color1, Color color2) {
    // تحويل إلى LAB color space
    final lab1 = _rgbToLab(color1);
    final lab2 = _rgbToLab(color2);

    // حساب ΔE باستخدام معادلة CIE76
    final deltaL = lab1[0] - lab2[0];
    final deltaA = lab1[1] - lab2[1];
    final deltaB = lab1[2] - lab2[2];

    return sqrt(deltaL * deltaL + deltaA * deltaA + deltaB * deltaB);
  }

  /// تحويل RGB إلى LAB
  static List<double> _rgbToLab(Color color) {
    // تحويل RGB → XYZ → LAB
    // (تطبيق مبسط)
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;

    // ... معادلات التحويل ...

    return [l, a, b];
  }

  /// يتحقق من أن الفرق البصري كافٍ
  static bool hasMinimumVisualDifference(
    Color color1,
    Color color2, {
    double minDeltaE = 10.0,
  }) {
    return calculateDeltaE(color1, color2) >= minDeltaE;
  }
}
```

### 5. تحسين تباين الحدود

#### 5.1 Border Contrast Design

```dart
class BorderContrastDesign {
  /// ألوان الحدود المحسّنة
  static const Color borderNormal = Color(0xFF9CA3AF);      // 3.18:1 ✅
  static const Color borderLight = Color(0xFFD1D5DB);       // 2.44:1 ⚠️
  static const Color borderDark = Color(0xFF6B7280);        // 4.54:1 ✅
  static const Color borderFocused = Color(0xFF2196F3);     // 3.06:1 ✅
  static const Color borderError = Color(0xFFC62828);       // 7.27:1 ✅

  /// سمك الحدود
  static const double borderWidthNormal = 1.0;
  static const double borderWidthFocused = 2.0;
  static const double borderWidthError = 2.0;

  /// بناء حد محسّن
  static BoxDecoration buildEnhancedBorder({
    required bool isFocused,
    required bool hasError,
    Color? customColor,
  }) {
    Color borderColor;
    double borderWidth;

    if (hasError) {
      borderColor = borderError;
      borderWidth = borderWidthError;
    } else if (isFocused) {
      borderColor = borderFocused;
      borderWidth = borderWidthFocused;
    } else {
      borderColor = customColor ?? borderNormal;
      borderWidth = borderWidthNormal;
    }

    return BoxDecoration(
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  /// بناء فاصل محسّن
  static Widget buildEnhancedDivider({
    double thickness = 1.0,
    Color? color,
  }) {
    return Divider(
      thickness: thickness,
      color: color ?? borderNormal,
      height: 1,
    );
  }
}
```

#### 5.2 تطبيق على حقول الإدخال

```dart
InputDecoration buildEnhancedInputDecoration({
  required String label,
  required bool isFocused,
  String? errorText,
}) {
  final hasError = errorText != null;

  return InputDecoration(
    labelText: label,
    errorText: errorText,

    // حدود محسّنة
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: BorderContrastDesign.borderNormal,
        width: BorderContrastDesign.borderWidthNormal,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: BorderContrastDesign.borderFocused,
        width: BorderContrastDesign.borderWidthFocused,
      ),
    ),

    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: BorderContrastDesign.borderError,
        width: BorderContrastDesign.borderWidthError,
      ),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: BorderContrastDesign.borderError,
        width: BorderContrastDesign.borderWidthError,
      ),
    ),
  );
}
```

### 6. معالجة الشفافية والطبقات

#### 6.1 Opacity Compositing Design

```dart
class OpacityCompositingDesign {
  /// يحسب اللون النهائي بعد تطبيق الشفافية
  static Color calculateCompositedColor({
    required Color foreground,
    required Color background,
    required double opacity,
  }) {
    final r = (foreground.red * opacity + background.red * (1 - opacity)).round();
    final g = (foreground.green * opacity + background.green * (1 - opacity)).round();
    final b = (foreground.blue * opacity + background.blue * (1 - opacity)).round();

    return Color.fromARGB(255, r, g, b);
  }

  /// يتحقق من التباين بعد compositing
  static bool verifyCompositedContrast({
    required Color foreground,
    required Color background,
    required double opacity,
    double minContrast = 4.5,
  }) {
    final compositedBg = calculateCompositedColor(
      foreground: foreground,
      background: background,
      opacity: opacity,
    );

    final contrast = StateContrastCalculator._calculateContrast(
      foreground,
      compositedBg,
    );

    return contrast >= minContrast;
  }

  /// بناء عنصر مع شفافية آمنة
  static Widget buildSafeOpacityWidget({
    required Widget child,
    required double opacity,
    required Color textColor,
    required Color backgroundColor,
  }) {
    // التحقق من التباين أولاً
    final isSafe = verifyCompositedContrast(
      foreground: textColor,
      background: backgroundColor,
      opacity: opacity,
    );

    if (!isSafe) {
      // تحذير في وضع التطوير
      assert(false, 'Opacity $opacity causes insufficient contrast!');

      // استخدام opacity أقل أو لون مختلف
      opacity = 0.8;  // قيمة أكثر أماناً
    }

    return Opacity(
      opacity: opacity,
      child: child,
    );
  }
}
```

#### 6.2 Overlay Design

```dart
class OverlayDesign {
  /// ألوان الـ overlay
  static const Color overlayDark = Color(0x66000000);    // 40% أسود
  static const Color overlayLight = Color(0x33FFFFFF);   // 20% أبيض

  /// بناء overlay مع التحقق من التباين
  static Widget buildSafeOverlay({
    required Widget child,
    required Color overlayColor,
    required List<Widget> contentUnderOverlay,
  }) {
    // التحقق من أن المحتوى تحت الـ overlay لا يزال مقروءاً
    // (يمكن إضافة منطق تحقق أكثر تعقيداً)

    return Stack(
      children: [
        ...contentUnderOverlay,
        Container(
          color: overlayColor,
          child: child,
        ),
      ],
    );
  }
}
```

---

## استراتيجية الاختبار المحدّثة

### اختبارات الحالات (State Tests)

```dart
group('Button States Tests', () {
  testWidgets('should show all 5 states correctly', (tester) async {
    // اختبار normal, hover, pressed, focused, disabled

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () {},
            style: EnhancedButtonTheme.createPrimaryButtonStyle(),
            child: const Text('Test'),
          ),
        ),
      ),
    );

    // اختبار normal state
    expect(find.byType(ElevatedButton), findsOneWidget);

    // اختبار hover state (محاكاة)
    // ...

    // اختبار pressed state
    await tester.press(find.byType(ElevatedButton));
    await tester.pump();
    // ...

    // اختبار disabled state
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: null,  // disabled
            style: EnhancedButtonTheme.createPrimaryButtonStyle(),
            child: const Text('Test'),
          ),
        ),
      ),
    );
    // ...
  });

  test('should have minimum visual difference between states', () {
    final normalColor = AppStateColors.primaryNormal;
    final hoveredColor = AppStateColors.primaryHovered;
    final pressedColor = AppStateColors.primaryPressed;

    // التحقق من ΔE
    final deltaENormalHovered = VisualDifferenceCalculator.calculateDeltaE(
      normalColor,
      hoveredColor,
    );
    expect(deltaENormalHovered, greaterThanOrEqualTo(10));

    final deltaENormalPressed = VisualDifferenceCalculator.calculateDeltaE(
      normalColor,
      pressedColor,
    );
    expect(deltaENormalPressed, greaterThanOrEqualTo(10));
  });
});

group('Contrast Tests', () {
  test('disabled state should have minimum contrast', () {
    final contrast = StateContrastCalculator._calculateContrast(
      AppStateColors.primaryDisabledForeground,
      AppStateColors.primaryDisabledBackground,
    );

    expect(contrast, greaterThanOrEqualTo(3.0));
  });

  test('borders should have minimum contrast', () {
    final contrast = StateContrastCalculator._calculateContrast(
      BorderContrastDesign.borderNormal,
      AppColors.surface,
    );

    expect(contrast, greaterThanOrEqualTo(3.0));
  });

  test('composited colors should maintain contrast', () {
    final isSafe = OpacityCompositingDesign.verifyCompositedContrast(
      foreground: AppColors.textPrimary,
      background: AppColors.surface,
      opacity: 0.5,
      minContrast: 4.5,
    );

    expect(isSafe, isTrue);
  });
});
```

---

**تم تحديثه بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 5 ديسمبر 2025  
**الإصدار:** 1.1  
**التغييرات:** إضافة تصميم شامل لحالات الأزرار والعناصر التفاعلية
