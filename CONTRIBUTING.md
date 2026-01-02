# دليل المساهمة في مشروع بصير

**المشروع:** بصير MVP  
**التاريخ:** 30 نوفمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير

---

## 🎯 مرحباً بك!

شكراً لاهتمامك بالمساهمة في مشروع بصير! هذا الدليل سيساعدك على فهم كيفية المساهمة بشكل فعال.

---

## 📋 المتطلبات الأساسية

### الأدوات المطلوبة

- Flutter SDK: `^3.5.0`
- Dart: `^3.5.0`
- Git: `2.x+`
- IDE: VS Code أو Android Studio

### التحقق من الإعداد

```bash
flutter --version
dart --version
git --version
```

---

## 🔀 Git Workflow

### الفرع الرئيسي

حالياً، نستخدم `master` كفرع رئيسي للتطوير.

```bash
# التأكد من أنك على الفرع الصحيح
git checkout master

# تحديث الفرع
git pull origin master
```

### رسائل الـ Commits

نستخدم **Conventional Commits** لتوحيد رسائل الـ commits.

#### الصيغة

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### الأنواع (Types)

| النوع      | الاستخدام      | مثال                                         |
| :--------- | :------------- | :------------------------------------------- |
| `feat`     | ميزة جديدة     | `feat(customers): add customer search`       |
| `fix`      | إصلاح خطأ      | `fix(invoice): resolve PDF generation issue` |
| `docs`     | تحديث توثيق    | `docs(readme): update installation guide`    |
| `style`    | تنسيق الكود    | `style(auth): format login screen`           |
| `refactor` | إعادة هيكلة    | `refactor(models): simplify customer model`  |
| `test`     | إضافة اختبارات | `test(invoice): add unit tests`              |
| `chore`    | مهام صيانة     | `chore(deps): update dependencies`           |
| `perf`     | تحسين الأداء   | `perf(db): optimize query performance`       |

#### أمثلة صحيحة ✅

```bash
# ميزة جديدة
git commit -m "feat(customers): add customer search functionality"

# إصلاح خطأ
git commit -m "fix(invoice): resolve PDF generation issue

- Fixed date formatting
- Updated tax calculation
- Improved error handling"

# تحديث توثيق
git commit -m "docs(api): update API documentation"

# إعادة هيكلة
git commit -m "refactor(models): simplify customer model structure"
```

#### أمثلة خاطئة ❌

```bash
# غير واضح
git commit -m "fix bug"

# بدون type
git commit -m "update customer screen"

# غير محدد
git commit -m "changes"
```

---

## ✅ قبل كل Commit

### 1. تشغيل التحليل

```bash
flutter analyze --no-pub
```

**يجب أن تكون النتيجة:**

```
No issues found!
```

### 2. تشغيل الاختبارات

```bash
flutter test --no-pub
```

**يجب أن تنجح جميع الاختبارات:**

```
All tests passed!
```

### 3. التنسيق

```bash
dart format lib/ test/
```

---

## 🧪 معايير الاختبار

### تغطية الاختبارات

- **الحد الأدنى:** 70%
- **المستهدف:** 80%+

### أنواع الاختبارات

#### 1. Unit Tests

```dart
test('should add customer successfully', () {
  // Arrange
  final customer = Customer(name: 'أحمد', phone: '0501234567');

  // Act
  repository.addCustomer(customer);

  // Assert
  expect(repository.customers.length, equals(1));
});
```

#### 2. Widget Tests

```dart
testWidgets('should display customer name', (tester) async {
  await tester.pumpWidget(CustomerCard(customer: customer));
  expect(find.text('أحمد'), findsOneWidget);
});
```

#### 3. Integration Tests

```dart
testWidgets('should complete full invoice flow', (tester) async {
  // Test complete user journey
});
```

---

## 📝 معايير الكود

### التسمية

اتبع [naming-conventions.md](.kiro/steering/naming-conventions.md):

```dart
// ✅ صحيح
class CustomerRepository { }
final customerName = 'أحمد';
Future<void> addCustomer() async { }

// ❌ خاطئ
class customer_repository { }
final CustomerName = 'أحمد';
Future<void> AddCustomer() async { }
```

### التوثيق

```dart
/// يضيف عميل جديد إلى قاعدة البيانات.
///
/// [customer] العميل المراد إضافته.
///
/// Throws [ValidationException] إذا كانت البيانات غير صحيحة.
Future<void> addCustomer(Customer customer) async {
  // implementation
}
```

### الجودة

- اتبع [code-quality-standards.md](.kiro/steering/code-quality-standards.md)
- اتبع [flutter-best-practices.md](.kiro/steering/flutter-best-practices.md)
- اتبع مبادئ SOLID

---

## 🔒 الأمان

### قواعد الأمان

1. **لا تخزن أسرار في الكود**

   ```dart
   // ❌ خاطئ
   const apiKey = 'redacted';

   // ✅ صحيح
   final apiKey = await secureStorage.read(key: 'api_key');
   ```

2. **استخدم flutter_secure_storage**

   ```dart
   await secureStorage.write(key: 'password', value: hashedPassword);
   ```

3. **تحقق من جميع المدخلات**
   ```dart
   String? validatePhone(String? value) {
     if (value == null || value.isEmpty) {
       return 'رقم الهاتف مطلوب';
     }
     // validation logic
   }
   ```

---

## 🚀 عملية المساهمة

### الخطوات

#### 1. استنساخ المستودع

```bash
git clone https://github.com/your-username/Basir_MVP.git
cd Basir_MVP
```

#### 2. تثبيت التبعيات

```bash
flutter pub get
```

#### 3. إنشاء فرع (اختياري للميزات الكبيرة)

```bash
git checkout -b feature/customer-search
```

#### 4. إجراء التغييرات

- اكتب الكود
- اكتب الاختبارات
- وثق الكود

#### 5. التحقق من الجودة

```bash
# تحليل
flutter analyze --no-pub

# اختبارات
flutter test --no-pub

# تنسيق
dart format lib/ test/
```

#### 6. Commit

```bash
git add .
git commit -m "feat(customers): add customer search functionality"
```

#### 7. Push

```bash
git push origin master
# أو
git push origin feature/customer-search
```

---

## 📚 الموارد

### الوثائق

- [README.md](README.md) - نظرة عامة على المشروع
- [ARCHITECTURE.md](ARCHITECTURE.md) - البنية المعمارية
- [.kiro/steering/](. kiro/steering/) - المعايير والتوجيهات

### المعايير

- [philosophy.md](.kiro/steering/philosophy.md) - الفلسفة الهندسية
- [tech-stack.md](.kiro/steering/tech-stack.md) - المكدس التقني
- [structure.md](.kiro/steering/structure.md) - البنية الهيكلية
- [security.md](.kiro/steering/security.md) - معايير الأمان

---

## 🐛 الإبلاغ عن الأخطاء

### قبل الإبلاغ

1. تحقق من أن الخطأ لم يتم الإبلاغ عنه مسبقاً
2. تأكد من أنك تستخدم أحدث إصدار
3. جرب إعادة إنتاج الخطأ

### معلومات مطلوبة

```markdown
## وصف الخطأ

وصف واضح ومختصر للخطأ.

## خطوات إعادة الإنتاج

1. اذهب إلى '...'
2. اضغط على '...'
3. انتقل إلى '...'
4. شاهد الخطأ

## السلوك المتوقع

ما كان يجب أن يحدث.

## السلوك الفعلي

ما حدث بالفعل.

## لقطات الشاشة

إن وجدت.

## البيئة

- OS: [e.g. Android 13]
- Flutter: [e.g. 3.5.0]
- Device: [e.g. Samsung Galaxy S21]
```

---

## 💡 اقتراح ميزات

### قالب الاقتراح

```markdown
## وصف الميزة

وصف واضح للميزة المقترحة.

## المشكلة التي تحلها

ما المشكلة التي ستحلها هذه الميزة؟

## الحل المقترح

كيف يمكن تنفيذ هذه الميزة؟

## البدائل

هل هناك بدائل أخرى؟

## معلومات إضافية

أي معلومات أخرى مفيدة.
```

---

## ❓ الأسئلة الشائعة

### كيف أبدأ؟

1. اقرأ [README.md](README.md)
2. اقرأ [ARCHITECTURE.md](ARCHITECTURE.md)
3. راجع [.kiro/steering/](.kiro/steering/)
4. جرب تشغيل المشروع

### كيف أختبر تغييراتي؟

```bash
# اختبارات محددة
flutter test test/unit/models/customer_test.dart

# جميع الاختبارات
flutter test

# مع التغطية
flutter test --coverage
```

### كيف أحل مشاكل التحليل؟

```bash
# عرض المشاكل
flutter analyze

# إصلاح تلقائي
dart fix --apply
```

### كيف أحدث التبعيات؟

```bash
# تحديث
flutter pub upgrade

# تحديث major versions
flutter pub upgrade --major-versions
```

---

## 🤝 قواعد السلوك

### التزاماتنا

- احترام جميع المساهمين
- قبول النقد البناء
- التركيز على ما هو أفضل للمشروع
- إظهار التعاطف مع الآخرين

### السلوك المقبول

- ✅ استخدام لغة ترحيبية وشاملة
- ✅ احترام وجهات النظر المختلفة
- ✅ قبول النقد البناء بلطف
- ✅ التركيز على ما هو أفضل للمجتمع

### السلوك غير المقبول

- ❌ استخدام لغة أو صور جنسية
- ❌ التعليقات المسيئة أو المهينة
- ❌ المضايقة العامة أو الخاصة
- ❌ نشر معلومات خاصة للآخرين

---

## 📞 التواصل

### للأسئلة

- افتح Issue على GitHub
- راجع الوثائق أولاً

### للمساعدة

- راجع [README.md](README.md)
- راجع [ARCHITECTURE.md](ARCHITECTURE.md)
- افتح Discussion على GitHub

---

## 🎉 شكراً لك!

شكراً لمساهمتك في مشروع بصير! كل مساهمة، مهما كانت صغيرة، تساعد في تحسين المشروع.

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 30 نوفمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
