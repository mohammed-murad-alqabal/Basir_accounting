import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/business_settings.dart';
import 'package:isar/isar.dart';

part 'business_settings_model.g.dart';

/// نموذج قاعدة البيانات لإعدادات العمل
@collection
class BusinessSettingsModel {
  /// المنشئ
  BusinessSettingsModel();

  /// التحويل من Entity
  /// التحويل من Entity
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

  /// المعرف الداخلي (Isar)
  Id? isarId;

  /// المعرف الفريد
  @Index(unique: true, replace: true)
  late String id;

  /// اسم الشركة
  late String companyName;

  /// الرقم الضريبي
  String? taxNumber;

  /// العنوان
  String? address;

  /// رابط الشعار
  String? logoUrl;

  /// نسبة الضريبة الافتراضية
  late double defaultTaxRate;

  /// كود العملة
  late String currencyCode;

  /// رمز العملة
  late String currencySymbol;

  /// معرف المستخدم المالك
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
