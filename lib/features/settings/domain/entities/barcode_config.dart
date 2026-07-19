import 'package:freezed_annotation/freezed_annotation.dart';

part 'barcode_config.freezed.dart';
part 'barcode_config.g.dart';

/// نوع الطابعة المستخدمة للباركود
enum PrinterType {
  /// طابعة حرارية (رولا)
  thermal,

  /// طابعة عادية (ورق A4)
  a4,
}

/// إعدادات محرك الباركود (FORENSIC 098)
@freezed
class BarcodeConfig with _$BarcodeConfig {
  /// Creates barcode configuration.
  const factory BarcodeConfig({
    /// المعرف الفريد للإعداد
    @Default('default') String id,

    /// نوع الطابعة
    @Default(PrinterType.thermal) PrinterType printerType,

    /// عدد الأعمدة في الصف الواحد (خاص بـ A4)
    @Default(1) int columnsPerRow,

    /// طول الملصق بالمليمتر
    @Default(30.0) double height,

    /// عرض الملصق بالمليمتر
    @Default(50.0) double width,

    /// الهامش بالمليمتر
    @Default(2.0) double margin,

    /// هل يتم طباعة اسم الصنف
    @Default(true) bool showItemName,

    /// هل يتم طباعة السعر
    @Default(true) bool showPrice,
  }) = _BarcodeConfig;

  /// Creates instance from JSON.
  factory BarcodeConfig.fromJson(Map<String, dynamic> json) =>
      _$BarcodeConfigFromJson(json);
}
