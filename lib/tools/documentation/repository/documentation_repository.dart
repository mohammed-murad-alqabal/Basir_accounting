import 'dart:convert';
import 'dart:io';

import 'package:basir_accounting_system/tools/documentation/analysis/analysis_engine.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

/// مستودع التوثيق
///
/// يدير حفظ واسترجاع تقارير التغطية والإحصائيات
class DocumentationRepository {
  /// إنشاء مستودع التوثيق
  DocumentationRepository({this.reportsPath = '.documentation/reports'});

  /// مسار مجلد التقارير
  final String reportsPath;

  /// حفظ تقرير تغطية
  ///
  /// يحفظ تقرير التغطية في ملف JSON
  ///
  /// Parameters:
  /// - [report]: تقرير التغطية المراد حفظه
  ///
  /// Returns: Future يكتمل عند انتهاء الحفظ
  Future<void> saveCoverageReport(CoverageReport report) async {
    // ignore: avoid_slow_async_io
    final dir = Directory(reportsPath);
    // ignore: avoid_slow_async_io
    if (!await dir.exists()) {
      // ignore: avoid_slow_async_io
      await dir.create(recursive: true);
    }
    final timestamp = report.timestamp.millisecondsSinceEpoch;
    final filename = 'coverage_report_$timestamp.json';
    // ignore: avoid_slow_async_io
    final file = File(p.join(reportsPath, filename));

    // ignore: avoid_slow_async_io
    await file.writeAsString(jsonEncode(report.toJson()));
  }

  /// الحصول على تاريخ التغطية
  ///
  /// يسترجع جميع تقارير التغطية المحفوظة
  ///
  /// Returns: قائمة تقارير التغطية مرتبة حسب التاريخ
  Future<List<CoverageReport>> getCoverageHistory() async {
    // ignore: avoid_slow_async_io
    final dir = Directory(reportsPath);
    // ignore: avoid_slow_async_io
    if (!await dir.exists()) return [];

    final reports = <CoverageReport>[];
    // ignore: avoid_slow_async_io
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.json')) {
        try {
          // ignore: avoid_slow_async_io
          final content = await entity.readAsString();
          final json = jsonDecode(content) as Map<String, dynamic>;
          reports.add(CoverageReport.fromJson(json));
        } on Exception {
          // Ignore bad files
        }
      }
    }
    // Sort by timestamp desc
    reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return reports;
  }

  /// تصدير تقرير
  ///
  /// يصدر التقرير بالصيغة المحددة
  ///
  /// Parameters:
  /// - [format]: صيغة التصدير
  ///
  /// Returns: محتوى التقرير المصدر
  Future<String> exportReport(ReportFormat format) async {
    final latest = await getLatestReport();
    if (latest == null) return '';

    switch (format) {
      case ReportFormat.json:
        return jsonEncode(latest.toJson());
      case ReportFormat.markdown:
        final buf = StringBuffer()
          ..writeln('# تقرير تغطية التوثيق')
          ..writeln()
          ..writeln('*تاريخ الإنشاء: ${latest.timestamp.toIso8601String()}*')
          ..writeln()
          ..writeln('## ملخص')
          ..writeln()
          ..writeln('| المؤشر | القيمة |')
          ..writeln('|--------|-------|')
          ..writeln('| عدد الملفات المحللة | ${latest.analyzedFiles.length} |')
          ..writeln(
              '| نسبة التغطية | ${latest.stats.coveragePercentage.toStringAsFixed(1)}% |')
          ..writeln('| إجمالي العناصر | ${latest.stats.totalElements} |')
          ..writeln('| العناصر الموثقة | ${latest.stats.documentedElements} |')
          ..writeln(
              '| العناصر غير الموثقة | ${latest.stats.undocumentedElements} |')
          ..writeln(
              '| الملفات ذات التغطية المنخفضة | ${latest.lowCoverageFiles.length} |');
        if (latest.lowCoverageFiles.isNotEmpty) {
          buf
            ..writeln()
            ..writeln('## الملفات ذات التغطية المنخفضة')
            ..writeln();
          for (final f in latest.lowCoverageFiles) {
            buf.writeln('- ⚠️ $f');
          }
        }
        return buf.toString();
      case ReportFormat.html:
        return '''
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head><meta charset="UTF-8"><title>تقرير التغطية</title></head>
<body>
<h1>تقرير تغطية التوثيق</h1>
<p>تاريخ الإنشاء: ${latest.timestamp.toIso8601String()}</p>
<ul>
<li>عدد الملفات المحللة: ${latest.analyzedFiles.length}</li>
<li>نسبة التغطية: ${latest.stats.coveragePercentage.toStringAsFixed(1)}%</li>
<li>إجمالي العناصر: ${latest.stats.totalElements}</li>
<li>العناصر الموثقة: ${latest.stats.documentedElements}</li>
<li>العناصر غير الموثقة: ${latest.stats.undocumentedElements}</li>
<li>الملفات ذات التغطية المنخفضة: ${latest.lowCoverageFiles.length}</li>
</ul>
</body>
</html>
''';
      case ReportFormat.csv:
        return [
          'timestamp,coverage_pct,total_elements,documented,undocumented,files_count,low_coverage_count',
          [
            latest.timestamp.toIso8601String(),
            latest.stats.coveragePercentage.toStringAsFixed(2),
            latest.stats.totalElements.toString(),
            latest.stats.documentedElements.toString(),
            latest.stats.undocumentedElements.toString(),
            latest.analyzedFiles.length.toString(),
            latest.lowCoverageFiles.length.toString(),
          ].join(','),
        ].join('\n');
      case ReportFormat.text:
        return '''
=== تقرير تغطية التوثيق ===
تاريخ الإنشاء: ${latest.timestamp.toIso8601String()}

عدد الملفات المحللة: ${latest.analyzedFiles.length}
نسبة التغطية: ${latest.stats.coveragePercentage.toStringAsFixed(1)}%
إجمالي العناصر: ${latest.stats.totalElements}
العناصر الموثقة: ${latest.stats.documentedElements}
العناصر غير الموثقة: ${latest.stats.undocumentedElements}
الملفات ذات التغطية المنخفضة: ${latest.lowCoverageFiles.length}
''';
    }
  }

  /// حذف تقارير قديمة
  ///
  /// يحذف التقارير الأقدم من المدة المحددة
  ///
  /// Parameters:
  /// - [olderThan]: المدة الزمنية
  ///
  /// Returns: عدد التقارير المحذوفة
  Future<int> deleteOldReports(Duration olderThan) async {
    final now = DateTime.now();
    final cutoff = now.subtract(olderThan);
    final history = await getCoverageHistory();
    var count = 0;
    for (final report in history) {
      if (report.timestamp.isBefore(cutoff)) {
        final timestamp = report.timestamp.millisecondsSinceEpoch;
        final filename = 'coverage_report_$timestamp.json';
        // ignore: avoid_slow_async_io
        final file = File(p.join(reportsPath, filename));
        // ignore: avoid_slow_async_io
        if (await file.exists()) {
          // ignore: avoid_slow_async_io
          await file.delete();
          count++;
        }
      }
    }
    return count;
  }

  /// الحصول على آخر تقرير
  ///
  /// يسترجع أحدث تقرير تغطية
  ///
  /// Returns: آخر تقرير أو null إذا لم يوجد
  Future<CoverageReport?> getLatestReport() async {
    final history = await getCoverageHistory();
    if (history.isEmpty) return null;
    return history.first;
  }

  /// حساب الاتجاه
  ///
  /// يحسب اتجاه التغطية (تحسن أم تراجع) عبر مقارنة آخر تقرير بتقرير سابق
  /// ضمن الفترة المحددة
  ///
  /// Parameters:
  /// - [period]: الفترة الزمنية للمقارنة
  ///
  /// Returns: معلومات الاتجاه
  Future<CoverageTrend> calculateTrend(Duration period) async {
    final history = await getCoverageHistory();
    if (history.length < 2) {
      return CoverageTrend(
        direction: TrendDirection.stable,
        changePercentage: 0,
        currentCoverage:
            history.isNotEmpty ? history.first.stats.coveragePercentage : 0,
        previousCoverage: 0,
        period: period,
      );
    }

    final now = DateTime.now();
    final cutoff = now.subtract(period);
    final current = history.first;

    CoverageReport? previous;
    for (final r in history.skip(1)) {
      if (r.timestamp.isBefore(cutoff)) {
        previous = r;
        break;
      }
    }
    previous ??= history.last;

    final change =
        current.stats.coveragePercentage - previous.stats.coveragePercentage;
    final direction = change > 0.5
        ? TrendDirection.improving
        : change < -0.5
            ? TrendDirection.declining
            : TrendDirection.stable;

    return CoverageTrend(
      direction: direction,
      changePercentage: change,
      currentCoverage: current.stats.coveragePercentage,
      previousCoverage: previous.stats.coveragePercentage,
      period: period,
    );
  }
}

/// تقرير التغطية
///
/// يحتوي على معلومات شاملة عن تغطية التوثيق في وقت معين
class CoverageReport {
  /// إنشاء تقرير تغطية
  const CoverageReport({
    required this.timestamp,
    required this.stats,
    required this.analyzedFiles,
    required this.lowCoverageFiles,
    this.notes,
  });

  /// إنشاء من JSON
  factory CoverageReport.fromJson(Map<String, dynamic> json) {
    final statsJson = json['stats'] as Map<String, dynamic>;
    return CoverageReport(
      timestamp: DateTime.parse(json['timestamp'] as String),
      stats: CoverageStats(
        totalElements: statsJson['totalElements'] as int,
        documentedElements: statsJson['documentedElements'] as int,
        undocumentedElements: statsJson['undocumentedElements'] as int,
        coveragePercentage: (statsJson['coveragePercentage'] as num).toDouble(),
        elementBreakdown: const {},
      ),
      analyzedFiles:
          (json['analyzedFiles'] as List<dynamic>?)?.cast<String>() ?? [],
      lowCoverageFiles:
          (json['lowCoverageFiles'] as List<dynamic>?)?.cast<String>() ?? [],
      notes: json['notes'] as String?,
    );
  }

  /// تاريخ التقرير
  final DateTime timestamp;

  /// إحصائيات التغطية
  final CoverageStats stats;

  /// الملفات المحللة
  final List<String> analyzedFiles;

  /// الملفات ذات التغطية المنخفضة
  final List<String> lowCoverageFiles;

  /// ملاحظات إضافية
  final String? notes;

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'stats': {
          'totalElements': stats.totalElements,
          'documentedElements': stats.documentedElements,
          'undocumentedElements': stats.undocumentedElements,
          'coveragePercentage': stats.coveragePercentage,
        },
        'analyzedFiles': analyzedFiles,
        'lowCoverageFiles': lowCoverageFiles,
        'notes': notes,
      };
}

/// صيغة التقرير
enum ReportFormat {
  /// JSON format
  json,

  /// Markdown format
  markdown,

  /// HTML format
  html,

  /// CSV format
  csv,

  /// Plain text format
  text,
}

/// اتجاه التغطية
///
/// يمثل اتجاه تغير التغطية عبر الزمن
class CoverageTrend {
  /// إنشاء اتجاه تغطية
  const CoverageTrend({
    required this.direction,
    required this.changePercentage,
    required this.currentCoverage,
    required this.previousCoverage,
    required this.period,
  });

  /// الاتجاه (تحسن، تراجع، ثابت)
  final TrendDirection direction;

  /// نسبة التغيير
  final double changePercentage;

  /// التغطية الحالية
  final double currentCoverage;

  /// التغطية السابقة
  final double previousCoverage;

  /// الفترة الزمنية
  final Duration period;

  /// هل التغطية تتحسن
  bool get isImproving => direction == TrendDirection.improving;

  /// هل التغطية تتراجع
  bool get isDeclining => direction == TrendDirection.declining;

  /// هل التغطية ثابتة
  bool get isStable => direction == TrendDirection.stable;
}

/// اتجاه الاتجاه
enum TrendDirection {
  /// تحسن
  improving,

  /// تراجع
  declining,

  /// ثابت
  stable,
}
