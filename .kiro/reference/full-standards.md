# المعايير الكاملة - مرجع شامل

**المشروع:** بصير MVP  
**التاريخ:** 7 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## نظرة عامة

هذا الملف يحتوي على جميع المعايير التفصيلية للمشروع. يُستخدم كمرجع عند الحاجة للمعلومات التفصيلية.

**للاستخدام اليومي:** راجع الملفات المختصرة في `standards/`

---

## الفهرس

1. [معايير التسمية](#معايير-التسمية)
2. [معايير جودة الكود](#معايير-جودة-الكود)
3. [معايير Flutter](#معايير-flutter)
4. [معايير اللغة العربية](#معايير-اللغة-العربية)
5. [معايير التوثيق](#معايير-التوثيق)
6. [معايير الاختبارات](#معايير-الاختبارات)
7. [معايير الأمان](#معايير-الأمان)
8. [معايير Git](#معايير-git)

---

## معايير التسمية

### القواعد الأساسية

#### الملفات والمجلدات

- **snake_case** لجميع الملفات والمجلدات
- أسماء وصفية ودقيقة
- تجنب الاختصارات غير الواضحة

**أمثلة:**

```
✅ customer_repository.dart
✅ invoice_model.dart
✅ auth_service.dart
❌ CustomerRepository.dart
❌ custRepo.dart
```

#### Classes و Enums

- **PascalCase** دائماً
- أسماء واضحة تعبر عن الغرض

**أمثلة:**

```dart
✅ class CustomerRepository { }
✅ enum InvoiceStatus { }
❌ class customerRepository { }
❌ class CustRepo { }
```

#### Methods و Functions

- **camelCase** دائماً
- أفعال واضحة تصف الإجراء

**أمثلة:**

```dart
✅ Future<void> addCustomer(Customer customer) async { }
✅ List<Invoice> getAllInvoices() { }
❌ Future<void> AddCustomer() { }
❌ List<Invoice> getAll() { }
```

#### Variables و Properties

- **camelCase** للمتغيرات العادية
- **lowerCamelCase** للثوابت
- **\_prefix** للمتغيرات الخاصة

**أمثلة:**

```dart
✅ String customerName;
✅ final maxRetries = 3;
✅ String _privateToken;
❌ String name;  // غير محدد
❌ final MAX_RETRIES = 3;  // SCREAMING_SNAKE_CASE
```

---

## معايير جودة الكود

### SOLID Principles

#### 1. Single Responsibility Principle (SRP)

كل class يجب أن يكون له مسؤولية واحدة فقط.

**مثال صحيح:**

```dart
class CustomerRepository {
  Future<List<Customer>> getAllCustomers() async { }
  Future<void> addCustomer(Customer customer) async { }
}

class CustomerValidator {
  static String? validateName(String? value) { }
  static String? validatePhone(String? value) { }
}
```

#### 2. Open/Closed Principle (OCP)

مفتوح للتوسع، مغلق للتعديل.

**مثال صحيح:**

```dart
abstract class PaymentMethod {
  Future<bool> processPayment(double amount);
}

class CashPayment implements PaymentMethod {
  @override
  Future<bool> processPayment(double amount) async {
    return true;
  }
}
```

#### 3. Liskov Substitution Principle (LSP)

يجب أن تكون الأنواع الفرعية قابلة للاستبدال بأنواعها الأساسية.

#### 4. Interface Segregation Principle (ISP)

لا تجبر class على تنفيذ interfaces لا يحتاجها.

#### 5. Dependency Inversion Principle (DIP)

الاعتماد على abstractions وليس على implementations.

### Clean Code Principles

#### Meaningful Names

- أسماء واضحة تعبر عن الغرض
- تجنب الاختصارات المبهمة
- استخدام أسماء قابلة للنطق

#### Small Functions

- دالة واحدة = مسؤولية واحدة
- الحد الأقصى: 20-30 سطر
- مستوى واحد من التجريد

#### DRY (Don't Repeat Yourself)

- تجنب تكرار الكود
- استخدام functions للكود المتكرر
- استخدام constants للقيم المتكررة

---

## معايير Flutter

### البنية المعمارية

#### Clean Architecture

- **Presentation Layer**: Screens, Widgets, Providers
- **Domain Layer**: Business Logic, Use Cases
- **Data Layer**: Models, Repositories, Services

#### Feature-First Organization

```
lib/
├── core/          # مشترك
├── features/      # حسب الميزة
└── data/          # البيانات
```

### إدارة الحالة

#### Riverpod (الموصى به)

- `Provider`: قيم ثابتة
- `StateProvider`: حالات بسيطة
- `FutureProvider`: async operations
- `StateNotifierProvider`: حالات معقدة

### قاعدة البيانات

#### Isar (المعتمد)

- استخدام Isar في الذاكرة للاختبارات
- إغلاق الاتصالات بشكل صحيح
- استخدام Transactions للعمليات المتعددة
- إنشاء Indexes للبحث

### الأمان

#### التخزين الآمن

- استخدام `flutter_secure_storage`
- عدم تخزين كلمات المرور بشكل نصي
- استخدام Hashing (SHA-256+)

### الأداء

#### التحسينات

- استخدام `const` constructors
- تجنب rebuilds غير ضرورية
- استخدام `ListView.builder`
- Lazy loading للصور

### دعم RTL

#### القواعد

- استخدام `Directionality`
- اختبار في كلا الاتجاهين
- استخدام خطوط عربية مناسبة
- `TextAlign.start` بدلاً من `left`

---

## معايير اللغة العربية

### المصطلحات الموحدة

| English  | العربية        | ملاحظات          |
| :------- | :------------- | :--------------- |
| Customer | عميل           | ليس "زبون"       |
| Invoice  | فاتورة         | ليس "إيصال"      |
| Item     | بند            | في سياق الفاتورة |
| Total    | الإجمالي       | ليس "المجموع"    |
| Subtotal | المجموع الفرعي | قبل الضريبة      |
| Tax      | الضريبة        | ليس "الرسوم"     |
| Discount | الخصم          | ليس "التخفيض"    |
| Payment  | الدفع          | ليس "السداد"     |

### حالات الفاتورة

| English   | العربية |
| :-------- | :------ |
| Draft     | مسودة   |
| Sent      | مرسلة   |
| Paid      | مدفوعة  |
| Overdue   | متأخرة  |
| Cancelled | ملغاة   |

### الإجراءات

| English | العربية |
| :------ | :------ |
| Add     | إضافة   |
| Edit    | تعديل   |
| Delete  | حذف     |
| Save    | حفظ     |
| Cancel  | إلغاء   |
| Search  | بحث     |
| Filter  | تصفية   |
| Export  | تصدير   |
| Print   | طباعة   |

### قواعد الكتابة

#### علامات الترقيم

- الفاصلة العربية (،) وليس الإنجليزية (,)
- علامة الاستفهام العربية (؟) وليس الإنجليزية (?)
- النقطة (.) في نهاية الجمل

#### الأرقام

- **الموصى به:** الأرقام الهندية (123)
- الفاصلة (،) لفصل الآلاف
- النقطة (.) للكسور العشرية

---

## معايير التوثيق

### DartDoc

#### الإلزامي

- توثيق جميع public APIs
- شرح المعاملات والقيم المرجعة
- إضافة أمثلة

#### الصيغة

````dart
/// يضيف عميل جديد إلى قاعدة البيانات.
///
/// [customer] العميل المراد إضافته.
///
/// Throws [ValidationException] إذا كانت البيانات غير صحيحة.
///
/// مثال:
/// ```dart
/// await repository.addCustomer(customer);
/// ```
Future<void> addCustomer(Customer customer);
````

### التعليقات

#### TODO Comments

```dart
// TODO(developer): إضافة validation لرقم الهاتف
```

#### التعليقات الداخلية

- استخدام `//` للتعليقات القصيرة
- استخدام `/* */` للتعليقات الطويلة
- شرح "لماذا" وليس "ماذا"

---

## معايير الاختبارات

### الأنواع

#### Unit Tests

- **الهدف:** اختبار الدوال والـ Classes المعزولة
- **التغطية:** 70%+
- **السرعة:** سريعة جداً

#### Widget Tests

- **الهدف:** اختبار الـ Widgets
- **التغطية:** المسارات الحرجة
- **السرعة:** سريعة

#### Integration Tests

- **الهدف:** اختبار التدفقات الكاملة
- **التغطية:** رحلات المستخدم
- **السرعة:** متوسطة

### القواعد الأساسية

#### الإلزامي

- اختبار كل public function
- اختبار الحالات الطبيعية والاستثنائية
- استخدام mocks للـ dependencies
- اختبارات مستقلة

#### الممنوع

- اختبارات تعتمد على بعضها
- اختبارات بطيئة (> 30 ثانية للكل)
- استخدام بيانات حقيقية
- mocks لجعل الاختبارات تنجح

---

## معايير الأمان

### التخزين الآمن

- استخدام `flutter_secure_storage`
- عدم تخزين كلمات المرور بشكل نصي
- استخدام Hashing (SHA-256+)

### Input Validation

- التحقق من جميع المدخلات
- استخدام whitelist validation
- تجنب injection attacks

### Secure Storage

- استخدام secure storage للبيانات الحساسة
- تشفير البيانات
- عدم تخزين بيانات حساسة في plain text

---

## معايير Git

### Commit Messages

- **القاعدة:** اتباع Conventional Commits
- **الصيغة:** `type(scope): description`
- **الأنواع:** feat, fix, docs, style, refactor, test, chore

### Branching Strategy

- **الأساسية:** استخدام فروع الميزات
- **الاستقرار:** الفرع الرئيسي مستقر دائماً
- **التنظيف:** حذف الفروع المدمجة

---

## المراجع

### للمزيد من التفاصيل

- `standards/naming.md` - معايير التسمية المختصرة
- `standards/code-quality.md` - معايير الجودة المختصرة
- `standards/flutter.md` - معايير Flutter المختصرة
- `standards/arabic.md` - معايير العربية المختصرة
- `standards/documentation.md` - معايير التوثيق المختصرة
- `standards/testing.md` - معايير الاختبارات المختصرة

### الأدلة التفصيلية

- `guides/flutter-guide.md` - دليل Flutter الكامل
- `guides/git-guide.md` - دليل Git الكامل
- `guides/security-guide.md` - دليل الأمان الكامل

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 7 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
