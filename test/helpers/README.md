# Test Helpers - دوال مساعدة للاختبارات

هذا المجلد يحتوي على دوال مساعدة لتسهيل كتابة الاختبارات في تطبيق بصير.

## الملفات

### test_helpers.dart

يحتوي على دوال مساعدة عامة للاختبارات:

- `createTestIsar()` - إنشاء قاعدة بيانات Isar للاختبار
- `cleanupTestIsar()` - تنظيف قاعدة البيانات بعد الاختبار
- `createTestContainer()` - إنشاء ProviderContainer للاختبار
- `cleanupTestContainer()` - تنظيف ProviderContainer

### mock_data.dart

يحتوي على دوال لإنشاء بيانات اختبار جاهزة:

- `createTestCustomer()` - إنشاء عميل اختبار
- `createTestInvoice()` - إنشاء فاتورة اختبار
- `createTestInvoiceItem()` - إنشاء بند فاتورة اختبار
- `createTestCustomers()` - إنشاء قائمة عملاء
- `createTestInvoices()` - إنشاء قائمة فواتير

### test_utils.dart

يحتوي على أدوات مساعدة إضافية:

- `wrapWithMaterialApp()` - تغليف widget في MaterialApp
- `pumpAndSettle()` - الانتظار حتى تكتمل animations
- `findByText()` - البحث عن widget بالنص
- `findByType()` - البحث عن widget بالنوع
- `tap()` - الضغط على widget
- `enterText()` - إدخال نص في TextField

## الاستخدام

```dart
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';
import '../helpers/mock_data.dart';
import '../helpers/test_utils.dart';

void main() {
  group('مثال على الاستخدام', () {
    late Isar isar;

    setUp(() async {
      isar = await TestHelpers.createTestIsar();
    });

    tearDown(() async {
      await TestHelpers.cleanupTestIsar(isar);
    });

    test('should create test customer', () {
      final customer = MockData.createTestCustomer();
      expect(customer.name, 'عميل اختبار');
    });
  });
}
```

---

**تم إنشاؤه بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 29 نوفمبر 2025
