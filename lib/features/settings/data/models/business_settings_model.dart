import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/settings/domain/entities/business_settings.dart';
import 'package:isar/isar.dart';

part 'business_settings_model.g.dart';

@collection
class BusinessSettingsModel {
  BusinessSettingsModel();

  factory BusinessSettingsModel.fromEntity(BusinessSettings entity) =>
      BusinessSettingsModel()
        ..id = entity.id
        ..companyName = entity.companyName
        ..taxNumber = entity.taxNumber
        ..address = entity.address
        ..logoUrl = entity.logoUrl
        ..defaultTaxRate = entity.defaultTaxRate
        ..currencyCode = entity.currencyCode
        ..currencySymbol = entity.currencySymbol
        ..userId = entity.userId
        ..syncStatus = entity.syncStatus
        ..serverUpdatedAt = entity.serverUpdatedAt
        ..isDeleted = entity.isDeleted;
  Id? isarId;

  @Index(unique: true, replace: true)
  late String id;

  late String companyName;
  String? taxNumber;
  String? address;
  String? logoUrl;
  late double defaultTaxRate;
  late String currencyCode;
  late String currencySymbol;

  @Index()
  String? userId;

  @enumerated
  late SyncStatus syncStatus;

  DateTime? serverUpdatedAt;

  late bool isDeleted;

  BusinessSettings toEntity() => BusinessSettings(
        id: id,
        companyName: companyName,
        taxNumber: taxNumber,
        address: address,
        logoUrl: logoUrl,
        defaultTaxRate: defaultTaxRate,
        currencyCode: currencyCode,
        currencySymbol: currencySymbol,
        userId: userId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
      );
}
