# خطة ترقية Riverpod إلى الإصدار 3.1.0

**التاريخ:** 11 يناير 2026  
**المؤلف:** فريق وكلاء تطوير مشروع بصير

---

## 📋 نظرة عامة

هذه الوثيقة تحدد خطة مفصلة لترقية `flutter_riverpod` من الإصدار 2.6.1 إلى 3.1.0.

## 🚨 التغييرات الكسرية الرئيسية

### 1. نقل الموفرات القديمة (Legacy Providers)

**التغيير:**

- `StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider` نُقلت إلى `package:flutter_riverpod/legacy.dart`

**الإجراء المطلوب:**

```dart
// قبل
import 'package:flutter_riverpod/flutter_riverpod.dart';

// بعد
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // للموفرات القديمة فقط
```

### 2. إزالة فئات Ref الفرعية

**التغيير:**

- إزالة `ProviderRef`, `FutureProviderRef`, `StateProviderRef`, إلخ
- استخدام `Ref` مباشرة

**الإجراء المطلوب:**

```dart
// قبل
final provider = Provider<String>((ProviderRef<String> ref) {
  return 'Hello';
});

// بعد
final provider = Provider<String>((Ref ref) {
  return 'Hello';
});
```

### 3. إزالة AutoDispose interfaces

**التغيير:**

- إزالة `AutoDisposeProvider`, `AutoDisposeNotifier`, إلخ
- استخدام `Provider`, `Notifier` مع `isAutoDispose: true`

**الإجراء المطلوب:**

```dart
// قبل
final provider = Provider.autoDispose<String>((ref) => 'Hello');

// بعد
final provider = Provider<String>((ref) => 'Hello', isAutoDispose: true);
```

### 4. إزالة Family Notifiers

**التغيير:**

- إزالة `FamilyNotifier`, `AsyncFamilyNotifier`, إلخ
- استخدام `Notifier`, `AsyncNotifier` مع معاملات

**الإجراء المطلوب:**

```dart
// قبل
class MyFamilyNotifier extends FamilyNotifier<State, Arg> {
  @override
  State build(Arg arg) => State();
}

// بعد
class MyNotifier extends Notifier<State> {
  late final Arg arg;

  @override
  State build() {
    arg = ref.watch(argProvider); // أو تمرير المعامل بطريقة أخرى
    return State();
  }
}
```

### 5. تغيير ProviderObserver

**التغيير:**

- تغيير واجهة `ProviderObserver` لاستخدام `ProviderObserverContext`

**الإجراء المطلوب:**

```dart
// قبل
class MyObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {}
}

// بعد
class MyObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    // استخدم context.provider و context.container
  }
}
```

### 6. تغيير AsyncValue

**التغيير:**

- `AsyncValue.value` الآن يعيد `null` أثناء الأخطاء
- إزالة `AsyncValue.valueOrNull`

**الإجراء المطلوب:**

```dart
// قبل
final value = asyncValue.valueOrNull;

// بعد
final value = asyncValue.value; // يعيد null أثناء الأخطاء
```

### 7. إعادة المحاولة التلقائية

**التغيير:**

- الموفرات الفاشلة تُعيد المحاولة تلقائياً
- يمكن تعطيل هذا السلوك

**الإجراء المطلوب:**

```dart
// تعطيل إعادة المحاولة عالمياً
ProviderScope(
  overrides: [],
  observers: [],
  child: MyApp(),
  // تعطيل إعادة المحاولة
  retryPolicy: RetryPolicy.disabled,
);

// أو لموفر محدد
final provider = Provider<String>(
  (ref) => 'Hello',
  retry: false,
);
```

## 📁 الملفات المتأثرة في مشروع بصير

### 1. ملفات الموفرات الرئيسية

```
lib/features/*/presentation/providers/
├── accounting_providers.dart
├── invoice_providers.dart
├── customer_providers.dart
├── vendor_providers.dart
├── inventory_providers.dart
└── report_providers.dart
```

### 2. ملفات الخدمات الأساسية

```
lib/core/providers/
├── app_providers.dart
├── theme_providers.dart
├── locale_providers.dart
└── database_providers.dart
```

### 3. ملفات الاختبارات

```
test/
├── unit/providers/
├── widget/
└── integration/
```

## 🔄 خطة التنفيذ

### المرحلة 1: التحضير (يوم 1)

1. **إنشاء فرع جديد**

   ```bash
   git checkout -b feature/riverpod-v3-migration
   ```

2. **تحديث pubspec.yaml**

   ```yaml
   dependencies:
     flutter_riverpod: ^3.1.0
     riverpod_annotation: ^2.6.1

   dev_dependencies:
     riverpod_generator: ^2.4.0
   ```

3. **تشغيل flutter pub get**
   ```bash
   flutter pub get
   ```

### المرحلة 2: إصلاح الاستيرادات (يوم 1-2)

1. **تحديث الاستيرادات للموفرات القديمة**

   - البحث عن جميع استخدامات `StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider`
   - إضافة `import 'package:flutter_riverpod/legacy.dart';` حسب الحاجة

2. **إزالة أنواع Ref المحددة**
   - استبدال `ProviderRef<T>` بـ `Ref`
   - استبدال `FutureProviderRef<T>` بـ `Ref`
   - استبدال جميع أنواع Ref الأخرى بـ `Ref`

### المرحلة 3: تحديث الموفرات (يوم 2-3)

1. **تحديث AutoDispose providers**

   - استبدال `.autoDispose` بـ `isAutoDispose: true`
   - استبدال `.autoDispose.family` بـ `isAutoDispose: true` مع family

2. **تحديث Family Notifiers**
   - تحويل `FamilyNotifier` إلى `Notifier` عادي
   - إعادة هيكلة تمرير المعاملات

### المرحلة 4: إصلاح ProviderObserver (يوم 3)

1. **تحديث جميع ProviderObserver implementations**
   - تغيير signature للطرق
   - استخدام `ProviderObserverContext`

### المرحلة 5: إصلاح AsyncValue (يوم 3-4)

1. **استبدال valueOrNull بـ value**
2. **التعامل مع null values أثناء الأخطاء**

### المرحلة 6: الاختبار والتحقق (يوم 4-5)

1. **تشغيل flutter analyze**

   ```bash
   flutter analyze
   ```

2. **تشغيل جميع الاختبارات**

   ```bash
   flutter test
   ```

3. **اختبار التطبيق يدوياً**
   - التأكد من عمل جميع الشاشات
   - التحقق من إدارة الحالة
   - اختبار الأداء

## 🧪 استراتيجية الاختبار

### 1. اختبارات الوحدة

- اختبار جميع الموفرات المحدثة
- التأكد من عمل إدارة الحالة بشكل صحيح
- اختبار إعادة المحاولة التلقائية

### 2. اختبارات الواجهة

- اختبار جميع الشاشات الرئيسية
- التأكد من تحديث واجهة المستخدم بشكل صحيح
- اختبار التفاعلات المعقدة

### 3. اختبارات التكامل

- اختبار التدفقات الكاملة
- التأكد من عمل النظام ككل
- اختبار الأداء تحت الحمولة

## 📊 مؤشرات النجاح

### مؤشرات تقنية

- ✅ لا توجد أخطاء في `flutter analyze`
- ✅ جميع الاختبارات تمر بنجاح
- ✅ لا توجد تحذيرات deprecation
- ✅ الأداء مماثل أو أفضل من قبل

### مؤشرات وظيفية

- ✅ جميع الميزات تعمل كما هو متوقع
- ✅ إدارة الحالة تعمل بشكل صحيح
- ✅ لا توجد مشاكل في واجهة المستخدم
- ✅ التطبيق مستقر ولا يتعطل

## 🚨 المخاطر والتخفيف

### المخاطر المحتملة

1. **كسر في الوظائف الحالية**

   - **التخفيف:** اختبار شامل قبل الدمج

2. **مشاكل في الأداء**

   - **التخفيف:** قياس الأداء قبل وبعد

3. **مشاكل في الاختبارات**
   - **التخفيف:** تحديث الاختبارات تدريجياً

### خطة الطوارئ

- الاحتفاظ بنسخة احتياطية من الكود الحالي
- إمكانية العودة للإصدار السابق إذا لزم الأمر
- اختبار شامل في بيئة منفصلة قبل الإنتاج

## 📝 قائمة المراجعة

### قبل البدء

- [ ] إنشاء نسخة احتياطية من الكود الحالي
- [ ] إنشاء فرع جديد للترقية
- [ ] توثيق الحالة الحالية

### أثناء التنفيذ

- [ ] تحديث pubspec.yaml
- [ ] إصلاح الاستيرادات
- [ ] تحديث الموفرات
- [ ] إصلاح ProviderObserver
- [ ] إصلاح AsyncValue
- [ ] تشغيل flutter analyze
- [ ] تشغيل الاختبارات

### بعد التنفيذ

- [ ] اختبار شامل للتطبيق
- [ ] قياس الأداء
- [ ] توثيق التغييرات
- [ ] دمج الكود في الفرع الرئيسي

---

**الحالة:** 🔄 قيد التنفيذ  
**الأولوية:** 🔥 عالية  
**المدة المتوقعة:** 5 أيام
