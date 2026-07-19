# تصميم نظام Onboarding المحسّن

**المشروع:** بصير MVP  
**التاريخ:** 7 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ معتمد

---

## نظرة عامة

نظام Onboarding المحسّن هو تجربة تفاعلية مكونة من 4 خطوات رئيسية تهدف إلى تحقيق "First Success" للمستخدم الجديد في أقل من 5 دقائق. التصميم يركز على البساطة، السرعة، والتخصيص حسب نوع العمل.

### الأهداف التصميمية

1. **السرعة**: Time to First Invoice < 5 دقائق
2. **البساطة**: 4 خطوات فقط للوصول إلى First Success
3. **التخصيص**: تجربة مخصصة حسب نوع العمل
4. **الوضوح**: واجهة نظيفة مع إرشادات واضحة
5. **المرونة**: إمكانية التخطي والعودة لاحقاً

### المبادئ التصميمية

- **Progressive Disclosure**: عرض المعلومات تدريجياً
- **Immediate Feedback**: استجابة فورية لكل إجراء
- **Error Prevention**: منع الأخطاء قبل حدوثها
- **Contextual Help**: مساعدة في الوقت المناسب
- **Celebration**: الاحتفال بالإنجازات

---

## البنية المعمارية

### نمط المعمارية

نستخدم **Feature-First Clean Architecture** مع فصل واضح للمسؤوليات:

```
lib/features/onboarding/
├── domain/
│   ├── entities/
│   │   ├── onboarding_state.dart
│   │   ├── business_type.dart
│   │   └── onboarding_step.dart
│   └── repositories/
│       └── onboarding_repository.dart
├── data/
│   ├── models/
│   │   ├── onboarding_state_model.dart
│   │   └── business_type_model.dart
│   ├── repositories/
│   │   └── onboarding_repository_impl.dart
│   └── datasources/
│       └── onboarding_local_datasource.dart
└── presentation/
    ├── screens/
    │   ├── welcome_screen.dart
    │   ├── business_type_screen.dart
    │   ├── template_selection_screen.dart
    │   ├── quick_setup_screen.dart
    │   ├── first_success_screen.dart
    │   └── guided_tour_screen.dart
    ├── widgets/
    │   ├── onboarding_progress_indicator.dart
    │   ├── business_type_card.dart
    │   ├── template_preview_card.dart
    │   └── contextual_tip.dart
    └── providers/
        └── onboarding_provider.dart
```

## المكونات والواجهات

### 1. Domain Layer

#### OnboardingState Entity

```dart
class OnboardingState {
  final String id;
  final OnboardingStep currentStep;
  final BusinessType? selectedBusinessType;
  final String? selectedTemplateId;
  final CompanyInfo? companyInfo;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  OnboardingState({
    required this.id,
    required this.currentStep,
    this.selectedBusinessType,
    this.selectedTemplateId,
    this.companyInfo,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });
}
```

#### BusinessType Enum

```dart
enum BusinessType {
  freelancer,  // مستقل
  shop,        // محل
  company,     // شركة
  professional // مهني
}
```

#### OnboardingStep Enum

```dart
enum OnboardingStep {
  welcome,           // شاشة الترحيب
  businessType,      // اختيار نوع العمل
  templateSelection, // اختيار القالب
  quickSetup,        // الإعداد السريع
  firstSuccess,      // النجاح الأول
  guidedTour,        // الجولة الإرشادية
  completed          // مكتمل
}
```

#### OnboardingRepository Interface

```dart
abstract class OnboardingRepository {
  /// يحفظ حالة Onboarding الحالية
  Future<void> saveState(OnboardingState state);

  /// يسترجع حالة Onboarding المحفوظة
  Future<OnboardingState?> getState();

  /// يحدث الخطوة الحالية
  Future<void> updateCurrentStep(OnboardingStep step);

  /// يحفظ نوع العمل المختار
  Future<void> saveBusinessType(BusinessType type);

  /// يحفظ القالب المختار
  Future<void> saveSelectedTemplate(String templateId);

  /// يحفظ معلومات الشركة
  Future<void> saveCompanyInfo(CompanyInfo info);

  /// يكمل Onboarding
  Future<void> completeOnboarding();

  /// يعيد تعيين Onboarding
  Future<void> resetOnboarding();

  /// يتحقق إذا كان Onboarding مكتمل
  Future<bool> isOnboardingCompleted();
}
```

### 2. Data Layer

#### OnboardingStateModel

```dart
@collection
class OnboardingStateModel {
  Id id = Isar.autoIncrement;

  @enumerated
  late OnboardingStep currentStep;

  @enumerated
  OnboardingStep? selectedBusinessType;

  String? selectedTemplateId;

  String? companyName;
  String? companyPhone;
  String? companyAddress;
  String? companyEmail;

  late bool isCompleted;
  late DateTime createdAt;
  DateTime? completedAt;

  /// تحويل إلى Entity
  OnboardingState toEntity() {
    return OnboardingState(
      id: id.toString(),
      currentStep: currentStep,
      selectedBusinessType: selectedBusinessType,
      selectedTemplateId: selectedTemplateId,
      companyInfo: companyName != null ? CompanyInfo(
        name: companyName!,
        phone: companyPhone!,
        address: companyAddress!,
        email: companyEmail,
      ) : null,
      isCompleted: isCompleted,
      createdAt: createdAt,
      completedAt: completedAt,
    );
  }

  /// تحويل من Entity
  static OnboardingStateModel fromEntity(OnboardingState entity) {
    return OnboardingStateModel()
      ..currentStep = entity.currentStep
      ..selectedBusinessType = entity.selectedBusinessType
      ..selectedTemplateId = entity.selectedTemplateId
      ..companyName = entity.companyInfo?.name
      ..companyPhone = entity.companyInfo?.phone
      ..companyAddress = entity.companyInfo?.address
      ..companyEmail = entity.companyInfo?.email
      ..isCompleted = entity.isCompleted
      ..createdAt = entity.createdAt
      ..completedAt = entity.completedAt;
  }
}
```

#### OnboardingRepositoryImpl

```dart
class OnboardingRepositoryImpl implements OnboardingRepository {
  final Isar isar;

  OnboardingRepositoryImpl(this.isar);

  @override
  Future<void> saveState(OnboardingState state) async {
    await isar.writeTxn(() async {
      final model = OnboardingStateModel.fromEntity(state);
      await isar.onboardingStateModels.put(model);
    });
  }

  @override
  Future<OnboardingState?> getState() async {
    final model = await isar.onboardingStateModels
        .where()
        .sortByCreatedAtDesc()
        .findFirst();
    return model?.toEntity();
  }

  // ... تنفيذ باقي الدوال
}
```

### 3. Presentation Layer

#### OnboardingProvider

```dart
@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  Future<OnboardingState> build() async {
    final repository = ref.read(onboardingRepositoryProvider);
    final state = await repository.getState();

    // إذا لم توجد حالة محفوظة، أنشئ حالة جديدة
    if (state == null) {
      final newState = OnboardingState(
        id: const Uuid().v4(),
        currentStep: OnboardingStep.welcome,
        createdAt: DateTime.now(),
      );
      await repository.saveState(newState);
      return newState;
    }

    return state;
  }

  /// الانتقال للخطوة التالية
  Future<void> nextStep() async {
    final currentState = state.value!;
    final nextStep = _getNextStep(currentState.currentStep);

    final newState = currentState.copyWith(currentStep: nextStep);
    await ref.read(onboardingRepositoryProvider).saveState(newState);

    state = AsyncValue.data(newState);
  }

  /// حفظ نوع العمل
  Future<void> selectBusinessType(BusinessType type) async {
    final currentState = state.value!;
    final newState = currentState.copyWith(selectedBusinessType: type);

    await ref.read(onboardingRepositoryProvider).saveState(newState);
    state = AsyncValue.data(newState);
  }

  /// حفظ القالب المختار
  Future<void> selectTemplate(String templateId) async {
    final currentState = state.value!;
    final newState = currentState.copyWith(selectedTemplateId: templateId);

    await ref.read(onboardingRepositoryProvider).saveState(newState);
    state = AsyncValue.data(newState);
  }

  /// حفظ معلومات الشركة
  Future<void> saveCompanyInfo(CompanyInfo info) async {
    final currentState = state.value!;
    final newState = currentState.copyWith(companyInfo: info);

    await ref.read(onboardingRepositoryProvider).saveState(newState);
    state = AsyncValue.data(newState);
  }

  /// إكمال Onboarding
  Future<void> complete() async {
    final currentState = state.value!;
    final newState = currentState.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
      currentStep: OnboardingStep.completed,
    );

    await ref.read(onboardingRepositoryProvider).completeOnboarding();
    state = AsyncValue.data(newState);
  }

  OnboardingStep _getNextStep(OnboardingStep current) {
    switch (current) {
      case OnboardingStep.welcome:
        return OnboardingStep.businessType;
      case OnboardingStep.businessType:
        return OnboardingStep.templateSelection;
      case OnboardingStep.templateSelection:
        return OnboardingStep.quickSetup;
      case OnboardingStep.quickSetup:
        return OnboardingStep.firstSuccess;
      case OnboardingStep.firstSuccess:
        return OnboardingStep.guidedTour;
      case OnboardingStep.guidedTour:
        return OnboardingStep.completed;
      case OnboardingStep.completed:
        return OnboardingStep.completed;
    }
  }
}
```

## نماذج البيانات

### CompanyInfo

```dart
class CompanyInfo {
  final String name;
  final String phone;
  final String address;
  final String? email;

  CompanyInfo({
    required this.name,
    required this.phone,
    required this.address,
    this.email,
  });

  CompanyInfo copyWith({
    String? name,
    String? phone,
    String? address,
    String? email,
  }) {
    return CompanyInfo(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      email: email ?? this.email,
    );
  }
}
```

### InvoiceTemplate

```dart
class InvoiceTemplate {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final BusinessType suitableFor;
  final String previewImageUrl;
  final TemplateStyle style;

  InvoiceTemplate({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.suitableFor,
    required this.previewImageUrl,
    required this.style,
  });
}
```

### TemplateStyle

```dart
class TemplateStyle {
  final Color primaryColor;
  final Color secondaryColor;
  final String fontFamily;
  final bool showLogo;
  final bool showQRCode;
  final LayoutType layout;

  TemplateStyle({
    required this.primaryColor,
    required this.secondaryColor,
    required this.fontFamily,
    this.showLogo = true,
    this.showQRCode = true,
    required this.layout,
  });
}

enum LayoutType {
  simple,      // بسيط
  professional, // احترافي
  modern,      // عصري
  classic      // كلاسيكي
}
```

## Correctness Properties

_A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees._

### Property 1: Step Transition Consistency

_For any_ onboarding state at step welcome, when the video completes or is skipped, the state must transition to businessType step.

**Validates: Requirements 1.3**

### Property 2: Business Type Persistence

_For any_ selected business type, after saving, the business type must be retrievable from the local database and match the selected value.

**Validates: Requirements 2.2**

### Property 3: Template Preview Display

_For any_ invoice template, when pressed, a preview screen must be displayed showing the template details.

**Validates: Requirements 3.2**

### Property 4: Template Selection Persistence

_For any_ selected template, after saving, the template ID must be stored as the default template in the database.

**Validates: Requirements 3.3**

### Property 5: Company Name Validation

_For any_ company name input, validation must pass if and only if the name is non-empty and has length >= 2 characters.

**Validates: Requirements 4.2**

### Property 6: Phone Number Validation

_For any_ phone number input, validation must pass if and only if the number starts with "05" and has exactly 10 digits.

**Validates: Requirements 4.3**

### Property 7: Email Validation

_For any_ email input, validation must pass if and only if the email matches the standard email format pattern.

**Validates: Requirements 4.4**

### Property 8: Customer Save Celebration

_For any_ customer save action, a congratulatory message must be displayed to the user.

**Validates: Requirements 5.2**

### Property 9: First Invoice Celebration

_For any_ first invoice creation, a celebratory message must be displayed to the user.

**Validates: Requirements 5.3**

### Property 10: Guided Tour Transition

_For any_ onboarding state at firstSuccess step, when "start tour" is selected, the state must transition to guidedTour step.

**Validates: Requirements 6.2**

### Property 11: Onboarding Completion

_For any_ onboarding state, when the guided tour is completed, isCompleted must be set to true and completedAt must be set to the current timestamp.

**Validates: Requirements 6.3**

### Property 12: Progress Persistence (Round Trip)

_For any_ onboarding state, saving the state to the database and then retrieving it must return an equivalent state with the same currentStep, selectedBusinessType, and other properties.

**Validates: Requirements 9.1, 9.2**

### Property 13: Business Type Customization

_For any_ business type selection, the displayed tips, examples, and templates must be customized specifically for that business type.

**Validates: Requirements 10.1**

## معالجة الأخطاء

### استراتيجية معالجة الأخطاء

#### 1. أخطاء التحقق من الصحة (Validation Errors)

```dart
class ValidationException implements Exception {
  final String field;
  final String message;

  ValidationException(this.field, this.message);

  @override
  String toString() => 'ValidationException: $field - $message';
}
```

**معالجة:**

- عرض رسالة خطأ واضحة باللغة العربية تحت الحقل المعني
- تمييز الحقل بلون أحمر
- منع الانتقال للخطوة التالية حتى يتم تصحيح الخطأ

#### 2. أخطاء قاعدة البيانات (Database Errors)

```dart
class DatabaseException implements Exception {
  final String operation;
  final String message;

  DatabaseException(this.operation, this.message);

  @override
  String toString() => 'DatabaseException: $operation - $message';
}
```

**معالجة:**

- محاولة إعادة العملية مرة واحدة
- إذا فشلت، عرض رسالة خطأ عامة: "حدث خطأ أثناء حفظ البيانات. يرجى المحاولة مرة أخرى"
- تسجيل الخطأ للمراجعة

#### 3. أخطاء الحالة (State Errors)

```dart
class StateException implements Exception {
  final String currentState;
  final String expectedState;

  StateException(this.currentState, this.expectedState);

  @override
  String toString() => 'StateException: Expected $expectedState but got $currentState';
}
```

**معالجة:**

- إعادة تحميل الحالة من قاعدة البيانات
- إذا فشلت، إعادة تعيين Onboarding من البداية
- إعلام المستخدم بوضوح

### مثال على معالجة الأخطاء

```dart
Future<void> saveCompanyInfo(CompanyInfo info) async {
  try {
    // التحقق من الصحة
    _validateCompanyInfo(info);

    // الحفظ
    final currentState = state.value!;
    final newState = currentState.copyWith(companyInfo: info);
    await ref.read(onboardingRepositoryProvider).saveState(newState);

    state = AsyncValue.data(newState);
  } on ValidationException catch (e) {
    // عرض رسالة خطأ للمستخدم
    state = AsyncValue.error(
      'خطأ في التحقق: ${e.message}',
      StackTrace.current,
    );
  } on DatabaseException catch (e) {
    // محاولة إعادة العملية
    debugPrint('Database error: ${e.message}. Retrying...');
    try {
      await ref.read(onboardingRepositoryProvider).saveState(newState);
      state = AsyncValue.data(newState);
    } catch (retryError) {
      state = AsyncValue.error(
        'حدث خطأ أثناء حفظ البيانات. يرجى المحاولة مرة أخرى',
        StackTrace.current,
      );
    }
  } catch (e, stackTrace) {
    debugPrint('Unexpected error: $e');
    debugPrintStack(stackTrace: stackTrace);
    state = AsyncValue.error(
      'حدث خطأ غير متوقع',
      stackTrace,
    );
  }
}
```

## استراتيجية الاختبار

### نهج الاختبار المزدوج

نستخدم نهجاً مزدوجاً يجمع بين **Unit Tests** و **Property-Based Tests** لضمان تغطية شاملة:

- **Unit Tests**: للتحقق من أمثلة محددة وحالات خاصة
- **Property Tests**: للتحقق من الخصائص العامة عبر مجموعة واسعة من المدخلات

### مكتبة Property-Based Testing

**المكتبة المختارة**: لا توجد مكتبة property-based testing ناضجة لـ Dart/Flutter حالياً، لذلك سنستخدم نهج **Parameterized Tests** مع **test package** لمحاكاة property-based testing.

### تكوين الاختبارات

```dart
// في ملف test_helpers.dart
class PropertyTest {
  static const int minIterations = 100;

  static Future<void> runProperty<T>({
    required String description,
    required List<T> testCases,
    required Future<void> Function(T) test,
  }) async {
    for (final testCase in testCases) {
      await test(testCase);
    }
  }
}
```

### Unit Tests

#### 1. اختبار OnboardingRepository

```dart
void main() {
  group('OnboardingRepository', () {
    late Isar isar;
    late OnboardingRepositoryImpl repository;

    setUp(() async {
      isar = await Isar.open(
        [OnboardingStateModelSchema],
        directory: '',
        name: 'test_${DateTime.now().millisecondsSinceEpoch}',
      );
      repository = OnboardingRepositoryImpl(isar);
    });

    tearDown(() async {
      await isar.close(deleteFromDisk: true);
    });

    test('should save and retrieve onboarding state', () async {
      // Arrange
      final state = OnboardingState(
        id: 'test-1',
        currentStep: OnboardingStep.welcome,
        createdAt: DateTime.now(),
      );

      // Act
      await repository.saveState(state);
      final retrieved = await repository.getState();

      // Assert
      expect(retrieved, isNotNull);
      expect(retrieved!.currentStep, OnboardingStep.welcome);
    });

    test('should update current step', () async {
      // Arrange
      final state = OnboardingState(
        id: 'test-1',
        currentStep: OnboardingStep.welcome,
        createdAt: DateTime.now(),
      );
      await repository.saveState(state);

      // Act
      await repository.updateCurrentStep(OnboardingStep.businessType);
      final retrieved = await repository.getState();

      // Assert
      expect(retrieved!.currentStep, OnboardingStep.businessType);
    });
  });
}
```

#### 2. اختبار Validation

```dart
void main() {
  group('CompanyInfo Validation', () {
    test('should accept valid company name', () {
      // Arrange
      const name = 'شركة بصير';

      // Act
      final result = validateCompanyName(name);

      // Assert
      expect(result, isNull);
    });

    test('should reject empty company name', () {
      // Arrange
      const name = '';

      // Act
      final result = validateCompanyName(name);

      // Assert
      expect(result, equals('اسم الشركة مطلوب'));
    });

    test('should reject short company name', () {
      // Arrange
      const name = 'أ';

      // Act
      final result = validateCompanyName(name);

      // Assert
      expect(result, contains('حرفين على الأقل'));
    });
  });
}
```

### Property-Based Tests

#### Property Test 1: Round Trip Persistence

**Feature: enhanced-onboarding, Property 12: Progress Persistence**

```dart
void main() {
  group('Property: Round Trip Persistence', () {
    late Isar isar;
    late OnboardingRepositoryImpl repository;

    setUp(() async {
      isar = await Isar.open(
        [OnboardingStateModelSchema],
        directory: '',
        name: 'test_${DateTime.now().millisecondsSinceEpoch}',
      );
      repository = OnboardingRepositoryImpl(isar);
    });

    tearDown(() async {
      await isar.close(deleteFromDisk: true);
    });

    test('saving and retrieving state should return equivalent state', () async {
      // Generate test cases
      final testCases = [
        OnboardingState(
          id: 'test-1',
          currentStep: OnboardingStep.welcome,
          createdAt: DateTime.now(),
        ),
        OnboardingState(
          id: 'test-2',
          currentStep: OnboardingStep.businessType,
          selectedBusinessType: BusinessType.freelancer,
          createdAt: DateTime.now(),
        ),
        OnboardingState(
          id: 'test-3',
          currentStep: OnboardingStep.quickSetup,
          selectedBusinessType: BusinessType.company,
          selectedTemplateId: 'template-1',
          companyInfo: CompanyInfo(
            name: 'شركة اختبار',
            phone: '0501234567',
            address: 'الرياض',
            email: 'test@example.com',
          ),
          createdAt: DateTime.now(),
        ),
      ];

      // Run property test
      for (final originalState in testCases) {
        // Act
        await repository.saveState(originalState);
        final retrievedState = await repository.getState();

        // Assert
        expect(retrievedState, isNotNull);
        expect(retrievedState!.currentStep, originalState.currentStep);
        expect(retrievedState.selectedBusinessType, originalState.selectedBusinessType);
        expect(retrievedState.selectedTemplateId, originalState.selectedTemplateId);
        if (originalState.companyInfo != null) {
          expect(retrievedState.companyInfo!.name, originalState.companyInfo!.name);
          expect(retrievedState.companyInfo!.phone, originalState.companyInfo!.phone);
        }
      }
    });
  });
}
```

#### Property Test 2: Phone Number Validation

**Feature: enhanced-onboarding, Property 6: Phone Number Validation**

```dart
void main() {
  group('Property: Phone Number Validation', () {
    test('validation passes only for numbers starting with 05 and length 10', () async {
      // Valid test cases
      final validNumbers = [
        '0501234567',
        '0551234567',
        '0591234567',
      ];

      // Invalid test cases
      final invalidNumbers = [
        '1234567890',  // doesn't start with 05
        '05123456',    // too short
        '050123456789', // too long
        '0612345678',  // starts with 06
        '05abcd1234',  // contains letters
      ];

      // Test valid numbers
      for (final number in validNumbers) {
        final result = validatePhoneNumber(number);
        expect(result, isNull, reason: 'Expected $number to be valid');
      }

      // Test invalid numbers
      for (final number in invalidNumbers) {
        final result = validatePhoneNumber(number);
        expect(result, isNotNull, reason: 'Expected $number to be invalid');
      }
    });
  });
}
```

#### Property Test 3: Business Type Customization

**Feature: enhanced-onboarding, Property 13: Business Type Customization**

```dart
void main() {
  group('Property: Business Type Customization', () {
    test('each business type should have customized content', () {
      final businessTypes = BusinessType.values;

      for (final type in businessTypes) {
        // Act
        final templates = getTemplatesForBusinessType(type);
        final tips = getTipsForBusinessType(type);
        final examples = getExamplesForBusinessType(type);

        // Assert
        expect(templates, isNotEmpty,
          reason: 'Business type $type should have templates');
        expect(tips, isNotEmpty,
          reason: 'Business type $type should have tips');
        expect(examples, isNotEmpty,
          reason: 'Business type $type should have examples');

        // Verify customization
        expect(templates.every((t) => t.suitableFor == type), isTrue,
          reason: 'All templates should be suitable for $type');
      }
    });
  });
}
```

### Widget Tests

```dart
void main() {
  group('WelcomeScreen Widget Tests', () {
    testWidgets('should display welcome message and video', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: WelcomeScreen(),
        ),
      );

      // Assert
      expect(find.text('مرحباً بك في بصير'), findsOneWidget);
      expect(find.byType(VideoPlayer), findsOneWidget);
      expect(find.text('تخطي'), findsOneWidget);
    });

    testWidgets('should navigate to business type screen on skip', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: WelcomeScreen(),
        ),
      );

      // Act
      await tester.tap(find.text('تخطي'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BusinessTypeScreen), findsOneWidget);
    });
  });
}
```

### Integration Tests

```dart
void main() {
  group('Onboarding Flow Integration Tests', () {
    testWidgets('complete onboarding flow', (tester) async {
      // Arrange
      await tester.pumpWidget(MyApp());

      // Step 1: Welcome
      expect(find.byType(WelcomeScreen), findsOneWidget);
      await tester.tap(find.text('تخطي'));
      await tester.pumpAndSettle();

      // Step 2: Business Type
      expect(find.byType(BusinessTypeScreen), findsOneWidget);
      await tester.tap(find.text('مستقل'));
      await tester.pumpAndSettle();

      // Step 3: Template Selection
      expect(find.byType(TemplateSelectionScreen), findsOneWidget);
      await tester.tap(find.byType(TemplatePreviewCard).first);
      await tester.pumpAndSettle();

      // Step 4: Quick Setup
      expect(find.byType(QuickSetupScreen), findsOneWidget);
      await tester.enterText(find.byKey(Key('company_name')), 'شركة اختبار');
      await tester.enterText(find.byKey(Key('company_phone')), '0501234567');
      await tester.enterText(find.byKey(Key('company_address')), 'الرياض');
      await tester.tap(find.text('التالي'));
      await tester.pumpAndSettle();

      // Step 5: First Success
      expect(find.byType(FirstSuccessScreen), findsOneWidget);
    });
  });
}
```

### تغطية الاختبارات المستهدفة

| النوع             |    التغطية المستهدفة    |
| :---------------- | :---------------------: |
| Unit Tests        |          80%+           |
| Widget Tests      |  جميع الشاشات الرئيسية  |
| Integration Tests |      التدفق الكامل      |
| Property Tests    | جميع الخصائص (13 خاصية) |

## الأداء والتحسين

### متطلبات الأداء

| المقياس              |  الهدف  |  الأولوية  |
| :------------------- | :-----: | :--------: |
| Time to First Screen | < 500ms | عالية جداً |
| Step Transition Time | < 300ms |   عالية    |
| Database Save Time   | < 100ms |   عالية    |
| Video Load Time      |  < 2s   |   متوسطة   |
| Memory Usage         | < 50MB  |   متوسطة   |

### استراتيجيات التحسين

#### 1. Lazy Loading

```dart
// تحميل الفيديو فقط عند الحاجة
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    // تحميل الفيديو بشكل غير متزامن
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/videos/welcome.mp4');
    await _controller!.initialize();
    setState(() {});
  }
}
```

#### 2. Caching

```dart
// تخزين القوالب في الذاكرة المؤقتة
class TemplateCache {
  static final Map<String, InvoiceTemplate> _cache = {};

  static InvoiceTemplate? get(String id) => _cache[id];

  static void set(String id, InvoiceTemplate template) {
    _cache[id] = template;
  }

  static void clear() => _cache.clear();
}
```

#### 3. Optimistic UI Updates

```dart
// تحديث الواجهة فوراً قبل حفظ البيانات
Future<void> selectBusinessType(BusinessType type) async {
  // تحديث الواجهة فوراً
  final currentState = state.value!;
  final newState = currentState.copyWith(selectedBusinessType: type);
  state = AsyncValue.data(newState);

  // حفظ في الخلفية
  try {
    await ref.read(onboardingRepositoryProvider).saveState(newState);
  } catch (e) {
    // في حالة الفشل، إعادة الحالة السابقة
    state = AsyncValue.data(currentState);
    rethrow;
  }
}
```

#### 4. Image Optimization

- استخدام صور مضغوطة (WebP format)
- تحميل صور بدقة مناسبة للشاشة
- استخدام placeholders أثناء التحميل

```dart
Image.asset(
  'assets/images/template_preview.webp',
  cacheWidth: 400, // تحديد عرض الكاش
  fit: BoxFit.cover,
)
```

### Monitoring

```dart
class PerformanceMonitor {
  static void trackStepTransition(OnboardingStep from, OnboardingStep to) {
    final stopwatch = Stopwatch()..start();
    // ... perform transition
    stopwatch.stop();

    debugPrint('Step transition $from -> $to took ${stopwatch.elapsedMilliseconds}ms');

    if (stopwatch.elapsedMilliseconds > 300) {
      debugPrint('WARNING: Slow step transition detected!');
    }
  }
}
```

## الأمان والخصوصية

### مبادئ الأمان

1. **Local-First**: جميع البيانات محفوظة محلياً فقط
2. **No Tracking**: لا تتبع للمستخدم أو إرسال بيانات
3. **Encryption**: تشفير البيانات الحساسة
4. **Input Validation**: التحقق من جميع المدخلات

### تنفيذ الأمان

#### 1. تشفير البيانات الحساسة

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureOnboardingStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveCompanyInfo(CompanyInfo info) async {
    // تشفير البيانات الحساسة
    await _storage.write(
      key: '<credential-fixture>',
      value: info.email,
    );
    await _storage.write(
      key: '<credential-fixture>',
      value: info.phone,
    );
  }

  Future<CompanyInfo?> getCompanyInfo() async {
    final email = await _storage.read(key: '<credential-fixture>');
    final phone = await _storage.read(key: '<credential-fixture>');

    if (email == null || phone == null) return null;

    return CompanyInfo(
      name: '', // من قاعدة البيانات العادية
      phone: phone,
      address: '', // من قاعدة البيانات العادية
      email: email,
    );
  }
}
```

#### 2. Input Sanitization

```dart
class InputSanitizer {
  /// تنظيف اسم الشركة من أحرف خاصة خطرة
  static String sanitizeCompanyName(String input) {
    // إزالة أحرف HTML/SQL خطرة
    return input
        .replaceAll(RegExp(r'[<>\'\"\\]'), '')
        .trim();
  }

  /// تنظيف رقم الهاتف
  static String sanitizePhoneNumber(String input) {
    // إبقاء الأرقام فقط
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// تنظيف البريد الإلكتروني
  static String sanitizeEmail(String input) {
    return input.trim().toLowerCase();
  }
}
```

#### 3. Rate Limiting

```dart
class RateLimiter {
  final Map<String, DateTime> _lastAttempts = {};
  final Duration cooldown;

  RateLimiter({this.cooldown = const Duration(seconds: 1)});

  bool canProceed(String action) {
    final lastAttempt = _lastAttempts[action];
    if (lastAttempt == null) {
      _lastAttempts[action] = DateTime.now();
      return true;
    }

    final timeSinceLastAttempt = DateTime.now().difference(lastAttempt);
    if (timeSinceLastAttempt >= cooldown) {
      _lastAttempts[action] = DateTime.now();
      return true;
    }

    return false;
  }
}
```

### Privacy Compliance

- ✅ لا يتم جمع أي بيانات شخصية
- ✅ لا يتم إرسال بيانات لخوادم خارجية
- ✅ المستخدم يتحكم بالكامل في بياناته
- ✅ إمكانية حذف جميع البيانات في أي وقت

## إمكانية الوصول (Accessibility)

### معايير WCAG 2.1 AA

#### 1. التباين اللوني

- نسبة تباين لا تقل عن 4.5:1 للنصوص العادية
- نسبة تباين لا تقل عن 3:1 للنصوص الكبيرة (18px+)

```dart
class AccessibleColors {
  // تباين 7:1 مع الخلفية البيضاء
  static const Color primaryText = Color(0xFF1A1A1A);

  // تباين 4.5:1 مع الخلفية البيضاء
  static const Color secondaryText = Color(0xFF4A4A4A);

  // تباين 4.5:1 مع الخلفية البيضاء
  static const Color hintText = Color(0xFF757575);
}
```

#### 2. حجم الخط

- الحد الأدنى: 14px للنصوص العادية
- الحد الأدنى: 18px للعناوين
- دعم Text Scaling حتى 200%

```dart
Text(
  'مرحباً بك في بصير',
  style: TextStyle(
    fontSize: 24, // سيتم تكبيره تلقائياً مع Text Scaling
  ),
)
```

#### 3. حجم الأزرار

- الحد الأدنى: 48x48 px
- مسافة بين الأزرار: 8px على الأقل

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(88, 48), // WCAG AA
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  onPressed: () {},
  child: const Text('التالي'),
)
```

#### 4. قارئ الشاشة

```dart
Semantics(
  label: 'اختر نوع عملك',
  hint: 'اضغط لاختيار نوع العمل المناسب لك',
  child: BusinessTypeCard(
    type: BusinessType.freelancer,
    onTap: () {},
  ),
)
```

#### 5. التنقل بلوحة المفاتيح

```dart
Focus(
  autofocus: true,
  child: TextField(
    decoration: InputDecoration(
      labelText: 'اسم الشركة',
    ),
  ),
)
```

### اختبارات إمكانية الوصول

```dart
void main() {
  testWidgets('should meet accessibility guidelines', (tester) async {
    await tester.pumpWidget(MyApp());

    // التحقق من حجم الأزرار
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.style?.minimumSize?.resolve({}),
      greaterThanOrEqualTo(const Size(48, 48)));

    // التحقق من Semantics
    expect(find.bySemanticsLabel('اختر نوع عملك'), findsOneWidget);
  });
}
```

## التوطين (Localization)

### دعم اللغة العربية

#### 1. RTL Support

```dart
MaterialApp(
  locale: const Locale('ar', 'SA'),
  supportedLocales: const [
    Locale('ar', 'SA'),
    Locale('en', 'US'),
  ],
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
)
```

#### 2. النصوص المترجمة

```dart
class OnboardingStrings {
  static const Map<String, String> ar = {
    'welcome_title': 'مرحباً بك في بصير',
    'welcome_subtitle': 'تطبيق إدارة الفواتير الأول في السعودية',
    'skip': 'تخطي',
    'next': 'التالي',
    'back': 'رجوع',
    'business_type_title': 'اختر نوع عملك',
    'freelancer': 'مستقل',
    'shop': 'محل',
    'company': 'شركة',
    'professional': 'مهني',
    'template_selection_title': 'اختر قالب الفاتورة',
    'quick_setup_title': 'معلومات الشركة',
    'company_name': 'اسم الشركة',
    'company_phone': 'رقم الهاتف',
    'company_address': 'العنوان',
    'company_email': 'البريد الإلكتروني (اختياري)',
    'first_success_title': 'أنشئ أول فاتورة',
    'congratulations': 'تهانينا!',
    'first_invoice_created': 'أنشأت أول فاتورة بنجاح',
  };

  static const Map<String, String> en = {
    'welcome_title': 'Welcome to Basir',
    'welcome_subtitle': 'The first invoice management app in Saudi Arabia',
    'skip': 'Skip',
    'next': 'Next',
    'back': 'Back',
    // ... باقي الترجمات
  };
}
```

#### 3. تنسيق التواريخ والأرقام

```dart
import 'package:intl/intl.dart';

class LocaleFormatter {
  static String formatDate(DateTime date, String locale) {
    final formatter = DateFormat.yMMMd(locale);
    return formatter.format(date);
  }

  static String formatNumber(num number, String locale) {
    final formatter = NumberFormat.decimalPattern(locale);
    return formatter.format(number);
  }
}
```

## التبعيات والقيود

### التبعيات التقنية

#### المكتبات المطلوبة

```yaml
dependencies:
  flutter:
    sdk: flutter
  riverpod: ^2.4.0
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  flutter_secure_storage: ^9.0.0
  video_player: ^2.8.0
  uuid: ^4.0.0
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  isar_generator: ^3.1.0
  build_runner: ^2.4.0
  mockito: ^5.4.4
```

#### الأصول المطلوبة

```yaml
flutter:
  assets:
    - assets/videos/welcome.mp4
    - assets/images/templates/
    - assets/images/business_types/
```

### القيود

#### 1. القيود التقنية

- **حجم الفيديو**: يجب ألا يتجاوز 5MB
- **دقة الصور**: 1080x1920 كحد أقصى
- **حجم قاعدة البيانات**: محدود بمساحة الجهاز

#### 2. القيود الوظيفية

- **عدد القوالب**: 3 قوالب أساسية لكل نوع عمل في المرحلة الأولى
- **اللغات المدعومة**: العربية والإنجليزية فقط
- **الأجهزة المدعومة**: Android 5.0+ و iOS 12.0+

#### 3. القيود الزمنية

- **مدة الفيديو**: 30 ثانية كحد أقصى
- **وقت الانتقال**: 300ms كحد أقصى بين الخطوات
- **وقت الحفظ**: 100ms كحد أقصى

### المخاطر والتخفيف

| المخاطر           | الاحتمال | التأثير | التخفيف                          |
| :---------------- | :------: | :-----: | :------------------------------- |
| بطء تحميل الفيديو |  متوسط   |  متوسط  | Lazy loading + خيار التخطي       |
| فشل حفظ البيانات  |  منخفض   |  عالي   | Retry mechanism + Error handling |
| مشاكل الأداء      |  منخفض   |  متوسط  | Optimization + Monitoring        |
| مشاكل التوافق     |  منخفض   |  عالي   | Testing على أجهزة متعددة         |

## خطة النشر

### المراحل

#### المرحلة 1: التطوير (الأسبوع 1-2)

- تنفيذ Domain Layer
- تنفيذ Data Layer
- تنفيذ Presentation Layer
- كتابة Unit Tests

#### المرحلة 2: الاختبار (الأسبوع 3)

- كتابة Widget Tests
- كتابة Integration Tests
- كتابة Property Tests
- اختبار الأداء
- اختبار إمكانية الوصول

#### المرحلة 3: التحسين (الأسبوع 4)

- تحسين الأداء
- تحسين UX
- إصلاح الأخطاء
- مراجعة الكود

#### المرحلة 4: النشر (الأسبوع 5)

- Beta testing مع 50 مستخدم
- جمع feedback
- إصلاحات نهائية
- النشر للإنتاج

### معايير القبول للنشر

- ✅ جميع الاختبارات تنجح (100%)
- ✅ Test coverage > 80%
- ✅ لا أخطاء حرجة
- ✅ Time to First Invoice < 5 دقائق
- ✅ Activation Rate > 80% في Beta
- ✅ NPS > 50 في Beta
- ✅ جميع متطلبات إمكانية الوصول مستوفاة

### Rollback Plan

في حالة وجود مشاكل حرجة بعد النشر:

1. إيقاف Onboarding الجديد فوراً
2. العودة للنسخة السابقة
3. إصلاح المشكلة
4. إعادة الاختبار
5. النشر مرة أخرى

## الخلاصة

نظام Onboarding المحسّن هو حجر الأساس لتحقيق Product-Market Fit في Q1 2026. من خلال تجربة سلسة ومخصصة وسريعة، نضمن أن المستخدمين الجدد:

1. **يفهمون القيمة** في أول 30 ثانية
2. **يحققون النجاح** في أقل من 5 دقائق
3. **يشعرون بالثقة** في استخدام التطبيق
4. **يعودون** لاستخدام التطبيق مرة أخرى

### الأولويات التنفيذية

1. **عالية جداً**: Welcome → Quick Setup → First Success
2. **عالية**: Guided Tour + Contextual Tips
3. **متوسطة**: Help Center + Advanced Customization

### المقاييس الرئيسية للنجاح

| المقياس               |   الهدف   |
| :-------------------- | :-------: |
| Time to First Invoice | < 5 دقائق |
| Activation Rate       |   > 80%   |
| Retention Day 7       |   > 40%   |
| NPS                   |   > 50    |
| Test Coverage         |   > 80%   |

### الخطوات التالية

1. مراجعة التصميم والموافقة عليه
2. إنشاء ملف tasks.md مع خطة التنفيذ التفصيلية
3. البدء في التطوير
4. الاختبار المستمر
5. Beta testing
6. النشر

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 7 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** 🔄 جاهز للمراجعة
