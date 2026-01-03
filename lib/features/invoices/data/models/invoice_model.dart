import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:isar/isar.dart';

part 'invoice_model.g.dart';

/// نموذج بند الفاتورة (Invoice Item Model)
///
/// يستخدم لتخزين تفاصيل بنود الفاتورة في قاعدة بيانات Isar.
@embedded
class InvoiceItemModel {
  /// إنشاء نموذج بند فاتورة فارغ (مطلوب لـ Isar)
  InvoiceItemModel();

  /// إنشاء نموذج بند من كيان المجال
  factory InvoiceItemModel.fromEntity(InvoiceItem item) => InvoiceItemModel()
    ..id = item.id
    ..name = item.name
    ..description = item.description
    ..quantity = item.quantity
    ..price = item.price
    ..total = item.total
    ..taxAmount = item.taxAmount;

  /// المعرف الفريد للبند
  late String id;

  /// اسم المنتج أو الخدمة
  late String name;

  /// وصف تفصيلي للبند (اختياري)
  String? description;

  /// الكمية
  late double quantity;

  /// سعر الوحدة
  late double price;

  /// الإجمالي (الكمية * السعر)
  late double total;

  /// مبلغ الضريبة لهذا البند
  late double taxAmount;

  /// تحويل النموذج إلى كيان مجال
  InvoiceItem toEntity() => InvoiceItem(
        id: id,
        name: name,
        description: description,
        quantity: quantity,
        price: price,
        total: total,
        taxAmount: taxAmount,
      );
}

/// نموذج الفاتورة (Invoice Model)
///
/// يمثل جدول الفواتير في قاعدة بيانات Isar.
@collection
class InvoiceModel {
  /// إنشاء نموذج فاتورة فارغ (مطلوب لـ Isar)
  InvoiceModel();

  /// إنشاء نموذج فاتورة من كيان المجال
  factory InvoiceModel.fromEntity(Invoice invoice) => InvoiceModel()
    ..invoiceId = invoice.id
    ..invoiceNumber = invoice.invoiceNumber
    ..customerId = invoice.customerId
    ..customerName = invoice.customerName
    ..items = invoice.items.map(InvoiceItemModel.fromEntity).toList()
    ..issuedDate = invoice.issuedDate
    ..dueDate = invoice.dueDate
    ..paidDate = invoice.paidDate
    ..createdAt = invoice.createdAt
    ..updatedAt = invoice.updatedAt
    ..status = invoice.status // Isar handles Enum with @enumerated
    ..subtotalAmount = invoice.subtotalAmount
    ..taxAmount = invoice.taxAmount
    ..discountAmount = invoice.discountAmount
    ..totalAmount = invoice.totalAmount
    ..paidAmount = invoice.paidAmount
    ..taxRate = invoice.taxRate
    ..discountRate = invoice.discountRate
    ..currency = invoice.currency
    ..notes = invoice.notes
    ..terms = invoice.terms
    ..zatcaUuid = invoice.zatcaUuid
    ..zatcaHash = invoice.zatcaHash
    ..qrCode = invoice.qrCode
    ..xmlContent = invoice.xmlContent
    ..userId = invoice.userId
    ..syncStatus = invoice.syncStatus
    ..serverUpdatedAt = invoice.serverUpdatedAt
    ..isDeleted = invoice.isDeleted;

  /// المعرف الداخلي لـ Isar (تلقائي)
  Id id = Isar.autoIncrement;

  /// المعرف الفريد للفاتورة (UUID)
  @Index(unique: true)
  late String invoiceId;

  /// رقم الفاتورة التسلسلي (مثال: INV-2023-001)
  @Index()
  late String invoiceNumber;

  /// معرف العميل صاحب الفاتورة
  @Index()
  late String customerId;

  /// اسم العميل (للتخزين المؤقت والعرض السريع)
  late String customerName;

  /// قائمة بنود الفاتورة
  List<InvoiceItemModel>? items;

  /// تاريخ إصدار الفاتورة
  @Index()
  late DateTime issuedDate;

  /// تاريخ استحقاق الفاتورة
  late DateTime dueDate;

  /// تاريخ السداد (إن وجد)
  DateTime? paidDate;

  /// تاريخ إنشاء السجل
  @Index()
  late DateTime createdAt;

  /// تاريخ آخر تحديث للسجل
  late DateTime updatedAt;

  /// حالة الفاتورة (مسودة، مرسلة، مدفوعة، إلخ)
  @Enumerated(EnumType.name)
  late InvoiceStatus status;

  // Amounts

  /// المجموع الفرعي (قبل الضريبة والخصم)
  late double subtotalAmount;

  /// إجمالي مبلغ الضريبة
  late double taxAmount;

  /// إجمالي مبلغ الخصم
  late double discountAmount;

  /// المبلغ الإجمالي النهائي (المستحق)
  late double totalAmount;

  /// المبلغ المدفوع حتى الآن
  late double paidAmount;

  /// نسبة الضريبة المطبقة
  late double taxRate;

  /// نسبة الخصم المطبقة
  late double discountRate;

  /// رمز العملة (مثال: SAR)
  late String currency;

  /// ملاحظات إضافية على الفاتورة
  String? notes;

  /// الشروط والأحكام الخاصة بالفاتورة
  String? terms;

  // ZATCA

  /// المعرف الفريد للفاتورة الإلكترونية (UUID)
  String? zatcaUuid;

  /// التوقيع الرقمي (Hash) للفاتورة
  String? zatcaHash;

  /// رمز الاستجابة السريعة (QR Code) المشفر
  String? qrCode;

  /// محتوى الفاتورة بصيغة XML (المطلوب من ZATCA)
  String? xmlContent;

  /// معرف المستخدم (لعزل البيانات).
  @Index()
  String? userId;

  /// حالة المزامنة
  @enumerated
  late SyncStatus syncStatus;

  /// تاريخ آخر تحديث من السيرفر
  DateTime? serverUpdatedAt;

  /// هل السجل محذوف
  late bool isDeleted;

  /// تحويل النموذج إلى كيان مجال
  Invoice toEntity() => Invoice(
        id: invoiceId,
        invoiceNumber: invoiceNumber,
        customerId: customerId,
        customerName: customerName,
        items: items?.map((item) => item.toEntity()).toList() ?? [],
        issuedDate: issuedDate,
        dueDate: dueDate,
        paidDate: paidDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
        status: status,
        subtotalAmount: subtotalAmount,
        taxAmount: taxAmount,
        discountAmount: discountAmount,
        totalAmount: totalAmount,
        paidAmount: paidAmount,
        taxRate: taxRate,
        discountRate: discountRate,
        currency: currency,
        notes: notes,
        terms: terms,
        zatcaUuid: zatcaUuid,
        zatcaHash: zatcaHash,
        qrCode: qrCode,
        xmlContent: xmlContent,
        userId: userId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
      );
}
