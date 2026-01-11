import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider لـ CustomerRepository (مستورد من core/providers.dart)
///
/// **ملاحظة:** هذا Provider معاد تصديره من core/providers.dart
/// للحفاظ على التوافق مع الكود القديم.

/// Provider لقائمة جميع العملاء
///
/// يسترجع جميع العملاء من المستودع ويوفرها كـ [AsyncValue].
///
/// **الاستخدام:**
/// ```dart
/// final customersAsync = ref.watch(customersProvider,);
/// customersAsync.when(
///   data: (customers) => ListView.builder(...),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('خطأ: $error'),
///,);
/// ```
///
/// **Side Effects:**
/// - يتم تحديثه تلقائيًا عند إضافة/تحديث/حذف عميل
/// - يستخدم [customerRepositoryProvider] للوصول إلى البيانات
///
/// **Returns:** [AsyncValue<List<Customer>>] قائمة العملاء
final customersProvider = FutureProvider<List<Customer>>((ref) async {
  final repository = ref.watch(customerRepositoryProvider);
  return repository.getAllCustomers();
});

/// Provider لإضافة عميل جديد
///
/// يضيف عميل جديد إلى النظام ويحدث قائمة العملاء.
///
/// **الاستخدام:**
/// ```dart
/// final customer = Customer(
///   id: uuid.v4(),
///   name: 'أحمد محمد',
///   phone: '0501234567',
///   createdAt: DateTime.now(),
///   updatedAt: DateTime.now(),
///,);
///
/// final result = await ref.read(addCustomerProvider(customer).future,);
/// if (result) {
///   // تمت الإضافة بنجاح
/// }
/// ```
///
/// **Side Effects:**
/// - يحدث customersProvider تلقائيًا بعد الإضافة
/// - يعيد true عند النجاح، false عند الفشل
///
/// **Parameters:**
/// - customer: بيانات العميل الجديد
///
/// **Returns:** bool true إذا نجحت العملية، false إذا فشلت
final addCustomerProvider = FutureProvider.family<bool, Customer>((
  ref,
  customer,
) async {
  final repository = ref.watch(customerRepositoryProvider);

  try {
    await repository.addCustomer(customer);
    ref.invalidate(customersProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// Provider لتحديث عميل
///
/// يحدث بيانات عميل موجود ويحدث قائمة العملاء.
///
/// **الاستخدام:**
/// ```dart
/// final updatedCustomer = customer.copyWith(
///   phone: '0509876543',
///   updatedAt: DateTime.now(),
///,);
///
/// final result = await ref.read(
///   updateCustomerProvider(updatedCustomer).future,
///,);
/// if (result) {
///   // تم التحديث بنجاح
/// }
/// ```
///
/// **Side Effects:**
/// - يحدث customersProvider تلقائيًا بعد التحديث
/// - يعيد true عند النجاح، false عند الفشل
///
/// **Parameters:**
/// - customer: بيانات العميل المحدثة (يجب أن يحتوي على نفس المعرف)
///
/// **Returns:** bool true إذا نجحت العملية، false إذا فشلت
final updateCustomerProvider = FutureProvider.family<bool, Customer>((
  ref,
  customer,
) async {
  final repository = ref.watch(customerRepositoryProvider);

  try {
    await repository.updateCustomer(customer);
    ref.invalidate(customersProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// Provider لحذف عميل
///
/// يحذف عميل من النظام ويحدث قائمة العملاء.
///
/// **الاستخدام:**
/// ```dart
/// final result = await ref.read(deleteCustomerProvider('customer-1').future,);
/// if (result) {
///   // تم الحذف بنجاح
/// }
/// ```
///
/// **Side Effects:**
/// - يحدث customersProvider تلقائيًا بعد الحذف
/// - يعيد true عند النجاح، false عند الفشل
/// - لا يفعل شيئًا إذا لم يُعثر على العميل
///
/// **Parameters:**
/// - customerId: معرف العميل المراد حذفه
///
/// **Returns:** bool true إذا نجحت العملية، false إذا فشلت
final deleteCustomerProvider = FutureProvider.family<bool, String>((
  ref,
  customerId,
) async {
  final repository = ref.watch(customerRepositoryProvider);

  try {
    await repository.deleteCustomer(customerId);
    ref.invalidate(customersProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// State Provider لحالة البحث
///
/// يحفظ نص البحث الحالي للعملاء.
///
/// **الاستخدام:**
/// ```dart
/// // قراءة نص البحث
/// final searchQuery = ref.watch(customerSearchProvider,);
///
/// // تحديث نص البحث
/// ref.read(customerSearchProvider.notifier).state = 'أحمد';
/// ```
///
/// **القيمة الافتراضية:** سلسلة فارغة ('')
final customerSearchProvider = StateProvider<String>((ref) => '');

/// Provider لقائمة العملاء المفلترة حسب البحث
///
/// يفلتر قائمة العملاء بناءً على نص البحث في [customerSearchProvider].
/// يبحث في الاسم، البريد الإلكتروني، ورقم الهاتف.
///
/// **الاستخدام:**
/// ```dart
/// final filteredAsync = ref.watch(filteredCustomersProvider,);
/// filteredAsync.when(
///   data: (customers) => ListView.builder(
///     itemCount: customers.length,
///     itemBuilder: (context, index) => CustomerCard(customers[index]),
///   ),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('خطأ: $error'),
///,);
/// ```
///
/// **السلوك:**
/// - إذا كان نص البحث فارغًا، يعيد جميع العملاء
/// - يبحث في: الاسم، البريد الإلكتروني، رقم الهاتف
/// - البحث حساس لحالة الأحرف (Case-sensitive)
/// - يتحدث تلقائيًا عند تغيير نص البحث أو قائمة العملاء
///
/// **Dependencies:**
/// - [customerSearchProvider]: نص البحث
/// - [customersProvider]: قائمة جميع العملاء
///
/// **Returns:** [AsyncValue<List<Customer>>] قائمة العملاء المفلترة
final filteredCustomersProvider = Provider<AsyncValue<List<Customer>>>((ref) {
  final searchQuery = ref.watch(customerSearchProvider);
  final customersAsync = ref.watch(customersProvider);

  return customersAsync.whenData((customers) {
    if (searchQuery.isEmpty) {
      return customers;
    }
    return customers
        .where(
          (customer) =>
              customer.nameAr.contains(searchQuery) ||
              customer.nameEn.contains(searchQuery) ||
              (customer.email?.contains(searchQuery) ?? false) ||
              (customer.phone?.contains(searchQuery) ?? false),
        )
        .toList();
  });
});
