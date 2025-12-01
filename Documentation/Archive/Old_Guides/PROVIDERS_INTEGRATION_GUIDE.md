# دليل تكامل Riverpod Providers

## نظرة عامة
هذا الدليل يوضح كيفية استخدام Riverpod Providers في واجهات المستخدم للتطبيق.

## 1. استخدام Auth Providers في Setup Screen

```dart
// استخدام setupProvider
final setupAsyncValue = ref.watch(setupProvider((username, password)));

setupAsyncValue.when(
  data: (success) {
    if (success) {
      // الانتقال إلى الشاشة التالية
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  },
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('خطأ: $err'),
);
```

## 2. استخدام Customer Providers في Customers Screen

```dart
// عرض قائمة العملاء المفلترة
final filteredCustomers = ref.watch(filteredCustomersProvider);

filteredCustomers.when(
  data: (customers) => ListView.builder(
    itemCount: customers.length,
    itemBuilder: (context, index) => CustomerTile(customers[index]),
  ),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('خطأ: $err'),
);
```

## 3. استخدام Invoice Providers في Invoices Screen

```dart
// عرض قائمة الفواتير المفلترة
final filteredInvoices = ref.watch(filteredInvoicesProvider);

filteredInvoices.when(
  data: (invoices) => ListView.builder(
    itemCount: invoices.length,
    itemBuilder: (context, index) => InvoiceTile(invoices[index]),
  ),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('خطأ: $err'),
);
```

## 4. استخدام Dashboard Providers في Dashboard Screen

```dart
// عرض إجمالي المبيعات
final totalSales = ref.watch(totalSalesProvider);

totalSales.when(
  data: (total) => Text('إجمالي المبيعات: $total ر.س'),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('خطأ: $err'),
);
```

## الخطوات التالية
- تحديث جميع الواجهات لاستخدام Providers
- اختبار جميع الوظائف
- إضافة معالجة الأخطاء
