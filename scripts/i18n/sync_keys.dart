// ignore_for_file: avoid_print, avoid_catches_without_on_clauses
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

/// Script to synchronize keys from the template ARB to other ARB files.
///
/// Usage: dart scripts/i18n/sync_keys.dart
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

  print('🔄 Synchronizing keys...');

  final templateJson = _readArb(templatePath);
  if (templateJson == null) {
    print('❌ Error: Could not read template file: $templatePath');
    exit(1);
  }

  // Get all keys including metadata
  final templateKeys = <credential-fixture>();

  final arbDirEntity = Directory(arbDir);
  if (!arbDirEntity.existsSync()) {
    print('❌ Error: ARB directory does not exist: $arbDir');
    exit(1);
  }

  var changesMade = false;

  for (final file in arbDirEntity.listSync()) {
    if (file is File &&
        file.path.endsWith('.arb') &&
        path.basename(file.path) != templateFile) {
      final fileName = path.basename(file.path);
      final fileJson = _readArb(file.path);

      if (fileJson == null) {
        print('⚠️ Warning: Could not read file: $fileName');
        continue;
      }

      final fileKeys = <credential-fixture>();
      final missingKeys = <credential-fixture>(fileKeys);

      // Filter out metadata keys if the main key is missing (usually they
      // go together, but let's be safe). If we just copy everything
      // missing, we cover metadata too.

      if (missingKeys.isNotEmpty) {
        print('📝 Adding ${missingKeys.length} missing keys to $fileName...');

        final newJson = Map<String, dynamic>.from(fileJson);

        for (final key in missingKeys) {
          // If it's a metadata key (starts with @), copy from template
          if (key.startsWith('@')) {
            newJson[key] = templateJson[key];
          } else {
            // It's a translation key.
            // For now, let's just copy the value to avoid breaking with nulls.
            // But we should probably not prefix it for production safety,
            // or maybe we SHOULD to indicate it needs translation.
            // Given "إضافة المفاتيح المفقودة تلقائياً", let's copy the value.
            newJson[key] = templateJson[key];
          }
        }

        // Flutter Gen usually likes the keys to be there. Order doesn't
        // strictly matter for parsing but good for git diffs.
        // Let's sort alphabetically for stability.
        final sortedKeys = <credential-fixture>()..sort();
        final sortedJson = {for (final k in sortedKeys) k: newJson[k]};

        const encoder = JsonEncoder.withIndent('  ');
        file.writeAsStringSync(encoder.convert(sortedJson));
        changesMade = true;
      } else {
        print('✅ $fileName is already distinct with template keys.');
      }
    }
  }

  if (changesMade) {
    print('\n✨ Sync completed. Files updated.');
  } else {
    print('\n✅ Sync completed. No changes needed.');
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

Map<String, dynamic>? _readArb(String filePath) {
  try {
    final file = File(filePath);
    if (!file.existsSync()) return null;
    final content = file.readAsStringSync();
    return jsonDecode(content) as Map<String, dynamic>;
  } catch (e) {
    print('Error parsing JSON in $filePath: $e');
    return null;
  }
}
