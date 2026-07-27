# دليل اختبار إمكانية الوصول (Accessibility Testing Guide)

**المشروع:** بصير - نظام المحاسبة الذكي  
**الإصدار:** 1.0  
**التاريخ:** 26 يوليو 2026  
**المؤلف:** فريق وكلاء تطوير مشروع بصير

---

## نظرة عامة

هذا الدليل يوفر إرشادات لاختبار إمكانية الوصول في تطبيق بصير لضمان امتثاله لمعايير WCAG 2.1 Level AA.

---

## أنواع اختبارات إمكانية الوصول

### 1. اختبار قارئ الشاشة (Screen Reader Testing)

#### الإعداد على Android (TalkBack)

1. **تفعيل TalkBack:**
   - الإعدادات → الوصولية → TalkBack → تفعيل
   - أو: الإعدادات → الوصولية → أجهزة الوصول → TalkBack

2. **التنقل الأساسي:**
   - **النقر:** تحديد العنصر
   - **النقر المزدوج:** تفعيل العنصر
   - **السحب ببطء:** استكشاف العناصر
   - **السحب بسرعة:** الانتقال بين العناصر

3. **اختبار شامل:**
   ```
   □ قراءة جميع العناوين بشكل صحيح
   □ قراءة الأزرار مع وصف الإجراء
   □ قراءة حقول الإدخال مع التسميات
   □ قراءة رسائل الخطأ والتحذير
   □ قراءة حالة العناصر (معطل، محدد)
   □ قراءة قيم القوائم والجداول
   ```

#### اختبار Semantics في Flutter

```dart
// اختبار وحدة للتحقق من Semantics
testWidgets('button should have proper semantics', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AppEnhancedButton(
          text: 'حفظ',
          onPressed: () {},
        ),
      ),
    ),
  );

  // التحقق من وجود Semantics
  expect(
    tester.getSemantics(find.byType(AppEnhancedButton)),
    matchesSemantics(
      label: 'حفظ',
      button: true,
      enabled: true,
      hasTapAction: true,
    ),
  );
});
```

---

### 2. اختبار التنقل بلوحة المفاتيح

#### الأجهزة المدعومة
- **Android:** لوحة مفاتيح خارجية أو مدمجة
- **Flutter Web:** التنقل الكامل بلوحة المفاتيح

#### مفاتيح التنقل الأساسية

| المفتاح | الوظيفة |
|---------|---------|
| `Tab` | الانتقال للعنصر التالي |
| `Shift + Tab` | الانتقال للعنصر السابق |
| `Enter` / `Space` | تفعيل العنصر |
| `Arrow Keys` | التنقل داخل القوائم |
| `Escape` | إغلاق النوافذ الحوارية |

#### اختبار مؤشر التركيز

```dart
// اختبار وحدة للتحقق من مؤشر التركيز
testWidgets('focus indicator should be visible', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Focus(
          child: AppTextField(
            label: 'الاسم',
          ),
        ),
      ),
    ),
  );

  // التركيز على الحقل
  final focusNode = tester.widget<Focus>(find.byType(Focus)).focusNode!;
  focusNode.requestFocus();
  await tester.pump();

  // التحقق من مؤشر التركيز
  expect(focusNode.hasFocus, isTrue);
});
```

---

### 3. اختبار تكبير النص (Text Scaling)

#### إعدادات Android

1. **تغيير حجم الخط:**
   - الإعدادات → العرض → حجم الخط والنمط
   - اختبار الأحجام: صغير، افتراضي، كبير، ضخم

2. **textScaleFactor في Flutter:**
   ```dart
   // اختبار مع عوامل تكبير مختلفة
   for (final scale in [1.0, 1.15, 1.3, 1.5, 2.0]) {
     await tester.pumpWidget(
       MaterialApp(
         home: MediaQuery(
           data: MediaQueryData(textScaleFactor: scale),
           child: Scaffold(
             body: AppEnhancedButton(
               text: 'اختبار تكبير النص',
               onPressed: () {},
             ),
           ),
         ),
       ),
     );

     // التحقق من عدم وجود overflow
     expect(tester.takeException(), isNull);
   }
   ```

#### معايير النجاح

```
□ textScaleFactor 1.0 (افتراضي) - يعمل
□ textScaleFactor 1.15 (كبير) - يعمل
□ textScaleFactor 1.3 (كبير جداً) - يعمل
□ textScaleFactor 1.5 (ضخم) - يعمل
□ textScaleFactor 2.0 (أقصى حد) - يعمل
□ لا توجد أخطاء RenderFlex overflow
□ النص يلتف بشكل صحيح
□ الأزرار تتكيف مع الحجم
```

---

### 4. اختبار عمى الألوان (Color Blindness)

#### أنواع عمى الألوان

| النوع | التأثير | النسبة |
|-------|---------|--------|
| Protanopia | عمى الأحمر | ~1% من الذكور |
| Deuteranopia | عمى الأخضر | ~6% من الذكور |
| Tritanopia | عمى الأزرق | ~0.01% |

#### أدوات المحاكاة

1. **Android Studio:**
   - Layout Inspector → Color Blind Mode

2. **أدوات خارجية:**
   - [Coblis](https://www.color-blindness.com/coblis-color-blindness-simulator/)
   - [Color Oracle](https://colororacle.org/)

#### معايير النجاح

```
□ لا تعتمد على اللون وحده لتوصيل المعلومات
□ الأيقونات واضحة بدون ألوان
□ النصوص مقروءة في جميع الحالات
□ حالات الخطأ والنجاح لها أيقونات
□ الحدود والفواصل واضحة
```

---

### 5. اختبار التباين (Contrast Testing)

#### معايير WCAG 2.1 Level AA

| نوع النص | الحد الأدنى |
|----------|-------------|
| نص عادي (< 18px أو < 14px عريض) | 4.5:1 |
| نص كبير (≥ 18px أو ≥ 14px عريض) | 3:1 |
| عناصر تفاعلية | 3:1 |
| حدود | 3:1 |

#### فحص التباين باستخدام AccessibilityChecker

```dart
import 'package:basir_accounting_system/core/theme/utils/accessibility_checker.dart';

void testContrast() {
  // فحص تباين النص الأساسي
  final textContrast = AccessibilityChecker.checkContrast(
    AppColors.textPrimary,
    AppColors.surface,
    minRatio: 4.5,
  );
  assert(textContrast, 'نص أساسي: التباين غير كافٍ');

  // فحص تباين الزر
  final buttonContrast = AccessibilityChecker.checkContrast(
    AppColors.onPrimary,
    AppColors.primary,
    minRatio: 4.5,
  );
  assert(buttonContrast, 'زر أساسي: التباين غير كافٍ');
}
```

#### قائمة فحص التباين

```
□ textPrimary على surface: ≥ 4.5:1 ✅
□ textSecondary على surface: ≥ 4.5:1 ✅
□ primary (خلفية زر) على onPrimary (نص): ≥ 4.5:1 ✅
□ error على errorLight: ≥ 4.5:1 ✅
□ success على successLight: ≥ 4.5:1 ✅
□ warning على warningLight: ≥ 4.5:1 ✅
□ focusBorder على surface: ≥ 3:1 ✅
```

---

### 6. اختبار مساحة النقر (Touch Target Testing)

#### المعايير

| المنصة | الحد الأدنى |
|--------|-------------|
| WCAG 2.1 AA | 48x48px |
| Material Design | 48x48px |
| iOS HIG | 44x44pt |

#### فحص مساحة النقر

```dart
testWidgets('button should have minimum touch target', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AppEnhancedButton(
          text: 'اختبار',
          onPressed: () {},
        ),
      ),
    ),
  );

  final buttonSize = tester.getSize(find.byType(AppEnhancedButton));

  expect(buttonSize.width, greaterThanOrEqualTo(48.0));
  expect(buttonSize.height, greaterThanOrEqualTo(48.0));
});
```

#### قائمة فحص مساحة النقر

```
□ الأزرار الأساسية: ≥ 48x48px ✅
□ أزرار الأيقونات: ≥ 48x48px ✅
□ عناصر القائمة: ≥ 48x48px ✅
□ حقول الإدخال: ≥ 48px ارتفاع ✅
□ عناصر التنقل: ≥ 48x48px ✅
```

---

## قائمة فحص شاملة لإمكانية الوصول

### المرئي (Visual)

```
□ التباين: جميع النصوص تحقق ≥ 4.5:1
□ الأحجام: جميع مساحات النقر ≥ 48x48px
□ الأيقونات: جميع الأيقونات ≥ 24px
□ النصوص: الخطوط ≥ 15px للعربية
□ الألوان: لا تعتمد على اللون وحده
□ الحدود: واضحة بتباين ≥ 3:1
```

### التفاعلي (Interactive)

```
□ التركيز: مؤشر واضح لجميع العناصر
□ الحالات: normal, hover, pressed, focused, disabled واضحة
□ الأزرار: text, icon, tooltip واضحة
□ النماذج: labels, errors, help text واضحة
□ التنقل: ترتيب منطقي بالـ Tab
```

### المعلوماتي (Informational)

```
□ العناوين: تسلسل هرمي صحيح (h1, h2, h3)
□ الروابط: نص واضح يصف الهدف
□ الصور: alt text مناسب
□ الجداول: headers واضحة
□ الأخطاء: رسائل واضحة مع اقتراحات
```

### المسموع (Auditory - Screen Reader)

```
□ Semantics: جميع العناصر لها labels
□ الأزرار: وصف الإجراء واضح
□ الحقول: label + hint + error
□ القوائم: عدد العناصر + الموقع
□ التنبيهات: إعلان عند الظهور
```

---

## تشغيل الاختبارات

### اختبارات الوحدة

```bash
# تشغيل جميع اختبارات إمكانية الوصول
flutter test test/core/theme/utils/accessibility_checker_test.dart

# تشغيل اختبارات الخصائص
flutter test test/core/theme/tokens/properties/
```

### اختبارات Widget

```bash
# تشغيل اختبارات Widgets
flutter test test/widget/

# تشغيل اختبار محدد
flutter test test/widget/core/widgets/app_enhanced_button_test.dart
```

### فحص الكود

```bash
# تشغيل flutter analyze
flutter analyze

# التحقق من عدم وجود مشاكل
flutter analyze --no-pub
```

---

## أدوات مفيدة

### أدوات Flutter

- **Accessibility Scanner:** `flutter accessibility_tools`
- **Semantics Debugger:** `debugShowSemantics: true`
- **Performance Overlay:** `showPerformanceOverlay: true`

### أدوات خارجية

- **Android Accessibility Scanner:** تطبيق من Google
- **Accessibility Insights:** من Microsoft
- **WAVE:** لاختبار الويب
- **axe DevTools:** لاختبار الويب

---

## الإبلاغ عن المشاكل

عند اكتشاف مشكلة في إمكانية الوصول:

1. **التوثيق:**
   - وصف المشكلة بوضوح
   - لقطة شاشة أو فيديو
   - خطوات التكرار
   - المعيار المتأثر (WCAG)

2. **التصنيف:**
   - 🔴 حرج: يمنع استخدام التطبيق
   - 🟠 عالي: يصعب الاستخدام
   - 🟡 متوسط: يؤثر على التجربة
   - 🟢 منخفض: تحسين

3. **الإصلاح:**
   - تحديد الملفات المتأثرة
   - تطبيق الإصلاح
   - اختبار الحل
   - توثيق التغيير

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 26 يوليو 2026  
**الإصدار:** 1.0
