// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetImpl _$$BudgetImplFromJson(Map<String, dynamic> json) => _$BudgetImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: $enumDecode(_$BudgetCategoryEnumMap, json['category']),
      limitAmount: Decimal.fromJson(json['limitAmount'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      spentAmount: Decimal.fromJson(json['spentAmount'] as String),
      alertThreshold: (json['alertThreshold'] as num?)?.toDouble() ?? 0.8,
      isRollover: json['isRollover'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$$BudgetImplToJson(_$BudgetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': _$BudgetCategoryEnumMap[instance.category]!,
      'limitAmount': instance.limitAmount,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'spentAmount': instance.spentAmount,
      'alertThreshold': instance.alertThreshold,
      'isRollover': instance.isRollover,
      'isActive': instance.isActive,
      'userId': instance.userId,
    };

const _$BudgetCategoryEnumMap = {
  BudgetCategory.housing: 'housing',
  BudgetCategory.utilities: 'utilities',
  BudgetCategory.transportation: 'transportation',
  BudgetCategory.food: 'food',
  BudgetCategory.health: 'health',
  BudgetCategory.insurance: 'insurance',
  BudgetCategory.personal: 'personal',
  BudgetCategory.entertainment: 'entertainment',
  BudgetCategory.education: 'education',
  BudgetCategory.savings: 'savings',
  BudgetCategory.debt: 'debt',
  BudgetCategory.other: 'other',
};
