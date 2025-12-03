import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_tracking_config.freezed.dart';
part 'error_tracking_config.g.dart';

/// يمثل إعدادات نظام تتبع الأخطاء.
///
/// يحتوي على جميع الإعدادات القابلة للتخصيص للنظام.
@freezed
class ErrorTrackingConfig with _$ErrorTrackingConfig {
  /// إنشاء إعدادات نظام تتبع الأخطاء.
  const factory ErrorTrackingConfig({
    /// إعدادات Git Hooks
    required HooksConfig hooksConfig,

    /// إعدادات التقارير
    required ReportsConfig reportsConfig,

    /// إعدادات الأمان
    required SecurityConfig securityConfig,

    /// إعدادات الأداء
    required PerformanceConfig performanceConfig,

    /// تفعيل/تعطيل النظام
    @Default(true) bool enabled,

    /// مستوى السجلات
    @Default(LogLevel.error) LogLevel logLevel,

    /// الحد الأقصى لعمر السجلات (بالأيام)
    @Default(7) int maxLogAgeDays,

    /// الأرشفة التلقائية
    @Default(true) bool autoArchive,

    /// الحد الأقصى لحجم الأرشيف (بالميجابايت)
    @Default(10.0) double maxArchiveSizeMB,

    /// معلومات إضافية
    Map<String, dynamic>? metadata,
  }) = _ErrorTrackingConfig;

  /// إنشاء من JSON.
  factory ErrorTrackingConfig.fromJson(Map<String, dynamic> json) =>
      _$ErrorTrackingConfigFromJson(json);

  /// إنشاء إعدادات افتراضية
  factory ErrorTrackingConfig.defaults() => ErrorTrackingConfig(
        hooksConfig: HooksConfig.defaults(),
        reportsConfig: ReportsConfig.defaults(),
        securityConfig: SecurityConfig.defaults(),
        performanceConfig: PerformanceConfig.defaults(),
      );
}

/// مستوى السجلات
enum LogLevel {
  /// أخطاء فقط
  error,

  /// أخطاء وتحذيرات
  warning,

  /// أخطاء وتحذيرات ومعلومات
  info,

  /// جميع السجلات
  debug,
}

/// إعدادات Git Hooks
@freezed
class HooksConfig with _$HooksConfig {
  /// إنشاء إعدادات Git Hooks.
  const factory HooksConfig({
    /// تفعيل pre-commit hook
    @Default(true) bool preCommitEnabled,

    /// تفعيل commit-msg hook
    @Default(true) bool commitMsgEnabled,

    /// تفعيل pre-push hook
    @Default(true) bool prePushEnabled,

    /// تشغيل flutter format في pre-commit
    @Default(true) bool runFormat,

    /// تشغيل flutter analyze في pre-commit
    @Default(true) bool runAnalyze,

    /// تشغيل الاختبارات في pre-push
    @Default(true) bool runTests,

    /// فحص الأسرار في pre-push
    @Default(true) bool checkSecrets,

    /// الحد الأقصى لوقت تنفيذ pre-commit (بالثواني)
    @Default(30) int preCommitTimeout,

    /// الحد الأقصى لوقت تنفيذ pre-push (بالثواني)
    @Default(120) int prePushTimeout,
  }) = _HooksConfig;

  /// إنشاء من JSON.
  factory HooksConfig.fromJson(Map<String, dynamic> json) =>
      _$HooksConfigFromJson(json);

  /// إنشاء إعدادات افتراضية.
  factory HooksConfig.defaults() => const HooksConfig();
}

/// إعدادات التقارير
@freezed
class ReportsConfig with _$ReportsConfig {
  /// إنشاء إعدادات التقارير.
  const factory ReportsConfig({
    /// تفعيل التقارير اليومية
    @Default(true) bool dailyReportsEnabled,

    /// وقت إنشاء التقرير اليومي (الساعة)
    @Default(2) int dailyReportHour,

    /// تضمين إحصائيات المشروع
    @Default(true) bool includeProjectStats,

    /// تضمين ملخص الأخطاء
    @Default(true) bool includeErrorSummary,

    /// تضمين نتائج الاختبارات
    @Default(true) bool includeTestResults,

    /// تضمين التوصيات
    @Default(true) bool includeRecommendations,

    /// حفظ التقارير في Git
    @Default(false) bool saveToGit,

    /// مسار حفظ التقارير
    @Default('logs/reports') String reportsPath,
  }) = _ReportsConfig;

  /// إنشاء من JSON.
  factory ReportsConfig.fromJson(Map<String, dynamic> json) =>
      _$ReportsConfigFromJson(json);

  /// إنشاء إعدادات افتراضية.
  factory ReportsConfig.defaults() => const ReportsConfig();
}

/// إعدادات الأمان
@freezed
class SecurityConfig with _$SecurityConfig {
  /// إنشاء إعدادات الأمان.
  const factory SecurityConfig({
    /// تنظيف البيانات الحساسة من السجلات
    @Default(true) bool sanitizeLogs,

    /// فحص الأسرار المكشوفة
    @Default(true) bool checkExposedSecrets,

    /// تشفير السجلات الحساسة
    @Default(false) bool encryptSensitiveLogs,

    /// الحد الأقصى لحجم السجل (بالكيلوبايت)
    @Default(100) int maxLogSizeKB,
  }) = _SecurityConfig;

  /// إنشاء من JSON.
  factory SecurityConfig.fromJson(Map<String, dynamic> json) =>
      _$SecurityConfigFromJson(json);

  /// إنشاء إعدادات افتراضية.
  factory SecurityConfig.defaults() => const SecurityConfig();
}

/// إعدادات الأداء
@freezed
class PerformanceConfig with _$PerformanceConfig {
  /// إنشاء إعدادات الأداء.
  const factory PerformanceConfig({
    /// تفعيل التخزين المؤقت
    @Default(true) bool cachingEnabled,

    /// مدة التخزين المؤقت (بالدقائق)
    @Default(30) int cacheDurationMinutes,

    /// الحد الأقصى لعدد السجلات في الذاكرة
    @Default(1000) int maxLogsInMemory,

    /// ضغط السجلات القديمة
    @Default(true) bool compressOldLogs,

    /// نسبة الضغط المستهدفة
    @Default(0.7) double targetCompressionRatio,

    /// تنفيذ العمليات بالتوازي
    @Default(true) bool parallelProcessing,

    /// عدد العمليات المتوازية
    @Default(4) int maxParallelOperations,
  }) = _PerformanceConfig;

  /// إنشاء من JSON.
  factory PerformanceConfig.fromJson(Map<String, dynamic> json) =>
      _$PerformanceConfigFromJson(json);

  /// إنشاء إعدادات افتراضية.
  factory PerformanceConfig.defaults() => const PerformanceConfig();
}
