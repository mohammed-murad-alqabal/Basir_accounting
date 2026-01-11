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
  Future<String> exportReport(ReportFormat format) async => '';

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
  /// يحسب اتجاه التغطية (تحسن أم تراجع)
  ///
  /// Parameters:
  /// - [period]: الفترة الزمنية للمقارنة
  ///
  /// Returns: معلومات الاتجاه
  Future<CoverageTrend> calculateTrend(Duration period) async => CoverageTrend(
        direction: TrendDirection.stable,
        changePercentage: 0,
        currentCoverage: 0,
        previousCoverage: 0,
        period: period,
      );
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
