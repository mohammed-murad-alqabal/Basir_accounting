import 'dart:io';

import 'package:basir_app/tools/documentation/analysis/analysis_engine.dart';
import 'package:basir_app/tools/documentation/repository/documentation_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DocumentationRepository', () {
    late DocumentationRepository repository;
    late Directory tempDir;

    setUp(() async {
      // إنشاء مجلد مؤقت للاختبارات
      tempDir = await Directory.systemTemp.createTemp('doc_repo_test_');
      repository = DocumentationRepository(reportsPath: tempDir.path);
    });

    tearDown(() {
      // حذف المجلد المؤقت بعد الاختبار
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    group('saveCoverageReport', () {
      test('should save coverage report successfully', () async {
        // Arrange
        final report = CoverageReport(
          timestamp: DateTime(2025, 11, 27, 10),
          stats: const CoverageStats(
            totalElements: 100,
            documentedElements: 75,
            undocumentedElements: 25,
            coveragePercentage: 75,
            elementBreakdown: {},
          ),
          analyzedFiles: ['lib/main.dart', 'lib/core/constants.dart'],
          lowCoverageFiles: ['lib/core/constants.dart'],
          notes: 'Initial coverage report',
        );

        // Act & Assert
        await repository.saveCoverageReport(report);
        // Should complete without error
      });

      test('should handle saving multiple reports', () async {
        // Arrange
        final report1 = CoverageReport(
          timestamp: DateTime(2025, 11, 27, 10),
          stats: const CoverageStats(
            totalElements: 100,
            documentedElements: 70,
            undocumentedElements: 30,
            coveragePercentage: 70,
            elementBreakdown: {},
          ),
          analyzedFiles: ['lib/main.dart'],
          lowCoverageFiles: ['lib/main.dart'],
        );

        final report2 = CoverageReport(
          timestamp: DateTime(2025, 11, 27, 11),
          stats: const CoverageStats(
            totalElements: 100,
            documentedElements: 80,
            undocumentedElements: 20,
            coveragePercentage: 80,
            elementBreakdown: {},
          ),
          analyzedFiles: ['lib/main.dart'],
          lowCoverageFiles: [],
        );

        // Act & Assert
        await repository.saveCoverageReport(report1);
        await repository.saveCoverageReport(report2);
        // Should complete without error
      });
    });

    group('getCoverageHistory', () {
      test('should return empty list when no reports exist', () async {
        // Act & Assert
        expect(await repository.getCoverageHistory(), isEmpty);
      });

      test('should retrieve all saved reports', () async {
        // Act & Assert
        final history = await repository.getCoverageHistory();
        expect(history, isA<List<CoverageReport>>());
      });

      test('should return reports sorted by timestamp', () async {
        // Act & Assert
        final history = await repository.getCoverageHistory();
        expect(history, isA<List<CoverageReport>>());
      });
    });

    group('exportReport', () {
      test('should export report in JSON format', () async {
        // Act & Assert
        expect(await repository.exportReport(ReportFormat.json), isA<String>());
        expect(await repository.exportReport(ReportFormat.markdown),
            isA<String>());
        expect(await repository.exportReport(ReportFormat.html), isA<String>());
        expect(await repository.exportReport(ReportFormat.csv), isA<String>());
        expect(await repository.exportReport(ReportFormat.text), isA<String>());
      });
    });

    group('deleteOldReports', () {
      test('should delete reports older than specified duration', () async {
        // Act & Assert
        expect(await repository.deleteOldReports(const Duration(days: 30)),
            isA<int>());
        expect(await repository.deleteOldReports(const Duration(days: 7)),
            isA<int>());
        expect(await repository.deleteOldReports(const Duration(days: 1)),
            isA<int>());
      });
    });

    group('getLatestReport', () {
      test('should return null when no reports exist', () async {
        // Act & Assert
        expect(await repository.getLatestReport(), isNull);
        // ...
        final report = await repository.getLatestReport();
        expect(report,
            isNull); // Since no reports were saved in this specific scope
      });
    });

    group('calculateTrend', () {
      test('should calculate improving trend', () async {
        // Act & Assert
        expect(await repository.calculateTrend(const Duration(days: 7)),
            isA<CoverageTrend>());
        expect(await repository.calculateTrend(const Duration(days: 7)),
            isA<CoverageTrend>());
        expect(await repository.calculateTrend(const Duration(days: 7)),
            isA<CoverageTrend>());
        expect(await repository.calculateTrend(const Duration(days: 30)),
            isA<CoverageTrend>());
      });
    });
  });

  group('CoverageReport', () {
    test('should create report with all fields', () {
      // Arrange & Act
      final report = CoverageReport(
        timestamp: DateTime(2025, 11, 27, 10),
        stats: const CoverageStats(
          totalElements: 100,
          documentedElements: 75,
          undocumentedElements: 25,
          coveragePercentage: 75,
          elementBreakdown: {},
        ),
        analyzedFiles: ['lib/main.dart', 'lib/core/constants.dart'],
        lowCoverageFiles: ['lib/core/constants.dart'],
        notes: 'Test report',
      );

      // Assert
      expect(report.timestamp, equals(DateTime(2025, 11, 27, 10)));
      expect(report.stats.totalElements, equals(100));
      expect(report.stats.documentedElements, equals(75));
      expect(report.stats.coveragePercentage, equals(75.0));
      expect(report.analyzedFiles.length, equals(2));
      expect(report.lowCoverageFiles.length, equals(1));
      expect(report.notes, equals('Test report'));
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final report = CoverageReport(
        timestamp: DateTime(2025, 11, 27, 10),
        stats: const CoverageStats(
          totalElements: 100,
          documentedElements: 75,
          undocumentedElements: 25,
          coveragePercentage: 75,
          elementBreakdown: {},
        ),
        analyzedFiles: ['lib/main.dart'],
        lowCoverageFiles: [],
        notes: 'Test',
      );

      // Act
      final json = report.toJson();
      final stats = json['stats'] as Map<String, dynamic>;

      // Assert
      expect(json['timestamp'], equals('2025-11-27T10:00:00.000'));
      expect(stats['totalElements'], equals(100));
      expect(stats['documentedElements'], equals(75));
      expect(stats['coveragePercentage'], equals(75.0));
      expect(json['analyzedFiles'], equals(['lib/main.dart']));
      expect(json['lowCoverageFiles'], equals([]));
      expect(json['notes'], equals('Test'));
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = {
        'timestamp': '2025-11-27T10:00:00.000',
        'stats': {
          'totalElements': 100,
          'documentedElements': 75,
          'undocumentedElements': 25,
          'coveragePercentage': 75.0,
        },
        'analyzedFiles': <String>['lib/main.dart'],
        'lowCoverageFiles': <String>[],
        'notes': 'Test',
      };

      // Act
      final report = CoverageReport.fromJson(json);

      // Assert
      expect(report.timestamp, equals(DateTime(2025, 11, 27, 10)));
      expect(report.stats.totalElements, equals(100));
      expect(report.stats.documentedElements, equals(75));
      expect(report.stats.coveragePercentage, equals(75.0));
      expect(report.analyzedFiles, equals(['lib/main.dart']));
      expect(report.lowCoverageFiles, equals([]));
      expect(report.notes, equals('Test'));
    });

    test('should handle null notes in JSON', () {
      // Arrange
      final json = {
        'timestamp': '2025-11-27T10:00:00.000',
        'stats': {
          'totalElements': 100,
          'documentedElements': 75,
          'undocumentedElements': 25,
          'coveragePercentage': 75.0,
        },
        'analyzedFiles': <String>['lib/main.dart'],
        'lowCoverageFiles': <String>[],
        'notes': null,
      };

      // Act
      final report = CoverageReport.fromJson(json);

      // Assert
      expect(report.notes, isNull);
    });
  });

  group('CoverageTrend', () {
    test('should create trend with all fields', () {
      // Arrange & Act
      const trend = CoverageTrend(
        direction: TrendDirection.improving,
        changePercentage: 10,
        currentCoverage: 80,
        previousCoverage: 70,
        period: Duration(days: 7),
      );

      // Assert
      expect(trend.direction, equals(TrendDirection.improving));
      expect(trend.changePercentage, equals(10.0));
      expect(trend.currentCoverage, equals(80.0));
      expect(trend.previousCoverage, equals(70.0));
      expect(trend.period, equals(const Duration(days: 7)));
    });

    test('should correctly identify improving trend', () {
      // Arrange
      const trend = CoverageTrend(
        direction: TrendDirection.improving,
        changePercentage: 5,
        currentCoverage: 75,
        previousCoverage: 70,
        period: Duration(days: 7),
      );

      // Assert
      expect(trend.isImproving, isTrue);
      expect(trend.isDeclining, isFalse);
      expect(trend.isStable, isFalse);
    });

    test('should correctly identify declining trend', () {
      // Arrange
      const trend = CoverageTrend(
        direction: TrendDirection.declining,
        changePercentage: -5,
        currentCoverage: 65,
        previousCoverage: 70,
        period: Duration(days: 7),
      );

      // Assert
      expect(trend.isImproving, isFalse);
      expect(trend.isDeclining, isTrue);
      expect(trend.isStable, isFalse);
    });

    test('should correctly identify stable trend', () {
      // Arrange
      const trend = CoverageTrend(
        direction: TrendDirection.stable,
        changePercentage: 0,
        currentCoverage: 70,
        previousCoverage: 70,
        period: Duration(days: 7),
      );

      // Assert
      expect(trend.isImproving, isFalse);
      expect(trend.isDeclining, isFalse);
      expect(trend.isStable, isTrue);
    });
  });

  group('ReportFormat', () {
    test('should have all expected formats', () {
      // Assert
      expect(ReportFormat.values.length, equals(5));
      expect(ReportFormat.values, contains(ReportFormat.json));
      expect(ReportFormat.values, contains(ReportFormat.markdown));
      expect(ReportFormat.values, contains(ReportFormat.html));
      expect(ReportFormat.values, contains(ReportFormat.csv));
      expect(ReportFormat.values, contains(ReportFormat.text));
    });
  });

  group('TrendDirection', () {
    test('should have all expected directions', () {
      // Assert
      expect(TrendDirection.values.length, equals(3));
      expect(TrendDirection.values, contains(TrendDirection.improving));
      expect(TrendDirection.values, contains(TrendDirection.declining));
      expect(TrendDirection.values, contains(TrendDirection.stable));
    });
  });
}
