/// كيان الفاتورة (Invoice Entity)
///
/// يمثل بيانات الفاتورة الأساسية في طبقة المجال (Domain Layer).
/// يحتوي على جميع المعلومات المتعلقة بالفاتورة وبنودها.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice.freezed.dart';

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
@freezed
class InvoiceItem with _$InvoiceItem {
  /// إنشاء بند فاتورة جديد
  ///
  /// **Parameters:**
  /// - [id]: معرف فريد للبند
  /// - [name]: اسم المنتج أو الخدمة
  /// - [quantity]: الكمية (يمكن أن تكون كسرية)
  /// - [price]: السعر للوحدة الواحدة
  const factory InvoiceItem({
    /// معرف البند الفريد
    required String id,

    /// اسم المنتج أو الخدمة
    ///
    /// **مثال:** 'خدمة استشارية', 'تصميم موقع'
    required String name,

    /// الكمية
    ///
    /// يمكن أن تكون عدداً صحيحاً أو كسرياً (مثل 1.5 ساعة).
    ///
    /// **مثال:** 2.0, 1.5, 10.0
    required double quantity,

    /// السعر للوحدة الواحدة
    ///
    /// **مثال:** 500.0 ريال
    required double price,
  }) = _InvoiceItem;

  const InvoiceItem._();

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
@freezed
class Invoice with _$Invoice {
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
  const factory Invoice({
    /// معرف الفاتورة الفريد
    required String id,

    /// معرف العميل
    required String customerId,

    /// اسم العميل
    ///
    /// يتم نسخه من بيانات العميل لسهولة الوصول.
    required String customerName,

    /// قائمة بنود الفاتورة
    ///
    /// يجب أن تحتوي على بند واحد على الأقل.
    required List<InvoiceItem> items,

    /// تاريخ إصدار الفاتورة
    required DateTime issuedDate,

    /// تاريخ استحقاق الدفع
    required DateTime dueDate,

    /// نسبة الضريبة
    ///
    /// **مثال:** 0.15 = 15%
    required double taxRate,

    /// حالة الفاتورة
    ///
    /// **القيم الممكنة:**
    /// - `draft`: مسودة
    /// - `issued`: صادرة
    /// - `paid`: مدفوعة
    /// - `overdue`: متأخرة
    /// - `cancelled`: ملغاة
    required String status,

    /// تاريخ إنشاء الفاتورة
    required DateTime createdAt,

    /// تاريخ آخر تحديث للفاتورة
    required DateTime updatedAt,

    /// ملاحظات إضافية
    ///
    /// **اختياري** - يمكن استخدامه لشروط الدفع أو ملاحظات خاصة.
    String? notes,
  }) = _Invoice;

  const Invoice._();

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
}
