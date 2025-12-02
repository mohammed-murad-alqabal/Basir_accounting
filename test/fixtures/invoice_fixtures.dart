/// Invoice Fixtures - بيانات فواتير ثابتة للاختبار
///
/// يوفر مجموعة من الفواتير النموذجية للاستخدام في الاختبارات
library;

import 'package:basser_app/features/invoices/domain/entities/invoice.dart';

import 'customer_fixtures.dart';

/// بيانات فواتير ثابتة للاختبار
class InvoiceFixtures {
  /// فاتورة 1: فاتورة مسودة بسيطة
  static final invoice1 = Invoice(
    id: 'invoice-1',
    customerId: CustomerFixtures.customer1.id,
    customerName: CustomerFixtures.customer1.name,
    issuedDate: DateTime(2025, 11),
    dueDate: DateTime(2025, 12),
    status: 'draft',
    items: const [
      InvoiceItem(
        id: 'item-1',
        name: 'خدمة استشارية',
        quantity: 1,
        price: 1000,
      ),
    ],
    taxRate: 0.15,
    createdAt: DateTime(2025, 11),
    updatedAt: DateTime(2025, 11),
  );

  /// فاتورة 2: فاتورة مرسلة مع عدة بنود
  static final invoice2 = Invoice(
    id: 'invoice-2',
    customerId: CustomerFixtures.customer2.id,
    customerName: CustomerFixtures.customer2.name,
    issuedDate: DateTime(2025, 11, 5),
    dueDate: DateTime(2025, 12, 5),
    status: 'issued',
    items: const [
      InvoiceItem(
        id: 'item-2-1',
        name: 'منتج أ',
        quantity: 2,
        price: 500,
      ),
      InvoiceItem(
        id: 'item-2-2',
        name: 'منتج ب',
        quantity: 3,
        price: 300,
      ),
      InvoiceItem(
        id: 'item-2-3',
        name: 'خدمة التوصيل',
        quantity: 1,
        price: 100,
      ),
    ],
    taxRate: 0.15,
    createdAt: DateTime(2025, 11, 5),
    updatedAt: DateTime(2025, 11, 5),
  );

  /// فاتورة 3: فاتورة مدفوعة
  static final invoice3 = Invoice(
    id: 'invoice-3',
    customerId: CustomerFixtures.customer3.id,
    customerName: CustomerFixtures.customer3.name,
    issuedDate: DateTime(2025, 10, 15),
    dueDate: DateTime(2025, 11, 15),
    status: 'paid',
    items: const [
      InvoiceItem(
        id: 'item-3',
        name: 'اشتراك شهري',
        quantity: 1,
        price: 2000,
      ),
    ],
    taxRate: 0.15,
    createdAt: DateTime(2025, 10, 15),
    updatedAt: DateTime(2025, 11, 16),
  );

  /// فاتورة 4: فاتورة متأخرة
  static final invoice4 = Invoice(
    id: 'invoice-4',
    customerId: CustomerFixtures.customer4.id,
    customerName: CustomerFixtures.customer4.name,
    issuedDate: DateTime(2025, 9),
    dueDate: DateTime(2025, 10),
    status: 'overdue',
    items: const [
      InvoiceItem(
        id: 'item-4',
        name: 'خدمة صيانة',
        quantity: 1,
        price: 1500,
      ),
    ],
    taxRate: 0.15,
    createdAt: DateTime(2025, 9),
    updatedAt: DateTime(2025, 10, 2),
  );

  /// فاتورة 5: فاتورة ملغاة
  static final invoice5 = Invoice(
    id: 'invoice-5',
    customerId: CustomerFixtures.customer5.id,
    customerName: CustomerFixtures.customer5.name,
    issuedDate: DateTime(2025, 11, 10),
    dueDate: DateTime(2025, 12, 10),
    status: 'cancelled',
    items: const [
      InvoiceItem(
        id: 'item-5',
        name: 'طلب ملغي',
        quantity: 1,
        price: 800,
      ),
    ],
    taxRate: 0.15,
    createdAt: DateTime(2025, 11, 10),
    updatedAt: DateTime(2025, 11, 11),
  );

  /// فاتورة 6: فاتورة مع بنود متعددة
  static final invoice6 = Invoice(
    id: 'invoice-6',
    customerId: CustomerFixtures.customer1.id,
    customerName: CustomerFixtures.customer1.name,
    issuedDate: DateTime(2025, 11, 20),
    dueDate: DateTime(2025, 12, 20),
    status: 'draft',
    items: const [
      InvoiceItem(id: 'item-6-1', name: 'منتج 1', quantity: 5, price: 100),
      InvoiceItem(id: 'item-6-2', name: 'منتج 2', quantity: 3, price: 200),
      InvoiceItem(id: 'item-6-3', name: 'منتج 3', quantity: 2, price: 300),
      InvoiceItem(id: 'item-6-4', name: 'منتج 4', quantity: 1, price: 400),
      InvoiceItem(id: 'item-6-5', name: 'منتج 5', quantity: 4, price: 150),
      InvoiceItem(
        id: 'item-6-6',
        name: 'خدمة التركيب',
        quantity: 1,
        price: 500,
      ),
      InvoiceItem(id: 'item-6-7', name: 'خدمة الضمان', quantity: 1, price: 250),
    ],
    taxRate: 0.15,
    createdAt: DateTime(2025, 11, 20),
    updatedAt: DateTime(2025, 11, 20),
  );

  /// فاتورة 7: فاتورة بدون ضريبة
  static final invoice7 = Invoice(
    id: 'invoice-7',
    customerId: CustomerFixtures.customer2.id,
    customerName: CustomerFixtures.customer2.name,
    issuedDate: DateTime(2025, 11, 25),
    dueDate: DateTime(2025, 12, 25),
    status: 'draft',
    items: const [
      InvoiceItem(
        id: 'item-7',
        name: 'خدمة معفاة من الضريبة',
        quantity: 1,
        price: 1000,
      ),
    ],
    taxRate: 0, // بدون ضريبة
    createdAt: DateTime(2025, 11, 25),
    updatedAt: DateTime(2025, 11, 25),
  );

  /// قائمة جميع الفواتير
  static final List<Invoice> allInvoices = [
    invoice1,
    invoice2,
    invoice3,
    invoice4,
    invoice5,
    invoice6,
    invoice7,
  ];

  /// فواتير المسودة فقط
  static final List<Invoice> draftInvoices = [
    invoice1,
    invoice6,
    invoice7,
  ];

  /// فواتير المرسلة فقط
  static final List<Invoice> issuedInvoices = [
    invoice2,
  ];

  /// فواتير المدفوعة فقط
  static final List<Invoice> paidInvoices = [
    invoice3,
  ];

  /// فواتير المتأخرة فقط
  static final List<Invoice> overdueInvoices = [
    invoice4,
  ];

  /// فواتير الملغاة فقط
  static final List<Invoice> cancelledInvoices = [
    invoice5,
  ];

  /// إنشاء فاتورة ديناميكية للاختبار
  static Invoice createInvoice(int index, {String? status}) => Invoice(
        id: 'invoice-$index',
        customerId: 'customer-$index',
        customerName: 'عميل رقم $index',
        issuedDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 30)),
        status: status ?? 'draft',
        items: [
          InvoiceItem(
            id: 'item-$index',
            name: 'منتج رقم $index',
            quantity: 1,
            price: 100.0 * index,
          ),
        ],
        taxRate: 0.15,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// إنشاء عدة فواتير ديناميكية
  static List<Invoice> createInvoices(int count) =>
      List.generate(count, (index) => createInvoice(index + 1));
}
