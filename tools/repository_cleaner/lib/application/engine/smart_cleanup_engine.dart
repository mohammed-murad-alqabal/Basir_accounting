import 'dart:io';

import 'package:intl/intl.dart';
import 'package:repository_cleaner/application/safety/advanced_safety_controller.dart';
import 'package:repository_cleaner/domain/entities/cleanup_plan.dart';
import 'package:repository_cleaner/domain/entities/file_info.dart';
import 'package:repository_cleaner/infrastructure/analyzer/intelligent_file_analyzer.dart';
import 'package:repository_cleaner/infrastructure/archive/advanced_archive_manager.dart';
import 'package:repository_cleaner/infrastructure/scanner/advanced_repository_scanner.dart';

class SmartCleanupEngine {
  SmartCleanupEngine({
    required this.scanner,
    required this.analyzer,
    required this.safetyController,
    required this.archiveManager,
  });
  final AdvancedRepositoryScanner scanner;
  final IntelligentFileAnalyzer analyzer;
  final AdvancedSafetyController safetyController;
  final AdvancedArchiveManager archiveManager;

  Future<CleanupPlan> generatePlan() async {
    final actions = <CleanupAction>[];

    await for (final fileInfo in scanner.scan()) {
      final analyzedInfo = await analyzer.analyze(fileInfo);
      final action = _decideAction(analyzedInfo);
      // Include ALL actions in the plan for transparency
      actions.add(action);
    }

    return CleanupPlan(actions: actions, generatedAt: DateTime.now());
  }

  Future<void> executePlan(CleanupPlan plan, {bool dryRun = true}) async {
    if (dryRun) {
      print('DRY RUN: Executing plan with ${plan.actions.length} actions.');
      return;
    }

    print('EXECUTING CLEANUP PLAN...');

    // Group archival tasks
    final filesToArchive = <FileInfo>[];

    for (final action in plan.actions) {
      if (action.actionType == CleanupActionType.ignore ||
          action.actionType == CleanupActionType.keep) {
        continue;
      }

      if (!safetyController.isSafeToDelete(action.file)) {
        print('SKIPPING UNSAFE: ${action.file.path}');
        continue;
      }

      try {
        if (action.actionType == CleanupActionType.delete) {
          await safetyController.backupFile(action.file);
          final file = File(action.file.path);
          if (await file.exists()) {
            await file.delete();
            print('DELETED: ${action.file.path}');
          }
        } else if (action.actionType == CleanupActionType.archive) {
          filesToArchive.add(action.file);
        }
      } catch (e) {
        print('ERROR processing ${action.file.path}: $e');
      }
    }

    // Process archival in bulk
    if (filesToArchive.isNotEmpty) {
      final dateStr = DateFormat('yyyy_MM_dd').format(DateTime.now());
      final archiveName = 'archive_${dateStr}_logs.zip';

      try {
        print('ARCHIVING ${filesToArchive.length} files to $archiveName...');
        await archiveManager.compressFiles(filesToArchive, archiveName);
        await archiveManager.createMetaFile(archiveName, filesToArchive);

        // After successful archive, delete originals
        for (final fileInfo in filesToArchive) {
          final file = File(fileInfo.path);
          if (await file.exists()) {
            await file.delete();
            print('ARCHIVED & DELETED: ${fileInfo.path}');
          }
        }
      } catch (e) {
        print('ERROR during archival: $e');
      }
    }
  }

  CleanupAction _decideAction(FileInfo file) {
    // 1. Critical Files (Keep)
    if (!safetyController.isSafeToDelete(file)) {
      return CleanupAction(
        file: file,
        actionType: CleanupActionType.keep,
        reason: 'Critical file protected by SafetyController',
      );
    }

    // 2. Old Logs (Archive)
    if (file.path.contains('/logs/') && file.category == FileCategory.log) {
      final age = DateTime.now().difference(file.modifiedAt);
      if (age.inDays > 7) {
        return CleanupAction(
          file: file,
          actionType: CleanupActionType.archive,
          reason: 'Old log file (>7 days)',
        );
      }
    }

    // 3. Archive Folder Optimization (Flatten & Re-archive)
    // Archive everything in docs/Archive that isn't already a zip/tar/gz
    if (file.path.contains('/docs/Archive/') &&
        !file.name.endsWith('.zip') &&
        !file.name.endsWith('.tar.gz') &&
        !file.name.endsWith('.rar')) {
      return CleanupAction(
        file: file,
        actionType: CleanupActionType.archive,
        reason: 'Consolidating docs/Archive',
      );
    }

    // 4. Temporary Files (Delete)
    if (file.category == FileCategory.log ||
        file.name.endsWith('.tmp') ||
        file.name.endsWith('.bak')) {
      return CleanupAction(
        file: file,
        actionType: CleanupActionType.delete,
        reason: 'Temporary or Log file',
      );
    }

    // Default: Ignore (Keep)
    return CleanupAction(
      file: file,
      actionType: CleanupActionType.ignore,
      reason: 'No cleanup rule matched',
    );
  }
}
