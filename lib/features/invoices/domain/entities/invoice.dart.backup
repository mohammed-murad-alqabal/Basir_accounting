/// كيان الفاتورة (Invoice Entity)
///
/// يمثل بيانات الفاتورة الأساسية في طبقة المجال (Domain Layer).
/// يحتوي على جميع المعلومات المتعلقة بالفاتورة وبنودها.
library;

import 'package:flutter/foundation.dart';

/// بند الفاتورة (Invoice Item)
///
/// يمثل بنداً واحداً في الفاتورة مع الكمية والسعر.
///
/// **الخصائص:**
/// - معرف فريد للبند
/// - اسم المنتج/الخدمة
/// - الكمية
/// - السعر للوحدة الواحدة
///
/// **مثال:**
/// ```dart
/// final item = InvoiceItem(
///   id: 'item-1',
///   name: 'خدمة استشارية',
///   quantity: 2.0,
///   price: 500.0,
/// );
/// print('الإجمالي: ${item.total}'); // 1000.0
/// ```
@immutable
class InvoiceItem {
  /// إنشاء بند فاتورة جديد
  ///
  /// **Parameters:**
  /// - [id]: معرف فريد للبند
  /// - [name]: اسم المنتج أو الخدمة
  /// - [quantity]: الكمية (يمكن أن تكون كسرية)
  /// - [price]: السعر للوحدة الواحدة
  const InvoiceItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  /// معرف البند الفريد
  final String id;

  /// اسم المنتج أو الخدمة
  ///
  /// **مثال:** 'خدمة استشارية', 'تصميم موقع'
  final String name;

  /// الكمية
  ///
  /// يمكن أن تكون عدداً صحيحاً أو كسرياً (مثل 1.5 ساعة).
  ///
  /// **مثال:** 2.0, 1.5, 10.0
  final double quantity;

  /// السعر للوحدة الواحدة
  ///
  /// **مثال:** 500.0 ريال
  final double price;

  /// حساب الإجمالي للبند
  ///
  /// يحسب الإجمالي بضرب الكمية في السعر.
  ///
  /// **Formula:** `quantity × price`
  ///
  /// **مثال:**
  /// ```dart
  /// final item = InvoiceItem(
  ///   id: 'item-1',
  ///   name: 'خدمة',
  ///   quantity: 2.0,
  ///   price: 500.0,
  /// );
  /// print(item.total); // 1000.0
  /// ```
  double get total => quantity * price;

  /// نسخ البند مع تحديث بعض الحقول
  ///
  /// يسمح بإنشاء نسخة جديدة من البند مع تغيير بعض القيم.
  ///
  /// **Parameters:**
  /// - [id]: معرف جديد (اختياري)
  /// - [name]: اسم جديد (اختياري)
  /// - [quantity]: كمية جديدة (اختياري)
  /// - [price]: سعر جديد (اختياري)
  ///
  /// **مثال:**
  /// ```dart
  /// final updatedItem = item.copyWith(quantity: 3.0);
  /// ```
  InvoiceItem copyWith({
    String? id,
    String? name,
    double? quantity,
    double? price,
  }) =>
      InvoiceItem(
        id: id ?? this.id,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
      );

  @override
  String toString() => 'InvoiceItem(id: $id, name: $name, quantity: $quantity, '
      'price: $price)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// الفاتورة (Invoice)
///
/// كيان رئيسي يمثل فاتورة كاملة مع جميع بنودها وتفاصيلها.
///
/// **الميزات:**
/// - إدارة بنود متعددة
/// - حساب تلقائي للضرائب والإجماليات
/// - تتبع حالة الفاتورة
/// - ربط بالعميل
///
/// **حالات الفاتورة:**
/// - `draft`: مسودة
/// - `issued`: صادرة
/// - `paid`: مدفوعة
/// - `overdue`: متأخرة
/// - `cancelled`: ملغاة
///
/// **مثال:**
/// ```dart
/// final invoice = Invoice(
///   id: 'inv-001',
///   customerId: 'customer-1',
///   customerName: 'أحمد محمد',
///   items: [
///     InvoiceItem(
///       id: 'item-1',
///       name: 'خدمة استشارية',
///       quantity: 2.0,
///       price: 500.0,
///     ),
///   ],
///   issuedDate: DateTime.now(),
///   dueDate: DateTime.now().add(Duration(days: 30)),
///   taxRate: 0.15, // 15%
///   status: 'issued',
///   createdAt: DateTime.now(),
///   updatedAt: DateTime.now(),
/// );
/// print('الإجمالي: ${invoice.grandTotal}'); // 1150.0
/// ```
@immutable
class Invoice {
  /// إنشاء فاتورة جديدة
  ///
  /// **Parameters:**
  /// - [id]: معرف فريد للفاتورة
  /// - [customerId]: معرف العميل
  /// - [customerName]: اسم العميل
  /// - [items]: قائمة بنود الفاتورة
  /// - [issuedDate]: تاريخ الإصدار
  /// - [dueDate]: تاريخ الاستحقاق
  /// - [taxRate]: نسبة الضريبة (0.15 = 15%)
  /// - [status]: حالة الفاتورة
  /// - [createdAt]: تاريخ الإنشاء
  /// - [updatedAt]: تاريخ آخر تحديث
  /// - [notes]: ملاحظات إضافية (اختياري)
  const Invoice({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.items,
    required this.issuedDate,
    required this.dueDate,
    required this.taxRate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  /// معرف الفاتورة الفريد
  final String id;

  /// معرف العميل
  final String customerId;

  /// اسم العميل
  ///
  /// يتم نسخه من بيانات العميل لسهولة الوصول.
  final String customerName;

  /// قائمة بنود الفاتورة
  ///
  /// يجب أن تحتوي على بند واحد على الأقل.
  final List<InvoiceItem> items;

  /// تاريخ إصدار الفاتورة
  final DateTime issuedDate;

  /// تاريخ استحقاق الدفع
  final DateTime dueDate;

  /// نسبة الضريبة
  ///
  /// **مثال:** 0.15 = 15%
  final double taxRate;

  /// حالة الفاتورة
  ///
  /// **القيم الممكنة:**
  /// - `draft`: مسودة
  /// - `issued`: صادرة
  /// - `paid`: مدفوعة
  /// - `overdue`: متأخرة
  /// - `cancelled`: ملغاة
  final String status;

  /// ملاحظات إضافية
  ///
  /// **اختياري** - يمكن استخدامه لشروط الدفع أو ملاحظات خاصة.
  final String? notes;

  /// تاريخ إنشاء الفاتورة
  final DateTime createdAt;

  /// تاريخ آخر تحديث للفاتورة
  final DateTime updatedAt;

  /// حساب الإجمالي الفرعي (Subtotal)
  ///
  /// يحسب مجموع إجماليات جميع البنود قبل الضريبة.
  ///
  /// **Formula:** `Σ(item.total)`
  ///
  /// **مثال:**
  /// ```dart
  /// // بند 1: 2 × 500 = 1000
  /// // بند 2: 1 × 300 = 300
  /// // الإجمالي الفرعي = 1300
  /// print(invoice.subtotal); // 1300.0
  /// ```
  double get subtotal => items.fold(0, (sum, item) => sum + item.total);

  /// حساب إجمالي الضريبة (Tax Total)
  ///
  /// يحسب قيمة الضريبة بناءً على الإجمالي الفرعي ونسبة الضريبة.
  ///
  /// **Formula:** `subtotal × taxRate`
  ///
  /// **مثال:**
  /// ```dart
  /// // الإجمالي الفرعي: 1000
  /// // نسبة الضريبة: 15%
  /// // الضريبة = 1000 × 0.15 = 150
  /// print(invoice.taxTotal); // 150.0
  /// ```
  double get taxTotal => subtotal * taxRate;

  /// حساب الإجمالي الكلي (Grand Total)
  ///
  /// يحسب المبلغ النهائي المستحق شاملاً الضريبة.
  ///
  /// **Formula:** `subtotal + taxTotal`
  ///
  /// **مثال:**
  /// ```dart
  /// // الإجمالي الفرعي: 1000
  /// // الضريبة: 150
  /// // الإجمالي الكلي = 1150
  /// print(invoice.grandTotal); // 1150.0
  /// ```
  double get grandTotal => subtotal + taxTotal;

  /// نسخ الفاتورة مع تحديث بعض الحقول
  ///
  /// يسمح بإنشاء نسخة جديدة من الفاتورة مع تغيير بعض القيم.
  ///
  /// **مثال:**
  /// ```dart
  /// final updatedInvoice = invoice.copyWith(
  ///   status: 'paid',
  ///   updatedAt: DateTime.now(),
  /// );
  /// ```
  Invoice copyWith({
    String? id,
    String? customerId,
    String? customerName,
    List<InvoiceItem>? items,
    DateTime? issuedDate,
    DateTime? dueDate,
    double? taxRate,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Invoice(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        customerName: customerName ?? this.customerName,
        items: items ?? this.items,
        issuedDate: issuedDate ?? this.issuedDate,
        dueDate: dueDate ?? this.dueDate,
        taxRate: taxRate ?? this.taxRate,
        status: status ?? this.status,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  String toString() =>
      'Invoice(id: $id, customerId: $customerId, status: $status, '
      'grandTotal: $grandTotal)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Invoice && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
