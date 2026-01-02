# دليل المساهمة

## Contributing Guide

شكراً لاهتمامك بالمساهمة في مشروع بصير MVP! 🎉

---

## 📋 جدول المحتويات

1. [قواعد السلوك](#قواعد-السلوك)
2. [كيفية المساهمة](#كيفية-المساهمة)
3. [سير العمل](#سير-العمل)
4. [معايير الكود](#معايير-الكود)
5. [الاختبارات](#الاختبارات)
6. [التوثيق](#التوثيق)
7. [الإبلاغ عن الأخطاء](#الإبلاغ-عن-الأخطاء)
8. [طلب الميزات](#طلب-الميزات)

---

## قواعد السلوك

### مبادئنا

- 🤝 **الاحترام:** نحترم جميع المساهمين
- 💡 **الانفتاح:** نرحب بجميع الأفكار
- 🎯 **التركيز:** نركز على الجودة
- 📚 **التعلم:** نتعلم من بعضنا البعض

### السلوك المتوقع

✅ استخدام لغة ترحيبية وشاملة  
✅ احترام وجهات النظر المختلفة  
✅ قبول النقد البناء بلطف  
✅ التركيز على ما هو أفضل للمجتمع  
✅ إظهار التعاطف مع أعضاء المجتمع الآخرين

### السلوك غير المقبول

❌ استخدام لغة أو صور جنسية  
❌ التعليقات المسيئة أو الشخصية  
❌ المضايقة العامة أو الخاصة  
❌ نشر معلومات خاصة للآخرين  
❌ أي سلوك غير مهني آخر

---

## كيفية المساهمة

### أنواع المساهمات

نرحب بجميع أنواع المساهمات:

- 🐛 **إصلاح الأخطاء**
- ✨ **ميزات جديدة**
- 📝 **تحسين التوثيق**
- 🧪 **إضافة اختبارات**
- 🎨 **تحسين التصميم**
- ♻️ **إعادة هيكلة الكود**
- ⚡ **تحسين الأداء**

### قبل البدء

1. **تحقق من Issues الموجودة**

   - ابحث عن Issue مشابه
   - إذا لم تجد، أنشئ Issue جديد

2. **ناقش التغييرات الكبيرة**

   - للميزات الكبيرة، أنشئ Issue أولاً
   - ناقش التصميم مع الفريق
   - احصل على موافقة قبل البدء

3. **اقرأ التوثيق**
   - [Git/GitHub Guide](../docs/GIT_GITHUB_GUIDE.md)
   - [Flutter Best Practices](.kiro/steering/flutter-best-practices.md)
   - [Tech Stack](.kiro/steering/tech-stack.md)

---

## سير العمل

### 1. Fork المشروع

```bash
# على GitHub، انقر Fork
# ثم clone الـ fork الخاص بك
git clone https://github.com/YOUR_USERNAME/Basir_MVP.git
cd Basir_MVP
```

### 2. إعداد البيئة

```bash
# تثبيت التبعيات
flutter pub get

# إعداد Git
./scripts/setup_git.sh

# التحقق من البيئة
flutter doctor
flutter analyze
flutter test
```

### 3. إنشاء فرع

```bash
# للميزات
git checkout -b feature/my-feature

# للإصلاحات
git checkout -b fix/bug-name

# للتوثيق
git checkout -b docs/doc-name
```

### 4. كتابة الكود

```bash
# اتبع معايير الكود
# أضف اختبارات
# حدث التوثيق
```

### 5. Commit

```bash
# استخدم Conventional Commits
git add .
git commit -m "feat(scope): description"
```

### 6. Push

```bash
git push origin feature/my-feature
```

### 7. إنشاء Pull Request

1. اذهب إلى GitHub
2. انقر "New Pull Request"
3. املأ القالب بالكامل
4. انتظر المراجعة

---

## معايير الكود

### Flutter/Dart

#### 1. التنسيق

```bash
# تنسيق الكود
flutter format lib/ test/

# التحقق من التنسيق
flutter format --set-exit-if-changed lib/ test/
```

#### 2. التحليل

```bash
# تشغيل التحليل
flutter analyze

# يجب أن يكون 0 errors
```

#### 3. التسمية

```dart
// ✅ جيد
class CustomerRepository {}
void getAllCustomers() {}
final customerList = [];

// ❌ سيء
class customer_repository {}
void GetAllCustomers() {}
final CustomerList = [];
```

#### 4. التوثيق

````dart
/// وصف مختصر للـ class/function
///
/// وصف مفصل يشرح الغرض والاستخدام
///
/// Parameters:
/// - [param1]: وصف المعامل
///
/// Returns: وصف القيمة المرجعة
///
/// Example:
/// ```dart
/// final result = myFunction(param1);
/// ```
void myFunction(String param1) {
  // implementation
}
````

#### 5. معالجة الأخطاء

```dart
// ✅ جيد
try {
  // code
} on SpecificException catch (e, stackTrace) {
  debugPrint('Error: $e');
  debugPrint('Stack trace: $stackTrace');
  // handle
} on Exception catch (e, stackTrace) {
  debugPrint('Error: $e');
  debugPrint('Stack trace: $stackTrace');
  // handle
}

// ❌ سيء
try {
  // code
} catch (e) {
  print('Error: $e');
}
```

### Git

#### 1. Commits

```bash
# ✅ جيد
git commit -m "feat(auth): إضافة تسجيل دخول بالبصمة"

# ❌ سيء
git commit -m "update"
```

#### 2. الفروع

```bash
# ✅ جيد
feature/biometric-auth
fix/login-error
docs/api-documentation

# ❌ سيء
test
my-branch
update
```

---

## الاختبارات

### متطلبات الاختبارات

- ✅ **تغطية ≥ 70%**
- ✅ **جميع الاختبارات تنجح**
- ✅ **اختبارات Unit للمنطق**
- ✅ **اختبارات Widget للواجهة**
- ✅ **اختبارات Integration للتدفقات**

### كتابة الاختبارات

```dart
// test/features/auth/auth_service_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('should login successfully with valid credentials', () async {
      // Arrange
      final username = 'test@example.com';
      final password = 'redacted';

      // Act
      final result = await authService.login(username, password);

      // Assert
      expect(result.isSuccess, true);
      expect(result.user, isNotNull);
    });

    test('should fail login with invalid credentials', () async {
      // Arrange
      final username = 'test@example.com';
      final password = 'wrong';

      // Act
      final result = await authService.login(username, password);

      // Assert
      expect(result.isSuccess, false);
      expect(result.error, isNotNull);
    });
  });
}
```

### تشغيل الاختبارات

```bash
# جميع الاختبارات
flutter test

# اختبار محدد
flutter test test/features/auth/auth_service_test.dart

# مع التغطية
flutter test --coverage

# عرض التغطية
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## التوثيق

### أنواع التوثيق

#### 1. Code Documentation

```dart
/// توثيق الكود باستخدام DartDoc
```

#### 2. README

```markdown
# تحديث README.md عند إضافة ميزات جديدة
```

#### 3. CHANGELOG

```markdown
## [Unreleased]

### Added

- ميزة جديدة

### Fixed

- إصلاح خطأ
```

#### 4. Technical Documentation

```markdown
# إضافة توثيق تقني في docs/
```

---

## الإبلاغ عن الأخطاء

### قبل الإبلاغ

1. **ابحث في Issues الموجودة**
2. **تحقق من أنك تستخدم آخر إصدار**
3. **جرب إعادة إنتاج الخطأ**

### إنشاء Bug Report

1. اذهب إلى [Issues](../../issues)
2. انقر "New Issue"
3. اختر "Bug Report"
4. املأ القالب:
   - وصف الخطأ
   - خطوات إعادة الإنتاج
   - السلوك المتوقع vs الفعلي
   - البيئة
   - لقطات الشاشة
   - سجلات الأخطاء

---

## طلب الميزات

### قبل الطلب

1. **ابحث في Issues الموجودة**
2. **تأكد من توافق الميزة مع أهداف المشروع**
3. **فكر في التأثير على المستخدمين**

### إنشاء Feature Request

1. اذهب إلى [Issues](../../issues)
2. انقر "New Issue"
3. اختر "Feature Request"
4. املأ القالب:
   - وصف الميزة
   - المشكلة التي تحلها
   - الحل المقترح
   - البدائل
   - الأولوية

---

## مراجعة الكود

### للمطور

#### قبل طلب المراجعة

- ✅ جميع الاختبارات تنجح
- ✅ لا توجد أخطاء في التحليل
- ✅ الكود موثق
- ✅ CHANGELOG محدث
- ✅ لقطات شاشة (للتغييرات في الواجهة)

#### أثناء المراجعة

- ✅ كن منفتحاً للتعليقات
- ✅ اشرح قراراتك
- ✅ عالج التعليقات بسرعة
- ✅ اطلب توضيحات إذا لزم

### للمراجع

#### ما يجب مراجعته

- ✅ **الوظيفة:** هل يعمل كما متوقع؟
- ✅ **الكود:** هل يتبع المعايير؟
- ✅ **الاختبارات:** هل التغطية كافية؟
- ✅ **الأداء:** هل يؤثر على الأداء؟
- ✅ **الأمان:** هل يوجد ثغرات؟
- ✅ **التوثيق:** هل موثق بشكل مناسب؟

#### كيفية المراجعة

- ✅ كن محترماً ومهذباً
- ✅ اشرح سبب التعليقات
- ✅ اقترح حلول بديلة
- ✅ ميز بين المطلوب والاختياري
- ✅ وافق عندما يكون جاهزاً

---

## الحصول على المساعدة

### الموارد

- 📚 [Documentation](../docs/)
- 🐛 [Issues](../../issues)
- 💬 [Discussions](../../discussions)
- 📖 [Git/GitHub Guide](../docs/GIT_GITHUB_GUIDE.md)

### الاتصال

- **Issues:** للأخطاء والميزات
- **Discussions:** للأسئلة والنقاشات
- **Pull Requests:** للمساهمات

---

## الشكر والتقدير

نشكر جميع المساهمين في المشروع! 🎉

### المساهمون

<!-- يتم تحديثه تلقائياً -->

---

## الترخيص

بالمساهمة في هذا المشروع، فإنك توافق على أن مساهماتك ستكون مرخصة بموجب نفس ترخيص المشروع.

---

**شكراً لمساهمتك! 🙏**

**آخر تحديث:** 2025-01-XX  
**الإصدار:** 1.0.0
