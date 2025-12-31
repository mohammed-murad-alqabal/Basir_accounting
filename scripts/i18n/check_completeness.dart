// ignore_for_file: avoid_print, avoid_catches_without_on_clauses
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

/// Script to check for missing keys in ARB files compared to the template.
///
/// Usage: dart scripts/i18n/check_completeness.dart
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

  print(
    '🔍 Checking ARB completeness...',
  );
  print('📂 ARB Directory: $arbDir');
  print('📄 Template File: $templateFile');

  final templateKeys = <credential-fixture>(templatePath);
  if (templateKeys == null) {
    print('❌ Error: Could not read template file: $templatePath');
    exit(1);
  }

  print('🔑 Total keys in template: ${templateKeys.length}');

  final arbDirEntity = Directory(arbDir);
  if (!arbDirEntity.existsSync()) {
    print('❌ Error: ARB directory does not exist: $arbDir');
    exit(1);
  }

  var hasErrors = false;

  for (final file in arbDirEntity.listSync()) {
    if (file is File &&
        file.path.endsWith('.arb') &&
        path.basename(file.path) != templateFile) {
      final fileName = path.basename(file.path);
      final fileKeys = <credential-fixture>(file.path);

      if (fileKeys == null) {
        print('⚠️ Warning: Could not read file: $fileName');
        continue;
      }

      final missingKeys = <credential-fixture>(fileKeys);

      if (missingKeys.isNotEmpty) {
        hasErrors = true;
        print('\n❌ Missing keys in $fileName:');
        for (final key in missingKeys) {
          print('   - $key');
        }
      } else {
        print('✅ $fileName is complete.');
      }
    }
  }

  if (hasErrors) {
    print(
      '\n❌ Completeness check failed. Some files are missing translations.',
    );
    exit(1);
  } else {
    print('\n✅ All ARB files are complete!');
    exit(0);
  }
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
    // Filter out metadata keys (starting with @)
    return json.keys.where((k) => !k.startsWith('@')).toSet();
  } catch (e) {
    print('Error parsing JSON in $filePath: $e');
    return null;
  }
}
