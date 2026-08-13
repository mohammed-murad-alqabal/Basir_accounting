// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketPriceImpl _$$MarketPriceImplFromJson(Map<String, dynamic> json) =>
    _$MarketPriceImpl(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      price: (json['price'] as num).toDouble(),
      asOfDate: DateTime.parse(json['asOfDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MarketPriceImplToJson(_$MarketPriceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'price': instance.price,
      'asOfDate': instance.asOfDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
