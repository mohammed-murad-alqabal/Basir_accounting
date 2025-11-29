/// Mock لـ CustomerRepository
///
/// يوفر هذا الملف mock object لـ CustomerRepository للاستخدام في الاختبارات.
/// يحاكي سلوك repository بدون الحاجة لقاعدة بيانات فعلية.
library;

import 'package:basser_app/features/customers/domain/entities/customer.dart';

/// Mock implementation لـ CustomerRepository
///
/// يستخدم List في الذاكرة لتخزين العملاء بدلاً من قاعدة البيانات الفعلية.
///
/// مثال:
/// ```dart
/// final mockRepo = MockCustomerRepository();
/// final customer = MockData.createTestCustomer();
/// await mockRepo.addCustomer(customer);
/// final customers = await mockRepo.getAllCustomers();
/// expect(customers.length, 1);
/// ```
class MockCustomerRepository {
  /// قائمة العملاء في الذاكرة
  final List<Customer> _customers = [];

  /// الحصول على جميع العملاء
  ///
  /// Returns قائمة بجميع العملاء المخزنين
  Future<List<Customer>> getAllCustomers() async => List.from(_customers);

  /// الحصول على عميل بواسطة المعرف
  ///
  /// [id] معرف العميل
  ///
  /// Returns العميل إذا وُجد، null إذا لم يُوجد
  Future<Customer?> getCustomerById(String id) async {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } on StateError {
      return null;
    }
  }

  /// إضافة عميل جديد
  ///
  /// [customer] العميل المراد إضافته
  ///
  /// Throws Exception إذا كان المعرف موجود مسبقاً
  Future<void> addCustomer(Customer customer) async {
    // التحقق من عدم وجود عميل بنفس المعرف
    final exists = _customers.any((c) => c.id == customer.id);
    if (exists) {
      throw Exception('عميل بنفس المعرف موجود مسبقاً');
    }
    _customers.add(customer);
  }

  /// تحديث بيانات عميل موجود
  ///
  /// [customer] العميل المراد تحديثه
  ///
  /// Throws Exception إذا لم يكن العميل موجوداً
  Future<void> updateCustomer(Customer customer) async {
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index == -1) {
      throw Exception('العميل غير موجود');
    }
    _customers[index] = customer;
  }

  /// حذف عميل
  ///
  /// [id] معرف العميل المراد حذفه
  ///
  /// Throws Exception إذا لم يكن العميل موجوداً
  Future<void> deleteCustomer(String id) async {
    final initialLength = _customers.length;
    _customers.removeWhere((c) => c.id == id);
    if (_customers.length == initialLength) {
      throw Exception('العميل غير موجود');
    }
  }

  /// البحث عن عملاء بالاسم
  ///
  /// [query] نص البحث
  ///
  /// Returns قائمة العملاء الذين يحتوي اسمهم على نص البحث
  Future<List<Customer>> searchCustomers(String query) async => _customers
      .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
      .toList();

  /// تنظيف القائمة (للاستخدام في tearDown)
  void clear() {
    _customers.clear();
  }

  /// الحصول على عدد العملاء
  int get count => _customers.length;

  /// التحقق من أن القائمة فارغة
  bool get isEmpty => _customers.isEmpty;

  /// التحقق من أن القائمة تحتوي على عملاء
  bool get isNotEmpty => _customers.isNotEmpty;
}
