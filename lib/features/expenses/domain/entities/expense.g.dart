// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: Decimal.fromJson(json['amount'] as String),
      currencyCode: json['currencyCode'] as String,
      expenseDate: DateTime.parse(json['expenseDate'] as String),
      categoryId: json['categoryId'] as String,
      vendorId: json['vendorId'] as String?,
      vendorName: json['vendorName'] as String?,
      receiptUrl: json['receiptUrl'] as String?,
      notes: json['notes'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringEndDate: json['recurringEndDate'] == null
          ? null
          : DateTime.parse(json['recurringEndDate'] as String),
      status: json['status'] as String? ?? 'pending',
      journalEntryId: json['journalEntryId'] as String?,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
      'currencyCode': instance.currencyCode,
      'expenseDate': instance.expenseDate.toIso8601String(),
      'categoryId': instance.categoryId,
      'vendorId': instance.vendorId,
      'vendorName': instance.vendorName,
      'receiptUrl': instance.receiptUrl,
      'notes': instance.notes,
      'isRecurring': instance.isRecurring,
      'recurringEndDate': instance.recurringEndDate?.toIso8601String(),
      'status': instance.status,
      'journalEntryId': instance.journalEntryId,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ExpenseCategoryImpl _$$ExpenseCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ExpenseCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      accountId: json['accountId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$ExpenseCategoryImplToJson(
        _$ExpenseCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameAr': instance.nameAr,
      'icon': instance.icon,
      'color': instance.color,
      'accountId': instance.accountId,
      'isActive': instance.isActive,
    };
