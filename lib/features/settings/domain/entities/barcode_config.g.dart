// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BarcodeConfigImpl _$$BarcodeConfigImplFromJson(Map<String, dynamic> json) =>
    _$BarcodeConfigImpl(
      id: json['id'] as String? ?? 'default',
      printerType:
          $enumDecodeNullable(_$PrinterTypeEnumMap, json['printerType']) ??
              PrinterType.thermal,
      columnsPerRow: (json['columnsPerRow'] as num?)?.toInt() ?? 1,
      height: (json['height'] as num?)?.toDouble() ?? 30.0,
      width: (json['width'] as num?)?.toDouble() ?? 50.0,
      margin: (json['margin'] as num?)?.toDouble() ?? 2.0,
      showItemName: json['showItemName'] as bool? ?? true,
      showPrice: json['showPrice'] as bool? ?? true,
    );

Map<String, dynamic> _$$BarcodeConfigImplToJson(_$BarcodeConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'printerType': _$PrinterTypeEnumMap[instance.printerType]!,
      'columnsPerRow': instance.columnsPerRow,
      'height': instance.height,
      'width': instance.width,
      'margin': instance.margin,
      'showItemName': instance.showItemName,
      'showPrice': instance.showPrice,
    };

const _$PrinterTypeEnumMap = {
  PrinterType.thermal: 'thermal',
  PrinterType.a4: 'a4',
};
