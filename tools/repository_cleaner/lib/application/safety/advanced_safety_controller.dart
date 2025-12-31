import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:repository_cleaner/domain/entities/file_info.dart';

class AdvancedSafetyController {
  AdvancedSafetyController({
    required this.projectRoot,
  }) : trashPath = p.join(projectRoot, '.kiro/trash');
  final String projectRoot;
  final String trashPath;

  // Critical files that should NEVER be deleted
  static const List<String> _criticalFiles = [
    'pubspec.yaml',
    'pubspec.lock',
    'lib/main.dart',
    '.gitignore',
    'README.md',
    '.metadata',
  ];

  bool isSafeToDelete(FileInfo file) {
    if (_criticalFiles.contains(p.relative(file.path, from: projectRoot))) {
      return false;
    }
    // Add more safety checks here (e.g. check if file is currently open/locked if possible)
    return true;
  }

  Future<void> backupFile(FileInfo file) async {
    final originalFile = File(file.path);
    if (!await originalFile.exists()) return;

    final relativePath = p.relative(file.path, from: projectRoot);
    final backupFile = File(p.join(trashPath, relativePath));

    await backupFile.create(recursive: true);
    await originalFile.copy(backupFile.path);
  }

  Future<void> restoreFile(String originalRelativePath) async {
    final backupFile = File(p.join(trashPath, originalRelativePath));
    if (!await backupFile.exists())
      throw Exception('Backup not found for $originalRelativePath');

    final originalFile = File(p.join(projectRoot, originalRelativePath));
    await originalFile.create(recursive: true);
    await backupFile.copy(originalFile.path);
  }
}
