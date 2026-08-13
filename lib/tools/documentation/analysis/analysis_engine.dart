import 'dart:io';

/// محرك تحليل الكود لاكتشاف العناصر غير الموثقة
///
/// يقوم بتحليل ملفات Dart واكتشاف العناصر العامة التي تحتاج documentation
class AnalysisEngine {
  List<AnalysisResult> _lastResults = const <AnalysisResult>[];

  /// تحليل ملف واحد
  ///
  /// يقوم بفحص الملف المحدد واكتشاف جميع العناصر العامة غير الموثقة
  Future<AnalysisResult> analyzeFile(String filePath) async {
    // ignore: avoid_slow_async_io
    final file = File(filePath);
    // ignore: avoid_slow_async_io
    if (!await file.exists()) {
      return AnalysisResult(
        filePath: filePath,
        undocumentedElements: const <UndocumentedElement>[],
        coveragePercentage: 100,
      );
    }

    // ignore: avoid_slow_async_io
    final content = await file.readAsString();
    final lines = content.split('\n');
    final undocumented = <UndocumentedElement>[];
    var totalElements = 0;

    // Regex definitions for public elements
    final classRegex = RegExp(r'^class\s+([A-Z]\w+)');
    final enumRegex = RegExp(r'^enum\s+([A-Z]\w+)');
    final methodRegex = RegExp(r'^\s*[\w\.\<\>]+\s+([a-z]\w+)\s*\(');
    // Ignore overrides and private members
    final overrideRegex = RegExp('@override');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Skip comments, imports, empty lines
      if (line.isEmpty ||
          line.startsWith('//') ||
          line.startsWith('import') ||
          line.startsWith('library') ||
          line.startsWith('part')) {
        continue;
      }

      String? name;
      ElementType? type;
      final signature = line;

      if (classRegex.hasMatch(line)) {
        name = classRegex.firstMatch(line)!.group(1);
        type = ElementType.classType;
      } else if (enumRegex.hasMatch(line)) {
        name = enumRegex.firstMatch(line)!.group(1);
        type = ElementType.enumType;
      } else if (methodRegex.hasMatch(line)) {
        final match = methodRegex.firstMatch(line)!;
        name = match.group(1);
        // Exclude private methods
        if (name != null && !name.startsWith('_')) {
          type = ElementType.method;
        }
      }

      // If we found a candidate public element
      if (name != null && type != null) {
        // Check for Override annotation in previous lines
        var isOverride = false;
        if (i > 0 && overrideRegex.hasMatch(lines[i - 1])) {
          isOverride = true;
        }

        if (!isOverride) {
          totalElements++;
          // Check for documentation in previous lines
          var hasDocs = false;
          if (i > 0) {
            final prev = lines[i - 1].trim();
            if (prev.startsWith('///') || prev.endsWith('*/')) {
              hasDocs = true;
            }
            // Handle @Override which might be above docs
            if (isOverride && i > 1) {
              final prev2 = lines[i - 2].trim();
              if (prev2.startsWith('///') || prev2.endsWith('*/')) {
                hasDocs = true;
              }
            }
          }

          if (!hasDocs) {
            undocumented.add(
              UndocumentedElement(
                name: name,
                type: type,
                lineNumber: i + 1, // 1-based
                signature: signature,
              ),
            );
          }
        }
      }
    }

    var coverage = 100.0;
    if (totalElements > 0) {
      coverage =
          ((totalElements - undocumented.length) / totalElements) * 100.0;
    }

    return AnalysisResult(
      filePath: filePath,
      undocumentedElements: undocumented,
      totalElements: totalElements,
      coveragePercentage: coverage,
    );
  }

  /// تحليل مجلد كامل
  Future<List<AnalysisResult>> analyzeDirectory(String dirPath) async {
    // ignore: avoid_slow_async_io
    final dir = Directory(dirPath);
    // ignore: avoid_slow_async_io
    if (!await dir.exists()) return [];

    final results = <AnalysisResult>[];
    // ignore: avoid_slow_async_io
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File &&
          entity.path.endsWith('.dart') &&
          !entity.path.contains('.g.dart') &&
          !entity.path.contains('.freezed.dart')) {
        results.add(await analyzeFile(entity.path));
      }
    }
    _lastResults = results;
    return results;
  }

  /// الحصول على إحصائيات التغطية من آخر تحليل مكتمل.
  CoverageStats getCoverageStats() {
    final total = _lastResults.fold<int>(
      0,
      (sum, result) => sum + result.totalElements,
    );
    final undocumented = _lastResults.fold<int>(
      0,
      (sum, result) => sum + result.undocumentedElements.length,
    );
    final documented = total - undocumented;
    return CoverageStats(
      totalElements: total,
      documentedElements: documented,
      undocumentedElements: undocumented,
      coveragePercentage: CoverageStats.calculateCoverage(documented, total),
      elementBreakdown: const <ElementType, int>{},
    );
  }
}

/// نتيجة تحليل ملف
class AnalysisResult {
  /// إنشاء نتيجة تحليل
  const AnalysisResult({
    required this.filePath,
    required this.undocumentedElements,
    required this.coveragePercentage,
    this.totalElements = 0,
  });

  /// مسار الملف
  final String filePath;

  /// قائمة العناصر غير الموثقة
  final List<UndocumentedElement> undocumentedElements;

  /// إجمالي العناصر العامة التي حللها المحرك في الملف.
  final int totalElements;

  /// نسبة التغطية (0-100)
  final double coveragePercentage;
}

/// عنصر غير موثق
class UndocumentedElement {
  /// إنشاء عنصر غير موثق
  const UndocumentedElement({
    required this.name,
    required this.type,
    required this.lineNumber,
    required this.signature,
  });

  /// اسم العنصر
  final String name;

  /// نوع العنصر
  final ElementType type;

  /// رقم السطر
  final int lineNumber;

  /// التوقيع
  final String signature;
}

/// نوع العنصر
enum ElementType {
  /// كلاس
  classType,

  /// دالة
  method,

  /// خاصية
  property,

  /// enum
  enumType,

  /// typedef
  typedef,
}

/// إحصائيات تغطية التوثيق
class CoverageStats {
  /// إنشاء إحصائيات التغطية
  const CoverageStats({
    required this.totalElements,
    required this.documentedElements,
    required this.undocumentedElements,
    required this.coveragePercentage,
    required this.elementBreakdown,
  });

  /// إجمالي عدد العناصر
  final int totalElements;

  /// عدد العناصر الموثقة
  final int documentedElements;

  /// عدد العناصر غير الموثقة
  final int undocumentedElements;

  /// نسبة التغطية (0-100)
  final double coveragePercentage;

  /// تفصيل العناصر حسب النوع
  final Map<ElementType, int> elementBreakdown;

  /// حساب نسبة التغطية
  static double calculateCoverage(int documented, int total) {
    if (total == 0) return 100;
    return (documented / total) * 100.0;
  }
}
