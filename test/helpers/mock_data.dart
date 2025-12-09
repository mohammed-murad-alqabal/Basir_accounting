/// Mock Data - بيانات اختبار جاهزة
///
/// يوفر هذا الملف دوال لإنشاء بيانات اختبار نموذجية
/// للعملاء والفواتير وغيرها.
library;

import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';

/// بيانات اختبار نموذجية
class MockData {
  /// إنشاء عميل اختبار افتراضي
  ///
  /// يُنشئ عميل بقيم افتراضية يمكن تخصيصها.
  ///
  /// مثال:
  /// ```dart
  /// final customer = MockData.createTestCustomer();
  /// final customCustomer = MockData.createTestCustomer(
  ///   id: 'custom-id',
  ///   name: 'اسم مخصص',
  /// );
  /// ```
  static Customer createTestCustomer({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
  }) {
    final now = DateTime.now();
    return Customer(
      id: id ?? 'test-customer-${now.millisecondsSinceEpoch}',
      name: name ?? 'عميل اختبار',
      phone: phone ?? '0501234567',
      email: email ?? 'test@example.com',
      address: address ?? 'عنوان اختبار، الرياض',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// إنشاء قائمة من العملاء للاختبار
  ///
  /// يُنشئ عدد محدد من العملاء بأسماء مختلفة.
  ///
  /// مثال:
  /// ```dart
  /// final customers = MockData.createTestCustomers(count: 5);
  /// ```
  static List<Customer> createTestCustomers({int count = 3}) => List.generate(
    count,
    (index) => createTestCustomer(
      id: 'test-customer-$index',
      name: 'عميل اختبار ${index + 1}',
      phone: '050${1234567 + index}',
      email: 'test$index@example.com',
    ),
  );

  /// إنشاء فاتورة اختبار افتراضية
  ///
  /// يُنشئ فاتورة بقيم افتراضية يمكن تخصيصها.
  ///
  /// مثال:
  /// ```dart
  /// final invoice = MockData.createTestInvoice();
  /// final customInvoice = MockData.createTestInvoice(
  ///   id: 'custom-id',
  ///   customerId: 'customer-1',
  ///   status: 'paid',
  ///   itemCount: 5,
  ///   itemName: 'خدمة مخصصة',
  ///   itemPrice: 500.0,
  /// );
  /// ```
  static Invoice createTestInvoice({
    String? id,
    String? customerId,
    String? customerName,
    DateTime? issuedDate,
    DateTime? dueDate,
    String? status,
    List<InvoiceItem>? items,
    double? taxRate,
    String? notes,
    int? itemCount,
    String? itemName,
    double? itemPrice,
  }) {
    final now = DateTime.now();

    // إنشاء البنود بناءً على المعاملات
    List<InvoiceItem> invoiceItems;
    if (items != null) {
      invoiceItems = items;
    } else if (itemCount != null) {
      // إنشاء عدد محدد من البنود
      invoiceItems = List.generate(
        itemCount,
        (index) => InvoiceItem(
          id: 'test-item-${index + 1}',
          name: itemName ?? 'خدمة اختبار ${index + 1}',
          quantity: 1,
          price: itemPrice ?? 1000,
        ),
      );
    } else {
      // البند الافتراضي
      invoiceItems = [
        InvoiceItem(
          id: 'test-item-1',
          name: itemName ?? 'خدمة اختبار',
          quantity: 1,
          price: itemPrice ?? 1000,
        ),
      ];
    }

    return Invoice(
      id: id ?? 'test-invoice-${now.millisecondsSinceEpoch}',
      customerId: customerId ?? 'test-customer-1',
      customerName: customerName ?? 'عميل اختبار',
      issuedDate: issuedDate ?? now,
      dueDate: dueDate ?? now.add(const Duration(days: 30)),
      status: status ?? 'draft',
      items: invoiceItems,
      taxRate: taxRate ?? 0.15,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// إنشاء قائمة من الفواتير للاختبار
  ///
  /// يُنشئ عدد محدد من الفواتير بحالات مختلفة.
  ///
  /// مثال:
  /// ```dart
  /// final invoices = MockData.createTestInvoices(count: 5);
  /// ```
  static List<Invoice> createTestInvoices({int count = 3}) => List.generate(
    count,
    (index) => createTestInvoice(
      id: 'test-invoice-$index',
      customerId: 'test-customer-$index',
      customerName: 'عميل اختبار ${index + 1}',
      status: index.isEven ? 'draft' : 'paid',
    ),
  );
}
