import 'package:basir_accounting_system/features/settings/domain/entities/barcode_config.dart';
import 'package:isar/isar.dart';

part 'barcode_config_model.g.dart';

/// نموذج إعدادات الباركود لتخزينها في Isar
@collection
class BarcodeConfigModel {
  /// المنشئ
  BarcodeConfigModel();

  /// التحويل من Entity
  factory BarcodeConfigModel.fromEntity(BarcodeConfig entity) =>
      BarcodeConfigModel()
        ..id = entity.id
        ..printerType = entity.printerType
        ..columnsPerRow = entity.columnsPerRow
        ..height = entity.height
        ..width = entity.width
        ..margin = entity.margin
        ..showItemName = entity.showItemName
        ..showPrice = entity.showPrice;

  /// المعرف الداخلي لـ Isar
  Id? isarId;

  /// المعرف (نستخدم 'default' لإعداد واحد فقط)
  @Index(unique: true, replace: true)
  late String id;

  /// نوع الطابعة
  @enumerated
  late PrinterType printerType;

  /// أعمدة لكل صف
  late int columnsPerRow;

  /// الطول
  late double height;

  /// العرض
  late double width;

  /// الهامش
  late double margin;

  /// إظهار الاسم
  late bool showItemName;

  /// إظهار السعر
  late bool showPrice;

  /// التحويل إلى Entity
  BarcodeConfig toEntity() => BarcodeConfig(
        id: id,
        printerType: printerType,
        columnsPerRow: columnsPerRow,
        height: height,
        width: width,
        margin: margin,
        showItemName: showItemName,
        showPrice: showPrice,
      );
}
