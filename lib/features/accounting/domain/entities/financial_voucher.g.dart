// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinancialVoucherImpl _$$FinancialVoucherImplFromJson(
        Map<String, dynamic> json) =>
    _$FinancialVoucherImpl(
      id: json['id'] as String,
      referenceNumber: json['referenceNumber'] as String,
      date: DateTime.parse(json['date'] as String),
      type: $enumDecode(_$VoucherTypeEnumMap, json['type']),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      amount: Decimal.fromJson(json['amount'] as String),
      accountId: json['accountId'] as String,
      treasuryAccountId: json['treasuryAccountId'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      personName: json['personName'] as String?,
      isPosted: json['isPosted'] as bool? ?? false,
      journalEntryId: json['journalEntryId'] as String?,
      userId: json['userId'] as String?,
      originalCurrency: json['originalCurrency'] as String?,
      exchangeRate: json['exchangeRate'] == null
          ? null
          : Decimal.fromJson(json['exchangeRate'] as String),
      originalAmount: json['originalAmount'] == null
          ? null
          : Decimal.fromJson(json['originalAmount'] as String),
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
              SyncStatus.synced,
      serverUpdatedAt: json['serverUpdatedAt'] == null
          ? null
          : DateTime.parse(json['serverUpdatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$FinancialVoucherImplToJson(
        _$FinancialVoucherImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referenceNumber': instance.referenceNumber,
      'date': instance.date.toIso8601String(),
      'type': _$VoucherTypeEnumMap[instance.type]!,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'amount': instance.amount,
      'accountId': instance.accountId,
      'treasuryAccountId': instance.treasuryAccountId,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'personName': instance.personName,
      'isPosted': instance.isPosted,
      'journalEntryId': instance.journalEntryId,
      'userId': instance.userId,
      'originalCurrency': instance.originalCurrency,
      'exchangeRate': instance.exchangeRate,
      'originalAmount': instance.originalAmount,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
      'serverUpdatedAt': instance.serverUpdatedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
    };

const _$VoucherTypeEnumMap = {
  VoucherType.receipt: 'receipt',
  VoucherType.payment: 'payment',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.bank: 'bank',
  PaymentMethod.check: 'check',
};

const _$SyncStatusEnumMap = {
  SyncStatus.synced: 'synced',
  SyncStatus.pendingPush: 'pendingPush',
  SyncStatus.pendingPull: 'pendingPull',
  SyncStatus.conflict: 'conflict',
};
