import 'package:basir_drift_storage/src/basir_database.dart';
import 'package:basir_drift_storage/src/profile_store.dart';
import 'package:basir_drift_storage/src/user_scope.dart';
import 'package:drift/drift.dart';

/// DTO محايد لإعدادات العمل؛ يحافظ على حقول المزامنة اللازمة قبل أي cutover.
class BusinessSettingsRecord {
  const BusinessSettingsRecord({
    required this.id,
    required this.companyName,
    required this.taxNumber,
    required this.address,
    required this.logoUrl,
    required this.defaultTaxRate,
    required this.currencyCode,
    required this.currencySymbol,
    required this.userId,
    required this.syncStatus,
    required this.serverUpdatedAt,
    required this.isDeleted,
  });

  final String id;
  final String companyName;
  final String? taxNumber;
  final String? address;
  final String? logoUrl;
  final double defaultTaxRate;
  final String currencyCode;
  final String currencySymbol;
  final String? userId;
  final String syncStatus;
  final DateTime? serverUpdatedAt;
  final bool isDeleted;
}

/// عقد إعدادات العمل المقيد بالمستخدم، مستقل عن تفاصيل Drift في التطبيق الرئيسي.
abstract interface class BusinessSettingsStorage {
  Future<BusinessSettingsRecord?> readForUser(String? userId);

  Future<void> save(BusinessSettingsRecord record);
}

/// DAO إعدادات العمل للموجة الثانية. المفتاح الداخلي هو نطاق المستخدم، لذلك
/// يستبدل الحفظ اللاحق الإعدادات الموجودة لنفس المستخدم حتى لو اختلف UUID.
class BusinessSettingsStore implements BusinessSettingsStorage {
  BusinessSettingsStore(this._database);

  final BasirDatabase _database;

  @override
  Future<BusinessSettingsRecord?> readForUser(String? userId) async {
    final row = await (_database.select(_database.businessSettings)
          ..where((table) => table.scopeKey.equals(userScopeKey(userId))))
        .getSingleOrNull();
    return row == null ? null : _toRecord(row);
  }

  @override
  Future<void> save(BusinessSettingsRecord record) {
    _validate(record);
    return _database.into(_database.businessSettings).insertOnConflictUpdate(
          BusinessSettingsCompanion.insert(
            scopeKey: <credential-fixture>(record.userId),
            id: record.id,
            companyName: record.companyName,
            taxNumber: Value(record.taxNumber),
            address: Value(record.address),
            logoUrl: Value(record.logoUrl),
            defaultTaxRate: record.defaultTaxRate,
            currencyCode: record.currencyCode,
            currencySymbol: record.currencySymbol,
            userId: Value(record.userId),
            syncStatus: Value(record.syncStatus),
            serverUpdatedAt: Value(record.serverUpdatedAt?.toUtc()),
            isDeleted: Value(record.isDeleted),
          ),
        );
  }

  static BusinessSettingsRecord _toRecord(BusinessSetting row) =>
      BusinessSettingsRecord(
        id: row.id,
        companyName: row.companyName,
        taxNumber: row.taxNumber,
        address: row.address,
        logoUrl: row.logoUrl,
        defaultTaxRate: row.defaultTaxRate,
        currencyCode: row.currencyCode,
        currencySymbol: row.currencySymbol,
        userId: row.userId,
        syncStatus: row.syncStatus,
        serverUpdatedAt: row.serverUpdatedAt,
        isDeleted: row.isDeleted,
      );

  static void _validate(BusinessSettingsRecord record) {
    if (record.id.isEmpty ||
        record.companyName.isEmpty ||
        record.currencyCode.isEmpty ||
        record.currencySymbol.isEmpty ||
        record.defaultTaxRate.isNegative) {
      throw ArgumentError.value(record, 'record', 'Invalid business settings.');
    }
    validateProfileSyncStatus(record.syncStatus);
  }
}
