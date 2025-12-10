# دليل المستخدم - نظام التوثيق الشامل

## 📚 نظرة عامة

نظام التوثيق الشامل هو أداة متكاملة لتحليل، توليد، والتحقق من توثيق الكود في مشروع بصير MVP. يهدف النظام إلى رفع تغطية التوثيق من 5% إلى 95%+ مع ضمان جودة عالية.

## 🎯 الأهداف

- **تحليل شامل**: فحص جميع ملفات المشروع واكتشاف العناصر غير الموثقة
- **توليد تلقائي**: إنشاء توثيق DartDoc احترافي بشكل تلقائي
- **التحقق من الجودة**: فحص جودة التوثيق والتأكد من الامتثال للمعايير
- **تكامل CI/CD**: رفض Pull Requests التي لا تحقق معايير التوثيق

## 📦 المكونات الرئيسية

### 1. Analysis Engine (محرك التحليل)

يقوم بتحليل ملفات الكود واكتشاف العناصر غير الموثقة.

**الميزات:**

- تحليل ملف واحد أو مجلد كامل
- اكتشاف Classes, Methods, Properties, Enums, Typedefs
- حساب تغطية التوثيق بدقة
- تصنيف العناصر حسب النوع

### 2. Generation Engine (محرك التوليد)

يقوم بتوليد توثيق DartDoc احترافي تلقائياً.

**الميزات:**

- قوالب توثيق جاهزة لكل نوع عنصر
- دعم اللغة العربية والإنجليزية
- إضافة أمثلة وتفاصيل تقنية
- تطبيق التوثيق مباشرة على الملفات

### 3. Validation Engine (محرك التحقق)

يتحقق من جودة التوثيق والامتثال للمعايير.

**الميزات:**

- التحقق من صيغة DartDoc
- حساب درجة الجودة (Quality Score)
- اكتشاف المشاكل والأخطاء
- تصنيف المشاكل حسب الخطورة

### 4. Documentation Repository (مستودع التوثيق)

يدير تقارير التغطية والتاريخ.

**الميزات:**

- حفظ تقارير التغطية
- تتبع التاريخ والاتجاهات
- تصدير التقارير بصيغ متعددة (JSON, Markdown, HTML)
- حذف التقارير القديمة تلقائياً

## 🚀 البدء السريع

### المتطلبات

- Flutter 3.24.0+
- Dart 3.5.0+

### التثبيت

```bash
# استنساخ المشروع
git clone <repository-url>
cd Basser_MVP

# تثبيت التبعيات
flutter pub get
```

### الاستخدام الأساسي

#### 1. تحليل المشروع

```bash
# تحليل المشروع بالكامل
dart lib/tools/documentation/cli/doc_cli.dart analyze

# تحليل مجلد معين
dart lib/tools/documentation/cli/doc_cli.dart analyze --path lib/features/auth

# تحليل ملف واحد
dart lib/tools/documentation/cli/doc_cli.dart analyze --path lib/core/constants.dart
```

#### 2. توليد التوثيق

```bash
# توليد توثيق للمشروع بالكامل
dart lib/tools/documentation/cli/doc_cli.dart generate

# توليد توثيق بخيارات مخصصة
dart lib/tools/documentation/cli/doc_cli.dart generate --comprehensive --bilingual

# توليد توثيق لمجلد معين
dart lib/tools/documentation/cli/doc_cli.dart generate --path lib/features/customers
```

#### 3. التحقق من الجودة

```bash
# التحقق من جودة التوثيق
dart lib/tools/documentation/cli/doc_cli.dart validate

# التحقق من ملف معين
dart lib/tools/documentation/cli/doc_cli.dart validate --path lib/data/models/customer_model.dart
```

#### 4. إنشاء التقارير

```bash
# إنشاء تقرير بصيغة Markdown
dart lib/tools/documentation/cli/doc_cli.dart report --format markdown

# إنشاء تقرير بصيغة JSON
dart lib/tools/documentation/cli/doc_cli.dart report --format json

# إنشاء تقرير بصيغة HTML
dart lib/tools/documentation/cli/doc_cli.dart report --format html
```

## 📖 أمثلة عملية

### مثال 1: تحليل وتوليد توثيق لميزة معينة

```bash
# 1. تحليل ميزة العملاء
dart lib/tools/documentation/cli/doc_cli.dart analyze --path lib/features/customers

# 2. توليد التوثيق
dart lib/tools/documentation/cli/doc_cli.dart generate --path lib/features/customers --comprehensive

# 3. التحقق من الجودة
dart lib/tools/documentation/cli/doc_cli.dart validate --path lib/features/customers

# 4. إنشاء تقرير
dart lib/tools/documentation/cli/doc_cli.dart report --format markdown --output customers_report.md
```

### مثال 2: سير عمل كامل للمشروع

```bash
# 1. تحليل المشروع بالكامل
dart lib/tools/documentation/cli/doc_cli.dart analyze

# 2. توليد توثيق شامل
dart lib/tools/documentation/cli/doc_cli.dart generate --comprehensive --bilingual

# 3. التحقق من الجودة
dart lib/tools/documentation/cli/doc_cli.dart validate

# 4. إنشاء تقرير HTML
dart lib/tools/documentation/cli/doc_cli.dart report --format html --output documentation_report.html
```

### مثال 3: استخدام في CI/CD

```yaml
# .github/workflows/documentation.yml
name: Documentation Check

on: [push, pull_request]

jobs:
  documentation-coverage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.24.0"

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze documentation
        run: dart lib/tools/documentation/cli/doc_cli.dart analyze

      - name: Validate documentation
        run: dart lib/tools/documentation/cli/doc_cli.dart validate

      - name: Generate report
        run: dart lib/tools/documentation/cli/doc_cli.dart report --format markdown

      - name: Check coverage threshold
        run: |
          COVERAGE=$(dart lib/tools/documentation/cli/doc_cli.dart analyze --json | jq '.coverage')
          if (( $(echo "$COVERAGE < 95" | bc -l) )); then
            echo "Documentation coverage is below 95%: $COVERAGE%"
            exit 1
          fi
```

## ⚙️ الخيارات المتقدمة

### خيارات التوليد

```bash
# توليد توثيق شامل مع أمثلة وتفاصيل
dart lib/tools/documentation/cli/doc_cli.dart generate \
  --comprehensive \
  --include-examples \
  --include-details \
  --bilingual

# توليد توثيق بسيط بالعربية فقط
dart lib/tools/documentation/cli/doc_cli.dart generate \
  --minimal \
  --arabic-only

# توليد توثيق بالإنجليزية فقط
dart lib/tools/documentation/cli/doc_cli.dart generate \
  --english-only
```

### خيارات التحليل

```bash
# تحليل مع تفاصيل موسعة
dart lib/tools/documentation/cli/doc_cli.dart analyze --verbose

# تحليل مع إخراج JSON
dart lib/tools/documentation/cli/doc_cli.dart analyze --json

# تحليل مع تجاهل ملفات معينة
dart lib/tools/documentation/cli/doc_cli.dart analyze --exclude "test/**,build/**"
```

### خيارات التقارير

```bash
# تقرير مع إحصائيات تفصيلية
dart lib/tools/documentation/cli/doc_cli.dart report \
  --format markdown \
  --include-stats \
  --include-trends \
  --output detailed_report.md

# تقرير مختصر
dart lib/tools/documentation/cli/doc_cli.dart report \
  --format markdown \
  --summary-only \
  --output summary.md
```

## 📊 فهم التقارير

### تقرير التغطية

```markdown
# Documentation Coverage Report

## Overall Statistics

- Total Elements: 500
- Documented: 475
- Undocumented: 25
- Coverage: 95.0%
- Quality Score: 92/100 (Excellent)

## Coverage by Type

- Classes: 98% (49/50)
- Methods: 94% (235/250)
- Properties: 96% (192/200)

## Undocumented Elements

1. lib/features/auth/auth_service.dart

   - Method: validateToken (line 45)
   - Method: refreshToken (line 67)

2. lib/features/customers/customer_repository.dart
   - Property: \_cache (line 23)
```

### درجات الجودة

- **Perfect (95-100)**: توثيق ممتاز مع أمثلة وتفاصيل كاملة
- **Excellent (85-94)**: توثيق جيد جداً مع معظم التفاصيل
- **Good (70-84)**: توثيق جيد مع بعض النواقص
- **Fair (55-69)**: توثيق مقبول يحتاج تحسين
- **Poor (<55)**: توثيق ضعيف يحتاج إعادة كتابة

## 🔧 استكشاف الأخطاء

### مشكلة: التحليل يستغرق وقتاً طويلاً

**الحل:**

```bash
# تحليل مجلدات محددة بدلاً من المشروع بالكامل
dart lib/tools/documentation/cli/doc_cli.dart analyze --path lib/features
```

### مشكلة: التوليد يفشل لبعض الملفات

**الحل:**

```bash
# استخدام وضع verbose لرؤية التفاصيل
dart lib/tools/documentation/cli/doc_cli.dart generate --verbose

# تجاهل الملفات المشكلة مؤقتاً
dart lib/tools/documentation/cli/doc_cli.dart generate --exclude "problematic_file.dart"
```

### مشكلة: التغطية لا تصل إلى 95%

**الحل:**

1. تشغيل التحليل لمعرفة العناصر غير الموثقة
2. توليد التوثيق التلقائي
3. مراجعة وتحسين التوثيق المولد
4. التحقق من الجودة مرة أخرى

```bash
# سير عمل كامل
dart lib/tools/documentation/cli/doc_cli.dart analyze --verbose
dart lib/tools/documentation/cli/doc_cli.dart generate --comprehensive
dart lib/tools/documentation/cli/doc_cli.dart validate
dart lib/tools/documentation/cli/doc_cli.dart analyze
```

## 🎓 أفضل الممارسات

### 1. التوثيق المستمر

- وثق الكود أثناء الكتابة، لا بعدها
- استخدم الأداة للتحقق من التغطية بانتظام
- راجع التوثيق المولد تلقائياً وحسّنه

### 2. جودة التوثيق

- اكتب توثيق واضح ومفهوم
- أضف أمثلة عملية للاستخدام
- وثق الحالات الخاصة والاستثناءات
- استخدم اللغة العربية للمشروع المحلي

### 3. التكامل مع CI/CD

- أضف فحص التوثيق إلى pipeline
- ارفض PRs التي تقلل التغطية
- أنشئ تقارير تلقائية
- راقب الاتجاهات بمرور الوقت

### 4. الصيانة

- راجع التوثيق عند تحديث الكود
- احذف التوثيق القديم للكود المحذوف
- حدّث الأمثلة عند تغيير الواجهات
- حافظ على التناسق في الأسلوب

## 📝 قوالب التوثيق

### قالب Class

````dart
/// وصف مختصر للـ Class
///
/// وصف تفصيلي يشرح الغرض من الـ Class ومتى يُستخدم.
///
/// **مثال:**
/// ```dart
/// final customer = Customer(
///   id: 'customer-1',
///   name: 'أحمد محمد',
///   phone: '0501234567',
/// );
/// ```
///
/// **ملاحظات:**
/// - ملاحظة مهمة 1
/// - ملاحظة مهمة 2
class Customer {
  // ...
}
````

### قالب Method

````dart
/// وصف مختصر للـ Method
///
/// وصف تفصيلي يشرح ماذا يفعل الـ Method.
///
/// **المعاملات:**
/// - [param1]: وصف المعامل الأول
/// - [param2]: وصف المعامل الثاني
///
/// **القيمة المرجعة:**
/// وصف القيمة المرجعة
///
/// **الاستثناءات:**
/// - [Exception1]: متى يُرمى هذا الاستثناء
///
/// **مثال:**
/// ```dart
/// final result = await method(param1, param2);
/// ```
Future<Result> method(String param1, int param2) async {
  // ...
}
````

### قالب Property

```dart
/// وصف مختصر للـ Property
///
/// وصف تفصيلي يشرح الغرض من الـ Property.
///
/// **القيمة الافتراضية:** `defaultValue`
///
/// **ملاحظات:**
/// - ملاحظة مهمة
final String property;
```

## 🔗 الموارد الإضافية

### الوثائق الرسمية

- [DartDoc Guide](https://dart.dev/tools/dartdoc)
- [Effective Dart: Documentation](https://dart.dev/guides/language/effective-dart/documentation)
- [Flutter Documentation Best Practices](https://flutter.dev/docs/development/tools/documentation)

### أدوات مساعدة

- [dartdoc](https://pub.dev/packages/dartdoc): أداة توليد التوثيق الرسمية
- [analyzer](https://pub.dev/packages/analyzer): محلل Dart الرسمي
- [markdown](https://pub.dev/packages/markdown): معالج Markdown

## 📞 الدعم والمساعدة

### الإبلاغ عن المشاكل

إذا واجهت أي مشكلة، يرجى:

1. التحقق من قسم استكشاف الأخطاء
2. البحث في Issues الموجودة
3. فتح Issue جديد مع التفاصيل الكاملة

### المساهمة

نرحب بالمساهمات! يرجى:

1. قراءة دليل المساهمة
2. اتباع معايير الكود
3. إضافة اختبارات للميزات الجديدة
4. تحديث التوثيق

## 📄 الترخيص

هذا المشروع مرخص تحت [LICENSE](../../LICENSE).

---

**الإصدار:** 1.0.0  
**تاريخ التحديث:** 28 نوفمبر 2025  
**المؤلف:** فريق بصير MVP
