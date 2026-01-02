# خطة إصلاح الخطوط ومشاكل النصوص

**المشروع:** بصير MVP  
**التاريخ:** 4 ديسمبر 2025  
**المحلل:** فريق وكلاء تطوير مشروع بصير  
**الأولوية:** 🔴 عالية

---

## المشاكل المكتشفة

### 1. عدم وجود خط عربي مخصص

**المشكلة:**

- التطبيق يعتمد على الخط الافتراضي للنظام
- قد لا يدعم العربية بشكل جيد على جميع الأجهزة
- تجربة مستخدم غير متسقة

**الحل المقترح:**

- إضافة خط عربي احترافي (مثل Cairo أو Tajawal)
- تكوين الخط في pubspec.yaml
- تطبيق الخط في AppTheme

### 2. Text Overflow غير محدد

**المشكلة:**

- بعض النصوص لا تحتوي على overflow و maxLines
- قد يسبب مشاكل عرض على شاشات صغيرة

**الحل المقترح:**

- إضافة overflow: TextOverflow.ellipsis
- تحديد maxLines حسب السياق
- استخدام Flexible/Expanded حيث مناسب

### 3. Dialog Constraints

**المشكلة:**

- المحتوى قد يتجاوز المساحة عند ظهور لوحة المفاتيح
- تم إصلاحه جزئياً بـ SingleChildScrollView

**الحل المطبق:**

- ✅ إضافة SingleChildScrollView
- ✅ تنظيم actions بشكل صحيح

---

## خطة التنفيذ

### المرحلة 1: إضافة خط عربي (30 دقيقة)

#### الخطوة 1: اختيار الخط

**الخيارات:**

1. **Cairo** - خط عربي حديث وواضح
2. **Tajawal** - خط عربي أنيق
3. **IBM Plex Sans Arabic** - خط احترافي

**القرار:** استخدام **Cairo** لأنه:

- مجاني ومفتوح المصدر
- يدعم جميع الأوزان
- واضح وسهل القراءة
- متوافق مع Material Design

#### الخطوة 2: تحميل الخط

```bash
# تحميل من Google Fonts
# أو استخدام package google_fonts
```

#### الخطوة 3: إضافة إلى pubspec.yaml

```yaml
flutter:
  fonts:
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo-Regular.ttf
        - asset: assets/fonts/Cairo-Bold.ttf
          weight: 700
        - asset: assets/fonts/Cairo-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Cairo-Medium.ttf
          weight: 500
        - asset: assets/fonts/Cairo-Light.ttf
          weight: 300
```

#### الخطوة 4: تطبيق في AppTheme

```dart
// في lib/core/theme/app_theme.dart
static ThemeData lightTheme = ThemeData(
  fontFamily: 'Cairo',
  // ... بقية الإعدادات
);
```

### المرحلة 2: إصلاح Text Overflow (20 دقيقة)

#### الأماكن التي تحتاج إصلاح:

1. **CustomerCard**

```dart
// قبل
Text(customer.name)

// بعد
Text(
  customer.name,
  overflow: TextOverflow.ellipsis,
  maxLines: 1,
)
```

2. **InvoiceCard**

```dart
// قبل
Text(invoice.customerName)

// بعد
Text(
  invoice.customerName,
  overflow: TextOverflow.ellipsis,
  maxLines: 1,
)
```

3. **SettingsScreen**

```dart
// قبل
Text('وصف الإعداد')

// بعد
Text(
  'وصف الإعداد',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

### المرحلة 3: تحسين Dialogs (15 دقيقة)

#### تحسينات إضافية:

1. **إضافة constraints للـ content**

```dart
AlertDialog(
  title: const Text('العنوان'),
  content: ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.6,
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // المحتوى
        ],
      ),
    ),
  ),
  actions: [
    // الأزرار
  ],
)
```

2. **إضافة resizeToAvoidBottomInset**

```dart
Scaffold(
  resizeToAvoidBottomInset: true,
  // ...
)
```

---

## الحل البديل السريع (بدون تحميل خطوط)

### استخدام Google Fonts Package

#### الخطوة 1: إضافة التبعية

```yaml
dependencies:
  google_fonts: ^6.1.0
```

#### الخطوة 2: تطبيق في AppTheme

```dart
import 'package:google_fonts/google_fonts.dart';

static ThemeData lightTheme = ThemeData(
  textTheme: GoogleFonts.cairoTextTheme(),
  // ... بقية الإعدادات
);
```

**المميزات:**

- ✅ سهل التطبيق
- ✅ لا يحتاج تحميل ملفات
- ✅ يدعم جميع الأوزان
- ✅ يتم التحميل تلقائياً

**العيوب:**

- ⚠️ يحتاج اتصال إنترنت في أول مرة
- ⚠️ حجم التطبيق أكبر قليلاً

---

## قائمة التحقق

### قبل التطبيق

- [ ] اختيار الخط المناسب
- [ ] تحميل ملفات الخط أو إضافة google_fonts
- [ ] تحديث pubspec.yaml
- [ ] مراجعة جميع النصوص في التطبيق

### أثناء التطبيق

- [ ] تطبيق الخط في AppTheme
- [ ] إضافة overflow لجميع النصوص
- [ ] تحديد maxLines حسب السياق
- [ ] تحسين Dialogs

### بعد التطبيق

- [ ] اختبار على الموبايل
- [ ] التحقق من عرض النصوص الطويلة
- [ ] التحقق من عرض النصوص القصيرة
- [ ] اختبار Dialogs مع لوحة المفاتيح
- [ ] flutter analyze
- [ ] تحديث التوثيق

---

## الأولويات

### P1 - عالية (يجب إصلاحها الآن)

1. ✅ إصلاح Overflow في شاشة الإعدادات (مكتمل)
2. 🔄 إضافة overflow لجميع النصوص الحرجة
3. 🔄 تحسين Dialogs constraints

### P2 - متوسطة (الأسبوع القادم)

1. 📋 إضافة خط عربي مخصص
2. 📋 مراجعة شاملة لجميع النصوص
3. 📋 اختبار على أحجام شاشات مختلفة

### P3 - منخفضة (المرحلة القادمة)

1. 📋 تحسين AppTypography.بشكل عام
2. 📋 إضافة animations للنصوص
3. 📋 تحسين accessibility

---

## التقدير الزمني

| المهمة              | الوقت المقدر |
| :------------------ | :----------: |
| إضافة google_fonts  |   10 دقائق   |
| تطبيق الخط          |   5 دقائق    |
| إصلاح Text Overflow |   20 دقيقة   |
| تحسين Dialogs       |   15 دقيقة   |
| الاختبار            |   15 دقيقة   |
| **الإجمالي**        | **65 دقيقة** |

---

## التوصية النهائية

**الحل الموصى به:**

1. **الآن (P1):**

   - إضافة google_fonts package
   - تطبيق خط Cairo
   - إصلاح Text Overflow الحرجة

2. **الأسبوع القادم (P2):**

   - مراجعة شاملة لجميع النصوص
   - اختبار على أجهزة متعددة
   - تحسينات إضافية

3. **المرحلة القادمة (P3):**
   - تحسينات AppTypography.متقدمة
   - إضافة ميزات إضافية

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** 📋 جاهز للتنفيذ
