/// Automated Backup Service for Basir ERP Development
library;

/// This service handles automated backups of Git branches, database snapshots,
/// and critical project files to ensure data integrity and recovery
/// capabilities.
///
/// Author: فريق وكلاء تطوير مشروع بصير

import 'dart:convert';
import 'dart:io';

/// Manages automated backups for the Basir ERP system
class BackupService {
  /// Default backup configuration
  static const BackupConfig defaultConfig = BackupConfig(
    enableAutomaticBackups: true,
    backupIntervalHours: 24,
    maxBackupRetentionDays: 30,
    backupBranches: ['main', 'development'],
    backupDatabase: true,
    backupConfigurations: true,
    compressionEnabled: true,
  );

  /// Backup storage locations
  static const Map<String, String> backupLocations = {
    'git': '.backups/git',
    'database': '.backups/database',
    'config': '.backups/config',
    'logs': '.backups/logs',
  };

  /// Creates a comprehensive backup of the current state
  static Future<BackupResult> createBackup({
    BackupConfig? config,
    String? customName,
    bool dryRun = false,
  }) async {
    final backupConfig = config ?? defaultConfig;
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final backupName = customName ?? 'backup-$timestamp';

    try {
      if (dryRun) {
        return BackupResult.success(
          'Dry run: Would create backup $backupName',
          backupName: backupName,
        );
      }

      // Create backup directories
      await _createBackupDirectories();

      final backupPath = '.backups/$backupName';
      await Directory(backupPath).create(recursive: true);

      // Collect backup items
      final allItems = <BackupItem>[];

      // Backup Git branches
      if (backupConfig.backupBranches.isNotEmpty) {
        final gitBackupResult = await _backupGitBranches(
          backupPath,
          backupConfig.backupBranches,
        );
        allItems.addAll(gitBackupResult.items);
      }

      // Backup database
      if (backupConfig.backupDatabase) {
        final dbBackupResult = await _backupDatabase(backupPath);
        allItems.addAll(dbBackupResult.items);
      }

      // Backup configurations
      if (backupConfig.backupConfigurations) {
        final configBackupResult = await _backupConfigurations(backupPath);
        allItems.addAll(configBackupResult.items);
      }

      // Create backup manifest
      final backupManifest = BackupManifest(
        name: backupName,
        timestamp: DateTime.now(),
        config: backupConfig,
        items: allItems,
      );

      // Create backup manifest
      await _createBackupManifest(backupPath, backupManifest);

      // Compress if enabled
      if (backupConfig.compressionEnabled) {
        await _compressBackup(backupPath);
      }

      // Clean old backups
      await _cleanOldBackups(backupConfig.maxBackupRetentionDays);

      return BackupResult.success(
        'Backup created successfully: $backupName',
        backupName: backupName,
        backupPath: backupPath,
        itemCount: backupManifest.items.length,
      );
    } on Exception catch (e) {
      return BackupResult.error('Failed to create backup: $e');
    }
  }

  /// Restores from a backup
  static Future<BackupResult> restoreBackup({
    required String backupName,
    List<String>? specificItems,
    bool dryRun = false,
  }) async {
    try {
      final backupPath = '.backups/$backupName';
      final backupDir = Directory(backupPath);

      if (!backupDir.existsSync()) {
        return BackupResult.error('Backup not found: $backupName');
      }

      if (dryRun) {
        return BackupResult.success(
          'Dry run: Would restore backup $backupName',
          backupName: backupName,
        );
      }

      // Read backup manifest
      final manifest = await _readBackupManifest(backupPath);
      if (manifest == null) {
        return BackupResult.error('Invalid backup: manifest not found');
      }

      // Decompress if needed
      await _decompressBackup(backupPath);

      // Restore items
      final itemsToRestore =
          specificItems ?? manifest.items.map((item) => item.name).toList();

      var restoredCount = 0;
      for (final itemName in itemsToRestore) {
        final item = manifest.items.firstWhere(
          (item) => item.name == itemName,
          orElse: () => throw ArgumentError('Item not found: $itemName'),
        );

        final restoreResult = await _restoreItem(backupPath, item);
        if (restoreResult.success) {
          restoredCount++;
        }
      }

      return BackupResult.success(
        'Restored $restoredCount items from backup $backupName',
        backupName: backupName,
        itemCount: restoredCount,
      );
    } on Exception catch (e) {
      return BackupResult.error('Failed to restore backup: $e');
    }
  }

  /// Lists available backups
  static Future<List<BackupInfo>> listBackups() async {
    try {
      final backupsDir = Directory('.backups');
      if (!backupsDir.existsSync()) {
        return [];
      }

      final backups = <BackupInfo>[];
      await for (final entity in backupsDir.list()) {
        if (entity is Directory) {
          final manifest = await _readBackupManifest(entity.path);
          if (manifest != null) {
            backups.add(
              BackupInfo(
                name: manifest.name,
                timestamp: manifest.timestamp,
                itemCount: manifest.items.length,
                size: await _calculateDirectorySize(entity.path),
                path: entity.path,
              ),
            );
          }
        }
      }

      // Sort by timestamp (newest first)
      backups.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return backups;
    } on Exception {
      return [];
    }
  }

  /// Schedules automatic backups
  static Future<void> scheduleAutomaticBackups(BackupConfig config) async {
    // This would integrate with a task scheduler in a real implementation
    // For now, we'll create a simple marker file
    final scheduleFile = File('.backups/schedule.json');
    await scheduleFile.writeAsString(
      jsonEncode({
        'enabled': config.enableAutomaticBackups,
        'intervalHours': config.backupIntervalHours,
        'lastBackup': DateTime.now().toIso8601String(),
        'nextBackup': DateTime.now()
            .add(Duration(hours: config.backupIntervalHours))
            .toIso8601String(),
      }),
    );
  }

  /// Checks if automatic backup is due
  static Future<bool> isBackupDue() async {
    try {
      final scheduleFile = File('.backups/schedule.json');
      if (!scheduleFile.existsSync()) {
        return true; // First backup
      }

      final scheduleData =
          jsonDecode(await scheduleFile.readAsString()) as Map<String, dynamic>;
      final nextBackup = DateTime.parse(scheduleData['nextBackup'] as String);
      return DateTime.now().isAfter(nextBackup);
    } on Exception {
      return true; // Default to backup needed
    }
  }

  /// Recovers deleted branches within retention period
  static Future<BackupResult> recoverDeletedBranch(String branchName) async {
    try {
      // Look for the branch in recent backups
      final backups = await listBackups();

      for (final backup in backups) {
        final manifest = await _readBackupManifest(backup.path);
        if (manifest == null) continue;

        BackupItem? branchItem;
        try {
          branchItem = manifest.items.firstWhere(
            (item) => item.type == 'git_branch' && item.name == branchName,
          );
        } on Exception {
          branchItem = null;
        }

        if (branchItem != null) {
          // Found the branch in this backup
          final restoreResult = await _restoreItem(backup.path, branchItem);
          if (restoreResult.success) {
            return BackupResult.success(
              'Branch $branchName recovered from backup ${backup.name}',
              backupName: backup.name,
            );
          }
        }
      }

      return BackupResult.error('Branch $branchName not found in any backup');
    } on Exception catch (e) {
      return BackupResult.error('Failed to recover branch: $e');
    }
  }

  // Private helper methods

  static Future<void> _createBackupDirectories() async {
    for (final location in backupLocations.values) {
      await Directory(location).create(recursive: true);
    }
  }

  static Future<GitBackupResult> _backupGitBranches(
    String backupPath,
    List<String> branches,
  ) async {
    final items = <BackupItem>[];
    final gitBackupPath = '$backupPath/git';
    await Directory(gitBackupPath).create(recursive: true);

    for (final branch in branches) {
      try {
        // Create bundle of the branch
        final bundlePath = '$gitBackupPath/$branch.bundle';
        final result = await Process.run('git', [
          'bundle',
          'create',
          bundlePath,
          branch,
        ]);

        if (result.exitCode == 0) {
          final bundleFile = File(bundlePath);
          items.add(
            BackupItem(
              name: branch,
              type: 'git_branch',
              path: bundlePath,
              size: await bundleFile.length(),
            ),
          );
        }
      } on Exception {
        // Continue with other branches
      }
    }

    return GitBackupResult(items: items);
  }

  static Future<DatabaseBackupResult> _backupDatabase(String backupPath) async {
    final items = <BackupItem>[];
    final dbBackupPath = '$backupPath/database';
    await Directory(dbBackupPath).create(recursive: true);

    // Backup Isar database files
    final isarFiles = [
      'basir.isar',
      'basir.isar.lock',
    ];

    for (final fileName in isarFiles) {
      final sourceFile = File(fileName);
      if (sourceFile.existsSync()) {
        final targetPath = '$dbBackupPath/$fileName';
        await sourceFile.copy(targetPath);

        items.add(
          BackupItem(
            name: fileName,
            type: 'database_file',
            path: targetPath,
            size: await sourceFile.length(),
          ),
        );
      }
    }

    return DatabaseBackupResult(items: items);
  }

  static Future<ConfigBackupResult> _backupConfigurations(
    String backupPath,
  ) async {
    final items = <BackupItem>[];
    final configBackupPath = '$backupPath/config';
    await Directory(configBackupPath).create(recursive: true);

    final configFiles = [
      'pubspec.yaml',
      'analysis_options.yaml',
      '.env',
      '.kiro/config.json',
      '.github/workflows/pr-checks.yml',
      '.github/branch-protection.yml',
      '.github/CODEOWNERS',
    ];

    for (final filePath in configFiles) {
      final sourceFile = File(filePath);
      if (sourceFile.existsSync()) {
        final fileName = filePath.split('/').last;
        final targetPath = '$configBackupPath/$fileName';
        await sourceFile.copy(targetPath);

        items.add(
          BackupItem(
            name: fileName,
            type: 'config_file',
            path: targetPath,
            size: await sourceFile.length(),
          ),
        );
      }
    }

    return ConfigBackupResult(items: items);
  }

  static Future<void> _createBackupManifest(
    String backupPath,
    BackupManifest manifest,
  ) async {
    final manifestFile = File('$backupPath/manifest.json');
    await manifestFile.writeAsString(jsonEncode(manifest.toJson()));
  }

  static Future<BackupManifest?> _readBackupManifest(String backupPath) async {
    try {
      final manifestFile = File('$backupPath/manifest.json');
      if (!manifestFile.existsSync()) {
        return null;
      }

      final manifestData =
          jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
      return BackupManifest.fromJson(manifestData);
    } on Exception {
      return null;
    }
  }

  static Future<void> _compressBackup(String backupPath) async {
    // In a real implementation, this would compress the backup directory
    // For now, we'll create a marker file
    final compressedMarker = File('$backupPath/.compressed');
    await compressedMarker.writeAsString('compressed');
  }

  static Future<void> _decompressBackup(String backupPath) async {
    // In a real implementation, this would decompress the backup
    // For now, we'll just check for the marker
    final compressedMarker = File('$backupPath/.compressed');
    if (compressedMarker.existsSync()) {
      // Backup is compressed, would decompress here
    }
  }

  static Future<BackupResult> _restoreItem(
    String backupPath,
    BackupItem item,
  ) async {
    try {
      switch (item.type) {
        case 'git_branch':
          return await _restoreGitBranch(backupPath, item);
        case 'database_file':
          return await _restoreDatabaseFile(backupPath, item);
        case 'config_file':
          return await _restoreConfigFile(backupPath, item);
        default:
          return BackupResult.error('Unknown item type: ${item.type}');
      }
    } on Exception catch (e) {
      return BackupResult.error('Failed to restore ${item.name}: $e');
    }
  }

  static Future<BackupResult> _restoreGitBranch(
    String backupPath,
    BackupItem item,
  ) async {
    try {
      final bundlePath = '$backupPath/git/${item.name}.bundle';
      final result = await Process.run('git', [
        'fetch',
        bundlePath,
        '${item.name}:${item.name}-restored',
      ]);

      if (result.exitCode == 0) {
        return BackupResult.success('Branch ${item.name} restored');
      } else {
        return BackupResult.error('Failed to restore branch: ${result.stderr}');
      }
    } on Exception catch (e) {
      return BackupResult.error('Failed to restore branch: $e');
    }
  }

  static Future<BackupResult> _restoreDatabaseFile(
    String backupPath,
    BackupItem item,
  ) async {
    try {
      final sourcePath = '$backupPath/database/${item.name}';
      final targetPath = item.name;

      await File(sourcePath).copy(targetPath);
      return BackupResult.success('Database file ${item.name} restored');
    } on Exception catch (e) {
      return BackupResult.error('Failed to restore database file: $e');
    }
  }

  static Future<BackupResult> _restoreConfigFile(
    String backupPath,
    BackupItem item,
  ) async {
    try {
      final sourcePath = '$backupPath/config/${item.name}';
      final targetPath = item.name;

      await File(sourcePath).copy(targetPath);
      return BackupResult.success('Config file ${item.name} restored');
    } on Exception catch (e) {
      return BackupResult.error('Failed to restore config file: $e');
    }
  }

  static Future<void> _cleanOldBackups(int maxRetentionDays) async {
    try {
      final backupsDir = Directory('.backups');
      if (!backupsDir.existsSync()) return;

      final cutoffDate =
          DateTime.now().subtract(Duration(days: maxRetentionDays));

      await for (final entity in backupsDir.list()) {
        if (entity is Directory) {
          final manifest = await _readBackupManifest(entity.path);
          if (manifest != null && manifest.timestamp.isBefore(cutoffDate)) {
            await entity.delete(recursive: true);
          }
        }
      }
    } on Exception {
      // Ignore cleanup errors
    }
  }

  static Future<int> _calculateDirectorySize(String path) async {
    try {
      var totalSize = 0;
      final dir = Directory(path);

      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }

      return totalSize;
    } on Exception {
      return 0;
    }
  }
}

/// Configuration for backup operations
class BackupConfig {
  /// Creates a new [BackupConfig] instance
  const BackupConfig({
    required this.enableAutomaticBackups,
    required this.backupIntervalHours,
    required this.maxBackupRetentionDays,
    required this.backupBranches,
    required this.backupDatabase,
    required this.backupConfigurations,
    required this.compressionEnabled,
  });

  /// Creates a [BackupConfig] from a JSON map
  factory BackupConfig.fromJson(Map<String, dynamic> json) => BackupConfig(
        enableAutomaticBackups: json['enableAutomaticBackups'] as bool? ?? true,
        backupIntervalHours: json['backupIntervalHours'] as int? ?? 24,
        maxBackupRetentionDays: json['maxBackupRetentionDays'] as int? ?? 30,
        backupBranches: List<String>.from(
          json['backupBranches'] as Iterable? ?? ['main', 'development'],
        ),
        backupDatabase: json['backupDatabase'] as bool? ?? true,
        backupConfigurations: json['backupConfigurations'] as bool? ?? true,
        compressionEnabled: json['compressionEnabled'] as bool? ?? true,
      );

  /// Whether to backup Git branches
  final bool enableAutomaticBackups;

  /// Interval between backups in hours
  final int backupIntervalHours;

  /// Maximum number of days to keep backups
  final int maxBackupRetentionDays;

  /// List of branches to backup
  final List<String> backupBranches;

  /// Whether to backup the database
  final bool backupDatabase;

  /// Whether to backup configuration files
  final bool backupConfigurations;

  /// Whether to compress backups
  final bool compressionEnabled;

  /// Converts the [BackupConfig] to a JSON map
  Map<String, dynamic> toJson() => {
        'enableAutomaticBackups': enableAutomaticBackups,
        'backupIntervalHours': backupIntervalHours,
        'maxBackupRetentionDays': maxBackupRetentionDays,
        'backupBranches': backupBranches,
        'backupDatabase': backupDatabase,
        'backupConfigurations': backupConfigurations,
        'compressionEnabled': compressionEnabled,
      };
}

/// Information about a backup
class BackupInfo {
  /// Creates a new [BackupInfo] instance
  const BackupInfo({
    required this.name,
    required this.timestamp,
    required this.itemCount,
    required this.size,
    required this.path,
  });

  /// The name of the backup
  final String name;

  /// The timestamp of the backup
  final DateTime timestamp;

  /// The number of items in the backup
  final int itemCount;

  /// The size of the backup in bytes
  final int size;

  /// The local path to the backup
  final String path;
}

/// Manifest for backup operations
class BackupManifest {
  /// Creates a new [BackupManifest] instance
  const BackupManifest({
    required this.name,
    required this.timestamp,
    required this.config,
    required this.items,
  });

  /// Creates a [BackupManifest] from a JSON map
  factory BackupManifest.fromJson(Map<String, dynamic> json) => BackupManifest(
        name: json['name'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        config: BackupConfig.fromJson(json['config'] as Map<String, dynamic>),
        items: (json['items'] as List<dynamic>)
            .map((item) => BackupItem.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  /// The name of the backup
  final String name;

  /// The timestamp of the backup
  final DateTime timestamp;

  /// The configuration used for the backup
  final BackupConfig config;

  /// The items included in the backup
  final List<BackupItem> items;

  /// Converts the [BackupManifest] to a JSON map
  Map<String, dynamic> toJson() => {
        'name': name,
        'timestamp': timestamp.toIso8601String(),
        'config': config.toJson(),
        'items': items.map((item) => item.toJson()).toList(),
      };
}

/// Individual backup item
class BackupItem {
  /// Creates a new [BackupItem] instance
  const BackupItem({
    required this.name,
    required this.type,
    required this.path,
    required this.size,
  });

  /// Creates a [BackupItem] from a JSON map
  factory BackupItem.fromJson(Map<String, dynamic> json) => BackupItem(
        name: json['name'] as String,
        type: json['type'] as String,
        path: json['path'] as String,
        size: json['size'] as int,
      );

  /// The name of the item
  final String name;

  /// The type of the item (e.g., 'git_branch', 'database_file')
  final String type;

  /// The path to the item
  final String path;

  /// The size of the item in bytes
  final int size;

  /// Converts the [BackupItem] to a JSON map
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'path': path,
        'size': size,
      };
}

/// Result of backup operations
class BackupResult {
  /// Creates a new [BackupResult] instance
  const BackupResult({
    required this.success,
    required this.message,
    this.backupName,
    this.backupPath,
    this.itemCount,
  });

  /// Creates a successful result
  factory BackupResult.success(
    String message, {
    String? backupName,
    String? backupPath,
    int? itemCount,
  }) =>
      BackupResult(
        success: true,
        message: message,
        backupName: backupName,
        backupPath: backupPath,
        itemCount: itemCount,
      );

  /// Creates an error result
  factory BackupResult.error(String message) => BackupResult(
        success: false,
        message: message,
      );

  /// Whether the operation was successful
  final bool success;

  /// Result message
  final String message;

  /// Name of the backup
  final String? backupName;

  /// Path to the backup directory
  final String? backupPath;

  /// Number of items backed up
  final int? itemCount;
}

/// Result of Git backup operations
class GitBackupResult {
  /// Creates a new [GitBackupResult] instance
  const GitBackupResult({required this.items});

  /// The list of backed up Git items
  final List<BackupItem> items;
}

/// Result of database backup operations
class DatabaseBackupResult {
  /// Creates a new [DatabaseBackupResult] instance
  const DatabaseBackupResult({required this.items});

  /// The list of backed up database items
  final List<BackupItem> items;
}

/// Result of configuration backup operations
class ConfigBackupResult {
  /// Creates a new [ConfigBackupResult] instance
  const ConfigBackupResult({required this.items});

  /// The list of backed up configuration items
  final List<BackupItem> items;
}
