import 'package:isar/isar.dart';

part 'warehouse_model.g.dart';

/// نموذج المستودع لقاعدة بيانات Isar
@collection
class WarehouseModel {
  /// إنشاء نموذج مستودع فارغ
  WarehouseModel();

  /// المعرف الخاص بـ Isar
  Id? isarId;

  /// المعرف الفريد للمستودع
  @Index(unique: true, replace: true)
  late String id;

  /// الاسم بالعربية
  @Index(type: IndexType.value)
  late String nameAr;

  /// الاسم بالإنجليزية
  @Index(type: IndexType.value)
  late String nameEn;

  /// الموقع الجغرافي أو العنوان
  String? location;

  /// معرف المستخدم المرتبط
  String? userId;

  /// تاريخ الإنشاء
  late DateTime createdAt;

  /// تاريخ التحديث
  late DateTime updatedAt;
}
