import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/profile.dart';
import 'package:isar/isar.dart';

part 'profile_model.g.dart';

/// نموذج بيانات الملف الشخصي
@collection
class ProfileModel {
  /// المنشئ
  ProfileModel();

  /// التحويل من Entity
  factory ProfileModel.fromEntity(Profile entity) => ProfileModel()
    ..id = entity.id
    ..email = entity.email
    ..displayName = entity.displayName
    ..avatarUrl = entity.avatarUrl
    ..phoneNumber = entity.phoneNumber
    ..userId = entity.userId
    ..syncStatus = entity.syncStatus
    ..serverUpdatedAt = entity.serverUpdatedAt
    ..isDeleted = entity.isDeleted;

  /// المعرف الداخلي
  Id? isarId;

  /// المعرف
  @Index(unique: true, replace: true)
  late String id;

  /// البريد الإلكتروني
  late String email;

  /// الاسم المعروض
  String? displayName;

  /// رابط الصورة الرمزية
  String? avatarUrl;

  /// رقم الهاتف
  String? phoneNumber;

  /// معرف المستخدم
  @Index()
  String? userId;

  /// حالة المزامنة
  @enumerated
  late SyncStatus syncStatus;

  /// توقيت التحديث في السيرفر
  DateTime? serverUpdatedAt;

  /// هل تم الحذف؟
  late bool isDeleted;

  /// التحويل إلى Entity
  Profile toEntity() => Profile(
        id: id,
        email: email,
        displayName: displayName,
        avatarUrl: avatarUrl,
        phoneNumber: phoneNumber,
        userId: userId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
      );
}
