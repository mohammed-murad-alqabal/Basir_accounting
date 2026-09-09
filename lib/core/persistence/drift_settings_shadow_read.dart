import 'package:basir_accounting_system/features/settings/domain/entities/business_settings.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/profile.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/business_settings_repository.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/profile_repository.dart';

/// نتيجة تشغيل shadow-read؛ لا تحمل قيم الأعمال أو هوية المستخدم.
enum DriftShadowReadOutcome {
  match,
  mismatch,
  sourceError,
  candidateError,
}

/// حدث تشخيصي آمن؛ يتعمد عدم احتواء userId أو payload أو exception message.
class DriftShadowReadEvent {
  const DriftShadowReadEvent({
    required this.slice,
    required this.operation,
    required this.outcome,
    required this.recordedAt,
  });

  final String slice;
  final String operation;
  final DriftShadowReadOutcome outcome;
  final DateTime recordedAt;
}

/// منفذ telemetry قابل للحقن، ويمكن ربطه لاحقًا بمراقبة المشروع بعد مراجعة.
typedef DriftShadowReadRecorder = Future<void> Function(
  DriftShadowReadEvent event,
);

/// sink ذاكراتي للاختبار فقط؛ لا يرسل أي بيانات إلى الشبكة.
class InMemoryDriftShadowReadSink {
  final events = <DriftShadowReadEvent>[];

  Future<void> record(DriftShadowReadEvent event) async {
    events.add(event);
  }
}

/// نتيجة بلا بيانات؛ تصلح لتقرير عدادات محلية أو لاتخاذ قرار canary.
class DriftShadowReadResult {
  const DriftShadowReadResult({
    required this.outcome,
    required this.recordedAt,
  });

  final DriftShadowReadOutcome outcome;
  final DateTime recordedAt;

  bool get matched => outcome == DriftShadowReadOutcome.match;
}

/// مشغّل shadow-read لموجة الإعدادات.
///
/// لا يبدل نتيجة القراءة التي يراها المستخدم، ولا يسجل نفسه في Providers.
/// إذا فشل المصدر أو المرشح، يسجل نوع الفشل فقط ويعيد النتيجة التشخيصية.
class DriftSettingsShadowReadComparator {
  DriftSettingsShadowReadComparator({
    required DriftShadowReadRecorder recorder,
    DateTime Function()? clock,
  })  : _recorder = recorder,
        _clock = clock ?? DateTime.now;

  final DriftShadowReadRecorder _recorder;
  final DateTime Function() _clock;

  Future<DriftShadowReadResult> compareProfile({
    required String operation,
    required Future<Profile?> Function() sourceRead,
    required Future<Profile?> Function() candidateRead,
  }) =>
      _compare(
        slice: 'profiles',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _profilesEqual,
      );

  Future<DriftShadowReadResult> compareBusinessSettings({
    required String operation,
    required Future<BusinessSettings?> Function() sourceRead,
    required Future<BusinessSettings?> Function() candidateRead,
  }) =>
      _compare(
        slice: 'business-settings',
        operation: operation,
        sourceRead: sourceRead,
        candidateRead: candidateRead,
        equals: _businessSettingsEqual,
      );

  Future<DriftShadowReadResult> _compare<T>({
    required String slice,
    required String operation,
    required Future<T?> Function() sourceRead,
    required Future<T?> Function() candidateRead,
    required bool Function(T source, T candidate) equals,
  }) async {
    late final T? source;
    try {
      source = await sourceRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.sourceError,
      );
    }

    late final T? candidate;
    try {
      candidate = await candidateRead();
    } on Object {
      return _record(
        slice: slice,
        operation: operation,
        outcome: DriftShadowReadOutcome.candidateError,
      );
    }

    final matches = source == null || candidate == null
        ? source == null && candidate == null
        : equals(source, candidate);
    return _record(
      slice: slice,
      operation: operation,
      outcome: matches
          ? DriftShadowReadOutcome.match
          : DriftShadowReadOutcome.mismatch,
    );
  }

  Future<DriftShadowReadResult> _record({
    required String slice,
    required String operation,
    required DriftShadowReadOutcome outcome,
  }) async {
    final recordedAt = _clock().toUtc();
    await _recorder(
      DriftShadowReadEvent(
        slice: slice,
        operation: operation,
        outcome: outcome,
        recordedAt: recordedAt,
      ),
    );
    return DriftShadowReadResult(outcome: outcome, recordedAt: recordedAt);
  }
}

bool _profilesEqual(Profile left, Profile right) =>
    left.id == right.id &&
    left.email == right.email &&
    left.displayName == right.displayName &&
    left.avatarUrl == right.avatarUrl &&
    left.phoneNumber == right.phoneNumber &&
    left.userId == right.userId &&
    left.syncStatus == right.syncStatus &&
    left.serverUpdatedAt?.toUtc() == right.serverUpdatedAt?.toUtc() &&
    left.isDeleted == right.isDeleted;

bool _businessSettingsEqual(
  BusinessSettings left,
  BusinessSettings right,
) =>
    left.id == right.id &&
    left.companyName == right.companyName &&
    left.taxNumber == right.taxNumber &&
    left.address == right.address &&
    left.logoUrl == right.logoUrl &&
    left.defaultTaxRate == right.defaultTaxRate &&
    left.currencyCode == right.currencyCode &&
    left.currencySymbol == right.currencySymbol &&
    left.userId == right.userId &&
    left.syncStatus == right.syncStatus &&
    left.serverUpdatedAt?.toUtc() == right.serverUpdatedAt?.toUtc() &&
    left.isDeleted == right.isDeleted;

/// Decorator يحافظ على قيمة Profile من المصدر القديم، ويشغّل المقارنة فقط عند
/// تفعيل flag خارجي مغلق افتراضيًا.
class ShadowReadProfileRepository implements ProfileRepository {
  ShadowReadProfileRepository({
    required ProfileRepository source,
    required ProfileRepository candidate,
    required DriftSettingsShadowReadComparator comparator,
    required bool enabled,
  })  : _source = source,
        _candidate = candidate,
        _comparator = comparator,
        _enabled = enabled;

  final ProfileRepository _source;
  final ProfileRepository _candidate;
  final DriftSettingsShadowReadComparator _comparator;
  final bool _enabled;

  @override
  Future<Profile?> getProfile() async {
    if (!_enabled) return _source.getProfile();

    final sourceRead = _source.getProfile;
    final sourceValue = await sourceRead();
    await _comparator.compareProfile(
      operation: 'getProfile',
      sourceRead: () async => sourceValue,
      candidateRead: _candidate.getProfile,
    );
    return sourceValue;
  }

  @override
  Future<void> saveProfile(Profile profile) => _source.saveProfile(profile);

  @override
  Future<void> deleteProfile() => _source.deleteProfile();
}

/// Decorator يحافظ على قيمة BusinessSettings من المصدر القديم، ويشغّل المقارنة
/// فقط عند تفعيل flag خارجي مغلق افتراضيًا.
class ShadowReadBusinessSettingsRepository
    implements BusinessSettingsRepository {
  ShadowReadBusinessSettingsRepository({
    required BusinessSettingsRepository source,
    required BusinessSettingsRepository candidate,
    required DriftSettingsShadowReadComparator comparator,
    required bool enabled,
  })  : _source = source,
        _candidate = candidate,
        _comparator = comparator,
        _enabled = enabled;

  final BusinessSettingsRepository _source;
  final BusinessSettingsRepository _candidate;
  final DriftSettingsShadowReadComparator _comparator;
  final bool _enabled;

  @override
  Future<BusinessSettings?> getSettings() async {
    if (!_enabled) return _source.getSettings();

    final sourceRead = _source.getSettings;
    final sourceValue = await sourceRead();
    await _comparator.compareBusinessSettings(
      operation: 'getSettings',
      sourceRead: () async => sourceValue,
      candidateRead: _candidate.getSettings,
    );
    return sourceValue;
  }

  @override
  Future<void> saveSettings(BusinessSettings settings) =>
      _source.saveSettings(settings);
}
