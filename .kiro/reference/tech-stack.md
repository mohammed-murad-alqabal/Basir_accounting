---
id: "tech-stack"
description: "المكدس التقني الكامل لبصير MVP"
version: "1.0"
last_updated: "2025-12-17"
inclusion: manual
author: "فريق وكلاء تطوير مشروع بصير"
metrics:
  location: ".kiro/reference/"
  size: "25KB"
  lines: 624
  context_usage: "12%"
note: "ملف كبير - استخدم tech-stack-index.md للتحميل الافتراضي"
---

# Tech Stack - Baseer MVP

**Project:** Baseer MVP - Flutter Invoice Management App  
**Architecture:** Local-first, offline-capable mobile application  
**Primary Language:** Arabic (UI) + English (code)  
**Last Updated:** December 17, 2025

## Core Technology Decisions

### Flutter & Dart Versions (MANDATORY)

```yaml
flutter: ">=3.35.5"
dart: ">=3.9.2"
target_platform: Android (API 21+)
future_platform: iOS (Q1-Q2 2026)
```

**AI Instructions:**

- Always use Flutter 3.35.5+ features and APIs
- Write Dart code compatible with 3.9.2+
- Target Android API 21+ (Android 5.0+)
- Do NOT suggest iOS-specific code yet (future phase)

## State Management (MANDATORY)

**Package:** `flutter_riverpod ^2.6.1`

**AI Instructions:**

- ALWAYS use Riverpod for state management
- Use `StateNotifier` for complex state logic
- Use `AsyncValue` for async operations (loading/error/data states)
- Use `Provider.family` for parameterized providers
- Never use `setState()` for business logic
- Never suggest Provider, BLoC, or GetX

**Code Pattern:**

```dart
// Correct: Use StateNotifier with AsyncValue
final invoicesProvider = StateNotifierProvider<InvoicesNotifier, AsyncValue<List<Invoice>>>((ref) {
  return InvoicesNotifier(ref.watch(invoiceRepositoryProvider));
});

class InvoicesNotifier extends StateNotifier<AsyncValue<List<Invoice>>> {
  InvoicesNotifier(this._repository) : super(const AsyncValue.loading());

  final InvoiceRepository _repository;

  Future<void> loadInvoices() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAllInvoices());
  }
}
```

## Local Database (MANDATORY)

**Package:** `isar ^3.1.0+1`

**AI Instructions:**

- ALWAYS use Isar for local data persistence
- Never suggest SQLite, Hive, or other databases
- Use `@Collection()` for entity classes
- Use `@Index()` for frequently queried fields
- Use `@Index(composite: [...])` for complex queries
- Always use transactions for related operations

**Why Isar:**

- 10x faster than SQLite
- Type-safe queries
- Perfect for offline-first architecture
- Excellent Flutter integration

**Code Pattern:**

```dart
@Collection()
class Invoice {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime createdAt;

  @Index()
  late int customerId;

  late double totalAmount;
  late String status;
}

// Query pattern
Future<List<Invoice>> getRecentInvoices() async {
  return await isar.invoices
    .where()
    .sortByCreatedAtDesc()
    .limit(50)
    .findAll();
}
```

## Security (MANDATORY)

**Packages:**

- `flutter_secure_storage ^9.0.0` - for sensitive data
- `crypto ^3.0.7` - for encryption

**AI Instructions:**

- NEVER hardcode secrets or credentials
- ALWAYS use `flutter_secure_storage` for sensitive data (PINs, tokens, keys)
- ALWAYS validate and sanitize user inputs
- ALWAYS hash passwords with SHA-256 or better
- Use AES-256 for data encryption when needed

**Code Pattern:**

```dart
// Correct: Secure storage
const storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

await storage.write(key: 'user_pin', value: hashedPin);
final pin = await storage.read(key: 'user_pin');

// Correct: Input validation
String sanitizeInput(String input) {
  return input.replaceAll(RegExp(r'[<>"\']'), '').trim();
}
```

## UI Framework (MANDATORY)

**Design System:** Material Design 3

**AI Instructions:**

- ALWAYS use Material Design 3 components
- Use `useMaterial3: true` in ThemeData
- Support both light and dark themes
- ALWAYS implement RTL (right-to-left) layout support
- Use `Directionality` widget for RTL content

**Code Pattern:**

```dart
// Correct: Material 3 theme
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2196F3),
    brightness: Brightness.light,
  ),
)

// Correct: RTL support
Directionality(
  textDirection: TextDirection.rtl,
  child: Scaffold(
    appBar: AppBar(title: const Text('إدارة الفواتير')),
    body: YourContent(),
  ),
)
```

## Arabic Language Support (MANDATORY)

**Packages:**

- `flutter_localizations` (SDK)
- `intl ^0.20.2`

**Fonts:** Cairo font family (local assets in `assets/fonts/`)

**AI Instructions:**

- ALL user-facing text MUST be in Arabic
- ALL code identifiers MUST be in English (variables, functions, classes)
- ALWAYS use RTL layout for Arabic content
- Use Cairo font for Arabic text
- Validate Arabic input with regex: `^[\u0600-\u06FF\s]+$`
- Support both Arabic (٠١٢٣) and Western (0123) numerals

**Code Pattern:**

```dart
// Correct: Arabic UI text, English code
class CustomerCard extends StatelessWidget {
  final Customer customer;
  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(customer.name), // Arabic name from data
        subtitle: const Text('رقم الهاتف'), // Arabic label
        trailing: Text(customer.phone),
      ),
    );
  }
}

// Correct: Arabic input validation
bool isValidArabicName(String name) {
  return RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(name);
}
```

## Testing Requirements (MANDATORY)

**Packages:**

- `flutter_test` (SDK)
- `mockito ^5.4.4`

**Coverage Target:** 70%+ (aiming for 85%+)

**AI Instructions:**

- ALWAYS write tests for new code
- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for critical flows
- Use `mockito` for mocking dependencies
- Test both success and error cases
- Test Arabic text rendering and RTL layout

**Code Pattern:**

```dart
// Correct: Unit test with mockito
void main() {
  late InvoiceService service;
  late MockInvoiceRepository mockRepo;

  setUp(() {
    mockRepo = MockInvoiceRepository();
    service = InvoiceService(mockRepo);
  });

  test('should create invoice with valid data', () async {
    final invoice = Invoice(customerId: 1, amount: 100.0);
    when(mockRepo.save(any)).thenAnswer((_) async => invoice);

    final result = await service.createInvoice(invoice);

    expect(result.customerId, equals(1));
    verify(mockRepo.save(any)).called(1);
  });
}
```

## Code Quality Standards (MANDATORY)

**Package:** `flutter_lints ^4.0.0`

**AI Instructions:**

- Run `flutter analyze` before committing
- Run `dart format .` to format code (80 char line length)
- Fix all analyzer errors (0 errors required)
- Follow `effective_dart` guidelines
- Use `const` constructors wherever possible
- Implement proper `dispose()` methods
- Write DartDoc comments for public APIs

**Commands:**

```bash
# Before every commit
dart format .
flutter analyze
flutter test --coverage
```

## Code Generation (MANDATORY)

**Packages:**

- `build_runner ^2.4.13`
- `isar_generator ^3.1.0+1`
- `riverpod_generator ^2.4.0` (optional)
- `freezed ^2.5.2` (optional)

**AI Instructions:**

- Run code generation after modifying Isar models
- Use `build_runner` for generating code
- Never manually edit generated files

**Commands:**

```bash
# Generate code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch mode (development)
flutter packages pub run build_runner watch
```

## Architecture Pattern (MANDATORY)

**Pattern:** Clean Architecture (3 layers)

**AI Instructions:**

- ALWAYS organize code by feature, not by type
- Use 3-layer architecture: Presentation, Domain, Data
- Keep business logic in Domain layer
- Use Repository pattern for data access
- Use Dependency Injection via Riverpod

**Project Structure:**

```
lib/
├── core/                    # Shared utilities, theme, constants
├── features/               # Feature-based organization
│   ├── invoices/
│   │   ├── data/          # Repositories, data sources
│   │   ├── domain/        # Entities, use cases
│   │   └── presentation/  # Pages, widgets, providers
│   └── customers/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

## Platform Support

**Current:** Android only (API 21+)  
**Future:** iOS (Q1-Q2 2026)

**AI Instructions:**

- Focus on Android development only
- Do NOT suggest iOS-specific code yet
- Use platform-agnostic Flutter APIs
- Test on Android devices/emulators only
- Minimum SDK: API 21 (Android 5.0)
- Target SDK: API 34 (Android 14)

## Local-First Architecture (CRITICAL)

**AI Instructions:**

- This is a LOCAL-FIRST application
- ALL core features MUST work offline
- Network connectivity is OPTIONAL, not required
- Use Isar for local data persistence
- Implement background sync when online (future feature)
- Never assume network availability

**Pattern:**

```dart
// Correct: Local-first data access
class InvoiceRepository {
  Future<List<Invoice>> getInvoices() async {
    // 1. Always return local data first
    final localInvoices = await _isar.invoices.where().findAll();

    // 2. Sync in background if connected (future)
    if (await _connectivity.isConnected()) {
      _syncInBackground(); // Don't await
    }

    return localInvoices;
  }
}
```

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
