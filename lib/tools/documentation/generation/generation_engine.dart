import 'dart:io';

import 'package:basir_accounting_system/tools/documentation/analysis/analysis_engine.dart';
import 'package:basir_accounting_system/tools/documentation/generation/documentation_template.dart';

/// محرك توليد التوثيق التلقائي
class GenerationEngine {
  /// توليد documentation لعنصر واحد مع دعم خيارات التوليد
  String generateDocumentation(
    UndocumentedElement element, {
    GenerationOptions options = GenerationOptions.defaults,
  }) {
    final description = _generateDescription(element, arabic: options.useArabic);
    final details =
        options.includeDetails ? _generateDetails(element, arabic: options.useArabic) : null;

    final template = DocumentationTemplate.fromType(element.type);
    final context = <String, dynamic>{
      'useArabic': options.useArabic,
      'description': description,
      if (details != null) 'details': details,
    };

    try {
      final result = template.generate(context);
      if (result.isNotEmpty) {
        return _stripDocSlashes(result);
      }
    } on Exception {
      // Fallback to simple description if template fails
    }
    return description;
  }

  /// توليد documentation لملف كامل مع دعم خيارات التوليد
  Map<String, String> generateFileDocumentation(
    AnalysisResult result, {
    GenerationOptions options = GenerationOptions.defaults,
  }) {
    final docs = <String, String>{};
    for (final element in result.undocumentedElements) {
      docs[element.name] = generateDocumentation(element, options: options);
    }
    return docs;
  }

  /// توليد documentation FORCE لملف كامل (بما في ذلك العناصر الموثقة سابقاً).
  ///
  /// تُستخدم مع علم --force لإعادة إنشاء كل التوثيق
  /// وتحديثه حتى لو كان موجوداً بالفعل. يعيد خريطة بتوقيع كل عنصر كعنصر مفتاح
  /// لتمكين مطابقته عبر الخط الكامل (لا يعتمد على اسم العنصر فقط).
  Map<String, String> generateFileDocumentationForce(
    AnalysisResult result, {
    GenerationOptions options = GenerationOptions.defaults,
  }) {
    final docs = <String, String>{};

    for (final element in result.undocumentedElements) {
      docs[element.name] = generateDocumentation(element, options: options);
    }
    for (final element in result.undocumentedElements) {
      docs['_sig::${element.signature.trim()}'] = generateDocumentation(element, options: options);
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
            while (newLines.isNotEmpty && newLines.last.trim().startsWith('///')) {
              newLines.removeLast();
            }
          }

          // Check if already documented in lines[i-1] (simple check)
          var commented = false;
          if (!forceOverwrite && i > 0 && lines[i - 1].trim().startsWith('///')) {
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
  String _generateDescription(UndocumentedElement element, {bool arabic = true}) {
    final name = element.name;
    final readable = _humanizeName(name);

    switch (element.type) {
      case ElementType.classType:
        return arabic
            ? 'كلاس يمثل $readable في النظام.'
            : 'Class representing $readable in the system.';
      case ElementType.enumType:
        return arabic
            ? 'تعداد يحدد أنواع مختلفة من $readable.'
            : 'Enum defining different types of $readable.';
      case ElementType.method:
        return arabic ? 'دالة تقوم بـ $readable.' : 'Method to perform $readable.';
      case ElementType.property:
        return arabic ? 'خاصية تخزن قيمة $readable.' : 'Property storing $readable value.';
      case ElementType.typedef:
        return arabic ? 'تعريف نوع لـ $readable.' : 'Type definition for $readable.';
    }
  }

  /// توليد تفاصيل إضافية للعنصر
  String? _generateDetails(UndocumentedElement element, {bool arabic = true}) {
    final name = element.name;
    final readable = _humanizeName(name);

    switch (element.type) {
      case ElementType.classType:
        return arabic
            ? 'يقوم هذا الكلاس بإدارة منطق $readable داخل النظام مع الالتزام بمعايير التصميم المعماري للمشروع.'
            : 'This class manages the $readable logic within the system while adhering to the project architectural design standards.';
      case ElementType.enumType:
        return arabic
            ? 'يحتوي هذا التعداد على جميع الحالات الممكنة لـ $readable مع ضمان الاتساق في الاستخدام عبر الوحدات المختلفة.'
            : 'Contains all possible states for $readable ensuring consistent usage across different modules.';
      case ElementType.method:
        return arabic
            ? 'تقوم هذه الدالة بتنفيذ عملية $readable وفقاً لقواعد العمل المحددة، مع إرجاع النتيجة المناسبة.'
            : 'Executes the $readable operation according to specified business rules and returns the appropriate result.';
      case ElementType.property:
      case ElementType.typedef:
        return null;
    }
  }

  /// تحويل CamelCase/SnakeCase إلى نص مقروء
  String _humanizeName(String name) {
    final buffer = StringBuffer();
    for (var i = 0; i < name.length; i++) {
      final char = name[i];
      if (i == 0) {
        buffer.write(char.toLowerCase());
      } else if (char == char.toUpperCase() && !char.contains(RegExp('[0-9_]'))) {
        buffer.write(' ${char.toLowerCase()}');
      } else if (char == '_') {
        buffer.write(' ');
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString().trim();
  }

  /// إزالة /// من بداية أسطر التوثيق عند استخدامها كنص واحد
  String _stripDocSlashes(String doc) {
    final lines = doc.split('\n');
    final cleaned = <String>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('///')) {
        cleaned.add(trimmed.substring(3).trim());
      } else {
        cleaned.add(line);
      }
    }
    return cleaned.join('\n').trim();
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
