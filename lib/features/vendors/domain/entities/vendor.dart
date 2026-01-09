import 'package:basir_app/core/models/sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor.freezed.dart';
part 'vendor.g.dart';

/// كيان المورد (Vendor Entity)
@freezed
class Vendor with _$Vendor {
  /// إنشاء كيان مورد جديد.
  const factory Vendor({
    /// معرف فريد للمورد
    required String id,

    /// اسم المورد بالعربية
    required String nameAr,

    /// اسم المورد بالإنجليزية
    required String nameEn,

    /// تاريخ إنشاء المورد
    required DateTime createdAt,

    /// تاريخ آخر تحديث للمورد
    required DateTime updatedAt,

    /// رقم هاتف المورد (اختياري)
    String? phone,

    /// البريد الإلكتروني للمورد (اختياري)
    String? email,

    /// عنوان المورد (اختياري)
    String? address,

    /// ملاحظات عن المورد (اختياري)
    String? notes,

    /// معرف حساب المورد في دليل الحسابات (AP Account)
    String? payableAccountId,

    /// الرصيد الحالي للمورد
    @Default(0.0) double balance,

    /// معرف المستخدم صاحب المورد (لعزل البيانات)
    String? userId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// تاريخ آخر تحديث من السيرفر
    DateTime? serverUpdatedAt,

    /// هل السجل محذوف (حذف ناعم)
    @Default(false) bool isDeleted,
  }) = _Vendor;

  /// إنشاء مورد من JSON
  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

  const Vendor._();

  /// الحصول على الاسم المناسب حسب اللغة
  String name({required bool isArabic}) => isArabic ? nameAr : nameEn;
}
