/// Invoice Fixtures - بيانات فواتير ثابتة للاختبار
///
/// يوفر مجموعة من الفواتير النموذجية للاستخدام في الاختبارات
library;

import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';

import 'customer_fixtures.dart';

/// بيانات فواتير ثابتة للاختبار
class InvoiceFixtures {
  /// فاتورة 1: فاتورة مسودة بسيطة
  static final invoice1 = Invoice(
    id: 'invoice-1',
    invoiceNumber: 'INV-001',
    customerId: CustomerFixtures.customer1.id,
    customerName: CustomerFixtures.customer1.nameAr,
    issuedDate: DateTime(2025, 11),
    dueDate: DateTime(2025, 12),
    status: InvoiceStatus.draft,
    items: [
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-1',
        name: 'خدمة استشارية',
        quantity: Decimal.one,
        price: Decimal.parse('1000'),
        total: Decimal.parse('1000'),
        taxAmount: Decimal.parse('150'),
        taxRate: Decimal.parse('0.15'),
      ),
    ],
    taxRate: Decimal.parse('0.15'),
    subtotalAmount: Decimal.parse('1000'),
    taxAmount: Decimal.parse('150'),
    totalAmount: Decimal.parse('1150'),
    paidAmount: Decimal.zero,
    discountAmount: Decimal.zero,
    discountRate: Decimal.zero,
    createdAt: DateTime(2025, 11),
    updatedAt: DateTime(2025, 11),
  );

  /// فاتورة 2: فاتورة مرسلة مع عدة بنود
  static final invoice2 = Invoice(
    id: 'invoice-2',
    invoiceNumber: 'INV-002',
    customerId: CustomerFixtures.customer2.id,
    customerName: CustomerFixtures.customer2.nameAr,
    issuedDate: DateTime(2025, 11, 5),
    dueDate: DateTime(2025, 12, 5),
    status: InvoiceStatus.sent,
    items: [
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-2-1',
        name: 'منتج أ',
        quantity: Decimal.parse('2'),
        price: Decimal.parse('500'),
        total: Decimal.parse('1000'),
        taxAmount: Decimal.parse('150'),
        taxRate: Decimal.parse('0.15'),
      ),
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-2-2',
        name: 'منتج ب',
        quantity: Decimal.parse('3'),
        price: Decimal.parse('300'),
        total: Decimal.parse('900'),
        taxAmount: Decimal.parse('135'),
        taxRate: Decimal.parse('0.15'),
      ),
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-2-3',
        name: 'خدمة التوصيل',
        quantity: Decimal.one,
        price: Decimal.parse('100'),
        total: Decimal.parse('100'),
        taxAmount: Decimal.parse('15'),
        taxRate: Decimal.parse('0.15'),
      ),
    ],
    taxRate: Decimal.parse('0.15'),
    subtotalAmount: Decimal.parse('2000'),
    taxAmount: Decimal.parse('300'),
    totalAmount: Decimal.parse('2300'),
    paidAmount: Decimal.zero,
    discountAmount: Decimal.zero,
    discountRate: Decimal.zero,
    createdAt: DateTime(2025, 11, 5),
    updatedAt: DateTime(2025, 11, 5),
  );

  /// فاتورة 3: فاتورة مدفوعة
  static final invoice3 = Invoice(
    id: 'invoice-3',
    invoiceNumber: 'INV-003',
    customerId: CustomerFixtures.customer3.id,
    customerName: CustomerFixtures.customer3.nameAr,
    issuedDate: DateTime(2025, 10, 15),
    dueDate: DateTime(2025, 11, 15),
    status: InvoiceStatus.paid,
    items: [
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-3',
        name: 'اشتراك شهري',
        quantity: Decimal.one,
        price: Decimal.parse('2000'),
        total: Decimal.parse('2000'),
        taxAmount: Decimal.parse('300'),
        taxRate: Decimal.parse('0.15'),
      ),
    ],
    taxRate: Decimal.parse('0.15'),
    subtotalAmount: Decimal.parse('2000'),
    taxAmount: Decimal.parse('300'),
    totalAmount: Decimal.parse('2300'),
    paidAmount: Decimal.parse('2300'),
    discountAmount: Decimal.zero,
    discountRate: Decimal.zero,
    createdAt: DateTime(2025, 10, 15),
    updatedAt: DateTime(2025, 11, 16),
  );

  /// فاتورة 4: فاتورة متأخرة
  static final invoice4 = Invoice(
    id: 'invoice-4',
    invoiceNumber: 'INV-004',
    customerId: CustomerFixtures.customer4.id,
    customerName: CustomerFixtures.customer4.nameAr,
    issuedDate: DateTime(2025, 9),
    dueDate: DateTime(2025, 10),
    status: InvoiceStatus.overdue,
    items: [
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-4',
        name: 'خدمة صيانة',
        quantity: Decimal.one,
        price: Decimal.parse('1500'),
        total: Decimal.parse('1500'),
        taxAmount: Decimal.parse('225'),
        taxRate: Decimal.parse('0.15'),
      ),
    ],
    taxRate: Decimal.parse('0.15'),
    subtotalAmount: Decimal.parse('1500'),
    taxAmount: Decimal.parse('225'),
    totalAmount: Decimal.parse('1725'),
    paidAmount: Decimal.zero,
    discountAmount: Decimal.zero,
    discountRate: Decimal.zero,
    createdAt: DateTime(2025, 9),
    updatedAt: DateTime(2025, 10, 2),
  );

  /// فاتورة 5: فاتورة ملغاة
  static final invoice5 = Invoice(
    id: 'invoice-5',
    invoiceNumber: 'INV-005',
    customerId: CustomerFixtures.customer5.id,
    customerName: CustomerFixtures.customer5.nameAr,
    issuedDate: DateTime(2025, 11, 10),
    dueDate: DateTime(2025, 12, 10),
    status: InvoiceStatus.cancelled,
    items: [
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-5',
        name: 'طلب ملغي',
        quantity: Decimal.one,
        price: Decimal.parse('800'),
        total: Decimal.parse('800'),
        taxAmount: Decimal.parse('120'),
        taxRate: Decimal.parse('0.15'),
      ),
    ],
    taxRate: Decimal.parse('0.15'),
    subtotalAmount: Decimal.parse('800'),
    taxAmount: Decimal.parse('120'),
    totalAmount: Decimal.parse('920'),
    paidAmount: Decimal.zero,
    discountAmount: Decimal.zero,
    discountRate: Decimal.zero,
    createdAt: DateTime(2025, 11, 10),
    updatedAt: DateTime(2025, 11, 11),
  );

  /// فاتورة 6: فاتورة مع بنود متعددة
  static final invoice6 = Invoice(
    id: 'invoice-6',
    invoiceNumber: 'INV-006',
    customerId: CustomerFixtures.customer1.id,
    customerName: CustomerFixtures.customer1.nameAr,
    issuedDate: DateTime(2025, 11, 20),
    dueDate: DateTime(2025, 12, 20),
    status: InvoiceStatus.draft,
    items: [
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-6-1',
        name: 'منتج 1',
        quantity: Decimal.parse('5'),
        price: Decimal.parse('100'),
        total: Decimal.parse('500'),
        taxAmount: Decimal.parse('75'),
        taxRate: Decimal.parse('0.15'),
      ),
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-6-2',
        name: 'منتج 2',
        quantity: Decimal.parse('3'),
        price: Decimal.parse('200'),
        total: Decimal.parse('600'),
        taxAmount: Decimal.parse('90'),
        taxRate: Decimal.parse('0.15'),
      ),
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-6-3',
        name: 'منتج 3',
        quantity: Decimal.parse('2'),
        price: Decimal.parse('300'),
        total: Decimal.parse('600'),
        taxAmount: Decimal.parse('90'),
        taxRate: Decimal.parse('0.15'),
      ),
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-6-4',
        name: 'منتج 4',
        quantity: Decimal.one,
        price: Decimal.parse('400'),
        total: Decimal.parse('400'),
        taxAmount: Decimal.parse('60'),
        taxRate: Decimal.parse('0.15'),
      ),
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-6-5',
        name: 'منتج 5',
        quantity: Decimal.parse('4'),
        price: Decimal.parse('150'),
        total: Decimal.parse('600'),
        taxAmount: Decimal.parse('90'),
        taxRate: Decimal.parse('0.15'),
      ),
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-6-6',
        name: 'خدمة التركيب',
        quantity: Decimal.one,
        price: Decimal.parse('500'),
        total: Decimal.parse('500'),
        taxAmount: Decimal.parse('75'),
        taxRate: Decimal.parse('0.15'),
      ),
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-6-7',
        name: 'خدمة الضمان',
        quantity: Decimal.one,
        price: Decimal.parse('250'),
        total: Decimal.parse('250'),
        taxAmount: Decimal.parse('37.5'),
        taxRate: Decimal.parse('0.15'),
      ),
    ],
    taxRate: Decimal.parse('0.15'),
    subtotalAmount: Decimal.parse('3450'),
    taxAmount: Decimal.parse('517.5'),
    totalAmount: Decimal.parse('3967.5'),
    paidAmount: Decimal.zero,
    discountAmount: Decimal.zero,
    discountRate: Decimal.zero,
    createdAt: DateTime(2025, 11, 20),
    updatedAt: DateTime(2025, 11, 20),
  );

  /// فاتورة 7: فاتورة بدون ضريبة
  static final invoice7 = Invoice(
    id: 'invoice-7',
    invoiceNumber: 'INV-007',
    customerId: CustomerFixtures.customer2.id,
    customerName: CustomerFixtures.customer2.nameAr,
    issuedDate: DateTime(2025, 11, 25),
    dueDate: DateTime(2025, 12, 25),
    status: InvoiceStatus.draft,
    items: [
      InvoiceItem(
        taxRate: Decimal.parse('0.15'),
        taxCategory: 'S',
        id: 'item-7',
        name: 'خدمة معفاة من الضريبة',
        quantity: Decimal.one,
        price: Decimal.parse('1000'),
        total: Decimal.parse('1000'),
        taxAmount: Decimal.zero,
        taxRate: Decimal.zero,
        taxCategory: 'E',
      ),
    ],
    taxRate: Decimal.zero, // بدون ضريبة
    subtotalAmount: Decimal.parse('1000'),
    taxAmount: Decimal.zero,
    totalAmount: Decimal.parse('1000'),
    paidAmount: Decimal.zero,
    discountAmount: Decimal.zero,
    discountRate: Decimal.zero,
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
  static final List<Invoice> draftInvoices = [invoice1, invoice6, invoice7];

  /// فواتير المرسلة فقط
  static final List<Invoice> issuedInvoices = [invoice2];

  /// فواتير المدفوعة فقط
  static final List<Invoice> paidInvoices = [invoice3];

  /// فواتير المتأخرة فقط
  static final List<Invoice> overdueInvoices = [invoice4];

  /// فواتير الملغاة فقط
  static final List<Invoice> cancelledInvoices = [invoice5];

  /// إنشاء فاتورة ديناميكية للاختبار
  static Invoice createInvoice(int index, {InvoiceStatus? status}) {
    final basePrice = Decimal.fromInt(100 * index);
    return Invoice(
      id: 'invoice-$index',
      invoiceNumber: 'INV-$index',
      customerId: 'customer-$index',
      customerName: 'عميل رقم $index',
      issuedDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      status: status ?? InvoiceStatus.draft,
      items: [
        InvoiceItem(
          taxRate: Decimal.parse('0.15'),
          taxCategory: 'S',
          id: 'item-$index',
          name: 'منتج رقم $index',
          quantity: Decimal.one,
          price: basePrice,
          total: basePrice,
          taxAmount: basePrice * Decimal.parse('0.15'),
          taxRate: Decimal.parse('0.15'),
        ),
      ],
      taxRate: Decimal.parse('0.15'),
      subtotalAmount: basePrice,
      taxAmount: basePrice * Decimal.parse('0.15'),
      totalAmount: basePrice * Decimal.parse('1.15'),
      paidAmount: Decimal.zero,
      discountAmount: Decimal.zero,
      discountRate: Decimal.zero,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// إنشاء عدة فواتير ديناميكية
  static List<Invoice> createInvoices(int count) =>
      List.generate(count, (index) => createInvoice(index + 1));
}
