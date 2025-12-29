# دليل تحسين Riverpod - بصير MVP

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 18 ديسمبر 2025

## 🎯 المشكلة الحالية

تحليل الأداء أظهر:

- **49 استدعاء watch()** في المشروع
- **0 استدعاء select()** - مشكلة أداء حرجة
- **نسبة select/watch: 0%** (المطلوب: 20%+)

## 🚀 التحسينات المطلوبة

### 1. استخدام select() بدلاً من watch()

#### ❌ المشكلة الحالية:

```dart
// يعيد بناء Widget عند تغيير أي جزء من الحالة
final state = ref.watch(exampleStateProvider);
final itemsCount = state.items.length;
```

#### ✅ الحل المحسن:

```dart
// يعيد بناء Widget فقط عند تغيير عدد العناصر
final itemsCount = ref.watch(
  exampleStateProvider.select((state) => state.items.length),
);
```

### 2. أمثلة عملية للتحسين

#### تحسين مراقبة الحالة:

```dart
// ❌ بدلاً من:
final user = ref.watch(userProvider);
final userName = user.name;

// ✅ استخدم:
final userName = ref.watch(userProvider.select((user) => user.name));
```

#### تحسين مراقبة القوائم:

```dart
// ❌ بدلاً من:
final invoices = ref.watch(invoicesProvider);
final invoiceCount = invoices.length;

// ✅ استخدم:
final invoiceCount = ref.watch(
  invoicesProvider.select((invoices) => invoices.length),
);
```

#### تحسين مراقبة الحالة المعقدة:

```dart
// ❌ بدلاً من:
final state = ref.watch(invoiceStateProvider);
final isLoading = state.isLoading;
final hasError = state.error != null;

// ✅ استخدم:
final isLoading = ref.watch(
  invoiceStateProvider.select((state) => state.isLoading),
);
final hasError = ref.watch(
  invoiceStateProvider.select((state) => state.error != null),
);
```

## 📊 الملفات التي تحتاج تحسين

### الأولوية العالية:

1. **lib/features/invoices/presentation/providers/invoice_provider.dart**

   - 11 استدعاء watch() يحتاج تحسين
   - تحسين filteredInvoicesProvider
   - تحسين totalSalesProvider

2. **lib/features/auth/presentation/providers/auth_provider.dart**

   - 8 استدعاءات watch() يحتاج تحسين
   - تحسين مراقبة حالة المصادقة

3. **lib/core/providers.dart**
   - 6 استدعاءات watch() يحتاج تحسين
   - تحسين مراقبة قاعدة البيانات

### الأولوية المتوسطة:

4. **lib/core/providers/theme_provider.dart**
   - استدعاء واحد يحتاج تحسين
   - تحسين مراقبة الثيم

## 🛠️ خطة التنفيذ

### المرحلة 1: التحسينات الأساسية (30 دقيقة)

- [ ] تحسين invoice_provider.dart
- [ ] إضافة select() للحالات البسيطة

### المرحلة 2: التحسينات المتقدمة (45 دقيقة)

- [ ] تحسين auth_provider.dart
- [ ] تحسين core/providers.dart
- [ ] إضافة select() للحالات المعقدة

### المرحلة 3: التحقق والاختبار (15 دقيقة)

- [ ] تشغيل flutter analyze
- [ ] تشغيل الاختبارات
- [ ] قياس تحسن الأداء

## 📈 النتائج المتوقعة

### قبل التحسين:

- **select/watch ratio:** 0%
- **Performance score:** -15 نقطة
- **Rebuilds:** عالية جداً

### بعد التحسين:

- **select/watch ratio:** 25%+ (هدف ممتاز)
- **Performance score:** +15 نقطة
- **Rebuilds:** محسنة بنسبة 60%+

## 💡 نصائح إضافية

### متى تستخدم select():

- عند مراقبة جزء محدد من الحالة
- عند حساب قيم مشتقة (derived values)
- عند مراقبة خصائص بسيطة (strings, numbers, booleans)

### متى تستخدم watch():

- عند الحاجة للحالة الكاملة
- في الـ providers (ليس في الـ widgets)
- عند التعامل مع حالات بسيطة

### أفضل الممارسات:

- استخدم select() في الـ widgets
- استخدم watch() في الـ providers
- اجمع عدة select() calls إذا أمكن
- اختبر الأداء بعد التحسين

## 🔧 أدوات المساعدة

### VS Code Extensions:

- Flutter Riverpod Snippets
- Dart Code Metrics

### أوامر مفيدة:

```bash
# فحص الأداء
flutter run --profile

# تحليل الكود
flutter analyze

# قياس الـ rebuilds
flutter inspector
```
