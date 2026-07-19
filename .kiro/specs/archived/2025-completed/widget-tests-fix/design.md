# تصميم إصلاح اختبارات Widget - بصير MVP

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 18 ديسمبر 2025  
**الحالة:** 🚨 أولوية حرجة فورية

---

## نظرة عامة

هذا التصميم يهدف لإصلاح 13 اختبار فاشل في Widget Tests من خلال إنشاء أو إصلاح مكونات UI المفقودة وتحديث الاختبارات لتتوافق مع التنفيذ الحالي.

## البنية المعمارية

### المكونات الأساسية

```
lib/
├── core/
│   └── widgets/
│       ├── app_primary_button.dart      # الزر الأساسي
│       ├── app_secondary_button.dart    # الزر الثانوي
│       ├── app_text_button.dart         # الزر النصي
│       └── app_enhanced_button.dart     # الزر المحسن (موجود)
└── features/
    ├── dashboard/
    ├── auth/
    └── customers/

test/
├── widget/
│   ├── features/
│   │   ├── dashboard/
│   │   ├── auth/
│   │   └── customers/
│   └── core/
│       └── widgets/
```

## المكونات والواجهات

### 1. AppPrimaryButton

```dart
class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AppPrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppEnhancedButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      style: AppButtonStyle.primary,
    );
  }
}
```

### 2. AppSecondaryButton

```dart
class AppSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AppSecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppEnhancedButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      style: AppButtonStyle.secondary,
    );
  }
}
```

### 3. AppTextButton

```dart
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AppTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppEnhancedButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: AppButtonStyle.text,
    );
  }
}
```

## نماذج البيانات

### ButtonTestData

```dart
class ButtonTestData {
  final String text;
  final bool isEnabled;
  final bool hasIcon;
  final AppButtonStyle style;

  const ButtonTestData({
    required this.text,
    this.isEnabled = true,
    this.hasIcon = false,
    required this.style,
  });
}
```

## خصائص الصحة

_خاصية هي سمة أو سلوك يجب أن يكون صحيحاً عبر جميع التنفيذات الصالحة للنظام - في الأساس، بيان رسمي حول ما يجب أن يفعله النظام. الخصائص تعمل كجسر بين المواصفات القابلة للقراءة البشرية وضمانات الصحة القابلة للتحقق آلياً._

### خصائص اختبار المكونات

#### خاصية 1: وجود المكونات

_لأي_ شاشة تحتوي على أزرار، يجب أن تحتوي على المكونات المطلوبة في widget tree
**يتحقق من: المتطلبات 1.2, 1.3, 1.4**

#### خاصية 2: استجابة الأزرار

_لأي_ زر مُفعل، يجب أن يستجيب للنقر ويستدعي callback المناسب
**يتحقق من: المتطلبات 2.1, 2.2, 2.3**

#### خاصية 3: عرض النصوص

_لأي_ زر، يجب أن يعرض النص المحدد بشكل صحيح
**يتحقق من: المتطلبات 2.4**

#### خاصية 4: حالة التحميل

_لأي_ زر في حالة تحميل، يجب أن يعرض مؤشر التحميل ويكون غير قابل للنقر
**يتحقق من: المتطلبات 2.5**

#### خاصية 5: استقرار الاختبارات

_لأي_ اختبار widget، يجب أن ينتج نفس النتيجة عند التشغيل المتكرر
**يتحقق من: المتطلبات 3.4, 3.5**

## معالجة الأخطاء

### استراتيجية معالجة الأخطاء

1. **أخطاء المكونات المفقودة**

   - التحقق من وجود المكون قبل الاختبار
   - رسائل خطأ واضحة تحدد المكون المفقود
   - اقتراحات للإصلاح

2. **أخطاء الاختبارات**

   - تسجيل مفصل للأخطاء
   - معلومات السياق للتشخيص
   - إرشادات الإصلاح

3. **أخطاء التكامل**
   - التحقق من التبعيات
   - اختبار التوافق
   - تقارير شاملة

## استراتيجية الاختبار

### اختبارات الوحدة

- اختبار كل مكون بشكل منفصل
- التحقق من الخصائص الأساسية
- اختبار حالات الحد

### اختبارات Widget

- اختبار تكامل المكونات مع الشاشات
- التحقق من التفاعلات
- اختبار حالات الاستخدام الحقيقية

### اختبارات التكامل

- اختبار تدفق المستخدم الكامل
- التحقق من الأداء
- اختبار الاستقرار

### إعداد اختبارات الخصائص

سيتم استخدام مكتبة `flutter_test` المدمجة مع Flutter لاختبار الخصائص. كل اختبار خاصية سيتم تشغيله 100 مرة على الأقل للتأكد من الاستقرار.

**متطلبات اختبار الخصائص:**

- كل اختبار خاصية يجب أن يحتوي على تعليق يشير إلى رقم الخاصية في وثيقة التصميم
- استخدام التنسيق: `**Feature: widget-tests-fix, Property {number}: {property_text}**`
- كل خاصية صحة يجب أن تُنفذ بواسطة اختبار خاصية واحد
- الاختبارات يجب أن تكون قريبة من التنفيذ لاكتشاف الأخطاء مبكراً

## خطة التنفيذ

### المرحلة 1: إنشاء المكونات المفقودة

1. إنشاء AppPrimaryButton
2. إنشاء AppSecondaryButton
3. إنشاء AppTextButton
4. تحديث exports في core/widgets

### المرحلة 2: تحديث الشاشات

1. تحديث DashboardScreen لاستخدام المكونات الجديدة
2. تحديث LoginScreen لاستخدام المكونات الجديدة
3. تحديث الشاشات الأخرى حسب الحاجة

### المرحلة 3: إصلاح الاختبارات

1. تحديث اختبارات DashboardScreen
2. تحديث اختبارات LoginScreen
3. تحديث الاختبارات الأخرى
4. إضافة اختبارات للمكونات الجديدة

### المرحلة 4: التحقق والتحسين

1. تشغيل جميع الاختبارات
2. التحقق من النتائج
3. إصلاح أي مشاكل متبقية
4. تحسين الأداء

## اعتبارات الأداء

### تحسين الاختبارات

- استخدام `setUp` و `tearDown` بكفاءة
- تجنب إعادة إنشاء المكونات غير الضرورية
- استخدام `pumpAndSettle` بحذر

### تحسين المكونات

- استخدام `const` constructors
- تجنب إعادة البناء غير الضرورية
- تحسين استخدام الذاكرة

## الأمان والجودة

### معايير الجودة

- جميع المكونات يجب أن تتبع معايير Flutter
- الكود يجب أن يكون قابل للقراءة والصيانة
- التوثيق يجب أن يكون شاملاً

### الأمان

- لا توجد اعتبارات أمنية خاصة
- التركيز على جودة الكود

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ تصميم شامل ومفصل  
**المراجعة القادمة:** عند اكتمال المهام
