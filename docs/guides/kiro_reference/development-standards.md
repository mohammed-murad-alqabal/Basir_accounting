---
id: "development-standards"
description: "معايير التطوير الشاملة لبصير MVP"
version: "1.0"
last_updated: "2025-12-17"
inclusion: manual
author: "فريق وكلاء تطوير مشروع بصير"
metrics:
  location: ".kiro/guides/"
  size: "12KB"
  lines: 345
  context_usage: "6%"
---

# معايير التطوير - بصير MVP

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 17 ديسمبر 2025  
**الحالة:** ✅ نشط ومكثف

---

## 🎯 معايير Flutter/Dart

### **معايير جودة الكود**

- اتباع `effective_dart` وأفضل ممارسات Flutter
- استخدام `dart format` للتنسيق المتسق
- تنفيذ `const` constructors حيثما أمكن
- استخدام `final` للمتغيرات غير القابلة للتغيير
- اتباع Clean Architecture (3 طبقات: Presentation, Domain, Data)

### **معايير هيكل المشروع**

```
lib/
├── core/                    # الأدوات والثوابت الأساسية
├── features/               # تنظيم حسب الميزة
│   ├── invoices/          # ميزة إدارة الفواتير
│   │   ├── data/          # طبقة البيانات (repositories, models)
│   │   ├── domain/        # طبقة المجال (entities, use cases)
│   │   └── presentation/  # طبقة العرض (pages, widgets)
│   └── customers/         # ميزة إدارة العملاء
└── shared/                # widgets والأدوات المشتركة
```

---

## 🔄 معايير إدارة الحالة (Riverpod)

### **أنماط Provider**

- استخدام `StateNotifier` لإدارة الحالة المعقدة
- تنفيذ `AsyncValue` للتعامل مع حالات التحميل/الخطأ
- استخدام `family` modifiers للـ providers المعاملة
- اتباع أنماط حقن التبعية مع providers

### **مثال على التنفيذ**

```dart
// ✅ جيد: StateNotifier للحالة المعقدة
class InvoiceNotifier extends StateNotifier<AsyncValue<List<Invoice>>> {
  InvoiceNotifier(this._repository) : super(const AsyncValue.loading());

  final InvoiceRepository _repository;

  Future<void> loadInvoices() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAllInvoices());
  }
}

// تعريف Provider
final invoiceProvider = StateNotifierProvider<InvoiceNotifier, AsyncValue<List<Invoice>>>(
  (ref) => InvoiceNotifier(ref.watch(invoiceRepositoryProvider)),
);
```

---

## 💾 معايير قاعدة البيانات المحلية (Isar)

### **تصميم المخطط**

- استخدام الفهرسة المناسبة للحقول المستعلمة بكثرة
- تنفيذ فهارس مركبة للاستعلامات المعقدة
- اتباع اتفاقيات التسمية: `@Collection()` للكيانات
- استخدام `@Id()` للمفاتيح الأساسية، تفضيل `int` على `String`

### **تحسين الاستعلامات**

```dart
// ✅ جيد: استعلام فعال مع فهرسة مناسبة
@Collection()
class Invoice {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime createdAt;

  @Index()
  late int customerId;

  @Index(composite: [CompositeIndex('customerId')])
  late String status;
}

// استخدام استعلام فعال
Future<List<Invoice>> getCustomerInvoices(int customerId) async {
  return await isar.invoices
    .where()
    .customerIdEqualTo(customerId)
    .sortByCreatedAtDesc()
    .findAll();
}
```

### **إدارة المعاملات**

```dart
// ✅ جيد: استخدام المعاملات
Future<void> createInvoiceWithItems(Invoice invoice, List<InvoiceItem> items) async {
  await isar.writeTxn(() async {
    await isar.invoices.put(invoice);
    await isar.invoiceItems.putAll(items);
  });
}
```

---

## 📱 معايير التطبيقات المحلية أولاً

### **مزامنة البيانات**

- تنفيذ استراتيجيات حل التعارض
- استخدام التحديثات المتفائلة لتجربة مستخدم أفضل
- التعامل مع تغييرات اتصال الشبكة بسلاسة
- تنفيذ المزامنة الخلفية عند عودة الاتصال

### **أنماط التخزين المحلي**

```dart
// ✅ جيد: نمط repository محلي أولاً
class InvoiceRepository {
  final IsarDatabase _localDb;
  final ApiService _apiService;
  final ConnectivityService _connectivity;

  Future<List<Invoice>> getInvoices() async {
    // إرجاع البيانات المحلية أولاً دائماً
    final localInvoices = await _localDb.getAllInvoices();

    // مزامنة في الخلفية إذا كان متصلاً
    if (await _connectivity.isConnected()) {
      _syncInBackground();
    }

    return localInvoices;
  }

  Future<void> _syncInBackground() async {
    // تنفيذ المزامنة الخلفية
  }
}
```

---

## 🔤 دعم اللغة العربية و RTL

### **معايير الترجمة**

- استخدام `flutter_localizations` لدعم RTL المناسب
- تنفيذ `Directionality` widgets بشكل صحيح
- اختبار جميع مكونات الواجهة في أوضاع LTR و RTL
- استخدام تنسيق التاريخ/الأرقام الخاص بالعربية

### **معايير إدخال النص**

```dart
// ✅ جيد: معالجة إدخال النص العربي
TextField(
  textDirection: TextDirection.rtl,
  textAlign: TextAlign.right,
  inputFormatters: [
    ArabicTextInputFormatter(), // منسق مخصص للعربية
  ],
  decoration: InputDecoration(
    hintText: 'أدخل اسم العميل',
    hintTextDirection: TextDirection.rtl,
  ),
)
```

---

## 🧪 معايير الاختبارات للتطبيقات المحلية

### **اختبار الوحدة**

- اختبار جميع المنطق التجاري بمعزل
- محاكاة التبعيات الخارجية (API، قاعدة البيانات)
- اختبار السيناريوهات غير المتصلة تحديداً
- تحقيق تغطية اختبار 70%+

### **اختبار Widget**

- اختبار مكونات الواجهة بالعربية والإنجليزية
- اختبار صحة تخطيط RTL
- اختبار معالجة الحالة غير المتصلة في الواجهة
- استخدام اختبارات golden للانحدار البصري

### **اختبار التكامل**

- اختبار رحلات المستخدم الكاملة غير متصلة
- اختبار استمرارية البيانات عبر إعادة تشغيل التطبيق
- اختبار وظائف المزامنة الخلفية
- اختبار إدخال وعرض العربية

---

## ⚡ معايير الأداء

### **أداء Flutter**

- استخدام `const` constructors لتقليل إعادة البناء
- تنفيذ `ListView.builder` المناسب للقوائم الكبيرة
- استخدام `RepaintBoundary` للـ widgets المكلفة
- مراقبة استخدام الذاكرة مع DevTools

### **أداء قاعدة البيانات**

- تنفيذ استراتيجيات الفهرسة المناسبة
- استخدام التحميل الكسول لمجموعات البيانات الكبيرة
- تنفيذ ترقيم الصفحات لعروض القائمة
- مراقبة أداء الاستعلام

---

## 🔒 معايير الأمان للتطبيقات المحلية

### **حماية البيانات المحلية**

- استخدام `flutter_secure_storage` للبيانات الحساسة
- تنفيذ التشفير المناسب لقاعدة البيانات المحلية
- التحقق من جميع مدخلات المستخدم
- تنفيذ آليات النسخ الاحتياطي/الاستعادة الآمنة

### **مثال على التنفيذ**

```dart
// ✅ جيد: التخزين المحلي الآمن
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );

  Future<void> storeUserPin(String pin) async {
    final hashedPin = await _hashPin(pin);
    await _storage.write(key: 'user_pin', value: hashedPin);
  }
}
```

---

## 📦 إدارة التبعيات

### **تبعيات Flutter**

- استخدام أحدث الإصدارات المستقرة من حزم Flutter
- تفضيل الحزم ذات الصيانة النشطة
- توثيق قيود الإصدار في pubspec.yaml
- عمليات تدقيق أمني منتظمة للتبعيات

### **الحزم الموصى بها لبصير MVP**

```yaml
dependencies:
  flutter:
    sdk: flutter
  riverpod: ^2.4.9 # إدارة الحالة
  isar: ^3.1.0 # قاعدة البيانات المحلية
  isar_flutter_libs: ^3.1.0
  flutter_secure_storage: ^9.0.0 # التخزين الآمن
  connectivity_plus: ^5.0.2 # اتصال الشبكة
  intl: ^0.18.1 # التدويل

dev_dependencies:
  flutter_test:
    sdk: flutter
  isar_generator: ^3.1.0
  build_runner: ^2.4.7
  mockito: ^5.4.4 # المحاكاة للاختبارات
```

---

## 📋 معايير مراجعة الكود

### **قائمة التحقق الخاصة بـ Flutter**

- [ ] الاستخدام الصحيح لـ `const` constructors
- [ ] أنماط إدارة الحالة الصحيحة
- [ ] استعلامات قاعدة البيانات الفعالة
- [ ] معالجة الأخطاء المناسبة للسيناريوهات غير المتصلة
- [ ] صحة تخطيط العربية/RTL
- [ ] اعتبارات الأداء (إعادة البناء، الذاكرة)
- [ ] تطبيق أفضل ممارسات الأمان
- [ ] كتابة الاختبارات ونجاحها

---

## 📚 معايير التوثيق

### **توثيق الكود**

- استخدام DartDoc لجميع APIs العامة
- تضمين أمثلة الاستخدام في التوثيق
- توثيق السلوك غير المتصل تحديداً
- شرح اعتبارات العربية/RTL

### **توثيق المشروع**

- الحفاظ على README شامل مع تعليمات الإعداد
- توثيق مخطط قاعدة البيانات والهجرات
- تضمين دليل استكشاف الأخطاء وإصلاحها للمشاكل الشائعة
- توثيق متطلبات إعداد اللغة العربية

---

## 🔗 المراجع المتقدمة

### **للتفاصيل الشاملة:**

- **Advanced Development Standards**

### **المعايير التقنية:**

- [معايير المشروع](./project-standards.md)
- [معايير Flutter Frontend](./frontend-standards.md)
- [أفضل ممارسات الأمان](./security-best-practices.md)

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ ملف توجيه مكثف ومحسن  
**المراجعة القادمة:** 23 ديسمبر 2025
