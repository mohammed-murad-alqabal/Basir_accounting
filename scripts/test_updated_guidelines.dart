#!/usr/bin/env dart
// test_updated_guidelines.dart
// سكريبت اختبار الإرشادات المحدثة لمشروع بصير

import 'dart:io';

/// Simple logging utility for development scripts
class Logger {
  static void info(String message) {
    stderr.writeln('[INFO] $message');
  }

  static void warning(String message) {
    stderr.writeln('[WARNING] $message');
  }

  static void error(String message) {
    stderr.writeln('[ERROR] $message');
  }

  static void success(String message) {
    stderr.writeln('[SUCCESS] $message');
  }
}

/// فئة لاختبار الإرشادات المحدثة
class GuidelinesValidator {
  static const String steeringPath = '.kiro/steering';
  static const List<String> requiredFiles = [
    'technologies/project-standards.md',
    'technologies/development-standards.md',
    'technologies/frontend-standards.md',
    'technologies/security-best-practices.md',
    'technologies/testing-best-practices.md',
    'technologies/mcp-best-practices.md',
  ];

  /// تشغيل جميع اختبارات التحقق
  static Future<ValidationReport> runAllTests() async {
    Logger.info('🔍 بدء اختبار الإرشادات المحدثة...\n');

    final report = ValidationReport();

    // اختبار وجود الملفات المطلوبة
    await testRequiredFiles(report);

    // اختبار خلو الملفات من المراجع غير المتوافقة
    await testIncompatibleReferences(report);

    // اختبار جودة المحتوى
    await testContentQuality(report);

    // اختبار التوافق مع Flutter/Dart
    await testFlutterCompatibility(report);

    // اختبار الاتساق
    await testConsistency(report);

    return report;
  }

  /// اختبار وجود الملفات المطلوبة
  static Future<void> testRequiredFiles(ValidationReport report) async {
    Logger.info('📁 اختبار وجود الملفات المطلوبة...');

    for (final fileName in requiredFiles) {
      final filePath = '$steeringPath/$fileName';
      final file = File(filePath);

      if (file.existsSync()) {
        report.addSuccess('✅ الملف موجود: $fileName');
      } else {
        report.addError('❌ الملف مفقود: $fileName');
      }
    }
    Logger.info('');
  }

  /// اختبار خلو الملفات من المراجع غير المتوافقة
  static Future<void> testIncompatibleReferences(
    ValidationReport report,
  ) async {
    Logger.info('🚫 اختبار المراجع غير المتوافقة...');

    final incompatiblePatterns = [
      RegExp(r'\bTypeScript\b', caseSensitive: false),
      RegExp(r'\bJavaScript\b', caseSensitive: false),
      RegExp(r'\bNode\.js\b', caseSensitive: false),
      RegExp(r'\bReact\b', caseSensitive: false),
      RegExp(r'\bVue\b', caseSensitive: false),
      RegExp(r'\bAngular\b', caseSensitive: false),
      RegExp(r'\bnpm install\b', caseSensitive: false),
      RegExp(r'\byarn add\b', caseSensitive: false),
      RegExp(r'\bpackage\.json\b', caseSensitive: false),
    ];

    final directory = Directory(steeringPath);
    await for (final entity in directory.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.md')) {
        final content = await entity.readAsString();
        final fileName = entity.path.split('/').last;

        for (final pattern in incompatiblePatterns) {
          final matches = pattern.allMatches(content);
          if (matches.isNotEmpty) {
            report.addWarning(
              '⚠️  مرجع غير متوافق في $fileName: ${pattern.pattern}',
            );
          }
        }
      }
    }

    if (report.warnings.isEmpty) {
      report.addSuccess('✅ لا توجد مراجع غير متوافقة');
    }
    Logger.info('');
  }

  /// اختبار جودة المحتوى
  static Future<void> testContentQuality(ValidationReport report) async {
    Logger.info('📝 اختبار جودة المحتوى...');

    final directory = Directory(steeringPath);
    await for (final entity in directory.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.md')) {
        final content = await entity.readAsString();
        final fileName = entity.path.split('/').last;

        // اختبار طول المحتوى
        if (content.length < 500) {
          report.addWarning(
            '⚠️  محتوى قصير في $fileName (${content.length} حرف)',
          );
        }

        // اختبار وجود العناوين
        if (!content.contains('# ')) {
          report.addError('❌ لا يوجد عنوان رئيسي في $fileName');
        }

        // اختبار وجود أمثلة كود
        if (fileName.contains('standards') && !content.contains('```')) {
          report.addWarning('⚠️  لا توجد أمثلة كود في $fileName');
        }
      }
    }
    Logger.info('');
  }

  /// اختبار التوافق مع Flutter/Dart
  static Future<void> testFlutterCompatibility(ValidationReport report) async {
    Logger.info('🎯 اختبار التوافق مع Flutter/Dart...');

    final flutterKeywords = [
      'Flutter',
      'Dart',
      'Widget',
      'StatelessWidget',
      'StatefulWidget',
      'pubspec.yaml',
      'flutter test',
      'dart analyze',
    ];

    final directory = Directory(steeringPath);
    var totalFlutterReferences = 0;

    await for (final entity in directory.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.md')) {
        final content = await entity.readAsString();

        for (final keyword in flutterKeywords) {
          totalFlutterReferences +=
              RegExp(keyword, caseSensitive: false).allMatches(content).length;
        }
      }
    }

    if (totalFlutterReferences > 50) {
      report.addSuccess(
        '✅ توافق جيد مع Flutter/Dart ($totalFlutterReferences مرجع)',
      );
    } else {
      report.addWarning(
        '⚠️  توافق ضعيف مع Flutter/Dart ($totalFlutterReferences مرجع)',
      );
    }
    Logger.info('');
  }

  /// اختبار الاتساق
  static Future<void> testConsistency(ValidationReport report) async {
    Logger.info('🔄 اختبار الاتساق...');

    // اختبار اتساق التسمية
    final directory = Directory(steeringPath);
    final fileNames = <String>[];

    await for (final entity in directory.list()) {
      if (entity is File && entity.path.endsWith('.md')) {
        fileNames.add(entity.path.split('/').last);
      }
    }

    // التحقق من نمط التسمية
    final namingPattern = RegExp(r'^[a-z-]+\.md$');
    for (final fileName in fileNames) {
      if (!namingPattern.hasMatch(fileName)) {
        report.addWarning('⚠️  نمط تسمية غير متسق: $fileName');
      }
    }

    if (report.warnings.where((w) => w.contains('نمط تسمية')).isEmpty) {
      report.addSuccess('✅ نمط التسمية متسق');
    }
    Logger.info('');
  }
}

/// تقرير نتائج التحقق
class ValidationReport {
  final List<String> successes = [];
  final List<String> warnings = [];
  final List<String> errors = [];

  void addSuccess(String message) => successes.add(message);
  void addWarning(String message) => warnings.add(message);
  void addError(String message) => errors.add(message);

  /// طباعة التقرير النهائي
  void printReport() {
    Logger.info('📊 تقرير اختبار الإرشادات المحدثة');
    Logger.info('=' * 50);

    Logger.info('\n✅ النجاحات (${successes.length}):');
    for (final success in successes) {
      Logger.info('  $success');
    }

    if (warnings.isNotEmpty) {
      Logger.warning('\n⚠️  التحذيرات (${warnings.length}):');
      for (final warning in warnings) {
        Logger.warning('  $warning');
      }
    }

    if (errors.isNotEmpty) {
      Logger.error('\n❌ الأخطاء (${errors.length}):');
      for (final error in errors) {
        Logger.error('  $error');
      }
    }

    Logger.info('\n📈 الملخص:');
    Logger.info('  • النجاحات: ${successes.length}');
    Logger.info('  • التحذيرات: ${warnings.length}');
    Logger.info('  • الأخطاء: ${errors.length}');

    final totalIssues = warnings.length + errors.length;
    final successRate =
        successes.length / (successes.length + totalIssues) * 100;

    Logger.info('  • معدل النجاح: ${successRate.toStringAsFixed(1)}%');

    if (errors.isEmpty && warnings.length <= 3) {
      Logger.success('\n🎉 الإرشادات جاهزة للاستخدام!');
    } else if (errors.isEmpty) {
      Logger.warning('\n⚠️  الإرشادات تحتاج تحسينات طفيفة');
    } else {
      Logger.error('\n❌ الإرشادات تحتاج إصلاحات قبل الاستخدام');
    }
  }

  /// حفظ التقرير في ملف
  Future<void> saveToFile(String filePath) async {
    final file = File(filePath);
    final buffer = StringBuffer();

    buffer.writeln('# تقرير اختبار الإرشادات المحدثة');
    buffer.writeln('**التاريخ:** ${DateTime.now().toIso8601String()}');
    buffer.writeln('**المشروع:** بصير MVP');
    buffer.writeln();

    buffer.writeln('## النتائج');
    buffer.writeln('- النجاحات: ${successes.length}');
    buffer.writeln('- التحذيرات: ${warnings.length}');
    buffer.writeln('- الأخطاء: ${errors.length}');
    buffer.writeln();

    if (successes.isNotEmpty) {
      buffer.writeln('## ✅ النجاحات');
      for (final success in successes) {
        buffer.writeln('- $success');
      }
      buffer.writeln();
    }

    if (warnings.isNotEmpty) {
      buffer.writeln('## ⚠️ التحذيرات');
      for (final warning in warnings) {
        buffer.writeln('- $warning');
      }
      buffer.writeln();
    }

    if (errors.isNotEmpty) {
      buffer.writeln('## ❌ الأخطاء');
      for (final error in errors) {
        buffer.writeln('- $error');
      }
      buffer.writeln();
    }

    await file.writeAsString(buffer.toString());
    Logger.success('💾 تم حفظ التقرير في: $filePath');
  }
}

/// النقطة الرئيسية للتشغيل
Future<void> main(List<String> args) async {
  try {
    final report = await GuidelinesValidator.runAllTests();
    report.printReport();

    // حفظ التقرير
    final timestamp = DateTime.now().toIso8601String().split('T')[0];
    await report.saveToFile('test_results/guidelines_test_$timestamp.md');

    // تحديد كود الخروج
    if (report.errors.isNotEmpty) {
      exit(1); // فشل
    } else if (report.warnings.length > 5) {
      exit(2); // تحذيرات كثيرة
    } else {
      exit(0); // نجاح
    }
  } on Exception catch (e) {
    Logger.error('❌ خطأ في تشغيل الاختبار: $e');
    exit(3);
  }
}
