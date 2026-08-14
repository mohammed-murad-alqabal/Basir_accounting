// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseImpl _$$WarehouseImplFromJson(Map<String, dynamic> json) =>
    _$WarehouseImpl(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      location: json['location'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$$WarehouseImplToJson(_$WarehouseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'location': instance.location,
      'userId': instance.userId,
    };
