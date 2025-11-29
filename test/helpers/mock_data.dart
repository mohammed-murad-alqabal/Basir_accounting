/// بيانات اختبار جاهزة
///
/// يوفر هذا الملف مجموعة من الدوال لإنشاء بيانات اختبار جاهزة
/// للاستخدام في الاختبارات.
library;

import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';

/// فئة تحتوي على دوال لإنشاء بيانات اختبار
class MockData {
  /// إنشاء عميل اختبار افتراضي
  ///
  /// يُستخدم هذا لإنشاء عميل بسيط للاختبارات.
  ///
  /// [id] معرف العميل (اختياري، القيمة الافتراضية: 'test-customer-1')
  /// [name] اسم العميل (اختياري، القيمة الافتراضية: 'عميل اختبار')
  /// [phone] رقم الهاتف (اختياري، القيمة الافتراضية: '0501234567')
  /// [email] البريد الإلكتروني (اختياري)
  /// [address] العنوان (اختياري)
  /// [createdAt] تاريخ الإنشاء (اختياري)
  /// [updatedAt] تاريخ التحديث (اختياري)
  ///
  /// مثال:
  /// ```dart
  /// final customer = MockData.createTestCustomer();
  /// final customer2 = MockData.createTestCustomer(
  ///   id: 'custom-id',
  ///   name: 'أحمد محمد',
  /// );
  /// ```
  static Customer createTestCustomer({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now();
    return Customer(
      id: id ?? 'test-customer-1',
      name: name ?? 'عميل اختبار',
      phone: phone ?? '0501234567',
      email: email,
      address: address,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }

  /// إنشاء فاتورة اختبار افتراضية
  ///
  /// يُستخدم هذا لإنشاء فاتورة بسيطة للاختبارات.
  ///
  /// [id] معرف الفاتورة (اختياري، القيمة الافتراضية: 'test-invoice-1')
  /// [customerId] معرف العميل (اختياري، القيمة الافتراضية: 'test-customer-1')
  /// [customerName] اسم العميل (اختياري، القيمة الافتراضية: 'عميل اختبار')
  /// [status] حالة الفاتورة (اختياري، القيمة الافتراضية: 'draft')
  /// [items] بنود الفاتورة (اختياري، القيمة الافتراضية: بند واحد)
  /// [createdAt] تاريخ الإنشاء (اختياري)
  /// [updatedAt] تاريخ التحديث (اختياري)
  ///
  /// مثال:
  /// ```dart
  /// final invoice = MockData.createTestInvoice();
  /// final invoice2 = MockData.createTestInvoice(
  ///   id: 'custom-id',
  ///   customerId: 'customer-123',
  /// );
  /// ```
  static Invoice createTestInvoice({
    String? id,
    String? customerId,
    String? customerName,
    String? status,
    List<InvoiceItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now();
    final invoiceItems = items ??
        [
          const InvoiceItem(
            id: 'test-item-1',
            name: 'منتج اختبار',
            quantity: 1,
            price: 100,
          ),
        ];

    return Invoice(
      id: id ?? 'test-invoice-1',
      customerId: customerId ?? 'test-customer-1',
      customerName: customerName ?? 'عميل اختبار',
      issuedDate: now,
      dueDate: now.add(const Duration(days: 30)),
      status: status ?? 'draft',
      items: invoiceItems,
      taxRate: 0.15,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }

  /// إنشاء بند فاتورة اختبار
  ///
  /// يُستخدم هذا لإنشاء بند فاتورة بسيط للاختبارات.
  ///
  /// [id] معرف البند (اختياري، القيمة الافتراضية: 'test-item-1')
  /// [name] اسم البند (اختياري، القيمة الافتراضية: 'بند اختبار')
  /// [quantity] الكمية (اختياري، القيمة الافتراضية: 1.0)
  /// [price] السعر (اختياري، القيمة الافتراضية: 100.0)
  ///
  /// مثال:
  /// ```dart
  /// final item = MockData.createTestInvoiceItem();
  /// final item2 = MockData.createTestInvoiceItem(
  ///   name: 'خدمة استشارية',
  ///   quantity: 2.0,
  ///   price: 500.0,
  /// );
  /// ```
  static InvoiceItem createTestInvoiceItem({
    String? id,
    String? name,
    double? quantity,
    double? price,
  }) =>
      InvoiceItem(
        id: id ?? 'test-item-1',
        name: name ?? 'بند اختبار',
        quantity: quantity ?? 1.0,
        price: price ?? 100.0,
      );

  /// إنشاء قائمة من العملاء للاختبار
  ///
  /// يُستخدم هذا لإنشاء عدة عملاء للاختبارات.
  ///
  /// [count] عدد العملاء (القيمة الافتراضية: 3)
  ///
  /// مثال:
  /// ```dart
  /// final customers = MockData.createTestCustomers(count: 5);
  /// ```
  static List<Customer> createTestCustomers({int count = 3}) => List.generate(
        count,
        (index) => createTestCustomer(
          id: 'test-customer-${index + 1}',
          name: 'عميل اختبار ${index + 1}',
          phone: '050${1234567 + index}',
        ),
      );

  /// إنشاء قائمة من الفواتير للاختبار
  ///
  /// يُستخدم هذا لإنشاء عدة فواتير للاختبارات.
  ///
  /// [count] عدد الفواتير (القيمة الافتراضية: 3)
  /// [customerId] معرف العميل (اختياري)
  ///
  /// مثال:
  /// ```dart
  /// final invoices = MockData.createTestInvoices(count: 5);
  /// ```
  static List<Invoice> createTestInvoices({
    int count = 3,
    String? customerId,
  }) =>
      List.generate(
        count,
        (index) => createTestInvoice(
          id: 'test-invoice-${index + 1}',
          customerId: customerId ?? 'test-customer-${index + 1}',
          customerName: 'عميل اختبار ${index + 1}',
        ),
      );
}
