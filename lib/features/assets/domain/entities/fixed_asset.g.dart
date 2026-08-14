// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FixedAssetImpl _$$FixedAssetImplFromJson(Map<String, dynamic> json) =>
    _$FixedAssetImpl(
      code: json['code'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      categoryId: json['categoryId'] as String,
      acquisitionDate: DateTime.parse(json['acquisitionDate'] as String),
      cost: (json['cost'] as num).toDouble(),
      residualValue: (json['residualValue'] as num).toDouble(),
      usefulLifeYears: (json['usefulLifeYears'] as num).toInt(),
      depreciationMethod: json['depreciationMethod'] as String,
      assetAccountId: json['assetAccountId'] as String,
      depreciationAccountId: json['depreciationAccountId'] as String,
      accumDepreciationAccountId: json['accumDepreciationAccountId'] as String,
      accumulatedDepreciation:
          (json['accumulatedDepreciation'] as num?)?.toDouble() ?? 0.0,
      id: json['id'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$FixedAssetImplToJson(_$FixedAssetImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'categoryId': instance.categoryId,
      'acquisitionDate': instance.acquisitionDate.toIso8601String(),
      'cost': instance.cost,
      'residualValue': instance.residualValue,
      'usefulLifeYears': instance.usefulLifeYears,
      'depreciationMethod': instance.depreciationMethod,
      'assetAccountId': instance.assetAccountId,
      'depreciationAccountId': instance.depreciationAccountId,
      'accumDepreciationAccountId': instance.accumDepreciationAccountId,
      'accumulatedDepreciation': instance.accumulatedDepreciation,
      'id': instance.id,
      'isActive': instance.isActive,
    };
