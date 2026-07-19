import 'package:flutter/foundation.dart';

/// نموذج بيانات لإدخال سجل في نظام تتبع الأخطاء.
///
/// يمثل هذا الكلاس إدخال سجل واحد يحتوي على جميع المعلومات
/// المتعلقة بخطأ أو تحذير أو معلومة في النظام.
///
/// مثال:
/// ```dart
/// final logEntry = LogEntry(
///   id: 'log-001',
///   timestamp: DateTime.now(),
///   type: LogType.error,
///   level: LogLevel.critical,
///   message: 'فشل في تحميل البيانات',
///   filePath: 'lib/features/customers/customer_repository.dart',
///   lineNumber: 42,
///   metadata: {'userId': '123', 'action': 'load'},
///,);
/// ```
@immutable
class LogEntry {
  /// ينشئ إدخال سجل جديد.
  const LogEntry({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.level,
    required this.message,
    this.filePath,
    this.lineNumber,
    this.metadata = const {},
  });

  /// ينشئ سجل من Map (JSON).
  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        type: LogType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => LogType.info,
        ),
        level: LogLevel.values.firstWhere(
          (e) => e.name == json['level'],
          orElse: () => LogLevel.info,
        ),
        message: json['message'] as String,
        filePath: json['filePath'] as String?,
        lineNumber: json['lineNumber'] as int?,
        metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
      );

  /// معرف فريد للسجل.
  final String id;

  /// وقت إنشاء السجل.
  final DateTime timestamp;

  /// نوع السجل (تحليل، اختبار، خطأ، إلخ).
  final LogType type;

  /// مستوى خطورة السجل.
  final LogLevel level;

  /// رسالة السجل.
  final String message;

  /// مسار الملف المرتبط بالسجل (اختياري).
  final String? filePath;

  /// رقم السطر في الملف (اختياري).
  final int? lineNumber;

  /// بيانات إضافية مرتبطة بالسجل.
  final Map<String, dynamic> metadata;

  /// ينشئ نسخة من السجل مع تعديل بعض الحقول.
  LogEntry copyWith({
    String? id,
    DateTime? timestamp,
    LogType? type,
    LogLevel? level,
    String? message,
    String? filePath,
    int? lineNumber,
    Map<String, dynamic>? metadata,
  }) =>
      LogEntry(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        type: type ?? this.type,
        level: level ?? this.level,
        message: message ?? this.message,
        filePath: filePath ?? this.filePath,
        lineNumber: lineNumber ?? this.lineNumber,
        metadata: metadata ?? this.metadata,
      );

  /// يحول السجل إلى Map لحفظه في JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'type': type.name,
        'level': level.name,
        'message': message,
        'filePath': filePath,
        'lineNumber': lineNumber,
        'metadata': metadata,
      };

  @override
  String toString() =>
      'LogEntry(id: $id, type: $type, level: $level, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LogEntry &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.type == type &&
        other.level == level &&
        other.message == message &&
        other.filePath == filePath &&
        other.lineNumber == lineNumber;
  }

  @override
  int get hashCode =>
      Object.hash(id, timestamp, type, level, message, filePath, lineNumber);
}

/// أنواع السجلات المختلفة.
enum LogType {
  /// سجل من Flutter Analyze.
  analyze,

  /// سجل من الاختبارات.
  test,

  /// سجل خطأ.
  error,

  /// سجل تحذير.
  warning,

  /// سجل معلومات.
  info,

  /// سجل تصحيح.
  debug,
}

/// مستويات خطورة السجلات.
enum LogLevel {
  /// خطأ حرج يتطلب إصلاح فوري.
  critical,

  /// خطأ يجب إصلاحه.
  error,

  /// تحذير يجب مراجعته.
  warning,

  /// معلومات عامة.
  info,

  /// معلومات تصحيح.
  debug,
}
