// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) {
  return _InvoiceItem.fromJson(json);
}

/// @nodoc
mixin _$InvoiceItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Decimal get quantity => throw _privateConstructorUsedError;
  Decimal get price => throw _privateConstructorUsedError;

  /// Calculated subtotal: quantity * price.
  Decimal get total => throw _privateConstructorUsedError;

  /// VAT amount calculated for this specific item.
  Decimal get taxAmount => throw _privateConstructorUsedError;

  /// VAT rate applied to this item (e.g., 0.15, 0.05, 0.0).
  Decimal get taxRate => throw _privateConstructorUsedError;

  /// Semantic description or notes.
  String? get description => throw _privateConstructorUsedError;

  /// VAT category (e.g., 'S' for Standard, 'Z' for Zero, etc.)
  String get taxCategory => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvoiceItemCopyWith<InvoiceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceItemCopyWith<$Res> {
  factory $InvoiceItemCopyWith(
          InvoiceItem value, $Res Function(InvoiceItem) then) =
      _$InvoiceItemCopyWithImpl<$Res, InvoiceItem>;
  @useResult
  $Res call(
      {String id,
      String name,
      Decimal quantity,
      Decimal price,
      Decimal total,
      Decimal taxAmount,
      Decimal taxRate,
      String? description,
      String taxCategory});
}

/// @nodoc
class _$InvoiceItemCopyWithImpl<$Res, $Val extends InvoiceItem>
    implements $InvoiceItemCopyWith<$Res> {
  _$InvoiceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? price = null,
    Object? total = null,
    Object? taxAmount = null,
    Object? taxRate = null,
    Object? description = freezed,
    Object? taxCategory = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Decimal,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as Decimal,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      taxCategory: null == taxCategory
          ? _value.taxCategory
          : taxCategory // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceItemImplCopyWith<$Res>
    implements $InvoiceItemCopyWith<$Res> {
  factory _$$InvoiceItemImplCopyWith(
          _$InvoiceItemImpl value, $Res Function(_$InvoiceItemImpl) then) =
      __$$InvoiceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      Decimal quantity,
      Decimal price,
      Decimal total,
      Decimal taxAmount,
      Decimal taxRate,
      String? description,
      String taxCategory});
}

/// @nodoc
class __$$InvoiceItemImplCopyWithImpl<$Res>
    extends _$InvoiceItemCopyWithImpl<$Res, _$InvoiceItemImpl>
    implements _$$InvoiceItemImplCopyWith<$Res> {
  __$$InvoiceItemImplCopyWithImpl(
      _$InvoiceItemImpl _value, $Res Function(_$InvoiceItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? price = null,
    Object? total = null,
    Object? taxAmount = null,
    Object? taxRate = null,
    Object? description = freezed,
    Object? taxCategory = null,
  }) {
    return _then(_$InvoiceItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as Decimal,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as Decimal,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as Decimal,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      taxCategory: null == taxCategory
          ? _value.taxCategory
          : taxCategory // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceItemImpl extends _InvoiceItem {
  _$InvoiceItemImpl(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.price,
      required this.total,
      required this.taxAmount,
      required this.taxRate,
      this.description,
      this.taxCategory = 'S'})
      : super._();

  factory _$InvoiceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final Decimal quantity;
  @override
  final Decimal price;

  /// Calculated subtotal: quantity * price.
  @override
  final Decimal total;

  /// VAT amount calculated for this specific item.
  @override
  final Decimal taxAmount;

  /// VAT rate applied to this item (e.g., 0.15, 0.05, 0.0).
  @override
  final Decimal taxRate;

  /// Semantic description or notes.
  @override
  final String? description;

  /// VAT category (e.g., 'S' for Standard, 'Z' for Zero, etc.)
  @override
  @JsonKey()
  final String taxCategory;

  @override
  String toString() {
    return 'InvoiceItem(id: $id, name: $name, quantity: $quantity, price: $price, total: $total, taxAmount: $taxAmount, taxRate: $taxRate, description: $description, taxCategory: $taxCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.taxCategory, taxCategory) ||
                other.taxCategory == taxCategory));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity, price, total,
      taxAmount, taxRate, description, taxCategory);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceItemImplCopyWith<_$InvoiceItemImpl> get copyWith =>
      __$$InvoiceItemImplCopyWithImpl<_$InvoiceItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceItemImplToJson(
      this,
    );
  }
}

abstract class _InvoiceItem extends InvoiceItem {
  factory _InvoiceItem(
      {required final String id,
      required final String name,
      required final Decimal quantity,
      required final Decimal price,
      required final Decimal total,
      required final Decimal taxAmount,
      required final Decimal taxRate,
      final String? description,
      final String taxCategory}) = _$InvoiceItemImpl;
  _InvoiceItem._() : super._();

  factory _InvoiceItem.fromJson(Map<String, dynamic> json) =
      _$InvoiceItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  Decimal get quantity;
  @override
  Decimal get price;
  @override

  /// Calculated subtotal: quantity * price.
  Decimal get total;
  @override

  /// VAT amount calculated for this specific item.
  Decimal get taxAmount;
  @override

  /// VAT rate applied to this item (e.g., 0.15, 0.05, 0.0).
  Decimal get taxRate;
  @override

  /// Semantic description or notes.
  String? get description;
  @override

  /// VAT category (e.g., 'S' for Standard, 'Z' for Zero, etc.)
  String get taxCategory;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceItemImplCopyWith<_$InvoiceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Invoice _$InvoiceFromJson(Map<String, dynamic> json) {
  return _Invoice.fromJson(json);
}

/// @nodoc
mixin _$Invoice {
  /// Unique immutable identifier (UUID).
  String get id => throw _privateConstructorUsedError;

  /// Human-readable sequential reference code.
  String get invoiceNumber => throw _privateConstructorUsedError;

  /// Target entity identifier.
  String get customerId => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;

  /// Granular list of products or services.
  List<InvoiceItem> get items => throw _privateConstructorUsedError;

  /// Execution and audit timestamps.
  DateTime get issuedDate => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Transaction lifecycle status.
  InvoiceStatus get status => throw _privateConstructorUsedError;

  /// Financial aggregates (Persisted for Data Integrity).
  Decimal get subtotalAmount => throw _privateConstructorUsedError;
  Decimal get taxAmount => throw _privateConstructorUsedError;
  Decimal get discountAmount => throw _privateConstructorUsedError;
  Decimal get totalAmount => throw _privateConstructorUsedError;
  Decimal get paidAmount => throw _privateConstructorUsedError;

  /// Rates and adjustments.
  Decimal get taxRate => throw _privateConstructorUsedError;
  Decimal get discountRate => throw _privateConstructorUsedError;

  /// Exchange rate to base currency (SAR).
  Decimal get exchangeRate => throw _privateConstructorUsedError;

  /// Granular transaction categorization (Sales, Return, etc.)
  InvoiceType get type => throw _privateConstructorUsedError;
  DateTime? get paidDate => throw _privateConstructorUsedError;

  /// Multi-currency support (Default: SAR).
  String get currency => throw _privateConstructorUsedError;

  /// Institutional memos and terms.
  String? get notes => throw _privateConstructorUsedError;
  String? get terms => throw _privateConstructorUsedError;

  /// ZATCA (Fatoora) Compliance Data.
  String? get zatcaUuid => throw _privateConstructorUsedError;
  String? get zatcaHash => throw _privateConstructorUsedError;
  String? get qrCode => throw _privateConstructorUsedError;
  String? get xmlContent => throw _privateConstructorUsedError;
  String? get zatcaDeviceId => throw _privateConstructorUsedError;
  ZatcaSubmissionStatus get zatcaStatus => throw _privateConstructorUsedError;
  int get zatcaCounter => throw _privateConstructorUsedError;

  /// Data isolation handle.
  String? get userId => throw _privateConstructorUsedError;

  /// Warehouse scope identifier.
  String? get warehouseId => throw _privateConstructorUsedError;

  /// Distributed ledger synchronization state.
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// Authority-verified timestamp.
  DateTime? get serverUpdatedAt => throw _privateConstructorUsedError;

  /// Soft-deletion flag for audit preservation.
  bool get isDeleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvoiceCopyWith<Invoice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceCopyWith<$Res> {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) then) =
      _$InvoiceCopyWithImpl<$Res, Invoice>;
  @useResult
  $Res call(
      {String id,
      String invoiceNumber,
      String customerId,
      String customerName,
      List<InvoiceItem> items,
      DateTime issuedDate,
      DateTime dueDate,
      DateTime createdAt,
      DateTime updatedAt,
      InvoiceStatus status,
      Decimal subtotalAmount,
      Decimal taxAmount,
      Decimal discountAmount,
      Decimal totalAmount,
      Decimal paidAmount,
      Decimal taxRate,
      Decimal discountRate,
      Decimal exchangeRate,
      InvoiceType type,
      DateTime? paidDate,
      String currency,
      String? notes,
      String? terms,
      String? zatcaUuid,
      String? zatcaHash,
      String? qrCode,
      String? xmlContent,
      String? zatcaDeviceId,
      ZatcaSubmissionStatus zatcaStatus,
      int zatcaCounter,
      String? userId,
      String? warehouseId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class _$InvoiceCopyWithImpl<$Res, $Val extends Invoice>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? items = null,
    Object? issuedDate = null,
    Object? dueDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? subtotalAmount = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? paidAmount = null,
    Object? taxRate = null,
    Object? discountRate = null,
    Object? exchangeRate = null,
    Object? type = null,
    Object? paidDate = freezed,
    Object? currency = null,
    Object? notes = freezed,
    Object? terms = freezed,
    Object? zatcaUuid = freezed,
    Object? zatcaHash = freezed,
    Object? qrCode = freezed,
    Object? xmlContent = freezed,
    Object? zatcaDeviceId = freezed,
    Object? zatcaStatus = null,
    Object? zatcaCounter = null,
    Object? userId = freezed,
    Object? warehouseId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<InvoiceItem>,
      issuedDate: null == issuedDate
          ? _value.issuedDate
          : issuedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvoiceStatus,
      subtotalAmount: null == subtotalAmount
          ? _value.subtotalAmount
          : subtotalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as Decimal,
      discountRate: null == discountRate
          ? _value.discountRate
          : discountRate // ignore: cast_nullable_to_non_nullable
              as Decimal,
      exchangeRate: null == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as Decimal,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InvoiceType,
      paidDate: freezed == paidDate
          ? _value.paidDate
          : paidDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      terms: freezed == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as String?,
      zatcaUuid: freezed == zatcaUuid
          ? _value.zatcaUuid
          : zatcaUuid // ignore: cast_nullable_to_non_nullable
              as String?,
      zatcaHash: freezed == zatcaHash
          ? _value.zatcaHash
          : zatcaHash // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      xmlContent: freezed == xmlContent
          ? _value.xmlContent
          : xmlContent // ignore: cast_nullable_to_non_nullable
              as String?,
      zatcaDeviceId: freezed == zatcaDeviceId
          ? _value.zatcaDeviceId
          : zatcaDeviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      zatcaStatus: null == zatcaStatus
          ? _value.zatcaStatus
          : zatcaStatus // ignore: cast_nullable_to_non_nullable
              as ZatcaSubmissionStatus,
      zatcaCounter: null == zatcaCounter
          ? _value.zatcaCounter
          : zatcaCounter // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseId: freezed == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      serverUpdatedAt: freezed == serverUpdatedAt
          ? _value.serverUpdatedAt
          : serverUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceImplCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$$InvoiceImplCopyWith(
          _$InvoiceImpl value, $Res Function(_$InvoiceImpl) then) =
      __$$InvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String invoiceNumber,
      String customerId,
      String customerName,
      List<InvoiceItem> items,
      DateTime issuedDate,
      DateTime dueDate,
      DateTime createdAt,
      DateTime updatedAt,
      InvoiceStatus status,
      Decimal subtotalAmount,
      Decimal taxAmount,
      Decimal discountAmount,
      Decimal totalAmount,
      Decimal paidAmount,
      Decimal taxRate,
      Decimal discountRate,
      Decimal exchangeRate,
      InvoiceType type,
      DateTime? paidDate,
      String currency,
      String? notes,
      String? terms,
      String? zatcaUuid,
      String? zatcaHash,
      String? qrCode,
      String? xmlContent,
      String? zatcaDeviceId,
      ZatcaSubmissionStatus zatcaStatus,
      int zatcaCounter,
      String? userId,
      String? warehouseId,
      SyncStatus syncStatus,
      DateTime? serverUpdatedAt,
      bool isDeleted});
}

/// @nodoc
class __$$InvoiceImplCopyWithImpl<$Res>
    extends _$InvoiceCopyWithImpl<$Res, _$InvoiceImpl>
    implements _$$InvoiceImplCopyWith<$Res> {
  __$$InvoiceImplCopyWithImpl(
      _$InvoiceImpl _value, $Res Function(_$InvoiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
    Object? customerId = null,
    Object? customerName = null,
    Object? items = null,
    Object? issuedDate = null,
    Object? dueDate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? status = null,
    Object? subtotalAmount = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? paidAmount = null,
    Object? taxRate = null,
    Object? discountRate = null,
    Object? exchangeRate = null,
    Object? type = null,
    Object? paidDate = freezed,
    Object? currency = null,
    Object? notes = freezed,
    Object? terms = freezed,
    Object? zatcaUuid = freezed,
    Object? zatcaHash = freezed,
    Object? qrCode = freezed,
    Object? xmlContent = freezed,
    Object? zatcaDeviceId = freezed,
    Object? zatcaStatus = null,
    Object? zatcaCounter = null,
    Object? userId = freezed,
    Object? warehouseId = freezed,
    Object? syncStatus = null,
    Object? serverUpdatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$InvoiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<InvoiceItem>,
      issuedDate: null == issuedDate
          ? _value.issuedDate
          : issuedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvoiceStatus,
      subtotalAmount: null == subtotalAmount
          ? _value.subtotalAmount
          : subtotalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as Decimal,
      discountRate: null == discountRate
          ? _value.discountRate
          : discountRate // ignore: cast_nullable_to_non_nullable
              as Decimal,
      exchangeRate: null == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as Decimal,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InvoiceType,
      paidDate: freezed == paidDate
          ? _value.paidDate
          : paidDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      terms: freezed == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as String?,
      zatcaUuid: freezed == zatcaUuid
          ? _value.zatcaUuid
          : zatcaUuid // ignore: cast_nullable_to_non_nullable
              as String?,
      zatcaHash: freezed == zatcaHash
          ? _value.zatcaHash
          : zatcaHash // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      xmlContent: freezed == xmlContent
          ? _value.xmlContent
          : xmlContent // ignore: cast_nullable_to_non_nullable
              as String?,
      zatcaDeviceId: freezed == zatcaDeviceId
          ? _value.zatcaDeviceId
          : zatcaDeviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      zatcaStatus: null == zatcaStatus
          ? _value.zatcaStatus
          : zatcaStatus // ignore: cast_nullable_to_non_nullable
              as ZatcaSubmissionStatus,
      zatcaCounter: null == zatcaCounter
          ? _value.zatcaCounter
          : zatcaCounter // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseId: freezed == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      serverUpdatedAt: freezed == serverUpdatedAt
          ? _value.serverUpdatedAt
          : serverUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceImpl extends _Invoice {
  _$InvoiceImpl(
      {required this.id,
      required this.invoiceNumber,
      required this.customerId,
      required this.customerName,
      required final List<InvoiceItem> items,
      required this.issuedDate,
      required this.dueDate,
      required this.createdAt,
      required this.updatedAt,
      required this.status,
      required this.subtotalAmount,
      required this.taxAmount,
      required this.discountAmount,
      required this.totalAmount,
      required this.paidAmount,
      required this.taxRate,
      required this.discountRate,
      required this.exchangeRate,
      this.type = InvoiceType.sales,
      this.paidDate,
      this.currency = 'SAR',
      this.notes,
      this.terms,
      this.zatcaUuid,
      this.zatcaHash,
      this.qrCode,
      this.xmlContent,
      this.zatcaDeviceId,
      this.zatcaStatus = ZatcaSubmissionStatus.notReported,
      this.zatcaCounter = 0,
      this.userId,
      this.warehouseId,
      this.syncStatus = SyncStatus.synced,
      this.serverUpdatedAt,
      this.isDeleted = false})
      : _items = items,
        super._();

  factory _$InvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceImplFromJson(json);

  /// Unique immutable identifier (UUID).
  @override
  final String id;

  /// Human-readable sequential reference code.
  @override
  final String invoiceNumber;

  /// Target entity identifier.
  @override
  final String customerId;
  @override
  final String customerName;

  /// Granular list of products or services.
  final List<InvoiceItem> _items;

  /// Granular list of products or services.
  @override
  List<InvoiceItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Execution and audit timestamps.
  @override
  final DateTime issuedDate;
  @override
  final DateTime dueDate;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Transaction lifecycle status.
  @override
  final InvoiceStatus status;

  /// Financial aggregates (Persisted for Data Integrity).
  @override
  final Decimal subtotalAmount;
  @override
  final Decimal taxAmount;
  @override
  final Decimal discountAmount;
  @override
  final Decimal totalAmount;
  @override
  final Decimal paidAmount;

  /// Rates and adjustments.
  @override
  final Decimal taxRate;
  @override
  final Decimal discountRate;

  /// Exchange rate to base currency (SAR).
  @override
  final Decimal exchangeRate;

  /// Granular transaction categorization (Sales, Return, etc.)
  @override
  @JsonKey()
  final InvoiceType type;
  @override
  final DateTime? paidDate;

  /// Multi-currency support (Default: SAR).
  @override
  @JsonKey()
  final String currency;

  /// Institutional memos and terms.
  @override
  final String? notes;
  @override
  final String? terms;

  /// ZATCA (Fatoora) Compliance Data.
  @override
  final String? zatcaUuid;
  @override
  final String? zatcaHash;
  @override
  final String? qrCode;
  @override
  final String? xmlContent;
  @override
  final String? zatcaDeviceId;
  @override
  @JsonKey()
  final ZatcaSubmissionStatus zatcaStatus;
  @override
  @JsonKey()
  final int zatcaCounter;

  /// Data isolation handle.
  @override
  final String? userId;

  /// Warehouse scope identifier.
  @override
  final String? warehouseId;

  /// Distributed ledger synchronization state.
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  /// Authority-verified timestamp.
  @override
  final DateTime? serverUpdatedAt;

  /// Soft-deletion flag for audit preservation.
  @override
  @JsonKey()
  final bool isDeleted;

  @override
  String toString() {
    return 'Invoice(id: $id, invoiceNumber: $invoiceNumber, customerId: $customerId, customerName: $customerName, items: $items, issuedDate: $issuedDate, dueDate: $dueDate, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, subtotalAmount: $subtotalAmount, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, paidAmount: $paidAmount, taxRate: $taxRate, discountRate: $discountRate, exchangeRate: $exchangeRate, type: $type, paidDate: $paidDate, currency: $currency, notes: $notes, terms: $terms, zatcaUuid: $zatcaUuid, zatcaHash: $zatcaHash, qrCode: $qrCode, xmlContent: $xmlContent, zatcaDeviceId: $zatcaDeviceId, zatcaStatus: $zatcaStatus, zatcaCounter: $zatcaCounter, userId: $userId, warehouseId: $warehouseId, syncStatus: $syncStatus, serverUpdatedAt: $serverUpdatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.issuedDate, issuedDate) ||
                other.issuedDate == issuedDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.subtotalAmount, subtotalAmount) ||
                other.subtotalAmount == subtotalAmount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.discountRate, discountRate) ||
                other.discountRate == discountRate) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.paidDate, paidDate) ||
                other.paidDate == paidDate) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.terms, terms) || other.terms == terms) &&
            (identical(other.zatcaUuid, zatcaUuid) ||
                other.zatcaUuid == zatcaUuid) &&
            (identical(other.zatcaHash, zatcaHash) ||
                other.zatcaHash == zatcaHash) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.xmlContent, xmlContent) ||
                other.xmlContent == xmlContent) &&
            (identical(other.zatcaDeviceId, zatcaDeviceId) ||
                other.zatcaDeviceId == zatcaDeviceId) &&
            (identical(other.zatcaStatus, zatcaStatus) ||
                other.zatcaStatus == zatcaStatus) &&
            (identical(other.zatcaCounter, zatcaCounter) ||
                other.zatcaCounter == zatcaCounter) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.serverUpdatedAt, serverUpdatedAt) ||
                other.serverUpdatedAt == serverUpdatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        invoiceNumber,
        customerId,
        customerName,
        const DeepCollectionEquality().hash(_items),
        issuedDate,
        dueDate,
        createdAt,
        updatedAt,
        status,
        subtotalAmount,
        taxAmount,
        discountAmount,
        totalAmount,
        paidAmount,
        taxRate,
        discountRate,
        exchangeRate,
        type,
        paidDate,
        currency,
        notes,
        terms,
        zatcaUuid,
        zatcaHash,
        qrCode,
        xmlContent,
        zatcaDeviceId,
        zatcaStatus,
        zatcaCounter,
        userId,
        warehouseId,
        syncStatus,
        serverUpdatedAt,
        isDeleted
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      __$$InvoiceImplCopyWithImpl<_$InvoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceImplToJson(
      this,
    );
  }
}

abstract class _Invoice extends Invoice {
  factory _Invoice(
      {required final String id,
      required final String invoiceNumber,
      required final String customerId,
      required final String customerName,
      required final List<InvoiceItem> items,
      required final DateTime issuedDate,
      required final DateTime dueDate,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final InvoiceStatus status,
      required final Decimal subtotalAmount,
      required final Decimal taxAmount,
      required final Decimal discountAmount,
      required final Decimal totalAmount,
      required final Decimal paidAmount,
      required final Decimal taxRate,
      required final Decimal discountRate,
      required final Decimal exchangeRate,
      final InvoiceType type,
      final DateTime? paidDate,
      final String currency,
      final String? notes,
      final String? terms,
      final String? zatcaUuid,
      final String? zatcaHash,
      final String? qrCode,
      final String? xmlContent,
      final String? zatcaDeviceId,
      final ZatcaSubmissionStatus zatcaStatus,
      final int zatcaCounter,
      final String? userId,
      final String? warehouseId,
      final SyncStatus syncStatus,
      final DateTime? serverUpdatedAt,
      final bool isDeleted}) = _$InvoiceImpl;
  _Invoice._() : super._();

  factory _Invoice.fromJson(Map<String, dynamic> json) = _$InvoiceImpl.fromJson;

  @override

  /// Unique immutable identifier (UUID).
  String get id;
  @override

  /// Human-readable sequential reference code.
  String get invoiceNumber;
  @override

  /// Target entity identifier.
  String get customerId;
  @override
  String get customerName;
  @override

  /// Granular list of products or services.
  List<InvoiceItem> get items;
  @override

  /// Execution and audit timestamps.
  DateTime get issuedDate;
  @override
  DateTime get dueDate;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override

  /// Transaction lifecycle status.
  InvoiceStatus get status;
  @override

  /// Financial aggregates (Persisted for Data Integrity).
  Decimal get subtotalAmount;
  @override
  Decimal get taxAmount;
  @override
  Decimal get discountAmount;
  @override
  Decimal get totalAmount;
  @override
  Decimal get paidAmount;
  @override

  /// Rates and adjustments.
  Decimal get taxRate;
  @override
  Decimal get discountRate;
  @override

  /// Exchange rate to base currency (SAR).
  Decimal get exchangeRate;
  @override

  /// Granular transaction categorization (Sales, Return, etc.)
  InvoiceType get type;
  @override
  DateTime? get paidDate;
  @override

  /// Multi-currency support (Default: SAR).
  String get currency;
  @override

  /// Institutional memos and terms.
  String? get notes;
  @override
  String? get terms;
  @override

  /// ZATCA (Fatoora) Compliance Data.
  String? get zatcaUuid;
  @override
  String? get zatcaHash;
  @override
  String? get qrCode;
  @override
  String? get xmlContent;
  @override
  String? get zatcaDeviceId;
  @override
  ZatcaSubmissionStatus get zatcaStatus;
  @override
  int get zatcaCounter;
  @override

  /// Data isolation handle.
  String? get userId;
  @override

  /// Warehouse scope identifier.
  String? get warehouseId;
  @override

  /// Distributed ledger synchronization state.
  SyncStatus get syncStatus;
  @override

  /// Authority-verified timestamp.
  DateTime? get serverUpdatedAt;
  @override

  /// Soft-deletion flag for audit preservation.
  bool get isDeleted;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
