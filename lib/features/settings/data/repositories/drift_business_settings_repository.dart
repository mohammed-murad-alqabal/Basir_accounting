import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/business_settings.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/business_settings_repository.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';

/// مكيّف تجريبي لعقد BusinessSettings باستخدام Drift.
///
/// لا يُسجل هذا التنفيذ في Riverpod بعد؛ يبقى BusinessSettingsRepositoryImpl
/// المعتمد على Isar المسار النشط حتى اجتياز بوابات الموجة الثانية.
class DriftBusinessSettingsRepository implements BusinessSettingsRepository {
  DriftBusinessSettingsRepository(BasirDatabase database, {this.userId})
      : _storage = BusinessSettingsStore(database);

  /// منشئ اختبار/حقن يحافظ على عزل طبقة domain عن أنواع Drift.
  DriftBusinessSettingsRepository.withStorage(this._storage, {this.userId});

  final BusinessSettingsStorage _storage;
  final String? userId;

  @override
  Future<BusinessSettings?> getSettings() => _storage
      .readForUser(userId)
      .then((record) => record == null ? null : _toEntity(record));

  @override
  Future<void> saveSettings(BusinessSettings settings) => _storage.save(
        _toRecord(
          BusinessSettings(
            id: settings.id,
            companyName: settings.companyName,
            taxNumber: settings.taxNumber,
            address: settings.address,
            logoUrl: settings.logoUrl,
            defaultTaxRate: settings.defaultTaxRate,
            currencyCode: settings.currencyCode,
            currencySymbol: settings.currencySymbol,
            userId: userId,
            syncStatus: settings.syncStatus,
            serverUpdatedAt: settings.serverUpdatedAt,
            isDeleted: settings.isDeleted,
          ),
        ),
      );

  static BusinessSettingsRecord _toRecord(BusinessSettings settings) =>
      BusinessSettingsRecord(
        id: settings.id,
        companyName: settings.companyName,
        taxNumber: settings.taxNumber,
        address: settings.address,
        logoUrl: settings.logoUrl,
        defaultTaxRate: settings.defaultTaxRate,
        currencyCode: settings.currencyCode,
        currencySymbol: settings.currencySymbol,
        userId: settings.userId,
        syncStatus: settings.syncStatus.name,
        serverUpdatedAt: settings.serverUpdatedAt,
        isDeleted: settings.isDeleted,
      );

  static BusinessSettings _toEntity(BusinessSettingsRecord record) =>
      BusinessSettings(
        id: record.id,
        companyName: record.companyName,
        taxNumber: record.taxNumber,
        address: record.address,
        logoUrl: record.logoUrl,
        defaultTaxRate: record.defaultTaxRate,
        currencyCode: record.currencyCode,
        currencySymbol: record.currencySymbol,
        userId: record.userId,
        syncStatus: _syncStatusFromStorage(record.syncStatus),
        serverUpdatedAt: record.serverUpdatedAt,
        isDeleted: record.isDeleted,
      );

  static SyncStatus _syncStatusFromStorage(String value) => switch (value) {
        'synced' => SyncStatus.synced,
        'pendingPush' => SyncStatus.pendingPush,
        'pendingPull' => SyncStatus.pendingPull,
        'conflict' => SyncStatus.conflict,
        _ => throw StateError('Unsupported persisted sync status: $value'),
      };
}
