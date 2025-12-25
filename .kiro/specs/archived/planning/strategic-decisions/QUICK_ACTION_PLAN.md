# خطة الإجراءات السريعة - ابدأ الآن!

**التاريخ:** 1 ديسمبر 2025  
**الحالة:** 🚀 جاهز للتنفيذ الفوري

---

## ⚡ ابدأ الآن - الأولوية القصوى

### 🔴 المهمة الأولى: testing-system (الأسبوع 1-2)

#### اليوم 1: إعداد البنية التحتية

```bash
# 1. راجع المواصفات
cat .kiro/specs/testing-system/requirements.md
cat .kiro/specs/testing-system/design.md
cat .kiro/specs/testing-system/tasks.md

# 2. أنشئ مجلد الاختبارات إذا لم يكن موجوداً
mkdir -p test/{unit,widget,integration}/{data,features,core}

# 3. أنشئ test helpers
mkdir -p test/helpers
mkdir -p test/mocks
mkdir -p test/fixtures
```

#### اليوم 2-3: اختبارات Repositories (8 ملفات)

**الملفات المطلوبة:**

```
test/unit/data/repositories/
├── customer_repository_test.dart          ⚡ ابدأ هنا
├── invoice_repository_test.dart
├── settings_repository_test.dart
├── auth_repository_test.dart
├── company_repository_test.dart
├── tax_repository_test.dart
├── backup_repository_test.dart
└── sync_repository_test.dart
```

**مثال سريع:**

```dart
// test/unit/data/repositories/customer_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  group('CustomerRepository', () {
    late Isar isar;
    late CustomerRepository repository;

    setUp(() async {
      // إعداد Isar في الذاكرة
      isar = await Isar.open(
        [CustomerModelSchema],
        directory: '',
        name: 'test_${DateTime.now().millisecondsSinceEpoch}',
      );
      repository = CustomerRepository(isar);
    });

    tearDown(() async {
      await isar.close(deleteFromDisk: true);
    });

    test('should add customer successfully', () async {
      // Arrange
      final customer = Customer(
        id: 'test-1',
        name: 'Test Customer',
        phone: '0501234567',
      );

      // Act
      await repository.addCustomer(customer);
      final customers = await repository.getAllCustomers();

      // Assert
      expect(customers.length, 1);
      expect(customers.first.name, 'Test Customer');
    });

    // أضف المزيد من الاختبارات...
  });
}
```

#### اليوم 4-5: اختبارات Services (4 ملفات)

**الملفات المطلوبة:**

```
test/unit/data/services/
├── auth_service_test.dart                 ⚡ ابدأ هنا
├── pdf_service_test.dart
├── settings_service_test.dart
└── backup_service_test.dart
```

#### اليوم 6-7: Test Helpers و Mocks

**الملفات المطلوبة:**

```
test/helpers/
├── test_helpers.dart                      ⚡ ابدأ هنا
├── mock_data.dart
└── test_utils.dart

test/mocks/
├── mock_secure_storage.dart
├── mock_customer_repository.dart
└── mock_invoice_repository.dart
```

---

## 🎯 المهمة الثانية: إكمال الميزات (الأسبوع 3-4)

### الأسبوع 3: Customers Screen

#### TODO المتبقية (6 TODO)

**الملف:** `lib/features/customers/presentation/screens/customers_screen.dart`

```dart
// TODO 1: تنفيذ البحث
void _handleSearch(String query) {
  // تنفيذ البحث في قائمة العملاء
}

// TODO 2: تنفيذ التصفية
void _handleFilter(CustomerFilter filter) {
  // تنفيذ التصفية حسب الحالة/التاريخ
}

// TODO 3: تنفيذ الترتيب
void _handleSort(SortOption option) {
  // ترتيب حسب الاسم/التاريخ
}

// TODO 4: تنفيذ التحديث
Future<void> _handleRefresh() async {
  // تحديث القائمة من قاعدة البيانات
}

// TODO 5: تنفيذ الحذف المتعدد
void _handleBulkDelete(List<String> ids) {
  // حذف عدة عملاء
}

// TODO 6: تنفيذ التصدير
Future<void> _handleExport() async {
  // تصدير القائمة كـ CSV/PDF
}
```

**خطة التنفيذ:**

```
اليوم 1: TODO 1-2 (البحث والتصفية)
اليوم 2: TODO 3-4 (الترتيب والتحديث)
اليوم 3: TODO 5-6 (الحذف والتصدير)
اليوم 4: الاختبار والتحسين
```

### الأسبوع 4: Invoices Screen

#### TODO المتبقية (8 TODO)

**الملف:** `lib/features/invoices/presentation/screens/invoices_screen.dart`

```dart
// TODO 1: تنفيذ البحث
// TODO 2: تنفيذ التصفية حسب الحالة
// TODO 3: تنفيذ التصفية حسب التاريخ
// TODO 4: تنفيذ الترتيب
// TODO 5: تنفيذ التحديث
// TODO 6: تنفيذ الحذف المتعدد
// TODO 7: تنفيذ التصدير
// TODO 8: تنفيذ الإحصائيات
```

**خطة التنفيذ:**

```
اليوم 1: TODO 1-3 (البحث والتصفية)
اليوم 2: TODO 4-5 (الترتيب والتحديث)
اليوم 3: TODO 6-7 (الحذف والتصدير)
اليوم 4: TODO 8 + الاختبار
```

---

## 🔧 المهمة الثالثة: تحسين الجودة (الأسبوع 5)

### اليوم 1-2: حل مشاكل flutter analyze (51 مشكلة)

```bash
# 1. عرض جميع المشاكل
flutter analyze

# 2. حل المشاكل تلقائياً (ما أمكن)
dart fix --apply

# 3. حل المشاكل المتبقية يدوياً
# راجع كل مشكلة وأصلحها

# 4. تحقق من النتيجة
flutter analyze
# الهدف: < 10 مشاكل
```

### اليوم 3: تقليل عدد Providers

**المشكلة:** 78 provider (مبالغ فيه)  
**الهدف:** ~20 provider

**خطة التقليل:**

```dart
// بدلاً من:
final customerProvider1 = Provider(...);
final customerProvider2 = Provider(...);
final customerProvider3 = Provider(...);

// استخدم:
final customerProvider = Provider.family<Customer, String>((ref, id) {
  // provider واحد لجميع العملاء
});
```

### اليوم 4-5: تحسين الأداء

**المهام:**

```
1. إضافة const constructors حيثما أمكن
2. تحسين استعلامات قاعدة البيانات
3. إضافة Caching للبيانات المتكررة
4. تحسين بناء الـ Widgets
5. قياس الأداء والتحقق
```

---

## 🎨 المهمة الرابعة: تحسين UX/UI (الأسبوع 6)

### اليوم 1-2: Animations و Transitions

```dart
// إضافة انتقالات سلسة
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextScreen(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(opacity: animation, child: child);
  },
);

// إضافة Hero animations
Hero(
  tag: 'customer-${customer.id}',
  child: CustomerCard(customer: customer),
);
```

### اليوم 3: Accessibility

```dart
// إضافة Semantics
Semantics(
  label: 'إضافة عميل جديد',
  button: true,
  child: FloatingActionButton(...),
);

// تحسين التباين
// استخدام ألوان متباينة للنصوص
```

### اليوم 4: Dark Mode

```dart
// تنفيذ Dark Mode
ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.blue,
  // ... المزيد من الألوان
);

MaterialApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.system,
);
```

### اليوم 5: Responsive Design

```dart
// استخدام LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return DesktopLayout();
    } else {
      return MobileLayout();
    }
  },
);
```

---

## 📊 تتبع التقدم

### قائمة التحقق اليومية

#### الأسبوع 1-2: Testing

- [ ] اليوم 1: إعداد البنية التحتية
- [ ] اليوم 2-3: اختبارات Repositories (8 ملفات)
- [ ] اليوم 4-5: اختبارات Services (4 ملفات)
- [ ] اليوم 6-7: Test Helpers و Mocks
- [ ] اليوم 8-10: اختبارات Providers و Widgets

**الهدف:** 40% test coverage

#### الأسبوع 3-4: Features

- [ ] الأسبوع 3: إكمال Customers Screen (6 TODO)
- [ ] الأسبوع 4: إكمال Invoices Screen (8 TODO)

**الهدف:** 0 TODO متبقية

#### الأسبوع 5: Quality

- [ ] اليوم 1-2: حل 51 مشكلة flutter analyze
- [ ] اليوم 3: تقليل Providers من 78 إلى ~20
- [ ] اليوم 4-5: تحسين الأداء

**الهدف:** < 10 مشاكل، أداء محسّن

#### الأسبوع 6: UX/UI

- [ ] اليوم 1-2: Animations و Transitions
- [ ] اليوم 3: Accessibility
- [ ] اليوم 4: Dark Mode
- [ ] اليوم 5: Responsive Design

**الهدف:** تجربة مستخدم ممتازة

---

## 🎯 مؤشرات النجاح

### بعد الأسبوع 2

- ✅ 40% test coverage
- ✅ 12 ملف اختبار جديد
- ✅ Test infrastructure جاهز

### بعد الأسبوع 4

- ✅ 0 TODO متبقية
- ✅ جميع الميزات تعمل
- ✅ 70% test coverage

### بعد الأسبوع 5

- ✅ < 10 مشاكل flutter analyze
- ✅ ~20 provider فقط
- ✅ أداء محسّن

### بعد الأسبوع 6

- ✅ Animations سلسة
- ✅ Accessibility كامل
- ✅ Dark Mode يعمل
- ✅ Responsive Design

---

## 🚀 ابدأ الآن!

### الخطوة الأولى (الآن)

```bash
# 1. افتح المواصفات
code .kiro/specs/testing-system/

# 2. راجع المهام
cat .kiro/specs/testing-system/tasks.md

# 3. ابدأ بالمهمة الأولى
# أنشئ أول ملف اختبار
code test/unit/data/repositories/customer_repository_test.dart
```

### الخطوة الثانية (بعد ساعة)

```bash
# 1. اكتب أول اختبار
# 2. شغّل الاختبار
flutter test test/unit/data/repositories/customer_repository_test.dart

# 3. تأكد من نجاحه
# 4. انتقل للاختبار التالي
```

### الخطوة الثالثة (نهاية اليوم)

```bash
# 1. راجع التقدم
flutter test --coverage

# 2. تحقق من التغطية
# 3. وثّق ما تم إنجازه
# 4. خطط لليوم التالي
```

---

## 📞 الدعم والمساعدة

### الموارد المتاحة

1. **المواصفات الكاملة:**

   - `.kiro/specs/testing-system/`
   - `.kiro/specs/MASTER_SPECS_ENGINEERING_ANALYSIS.md`

2. **المعايير والتوجيهات:**

   - `.kiro/steering/flutter-best-practices.md`
   - `.kiro/steering/testing-best-practices.md`
   - `.kiro/steering/code-quality-standards.md`

3. **الأمثلة:**
   - `test/unit/data/models/` (اختبارات موجودة)
   - `.kiro/specs/documentation-system/EXAMPLES.md`

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 1 ديسمبر 2025  
**الحالة:** 🚀 جاهز للتنفيذ الفوري

**الرسالة:** لا تنتظر! ابدأ الآن بأول اختبار! 💪
