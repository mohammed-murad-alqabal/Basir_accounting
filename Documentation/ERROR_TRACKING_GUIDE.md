# دليل نظام تتبع الأخطاء

## Error Tracking System Guide

هذا الدليل يشرح كيفية استخدام نظام تتبع الأخطاء المتكامل في المشروع.

---

## 📋 جدول المحتويات

1. [نظرة عامة](#نظرة-عامة)
2. [المكونات](#المكونات)
3. [الاستخدام المحلي](#الاستخدام-المحلي)
4. [الأتمتة عبر GitHub](#الأتمتة-عبر-github)
5. [إنشاء Issues](#إنشاء-issues)
6. [التقارير](#التقارير)
7. [أفضل الممارسات](#أفضل-الممارسات)

---

## نظرة عامة

نظام تتبع الأخطاء يوفر:

- ✅ تسجيل تلقائي للأخطاء
- ✅ تقارير يومية وشاملة
- ✅ إنشاء Issues تلقائياً على GitHub
- ✅ Git hooks للتحقق قبل الـ commit
- ✅ GitHub Actions للتحليل المستمر
- ✅ توثيق شامل للأخطاء المحلولة

---

## المكونات

### 1. GitHub Issue Templates

موجودة في `.github/ISSUE_TEMPLATE/`:

#### bug_report.md

قالب للإبلاغ عن الأخطاء:

```markdown
- وصف الخطأ
- خطوات إعادة الإنتاج
- السلوك المتوقع vs الفعلي
- البيئة
- سجلات الأخطاء
```

#### feature_request.md

قالب لطلب ميزات جديدة:

```markdown
- وصف الميزة
- المشكلة التي تحلها
- الحل المقترح
- الأولوية
```

#### code_quality.md

قالب لمشاكل جودة الكود:

```markdown
- نوع المشكلة
- الموقع
- الحل المقترح
- التأثير
```

### 2. نظام تسجيل الأخطاء المحلي

**الملف:** `scripts/log_error.sh`

**الوظائف:**

- تحليل أخطاء Flutter
- تحليل أخطاء الاختبارات
- إنشاء تقارير يومية
- إنشاء تقارير شاملة
- تنظيف السجلات القديمة

### 3. GitHub Actions

**الملف:** `.github/workflows/error_tracking.yml`

**المهام:**

- تشغيل Flutter Analyze
- تشغيل الاختبارات
- إنشاء تقارير
- إنشاء Issues للأخطاء الحرجة
- التعليق على Pull Requests

### 4. Git Hooks

**الملف:** `.githooks/pre-commit`

**الفحوصات:**

- Flutter Format
- Flutter Analyze
- الاختبارات السريعة
- TODO Comments

### 5. سجل حل الأخطاء

**الملف:** `Documentation/ERROR_RESOLUTION_LOG.md`

**المحتوى:**

- الأخطاء المحلولة
- الحلول المطبقة
- الدروس المستفادة
- قوالب للمشاكل الشائعة

---

## الاستخدام المحلي

### تشغيل نظام تسجيل الأخطاء

```bash
# تشغيل النظام الكامل
./scripts/log_error.sh

# النتائج:
# - logs/errors/error_TIMESTAMP.log
# - logs/reports/daily_report_DATE.md
# - logs/reports/summary_DATE.md
```

### تفعيل Git Hooks

```bash
# تفعيل الـ hooks
git config core.hooksPath .githooks

# الآن سيتم تشغيل الفحوصات تلقائياً قبل كل commit
```

### تشغيل الفحوصات يدوياً

```bash
# Flutter Format
flutter format lib/ test/

# Flutter Analyze
flutter analyze

# الاختبارات
flutter test

# جميع الفحوصات
flutter format lib/ test/ && flutter analyze && flutter test
```

---

## الأتمتة عبر GitHub

### التشغيل التلقائي

يتم تشغيل GitHub Actions تلقائياً عند:

- Push إلى main أو develop
- Pull Request إلى main أو develop
- يومياً في الساعة 2 صباحاً
- يدوياً عبر workflow_dispatch

### عرض النتائج

1. اذهب إلى **Actions** في GitHub
2. اختر **Error Tracking & Reporting**
3. اختر Run محدد
4. شاهد النتائج والتقارير

### تحميل التقارير

```bash
# التقارير متوفرة في Artifacts
# يمكن تحميلها من صفحة الـ workflow run
```

---

## إنشاء Issues

### تلقائياً

يتم إنشاء Issues تلقائياً عند:

- اكتشاف أخطاء حرجة (errors)
- فشل الاختبارات
- مشاكل في الأمان

### يدوياً

1. اذهب إلى **Issues** في GitHub
2. انقر **New Issue**
3. اختر القالب المناسب:
   - Bug Report
   - Feature Request
   - Code Quality Issue
4. املأ المعلومات المطلوبة
5. انقر **Submit new issue**

---

## التقارير

### التقرير اليومي

**الموقع:** `logs/reports/daily_report_DATE.md`

**المحتوى:**

- جميع الأخطاء المسجلة في اليوم
- التفاصيل الكاملة لكل خطأ

### التقرير الشامل

**الموقع:** `logs/reports/summary_DATE.md`

**المحتوى:**

- إحصائيات الأخطاء
- الملفات الأكثر تأثراً
- الاتجاهات

### تقرير GitHub Actions

**الموقع:** Artifacts في GitHub

**المحتوى:**

- نتائج Flutter Analyze
- نتائج الاختبارات
- التفاصيل الكاملة

---

## أفضل الممارسات

### 1. التسجيل المحلي

```bash
# قبل كل commit
./scripts/log_error.sh

# مراجعة التقارير
cat logs/reports/daily_report_$(date +%Y-%m-%d).md
```

### 2. معالجة الأخطاء

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

### 3. TODO Comments

```dart
// ✅ جيد
// TODO(team): Add biometric authentication - Issue #001

// ❌ سيء
// TODO: Add feature
```

### 4. التوثيق

````dart
// ✅ جيد
/// وصف مفصل للدالة
///
/// Parameters:
/// - [param]: وصف المعامل
///
/// Returns: وصف القيمة المرجعة
///
/// Example:
/// ```dart
/// final result = myFunction(param);
/// ```
void myFunction(String param) {
  // code
}

// ❌ سيء
void myFunction(String param) {
  // code
}
````

### 5. الاختبارات

```dart
// ✅ جيد
test('should return correct value', () {
  // arrange
  final input = 'test';

  // act
  final result = myFunction(input);

  // assert
  expect(result, equals('expected'));
});

// ❌ سيء
test('test', () {
  expect(myFunction('test'), 'expected');
});
```

---

## الأوامر السريعة

```bash
# تسجيل الأخطاء
./scripts/log_error.sh

# تفعيل Git Hooks
git config core.hooksPath .githooks

# فحص الكود
flutter analyze

# تشغيل الاختبارات
flutter test

# تنسيق الكود
flutter format lib/ test/

# عرض التقارير
cat logs/reports/daily_report_$(date +%Y-%m-%d).md

# تنظيف السجلات القديمة
find logs -name "*.log" -mtime +30 -delete
```

---

## استكشاف الأخطاء

### المشكلة: Git Hooks لا تعمل

**الحل:**

```bash
# تأكد من التفعيل
git config core.hooksPath .githooks

# تأكد من الصلاحيات
chmod +x .githooks/pre-commit
```

### المشكلة: GitHub Actions تفشل

**الحل:**

1. تحقق من سجلات الـ workflow
2. تأكد من صحة flutter version
3. تأكد من وجود جميع التبعيات

### المشكلة: التقارير لا تُنشأ

**الحل:**

```bash
# تأكد من وجود المجلدات
mkdir -p logs/errors logs/reports

# تأكد من الصلاحيات
chmod +x scripts/log_error.sh
```

---

## الدعم والمساعدة

### الموارد

- [Flutter Error Handling](https://flutter.dev/docs/testing/errors)
- [Dart Exception Handling](https://dart.dev/guides/language/language-tour#exceptions)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

### الاتصال

- **Issues:** [GitHub Issues](https://github.com/your-repo/issues)
- **Discussions:** [GitHub Discussions](https://github.com/your-repo/discussions)

---

**آخر تحديث:** 2025-01-XX  
**الإصدار:** 1.0.0
