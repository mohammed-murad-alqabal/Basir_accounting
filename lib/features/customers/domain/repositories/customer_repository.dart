import 'package:flutter/foundation.dart';
import 'package:basser_app/features/customers/domain/entities/customer.dart';

/// واجهة مستودع العملاء
///
/// تحدد العقد (Contract) لجميع العمليات المتعلقة بإدارة العملاء
/// في طبقة Domain. التطبيق الفعلي يكون في طبقة Data
///
/// Operations:
/// - CRUD كامل للعملاء
/// - البحث والاستعلام
/// - إدارة البيانات
///
/// Example:
/// ```dart
/// class CustomerRepositoryImpl implements CustomerRepository {
///   @override
///   Future<List<Customer>> getAllCustomers() async {
///     // التطبيق الفعلي
///   }
/// }
/// ```
abstract class CustomerRepository {
  /// الحصول على جميع العملاء
  ///
  /// يسترجع قائمة بجميع العملاء المسجلين في النظام
  ///
  /// Returns: قائمة بجميع العملاء، قائمة فارغة إذا لم يكن هناك عملاء
  ///
  /// Example:
  /// ```dart
  /// final customers = await repository.getAllCustomers();
  /// debugPrint('عدد العملاء: ${customers.length}',);
  /// ```
  Future<List<Customer>> getAllCustomers();

  /// الحصول على عميل بواسطة المعرف
  ///
  /// يبحث عن عميل محدد باستخدام معرفه الفريد
  ///
  /// Parameters:
  /// - [id]: معرف العميل المطلوب
  ///
  /// Returns: العميل إذا وُجد، null إذا لم يُعثر عليه
  ///
  /// Example:
  /// ```dart
  /// final customer = await repository.getCustomerById('customer-1',);
  /// if (customer != null) {
  ///   debugPrint('العميل: ${customer.name}',);
  /// }
  /// ```
  Future<Customer?> getCustomerById(
    String id,
  );

  /// البحث عن عملاء حسب الاسم
  ///
  /// يبحث عن العملاء الذين تحتوي أسماؤهم على النص المحدد
  ///
  /// Parameters:
  /// - [query]: نص البحث
  ///
  /// Returns: قائمة بالعملاء المطابقين، قائمة فارغة إذا لم يُعثر على نتائج
  ///
  /// Example:
  /// ```dart
  /// final results = await repository.searchCustomers('أحمد',);
  /// debugPrint('النتائج: ${results.length}',);
  /// ```
  Future<List<Customer>> searchCustomers(
    String query,
  );

  /// إضافة عميل جديد
  ///
  /// يضيف عميل جديد إلى النظام
  ///
  /// Parameters:
  /// - [customer]: بيانات العميل الجديد
  ///
  /// Throws: [Exception] إذا حدث خطأ في الحفظ
  ///
  /// Example:
  /// ```dart
  /// final customer = Customer(
  ///   id: 'customer-1',
  ///   name: 'أحمد محمد',
  ///   createdAt: DateTime.now(),
  ///   updatedAt: DateTime.now(),
  ///,);
  /// await repository.addCustomer(customer,);
  /// ```
  Future<void> addCustomer(
    Customer customer,
  );

  /// تحديث بيانات عميل
  ///
  /// يحدث بيانات عميل موجود في النظام
  ///
  /// Parameters:
  /// - [customer]: بيانات العميل المحدثة
  ///
  /// Throws: [Exception] إذا حدث خطأ في التحديث
  ///
  /// Example:
  /// ```dart
  /// final updatedCustomer = customer.copyWith(
  ///   phone: '0509876543',
  ///   updatedAt: DateTime.now(),
  ///,);
  /// await repository.updateCustomer(updatedCustomer,);
  /// ```
  Future<void> updateCustomer(
    Customer customer,
  );

  /// حذف عميل
  ///
  /// يحذف عميل من النظام باستخدام معرفه
  ///
  /// Parameters:
  /// - [id]: معرف العميل المراد حذفه
  ///
  /// Throws: [Exception] إذا حدث خطأ في الحذف
  ///
  /// Example:
  /// ```dart
  /// await repository.deleteCustomer('customer-1',);
  /// ```
  Future<void> deleteCustomer(
    String id,
  );

  /// حذف جميع العملاء
  ///
  /// يحذف جميع العملاء من النظام
  ///
  /// Warning: هذه العملية لا يمكن التراجع عنها
  ///
  /// Note: تُستخدم فقط لأغراض الاختبار أو إعادة تعيين النظام
  ///
  /// Example:
  /// ```dart
  /// await repository.deleteAllCustomers();
  /// ```
  Future<void> deleteAllCustomers();
}
