import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:isar/isar.dart';

part 'invoice_model.g.dart';

/// نموذج بند الفاتورة (Invoice Item Model)
///
/// نموذج Isar مضمن (Embedded) لتخزين بنود الفاتورة.
/// يتم تخزينه كجزء من [InvoiceModel] وليس كمجموعة منفصلة.
///
/// **مثال:**
/// ```dart
/// final itemModel = InvoiceItemModel()
///   ..id = 'item-1'
///   ..name = 'خدمة استشارية'
///   ..quantity = 2.0
///   ..price = 500.0;
/// ```
@embedded
class InvoiceItemModel {
  /// Constructor افتراضي (مطلوب لـ Isar)
  InvoiceItemModel();

  /// إنشاء نموذج من كيان
  ///
  /// يحول كيان [InvoiceItem] إلى نموذج Isar.
  ///
  /// **Parameters:**
  /// - [item]: كيان البند المراد تحويله
  ///
  /// **Returns:** نموذج Isar جاهز للحفظ
  factory InvoiceItemModel.fromEntity(InvoiceItem item) => InvoiceItemModel()
    ..id = item.id
    ..name = item.name
    ..quantity = item.quantity
    ..price = item.price;

  /// معرف البند الفريد
  late String id;

  /// اسم المنتج أو الخدمة
  late String name;

  /// الكمية
  late double quantity;

  /// السعر للوحدة الواحدة
  late double price;

  /// تحويل النموذج إلى كيان
  ///
  /// يحول نموذج Isar إلى كيان [InvoiceItem].
  ///
  /// **Returns:** كيان بند الفاتورة
  InvoiceItem toEntity() => InvoiceItem(
        id: id,
        name: name,
        quantity: quantity,
        price: price,
      );
}

/// نموذج الفاتورة (Invoice Model)
///
/// نموذج Isar لتخزين الفواتير محلياً في قاعدة البيانات.
/// يحتوي على جميع بيانات الفاتورة وبنودها.
///
/// **الميزات:**
/// - تخزين محلي آمن باستخدام Isar
/// - معرف تلقائي (Auto-increment)
/// - تخزين البنود كـ Embedded objects
/// - تحويل سهل بين النموذج والكيان
///
/// **مثال:**
/// ```dart
/// final invoice = Invoice(...);
/// final model = InvoiceModel.fromEntity(invoice);
/// await isar.invoiceModels.put(model);
/// ```
@collection
class InvoiceModel {
  /// Constructor افتراضي (مطلوب لـ Isar)
  InvoiceModel();

  /// إنشاء نموذج من كيان
  ///
  /// يحول كيان [Invoice] إلى نموذج Isar للتخزين المحلي.
  ///
  /// **الاستخدام:**
  /// ```dart
  /// final invoice = Invoice(...);
  /// final model = InvoiceModel.fromEntity(invoice);
  /// await isar.invoiceModels.put(model);
  /// ```
  ///
  /// **Parameters:**
  /// - [invoice]: كيان الفاتورة المراد تحويله
  ///
  /// **Returns:** نموذج Isar جاهز للحفظ
  factory InvoiceModel.fromEntity(Invoice invoice) => InvoiceModel()
    ..invoiceId = invoice.id
    ..customerId = invoice.customerId
    ..customerName = invoice.customerName
    ..items = invoice.items.map(InvoiceItemModel.fromEntity).toList()
    ..issuedDate = invoice.issuedDate
    ..dueDate = invoice.dueDate
    ..taxRate = invoice.taxRate
    ..status = invoice.status
    ..notes = invoice.notes
    ..createdAt = invoice.createdAt
    ..updatedAt = invoice.updatedAt;

  /// معرف Isar التلقائي (Auto-increment)
  Id id = Isar.autoIncrement;

  /// معرف الفاتورة الفريد (UUID)
  late String invoiceId;

  /// معرف العميل
  late String customerId;

  /// اسم العميل
  late String customerName;

  /// قائمة بنود الفاتورة
  late List<InvoiceItemModel> items;

  /// تاريخ إصدار الفاتورة
  late DateTime issuedDate;

  /// تاريخ استحقاق الدفع
  late DateTime dueDate;

  /// نسبة الضريبة (0.15 = 15%)
  late double taxRate;

  /// حالة الفاتورة (draft, issued, paid, overdue, cancelled)
  late String status;

  /// ملاحظات إضافية (اختياري)
  String? notes;

  /// تاريخ إنشاء الفاتورة
  late DateTime createdAt;

  /// تاريخ آخر تحديث
  late DateTime updatedAt;

  /// تحويل النموذج إلى كيان
  ///
  /// يحول نموذج Isar إلى كيان [Invoice] مع جميع بنوده.
  ///
  /// **الاستخدام:**
  /// ```dart
  /// final model = await isar.invoiceModels.get(1);
  /// final invoice = model?.toEntity();
  /// ```
  ///
  /// **Returns:** كيان الفاتورة الكامل
  Invoice toEntity() => Invoice(
        id: invoiceId,
        customerId: customerId,
        customerName: customerName,
        items: items.map((item) => item.toEntity()).toList(),
        issuedDate: issuedDate,
        dueDate: dueDate,
        taxRate: taxRate,
        status: status,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
