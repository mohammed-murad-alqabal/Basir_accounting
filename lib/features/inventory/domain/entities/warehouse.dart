import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse.freezed.dart';
part 'warehouse.g.dart';

/// كيان المستودع (Warehouse Entity)
///
/// يمثل مستودعًا لتخزين الأصناف.
@freezed
class Warehouse with _$Warehouse {
  /// تعريف المستودع
  const factory Warehouse({
    required String id,
    required String nameAr,
    required String nameEn,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? location,
    String? userId,
  }) = _Warehouse;

  /// تحويل من JSON
  factory Warehouse.fromJson(Map<String, dynamic> json) =>
      _$WarehouseFromJson(json);

  const Warehouse._();

  /// جلب الاسم بناءً على اللغة
  String name({required bool isArabic}) => isArabic ? nameAr : nameEn;
}
