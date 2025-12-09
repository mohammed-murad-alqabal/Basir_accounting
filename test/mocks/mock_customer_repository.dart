/// Mock Customer Repository - محاكاة لمستودع العملاء
///
/// يوفر تطبيق وهمي لـ CustomerRepository للاستخدام في الاختبارات
library;

import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/customers/domain/repositories/customer_repository.dart';

/// Mock implementation لـ CustomerRepository
///
/// يخزن العملاء في List في الذاكرة بدلاً من قاعدة البيانات.
/// مفيد لاختبار Providers والـ Services بدون الاعتماد على قاعدة البيانات.
class MockCustomerRepository implements CustomerRepository {
  /// Constructor مع بيانات اختبارية افتراضية
  MockCustomerRepository({List<Customer>? customers, this.shouldThrow = false})
      : _customers = customers ??
            [
              Customer(
                id: 'test-1',
                name: 'أحمد محمد',
                phone: '0501234567',
                email: 'ahmed@test.com',
                createdAt: DateTime(2024),
                updatedAt: DateTime(2024),
              ),
              Customer(
                id: 'test-2',
                name: 'سارة علي',
                phone: '0509876543',
                email: 'sara@test.com',
                createdAt: DateTime(2024, 1, 2),
                updatedAt: DateTime(2024, 1, 2),
              ),
            ];
  final List<Customer> _customers;

  /// للتحكم في رمي الأخطاء في الاختبارات
  final bool shouldThrow;

  /// للتحكم في رمي الأخطاء (backward compatibility)
  bool shouldThrowError = false;

  /// للتحكم في نتيجة addCustomer
  bool addCustomerResult = true;

  /// للتحكم في نتيجة updateCustomer
  bool updateCustomerResult = true;

  /// تأخير اختياري لمحاكاة عمليات async حقيقية (بالميلي ثانية)
  int delayMilliseconds = 0;

  @override
  Future<List<Customer>> getAllCustomers() async {
    if (delayMilliseconds > 0) {
      await Future<void>.delayed(Duration(milliseconds: delayMilliseconds));
    }
    if (shouldThrow || shouldThrowError) {
      throw Exception('Mock error: Failed to get customers');
    }
    return List.from(_customers);
  }

  @override
  Future<Customer?> getCustomerById(String id) async {
    if (delayMilliseconds > 0) {
      await Future<void>.delayed(Duration(milliseconds: delayMilliseconds));
    }
    try {
      return _customers.firstWhere((c) => c.id == id);
    } on Object {
      // العميل غير موجود أو خطأ آخر
      return null;
    }
  }

  @override
  Future<void> addCustomer(Customer customer) async {
    if (delayMilliseconds > 0) {
      await Future<void>.delayed(Duration(milliseconds: delayMilliseconds));
    }
    if (shouldThrow || shouldThrowError) {
      throw Exception('Mock error: Failed to add customer');
    }
    if (!addCustomerResult) {
      throw Exception('Mock: Add customer failed');
    }
    // التحقق من عدم وجود عميل بنفس الـ ID
    if (_customers.any((c) => c.id == customer.id)) {
      throw Exception('Customer with ID ${customer.id} already exists');
    }
    _customers.add(customer);
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    if (delayMilliseconds > 0) {
      await Future<void>.delayed(Duration(milliseconds: delayMilliseconds));
    }
    if (shouldThrow || shouldThrowError) {
      throw Exception('Mock error: Failed to update customer');
    }
    if (!updateCustomerResult) {
      throw Exception('Mock: Update customer failed');
    }
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index == -1) {
      throw Exception('Customer with ID ${customer.id} not found');
    }
    _customers[index] = customer;
  }

  @override
  Future<void> deleteCustomer(String id) async {
    if (delayMilliseconds > 0) {
      await Future<void>.delayed(Duration(milliseconds: delayMilliseconds));
    }
    if (shouldThrow || shouldThrowError) {
      throw Exception('Mock error: Failed to delete customer');
    }
    _customers.removeWhere((c) => c.id == id);
  }

  @override
  Future<void> deleteAllCustomers() async {
    if (delayMilliseconds > 0) {
      await Future<void>.delayed(Duration(milliseconds: delayMilliseconds));
    }
    _customers.clear();
  }

  @override
  Future<List<Customer>> searchCustomers(String query) async {
    if (delayMilliseconds > 0) {
      await Future<void>.delayed(Duration(milliseconds: delayMilliseconds));
    }
    final lowerQuery = query.toLowerCase();
    return _customers
        .where(
          (c) =>
              c.name.toLowerCase().contains(lowerQuery) ||
              (c.phone?.contains(query) ?? false) ||
              (c.email?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .toList();
  }

  /// دالة مساعدة لإضافة عدة عملاء دفعة واحدة
  Future<void> addAll(List<Customer> customers) async {
    for (final customer in customers) {
      await addCustomer(customer);
    }
  }

  /// دالة مساعدة لتعيين قائمة العملاء مباشرة (للاختبارات)
  void setCustomers(List<Customer> customers) {
    _customers.clear();
    _customers.addAll(customers);
  }

  /// دالة مساعدة لمسح جميع العملاء (للاختبارات)
  void clear() {
    _customers.clear();
  }

  /// دالة مساعدة للحصول على عدد العملاء
  int get count => _customers.length;

  /// دالة مساعدة للتحقق من أن المستودع فارغ
  bool get isEmpty => _customers.isEmpty;
}
