# Implementation Plan - نظام الاختبارات

## نظرة عامة

هذه الخطة تحول متطلبات وتصميم نظام الاختبارات إلى مهام قابلة للتنفيذ. المهام منظمة في 4 مراحل على مدى 4 أسابيع.

---

## المرحلة 1: الأساسيات (أسبوع 1)

### 1. إعداد البنية التحتية للاختبارات

- [ ] 1.1 إنشاء بنية مجلدات test
  - إنشاء `test/helpers/`
  - إنشاء `test/mocks/`
  - إنشاء `test/fixtures/`
  - إنشاء `test/unit/data/models/`
  - إنشاء `test/unit/data/repositories/`
  - إنشاء `test/unit/data/services/`
  - إنشاء `test/widget/core/widgets/`
  - إنشاء `test/widget/features/`
  - _Requirements: 4.1_

- [ ] 1.2 إضافة مكتبات الاختبار إلى pubspec.yaml
  - إضافة `mockito: ^5.4.0`
  - إضافة `build_runner: ^2.4.0` (إذا لم تكن موجودة)
  - تشغيل `flutter pub get`
  - _Requirements: 4.2_

- [ ] 1.3 إنشاء TestHelpers class
  - كتابة `test/helpers/test_helpers.dart`
  - تنفيذ `createTestIsar()` method
  - تنفيذ `cleanupTestIsar()` method
  - تنفيذ `createTestContainer()` method
  - _Requirements: 4.2_

- [ ] 1.4 إنشاء MockData class
  - كتابة `test/helpers/mock_data.dart`
  - تنفيذ `createTestCustomer()` method
  - تنفيذ `createTestInvoice()` method
  - إضافة variants مع parameters مختلفة
  - _Requirements: 4.2_

### 2. إنشاء Mock Objects

- [ ] 2.1 إنشاء MockSecureStorage
  - كتابة `test/mocks/mock_secure_storage.dart`
  - تنفيذ `write()` method
  - تنفيذ `read()` method
  - تنفيذ `delete()` method
  - تنفيذ `deleteAll()` method
  - _Requirements: 2.3, 4.3_

- [ ] 2.2 إنشاء MockCustomerRepository
  - كتابة `test/mocks/mock_customer_repository.dart`
  - تنفيذ `getAllCustomers()` method
  - تنفيذ `addCustomer()` method
  - تنفيذ `updateCustomer()` method
  - تنفيذ `deleteCustomer()` method
  - تنفيذ `getCustomerById()` method
  - _Requirements: 1.3, 4.3_

- [ ] 2.3 إنشاء MockInvoiceRepository
  - كتابة `test/mocks/mock_invoice_repository.dart`
  - تنفيذ `getAllInvoices()` method
  - تنفيذ `addInvoice()` method
  - تنفيذ `updateInvoice()` method
  - تنفيذ `deleteInvoice()` method
  - تنفيذ `getInvoiceById()` method
  - _Requirements: 1.3, 4.3_

### 3. إنشاء Fixtures

- [ ] 3.1 إنشاء CustomerFixtures
  - كتابة `test/fixtures/customer_fixtures.dart`
  - إنشاء 3-5 عملاء نموذجيين
  - إضافة `allCustomers` getter
  - _Requirements: 4.4_

- [ ] 3.2 إنشاء InvoiceFixtures
  - كتابة `test/fixtures/invoice_fixtures.dart`
  - إنشاء 3-5 فواتير نموذجية
  - إضافة `allInvoices` getter
  - ربط الفواتير بالعملاء من CustomerFixtures
  - _Requirements: 4.4_

### 4. اختبارات Models

- [ ] 4.1 اختبار Customer model
  - كتابة `test/unit/data/models/customer_model_test.dart`
  - اختبار `toJson()` method
  - اختبار `fromJson()` method
  - اختبار validation rules
  - اختبار edge cases (empty strings, null values)
  - _Requirements: 7.1, 7.3_

- [ ] 4.2 اختبار Invoice model
  - كتابة `test/unit/data/models/invoice_model_test.dart`
  - اختبار `toJson()` method
  - اختبار `fromJson()` method
  - اختبار computed properties (subtotal, taxAmount, grandTotal)
  - اختبار validation rules
  - _Requirements: 7.2, 7.4_

### 5. اختبارات Repositories

- [ ] 5.1 اختبار CustomerRepository - CRUD operations
  - كتابة `test/unit/data/repositories/customer_repository_test.dart`
  - اختبار `addCustomer()` - إضافة عميل جديد
  - اختبار `getAllCustomers()` - استرجاع جميع العملاء
  - اختبار `getCustomerById()` - استرجاع عميل محدد
  - اختبار `updateCustomer()` - تحديث بيانات عميل
  - اختبار `deleteCustomer()` - حذف عميل
  - _Requirements: 1.1, 1.2_

- [ ] 5.2 اختبار CustomerRepository - Error handling
  - اختبار إضافة عميل بـ ID مكرر
  - اختبار استرجاع عميل غير موجود
  - اختبار تحديث عميل غير موجود
  - اختبار حذف عميل غير موجود
  - _Requirements: 1.3_

- [ ] 5.3 اختبار InvoiceRepository - CRUD operations
  - كتابة `test/unit/data/repositories/invoice_repository_test.dart`
  - اختبار `addInvoice()` - إضافة فاتورة جديدة
  - اختبار `getAllInvoices()` - استرجاع جميع الفواتير
  - اختبار `getInvoiceById()` - استرجاع فاتورة محددة
  - اختبار `updateInvoice()` - تحديث بيانات فاتورة
  - اختبار `deleteInvoice()` - حذف فاتورة
  - _Requirements: 1.1, 1.2_

- [ ] 5.4 اختبار InvoiceRepository - Error handling
  - اختبار إضافة فاتورة بـ ID مكرر
  - اختبار استرجاع فاتورة غير موجودة
  - اختبار تحديث فاتورة غير موجودة
  - اختبار حذف فاتورة غير موجودة
  - _Requirements: 1.3_

- [ ] 5.5 Checkpoint - التحقق من نجاح المرحلة 1
  - تشغيل جميع الاختبارات: `flutter test`
  - التحقق من نجاح جميع الاختبارات
  - مراجعة تقرير التغطية
  - إصلاح أي مشاكل قبل المتابعة

---

## المرحلة 2: منطق الأعمال (أسبوع 2)

### 6. اختبارات Services

- [ ] 6.1 اختبار AuthService - Registration
  - كتابة `test/unit/data/services/auth_service_test.dart`
  - اختبار `register()` - تسجيل مستخدم جديد
  - اختبار `hasAccount()` - التحقق من وجود حساب
  - اختبار تسجيل مستخدم موجود (should fail)
  - اختبار تسجيل ببيانات غير صحيحة
  - _Requirements: 2.1_

- [ ] 6.2 اختبار AuthService - Login/Logout
  - اختبار `login()` - تسجيل دخول ناجح
  - اختبار `login()` - تسجيل دخول ببيانات خاطئة
  - اختبار `isLoggedIn()` - التحقق من حالة الدخول
  - اختبار `logout()` - تسجيل خروج
  - اختبار `logout()` عندما لا يوجد مستخدم مسجل
  - _Requirements: 2.1_

- [ ] 6.3 اختبار SettingsService
  - كتابة `test/unit/services/settings_service_test.dart`
  - اختبار `saveCompanySettings()` - حفظ إعدادات الشركة
  - اختبار `getCompanySettings()` - استرجاع إعدادات الشركة
  - اختبار `saveTaxRate()` - حفظ نسبة الضريبة
  - اختبار `getTaxRate()` - استرجاع نسبة الضريبة
  - _Requirements: 2.2_

- [ ] 6.4 اختبار PDFService
  - كتابة `test/unit/data/services/pdf_service_test.dart`
  - اختبار `generateInvoicePDF()` - توليد PDF للفاتورة
  - التحقق من احتواء PDF على بيانات الفاتورة
  - اختبار معالجة الأخطاء عند فشل التوليد
  - _Requirements: 9.1, 9.4_

### 7. اختبارات Providers

- [ ] 7.1 اختبار CustomerProvider - Loading
  - كتابة `test/unit/presentation/providers/customer_provider_test.dart`
  - اختبار تحميل قائمة العملاء
  - اختبار حالة loading
  - اختبار حالة error
  - اختبار حالة success
  - _Requirements: 6.1, 6.3_

- [ ] 7.2 اختبار CustomerProvider - CRUD operations
  - اختبار إضافة عميل جديد
  - اختبار تحديث عميل موجود
  - اختبار حذف عميل
  - التحقق من تحديث الحالة بعد كل عملية
  - التحقق من إشعار المستمعين
  - _Requirements: 6.1, 6.4_

- [ ] 7.3 اختبار InvoiceProvider - Loading
  - كتابة `test/unit/presentation/providers/invoice_provider_test.dart`
  - اختبار تحميل قائمة الفواتير
  - اختبار حالة loading
  - اختبار حالة error
  - اختبار حالة success
  - _Requirements: 6.2, 6.3_

- [ ] 7.4 اختبار InvoiceProvider - CRUD operations
  - اختبار إضافة فاتورة جديدة
  - اختبار تحديث فاتورة موجودة
  - اختبار حذف فاتورة
  - التحقق من تحديث الحالة بعد كل عملية
  - التحقق من إشعار المستمعين
  - _Requirements: 6.2, 6.4_

- [ ] 7.5 Checkpoint - التحقق من نجاح المرحلة 2
  - تشغيل جميع الاختبارات: `flutter test`
  - التحقق من نجاح جميع الاختبارات
  - مراجعة تقرير التغطية (يجب أن تكون > 50%)
  - إصلاح أي مشاكل قبل المتابعة

---

## المرحلة 3: الواجهات (أسبوع 3)

### 8. اختبارات Core Widgets

- [ ] 8.1 اختبار AppButton
  - كتابة `test/widget/core/widgets/app_button_test.dart`
  - اختبار عرض النص بشكل صحيح
  - اختبار استدعاء `onPressed` عند الضغط
  - اختبار حالة disabled
  - اختبار الأنماط المختلفة (primary, secondary)
  - _Requirements: 3.2_

- [ ] 8.2 اختبار AppCard
  - كتابة `test/widget/core/widgets/app_card_test.dart`
  - اختبار عرض المحتوى بشكل صحيح
  - اختبار استدعاء `onTap` عند الضغط
  - اختبار استدعاء `onLongPress` عند الضغط الطويل
  - اختبار عرض leading و trailing widgets
  - _Requirements: 3.1_

- [ ] 8.3 اختبار AppTextField
  - كتابة `test/widget/core/widgets/app_text_field_test.dart`
  - اختبار إدخال النص
  - اختبار validation rules
  - اختبار عرض رسائل الخطأ
  - اختبار حالة disabled
  - _Requirements: 3.3_

- [ ] 8.4 اختبار AppAppBar
  - كتابة `test/widget/core/widgets/app_app_bar_test.dart`
  - اختبار عرض العنوان
  - اختبار عرض actions
  - اختبار زر الرجوع
  - _Requirements: 3.4_

### 9. اختبارات Screens

- [ ] 9.1 اختبار CustomersScreen - Display
  - كتابة `test/widget/features/customers/customers_screen_test.dart`
  - اختبار عرض قائمة العملاء
  - اختبار عرض حالة loading
  - اختبار عرض حالة empty
  - اختبار عرض حالة error
  - _Requirements: 8.1_

- [ ] 9.2 اختبار CustomersScreen - Interactions
  - اختبار الضغط على عميل (navigation)
  - اختبار زر إضافة عميل جديد
  - اختبار البحث عن عميل
  - اختبار حذف عميل (long press)
  - _Requirements: 8.1, 8.4_

- [ ] 9.3 اختبار InvoicesScreen - Display
  - كتابة `test/widget/features/invoices/invoices_screen_test.dart`
  - اختبار عرض قائمة الفواتير
  - اختبار عرض حالة loading
  - اختبار عرض حالة empty
  - اختبار عرض حالة error
  - _Requirements: 8.2_

- [ ] 9.4 اختبار InvoicesScreen - Interactions
  - اختبار الضغط على فاتورة (navigation)
  - اختبار زر إنشاء فاتورة جديدة
  - اختبار التصفية حسب الحالة
  - اختبار حذف فاتورة (long press)
  - _Requirements: 8.2, 8.4_

- [ ] 9.5 اختبار DashboardScreen
  - كتابة `test/widget/features/dashboard/dashboard_screen_test.dart`
  - اختبار عرض بطاقات الإحصائيات
  - اختبار عرض الأرقام بشكل صحيح
  - اختبار الإجراءات السريعة
  - اختبار navigation إلى الشاشات الأخرى
  - _Requirements: 8.3_

- [ ] 9.6 Checkpoint - التحقق من نجاح المرحلة 3
  - تشغيل جميع الاختبارات: `flutter test`
  - التحقق من نجاح جميع الاختبارات
  - مراجعة تقرير التغطية (يجب أن تكون > 65%)
  - إصلاح أي مشاكل قبل المتابعة

---

## المرحلة 4: التكامل والتقارير (أسبوع 4)

### 10. إعداد التشغيل والتقارير

- [ ] 10.1 إنشاء script لتشغيل الاختبارات
  - إنشاء `test/run_tests.sh`
  - إضافة أمر تشغيل جميع الاختبارات
  - إضافة أمر توليد تقرير التغطية
  - إضافة أمر فتح تقرير التغطية في المتصفح
  - _Requirements: 5.1_

- [ ] 10.2 إعداد تقرير التغطية
  - تشغيل `flutter test --coverage`
  - توليد HTML report: `genhtml coverage/lcov.info -o coverage/html`
  - التحقق من نسبة التغطية الإجمالية
  - تحديد الملفات التي تحتاج تغطية أكثر
  - _Requirements: 5.3, 5.4_

- [ ] 10.3 تحسين التغطية
  - إضافة اختبارات للملفات ذات التغطية المنخفضة
  - التركيز على الوصول إلى 70%+ تغطية
  - مراجعة وإصلاح الاختبارات الفاشلة
  - _Requirements: 5.3_

### 11. اختبارات الخدمات الإضافية

- [ ] 11.1 اختبار Router
  - كتابة `test/unit/core/router_test.dart`
  - اختبار التوجيه إلى الشاشات المختلفة
  - اختبار معالجة routes غير موجودة
  - اختبار passing parameters بين الشاشات
  - _Requirements: 9.2_

- [ ] 11.2 اختبار معالجة الأخطاء في PDFService
  - اختبار فشل توليد PDF
  - اختبار معالجة بيانات فاتورة غير صحيحة
  - اختبار عرض رسائل خطأ مناسبة
  - _Requirements: 9.3_

### 12. إعداد CI/CD

- [ ] 12.1 إنشاء GitHub Actions workflow
  - إنشاء `.github/workflows/tests.yml`
  - إضافة خطوة تثبيت Flutter
  - إضافة خطوة تثبيت dependencies
  - إضافة خطوة تشغيل الاختبارات
  - إضافة خطوة التحقق من التغطية (≥ 70%)
  - إضافة خطوة رفع تقرير التغطية
  - _Requirements: 5.1, 5.3_

- [ ] 12.2 اختبار CI/CD workflow
  - عمل commit و push
  - التحقق من تشغيل workflow بنجاح
  - مراجعة logs
  - إصلاح أي مشاكل

### 13. التوثيق النهائي

- [ ] 13.1 تحديث README.md
  - إضافة قسم "Running Tests"
  - إضافة أوامر الاختبار
  - إضافة badge للتغطية
  - إضافة badge لحالة CI/CD

- [ ] 13.2 إنشاء TESTING.md
  - توثيق بنية الاختبارات
  - توثيق كيفية كتابة اختبارات جديدة
  - توثيق best practices
  - إضافة أمثلة

- [ ] 13.3 Final Checkpoint - التحقق النهائي
  - تشغيل جميع الاختبارات: `flutter test`
  - التحقق من نجاح 100% من الاختبارات
  - التحقق من التغطية ≥ 70%
  - التحقق من عمل CI/CD
  - مراجعة التوثيق

---

## ملخص المهام

### الإحصائيات

- **إجمالي المهام:** 13 مهمة رئيسية
- **إجمالي المهام الفرعية:** 70+ مهمة فرعية
- **المدة المتوقعة:** 4 أسابيع
- **التغطية المستهدفة:** ≥ 70%

### توزيع المهام حسب المرحلة

| المرحلة | المهام | المدة |
|---------|--------|-------|
| المرحلة 1 | 5 مهام (25 مهمة فرعية) | أسبوع 1 |
| المرحلة 2 | 2 مهام (15 مهمة فرعية) | أسبوع 2 |
| المرحلة 3 | 2 مهام (18 مهمة فرعية) | أسبوع 3 |
| المرحلة 4 | 4 مهام (12 مهمة فرعية) | أسبوع 4 |

### Checkpoints

- ✅ نهاية المرحلة 1: تغطية الأساسيات
- ✅ نهاية المرحلة 2: تغطية > 50%
- ✅ نهاية المرحلة 3: تغطية > 65%
- ✅ نهاية المرحلة 4: تغطية ≥ 70%

---

**تاريخ الإنشاء:** 24 نوفمبر 2025  
**الحالة:** جاهز للتنفيذ
