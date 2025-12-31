import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:repository_cleaner/domain/entities/file_info.dart';
import 'package:repository_cleaner/infrastructure/archive/advanced_archive_manager.dart';
import 'package:test/test.dart';

void main() {
  group('AdvancedArchiveManager', () {
    late Directory tempDir;
    late AdvancedArchiveManager manager;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('archive_test_');
      manager =
          AdvancedArchiveManager(archiveRoot: p.join(tempDir.path, 'archive'));
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('compresses files into zip', () async {
      final file1 = File(p.join(tempDir.path, 'file1.txt'));
      await file1.writeAsString('content1');

      final info1 = FileInfo(
        path: file1.path,
        name: 'file1.txt',
        sizeBytes: 8,
        modifiedAt: DateTime.now(),
        accessedAt: <credential-fixture>(),
        type: FileType.file,
      );

      final archiveFile =
          await manager.compressFiles([info1], 'test_archive.zip');

      expect(await archiveFile.exists(), isTrue);

      // Verify content
      final bytes = await archiveFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      expect(archive.length, equals(1));
      expect(archive.first.name, contains('file1.txt'));
    });

    test('creates meta file', () async {
      final info1 = FileInfo(
        path: '/path/to/file1.txt',
        name: 'file1.txt',
        sizeBytes: 100,
        modifiedAt: DateTime.now(),
        accessedAt: <credential-fixture>(),
        type: FileType.file,
      );

      await manager.createMetaFile('test_archive.zip', [info1]);

      final metaFile =
          File(p.join(tempDir.path, 'archive', 'test_archive.zip.meta.json'));
      expect(await metaFile.exists(), isTrue);
      final content = await metaFile.readAsString();
      expect(content, contains('file1.txt'));
    });
  });
}
