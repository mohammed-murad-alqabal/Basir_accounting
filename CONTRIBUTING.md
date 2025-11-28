# 🤝 دليل المساهمة - مشروع بصير MVP

مرحباً بك في مشروع بصير! نحن سعداء بمساهمتك.

---

## 📋 قبل البدء

### المتطلبات الأساسية

- Flutter 3.24.0+
- Dart 3.5.0+
- Git
- محرر كود (VS Code موصى به)

### قراءة التوثيق

قبل المساهمة، يرجى قراءة:

1. `README.md` - نظرة عامة على المشروع
2. `.kiro/README.md` - دليل Kiro Strategic Blueprint
3. `.kiro/steering/philosophy.md` - المبادئ الأساسية
4. `.kiro/steering/flutter-best-practices.md` - أفضل الممارسات

---

## 🎯 المبادئ الأساسية

### 0️⃣ Security First (الأمان أولاً)

- ✅ لا تخزن أسرار في الكود
- ✅ استخدم flutter_secure_storage للبيانات الحساسة
- ✅ اتبع معايير OWASP

### 1️⃣ Spec-Driven Development (التطوير الموجه بالمواصفات)

- ✅ كل ميزة تبدأ بـ spec
- ✅ دورة: Requirements → Design → Tasks
- ✅ لا كود بدون spec موافق عليه

### 2️⃣ Quality First (الجودة أولاً)

- ✅ تغطية 70%+ اختبارات
- ✅ 0 errors, 0 warnings
- ✅ توثيق جميع public APIs

---

## 🚀 البدء

### 1. Fork & Clone

```bash
# Fork المشروع على GitHub
# ثم clone

git clone https://github.com/YOUR_USERNAME/Basser_MVP.git
cd Basser_MVP
```

### 2. الإعداد

```bash
# تثبيت التبعيات
flutter pub get

# توليد الكود
flutter pub run build_runner build --delete-conflicting-outputs

# تشغيل الاختبارات
flutter test

# تشغيل التطبيق
flutter run
```

### 3. إنشاء Branch

```bash
# إنشاء branch للميزة
git checkout -b feature/your-feature-name

# أو للإصلاح
git checkout -b fix/bug-description
```

---

## 📝 عملية المساهمة

### الخطوة 1: إنشاء Spec (إذا كانت ميزة جديدة)

```bash
# اطلب من Kiro
"أريد إنشاء spec لميزة [اسم الميزة]"

# أو أنشئ يدوياً في
.kiro/specs/[feature-name]/
├── requirements.md
├── design.md
└── tasks.md
```

### الخطوة 2: كتابة الكود

```dart
// اتبع معايير Dart
// استخدم const حيثما أمكن
// وثّق public APIs

/// يقوم بإضافة عميل جديد
///
/// **Parameters:**
/// - `customer`: بيانات العميل
///
/// **Returns:** Future<void>
///
/// **Throws:** ValidationException إذا كانت البيانات غير صحيحة
Future<void> addCustomer(Customer customer) async {
  // Implementation
}
```

### الخطوة 3: كتابة الاختبارات

```dart
void main() {
  group('CustomerRepository', () {
    late CustomerRepository repository;

    setUp(() {
      // Arrange
      repository = CustomerRepositoryImpl();
    });

    test('should add customer successfully', () async {
      // Arrange
      final customer = Customer(id: '1', name: 'Test');

      // Act
      await repository.addCustomer(customer);
      final customers = await repository.getAllCustomers();

      // Assert
      expect(customers.length, 1);
      expect(customers.first.name, 'Test');
    });
  });
}
```

### الخطوة 4: التحقق من الجودة

```bash
# تنسيق الكود
dart format lib/ test/

# تحليل الكود
flutter analyze

# تشغيل الاختبارات
flutter test

# فحص التغطية
flutter test --coverage
```

### الخطوة 5: Commit & Push

```bash
# إضافة التغييرات
git add .

# Commit (سيعمل security_scan تلقائياً)
git commit -m "feat: add customer management feature"

# Push (سيعمل quality_gate تلقائياً)
git push origin feature/your-feature-name
```

### الخطوة 6: إنشاء Pull Request

1. اذهب إلى GitHub
2. اضغط "New Pull Request"
3. املأ القالب:
   - وصف التغييرات
   - رابط الـ Spec (إن وجد)
   - لقطات شاشة (للـ UI)
   - قائمة التحقق

---

## 📐 معايير الكود

### التسمية

```dart
// Classes: PascalCase
class CustomerRepository {}

// Functions: camelCase
void addCustomer() {}

// Variables: camelCase
final customerList = [];

// Constants: lowerCamelCase
const maxRetries = 3;

// Private: _prefix
void _privateMethod() {}
```

### البنية

```
lib/
├── core/           # مشترك
├── features/       # حسب الميزة
└── data/          # البيانات
```

### الاستيراد

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages
import 'package:riverpod/riverpod.dart';

// 4. Relative
import '../models/customer.dart';
```

---

## 🧪 الاختبارات

### أنواع الاختبارات

1. **Unit Tests** - للدوال والـ classes
2. **Widget Tests** - للـ widgets
3. **Integration Tests** - للتدفقات الكاملة

### معايير الاختبار

- ✅ تغطية 70%+
- ✅ نمط AAA (Arrange, Act, Assert)
- ✅ أسماء واضحة
- ✅ مستقلة (لا تعتمد على بعضها)
- ✅ سريعة (< 100ms للواحد)

---

## 🔍 مراجعة الكود

### ما نبحث عنه

- ✅ الالتزام بالمبادئ الأساسية
- ✅ جودة الكود
- ✅ التغطية بالاختبارات
- ✅ التوثيق
- ✅ الأمان
- ✅ الأداء

### عملية المراجعة

1. **Automated Checks** - CI/CD
2. **Code Review** - من المطورين
3. **Testing** - اختبار يدوي
4. **Approval** - موافقة نهائية
5. **Merge** - دمج في main

---

## 🐛 الإبلاغ عن Bugs

### قالب Bug Report

```markdown
**الوصف:**
وصف واضح للمشكلة

**خطوات إعادة الإنتاج:**

1. اذهب إلى '...'
2. اضغط على '...'
3. شاهد الخطأ

**السلوك المتوقع:**
ما كان يجب أن يحدث

**السلوك الفعلي:**
ما حدث فعلاً

**لقطات الشاشة:**
إن وجدت

**البيئة:**

- OS: [e.g. Android 13]
- Flutter: [e.g. 3.24.0]
- Device: [e.g. Pixel 6]
```

---

## 💡 اقتراح ميزات

### قالب Feature Request

```markdown
**المشكلة:**
ما المشكلة التي تحلها هذه الميزة؟

**الحل المقترح:**
كيف تريد حل المشكلة؟

**البدائل:**
هل فكرت في حلول أخرى؟

**السياق الإضافي:**
أي معلومات إضافية
```

---

## 📞 الدعم

### للحصول على المساعدة

1. راجع التوثيق
2. ابحث في Issues الموجودة
3. اسأل في Discussions
4. افتح Issue جديد

### القنوات

- **GitHub Issues** - للـ bugs والميزات
- **GitHub Discussions** - للأسئلة
- **Email** - للأمور الحساسة

---

## ✅ قائمة التحقق للـ PR

قبل إنشاء Pull Request، تأكد من:

- [ ] الكود منسق (dart format)
- [ ] لا توجد أخطاء (flutter analyze)
- [ ] جميع الاختبارات ناجحة
- [ ] التغطية ≥ 70%
- [ ] التوثيق محدث
- [ ] لا توجد أسرار في الكود
- [ ] Spec موجود (للميزات الجديدة)
- [ ] لقطات شاشة (للـ UI changes)
- [ ] Changelog محدث

---

## 🎓 الموارد

### التوثيق

- [Flutter Docs](https://docs.flutter.dev)
- [Riverpod Docs](https://riverpod.dev)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart)

### المشروع

- `.kiro/README.md` - دليل Kiro
- `.kiro/steering/` - ملفات الحوكمة
- `Documentation/` - توثيق المشروع

---

## 📜 الترخيص

بالمساهمة في هذا المشروع، أنت توافق على أن مساهماتك ستكون مرخصة تحت نفس ترخيص المشروع.

---

## 🙏 شكراً

شكراً لمساهمتك في جعل بصير أفضل! 🎉

---

**آخر تحديث:** 27 نوفمبر 2025  
**الإصدار:** 1.0
