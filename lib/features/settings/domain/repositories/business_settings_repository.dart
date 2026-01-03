import 'package:basir_app/features/settings/domain/entities/business_settings.dart';

abstract class BusinessSettingsRepository {
  Future<BusinessSettings?> getSettings();
  Future<void> saveSettings(BusinessSettings settings);
}
