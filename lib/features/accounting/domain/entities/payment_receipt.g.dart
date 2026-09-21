// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentReceiptImpl _$$PaymentReceiptImplFromJson(Map<String, dynamic> json) =>
    _$PaymentReceiptImpl(
      id: json['id'] as String,
      receiptNumber: json['receiptNumber'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      amount: Decimal.fromJson(json['amount'] as String),
      receiptDate: DateTime.parse(json['receiptDate'] as String),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      accountId: json['accountId'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      reference: json['reference'] as String?,
      notes: json['notes'] as String?,
      bankAccountNumber: json['bankAccountNumber'] as String?,
      checkNumber: json['checkNumber'] as String?,
      checkDueDate: json['checkDueDate'] == null
          ? null
          : DateTime.parse(json['checkDueDate'] as String),
      status: $enumDecodeNullable(_$PaymentStatusEnumMap, json['status']) ??
          PaymentStatus.cleared,
      journalEntryId: json['journalEntryId'] as String?,
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

Map<String, dynamic> _$$PaymentReceiptImplToJson(
        _$PaymentReceiptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receiptNumber': instance.receiptNumber,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'amount': instance.amount,
      'receiptDate': instance.receiptDate.toIso8601String(),
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'accountId': instance.accountId,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'reference': instance.reference,
      'notes': instance.notes,
      'bankAccountNumber': instance.bankAccountNumber,
      'checkNumber': instance.checkNumber,
      'checkDueDate': instance.checkDueDate?.toIso8601String(),
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'journalEntryId': instance.journalEntryId,
      'userId': instance.userId,
      'warehouseId': instance.warehouseId,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'serverUpdatedAt': instance.serverUpdatedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.bankTransfer: 'bankTransfer',
  PaymentMethod.check: 'check',
  PaymentMethod.creditCard: 'creditCard',
  PaymentMethod.online: 'online',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.cleared: 'cleared',
  PaymentStatus.bounced: 'bounced',
  PaymentStatus.cancelled: 'cancelled',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingPush: 'pendingPush',
  SyncStatus.pendingPull: 'pendingPull',
  SyncStatus.conflict: 'conflict',
};
