import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:repository_cleaner/domain/entities/file_info.dart';

class IntelligentFileAnalyzer {
  Future<FileInfo> analyze(FileInfo info) async {
    final file = File(info.path);
    if (!await file.exists()) return info;

    final category = _determineCategory(info.path);
    final checksum = await _computeChecksum(file);

    return info.copyWith(
      category: category,
      checksum: checksum,
    );
  }

  FileCategory _determineCategory(String path) {
    final ext = p.extension(path).toLowerCase();
    final name = p.basename(path).toLowerCase();

    if (name.startsWith('.')) return FileCategory.configuration;

    switch (ext) {
      case '.dart':
        if (path.contains('/test/')) return FileCategory.test;
        return FileCategory.sourceCode;
      case '.png':
      case '.jpg':
      case '.jpeg':
      case '.svg':
      case '.ico':
        return FileCategory.asset;
      case '.log':
      case '.tmp':
      case '.bak':
        return FileCategory.log; // Or temporary
      case '.md':
      case '.txt':
      case '.pdf':
        return FileCategory.documentation;
      case '.yaml':
      case '.json':
      case '.lock':
      case '.gradle':
      case '.properties':
        return FileCategory.configuration;
      case '.zip':
      case '.tar':
      case '.gz':
        return FileCategory.archive;
      default:
        return FileCategory.unknown;
    }
  }

  Future<String> _computeChecksum(File file) async {
    try {
      if (await file.length() > 50 * 1024 * 1024) {
        // Skip checksum for files > 50MB for performance for now
        return 'SKIP_LARGE_FILE';
      }
      final stream = file.openRead();
      final digest = await sha256.bind(stream).first;
      return digest.toString();
    } catch (e) {
      return 'ERROR_CHECKSUM';
    }
  }
}
