/// Test Reporting System
///
/// Generates comprehensive reports for test failures, analysis,
/// and actionable insights for development teams.
///
/// **Feature: test-failures-resolution, Property 12: Automated Diagnostics
/// Quality**
/// **Validates: Requirements 6.3, 6.4**
library test_reporter;

// ignore_for_file: avoid_print, avoid_dynamic_calls, lines_longer_than_80_chars
import 'dart:convert';
import 'dart:io';

import 'test_failure_analyzer.dart';
import 'test_monitor.dart';

/// Report format types
enum ReportFormat {
  /// JSON format for programmatic processing
  json,

  /// Markdown format for documentation
  markdown,

  /// HTML format for web display
  html,

  /// CSV format for data analysis
  csv,

  /// Plain text format for simple output
  text,
}

/// Report types
enum ReportType {
  /// Summary report with key metrics
  summary,

  /// Detailed report with full analysis
  detailed,

  /// Executive report for management
  executive,

  /// Technical report for developers
  technical,

  /// Historical report with trends
  historical,
}

/// Main test reporting system
///
/// Provides comprehensive test failure analysis and reporting capabilities
/// with support for multiple output formats and report types.
class TestReporter {
  /// Creates a new TestReporter instance
  ///
  /// [_analyzer] is required for test failure analysis
  /// [_monitor] is optional for monitoring capabilities
  TestReporter(this._analyzer, [this._monitor]);
  final TestFailureAnalyzer _analyzer;
  final TestMonitor? _monitor;

  /// Generates a comprehensive test report
  ///
  /// **Feature: test-failures-resolution, Property 12: Automated Diagnostics
  /// Quality**
  /// **Validates: Requirements 6.3, 6.4**
  Future<String> generateReport({
    required ReportType type,
    required ReportFormat format,
    String? outputPath,
  }) async {
    final reportData = await _gatherReportData(type);
    final content = _formatReport(reportData, format, type);

    if (outputPath != null) {
      final file = File(outputPath);
      await file.parent.create(recursive: true);
      await file.writeAsString(content);
    }

    return content;
  }

  /// Gathers data for report generation
  Future<Map<String, dynamic>> _gatherReportData(ReportType type) async {
    final metrics = _analyzer.generateMetrics();
    final failures = _analyzer.failures;
    final analyses = failures.map(_analyzer.analyzeFailure).toList();

    final data = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'reportType': type.name,
      'metrics': metrics.toJson(),
      'failures': failures.map((f) => f.toJson()).toList(),
      'analyses': analyses.map((a) => a.toJson()).toList(),
    };

    if (_monitor != null) {
      data['history'] = _monitor.history.map((h) => h.toJson()).toList();
      data['alerts'] = _monitor.activeAlerts.map((a) => a.toJson()).toList();
    }

    return data;
  }

  /// Formats report content based on format and type
  String _formatReport(
    Map<String, dynamic> data,
    ReportFormat format,
    ReportType type,
  ) {
    switch (format) {
      case ReportFormat.markdown:
        return _generateMarkdownReport(data, type);
      case ReportFormat.html:
        return _generateHtmlReport(data, type);
      case ReportFormat.csv:
        return _generateCsvReport(data, type);
      case ReportFormat.text:
        return _generateTextReport(data, type);
      case ReportFormat.json:
        return jsonEncode(data);
    }
  }

  /// Generates executive summary report in Markdown
  String _generateMarkdownReport(Map<String, dynamic> data, ReportType type) {
    final buffer = StringBuffer();
    final metrics = data['metrics'] is Map<String, dynamic>
        ? data['metrics'] as Map<String, dynamic>
        : <String, dynamic>{};
    final failures =
        data['failures'] is List ? data['failures'] as List : <dynamic>[];
    final analyses =
        data['analyses'] is List ? data['analyses'] as List : <dynamic>[];

    // Header
    buffer.writeln('# تقرير حالة الاختبارات - ${_getReportTypeName(type)}');
    buffer.writeln();
    final timestamp =
        data['timestamp']?.toString() ?? DateTime.now().toIso8601String();
    buffer.writeln('**التاريخ:** ${DateTime.parse(timestamp).toLocal()}');
    buffer.writeln('**المشروع:** بصير MVP');
    buffer.writeln('**المؤلف:** فريق وكلاء تطوير مشروع بصير');
    buffer.writeln();

    // Executive Summary
    buffer.writeln('## 📊 الملخص التنفيذي');
    buffer.writeln();
    buffer.writeln('| المؤشر | القيمة | الحالة |');
    buffer.writeln('|---------|--------|---------|');
    buffer.writeln('| إجمالي الاختبارات | ${metrics['totalTests'] ?? 0} | - |');
    buffer.writeln(
      '| الاختبارات الناجحة | ${metrics['passedTests'] ?? 0} | ✅ |',
    );
    final failedTests = metrics['failedTests'] as int? ?? 0;
    buffer.writeln(
      '| الاختبارات الفاشلة | $failedTests | '
      '${failedTests > 0 ? '❌' : '✅'} |',
    );
    final successRate = metrics['successRate'] as double? ?? 0.0;
    buffer.writeln(
      '| معدل النجاح | ${successRate.toStringAsFixed(1)}% | '
      '${_getSuccessRateStatus(successRate)} |',
    );
    buffer.writeln(
      '| وقت التنفيذ | ${metrics['totalExecutionTime'] ?? 0} ms | - |',
    );
    buffer.writeln();

    // Failure Breakdown
    if (failures.isNotEmpty) {
      buffer.writeln('## ❌ تصنيف الأخطاء');
      buffer.writeln();

      final failuresByType = metrics['failuresByType'] is Map<String, dynamic>
          ? metrics['failuresByType'] as Map<String, dynamic>
          : <String, dynamic>{};
      for (final entry in failuresByType.entries) {
        final icon = _getFailureTypeIcon(entry.key);
        buffer.writeln(
          '- $icon **${_getFailureTypeName(entry.key)}**: '
          '${entry.value} اختبار',
        );
      }
      buffer.writeln();

      // Top Failures
      buffer.writeln('## 🔍 أهم الأخطاء');
      buffer.writeln();

      for (var i = 0; i < failures.length && i < 5; i++) {
        final failure = failures[i] as Map<String, dynamic>? ?? {};
        final analysis = analyses[i] as Map<String, dynamic>? ?? {};

        buffer.writeln(
          '### ${i + 1}. ${failure['testName'] as String? ?? 'Unknown'}',
        );
        buffer.writeln();
        buffer.writeln(
          '- **الملف:** `${failure['filePath'] as String? ?? 'Unknown'}`',
        );
        buffer.writeln(
          '- **النوع:** '
          '${_getFailureTypeName(failure['type'] as String? ?? 'unknown')}',
        );
        buffer.writeln(
          '- **الأولوية:** '
          '${_getPriorityName(failure['priority'] as String? ?? 'low')}',
        );
        buffer.writeln(
          '- **السبب:** ${analysis['rootCause'] as String? ?? 'غير محدد'}',
        );
        buffer.writeln(
          '- **وقت الإصلاح المقدر:** '
          '${analysis['estimatedFixTime'] as String? ?? '0'} دقيقة',
        );
        buffer.writeln();

        buffer.writeln('**خطوات الإصلاح:**');
        final steps = analysis['resolutionSteps'] is List
            ? analysis['resolutionSteps'] as List
            : <dynamic>[];
        for (var j = 0; j < steps.length; j++) {
          buffer.writeln('${j + 1}. ${steps[j]}');
        }
        buffer.writeln();
      }
    }

    // Recommendations
    buffer.writeln('## 💡 التوصيات');
    buffer.writeln();

    final recommendations = _generateRecommendations(data);
    for (final rec in recommendations) {
      buffer.writeln('- $rec');
    }
    buffer.writeln();

    // Action Plan
    buffer.writeln('## 🎯 خطة العمل');
    buffer.writeln();

    final actionPlan = _generateActionPlan(data);
    for (var i = 0; i < actionPlan.length; i++) {
      buffer.writeln('${i + 1}. ${actionPlan[i]}');
    }
    buffer.writeln();

    // Historical Trends (if available)
    if (data.containsKey('history')) {
      buffer.writeln('## 📈 الاتجاهات التاريخية');
      buffer.writeln();
      buffer.writeln(
        '*البيانات التاريخية متوفرة - راجع التقرير التفصيلي للمزيد*',
      );
      buffer.writeln();
    }

    // Footer
    buffer.writeln('---');
    buffer.writeln('**تم إنشاؤه بواسطة:** نظام مراقبة الاختبارات المتقدم');
    buffer.writeln(
      '**الحالة:** '
      '${failures.isEmpty ? '✅ جميع الاختبارات تعمل' : '⚠️ يتطلب إصلاحات'}',
    );

    return buffer.toString();
  }

  /// Generates HTML report
  String _generateHtmlReport(Map<String, dynamic> data, ReportType type) {
    final buffer = StringBuffer();
    final metrics = data['metrics'] is Map<String, dynamic>
        ? data['metrics'] as Map<String, dynamic>
        : <String, dynamic>{};
    final failures =
        data['failures'] is List ? data['failures'] as List : <dynamic>[];

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html dir="rtl" lang="ar">');
    buffer.writeln('<head>');
    buffer.writeln('    <meta charset="UTF-8">');
    buffer.writeln(
      '    <meta name="viewport" '
      'content="width=device-width, initial-scale=1.0">',
    );
    buffer.writeln(
      '    <title>تقرير حالة الاختبارات - ${_getReportTypeName(type)}</title>',
    );
    buffer.writeln('    <style>');
    buffer.writeln(_getHtmlStyles());
    buffer.writeln('    </style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');

    // Header
    buffer.writeln('    <header>');
    buffer.writeln('        <h1>تقرير حالة الاختبارات</h1>');
    final timestamp =
        data['timestamp'] as String? ?? DateTime.now().toIso8601String();
    buffer.writeln(
      '        <p>المشروع: بصير MVP | '
      'التاريخ: ${DateTime.parse(timestamp).toLocal()}</p>',
    );
    buffer.writeln('    </header>');

    // Metrics Dashboard
    buffer.writeln('    <section class="dashboard">');
    buffer.writeln('        <div class="metric-card">');
    buffer.writeln('            <h3>إجمالي الاختبارات</h3>');
    buffer.writeln(
      '            <div class="metric-value">'
      '${metrics['totalTests'] ?? 0}</div>',
    );
    buffer.writeln('        </div>');
    buffer.writeln('        <div class="metric-card success">');
    buffer.writeln('            <h3>الناجحة</h3>');
    buffer.writeln(
      '            <div class="metric-value">'
      '${metrics['passedTests'] ?? 0}</div>',
    );
    buffer.writeln('        </div>');
    buffer.writeln(
      '        <div class="metric-card '
      '${failures.isNotEmpty ? 'error' : 'success'}">',
    );
    buffer.writeln('            <h3>الفاشلة</h3>');
    buffer.writeln(
      '            <div class="metric-value">'
      '${metrics['failedTests'] ?? 0}</div>',
    );
    buffer.writeln('        </div>');
    buffer.writeln('        <div class="metric-card">');
    buffer.writeln('            <h3>معدل النجاح</h3>');
    final successRate = metrics['successRate'] as double? ?? 0.0;
    buffer.writeln(
      '            <div class="metric-value">'
      '${successRate.toStringAsFixed(1)}%</div>',
    );
    buffer.writeln('        </div>');
    buffer.writeln('    </section>');

    // Failures Section
    if (failures.isNotEmpty) {
      buffer.writeln('    <section class="failures">');
      buffer.writeln('        <h2>الأخطاء المكتشفة</h2>');

      for (final rawFailure in failures.take(10)) {
        final failure = rawFailure as Map<String, dynamic>? ?? {};
        buffer.writeln('        <div class="failure-card">');
        buffer.writeln('            <h3>${failure['testName']}</h3>');
        buffer.writeln(
          '            <p><strong>الملف:</strong> '
          '${failure['filePath'] as String? ?? 'Unknown'}</p>',
        );
        buffer.writeln(
          '            <p><strong>النوع:</strong> '
          '${_getFailureTypeName(failure['type'] as String? ?? 'unknown')}'
          '</p>',
        );
        buffer.writeln(
          '            <p><strong>الأولوية:</strong> '
          '${_getPriorityName(failure['priority'] as String? ?? 'low')}'
          '</p>',
        );
        buffer.writeln('        </div>');
      }

      buffer.writeln('    </section>');
    }

    buffer.writeln('    <footer>');
    buffer.writeln(
      '        <p>تم إنشاؤه بواسطة: نظام مراقبة الاختبارات المتقدم</p>',
    );
    buffer.writeln('    </footer>');
    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  /// Generates CSV report
  String _generateCsvReport(Map<String, dynamic> data, ReportType type) {
    final buffer = StringBuffer();
    final failures =
        data['failures'] is List ? data['failures'] as List : <dynamic>[];

    // Header
    buffer.writeln('Test Name,File Path,Type,Priority,Error Message,Timestamp');

    // Data rows
    for (final rawFailure in failures) {
      final failure = rawFailure as Map<String, dynamic>? ?? {};
      buffer.writeln(
        [
          _escapeCsv(failure['testName'] as String? ?? ''),
          _escapeCsv(failure['filePath'] as String? ?? ''),
          _escapeCsv(failure['type'] as String? ?? ''),
          _escapeCsv(failure['priority'] as String? ?? ''),
          _escapeCsv(failure['errorMessage'] as String? ?? ''),
          _escapeCsv(failure['timestamp'] as String? ?? ''),
        ].join(','),
      );
    }

    return buffer.toString();
  }

  /// Generates plain text report
  String _generateTextReport(Map<String, dynamic> data, ReportType type) {
    final buffer = StringBuffer();
    final metrics = data['metrics'] is Map<String, dynamic>
        ? data['metrics'] as Map<String, dynamic>
        : <String, dynamic>{};
    final failures =
        data['failures'] is List ? data['failures'] as List : <dynamic>[];

    buffer.writeln('تقرير حالة الاختبارات - ${_getReportTypeName(type)}');
    buffer.writeln('=' * 60);
    final timestamp =
        data['timestamp'] as String? ?? DateTime.now().toIso8601String();
    buffer.writeln('التاريخ: ${DateTime.parse(timestamp).toLocal()}');
    buffer.writeln('المشروع: بصير MVP');
    buffer.writeln();

    buffer.writeln('الملخص:');
    buffer.writeln('-' * 30);
    buffer.writeln('إجمالي الاختبارات: ${metrics['totalTests'] ?? 0}');
    buffer.writeln('الناجحة: ${metrics['passedTests'] ?? 0}');
    buffer.writeln('الفاشلة: ${metrics['failedTests'] ?? 0}');
    final successRate = metrics['successRate'] as double? ?? 0.0;
    buffer.writeln('معدل النجاح: ${successRate.toStringAsFixed(1)}%');
    buffer.writeln();

    if (failures.isNotEmpty) {
      buffer.writeln('الأخطاء:');
      buffer.writeln('-' * 30);

      for (var i = 0; i < failures.length && i < 10; i++) {
        final failure = failures[i] as Map<String, dynamic>? ?? {};
        buffer.writeln(
          '${i + 1}. ${failure['testName'] as String? ?? 'Unknown'}',
        );
        buffer.writeln(
          '   الملف: ${failure['filePath'] as String? ?? 'Unknown'}',
        );
        buffer.writeln(
          '   النوع: '
          '${_getFailureTypeName(failure['type'] as String? ?? 'unknown')}',
        );
        buffer.writeln(
          '   الأولوية: '
          '${_getPriorityName(failure['priority'] as String? ?? 'low')}',
        );
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  /// Helper methods
  List<String> _generateRecommendations(Map<String, dynamic> data) {
    final recommendations = <String>[];
    final metrics = data['metrics'] is Map<String, dynamic>
        ? data['metrics'] as Map<String, dynamic>
        : <String, dynamic>{};
    final failuresByType = metrics['failuresByType'] is Map<String, dynamic>
        ? metrics['failuresByType'] as Map<String, dynamic>
        : <String, dynamic>{};

    if (failuresByType.containsKey('golden') &&
        (failuresByType['golden'] as int? ?? 0) > 0) {
      recommendations.add(
        '🎨 تحديث Golden Tests باستخدام: flutter test --update-goldens',
      );
    }

    if (failuresByType.containsKey('integration') &&
        (failuresByType['integration'] as int? ?? 0) > 0) {
      recommendations.add('🔗 فحص ملفات CLI المفقودة في Integration Tests');
    }

    if (failuresByType.containsKey('ui') &&
        (failuresByType['ui'] as int? ?? 0) > 0) {
      recommendations.add('📱 مراجعة مشاكل overflow في واجهة المستخدم');
    }

    final successRate = metrics['successRate'] as double? ?? 0.0;
    if (successRate < 90.0) {
      recommendations.add('⚠️ معدل النجاح منخفض - يتطلب تدخل فوري');
    }

    return recommendations;
  }

  List<String> _generateActionPlan(Map<String, dynamic> data) {
    final actionPlan = <String>[];
    final failures =
        data['failures'] is List ? data['failures'] as List : <dynamic>[];

    // Sort failures by priority
    failures.sort(
      (a, b) => _getPriorityWeight(
        (a as Map<String, dynamic>?)?['priority'] as String? ?? 'low',
      ).compareTo(
        _getPriorityWeight(
          (b as Map<String, dynamic>?)?['priority'] as String? ?? 'low',
        ),
      ),
    );

    actionPlan.add('إصلاح الأخطاء ذات الأولوية العالية أولاً');
    actionPlan.add('تشغيل تحليل شامل للأخطاء');
    actionPlan.add('تحديث الاختبارات والملفات المرجعية');
    actionPlan.add('إجراء اختبار شامل للتأكد من الإصلاحات');
    actionPlan.add('مراقبة مستمرة لمنع تكرار المشاكل');

    return actionPlan;
  }

  // Utility methods
  String _getReportTypeName(ReportType type) {
    switch (type) {
      case ReportType.summary:
        return 'ملخص';
      case ReportType.detailed:
        return 'مفصل';
      case ReportType.executive:
        return 'تنفيذي';
      case ReportType.technical:
        return 'تقني';
      case ReportType.historical:
        return 'تاريخي';
    }
  }

  String _getSuccessRateStatus(double rate) {
    if (rate >= 95.0) return '🟢';
    if (rate >= 85.0) return '🟡';
    return '🔴';
  }

  String _getFailureTypeIcon(String type) {
    switch (type) {
      case 'golden':
        return '🎨';
      case 'integration':
        return '🔗';
      case 'ui':
        return '📱';
      case 'unit':
        return '🧪';
      case 'timeout':
        return '⏰';
      default:
        return '❓';
    }
  }

  String _getFailureTypeName(String type) {
    switch (type) {
      case 'golden':
        return 'Golden Tests';
      case 'integration':
        return 'Integration Tests';
      case 'ui':
        return 'UI Tests';
      case 'unit':
        return 'Unit Tests';
      case 'timeout':
        return 'Timeout';
      default:
        return 'Unknown';
    }
  }

  String _getPriorityName(String priority) {
    switch (priority) {
      case 'critical':
        return 'حرجة';
      case 'high':
        return 'عالية';
      case 'medium':
        return 'متوسطة';
      case 'low':
        return 'منخفضة';
      default:
        return 'غير محدد';
    }
  }

  int _getPriorityWeight(String priority) {
    switch (priority) {
      case 'critical':
        return 0;
      case 'high':
        return 1;
      case 'medium':
        return 2;
      case 'low':
        return 3;
      default:
        return 4;
    }
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  String _getHtmlStyles() => '''
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
            direction: rtl;
        }
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .metric-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .metric-card.success {
            border-left: 5px solid #4CAF50;
        }
        .metric-card.error {
            border-left: 5px solid #f44336;
        }
        .metric-value {
            font-size: 2em;
            font-weight: bold;
            margin-top: 10px;
        }
        .failures {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .failure-card {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
            background: #fafafa;
        }
        footer {
            text-align: center;
            margin-top: 30px;
            color: #666;
        }
    ''';
}
