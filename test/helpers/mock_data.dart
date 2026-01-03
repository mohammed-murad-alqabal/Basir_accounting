/// Mock Data - بيانات اختبار جاهزة
///
/// يوفر هذا الملف دوال لإنشاء بيانات اختبار نموذجية
/// للعملاء والفواتير وغيرها.
library;

import 'package:basir_app/features/customers/domain/entities/customer.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';

/// بيانات اختبار نموذجية
class MockData {
  /// إنشاء عميل اختبار افتراضي
  static Customer createTestCustomer({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? userId,
  }) {
    final now = DateTime.now();
    return Customer(
      id: id ?? 'test-customer-${now.microsecondsSinceEpoch}',
      name: name ?? 'عميل اختبار',
      phone: phone ?? '0501234567',
      email: email ?? 'test@example.com',
      address: address ?? 'عنوان اختبار، الرياض',
      createdAt: now,
      updatedAt: now,
      userId: userId,
    );
  }

  /// إنشاء قائمة من العملاء للاختبار
  static List<Customer> createTestCustomers({int count = 3, String? userId}) =>
      List.generate(
        count,
        (index) => createTestCustomer(
          id: 'test-customer-$index',
          name: 'عميل اختبار ${index + 1}',
          phone: '050${1234567 + index}',
          email: 'test$index@example.com',
          userId: userId,
        ),
      );

  /// إنشاء قائمة من الفواتير للاختبار
  static List<Invoice> createTestInvoices({int count = 3, String? userId}) =>
      List.generate(
        count,
        (index) => createTestInvoice(
          id: 'test-invoice-$index',
          customerId: 'test-customer-$index',
          customerName: 'عميل اختبار ${index + 1}',
          status: index.isEven ? InvoiceStatus.draft : InvoiceStatus.paid,
          userId: userId,
        ),
      );

  /// إنشاء بند فاتورة اختبار
  static InvoiceItem createTestInvoiceItem({
    String? id,
    String? name,
    double? price,
    double? quantity,
    double taxRate = 0.15,
  }) {
    final qty = quantity ?? 1.0;
    final prc = price ?? 1000.0;
    final total = qty * prc;
    final tax = total * taxRate;

    return InvoiceItem(
      id: id ?? 'test-item-${DateTime.now().microsecondsSinceEpoch}',
      name: name ?? 'خدمة اختبار',
      price: prc,
      quantity: qty,
      total: total,
      taxAmount: tax,
    );
  }

  /// إنشاء فاتورة اختبار
  static Invoice createTestInvoice({
    String? id,
    String? invoiceNumber,
    String? customerId,
    String? customerName,
    DateTime? issuedDate,
    DateTime? dueDate,
    InvoiceStatus? status,
    List<InvoiceItem>? items,
    double? taxRate,
    String? notes,
    int? itemCount,
    String? itemName,
    double? itemPrice,
    double? itemQuantity,
    String? userId,
  }) {
    final now = DateTime.now();
    final rate = taxRate ?? 0.15;

    // إنشاء البنود بناءً على المعاملات
    List<InvoiceItem> invoiceItems;
    if (items != null) {
      invoiceItems = items;
    } else if (itemCount != null) {
      invoiceItems = List.generate(
        itemCount,
        (index) => createTestInvoiceItem(
          id: 'test-item-${index + 1}',
          name: itemName ?? 'خدمة اختبار ${index + 1}',
          quantity: itemQuantity ?? 1.0,
          price: itemPrice ?? 1000.0,
          taxRate: rate,
        ),
      );
    } else {
      invoiceItems = [
        createTestInvoiceItem(
          id: 'test-item-1',
          name: itemName ?? 'خدمة اختبار',
          quantity: itemQuantity ?? 1.0,
          price: itemPrice ?? 1000.0,
          taxRate: rate,
        ),
      ];
    }

    double subtotal = 0;
    double taxTotal = 0;
    for (final item in invoiceItems) {
      subtotal += item.total;
      taxTotal += item.taxAmount;
    }
    final total = subtotal + taxTotal;

    return Invoice(
      id: id ?? 'test-invoice-${now.microsecondsSinceEpoch}',
      invoiceNumber:
          invoiceNumber ?? 'INV-${id ?? now.microsecondsSinceEpoch.toString()}',
      customerId: customerId ?? 'test-customer-1',
      customerName: customerName ?? 'عميل اختبار',
      items: invoiceItems,
      issuedDate: issuedDate ?? now,
      dueDate: dueDate ?? now.add(const Duration(days: 30)),
      taxRate: rate,
      status: status ?? InvoiceStatus.draft,
      notes: notes,
      createdAt: now,
      updatedAt: now,
      subtotalAmount: subtotal,
      taxAmount: taxTotal,
      totalAmount: total,
      paidAmount: status == InvoiceStatus.paid ? total : 0,
      discountAmount: 0,
      userId: userId,
    );
  }
}
