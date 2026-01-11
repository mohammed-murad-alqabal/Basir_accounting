import 'dart:io';

import 'package:basir_accounting_system/tools/documentation/analysis/analysis_engine.dart';

/// محرك توليد التوثيق التلقائي
class GenerationEngine {
  /// توليد documentation لعنصر واحد
  // ignore: prefer_expression_function_bodies
  String generateDocumentation(UndocumentedElement element) {
    return _generateDescription(element);
  }

  /// توليد documentation لملف كامل
  Map<String, String> generateFileDocumentation(AnalysisResult result) {
    final docs = <String, String>{};
    for (final element in result.undocumentedElements) {
      docs[element.name] = _generateDescription(element);
    }
    return docs;
  }

  /// تطبيق التوثيق على الملف
  Future<void> applyDocumentation(
    String filePath,
    Map<String, String> docs,
  ) async {
    // ignore: avoid_slow_async_io
    final file = File(filePath);
    // ignore: avoid_slow_async_io
    if (!await file.exists()) return;

    // ignore: avoid_slow_async_io
    final lines = await file.readAsLines();
    final newLines = <String>[];

    // Simplified Application Logic:
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      var inserted = false;

      for (final entry in docs.entries) {
        // Heuristic: if line defines the element name
        if (line.contains('class ${entry.key}') ||
            line.contains('enum ${entry.key}') ||
            line.contains('${entry.key}(')) {
          // Check if already documented in lines[i-1] (simple check)
          var commented = false;
          if (i > 0 && lines[i - 1].trim().startsWith('///')) {
            commented = true;
          }

          if (!commented) {
            newLines.add('  /// ${entry.value}');
            inserted = true;
            break; // Only one doc per line
          }
        }
      }
      newLines.add(line);
      if (inserted) {
        // Placeholder for logging or future logic
      }
    }

    // ignore: avoid_slow_async_io
    await file.writeAsString(newLines.join('\n'));
  }

  /// توليد وصف تلقائي
  String _generateDescription(UndocumentedElement element) {
    final name = element.name;
    // CamelCase to Sentence case
    final buffer = StringBuffer();
    for (var i = 0; i < name.length; i++) {
      final char = name[i];
      if (i == 0) {
        buffer.write(char.toUpperCase());
      } else if (char == char.toUpperCase() &&
          !char.contains(RegExp('[0-9_]'))) {
        buffer.write(' ${char.toLowerCase()}');
      } else {
        buffer.write(char);
      }
    }

    switch (element.type) {
      case ElementType.classType:
        return 'Class representing various $buffer.';
      case ElementType.enumType:
        return 'Enum defining types of $buffer.';
      case ElementType.method:
        return 'Method to $buffer.';
      // ignore: no_default_cases
      default:
        return '$buffer.';
    }
  }
}

/// خيارات التوليد
class GenerationOptions {
  /// إنشاء خيارات التوليد
  const GenerationOptions({
    this.useArabic = true,
    this.useEnglish = false,
    this.includeExamples = false,
    this.includeDetails = true,
  });

  /// استخدام اللغة العربية
  final bool useArabic;

  /// استخدام اللغة الإنجليزية
  final bool useEnglish;

  /// تضمين أمثلة
  final bool includeExamples;

  /// تضمين تفاصيل
  final bool includeDetails;

  /// الخيارات الافتراضية
  static const GenerationOptions defaults = GenerationOptions();

  /// خيارات شاملة
  static const GenerationOptions comprehensive = GenerationOptions(
    useEnglish: true,
    includeExamples: true,
  );
}
