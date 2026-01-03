import 'package:basir_app/core/models/sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// الملف الشخصي للمستخدم
@freezed
class Profile with _$Profile {
  /// المنشئ
  const factory Profile({
    required String id,
    required String email,
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,

    /// معرف المستخدم لغرض عزل البيانات
    String? userId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// تاريخ آخر تحديث من السيرفر
    DateTime? serverUpdatedAt,

    /// هل السجل محذوف (حذف ناعم)
    @Default(false) bool isDeleted,
  }) = _Profile;

  /// التحويل من JSON
  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
