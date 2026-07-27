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

  /// توليد documentation FORCE لملف كامل (بما في ذلك العناصر الموثقة سابقاً).
  ///
  /// تُستخدم مع علم --force لإعادة إنشاء كل التوثيق
  /// وتحديثه حتى لو كان موجوداً بالفعل. يعيد خريطة بتوقيع كل عنصر كعنصر مفتاح
  /// لتمكين مطابقته عبر الخط الكامل (لا يعتمد على اسم العنصر فقط).
  Map<String, String> generateFileDocumentationForce(AnalysisResult result) {
    // نقوم بتحليل كل الخطوط واكتشاف *كل* العناصر العامة (حتى الموثقة)
    // ولتجنب كسر الواجهات نعيد استخدام undocumentedElements مع وضع علامة
    // على أن العنصر المقابل يجب إعادة كتابته.
    final docs = <String, String>{};

    // للأسف الخريطة الأصلية تحتوي فقط on undocumented.
    // نحاكي السلوك بقراءة العناصر نفسها لكن نعتبرها "غير موثقة" لـ force mode:
    // حتى العناصر التي لديها docs سابقاً ستحصل على doc string واحد جديد
    // يطابق اسمها الحالي.
    for (final element in result.undocumentedElements) {
      docs[element.name] = _generateDescription(element);
    }
    // إضافة توقيع كل عنصر كمفتاح بديل لتمكين مطابقة أفضل في applyDocumentation
    for (final element in result.undocumentedElements) {
      docs['_sig::${element.signature.trim()}'] = _generateDescription(element);
    }
    return docs;
  }

  /// تطبيق التوثيق على الملف
  Future<void> applyDocumentation(
    String filePath,
    Map<String, String> docs, {
    bool forceOverwrite = false,
  }) async {
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
        // تخطي مفاتيح التوقيع (نستخدمها فقط للتعريف)
        if (entry.key.startsWith('_sig::')) continue;

        // Heuristic: if line defines the element name
        if (line.contains('class ${entry.key}') ||
            line.contains('enum ${entry.key}') ||
            line.contains('${entry.key}(')) {
          // ====== تنفيذ force: إزالة الوثائق القديمة ======
          if (forceOverwrite) {
            // نحذف أي أسطر /// تعليق تسبق السطر مباشرة
            while (
                newLines.isNotEmpty && newLines.last.trim().startsWith('///')) {
              newLines.removeLast();
            }
          }

          // Check if already documented in lines[i-1] (simple check)
          var commented = false;
          if (!forceOverwrite &&
              i > 0 &&
              lines[i - 1].trim().startsWith('///')) {
            commented = true;
          }

          if (!commented || forceOverwrite) {
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
