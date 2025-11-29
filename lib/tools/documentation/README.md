# 📚 نظام التوثيق الشامل

نظام متكامل لتحليل وتوليد والتحقق من التوثيق في مشروع بصير MVP.

## 🎯 الهدف

رفع تغطية التوثيق من 5% إلى 95%+ مع ضمان جودة عالية للتوثيق.

## 🏗️ البنية

```
lib/tools/documentation/
├── analysis/           # محرك التحليل
│   └── analysis_engine.dart
├── generation/         # محرك التوليد
│   └── generation_engine.dart
├── validation/         # محرك التحقق
│   └── validation_engine.dart
├── repository/         # مستودع التقارير
│   └── documentation_repository.dart
├── cli/               # أداة سطر الأوامر
│   └── documentation_cli.dart
└── README.md          # هذا الملف
```

## 🚀 الاستخدام

### 1. تحليل التغطية

```bash
# تحليل المشروع بالكامل
dart run lib/tools/documentation/cli/documentation_cli.dart analyze

# تحليل مجلد معين
dart run lib/tools/documentation/cli/documentation_cli.dart analyze --path lib/features

# تحليل مفصل
dart run lib/tools/documentation/cli/documentation_cli.dart analyze --verbose
```

### 2. توليد التوثيق

```bash
# توليد التوثيق الناقص
dart run lib/tools/documentation/cli/documentation_cli.dart generate

# معاينة بدون تطبيق
dart run lib/tools/documentation/cli/documentation_cli.dart generate --dry-run

# توليد لمجلد معين
dart run lib/tools/documentation/cli/documentation_cli.dart generate --path lib/core

# إجبار التوليد حتى للموثق
dart run lib/tools/documentation/cli/documentation_cli.dart generate --force
```

### 3. التحقق من الجودة

```bash
# التحقق من جودة التوثيق
dart run lib/tools/documentation/cli/documentation_cli.dart validate

# التحقق الصارم (90%+)
dart run lib/tools/documentation/cli/documentation_cli.dart validate --strict

# التحقق من مجلد معين
dart run lib/tools/documentation/cli/documentation_cli.dart validate --path lib/features
```

### 4. إنشاء التقارير

```bash
# تقرير Markdown (افتراضي)
dart run lib/tools/documentation/cli/documentation_cli.dart report

# تقرير HTML
dart run lib/tools/documentation/cli/documentation_cli.dart report --format html

# تقرير JSON
dart run lib/tools/documentation/cli/documentation_cli.dart report --format json

# تقرير CSV
dart run lib/tools/documentation/cli/documentation_cli.dart report --format csv

# تحديد اسم الملف
dart run lib/tools/documentation/cli/documentation_cli.dart report --output my_report
```

## 📊 الأوامر المتاحة

| الأمر      | الوصف                  | الخيارات                         |
| :--------- | :--------------------- | :------------------------------- |
| `analyze`  | تحليل تغطية التوثيق    | `--path`, `--verbose`            |
| `generate` | توليد التوثيق الناقص   | `--path`, `--dry-run`, `--force` |
| `validate` | التحقق من جودة التوثيق | `--path`, `--strict`             |
| `report`   | إنشاء تقرير شامل       | `--format`, `--output`           |
| `help`     | عرض المساعدة           | -                                |

## 🔧 الخيارات المتقدمة

### خيارات المسار

```bash
# تحليل ملف واحد
--path lib/core/theme.dart

# تحليل مجلد
--path lib/features/auth

# تحليل عدة مجلدات (قريباً)
--path lib/core,lib/features
```

### خيارات التفصيل

```bash
# عرض تفاصيل كاملة
--verbose

# عرض ملخص فقط (افتراضي)
# بدون خيارات
```

### خيارات التصدير

```bash
# صيغ التقارير المدعومة
--format json      # JSON
--format html      # HTML
--format markdown  # Markdown (افتراضي)
--format csv       # CSV

# تحديد اسم الملف
--output my_report
```

## 📈 معايير الجودة

### تغطية التوثيق

- **ممتاز:** 95%+
- **جيد:** 80-94%
- **مقبول:** 70-79%
- **ضعيف:** < 70%

### درجة الجودة

- **A+:** 90-100 نقطة
- **A:** 80-89 نقطة
- **B:** 70-79 نقطة
- **C:** 60-69 نقطة
- **F:** < 60 نقطة

## 🎨 أمثلة عملية

### مثال 1: سير عمل كامل

```bash
# 1. تحليل الوضع الحالي
dart run lib/tools/documentation/cli/documentation_cli.dart analyze --verbose

# 2. توليد التوثيق الناقص
dart run lib/tools/documentation/cli/documentation_cli.dart generate

# 3. التحقق من الجودة
dart run lib/tools/documentation/cli/documentation_cli.dart validate

# 4. إنشاء تقرير HTML
dart run lib/tools/documentation/cli/documentation_cli.dart report --format html
```

### مثال 2: توثيق ميزة جديدة

```bash
# توثيق ميزة العملاء
dart run lib/tools/documentation/cli/documentation_cli.dart generate --path lib/features/customers

# التحقق من الجودة
dart run lib/tools/documentation/cli/documentation_cli.dart validate --path lib/features/customers --strict
```

### مثال 3: CI/CD Integration

```yaml
# في .github/workflows/documentation_check.yml
- name: Check documentation
  run: |
    dart run lib/tools/documentation/cli/documentation_cli.dart analyze
    dart run lib/tools/documentation/cli/documentation_cli.dart validate --strict
```

## 🔍 التحليل

### ما يتم تحليله

- ✅ Classes
- ✅ Methods
- ✅ Properties
- ✅ Enums
- ✅ Typedefs
- ✅ Extensions
- ✅ Mixins

### ما يتم اكتشافه

- ❌ عناصر بدون توثيق
- ⚠️ توثيق ناقص
- 🔍 توثيق ضعيف الجودة
- 📝 أمثلة مفقودة
- 🏷️ معاملات غير موثقة

## 🎯 التوليد

### قوالب التوثيق

#### Class Documentation

````dart
/// وصف الكلاس
///
/// شرح تفصيلي للكلاس ووظيفته
///
/// Example:
/// ```dart
/// final instance = MyClass();
/// ```
class MyClass {
  // ...
}
````

#### Method Documentation

````dart
/// وصف الدالة
///
/// شرح تفصيلي للدالة
///
/// Parameters:
/// - [param1]: وصف المعامل الأول
/// - [param2]: وصف المعامل الثاني
///
/// Returns: وصف القيمة المرجعة
///
/// Throws:
/// - [Exception]: متى يتم رمي الاستثناء
///
/// Example:
/// ```dart
/// final result = myMethod(param1, param2);
/// ```
ReturnType myMethod(Type1 param1, Type2 param2) {
  // ...
}
````

#### Property Documentation

```dart
/// وصف الخاصية
///
/// شرح تفصيلي للخاصية واستخدامها
final Type myProperty;
```

## ✅ التحقق

### قواعد التحقق

1. **صيغة DartDoc:** يجب أن يبدأ التوثيق بـ `///`
2. **الوصف:** يجب أن يحتوي على وصف واضح
3. **المعاملات:** يجب توثيق جميع المعاملات
4. **القيمة المرجعة:** يجب توثيق القيمة المرجعة
5. **الأمثلة:** يفضل وجود أمثلة للاستخدام
6. **الاستثناءات:** يجب توثيق الاستثناءات المحتملة

### مستويات الخطورة

- 🔴 **Critical:** يجب إصلاحه فوراً
- 🟠 **Warning:** يفضل إصلاحه
- 🟡 **Info:** معلومة للتحسين

## 📊 التقارير

### أنواع التقارير

#### 1. Coverage Report

يعرض نسبة التغطية الإجمالية والتفصيلية لكل ملف.

#### 2. Quality Report

يعرض درجة الجودة والمشاكل المكتشفة.

#### 3. Historical Report

يعرض تطور التغطية والجودة عبر الزمن.

#### 4. Detailed Report

يعرض تفاصيل كاملة لكل عنصر غير موثق.

### صيغ التقارير

- **JSON:** للمعالجة البرمجية
- **HTML:** للعرض في المتصفح
- **Markdown:** للتوثيق
- **CSV:** للتحليل في Excel

## 🔗 التكامل

### GitHub Actions

```yaml
name: Documentation Check

on: [push, pull_request]

jobs:
  documentation:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: dart run lib/tools/documentation/cli/documentation_cli.dart analyze
      - run: dart run lib/tools/documentation/cli/documentation_cli.dart validate --strict
```

### Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "🔍 Checking documentation..."
dart run lib/tools/documentation/cli/documentation_cli.dart analyze

if [ $? -ne 0 ]; then
  echo "❌ Documentation coverage below threshold"
  exit 1
fi

echo "✅ Documentation check passed"
```

### VS Code Task

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Check Documentation",
      "type": "shell",
      "command": "dart run lib/tools/documentation/cli/documentation_cli.dart analyze --verbose",
      "group": "test"
    }
  ]
}
```

## 🛠️ التطوير

### إضافة قالب جديد

```dart
// في lib/tools/documentation/generation/generation_engine.dart

String _generateCustomTemplate(UndocumentedElement element) {
  return '''
/// وصف مخصص
///
/// تفاصيل إضافية
''';
}
```

### إضافة قاعدة تحقق جديدة

```dart
// في lib/tools/documentation/validation/validation_engine.dart

ValidationIssue? _checkCustomRule(String documentation) {
  if (!documentation.contains('Example:')) {
    return ValidationIssue(
      description: 'Missing example',
      severity: IssueSeverity.warning,
    );
  }
  return null;
}
```

## 📚 الموارد

- [DartDoc Guide](https://dart.dev/guides/language/effective-dart/documentation)
- [Flutter Documentation Best Practices](https://flutter.dev/docs/development/tools/formatting)
- [Effective Dart: Documentation](https://dart.dev/guides/language/effective-dart/documentation)

## 🤝 المساهمة

نرحب بالمساهمات! يرجى:

1. Fork المشروع
2. إنشاء branch للميزة
3. Commit التغييرات
4. Push إلى Branch
5. فتح Pull Request

## 📝 الترخيص

هذا المشروع مرخص تحت MIT License.

## 👥 الفريق

- **المطور الرئيسي:** فريق وكلاء تطوير مشروع بصير
- **المشروع:** بصير MVP
- **التاريخ:** نوفمبر 2025

---

**Version:** 1.0.0  
**Status:** Production Ready  
**Last Updated:** 27 نوفمبر 2025
