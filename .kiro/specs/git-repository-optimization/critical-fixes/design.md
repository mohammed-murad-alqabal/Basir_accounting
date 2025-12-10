# Design Document - إصلاحات حرجة فورية

## Overview

هذا المستند يصف التصميم التفصيلي لإصلاح المشاكل الحرجة في مشروع بصير MVP.

## Architecture

### نهج الإصلاح

سنتبع نهج **تدريجي ومنهجي** للإصلاح:

1. **المرحلة 1**: إصلاح التبعيات (مكتمل ✅)
2. **المرحلة 2**: إصلاح معالجة الاستثناءات
3. **المرحلة 3**: إصلاح Future calls
4. **المرحلة 4**: استبدال Deprecated APIs
5. **المرحلة 5**: تحسين TODO comments
6. **المرحلة 6**: إضافة التوثيق المفقود
7. **المرحلة 7**: التثبيت والاختبار
8. **المرحلة 8**: التحقق النهائي

## Components and Interfaces

### 1. Exception Handling Fixer

**الملفات المتأثرة:**

- `lib/features/auth/data/services/auth_service.dart` (2 مواضع)
- `lib/features/auth/presentation/providers/auth_provider.dart` (4 مواضع)
- `lib/features/auth/presentation/screens/login_screen.dart` (1 موضع)
- `lib/features/auth/presentation/screens/setup_screen.dart` (1 موضع)

**النمط:**

```dart
// قبل:
try {
  // code
} catch (e) {
  print('Error: $e');
}

// بعد:
try {
  // code
} on Exception catch (e, stackTrace) {
  debugPrint('Error: $e');
  debugPrint('Stack trace: $stackTrace');
  rethrow;
}
```

### 2. Future Awaiter

**الملفات المتأثرة:**

- `lib/features/auth/presentation/screens/login_screen.dart` (2 مواضع)
- `lib/features/dashboard/presentation/screens/dashboard_screen.dart` (5 مواضع)
- `lib/features/invoices/presentation/screens/invoices_screen.dart` (1 موضع)

**النمط:**

```dart
// قبل:
Navigator.push(context, route);

// بعد:
await Navigator.push(context, route);

// أو إذا لم نحتاج النتيجة:
unawaited(Navigator.push(context, route));
```

### 3. API Modernizer

**الملفات المتأثرة:**

- `lib/features/auth/presentation/screens/login_screen.dart`
- `lib/features/auth/presentation/screens/setup_screen.dart`
- `lib/features/invoices/data/services/pdf_service.dart`

**النمط:**

```dart
// قبل:
color.withOpacity(0.5)

// بعد:
color.withValues(alpha: 0.5)

// قبل:
Table.fromTextArray(...)

// بعد:
TableHelper.fromTextArray(...)
```

### 4. TODO Formatter

**الملفات المتأثرة:**

- `lib/features/auth/presentation/screens/login_screen.dart`
- `lib/features/auth/presentation/screens/setup_screen.dart`
- `lib/features/settings/presentation/screens/settings_screen.dart`
- `lib/features/invoices/presentation/screens/invoices_screen.dart`

**النمط:**

```dart
// قبل:
// TODO: implement feature

// بعد:
// TODO(team): implement feature - Issue #123
```

## Data Models

### Fix Report Model

```dart
class FixReport {
  final DateTime timestamp;
  final int totalIssues;
  final int fixedIssues;
  final int remainingIssues;
  final List<FixedIssue> fixes;
  final Duration executionTime;

  double get successRate => (fixedIssues / totalIssues) * 100;
}

class FixedIssue {
  final String file;
  final int line;
  final String type;
  final String description;
  final bool success;
}
```

## Correctness Properties

_A property is a characteristic or behavior that should hold true across all valid executions of a system._

### Property 1: Exception handling consistency

_For any_ try-catch block in the codebase, it should use 'on' clause to specify the exception type being caught.
**Validates: Requirements 2.1, 2.2, 2.3**

### Property 2: Future completion

_For any_ Future-returning method call, it should either be awaited or explicitly marked as unawaited.
**Validates: Requirements 3.1, 3.2, 3.3**

### Property 3: API modernity

_For any_ deprecated API usage, it should be replaced with the modern alternative.
**Validates: Requirements 4.1, 4.2, 4.3**

### Property 4: Documentation completeness

_For any_ public API, it should have complete DartDoc documentation.
**Validates: Requirements 6.1, 6.2, 6.3**

### Property 5: Build success

_For any_ code changes, running flutter analyze should show fewer issues than before.
**Validates: Requirements 8.1**

### Property 6: Test stability

_For any_ code changes, all existing tests should continue to pass.
**Validates: Requirements 8.2**

## Error Handling

### استراتيجية معالجة الأخطاء

1. **تحديد نوع الاستثناء**: استخدام `on Exception` أو `on Error`
2. **تسجيل مفصل**: استخدام `debugPrint` مع stack trace
3. **إعادة الرمي**: استخدام `rethrow` للاستثناءات الحرجة
4. **رسائل واضحة**: توفير رسائل خطأ مفهومة للمستخدم

### مثال شامل:

```dart
Future<void> performOperation() async {
  try {
    // العملية الأساسية
    await someAsyncOperation();
  } on NetworkException catch (e, stackTrace) {
    // خطأ شبكة محدد
    debugPrint('Network error: $e');
    debugPrint('Stack trace: $stackTrace');
    throw UserFriendlyException('فشل الاتصال بالخادم');
  } on ValidationException catch (e) {
    // خطأ تحقق
    debugPrint('Validation error: $e');
    throw UserFriendlyException('البيانات المدخلة غير صحيحة');
  } on Exception catch (e, stackTrace) {
    // أي استثناء آخر
    debugPrint('Unexpected exception: $e');
    debugPrint('Stack trace: $stackTrace');
    throw UserFriendlyException('حدث خطأ غير متوقع');
  } on Error catch (e, stackTrace) {
    // أخطاء برمجية
    debugPrint('Programming error: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow; // إعادة رمي الأخطاء البرمجية
  }
}
```

## Testing Strategy

### Unit Tests

سنتأكد من أن جميع الإصلاحات لا تؤثر على الاختبارات الموجودة:

```bash
# تشغيل الاختبارات قبل الإصلاح
flutter test > tests_before.txt

# تطبيق الإصلاحات
# ...

# تشغيل الاختبارات بعد الإصلاح
flutter test > tests_after.txt

# المقارنة
diff tests_before.txt tests_after.txt
```

### Integration Tests

سنختبر التطبيق على الموبايل:

1. **تثبيت التطبيق**
2. **اختبار تسجيل الدخول**
3. **اختبار إضافة عميل**
4. **اختبار إنشاء فاتورة**
5. **اختبار تصدير PDF**

### Manual Testing Checklist

- [ ] التطبيق يعمل على Android
- [ ] التطبيق يعمل على iOS (إن أمكن)
- [ ] جميع الشاشات تعمل بشكل صحيح
- [ ] لا توجد أخطاء في Console
- [ ] الأداء سلس (60 FPS)
- [ ] لا توجد memory leaks

## Performance Considerations

### تأثير الإصلاحات على الأداء

| الإصلاح            | التأثير المتوقع | الملاحظات               |
| :----------------- | :-------------- | :---------------------- |
| Exception Handling | محايد           | لا تأثير على الأداء     |
| Future Awaiting    | إيجابي          | تحسين تدفق البرنامج     |
| API Modernization  | إيجابي          | APIs الحديثة أكثر كفاءة |
| Documentation      | محايد           | لا تأثير على runtime    |

## Security Considerations

### الأمان في معالجة الأخطاء

1. **عدم كشف معلومات حساسة**: عدم عرض stack traces للمستخدم
2. **تسجيل آمن**: عدم تسجيل كلمات المرور أو tokens
3. **معالجة آمنة**: عدم تجاهل الأخطاء الأمنية

## Deployment Strategy

### خطة النشر

1. **Development**: تطبيق الإصلاحات في branch منفصل
2. **Testing**: اختبار شامل
3. **Code Review**: مراجعة الكود
4. **Merge**: دمج في main branch
5. **Release**: إنشاء release build
6. **Deploy**: نشر على الأجهزة

---

**Version:** 1.0  
**Date:** 28 نوفمبر 2025  
**Status:** Approved
