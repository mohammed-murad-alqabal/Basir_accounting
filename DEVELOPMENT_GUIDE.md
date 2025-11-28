# دليل التطوير لتطبيق بصير

## مقدمة

هذا الدليل يوفر إرشادات شاملة للمطورين الذين يرغبون في المساهمة في تطوير تطبيق بصير.

## إعداد بيئة التطوير

### المتطلبات
- Flutter 3.24.0 أو أحدث
- Dart 3.5.0 أو أحدث
- Android Studio أو VS Code
- Git

### التثبيت

```bash
# تثبيت Flutter
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# التحقق من التثبيت
flutter doctor

# استنساخ المشروع
git clone <repository-url>
cd basser_mvp_project

# تثبيت المكتبات
flutter pub get

# توليد الملفات المُنتجة
flutter pub run build_runner build --delete-conflicting-outputs
```

## سير العمل (Workflow)

### 1. إنشاء فرع جديد
```bash
git checkout -b feature/feature-name
```

### 2. تطوير الميزة
- اتبع معايير الكود
- اكتب اختبارات
- وثق التغييرات

### 3. اختبار الكود
```bash
# تحليل الكود
flutter analyze

# تشغيل الاختبارات
flutter test

# تشغيل التطبيق
flutter run
```

### 4. التزام التغييرات
```bash
git add .
git commit -m "feat: add new feature"
git push origin feature/feature-name
```

### 5. فتح طلب دمج (Pull Request)
- اشرح التغييرات
- أرفق لقطات الشاشة إن أمكن
- اطلب المراجعة

## معايير الكود

### قواعس التسمية

| النوع | القاعدة | مثال |
|------|--------|------|
| Classes | PascalCase | `CustomerRepository` |
| Functions | camelCase | `getCustomers()` |
| Variables | camelCase | `customerName` |
| Constants | UPPER_SNAKE_CASE | `MAX_CUSTOMERS` |
| Files | snake_case | `customer_model.dart` |

### تنسيق الكود

```dart
// استخدم const عند الإمكان
const AppBar(title: Text('العملاء'))

// استخدم final للمتغيرات غير المتغيرة
final customer = Customer(...);

// استخدم late للمتغيرات المتأخرة
late final isar = await Isar.open(...);
```

### التعليقات

```dart
/// تعليق على المستوى العام للفئة
/// يشرح الغرض والاستخدام
class Customer {
  /// تعليق على الدالة
  /// يشرح المعاملات والقيمة المرجعة
  Future<void> save() async {
    // تعليق داخلي يشرح الخطوات المعقدة
  }
}
```

### معالجة الأخطاء

```dart
try {
  final result = await repository.getCustomers();
  // معالجة النتيجة
} on RepositoryException catch (e) {
  // معالجة أخطاء المستودع
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('خطأ: ${e.message}')),
  );
} catch (e) {
  // معالجة الأخطاء العامة
  print('خطأ غير متوقع: $e');
}
```

## إضافة ميزة جديدة

### الخطوة 1: إنشاء الـ Entity

```dart
// lib/features/new_feature/domain/entities/new_entity.dart
class NewEntity {
  final String id;
  final String name;
  // ...
}
```

### الخطوة 2: إنشاء الـ Model

```dart
// lib/features/new_feature/data/models/new_entity_model.dart
@collection
class NewEntityModel {
  Id id = Isar.autoIncrement;
  late String entityId;
  late String name;
  // ...
}
```

### الخطوة 3: إنشاء واجهة المستودع

```dart
// lib/features/new_feature/domain/repositories/new_entity_repository.dart
abstract class NewEntityRepository {
  Future<List<NewEntity>> getAll();
  Future<void> add(NewEntity entity);
  // ...
}
```

### الخطوة 4: تطبيق المستودع

```dart
// lib/features/new_feature/data/repositories/new_entity_repository_impl.dart
class NewEntityRepositoryImpl implements NewEntityRepository {
  final Isar isar;
  
  NewEntityRepositoryImpl({required this.isar});
  
  @override
  Future<List<NewEntity>> getAll() async {
    // التطبيق
  }
}
```

### الخطوة 5: إنشاء الشاشة

```dart
// lib/features/new_feature/presentation/screens/new_entity_screen.dart
class NewEntityScreen extends StatefulWidget {
  @override
  State<NewEntityScreen> createState() => _NewEntityScreenState();
}
```

### الخطوة 6: توليد الملفات

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## الاختبار

### اختبارات الوحدة

```dart
// test/features/new_feature/data/repositories/new_entity_repository_impl_test.dart
void main() {
  group('NewEntityRepositoryImpl', () {
    test('getAll should return list of entities', () async {
      // Arrange
      final repository = NewEntityRepositoryImpl(isar: mockIsar);
      
      // Act
      final result = await repository.getAll();
      
      // Assert
      expect(result, isA<List<NewEntity>>());
    });
  });
}
```

### اختبارات الواجهة

```dart
// test/features/new_feature/presentation/screens/new_entity_screen_test.dart
void main() {
  testWidgets('NewEntityScreen displays entities', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    expect(find.byType(NewEntityScreen), findsOneWidget);
  });
}
```

## التصحيح (Debugging)

### استخدام print
```dart
print('Debug: $value');
```

### استخدام debugPrint
```dart
debugPrint('Debug: $value');
```

### استخدام DevTools
```bash
flutter pub global activate devtools
devtools
```

## الأداء

### تحسين الأداء
- استخدم `const` للـ Widgets الثابتة
- استخدم `RepaintBoundary` للـ Widgets المعقدة
- تجنب إعادة البناء غير الضرورية
- استخدم `ListView.builder` بدلاً من `ListView`

### قياس الأداء
```bash
flutter run --profile
```

## التوثيق

### توثيق الدوال
```dart
/// حفظ العميل في قاعدة البيانات
/// 
/// المعاملات:
///   - customer: كائن العميل المراد حفظه
/// 
/// القيمة المرجعة:
///   - Future<void>: مستقبل بدون قيمة
Future<void> saveCustomer(Customer customer) async {
  // التطبيق
}
```

### توثيق الفئات
```dart
/// فئة لإدارة العملاء
/// 
/// توفر عمليات CRUD للعملاء
/// تستخدم Isar لتخزين البيانات محليًا
class CustomerRepository {
  // التطبيق
}
```

## الإصدارات

### نظام الإصدارات
- **Major**: تغييرات كبيرة غير متوافقة
- **Minor**: إضافة ميزات جديدة متوافقة
- **Patch**: إصلاح الأخطاء

مثال: `1.0.0` (Major.Minor.Patch)

### إنشاء إصدار جديد
```bash
# تحديث رقم الإصدار في pubspec.yaml
# تحديث CHANGELOG.md
git tag v1.0.0
git push origin v1.0.0
```

## الموارد

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev)
- [Isar Documentation](https://isar.dev)

## الدعم

للمساعدة أو الأسئلة:
- افتح Issue على GitHub
- تواصل مع الفريق

---

**آخر تحديث**: نوفمبر 2025
