import 'package:basir_accounting_system/features/settings/data/models/profile_model.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/profile.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/profile_repository.dart';
import 'package:isar/isar.dart';

/// تنفيذ مستودع الملف الشخصي
class ProfileRepositoryImpl implements ProfileRepository {
  /// المنشئ
  ProfileRepositoryImpl({required this.isar, this.userId});

  /// مثيل Isar
  final Isar isar;

  /// معرف المستخدم
  final String? userId;

  @override
  Future<Profile?> getProfile() async {
    final model =
        await isar.profileModels.filter().userIdEqualTo(userId).findFirst();
    return model?.toEntity();
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    await isar.writeTxn(() async {
      final model = ProfileModel.fromEntity(profile)..userId = userId;
      await isar.profileModels.put(model);
    });
  }

  @override
  Future<void> deleteProfile() async {
    await isar.writeTxn(() async {
      await isar.profileModels.filter().userIdEqualTo(userId).deleteAll();
    });
  }
}
