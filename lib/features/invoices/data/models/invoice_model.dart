import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';

part 'invoice_model.g.dart';

/// ***
/// Cognitive Foundation: InvoiceModel
///
/// Data Transfer Object (DTO) for the Invoices module, backed by Isar.
/// Facilitates high-fidelity serialization and hydration for local persistence.
///
/// Maps [Decimal] domain fields to [double] for Isar compatibility while
/// ensuring precision during hydration.
/// ***
@embedded
class InvoiceItemModel {
  /// Standard constructor for Isar.
  InvoiceItemModel();

  /// Mapping handle from Domain Entity.
  factory InvoiceItemModel.fromEntity(InvoiceItem item) => InvoiceItemModel()
    ..id = item.id
    ..name = item.name
    ..description = item.description
    ..quantity = item.quantity.toDouble()
    ..price = item.price.toDouble()
    ..total = item.total.toDouble()
    ..taxAmount = item.taxAmount.toDouble()
    ..taxCategory = item.taxCategory;

  /// Unique item identifier.
  late String id;

  /// Product or service name.
  late String name;

  /// Institutional description.
  String? description;

  /// Precise quantity.
  late double quantity;

  /// Unit price.
  late double price;

  /// Line total.
  late double total;

  /// Tax component.
  late double taxAmount;

  /// VAT category.
  late String taxCategory;

  /// Hydrates the domain entity from the model.
  InvoiceItem toEntity() => InvoiceItem(
        id: id,
        name: name,
        description: description,
        quantity: Decimal.parse(quantity.toString()),
        price: Decimal.parse(price.toString()),
        total: Decimal.parse(total.toString()),
        taxAmount: Decimal.parse(taxAmount.toString()),
        taxCategory: taxCategory,
      );
}

/// [InvoiceModel]
@collection
class InvoiceModel {
  /// Standard constructor for Isar.
  InvoiceModel();

  /// Mapping handle from Domain Entity.
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
    ..status = invoice.status
    ..subtotalAmount = invoice.subtotalAmount.toDouble()
    ..taxAmount = invoice.taxAmount.toDouble()
    ..discountAmount = invoice.discountAmount.toDouble()
    ..totalAmount = invoice.totalAmount.toDouble()
    ..paidAmount = invoice.paidAmount.toDouble()
    ..taxRate = invoice.taxRate.toDouble()
    ..discountRate = invoice.discountRate.toDouble()
    ..currency = invoice.currency
    ..notes = invoice.notes
    ..terms = invoice.terms
    ..zatcaUuid = invoice.zatcaUuid
    ..zatcaHash = invoice.zatcaHash
    ..qrCode = invoice.qrCode
    ..xmlContent = invoice.xmlContent
    ..zatcaDeviceId = invoice.zatcaDeviceId
    ..zatcaCounter = invoice.zatcaCounter
    ..userId = invoice.userId
    ..syncStatus = invoice.syncStatus
    ..serverUpdatedAt = invoice.serverUpdatedAt
    ..isDeleted = invoice.isDeleted;

  /// Isar primary key.
  Id id = Isar.autoIncrement;

  /// Institutional invoice UUID.
  @Index(unique: true)
  late String invoiceId;

  /// Serial invoice number.
  @Index()
  late String invoiceNumber;

  /// Associated customer ID.
  @Index()
  late String customerId;

  /// Cached customer name.
  late String customerName;

  /// Line items.
  List<InvoiceItemModel>? items;

  /// Issuance timestamp.
  @Index()
  late DateTime issuedDate;

  /// Maturity timestamp.
  late DateTime dueDate;

  /// Payment timestamp.
  DateTime? paidDate;

  /// Record creation timestamp.
  @Index()
  late DateTime createdAt;

  /// Record modification timestamp.
  late DateTime updatedAt;

  /// Transactional status.
  @Enumerated(EnumType.name)
  late InvoiceStatus status;

  /// Financial subtotal.
  late double subtotalAmount;

  /// Aggregate tax.
  late double taxAmount;

  /// Aggregate discount.
  late double discountAmount;

  /// Aggregate total.
  late double totalAmount;

  /// Total amount discharged.
  late double paidAmount;

  /// Applied tax rate.
  late double taxRate;

  /// Applied discount rate.
  late double discountRate;

  /// Institutional currency.
  late String currency;

  /// Institutional notes.
  String? notes;

  /// Standard terms.
  String? terms;

  /// ZATCA UUID.
  String? zatcaUuid;

  /// ZATCA Hash.
  String? zatcaHash;

  /// ZATCA QR Payload.
  String? qrCode;

  /// ZATCA XML Manifest.
  String? xmlContent;

  /// Registered Device ID.
  String? zatcaDeviceId;

  /// Monotonic counter for ZATCA sequence.
  late int zatcaCounter;

  /// Operator identity.
  @Index()
  String? userId;

  /// Synchronization state.
  @enumerated
  late SyncStatus syncStatus;

  /// Server-side ground truth timestamp.
  DateTime? serverUpdatedAt;

  /// Deletion marker.
  late bool isDeleted;

  /// Hydrates the domain entity from the model.
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
        subtotalAmount: Decimal.parse(subtotalAmount.toString()),
        taxAmount: Decimal.parse(taxAmount.toString()),
        discountAmount: Decimal.parse(discountAmount.toString()),
        totalAmount: Decimal.parse(totalAmount.toString()),
        paidAmount: Decimal.parse(paidAmount.toString()),
        taxRate: Decimal.parse(taxRate.toString()),
        discountRate: Decimal.parse(discountRate.toString()),
        currency: currency,
        notes: notes,
        terms: terms,
        zatcaUuid: zatcaUuid,
        zatcaHash: zatcaHash,
        qrCode: qrCode,
        xmlContent: xmlContent,
        zatcaDeviceId: zatcaDeviceId,
        zatcaCounter: zatcaCounter,
        userId: userId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
      );
}
