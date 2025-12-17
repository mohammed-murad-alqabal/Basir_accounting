# معايير المشروع - بصير MVP

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 16 ديسمبر 2025  
**الحالة:** ✅ نشط ومكثف

---

## 🎯 المبادئ الأساسية

### **Local-First Architecture**

- **دائماً محلي أولاً**: جميع الوظائف الأساسية تعمل بدون إنترنت
- **الشبكة اختيارية**: الاتصال تحسين وليس متطلب
- **Isar Database**: قاعدة البيانات المحلية الوحيدة
- **مزامنة خلفية**: عند توفر الاتصال

### **نمط البيانات المحلية**

```dart
class DataService {
  Future<List<Invoice>> getInvoices() async {
    // 1. البيانات المحلية أولاً
    final localData = await _localRepository.getAll();

    // 2. مزامنة خلفية
    if (await _connectivity.isConnected()) {
      _backgroundSync();
    }

    return localData;
  }
}
```

---

## 📋 معايير بصير المحددة

### **إدارة الفواتير**

```dart
class InvoiceService {
  // دورة حياة الفاتورة: مسودة -> مرسلة -> مدفوعة -> مؤرشفة
  Future<void> updateInvoiceStatus(String id, InvoiceStatus status) async {
    final invoice = await _repository.getById(id);

    if (!_isValidTransition(invoice.status, status)) {
      throw InvalidStateTransitionException();
    }

    await _repository.update(invoice.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    ));
  }
}
```

### **إدارة العملاء**

```dart
class CustomerService {
  Future<void> addCustomer(Customer customer) async {
    _validateArabicName(customer.name);
    _validateSaudiPhone(customer.phone);
    await _repository.save(customer);
  }

  void _validateArabicName(String name) {
    if (!RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(name)) {
      throw ValidationException('الاسم يجب أن يكون باللغة العربية');
    }
  }

  void _validateSaudiPhone(String phone) {
    if (!RegExp(r'^05\d{8}$').hasMatch(phone)) {
      throw ValidationException('رقم الهاتف يجب أن يبدأ بـ 05 ويتكون من 10 أرقام');
    }
  }
}
```

### **دعم العربية الأساسي**

- **RTL Layout**: جميع المكونات تدعم التخطيط من اليمين لليسار
- **الخطوط العربية**: استخدام خطوط النظام المناسبة
- **تنسيق الأرقام**: دعم الأرقام العربية (٠١٢٣) والغربية (0123)
- **التحقق من المدخلات**: التحقق الصحيح من النصوص العربية

---

## 🏗️ معايير الجودة

### **معايير Flutter الأساسية**

- اتباع `effective_dart` بدقة
- استخدام `const` constructors للـ widgets الثابتة
- تنفيذ `dispose()` للـ controllers
- استخدام `late` بشكل صحيح
- Clean Architecture (3 طبقات)

### **تسمية المتغيرات**

```dart
// ✅ جيد: أسماء إنجليزية للكود، عربية للواجهة
class CustomerRepository {
  Future<List<Customer>> getAllCustomers() async { }
}

// نصوص الواجهة بالعربية
const String addCustomerTitle = 'إضافة عميل جديد';
const String customerNameLabel = 'اسم العميل';
```

### **معالجة الأخطاء**

```dart
class ErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    // تسجيل محلي
    _localLogger.error(error, stackTrace);

    // رسالة عربية للمستخدم
    final message = _getArabicErrorMessage(error);
    _showErrorDialog(message);

    // طابور للتسجيل عند الاتصال
    _errorQueue.add(ErrorReport(error, stackTrace));
  }

  static String _getArabicErrorMessage(Object error) {
    switch (error.runtimeType) {
      case NetworkException:
        return 'لا يوجد اتصال بالإنترنت';
      case ValidationException:
        return 'البيانات المدخلة غير صحيحة';
      case DatabaseException:
        return 'حدث خطأ في حفظ البيانات';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
```

---

## 🧪 معايير الاختبارات

### **اختبارات التطبيقات المحلية**

- **اختبار بدون إنترنت**: جميع الوظائف تعمل offline
- **اختبار استمرارية البيانات**: البيانات تبقى بعد إعادة التشغيل
- **اختبار المدخلات العربية**: النصوص العربية والعرض
- **اختبار RTL**: الواجهة من اليمين لليسار
- **اختبار الأداء**: مع مجموعات بيانات كبيرة

### **متطلبات التغطية**

- **Unit Tests**: 70%+ للمنطق التجاري
- **Widget Tests**: جميع الـ widgets المخصصة
- **Integration Tests**: المسارات الحرجة (إنشاء فاتورة، إضافة عميل)
- **Golden Tests**: اتساق الواجهة عبر أحجام الشاشات

### **مثال على هيكل الاختبار**

```dart
void main() {
  group('Invoice Management', () {
    testWidgets('should create invoice offline', (tester) async {
      await tester.pumpWidget(MyApp(isOffline: true));
      await tester.tap(find.byKey(Key('add_invoice_button')));
      await tester.pumpAndSettle();
      expect(find.text('تم حفظ الفاتورة'), findsOneWidget);
    });

    testWidgets('should display Arabic text correctly', (tester) async {
      await tester.pumpWidget(MyApp(locale: Locale('ar')));
      expect(find.text('إضافة فاتورة جديدة'), findsOneWidget);

      final textWidget = tester.widget<Text>(find.text('إضافة فاتورة جديدة'));
      expect(textWidget.textDirection, TextDirection.rtl);
    });
  });
}
```

---

## 📚 معايير التوثيق

### **متطلبات التوثيق العربي**

- **نصوص الواجهة**: جميع نصوص الواجهة بالعربية
- **رسائل الخطأ**: جميع رسائل الخطأ بالعربية
- **أدلة المساعدة**: أدلة المستخدم بالعربية
- **تعليقات الكود**: التعليقات التقنية بالإنجليزية، قصص المستخدم بالعربية

### **توثيق API**

```dart
/// إدارة الفواتير في التطبيق
///
/// يوفر هذا الكلاس جميع العمليات المطلوبة لإدارة الفواتير
class InvoiceManager {
  /// ينشئ فاتورة جديدة
  ///
  /// [customer] العميل المرتبط بالفاتورة
  /// [items] قائمة البنود في الفاتورة
  ///
  /// Returns معرف الفاتورة الجديدة
  /// Throws [ValidationException] إذا كانت البيانات غير صحيحة
  Future<String> createInvoice(Customer customer, List<InvoiceItem> items) async {
    // Implementation
  }
}
```

---

## 🔒 الأمان والخصوصية

### **أمان البيانات المحلية**

- **تشفير البيانات**: تشفير البيانات الحساسة في قاعدة البيانات المحلية
- **التخزين الآمن**: استخدام `flutter_secure_storage` للبيانات الحساسة
- **تنظيف المدخلات**: تنظيف جميع مدخلات المستخدم قبل التخزين
- **التحكم في الوصول**: تطبيق ضوابط الوصول على مستوى التطبيق

### **اعتبارات الخصوصية**

```dart
class PrivacyManager {
  // لا تغادر البيانات الشخصية الجهاز بدون موافقة صريحة
  Future<void> exportData() async {
    final consent = await _getUserConsent();
    if (!consent) return;

    final anonymizedData = await _anonymizeData();
    await _exportToFile(anonymizedData);
  }

  // مسح جميع البيانات عند الطلب
  Future<void> clearAllData() async {
    await _localDatabase.clear();
    await _secureStorage.deleteAll();
    await _preferences.clear();
  }
}
```

---

## 📱 النشر والإصدار

### **نشر التطبيق المحمول**

- **تحسين متجر التطبيقات**: تحسين للمتاجر العربية
- **الترجمة**: دعم العربية والإنجليزية
- **الاختبار**: اختبار على أجهزة Android متنوعة
- **الأداء**: ضمان أداء سلس على الأجهزة متوسطة المواصفات

### **إدارة الإصدارات**

```yaml
# pubspec.yaml version management
version: 1.0.0+1
# Format: major.minor.patch+build
```

---

## 🔗 المراجع المتقدمة

### **للتفاصيل الشاملة:**

- [معايير المشروع المتقدمة](../../reference/advanced-project-standards.md)

### **المعايير التقنية:**

- [معايير Flutter/Dart](./frontend-standards.md)
- [معايير التطوير](./development-standards.md)
- [أفضل ممارسات الأمان](./security-best-practices.md)

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ ملف توجيه مكثف ومحسن  
**المراجعة القادمة:** 23 ديسمبر 2025
