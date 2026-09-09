import 'package:basir_drift_storage/src/user_scope.dart';

/// القيم القانونية لحالة المزامنة كما تُخزن في Drift وتُطابق Isar.
enum DriftSyncStatusValue {
  synced('synced'),
  pendingPush('pendingPush'),
  pendingPull('pendingPull'),
  conflict('conflict');

  const DriftSyncStatusValue(this.storageValue);

  final String storageValue;

  static DriftSyncStatusValue parse(String value) {
    for (final status in values) {
      if (status.storageValue == value) return status;
    }
    throw FormatException('Unknown sync status: $value');
  }
}

/// هوية محلية مركبة تمنع افتراض أن UUID عالمي عبر جميع المستخدمين.
///
/// لا تُستخدم هذه الهوية للتواصل مع Supabase؛ إنها مفتاح محلي فقط.
class DriftScopedIdentity {
  const DriftScopedIdentity({
    required this.scopeKey,
    required this.recordId,
  });

  factory DriftScopedIdentity.forUser({
    required String? userId,
    required String recordId,
  }) =>
      DriftScopedIdentity(
        scopeKey: userScopeKey(userId),
        recordId: recordId,
      );

  final String scopeKey;
  final String recordId;

  /// تمثيل deterministic للاختبارات والتشخيص المحلي، وليس payload شبكيًا.
  String get canonicalKey => '$scopeKey\u001f$recordId';

  void validate() {
    if (scopeKey.isEmpty) {
      throw ArgumentError.value(scopeKey, 'scopeKey', 'Cannot be empty.');
    }
    if (recordId.isEmpty) {
      throw ArgumentError.value(recordId, 'recordId', 'Cannot be empty.');
    }
  }
}

/// Metadata المشتركة للسجلات التي تملك lifecycle ومزامنة.
///
/// هذا العقد لا ينفذ LWW ولا يرسل outbox؛ إنه يثبت شكل البيانات وUTC فقط.
class DriftSyncMetadata {
  const DriftSyncMetadata({
    required this.updatedAt,
    required this.syncStatus,
    this.serverUpdatedAt,
  });

  final DateTime updatedAt;
  final DriftSyncStatusValue syncStatus;
  final DateTime? serverUpdatedAt;

  DriftSyncMetadata toUtc() => DriftSyncMetadata(
        updatedAt: updatedAt.toUtc(),
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt?.toUtc(),
      );

  void validate() {
    if (!updatedAt.isUtc) {
      throw ArgumentError.value(
        updatedAt,
        'updatedAt',
        'Storage timestamps must be UTC.',
      );
    }
    if (serverUpdatedAt != null && !serverUpdatedAt!.isUtc) {
      throw ArgumentError.value(
        serverUpdatedAt,
        'serverUpdatedAt',
        'Storage timestamps must be UTC.',
      );
    }
  }
}

/// نقاط التحقق المشتركة لكل Store جديد.
abstract final class DriftStorageContract {
  static const currentSchemaVersion = 8;

  static String scopeKeyForUser(String? userId) => userScopeKey(userId);

  static DateTime utc(DateTime value) => value.toUtc();

  static void validateIdentity({
    required String? userId,
    required String recordId,
  }) {
    DriftScopedIdentity.forUser(userId: userId, recordId: recordId).validate();
  }

  static void validateSyncMetadata(DriftSyncMetadata metadata) {
    metadata.validate();
  }
}
