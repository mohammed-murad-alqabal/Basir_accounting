// ignore_for_file: avoid_print, avoid_catches_without_on_clauses
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

/// Script to generate statistics for translations.
///
/// Usage: dart scripts/i18n/stats.dart
void main() {
  final rootDir = Directory.current.path;
  final l10nYamlPath = path.join(rootDir, 'l10n.yaml');
  final l10nConfig = _parseL10nYaml(l10nYamlPath);

  if (l10nConfig == null) {
    print('❌ Error: Could not parse l10n.yaml');
    exit(1);
  }

  final arbDir = path.join(
    rootDir,
    (l10nConfig['arb-dir'] as String?) ?? 'lib/l10n',
  );
  final templateFile =
      (l10nConfig['template-arb-file'] as String?) ?? 'app_en.arb';
  final templatePath = path.join(arbDir, templateFile);

  print('📊 Generating Translation Statistics...');

  final templateKeys = <credential-fixture>(templatePath);
  if (templateKeys == null) {
    print('❌ Error: Could not read template file: $templatePath');
    exit(1);
  }

  final totalKeys = <credential-fixture>;
  print('🔑 Total Keys (Template): $totalKeys');
  print('\n${'-' * 60}');
  print(
    '${'Locale'.padRight(10)} | ${'Translated'.padRight(12)} | '
    '${'Missing'.padRight(10)} | ${'Coverage'.padRight(10)}',
  );
  print('-' * 60);

  final arbDirEntity = Directory(arbDir);
  if (!arbDirEntity.existsSync()) {
    print('❌ Error: ARB directory does not exist: $arbDir');
    exit(1);
  }

  for (final file in arbDirEntity.listSync()) {
    if (file is File && file.path.endsWith('.arb')) {
      final fileName = path.basename(file.path);
      final locale = fileName.replaceAll('.arb', '').replaceAll('app_', '');

      final fileKeys = <credential-fixture>(file.path);
      if (fileKeys == null) continue;

      final translatedCount = fileKeys.length;
      final missingCount =
          totalKeys - fileKeys.intersection(templateKeys).length;
      // Note: This logic assumes only keys present in template count
      // towards coverage. Extra keys in locale files are ignored.

      final coverage =
          ((fileKeys.intersection(templateKeys).length / totalKeys) * 100)
              .toStringAsFixed(1);

      print(
        '${locale.padRight(10)} | '
        '${translatedCount.toString().padRight(12)} | '
        '${missingCount.toString().padRight(10)} | $coverage%',
      );
    }
  }
  print('-' * 60 + '\n');
}

Map<String, dynamic>? _parseL10nYaml(String filePath) {
  try {
    final file = File(filePath);
    if (!file.existsSync()) return null;
    final content = file.readAsStringSync();
    final config = <String, String>{};
    for (final line in content.split('\n')) {
      final parts = line.split(':');
      if (parts.length >= 2) {
        config[parts[0].trim()] = parts.sublist(1).join(':').trim();
      }
    }
    return config;
  } catch (e) {
    return null;
  }
}

Set<String>? _getArbKeys(String filePath) {
  try {
    final file = File(filePath);
    if (!file.existsSync()) return null;
    final content = file.readAsStringSync();
    final json = jsonDecode(content) as Map<String, dynamic>;
    return json.keys.where((k) => !k.startsWith('@')).toSet();
  } catch (e) {
    print('Error parsing JSON in $filePath: $e');
    return null;
  }
}
