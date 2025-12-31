import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:repository_cleaner/application/engine/smart_cleanup_engine.dart';
import 'package:repository_cleaner/application/safety/advanced_safety_controller.dart';
import 'package:repository_cleaner/domain/entities/cleanup_plan.dart';
import 'package:repository_cleaner/infrastructure/analyzer/intelligent_file_analyzer.dart';
import 'package:repository_cleaner/infrastructure/archive/advanced_archive_manager.dart';
import 'package:repository_cleaner/infrastructure/scanner/advanced_repository_scanner.dart';
import 'package:test/test.dart';

void main() {
  group('SmartCleanupEngine Integration', () {
    late Directory tempDir;
    late SmartCleanupEngine engine;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('engine_test_');

      final scanner = AdvancedRepositoryScanner(rootPath: tempDir.path);
      final analyzer = IntelligentFileAnalyzer();
      final safety = AdvancedSafetyController(projectRoot: tempDir.path);
      final archive =
          AdvancedArchiveManager(archiveRoot: p.join(tempDir.path, 'archive'));

      engine = SmartCleanupEngine(
        scanner: scanner,
        analyzer: analyzer,
        safetyController: safety,
        archiveManager: archive,
      );
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('generates plan to delete .tmp files', () async {
      final tmpFile = File(p.join(tempDir.path, 'junk.tmp'));
      await tmpFile.writeAsString('junk');

      final plan = await engine.generatePlan();

      expect(plan.actions.length, equals(1));
      expect(plan.actions.first.actionType, equals(CleanupActionType.delete));
      expect(plan.actions.first.file.name, equals('junk.tmp'));
    });

    test('respects critical files', () async {
      // Mock critical file path (relative to root)
      // SafetyController uses real path checking. 'pubspec.yaml' is critical.
      final pubspec = File(p.join(tempDir.path, 'pubspec.yaml'));
      await pubspec.writeAsString('name: test');

      final plan = await engine.generatePlan();

      final action =
          plan.actions.firstWhere((a) => a.file.name == 'pubspec.yaml');
      expect(action.actionType, equals(CleanupActionType.keep));
    });

    test('executes plan (dry run) without deleting', () async {
      final tmpFile = File(p.join(tempDir.path, 'junk.tmp'));
      await tmpFile.writeAsString('junk');

      final plan = await engine.generatePlan();
      await engine.executePlan(plan);

      expect(await tmpFile.exists(), isTrue);
    });

    test('executes plan (real) and deletes file', () async {
      final tmpFile = File(p.join(tempDir.path, 'junk.tmp'));
      await tmpFile.writeAsString('junk');

      final plan = await engine.generatePlan();
      await engine.executePlan(plan, dryRun: false);

      expect(await tmpFile.exists(), isFalse);
    });

    test('archives old log files', () async {
      final logsDir = Directory(p.join(tempDir.path, 'logs'));
      await logsDir.create();

      final oldLog = File(p.join(logsDir.path, 'old.log'));
      await oldLog.writeAsString('old log content for archive');

      // Manually set modified time to 8 days ago
      final oldDate = DateTime.now().subtract(const Duration(days: 8));
      await oldLog.setLastModified(oldDate);

      // We must regenerate scanner stream or retry logic since scan happens on generatePlan
      final plan = await engine.generatePlan();

      final archiveAction =
          plan.actions.firstWhere((a) => a.file.name == 'old.log');
      expect(archiveAction.actionType, equals(CleanupActionType.archive));

      // Execute archival
      await engine.executePlan(plan, dryRun: false);

      // Original should be gone
      expect(await oldLog.exists(), isFalse);

      // Archive should exist
      final archiveDir = Directory(p.join(tempDir.path, 'archive'));
      expect(await archiveDir.exists(), isTrue);
      final entityList = await archiveDir.list().toList();
      expect(entityList.isNotEmpty, isTrue);
      expect(entityList.any((e) => e.path.endsWith('.zip')), isTrue);
    });
  });
}
