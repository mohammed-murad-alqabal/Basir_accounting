import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_entry.freezed.dart';
part 'log_entry.g.dart';

/// يمثل سجل خطأ واحد في نظام تتبع الأخطاء.
///
/// يحتوي على جميع المعلومات المتعلقة بخطأ معين بما في ذلك
/// النوع، الرسالة، الموقع، والوقت.
///
/// مثال:
/// ```dart
/// final logEntry = LogEntry(
///   id: 'log-001',
///   timestamp: DateTime.now(),
///   type: LogType.error,
///   message: 'Failed to load data',
///   source: 'CustomerRepository',
///   file: 'lib/data/repositories/customer_repository.dart',
///   line: 45,
/// );
/// ```
@freezed
class LogEntry with _$LogEntry {
  /// إنشاء سجل خطأ جديد.
  const factory LogEntry({
    /// معرف فريد للسجل
    required String id,

    /// وقت حدوث الخطأ
    required DateTime timestamp,

    /// نوع السجل (error, warning, info)
    required LogType type,

    /// رسالة الخطأ
    required String message,

    /// مصدر الخطأ (اسم الـ class أو الـ function)
    required String source,

    /// مسار الملف
    String? file,

    /// رقم السطر
    int? line,

    /// Stack trace إن وجد
    String? stackTrace,

    /// معلومات إضافية
    Map<String, dynamic>? metadata,

    /// عدد مرات التكرار
    @Default(1) int count,

    /// آخر مرة حدث فيها الخطأ
    DateTime? lastOccurrence,

    /// حالة السجل (new, acknowledged, resolved)
    @Default(LogStatus.newLog) LogStatus status,

    /// الأولوية (low, medium, high, critical)
    @Default(LogPriority.medium) LogPriority priority,

    /// Tags للتصنيف
    @Default([]) List<String> tags,
  }) = _LogEntry;

  /// إنشاء سجل خطأ من JSON.
  factory LogEntry.fromJson(Map<String, dynamic> json) =>
      _$LogEntryFromJson(json);
}

/// أنواع السجلات
enum LogType {
  /// خطأ حرج
  error,

  /// تحذير
  warning,

  /// معلومة
  info,

  /// تصحيح
  debug,
}

/// حالة السجل
enum LogStatus {
  /// جديد - لم يتم مراجعته
  @JsonValue('new')
  newLog,

  /// تم الاطلاع عليه
  acknowledged,

  /// قيد الإصلاح
  inProgress,

  /// تم الحل
  resolved,

  /// مغلق
  closed,
}

/// أولوية السجل
enum LogPriority {
  /// منخفضة
  low,

  /// متوسطة
  medium,

  /// عالية
  high,

  /// حرجة
  critical,
}

/// Extension methods لـ LogType
extension LogTypeExtension on LogType {
  /// الحصول على اللون المناسب للنوع
  String get color {
    switch (this) {
      case LogType.error:
        return '#d73a4a'; // أحمر
      case LogType.warning:
        return '#fbca04'; // أصفر
      case LogType.info:
        return '#0075ca'; // أزرق
      case LogType.debug:
        return '#6f42c1'; // بنفسجي
    }
  }

  /// الحصول على الأيقونة المناسبة
  String get icon {
    switch (this) {
      case LogType.error:
        return '❌';
      case LogType.warning:
        return '⚠️';
      case LogType.info:
        return 'ℹ️';
      case LogType.debug:
        return '🔍';
    }
  }

  /// الحصول على الاسم بالعربية
  String get arabicName {
    switch (this) {
      case LogType.error:
        return 'خطأ';
      case LogType.warning:
        return 'تحذير';
      case LogType.info:
        return 'معلومة';
      case LogType.debug:
        return 'تصحيح';
    }
  }
}

/// Extension methods لـ LogPriority
extension LogPriorityExtension on LogPriority {
  /// الحصول على اللون المناسب للأولوية
  String get color {
    switch (this) {
      case LogPriority.low:
        return '#0e8a16'; // أخضر
      case LogPriority.medium:
        return '#fbca04'; // أصفر
      case LogPriority.high:
        return '#d93f0b'; // برتقالي
      case LogPriority.critical:
        return '#b60205'; // أحمر غامق
    }
  }

  /// الحصول على الأيقونة المناسبة
  String get icon {
    switch (this) {
      case LogPriority.low:
        return '🟢';
      case LogPriority.medium:
        return '🟡';
      case LogPriority.high:
        return '🟠';
      case LogPriority.critical:
        return '🔴';
    }
  }

  /// الحصول على الاسم بالعربية
  String get arabicName {
    switch (this) {
      case LogPriority.low:
        return 'منخفضة';
      case LogPriority.medium:
        return 'متوسطة';
      case LogPriority.high:
        return 'عالية';
      case LogPriority.critical:
        return 'حرجة';
    }
  }
}

/// Extension methods لـ LogStatus
extension LogStatusExtension on LogStatus {
  /// الحصول على اللون المناسب للحالة
  String get color {
    switch (this) {
      case LogStatus.newLog:
        return '#ededed'; // رمادي فاتح
      case LogStatus.acknowledged:
        return '#c5def5'; // أزرق فاتح
      case LogStatus.inProgress:
        return '#fbca04'; // أصفر
      case LogStatus.resolved:
        return '#0e8a16'; // أخضر
      case LogStatus.closed:
        return '#6f42c1'; // بنفسجي
    }
  }

  /// الحصول على الأيقونة المناسبة
  String get icon {
    switch (this) {
      case LogStatus.newLog:
        return '🆕';
      case LogStatus.acknowledged:
        return '👁️';
      case LogStatus.inProgress:
        return '🔄';
      case LogStatus.resolved:
        return '✅';
      case LogStatus.closed:
        return '🔒';
    }
  }

  /// الحصول على الاسم بالعربية
  String get arabicName {
    switch (this) {
      case LogStatus.newLog:
        return 'جديد';
      case LogStatus.acknowledged:
        return 'تم الاطلاع';
      case LogStatus.inProgress:
        return 'قيد الإصلاح';
      case LogStatus.resolved:
        return 'تم الحل';
      case LogStatus.closed:
        return 'مغلق';
    }
  }
}
