/// Customer Fixtures - بيانات عملاء ثابتة للاختبار
///
/// يوفر مجموعة من العملاء النموذجيين للاستخدام في الاختبارات
library;

import 'package:basser_app/features/customers/domain/entities/customer.dart';

/// بيانات عملاء ثابتة للاختبار
class CustomerFixtures {
  /// عميل 1: أحمد محمد - عميل كامل البيانات
  static final customer1 = Customer(
    id: 'customer-1',
    name: 'أحمد محمد',
    phone: '0501234567',
    email: 'ahmed@example.com',
    address: 'الرياض، حي النخيل، شارع الملك فهد',
    createdAt: DateTime(2025),
    updatedAt: DateTime(2025),
  );

  /// عميل 2: فاطمة علي - عميل بدون عنوان
  static final customer2 = Customer(
    id: 'customer-2',
    name: 'فاطمة علي',
    phone: '0507654321',
    email: 'fatima@example.com',
    createdAt: DateTime(2025, 1, 2),
    updatedAt: DateTime(2025, 1, 2),
  );

  /// عميل 3: خالد عبدالله - عميل بدون بريد إلكتروني
  static final customer3 = Customer(
    id: 'customer-3',
    name: 'خالد عبدالله',
    phone: '0509876543',
    address: 'جدة، حي الحمراء',
    createdAt: DateTime(2025, 1, 3),
    updatedAt: DateTime(2025, 1, 3),
  );

  /// عميل 4: نورة سعيد - عميل بالحد الأدنى من البيانات
  static final customer4 = Customer(
    id: 'customer-4',
    name: 'نورة سعيد',
    phone: '0505555555',
    createdAt: DateTime(2025, 1, 4),
    updatedAt: DateTime(2025, 1, 4),
  );

  /// عميل 5: محمد الأحمد
  static final customer5 = Customer(
    id: 'customer-5',
    name: 'محمد الأحمد',
    phone: '0501111111',
    email: 'mohammed@example.com',
    address: 'الدمام، حي الفيصلية',
    createdAt: DateTime(2025, 1, 5),
    updatedAt: DateTime(2025, 1, 5),
  );

  /// عميل 6: سارة خالد - عميل بعنوان طويل
  static final customer6 = Customer(
    id: 'customer-6',
    name: 'سارة خالد',
    phone: '0502222222',
    email: 'sara@example.com',
    address: 'مكة المكرمة، حي العزيزية، شارع الحج، مبنى رقم 123، الطابق الثاني',
    createdAt: DateTime(2025, 1, 6),
    updatedAt: DateTime(2025, 1, 6),
  );

  /// عميل 7: عبدالرحمن يوسف - عميل باسم طويل
  static final customer7 = Customer(
    id: 'customer-7',
    name: 'عبدالرحمن بن يوسف بن عبدالله آل سعود',
    phone: '0503333333',
    email: 'abdulrahman@example.com',
    address: 'الطائف',
    createdAt: DateTime(2025, 1, 7),
    updatedAt: DateTime(2025, 1, 7),
  );

  /// قائمة بجميع العملاء
  static List<Customer> get allCustomers => [
    customer1,
    customer2,
    customer3,
    customer4,
    customer5,
    customer6,
    customer7,
  ];

  /// قائمة بالعملاء الذين لديهم بريد إلكتروني
  static List<Customer> get customersWithEmail => [
    customer1,
    customer2,
    customer5,
    customer6,
    customer7,
  ];

  /// قائمة بالعملاء الذين لديهم عنوان
  static List<Customer> get customersWithAddress => [
    customer1,
    customer3,
    customer5,
    customer6,
    customer7,
  ];

  /// قائمة بالعملاء بالحد الأدنى من البيانات
  static List<Customer> get minimalCustomers => [customer4];

  /// إنشاء عميل مخصص بناءً على index
  static Customer createCustomer(int index) => Customer(
    id: 'customer-$index',
    name: 'عميل رقم $index',
    phone: '050${1000000 + index}',
    email: 'customer$index@example.com',
    address: 'عنوان العميل رقم $index',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  /// إنشاء قائمة من العملاء المخصصين
  static List<Customer> createCustomers(int count) =>
      List.generate(count, createCustomer);
}
