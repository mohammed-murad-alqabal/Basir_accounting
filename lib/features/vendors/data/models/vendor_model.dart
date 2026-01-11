import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';
import 'package:isar/isar.dart';

part 'vendor_model.g.dart';

/// نموذج المورد لـ Isar (Vendor Model for Isar)
@collection
class VendorModel {
  /// إنشاء نموذج مورد جديد.
  VendorModel();

  /// إنشاء نموذج مورد من كيان المورد.
  factory VendorModel.fromEntity(Vendor vendor) => VendorModel()
    ..vendorId = vendor.id
    ..nameAr = vendor.nameAr
    ..nameEn = vendor.nameEn
    ..phone = vendor.phone
    ..email = vendor.email
    ..address = vendor.address
    ..createdAt = vendor.createdAt
    ..updatedAt = vendor.updatedAt
    ..payableAccountId = vendor.payableAccountId
    ..balance = vendor.balance
    ..userId = vendor.userId
    ..syncStatus = vendor.syncStatus
    ..serverUpdatedAt = vendor.serverUpdatedAt
    ..isDeleted = vendor.isDeleted;

  /// معرف Isar التلقائي.
  Id id = Isar.autoIncrement;

  /// المعرف الفريد للمورد.
  @Index(unique: true)
  late String vendorId;

  /// اسم المورد بالعربية
  @Index()
  late String nameAr;

  /// اسم المورد بالإنجليزية
  @Index()
  late String nameEn;

  /// رقم هاتف المورد.
  String? phone;

  /// البريد الإلكتروني للمورد.
  String? email;

  /// عنوان المورد.
  String? address;

  /// تاريخ الإنشاء.
  @Index()
  late DateTime createdAt;

  /// تاريخ آخر تحديث.
  late DateTime updatedAt;

  /// معرف حساب الدائنين المرتبط.
  String? payableAccountId;

  /// رصيد المورد الحالي.
  double balance = 0;

  /// معرف المستخدم (لعزل البيانات).
  @Index()
  String? userId;

  /// حالة المزامنة
  @enumerated
  late SyncStatus syncStatus;

  /// تاريخ آخر تحديث من السيرفر
  DateTime? serverUpdatedAt;

  /// هل السجل محذوف
  late bool isDeleted;

  /// تحويل النموذج إلى كيان مورد.
  Vendor toEntity() => Vendor(
        id: vendorId,
        nameAr: nameAr,
        nameEn: nameEn,
        phone: phone,
        email: email,
        address: address,
        createdAt: createdAt,
        updatedAt: updatedAt,
        payableAccountId: payableAccountId,
        balance: balance,
        userId: userId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
      );
}
