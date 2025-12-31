import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:repository_cleaner/domain/entities/file_info.dart';
import 'package:repository_cleaner/infrastructure/analyzer/intelligent_file_analyzer.dart';
import 'package:repository_cleaner/infrastructure/scanner/advanced_repository_scanner.dart';
import 'package:test/test.dart';

void main() {
  group('AdvancedRepositoryScanner', () {
    late Directory tempDir;
    late AdvancedRepositoryScanner scanner;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('repo_cleaner_test_');
      scanner = AdvancedRepositoryScanner(rootPath: tempDir.path);
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('scans files correctly', () async {
      final file1 = File(p.join(tempDir.path, 'file1.txt'));
      await file1.writeAsString('content');

      final results = await scanner.scan().toList();
      expect(results.any((f) => f.name == 'file1.txt'), isTrue);
    });

    test('ignores build directory', () async {
      final buildDir = Directory(p.join(tempDir.path, 'build'));
      await buildDir.create();
      final buildFile = File(p.join(buildDir.path, 'ignored.txt'));
      await buildFile.writeAsString('ignored');

      final results = await scanner.scan().toList();
      expect(results.any((f) => f.name == 'ignored.txt'), isFalse);
    });
  });

  group('IntelligentFileAnalyzer', () {
    late IntelligentFileAnalyzer analyzer;
    late Directory tempDir;

    setUp(() async {
      analyzer = IntelligentFileAnalyzer();
      tempDir = await Directory.systemTemp.createTemp('analyzer_test_');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('categorizes dart files correctly', () async {
      final file = File(p.join(tempDir.path, 'main.dart'));
      await file.writeAsString('void main() {}');

      var info = FileInfo(
        path: file.path,
        name: 'main.dart',
        sizeBytes: 0,
        modifiedAt: DateTime.now(),
        accessedAt: <credential-fixture>(),
        type: FileType.file,
      );

      info = await analyzer.analyze(info);
      expect(info.category, equals(FileCategory.sourceCode));
    });

    test('categorizes test files correctly', () async {
      // Mock path structure
      final testPath = p.join(tempDir.path, 'test', 'unit_test.dart');
      final file = File(testPath);
      await file.create(recursive: true);
      await file.writeAsString('void main() {}');

      var info = FileInfo(
        path: file.path,
        name: 'unit_test.dart',
        sizeBytes: 0,
        modifiedAt: DateTime.now(),
        accessedAt: <credential-fixture>(),
        type: FileType.file,
      );

      info = await analyzer.analyze(info);
      expect(info.category, equals(FileCategory.test));
    });
  });
}
