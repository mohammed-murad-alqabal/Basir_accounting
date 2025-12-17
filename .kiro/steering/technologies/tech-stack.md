# المكدس التقني - بصير MVP

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 16 ديسمبر 2025  
**الحالة:** ✅ نشط ومكثف

---

## 🎯 نظرة عامة

**بصير MVP** تطبيق محمول متقدم لإدارة الفواتير باستخدام Flutter مع معمارية local-first ودعم كامل للعربية.

### � الحالة الححالية - تحتاج إصلاحات فورية

- **الاختبارات** تواجه مشاكل خطيرة وتتعطل ❌
- **تغطية اختبارات** غير قابلة للقياس بسبب فشل الاختبارات ❌
- **9 أخطاء** في flutter analyze تحتاج إصلاح ⚠️
- **FontManager undefined** خطأ في الكود الأساسي 🔴
- **7 dependencies قديمة** تحتاج تحديث 📦

---

## 🏗️ المكدس التقني الأساسي

### **Flutter Framework**

```yaml
flutter: "3.35.5+"
dart: "3.9.2+"
platforms:
  - Android (API 21+)
  - iOS (مستقبلي)
```

### **إدارة الحالة**

```yaml
state_management: "flutter_riverpod ^2.6.1"
patterns:
  - StateNotifier
  - AsyncValue
  - Provider Family
```

### **قاعدة البيانات المحلية**

```yaml
database: "isar ^3.1.0+1"
advantages:
  - 10x أسرع من SQLite
  - Type-safe queries
  - Offline-first support
```

### **الأمان**

```yaml
secure_storage: "flutter_secure_storage ^9.0.0"
encryption: "crypto ^3.0.7"
features:
  - AES-256 Encryption
  - Keychain/Keystore Integration
```

---

## 🎨 واجهة المستخدم

### **Material Design 3**

```yaml
design_system: "Material Design 3"
features:
  - Dynamic Color
  - Dark/Light Themes
  - RTL Support
  - Arabic Typography
```

### **دعم اللغة العربية**

```yaml
localization:
  - flutter_localizations
  - intl ^0.20.2
  - Custom Arabic Validators
fonts:
  - Cairo Font Family (Local Assets)
rtl_support:
  - Bidirectional Text
  - RTL Layout
  - Arabic Numerals
```

---

## 🧪 الجودة والاختبارات

### **إطار الاختبارات**

```yaml
testing:
  unit_tests: "flutter_test"
  mocking: "mockito ^5.4.4"
  coverage_target: "85%+"
  current_status: "924 tests, 99.8% success"
```

### **معايير الجودة**

```yaml
quality:
  linting: "flutter_lints ^4.0.0"
  analysis: "Strict Mode"
  formatting: "dart format (80 chars)"
  documentation: "95%+ API Coverage"
```

---

## 🚀 CI/CD والأتمتة

### **GitHub Actions Pipeline**

```yaml
pipeline_stages:
  1. Code Analysis: "flutter analyze + security scan"
  2. Testing: "Unit + Widget + Integration tests"
  3. Building: "Android APK/AAB"
  4. Quality Gates: "Coverage ≥ 70%, No critical issues"
  5. Deployment: "Artifact storage + release notes"
```

### **أدوات التطوير**

```yaml
code_generation:
  - "build_runner ^2.4.13"
  - "freezed ^2.5.2"
  - "riverpod_generator ^2.4.0"
  - "isar_generator ^3.1.0+1"
```

---

## 📱 دعم المنصات

### **Android (الحالي)**

```yaml
android:
  minimum_sdk: "API 21 (Android 5.0)"
  target_sdk: "API 34 (Android 14)"
  features:
    - Material Design 3
    - RTL Layout Support
    - Dark Theme Support
```

### **iOS (مستقبلي - Q1 2026)**

```yaml
ios:
  minimum_version: "iOS 12.0"
  target_version: "iOS 17.0"
  timeline: "Q1-Q2 2026"
```

---

## 🔮 خارطة الطريق التقنية

### **المرحلة القادمة (Q1-Q2 2026)**

- **تحسين الجودة**: رفع تغطية الاختبارات إلى 85%+
- **iOS Development**: تطوير نسخة iOS
- **Performance**: تحسينات الأداء والذاكرة
- **Security**: Multi-Factor Authentication

### **المرحلة المتوسطة (Q3-Q4 2026)**

- **AI Integration**: OCR للفواتير + Predictive Analytics
- **Web Platform**: Progressive Web App (PWA)
- **Enterprise Features**: Multi-user support

### **المرحلة المتقدمة (2027+)**

- **Desktop Platform**: Flutter Desktop (Windows, macOS, Linux)
- **Advanced AI**: Voice Commands (Arabic) + NLP
- **Quantum-Safe Security**: Post-Quantum Cryptography

---

## 🛠️ أدوات التطوير

### **بيئة التطوير**

```yaml
primary_ide: "VS Code / Android Studio"
extensions:
  - Flutter + Dart
  - GitLens + Error Lens
  - Material Icon Theme
debugging:
  - Flutter DevTools
  - Performance Profiler
  - Memory Analyzer
```

### **إدارة المشروع**

```yaml
version_control: "Git + GitHub"
workflow: "GitFlow"
documentation: "DartDoc + Markdown"
collaboration: "GitHub Pull Requests"
```

---

## 📊 مؤشرات الأداء

### **المؤشرات الحالية - الواقع الفعلي**

| المؤشر                | الحالي          | الهدف | الحالة            |
| --------------------- | --------------- | ----- | ----------------- |
| **Test Coverage**     | غير قابل للقياس | 85%+  | ❌ اختبارات معطلة |
| **Test Success Rate** | فاشلة           | >99%  | ❌ مشاكل خطيرة    |
| **Flutter Analyze**   | 9 issues        | 0     | ❌ يحتاج إصلاح    |
| **FontManager Error** | undefined       | fixed | 🔴 خطأ حرج        |
| **Dependencies**      | 7 قديمة         | محدثة | ⚠️ تحتاج تحديث    |

### **كيفية فحص المؤشرات:**

```bash
# فحص تغطية الاختبارات
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# فحص حجم APK
flutter build apk --analyze-size

# فحص الأداء
flutter run --profile
```

### **الأهداف 2026**

- Test Coverage: 85%+ (حالياً 67.9%)
- Performance Score: 95%+ (قيد القياس)
- Security Rating: A+ (حالياً A)
- User Satisfaction: 9.0/10 (قيد التقييم)

---

## � المتوجيهات العملية اليومية

### **سير العمل اليومي:**

```bash
# 1. فحص الجودة قبل البدء
flutter analyze
flutter test

# 2. تطوير الميزة
flutter pub get
flutter run

# 3. فحص نهائي قبل الـ commit
dart format .
flutter analyze
flutter test --coverage
```

### **أوامر أساسية مهمة:**

```bash
# إدارة التبعيات
flutter pub get              # تحديث التبعيات
flutter pub upgrade          # ترقية التبعيات
flutter pub deps             # عرض شجرة التبعيات

# الاختبارات والجودة
flutter test --coverage      # اختبارات مع تغطية
flutter analyze             # تحليل الكود
dart format .               # تنسيق الكود

# البناء والنشر
flutter build apk           # بناء APK
flutter build appbundle     # بناء AAB للمتجر
```

### **نصائح الأداء:**

- استخدم `const` constructors دائماً
- تجنب `setState()` المفرط
- استخدم `ListView.builder` للقوائم الطويلة
- راقب استهلاك الذاكرة بـ DevTools

### **المشاكل الشائعة وحلولها:**

#### **مشكلة: بطء في بناء التطبيق**

```bash
# الحل
flutter clean
flutter pub get
flutter build apk --release
```

#### **مشكلة: أخطاء في Isar**

```bash
# الحل
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### **مشكلة: مشاكل في RTL Layout**

```dart
// الحل: استخدم Directionality widget
Directionality(
  textDirection: TextDirection.rtl,
  child: YourWidget(),
)
```

---

## � المشاكعل المكتشفة والإصلاحات المطلوبة

### **المشاكل الحرجة الفورية:**

#### 1. **FontManager undefined**

```bash
# الخطأ في lib/main.dart:20:9
error • Undefined name 'FontManager' • lib/main.dart:20:9 • undefined_identifier
```

#### 2. **فشل الاختبارات**

```bash
# الاختبارات تتعطل مع أخطاء rendering
LayoutBuilder does not support returning intrinsic dimensions
RenderBox was not laid out
```

#### 3. **Dependencies قديمة**

```yaml
# الحزم التي تحتاج تحديث:
flutter_riverpod: 2.6.1 → 3.0.3
flutter_secure_storage: 9.2.4 → 10.0.0
flutter_lints: 4.0.0 → 6.0.0
mockito: 5.4.4 → 5.6.1
build_runner: 2.4.13 → 2.10.4
```

### **خطة الإصلاح الفورية:**

```bash
# 1. إصلاح FontManager
# إما إنشاء الكلاس أو إزالة الاستدعاء من main.dart

# 2. إصلاح الاختبارات
flutter test --no-coverage  # فحص بدون تغطية أولاً

# 3. تحديث التبعيات
flutter pub upgrade --major-versions

# 4. إصلاح مشاكل flutter analyze
flutter analyze --fix
```

### **الأولوية:**

1. 🔴 **عالية**: FontManager error (يمنع التشغيل)
2. 🟠 **متوسطة**: فشل الاختبارات (يؤثر على الجودة)
3. 🟡 **منخفضة**: تحديث التبعيات (تحسين عام)

---

## 🔗 المراجع التفصيلية

### **للتفاصيل الشاملة:**

- [المكدس التقني المتقدم (مرجع شامل)](../../reference/advanced-tech-stack.md)

### **المعايير التقنية:**

- [معايير Flutter/Dart](./frontend-standards.md)
- [معايير التطوير](./development-standards.md)
- [أفضل ممارسات الأمان](./security-best-practices.md)

### **أدلة العمل:**

- [سير عمل Git](./git-workflow.md)
- [معايير الاختبارات](./testing-best-practices.md)
- [أفضل ممارسات MCP](./mcp-best-practices.md)

---

## 🎯 التوصيات العملية

### **للمطورين الجدد:**

1. ابدأ بقراءة [الفلسفة الهندسية](../core/philosophy.md)
2. راجع [المرجع السريع](../core/quick-reference.md)
3. اتبع [معايير Flutter](./frontend-standards.md)

### **للتطوير اليومي:**

1. استخدم `flutter analyze` قبل كل commit
2. اكتب اختبارات لكل ميزة جديدة
3. اتبع Clean Architecture patterns
4. استخدم Riverpod لإدارة الحالة

### **للأمان:**

1. لا تضع أسرار في الكود
2. استخدم `flutter_secure_storage` للبيانات الحساسة
3. اتبع [معايير الأمان](./security-best-practices.md)

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ⚠️ تم تحديثه ليعكس الواقع الفعلي - يحتاج إصلاحات فورية  
**آخر فحص:** 17 ديسمبر 2025  
**المراجعة القادمة:** بعد إصلاح المشاكل الحرجة
