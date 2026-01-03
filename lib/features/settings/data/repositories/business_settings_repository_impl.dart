import 'package:basir_app/features/settings/data/models/business_settings_model.dart';
import 'package:basir_app/features/settings/domain/entities/business_settings.dart';
import 'package:basir_app/features/settings/domain/repositories/business_settings_repository.dart';
import 'package:isar/isar.dart';

/// تنفيذ مستودع إعدادات العمل
class BusinessSettingsRepositoryImpl implements BusinessSettingsRepository {
  /// المنشئ
  BusinessSettingsRepositoryImpl({required this.isar, this.userId});

  /// مثيل Isar
  final Isar isar;

  /// معرف المستخدم
  final String? userId;

  @override
  Future<BusinessSettings?> getSettings() async {
    final model = await isar.businessSettingsModels.filter().userIdEqualTo(userId).findFirst();
    return model?.toEntity();
  }

  @override
  Future<void> saveSettings(BusinessSettings settings) async {
    await isar.writeTxn(() async {
      final model = BusinessSettingsModel.fromEntity(settings)..userId = userId;
      await isar.businessSettingsModels.put(model);
    });
  }
}
