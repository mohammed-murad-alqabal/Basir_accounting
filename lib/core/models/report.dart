import 'package:basir_accounting_system/core/models/log_entry.dart';

/// نموذج بيانات لتقرير شامل عن حالة المشروع.
///
/// يحتوي على إحصائيات المشروع، ملخص الأخطاء، نتائج الاختبارات،
/// والتوصيات للتحسين.
///
/// مثال:
/// ```dart
/// final report = Report(
///   id: 'report-001',
///   generatedAt: DateTime.now(),
///   statistics: ProjectStatistics(...),
///   errors: [ErrorSummary(...)],
///   testResults: TestResults(...),
///   recommendations: [Recommendation(...)],
///,);
/// ```
class Report {
  /// ينشئ تقرير جديد.
  const Report({
    required this.id,
    required this.generatedAt,
    required this.statistics,
    required this.errors,
    required this.testResults,
    required this.recommendations,
  });

  /// ينشئ تقرير من Map (JSON).
  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json['id'] as String,
        generatedAt: DateTime.parse(json['generatedAt'] as String),
        statistics: ProjectStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>,
        ),
        errors: (json['errors'] as List)
            .map((e) => ErrorSummary.fromJson(e as Map<String, dynamic>))
            .toList(),
        testResults: TestResults.fromJson(
          json['testResults'] as Map<String, dynamic>,
        ),
        recommendations: (json['recommendations'] as List)
            .map((r) => Recommendation.fromJson(r as Map<String, dynamic>))
            .toList(),
      );

  /// معرف فريد للتقرير.
  final String id;

  /// وقت إنشاء التقرير.
  final DateTime generatedAt;

  /// إحصائيات المشروع.
  final ProjectStatistics statistics;

  /// ملخص الأخطاء والتحذيرات.
  final List<ErrorSummary> errors;

  /// نتائج الاختبارات.
  final TestResults testResults;

  /// التوصيات للتحسين.
  final List<Recommendation> recommendations;

  /// يحول التقرير إلى نص Markdown.
  String toMarkdown() {
    final buffer = StringBuffer();

    // العنوان
    buffer.writeln('# تقرير حالة المشروع');
    buffer.writeln();
    buffer.writeln('**التاريخ:** ${_formatDate(generatedAt)}');
    buffer.writeln('**المعرف:** $id');
    buffer.writeln();

    // الإحصائيات
    buffer.writeln('## إحصائيات المشروع');
    buffer.writeln();
    buffer.writeln('- **عدد الملفات:** ${statistics.fileCount}');
    buffer.writeln('- **حجم المشروع:** ${statistics.projectSize}');
    buffer.writeln('- **عدد الـ Commits:** ${statistics.commitCount}');
    buffer.writeln('- **عدد الأسطر:** ${statistics.totalLines}');
    buffer.writeln();

    // الأخطاء
    if (errors.isNotEmpty) {
      buffer.writeln('## ملخص الأخطاء والتحذيرات');
      buffer.writeln();
      for (final error in errors) {
        buffer.writeln('### ${error.type.name}');
        buffer.writeln('- **العدد:** ${error.count}');
        if (error.topErrors.isNotEmpty) {
          buffer.writeln('- **الأكثر شيوعاً:**');
          for (final topError in error.topErrors.take(5)) {
            buffer.writeln('  - $topError');
          }
        }
        buffer.writeln();
      }
    }

    // نتائج الاختبارات
    buffer.writeln('## نتائج الاختبارات');
    buffer.writeln();
    buffer.writeln('- **إجمالي الاختبارات:** ${testResults.totalTests}');
    buffer.writeln('- **نجح:** ${testResults.passedTests}');
    buffer.writeln('- **فشل:** ${testResults.failedTests}');
    buffer.writeln(
      '- **التغطية:** ${testResults.coveragePercentage.toStringAsFixed(1)}%',
    );
    buffer.writeln(
      '- **وقت التنفيذ:** ${testResults.executionTime.inSeconds} ثانية',
    );
    buffer.writeln();

    // التوصيات
    if (recommendations.isNotEmpty) {
      buffer.writeln('## التوصيات');
      buffer.writeln();
      for (final rec in recommendations) {
        buffer.writeln('### ${rec.title}');
        buffer.writeln('**الأولوية:** ${rec.priority.name}');
        buffer.writeln();
        buffer.writeln(rec.description);
        buffer.writeln();
        if (rec.actionItems.isNotEmpty) {
          buffer.writeln('**الإجراءات المطلوبة:**');
          for (final action in rec.actionItems) {
            buffer.writeln('- $action');
          }
          buffer.writeln();
        }
      }
    }

    return buffer.toString();
  }

  /// يحول التقرير إلى Map (JSON).
  ///
  /// Returns Map يحتوي على جميع بيانات التقرير بصيغة JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'generatedAt': generatedAt.toIso8601String(),
        'statistics': statistics.toJson(),
        'errors': errors.map((e) => e.toJson()).toList(),
        'testResults': testResults.toJson(),
        'recommendations': recommendations.map((r) => r.toJson()).toList(),
      };

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
}

/// إحصائيات المشروع.
///
/// يحتوي على معلومات إحصائية عن المشروع مثل عدد الملفات،
/// حجم المشروع، عدد الـ commits، وإجمالي عدد الأسطر.
class ProjectStatistics {
  /// ينشئ إحصائيات مشروع جديدة.
  const ProjectStatistics({
    required this.fileCount,
    required this.projectSize,
    required this.commitCount,
    required this.totalLines,
    this.filesByType = const {},
  });

  /// ينشئ إحصائيات من Map (JSON).
  factory ProjectStatistics.fromJson(Map<String, dynamic> json) =>
      ProjectStatistics(
        fileCount: json['fileCount'] as int,
        projectSize: json['projectSize'] as String,
        commitCount: json['commitCount'] as int,
        totalLines: json['totalLines'] as int,
        filesByType: Map<String, int>.from(json['filesByType'] as Map? ?? {}),
      );

  /// عدد الملفات.
  final int fileCount;

  /// حجم المشروع.
  final String projectSize;

  /// عدد الـ commits.
  final int commitCount;

  /// إجمالي عدد الأسطر.
  final int totalLines;

  /// عدد الملفات حسب النوع.
  final Map<String, int> filesByType;

  /// يحول الإحصائيات إلى Map (JSON).
  Map<String, dynamic> toJson() => {
        'fileCount': fileCount,
        'projectSize': projectSize,
        'commitCount': commitCount,
        'totalLines': totalLines,
        'filesByType': filesByType,
      };
}

/// ملخص الأخطاء.
///
/// يحتوي على معلومات عن الأخطاء والتحذيرات في المشروع،
/// بما في ذلك العدد الإجمالي وأكثر الأخطاء شيوعاً.
class ErrorSummary {
  /// ينشئ ملخص أخطاء جديد.
  const ErrorSummary({
    required this.type,
    required this.count,
    this.topErrors = const [],
    this.errorsByFile = const {},
  });

  /// ينشئ ملخص أخطاء من Map (JSON).
  factory ErrorSummary.fromJson(Map<String, dynamic> json) => ErrorSummary(
        type: LogType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => LogType.error,
        ),
        count: json['count'] as int,
        topErrors: List<String>.from(json['topErrors'] as List? ?? []),
        errorsByFile: Map<String, int>.from(json['errorsByFile'] as Map? ?? {}),
      );

  /// نوع السجل.
  final LogType type;

  /// عدد الأخطاء.
  final int count;

  /// أكثر الأخطاء شيوعاً.
  final List<String> topErrors;

  /// الأخطاء حسب الملف.
  final Map<String, int> errorsByFile;

  /// يحول ملخص الأخطاء إلى Map (JSON).
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'count': count,
        'topErrors': topErrors,
        'errorsByFile': errorsByFile,
      };
}

/// نتائج الاختبارات.
///
/// يحتوي على معلومات عن نتائج تشغيل الاختبارات،
/// بما في ذلك عدد الاختبارات الناجحة والفاشلة ونسبة التغطية.
class TestResults {
  /// ينشئ نتائج اختبارات جديدة.
  const TestResults({
    required this.totalTests,
    required this.passedTests,
    required this.failedTests,
    required this.coveragePercentage,
    required this.executionTime,
  });

  /// ينشئ نتائج اختبارات من Map (JSON).
  factory TestResults.fromJson(Map<String, dynamic> json) => TestResults(
        totalTests: json['totalTests'] as int,
        passedTests: json['passedTests'] as int,
        failedTests: json['failedTests'] as int,
        coveragePercentage: (json['coveragePercentage'] as num).toDouble(),
        executionTime: Duration(seconds: json['executionTimeSeconds'] as int),
      );

  /// إجمالي عدد الاختبارات.
  final int totalTests;

  /// عدد الاختبارات الناجحة.
  final int passedTests;

  /// عدد الاختبارات الفاشلة.
  final int failedTests;

  /// نسبة التغطية.
  final double coveragePercentage;

  /// وقت التنفيذ.
  final Duration executionTime;

  /// يحول نتائج الاختبارات إلى Map (JSON).
  Map<String, dynamic> toJson() => {
        'totalTests': totalTests,
        'passedTests': passedTests,
        'failedTests': failedTests,
        'coveragePercentage': coveragePercentage,
        'executionTimeSeconds': executionTime.inSeconds,
      };
}

/// توصية للتحسين.
///
/// تحتوي على اقتراح لتحسين المشروع مع تحديد الأولوية
/// والإجراءات المطلوبة لتنفيذ التوصية.
class Recommendation {
  /// ينشئ توصية جديدة.
  const Recommendation({
    required this.title,
    required this.description,
    required this.priority,
    this.actionItems = const [],
  });

  /// ينشئ توصية من Map (JSON).
  factory Recommendation.fromJson(Map<String, dynamic> json) => Recommendation(
        title: json['title'] as String,
        description: json['description'] as String,
        priority: RecommendationPriority.values.firstWhere(
          (e) => e.name == json['priority'],
          orElse: () => RecommendationPriority.medium,
        ),
        actionItems: List<String>.from(json['actionItems'] as List? ?? []),
      );

  /// عنوان التوصية.
  final String title;

  /// وصف التوصية.
  final String description;

  /// أولوية التوصية.
  final RecommendationPriority priority;

  /// الإجراءات المطلوبة.
  final List<String> actionItems;

  /// يحول التوصية إلى Map (JSON).
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'priority': priority.name,
        'actionItems': actionItems,
      };
}

/// أولويات التوصيات.
enum RecommendationPriority {
  /// حرج - يتطلب إصلاح فوري.
  critical,

  /// عالي - يجب إصلاحه قريباً.
  high,

  /// متوسط - يمكن إصلاحه لاحقاً.
  medium,

  /// منخفض - اختياري.
  low,
}
