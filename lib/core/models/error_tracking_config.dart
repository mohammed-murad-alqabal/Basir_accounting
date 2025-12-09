/// نموذج بيانات لتكوين نظام تتبع الأخطاء.
///
/// يحتوي على جميع الإعدادات المتعلقة بـ Git Hooks، الأرشفة،
/// التقارير، والأمان.
///
/// مثال:
/// ```dart
/// final config = ErrorTrackingConfig(
///   hooks: HooksConfig(),
///   archive: ArchiveConfig(),
///   report: ReportConfig(),
///   security: SecurityConfig(),
/// );
/// ```
class ErrorTrackingConfig {
  /// ينشئ تكوين جديد لنظام تتبع الأخطاء.
  const ErrorTrackingConfig({
    required this.hooks,
    required this.archive,
    required this.report,
    required this.security,
  });

  /// ينشئ تكوين من Map (JSON).
  factory ErrorTrackingConfig.fromJson(
    Map<String, dynamic> json,
  ) => ErrorTrackingConfig(
    hooks: HooksConfig.fromJson(json['hooks'] as Map<String, dynamic>),
    archive: ArchiveConfig.fromJson(json['archive'] as Map<String, dynamic>),
    report: ReportConfig.fromJson(json['report'] as Map<String, dynamic>),
    security: SecurityConfig.fromJson(json['security'] as Map<String, dynamic>),
  );

  /// ينشئ تكوين افتراضي.
  factory ErrorTrackingConfig.defaultConfig() => const ErrorTrackingConfig(
    hooks: HooksConfig(),
    archive: ArchiveConfig(),
    report: ReportConfig(),
    security: SecurityConfig(),
  );

  /// إعدادات Git Hooks.
  final HooksConfig hooks;

  /// إعدادات الأرشفة.
  final ArchiveConfig archive;

  /// إعدادات التقارير.
  final ReportConfig report;

  /// إعدادات الأمان.
  final SecurityConfig security;

  /// يحول التكوين إلى Map لحفظه في JSON.
  ///
  /// Returns Map يحتوي على جميع إعدادات التكوين.
  Map<String, dynamic> toJson() => {
    'hooks': hooks.toJson(),
    'archive': archive.toJson(),
    'report': report.toJson(),
    'security': security.toJson(),
  };
}

/// إعدادات Git Hooks.
class HooksConfig {
  /// ينشئ إعدادات Git Hooks جديدة.
  const HooksConfig({
    this.enablePreCommit = true,
    this.enablePrePush = true,
    this.autoFormat = true,
    this.blockOnErrors = true,
    this.maxExecutionTime = 120,
  });

  /// ينشئ إعدادات من Map (JSON).
  factory HooksConfig.fromJson(Map<String, dynamic> json) => HooksConfig(
    enablePreCommit: json['enablePreCommit'] as bool? ?? true,
    enablePrePush: json['enablePrePush'] as bool? ?? true,
    autoFormat: json['autoFormat'] as bool? ?? true,
    blockOnErrors: json['blockOnErrors'] as bool? ?? true,
    maxExecutionTime: json['maxExecutionTime'] as int? ?? 120,
  );

  /// تفعيل pre-commit hook.
  final bool enablePreCommit;

  /// تفعيل pre-push hook.
  final bool enablePrePush;

  /// تنسيق تلقائي للكود.
  final bool autoFormat;

  /// منع الـ commit عند وجود أخطاء.
  final bool blockOnErrors;

  /// الحد الأقصى لوقت التنفيذ (بالثواني).
  final int maxExecutionTime;

  /// يحول الإعدادات إلى Map لحفظها في JSON.
  Map<String, dynamic> toJson() => {
    'enablePreCommit': enablePreCommit,
    'enablePrePush': enablePrePush,
    'autoFormat': autoFormat,
    'blockOnErrors': blockOnErrors,
    'maxExecutionTime': maxExecutionTime,
  };
}

/// إعدادات الأرشفة.
class ArchiveConfig {
  /// ينشئ إعدادات أرشفة جديدة.
  const ArchiveConfig({
    this.maxAgeInDays = 7,
    this.maxSizeInMB = 10,
    this.enableCompression = true,
    this.compressionFormat = 'tar.gz',
  });

  /// ينشئ إعدادات من Map (JSON).
  factory ArchiveConfig.fromJson(Map<String, dynamic> json) => ArchiveConfig(
    maxAgeInDays: json['maxAgeInDays'] as int? ?? 7,
    maxSizeInMB: json['maxSizeInMB'] as int? ?? 10,
    enableCompression: json['enableCompression'] as bool? ?? true,
    compressionFormat: json['compressionFormat'] as String? ?? 'tar.gz',
  );

  /// الحد الأقصى لعمر السجلات (بالأيام).
  final int maxAgeInDays;

  /// الحد الأقصى لحجم الأرشيف (بالميجابايت).
  final int maxSizeInMB;

  /// تفعيل الضغط.
  final bool enableCompression;

  /// صيغة الضغط.
  final String compressionFormat;

  /// يحول الإعدادات إلى Map لحفظها في JSON.
  Map<String, dynamic> toJson() => {
    'maxAgeInDays': maxAgeInDays,
    'maxSizeInMB': maxSizeInMB,
    'enableCompression': enableCompression,
    'compressionFormat': compressionFormat,
  };
}

/// إعدادات التقارير.
class ReportConfig {
  /// ينشئ إعدادات تقارير جديدة.
  const ReportConfig({
    this.enableDailyReports = true,
    this.reportFormat = 'markdown',
    this.includeSections = const [
      'statistics',
      'errors',
      'tests',
      'recommendations',
    ],
    this.includeRecommendations = true,
  });

  /// ينشئ إعدادات من Map (JSON).
  factory ReportConfig.fromJson(Map<String, dynamic> json) => ReportConfig(
    enableDailyReports: json['enableDailyReports'] as bool? ?? true,
    reportFormat: json['reportFormat'] as String? ?? 'markdown',
    includeSections: List<String>.from(
      json['includeSections'] as List? ??
          ['statistics', 'errors', 'tests', 'recommendations'],
    ),
    includeRecommendations: json['includeRecommendations'] as bool? ?? true,
  );

  /// تفعيل التقارير اليومية.
  final bool enableDailyReports;

  /// صيغة التقرير.
  final String reportFormat;

  /// الأقسام المضمنة في التقرير.
  final List<String> includeSections;

  /// تضمين التوصيات.
  final bool includeRecommendations;

  /// يحول الإعدادات إلى Map لحفظها في JSON.
  Map<String, dynamic> toJson() => {
    'enableDailyReports': enableDailyReports,
    'reportFormat': reportFormat,
    'includeSections': includeSections,
    'includeRecommendations': includeRecommendations,
  };
}

/// إعدادات الأمان.
class SecurityConfig {
  /// ينشئ إعدادات أمان جديدة.
  const SecurityConfig({
    this.enableSecretScanning = true,
    this.secretPatterns = const ['api[_-]?key', 'password', 'token', 'secret'],
    this.sanitizeLogs = true,
    this.sensitiveKeywords = const ['password', 'token', 'key', 'secret'],
  });

  /// ينشئ إعدادات من Map (JSON).
  factory SecurityConfig.fromJson(Map<String, dynamic> json) => SecurityConfig(
    enableSecretScanning: json['enableSecretScanning'] as bool? ?? true,
    secretPatterns: List<String>.from(
      json['secretPatterns'] as List? ??
          ['api[_-]?key', 'password', 'token', 'secret'],
    ),
    sanitizeLogs: json['sanitizeLogs'] as bool? ?? true,
    sensitiveKeywords: List<String>.from(
      json['sensitiveKeywords'] as List? ??
          ['password', 'token', 'key', 'secret'],
    ),
  );

  /// تفعيل فحص الأسرار.
  final bool enableSecretScanning;

  /// أنماط الأسرار المراد البحث عنها.
  final List<String> secretPatterns;

  /// تنظيف السجلات من البيانات الحساسة.
  final bool sanitizeLogs;

  /// الكلمات المفتاحية الحساسة.
  final List<String> sensitiveKeywords;

  /// يحول الإعدادات إلى Map لحفظها في JSON.
  Map<String, dynamic> toJson() => {
    'enableSecretScanning': enableSecretScanning,
    'secretPatterns': secretPatterns,
    'sanitizeLogs': sanitizeLogs,
    'sensitiveKeywords': sensitiveKeywords,
  };
}
