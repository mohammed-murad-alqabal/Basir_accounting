// ignore_for_file: avoid_print
import 'dart:io';

import 'package:path/path.dart' as path;

/// Script to find potential hardcoded strings in Dart files.
///
/// Usage: dart scripts/i18n/extract_strings.dart
void main() {
  final rootDir = Directory.current.path;
  final libDir = path.join(rootDir, 'lib');

  print(
    '🔍 Scanning for hardcoded strings in $libDir...',
  );

  final libDirEntity = Directory(libDir);
  if (!libDirEntity.existsSync()) {
    print('❌ Error: lib directory does not exist.');
    exit(1);
  }

  var issueCount = 0;

  // Heuristic regex to find strings in UI contexts
  // Matches: Text('...'), label: '...', hintText: '...', title: '...',
  // tooltip: '...'
  // Ignores: import, package:, assets
  final patterns = [
    RegExp(r"Text\(\s*'([^']*)'"),
    RegExp(r'Text\(\s*"([^"]*)"'),
    RegExp(r"label:\s*'([^']*)'"),
    RegExp(r'label:\s*"([^"]*)"'),
    RegExp(r"hintText:\s*'([^']*)'"),
    RegExp(r'hintText:\s*"([^"]*)"'),
    RegExp(r"title:\s*'([^']*)'"),
    RegExp(r'title:\s*"([^"]*)"'),
    RegExp(r"tooltip:\s*'([^']*)'"),
    RegExp(r'tooltip:\s*"([^"]*)"'),
  ];

  for (final file in libDirEntity.listSync(recursive: true)) {
    if (file is File &&
        file.path.endsWith('.dart') &&
        !file.path.contains('.g.dart') &&
        !file.path.contains('.freezed.dart')) {
      final content = file.readAsStringSync();
      final lines = content.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trim().startsWith('import') ||
            line.contains('package:') ||
            line.contains('assets/')) {
          continue;
        }

        for (final pattern in patterns) {
          final match = pattern.firstMatch(line);
          if (match != null) {
            final text = match.group(1);
            if (text != null && text.isNotEmpty && !_isLikelyCode(text)) {
              issueCount++;
              print('📍 ${path.relative(file.path, from: rootDir)}:${i + 1}');
              print('   String: "$text"');
              print('   Line: ${line.trim()}');
              print('');
            }
          }
        }
      }
    }
  }

  if (issueCount > 0) {
    print('⚠️ Found $issueCount potential hardcoded strings.');
    print('💡 Consider moving these to ARB files.');
  } else {
    print('✅ No obvious hardcoded strings found in lib/ directory.');
  }
}

bool _isLikelyCode(String text) {
  // Simple heuristics to ignore technical strings
  if (text.contains('/') || text.contains('_') || text.isEmpty) return true;
  if (RegExp(r'^[a-z0-9]+$').hasMatch(text)) {
    return true; // Single words like id, key
  }
  return false;
}
