import 'package:basir_app/features/settings/domain/entities/profile.dart';

/// مستودع بيانات الملف الشخصي
abstract class ProfileRepository {
  /// الحصول على الملف الشخصي
  Future<Profile?> getProfile();

  /// حفظ الملف الشخصي
  Future<void> saveProfile(Profile profile);

  /// حذف الملف الشخصي
  Future<void> deleteProfile();
}
