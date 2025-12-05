# معايير النصوص والطباعة

**المشروع:** بصير MVP  
**التاريخ:** 4 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط ومعتمد

---

## المبدأ الأساسي

**الوضوح والقابلية للقراءة أولاً** - جميع النصوص يجب أن تكون واضحة، مقروءة، ومتجاوبة مع جميع أحجام الشاشات.

---

## 1. الخطوط المعتمدة

### 1.1 خط Cairo للعربية ✅

**الخط الأساسي:** Cairo  
**المصدر:** Google Fonts  
**الترخيص:** SIL Open Font License (مجاني)

**المميزات:**

- ✅ خط عربي احترافي وواضح
- ✅ دعم كامل للحروف العربية
- ✅ أوزان متعددة (Light, Regular, Medium, SemiBold, Bold)
- ✅ مجاني ومفتوح المصدر
- ✅ محسّن للشاشات الرقمية

**الاستخدام:**

```dart
import 'package:google_fonts/google_fonts.dart';

final textTheme = GoogleFonts.cairoTextTheme();
```

### 1.2 خط Roboto للإنجليزية

**الخط الثانوي:** Roboto  
**الاستخدام:** النصوص الإنجليزية والأرقام

### 1.3 خط Roboto Mono للأرقام

**الخط الخاص:** Roboto Mono  
**الاستخدام:** المبالغ المالية والأرقام الدقيقة

---

## 2. أحجام الخطوط

### 2.1 العناوين (Headlines)

| النوع               | الحجم |  الوزن   | الاستخدام               |
| :------------------ | :---: | :------: | :---------------------- |
| **Display Large**   | 34px  |   Bold   | عناوين الصفحات الرئيسية |
| **Display Medium**  | 28px  |   Bold   | عناوين الأقسام الكبيرة  |
| **Display Small**   | 24px  |   Bold   | عناوين الأقسام          |
| **Headline Large**  | 22px  | SemiBold | عناوين البطاقات         |
| **Headline Medium** | 18px  | SemiBold | عناوين فرعية            |
| **Headline Small**  | 16px  | SemiBold | عناوين صغيرة            |

### 2.2 النصوص (Body)

| النوع           | الحجم |  الوزن  | الاستخدام               |
| :-------------- | :---: | :-----: | :---------------------- |
| **Body Large**  | 17px  | Regular | نصوص أساسية كبيرة       |
| **Body Medium** | 15px  | Regular | نصوص أساسية (الافتراضي) |
| **Body Small**  | 13px  | Regular | نصوص ثانوية             |

### 2.3 التسميات (Labels)

| النوع            | الحجم | الوزن  | الاستخدام           |
| :--------------- | :---: | :----: | :------------------ |
| **Label Large**  | 15px  | Medium | أزرار وتسميات كبيرة |
| **Label Medium** | 13px  | Medium | تسميات متوسطة       |
| **Label Small**  | 12px  | Medium | تسميات صغيرة        |

---

## 3. معالجة Overflow

### 3.1 استخدام ResponsiveText Widget ✅

**القاعدة:** استخدم `ResponsiveText` بدلاً من `Text` العادي

**مثال صحيح ✅:**

```dart
ResponsiveText(
  'نص طويل جداً قد يسبب overflow',
  style: Theme.of(context).textTheme.titleLarge,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

**مثال خاطئ ❌:**

```dart
Text(
  'نص طويل جداً قد يسبب overflow',
  style: Theme.of(context).textTheme.titleLarge,
)
```

### 3.2 Widgets المخصصة

| Widget                 | الاستخدام    | maxLines الافتراضي |
| :--------------------- | :----------- | :----------------: |
| **ResponsiveHeadline** | عناوين كبيرة |         2          |
| **ResponsiveTitle**    | عناوين فرعية |         2          |
| **ResponsiveBody**     | نصوص أساسية  |      غير محدد      |
| **ResponsiveLabel**    | تسميات       |         1          |
| **ResponsiveCaption**  | نصوص صغيرة   |         2          |

### 3.3 استراتيجيات Overflow

1. **Ellipsis (...)** - الافتراضي

   ```dart
   overflow: TextOverflow.ellipsis
   ```

2. **Fade** - للنصوص الطويلة

   ```dart
   overflow: TextOverflow.fade
   ```

3. **Clip** - قص النص

   ```dart
   overflow: TextOverflow.clip
   ```

4. **Auto Scale** - تصغير تلقائي
   ```dart
   ResponsiveText(
     'نص',
     autoScale: true,
   )
   ```

---

## 4. التباين والوضوح

### 4.1 نسب التباين (WCAG 2.1)

| المستوى          | النسبة المطلوبة | الاستخدام          |
| :--------------- | :-------------: | :----------------- |
| **AA (Normal)**  |      4.5:1      | نصوص عادية         |
| **AA (Large)**   |       3:1       | نصوص كبيرة (18px+) |
| **AAA (Normal)** |       7:1       | نصوص عادية (مثالي) |
| **AAA (Large)**  |      4.5:1      | نصوص كبيرة (مثالي) |

### 4.2 ألوان النصوص المعتمدة

```dart
// نصوص على خلفية فاتحة
textPrimary: Color(0xFF1A1A1A)    // تباين 16:1 ✅
textSecondary: Color(0xFF4A4A4A)  // تباين 7:1 ✅
textHint: Color(0xFF757575)       // تباين 4.5:1 ✅

// نصوص على خلفية داكنة
textOnDark: Color(0xFFFFFFFF)     // تباين 21:1 ✅
```

---

## 5. ارتفاع الأسطر (Line Height)

### 5.1 القيم المعتمدة

| النوع         | Line Height | الاستخدام   |
| :------------ | :---------: | :---------- |
| **Headlines** |     1.2     | عناوين      |
| **Body**      |     1.5     | نصوص أساسية |
| **Labels**    |     1.3     | تسميات      |

### 5.2 أمثلة

```dart
// عنوان
TextStyle(
  fontSize: 24,
  height: 1.2,  // 28.8px line height
)

// نص أساسي
TextStyle(
  fontSize: 15,
  height: 1.5,  // 22.5px line height
)
```

---

## 6. المسافات بين الحروف (Letter Spacing)

### 6.1 القيم المعتمدة

| النوع        | Letter Spacing | الاستخدام    |
| :----------- | :------------: | :----------- |
| **Display**  |      -0.5      | عناوين كبيرة |
| **Headline** |       0        | عناوين       |
| **Body**     |   0.25 - 0.5   | نصوص أساسية  |
| **Label**    |      0.5       | تسميات       |

---

## 7. دعم RTL

### 7.1 القواعد

1. ✅ **استخدام TextDirection.rtl** للنصوص العربية
2. ✅ **استخدام TextAlign.start** بدلاً من left
3. ✅ **استخدام TextAlign.end** بدلاً من right
4. ✅ **اختبار جميع النصوص في RTL**

### 7.2 مثال

```dart
ResponsiveText(
  'نص عربي',
  textDirection: TextDirection.rtl,
  textAlign: TextAlign.start,  // ✅ صحيح
)

// ❌ خطأ
ResponsiveText(
  'نص عربي',
  textAlign: TextAlign.left,  // سيظهر على اليسار!
)
```

---

## 8. إمكانية الوصول (Accessibility)

### 8.1 الحد الأدنى لحجم الخط

**القاعدة:** لا تستخدم خطوط أصغر من 12px

```dart
// ✅ صحيح
fontSize: 13

// ❌ خطأ
fontSize: 10  // صغير جداً
```

### 8.2 الحد الأدنى لحجم الأزرار

**القاعدة:** الحد الأدنى 48x48 px

```dart
minimumSize: Size(88, 48)  // ✅ صحيح
```

### 8.3 دعم Text Scaling

**القاعدة:** يجب أن تعمل جميع النصوص مع textScaleFactor

```dart
// ✅ يدعم text scaling
ResponsiveText(
  'نص',
  maxLines: 2,
)

// ❌ لا يدعم text scaling
Text(
  'نص',
  textScaleFactor: 1.0,  // ثابت!
)
```

---

## 9. أفضل الممارسات

### 9.1 استخدام Theme

**✅ صحيح:**

```dart
Text(
  'نص',
  style: Theme.of(context).textTheme.bodyMedium,
)
```

**❌ خطأ:**

```dart
Text(
  'نص',
  style: TextStyle(fontSize: 15),  // hardcoded
)
```

### 9.2 استخدام const

**✅ صحيح:**

```dart
const ResponsiveText('نص ثابت')
```

**❌ خطأ:**

```dart
ResponsiveText('نص ثابت')  // بدون const
```

### 9.3 تجنب النصوص الطويلة في سطر واحد

**✅ صحيح:**

```dart
ResponsiveText(
  'نص طويل',
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

**❌ خطأ:**

```dart
Text('نص طويل جداً جداً جداً...')  // سيسبب overflow
```

---

## 10. الاختبارات

### 10.1 اختبارات إلزامية

- [ ] اختبار جميع النصوص على شاشات صغيرة (320px)
- [ ] اختبار جميع النصوص على شاشات كبيرة (1920px)
- [ ] اختبار RTL على جميع الشاشات
- [ ] اختبار Text Scaling (1.0x, 1.5x, 2.0x)
- [ ] اختبار التباين (WCAG AA)

### 10.2 أدوات الاختبار

```dart
// اختبار overflow
testWidgets('text should not overflow', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 100,
          child: ResponsiveText(
            'نص طويل جداً',
            maxLines: 1,
          ),
        ),
      ),
    ),
  );

  expect(tester.takeException(), isNull);
});
```

---

## 11. قائمة التحقق

### قبل Commit

- [ ] جميع النصوص تستخدم ResponsiveText أو widgets مشابهة
- [ ] لا توجد overflow errors
- [ ] جميع النصوص واضحة ومقروءة
- [ ] التباين يلبي WCAG AA
- [ ] RTL يعمل بشكل صحيح
- [ ] Text Scaling يعمل
- [ ] لا توجد hardcoded font sizes
- [ ] استخدام Theme بشكل صحيح

---

## 12. أمثلة كاملة

### مثال 1: بطاقة عميل

```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveTitle(
          'اسم العميل الطويل جداً',
          maxLines: 1,
        ),
        SizedBox(height: 8),
        ResponsiveBody(
          'عنوان طويل جداً قد يمتد لعدة أسطر',
          maxLines: 2,
        ),
        SizedBox(height: 4),
        ResponsiveCaption(
          'معلومات إضافية',
          color: Colors.grey,
        ),
      ],
    ),
  ),
)
```

### مثال 2: زر مع نص طويل

```dart
ElevatedButton(
  onPressed: () {},
  child: ResponsiveLabel(
    'نص الزر الطويل',
    maxLines: 1,
  ),
)
```

### مثال 3: Dialog مع نصوص

```dart
AlertDialog(
  title: ResponsiveTitle('عنوان'),
  content: SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResponsiveBody(
          'نص طويل جداً...',
          maxLines: 5,
        ),
      ],
    ),
  ),
  actions: [
    TextButton(
      onPressed: () {},
      child: ResponsiveLabel('إلغاء'),
    ),
    TextButton(
      onPressed: () {},
      child: ResponsiveLabel('موافق'),
    ),
  ],
)
```

---

## 13. الموارد والمراجع

### الوثائق الرسمية

- [Google Fonts - Cairo](https://fonts.google.com/specimen/Cairo)
- [Flutter Text Styling](https://docs.flutter.dev/cookbook/design/fonts)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Material Design Typography](https://m3.material.io/styles/typography)

### الأدوات المفيدة

- [Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Google Fonts](https://fonts.google.com/)
- [Flutter DevTools](https://docs.flutter.dev/tools/devtools)

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 4 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
