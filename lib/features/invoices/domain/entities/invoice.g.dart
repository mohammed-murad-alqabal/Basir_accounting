// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceItemImpl _$$InvoiceItemImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity:
          const DecimalJsonConverter().fromJson(json['quantity'] as String),
      price: const DecimalJsonConverter().fromJson(json['price'] as String),
      total: const DecimalJsonConverter().fromJson(json['total'] as String),
      taxAmount:
          const DecimalJsonConverter().fromJson(json['taxAmount'] as String),
      taxRate: const DecimalJsonConverter().fromJson(json['taxRate'] as String),
      description: json['description'] as String?,
      taxCategory: json['taxCategory'] as String? ?? 'S',
    );

Map<String, dynamic> _$$InvoiceItemImplToJson(_$InvoiceItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': const DecimalJsonConverter().toJson(instance.quantity),
      'price': const DecimalJsonConverter().toJson(instance.price),
      'total': const DecimalJsonConverter().toJson(instance.total),
      'taxAmount': const DecimalJsonConverter().toJson(instance.taxAmount),
      'taxRate': const DecimalJsonConverter().toJson(instance.taxRate),
      'description': instance.description,
      'taxCategory': instance.taxCategory,
    };

_$InvoiceImpl _$$InvoiceImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceImpl(
      id: json['id'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      issuedDate: DateTime.parse(json['issuedDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: $enumDecode(_$InvoiceStatusEnumMap, json['status']),
      subtotalAmount: const DecimalJsonConverter()
          .fromJson(json['subtotalAmount'] as String),
      taxAmount:
          const DecimalJsonConverter().fromJson(json['taxAmount'] as String),
      discountAmount: const DecimalJsonConverter()
          .fromJson(json['discountAmount'] as String),
      totalAmount:
          const DecimalJsonConverter().fromJson(json['totalAmount'] as String),
      paidAmount:
          const DecimalJsonConverter().fromJson(json['paidAmount'] as String),
      taxRate: const DecimalJsonConverter().fromJson(json['taxRate'] as String),
      discountRate:
          const DecimalJsonConverter().fromJson(json['discountRate'] as String),
      exchangeRate:
          const DecimalJsonConverter().fromJson(json['exchangeRate'] as String),
      type: $enumDecodeNullable(_$InvoiceTypeEnumMap, json['type']) ??
          InvoiceType.sales,
      paidDate: json['paidDate'] == null
          ? null
          : DateTime.parse(json['paidDate'] as String),
      currency: json['currency'] as String? ?? 'SAR',
      notes: json['notes'] as String?,
      terms: json['terms'] as String?,
      zatcaUuid: json['zatcaUuid'] as String?,
      zatcaHash: json['zatcaHash'] as String?,
      qrCode: json['qrCode'] as String?,
      xmlContent: json['xmlContent'] as String?,
      zatcaDeviceId: json['zatcaDeviceId'] as String?,
      zatcaStatus: $enumDecodeNullable(
              _$ZatcaSubmissionStatusEnumMap, json['zatcaStatus']) ??
          ZatcaSubmissionStatus.notReported,
      zatcaCounter: (json['zatcaCounter'] as num?)?.toInt() ?? 0,
      userId: json['userId'] as String?,
      warehouseId: json['warehouseId'] as String?,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
      serverUpdatedAt: json['serverUpdatedAt'] == null
          ? null
          : DateTime.parse(json['serverUpdatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$InvoiceImplToJson(_$InvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceNumber': instance.invoiceNumber,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'issuedDate': instance.issuedDate.toIso8601String(),
      'dueDate': instance.dueDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'status': _$InvoiceStatusEnumMap[instance.status]!,
      'subtotalAmount':
          const DecimalJsonConverter().toJson(instance.subtotalAmount),
      'taxAmount': const DecimalJsonConverter().toJson(instance.taxAmount),
      'discountAmount':
          const DecimalJsonConverter().toJson(instance.discountAmount),
      'totalAmount': const DecimalJsonConverter().toJson(instance.totalAmount),
      'paidAmount': const DecimalJsonConverter().toJson(instance.paidAmount),
      'taxRate': const DecimalJsonConverter().toJson(instance.taxRate),
      'discountRate':
          const DecimalJsonConverter().toJson(instance.discountRate),
      'exchangeRate':
          const DecimalJsonConverter().toJson(instance.exchangeRate),
      'type': _$InvoiceTypeEnumMap[instance.type]!,
      'paidDate': instance.paidDate?.toIso8601String(),
      'currency': instance.currency,
      'notes': instance.notes,
      'terms': instance.terms,
      'zatcaUuid': instance.zatcaUuid,
      'zatcaHash': instance.zatcaHash,
      'qrCode': instance.qrCode,
      'xmlContent': instance.xmlContent,
      'zatcaDeviceId': instance.zatcaDeviceId,
      'zatcaStatus': _$ZatcaSubmissionStatusEnumMap[instance.zatcaStatus]!,
      'zatcaCounter': instance.zatcaCounter,
      'userId': instance.userId,
      'warehouseId': instance.warehouseId,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'serverUpdatedAt': instance.serverUpdatedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
    };

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.draft: 'draft',
  InvoiceStatus.sent: 'sent',
  InvoiceStatus.paid: 'paid',
  InvoiceStatus.overdue: 'overdue',
  InvoiceStatus.cancelled: 'cancelled',
  InvoiceStatus.refunded: 'refunded',
};

const _$InvoiceTypeEnumMap = {
  InvoiceType.sales: 'sales',
  InvoiceType.purchase: 'purchase',
  InvoiceType.salesReturn: 'sales_return',
  InvoiceType.purchaseReturn: 'purchase_return',
  InvoiceType.damage: 'damage',
};

const _$ZatcaSubmissionStatusEnumMap = {
  ZatcaSubmissionStatus.notReported: 'notReported',
  ZatcaSubmissionStatus.reported: 'reported',
  ZatcaSubmissionStatus.rejected: 'rejected',
  ZatcaSubmissionStatus.reportedWithWarnings: 'reportedWithWarnings',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingPush: 'pendingPush',
  SyncStatus.pendingPull: 'pendingPull',
  SyncStatus.conflict: 'conflict',
};
