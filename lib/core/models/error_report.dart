import 'package:basser_app/core/models/log_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_report.freezed.dart';
part 'error_report.g.dart';

/// يمثل تقرير شامل لحالة المشروع والأخطاء.
///
/// يحتوي على إحصائيات المشروع، ملخص الأخطاء، نتائج الاختبارات،
/// والتوصيات.
///
/// مثال:
/// ```dart
/// final report = ErrorReport(
///   id: 'report-001',
///   timestamp: DateTime.now(),
///   projectStats: ProjectStats(...),
///   errorSummary: ErrorSummary(...),
///   testResults: TestResults(...),
///   recommendations: ['إصلاح الأخطاء الحرجة'],
/// );
/// ```
@freezed
class ErrorReport with _$ErrorReport {
  /// إنشاء تقرير شامل لحالة المشروع.
  const factory ErrorReport({
    /// معرف فريد للتقرير
    required String id,

    /// وقت إنشاء التقرير
    required DateTime timestamp,

    /// إحصائيات المشروع
    required ProjectStats projectStats,

    /// ملخص الأخطاء
    required ErrorSummary errorSummary,

    /// نتائج الاختبارات
    required TestResults testResults,

    /// التوصيات
    @Default([]) List<String> recommendations,

    /// نقاط الجودة (0-100)
    int? qualityScore,

    /// التقييم (A+, A, B, C, D)
    String? grade,

    /// السجلات المرفقة
    @Default([]) List<LogEntry> logs,

    /// معلومات إضافية
    Map<String, dynamic>? metadata,
  }) = _ErrorReport;

  /// إنشاء تقرير من JSON.
  factory ErrorReport.fromJson(Map<String, dynamic> json) =>
      _$ErrorReportFromJson(json);
}

/// إحصائيات المشروع
@freezed
class ProjectStats with _$ProjectStats {
  /// إنشاء إحصائيات المشروع.
  const factory ProjectStats({
    /// عدد ملفات Dart
    @Default(0) int dartFiles,

    /// إجمالي الأسطر
    @Default(0) int totalLines,

    /// حجم المشروع (بالميجابايت)
    @Default(0.0) double projectSize,

    /// عدد Commits
    @Default(0) int commits,

    /// آخر commit
    DateTime? lastCommit,

    /// الفرع الحالي
    String? currentBranch,

    /// إصدار Flutter
    String? flutterVersion,

    /// إصدار Dart
    String? dartVersion,
  }) = _ProjectStats;

  /// إنشاء إحصائيات المشروع من JSON.
  factory ProjectStats.fromJson(Map<String, dynamic> json) =>
      _$ProjectStatsFromJson(json);
}

/// ملخص الأخطاء
@freezed
class ErrorSummary with _$ErrorSummary {
  /// إنشاء ملخص الأخطاء.
  const factory ErrorSummary({
    /// عدد الأخطاء
    @Default(0) int errorCount,

    /// عدد التحذيرات
    @Default(0) int warningCount,

    /// عدد المعلومات
    @Default(0) int infoCount,

    /// الأخطاء الحرجة
    @Default([]) List<LogEntry> criticalErrors,

    /// الأخطاء حسب النوع
    @Default({}) Map<String, int> errorsByType,

    /// الأخطاء حسب الملف
    @Default({}) Map<String, int> errorsByFile,

    /// الأخطاء الأكثر تكراراً
    @Default([]) List<LogEntry> topErrors,
  }) = _ErrorSummary;

  /// إنشاء ملخص الأخطاء من JSON.
  factory ErrorSummary.fromJson(Map<String, dynamic> json) =>
      _$ErrorSummaryFromJson(json);
}

/// نتائج الاختبارات
@freezed
class TestResults with _$TestResults {
  /// إنشاء نتائج الاختبارات.
  const factory TestResults({
    /// عدد الاختبارات الناجحة
    @Default(0) int passed,

    /// عدد الاختبارات الفاشلة
    @Default(0) int failed,

    /// عدد الاختبارات المتخطاة
    @Default(0) int skipped,

    /// إجمالي الاختبارات
    @Default(0) int total,

    /// نسبة التغطية
    double? coverage,

    /// وقت التنفيذ (بالثواني)
    double? duration,

    /// الاختبارات الفاشلة
    @Default([]) List<String> failedTests,
  }) = _TestResults;

  /// إنشاء نتائج الاختبارات من JSON.
  factory TestResults.fromJson(Map<String, dynamic> json) =>
      _$TestResultsFromJson(json);
}

/// Extension methods لـ ErrorReport
extension ErrorReportExtension on ErrorReport {
  /// حساب نقاط الجودة
  int calculateQualityScore() {
    var score = 100;

    // خصم نقاط للأخطاء
    score -= errorSummary.errorCount * 10;

    // خصم نقاط للتحذيرات
    score -= errorSummary.warningCount * 2;

    // خصم نقاط للاختبارات الفاشلة
    score -= testResults.failed * 5;

    // التأكد من أن النقاط لا تقل عن 0
    if (score < 0) score = 0;

    return score;
  }

  /// تحديد التقييم بناءً على النقاط
  String calculateGrade() {
    final score = qualityScore ?? calculateQualityScore();

    if (score >= 90) return 'A+';
    if (score >= 80) return 'A';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    return 'D';
  }

  /// التحقق من وجود أخطاء حرجة
  bool get hasCriticalErrors => errorSummary.errorCount > 0;

  /// التحقق من وجود اختبارات فاشلة
  bool get hasFailedTests => testResults.failed > 0;

  /// التحقق من جودة مقبولة
  bool get isQualityAcceptable {
    final score = qualityScore ?? calculateQualityScore();
    return score >= 70;
  }

  /// الحصول على الأيقونة المناسبة للتقييم
  String get gradeIcon {
    final grade = this.grade ?? calculateGrade();
    switch (grade) {
      case 'A+':
        return '🌟';
      case 'A':
        return '✅';
      case 'B':
        return '👍';
      case 'C':
        return '⚠️';
      default:
        return '❌';
    }
  }

  /// إنشاء ملخص نصي للتقرير
  String toSummaryText() {
    final buffer = StringBuffer();

    buffer.writeln('# تقرير جودة الكود');
    buffer.writeln();
    buffer.writeln('**التاريخ:** ${timestamp.toIso8601String()}');
    buffer
        .writeln('**النقاط:** ${qualityScore ?? calculateQualityScore()}/100');
    buffer.writeln('**التقييم:** ${grade ?? calculateGrade()} $gradeIcon');
    buffer.writeln();

    buffer.writeln('## إحصائيات المشروع');
    buffer.writeln('- ملفات Dart: ${projectStats.dartFiles}');
    buffer.writeln('- إجمالي الأسطر: ${projectStats.totalLines}');
    buffer.writeln(
      '- حجم المشروع: ${projectStats.projectSize.toStringAsFixed(2)} MB',
    );
    buffer.writeln();

    buffer.writeln('## ملخص الأخطاء');
    buffer.writeln('- أخطاء: ${errorSummary.errorCount}');
    buffer.writeln('- تحذيرات: ${errorSummary.warningCount}');
    buffer.writeln('- معلومات: ${errorSummary.infoCount}');
    buffer.writeln();

    buffer.writeln('## نتائج الاختبارات');
    buffer.writeln('- نجح: ${testResults.passed}');
    buffer.writeln('- فشل: ${testResults.failed}');
    buffer.writeln('- تم تخطيه: ${testResults.skipped}');
    if (testResults.coverage != null) {
      buffer.writeln('- التغطية: ${testResults.coverage!.toStringAsFixed(1)}%');
    }
    buffer.writeln();

    if (recommendations.isNotEmpty) {
      buffer.writeln('## التوصيات');
      for (final recommendation in recommendations) {
        buffer.writeln('- $recommendation');
      }
    }

    return buffer.toString();
  }
}
