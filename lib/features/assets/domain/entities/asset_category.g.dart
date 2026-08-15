// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssetCategoryImpl _$$AssetCategoryImplFromJson(Map<String, dynamic> json) =>
    _$AssetCategoryImpl(
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      defaultDepreciationMethod: json['defaultDepreciationMethod'] as String,
      defaultUsefulLifeYears: (json['defaultUsefulLifeYears'] as num).toInt(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$$AssetCategoryImplToJson(_$AssetCategoryImpl instance) =>
    <String, dynamic>{
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'defaultDepreciationMethod': instance.defaultDepreciationMethod,
      'defaultUsefulLifeYears': instance.defaultUsefulLifeYears,
      'id': instance.id,
    };
