import 'package:basir_app/core/models/sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_settings.freezed.dart';
part 'business_settings.g.dart';

/// إعدادات العمل (المنشأة)
@freezed
class BusinessSettings with _$BusinessSettings {
  /// المنشئ
  const factory BusinessSettings({
    required String id,
    required String companyName,
    String? taxNumber,
    String? address,
    String? logoUrl,
    @Default(15.0) double defaultTaxRate,
    @Default('SAR') String currencyCode,
    @Default('ر.س') String currencySymbol,

    /// معرف المستخدم لغرض عزل البيانات
    String? userId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// تاريخ آخر تحديث من السيرفر
    DateTime? serverUpdatedAt,

    /// هل السجل محذوف (حذف ناعم)
    @Default(false) bool isDeleted,
  }) = _BusinessSettings;

  /// التحويل من JSON
  factory BusinessSettings.fromJson(Map<String, dynamic> json) => _$BusinessSettingsFromJson(json);
}
