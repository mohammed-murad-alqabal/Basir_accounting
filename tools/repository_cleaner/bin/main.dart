import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:repository_cleaner/application/engine/smart_cleanup_engine.dart';
import 'package:repository_cleaner/application/safety/advanced_safety_controller.dart';
import 'package:repository_cleaner/infrastructure/analyzer/intelligent_file_analyzer.dart';
import 'package:repository_cleaner/infrastructure/archive/advanced_archive_manager.dart';
import 'package:repository_cleaner/infrastructure/scanner/advanced_repository_scanner.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag(
      'dry-run',
      abbr: 'd',
      defaultsTo: true,
      help: 'Simulate cleanup without deleting files.',
    )
    ..addFlag('verbose', abbr: 'v', help: 'Show detailed output.')
    ..addOption(
      'root',
      abbr: 'r',
      help: 'Path to repository root (defaults to current directory).',
    );

  try {
    final results = parser.parse(arguments);
    final dryRun = results['dry-run'] as bool;
    final verbose = results['verbose'] as bool;
    final rootPath = results['root'] as String? ?? Directory.current.path;

    print('🧹 Repository Cleaner v1.0.0');
    print('Target: $rootPath');
    print(
        'Mode: ${dryRun ? "DRY RUN (Safe)" : "LIVE EXECUTION (Destructive)"}');
    print('----------------------------------------');

    final scanner = AdvancedRepositoryScanner(rootPath: rootPath);
    final analyzer = IntelligentFileAnalyzer();
    final safety = AdvancedSafetyController(projectRoot: rootPath);
    final archive = AdvancedArchiveManager(
        archiveRoot: p.join(rootPath, 'logs', 'archive'));

    final engine = SmartCleanupEngine(
      scanner: scanner,
      analyzer: analyzer,
      safetyController: safety,
      archiveManager: archive,
    );

    print('🔍 Scanning and analyzing...');
    final plan = await engine.generatePlan();

    print('----------------------------------------');
    print('📊 Analysis Report:');
    print('  Found ${plan.actions.length} actionable items.');
    print('  Files to Delete: ${plan.totalFilesToDelete}');
    print('  Files to Archive: ${plan.totalFilesToArchive}');
    print(
        '  Projected Savings: ${(plan.projectedBytesSaved / 1024 / 1024).toStringAsFixed(2)} MB');
    print('----------------------------------------');

    if (verbose) {
      for (final action in plan.actions) {
        // Only show actions that modify state
        if (action.actionType.name == 'ignore' ||
            action.actionType.name == 'keep') continue;
        print(
          '[${action.actionType.name.toUpperCase()}] ${p.relative(action.file.path, from: rootPath)} (${action.reason})',
        );
      }
    }

    if (!dryRun) {
      print(
          '⚠️  WARNING: Starting cleanup in 5 seconds. Press Ctrl+C to cancel.');
      await Future<void>.delayed(const Duration(seconds: 5));
    }

    await engine.executePlan(plan, dryRun: dryRun);

    print('----------------------------------------');
    print('✅ Cleanup Complete.');
  } catch (e) {
    print('❌ Error: $e');
    exit(1);
  }
}
