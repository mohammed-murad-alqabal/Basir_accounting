import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:repository_cleaner/domain/entities/file_info.dart';

class AdvancedRepositoryScanner {
  AdvancedRepositoryScanner({required this.rootPath});
  final List<String> _ignoredPatterns = [
    '.git/',
    '.dart_tool/',
    'build/',
    '.idea/',
    '.vscode/',
    'pubspec.lock',
  ];

  final String rootPath;

  Stream<FileInfo> scan() async* {
    final dir = Directory(rootPath);
    if (!await dir.exists()) {
      throw Exception('Root path does not exist: $rootPath');
    }

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (_shouldIgnore(entity.path)) continue;

      final stat = await entity.stat();
      if (entity is File) {
        yield FileInfo(
          path: entity.path,
          name: p.basename(entity.path),
          sizeBytes: stat.size,
          modifiedAt: stat.modified,
          accessedAt: <credential-fixture>,
          type: FileType.file,
        );
      } else if (entity is Directory) {
        yield FileInfo(
          path: entity.path,
          name: p.basename(entity.path),
          sizeBytes:
              0, // Directories technically 0 size in this context usually
          modifiedAt: stat.modified,
          accessedAt: <credential-fixture>,
          type: FileType.directory,
        );
      }
    }
  }

  bool _shouldIgnore(String path) {
    final relativePath = p.relative(path, from: rootPath);
    // Basic ignore logic based on simple suffix/prefix matching for now.
    // Can be enhanced with proper .gitignore parsing logic later.
    for (final pattern in _ignoredPatterns) {
      if (relativePath.contains(pattern) || relativePath == pattern) {
        return true;
      }
    }
    return false;
  }
}
