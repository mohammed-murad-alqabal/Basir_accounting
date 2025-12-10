# Test Mocks - Mock Objects للاختبارات

هذا المجلد يحتوي على mock objects لتسهيل كتابة الاختبارات في تطبيق بصير.

## الملفات

### mock_secure_storage.dart

Mock لـ FlutterSecureStorage:

- `write()` - كتابة قيمة
- `read()` - قراءة قيمة
- `readAll()` - قراءة جميع القيم
- `delete()` - حذف قيمة
- `deleteAll()` - حذف جميع القيم
- `containsKey()` - التحقق من وجود مفتاح
- `clear()` - تنظيف التخزين

### mock_customer_repository.dart

Mock لـ CustomerRepository:

- `getAllCustomers()` - الحصول على جميع العملاء
- `getCustomerById()` - الحصول على عميل بالمعرف
- `addCustomer()` - إضافة عميل
- `updateCustomer()` - تحديث عميل
- `deleteCustomer()` - حذف عميل
- `searchCustomers()` - البحث عن عملاء
- `clear()` - تنظيف القائمة

### mock_invoice_repository.dart

Mock لـ InvoiceRepository:

- `getAllInvoices()` - الحصول على جميع الفواتير
- `getInvoiceById()` - الحصول على فاتورة بالمعرف
- `getInvoicesByCustomerId()` - الحصول على فواتير عميل
- `getInvoicesByStatus()` - الحصول على فواتير بحالة معينة
- `addInvoice()` - إضافة فاتورة
- `updateInvoice()` - تحديث فاتورة
- `deleteInvoice()` - حذف فاتورة
- `getTotalAmount()` - حساب إجمالي الفواتير
- `getPaidAmount()` - حساب إجمالي الفواتير المدفوعة
- `getUnpaidAmount()` - حساب إجمالي الفواتير المعلقة
- `clear()` - تنظيف القائمة

## الاستخدام

```dart
import 'package:flutter_test/flutter_test.dart';
import '../mocks/mock_customer_repository.dart';
import '../helpers/mock_data.dart';

void main() {
  group('مثال على استخدام Mock Repository', () {
    late MockCustomerRepository mockRepo;

    setUp(() {
      mockRepo = MockCustomerRepository();
    });

    tearDown(() {
      mockRepo.clear();
    });

    test('should add customer successfully', () async {
      final customer = MockData.createTestCustomer();
      await mockRepo.addCustomer(customer);

      final customers = await mockRepo.getAllCustomers();
      expect(customers.length, 1);
      expect(customers.first.name, customer.name);
    });
  });
}
```

---

**تم إنشاؤه بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 29 نوفمبر 2025
