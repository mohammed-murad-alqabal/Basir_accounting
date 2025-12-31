import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:repository_cleaner/domain/entities/file_info.dart';

class AdvancedArchiveManager {
  AdvancedArchiveManager({required this.archiveRoot});
  final String archiveRoot;

  Future<File> compressFiles(List<FileInfo> files, String archiveName) async {
    final encoder = ZipFileEncoder();
    final archivePath = p.join(archiveRoot, archiveName);

    // Ensure directory exists
    final archiveFile = File(archivePath);
    await archiveFile.parent.create(recursive: true);

    encoder.create(archivePath);

    for (final fileInfo in files) {
      final file = File(fileInfo.path);
      if (await file.exists()) {
        await encoder.addFile(file);
      }
    }

    encoder.close();
    return File(archivePath);
  }

  Future<void> createMetaFile(String archiveName, List<FileInfo> files) async {
    final metaPath = p.join(archiveRoot, '$archiveName.meta.json');
    final file = File(metaPath);

    // Safety: ensure directory exists
    await file.parent.create(recursive: true);

    final buffer = StringBuffer();
    buffer.writeln('{');
    buffer.writeln('  "archive": "$archiveName",');
    buffer.writeln('  "created_at": "${DateTime.now().toIso8601String()}",');
    buffer.writeln('  "files": [');
    for (var i = 0; i < files.length; i++) {
      final f = files[i];
      buffer.write('    {"path": "${f.path}", "size": ${f.sizeBytes}}');
      if (i < files.length - 1) {
        buffer.writeln(',');
      } else {
        buffer.writeln();
      }
    }
    buffer.writeln('  ]');
    buffer.writeln('}');

    await file.writeAsString(buffer.toString());
  }
}
