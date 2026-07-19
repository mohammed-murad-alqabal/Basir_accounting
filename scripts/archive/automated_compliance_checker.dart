#!/usr/bin/env dart
// automated_compliance_checker.dart
// نظام فحص الامتثال التلقائي لمشروع بصير

import 'dart:convert';
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

/// نظام فحص الامتثال التلقائي
class AutomatedComplianceChecker {
  static const String configFile = '.kiro/compliance_rules.json';
  static const String reportFile = 'compliance_report.json';

  /// قواعد الامتثال الافتراضية
  static const Map<String, dynamic> defaultRules = {
    'incompatible_technologies': [
      {
        'pattern': r'\bTypeScript\b',
        'severity': 'error',
        'message': 'استخدم Dart بدلاً من TypeScript',
      },
      {
        'pattern': r'\bJavaScript\b',
        'severity': 'error',
        'message': 'استخدم Dart بدلاً من JavaScript',
      },
      {
        'pattern': r'\bNode\.js\b',
        'severity': 'error',
        'message': 'استخدم Flutter بدلاً من Node.js',
      },
      {
        'pattern': r'\bReact\b',
        'severity': 'error',
        'message': 'استخدم Flutter بدلاً من React',
      },
      {
        'pattern': r'\bVue\b',
        'severity': 'error',
        'message': 'استخدم Flutter بدلاً من Vue',
      },
      {
        'pattern': r'\bAngular\b',
        'severity': 'error',
        'message': 'استخدم Flutter بدلاً من Angular',
      },
      {
        'pattern': r'\bnpm install\b',
        'severity': 'error',
        'message': 'استخدم flutter pub get بدلاً من npm install',
      },
      {
        'pattern': r'\byarn add\b',
        'severity': 'error',
        'message': 'استخدم flutter pub add بدلاً من yarn add',
      },
      {
        'pattern': r'\bpackage\.json\b',
        'severity': 'warning',
        'message': 'استخدم pubspec.yaml بدلاً من package.json',
      },
      {
        'pattern': r'\brequirements\.txt\b',
        'severity': 'warning',
        'message': 'استخدم pubspec.yaml بدلاً من requirements.txt',
      },
    ],
    'required_flutter_patterns': [
      {
        'pattern': r'\bFlutter\b',
        'min_count': 1,
        'message': 'يجب ذكر Flutter في الملف',
      },
      {
        'pattern': r'\bDart\b',
        'min_count': 1,
        'message': 'يجب ذكر Dart في الملف',
      },
    ],
    'file_patterns': {
      'steering_files': r'\.kiro/steering/.*\.md$',
      'documentation': r'docs/.*\.md$',
      'guides': r'docs/guides/.*\.md$',
    },
    'exclusions': [
      r'\.git/',
      'build/',
      r'\.dart_tool/',
      'node_modules/',
      'coverage/',
      'test_results/',
    ],
  };

  /// تشغيل فحص الامتثال الشامل
  static Future<ComplianceReport> runComplianceCheck({
    bool autoFix = false,
    bool verbose = false,
  }) async {
    Logger.info('🔍 بدء فحص الامتثال التلقائي...\n');

    final report = ComplianceReport();
    final rules = await _loadRules();

    // فحص ملفات التوجيه
    await _checkSteeringFiles(report, rules, autoFix, verbose);

    // فحص ملفات التوثيق
    await _checkDocumentationFiles(report, rules, autoFix, verbose);

    // فحص ملفات الأدلة
    await _checkGuideFiles(report, rules, autoFix, verbose);

    // حفظ التقرير
    await _saveReport(report);

    return report;
  }

  /// تحميل قواعد الامتثال
  static Future<Map<String, dynamic>> _loadRules() async {
    final configFileObj = File(configFile);

    if (configFileObj.existsSync()) {
      try {
        final content = await configFileObj.readAsString();
        final decoded = json.decode(content);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } on Exception catch (e) {
        Logger.warning(
          '⚠️  خطأ في قراءة ملف القواعد، استخدام القواعد الافتراضية: $e',
        );
      }
    }

    // إنشاء ملف القواعد الافتراضي
    await _createDefaultRulesFile();
    return defaultRules;
  }

  /// إنشاء ملف القواعد الافتراضي
  static Future<void> _createDefaultRulesFile() async {
    final configFileObj = File(configFile);
    await configFileObj.parent.create(recursive: true);
    await configFileObj.writeAsString(
      const JsonEncoder.withIndent('  ').convert(defaultRules),
    );
    Logger.info('📝 تم إنشاء ملف القواعد الافتراضي: $configFile');
  }

  /// فحص ملفات التوجيه
  static Future<void> _checkSteeringFiles(
    ComplianceReport report,
    Map<String, dynamic> rules,
    bool autoFix,
    bool verbose,
  ) async {
    Logger.info('📁 فحص ملفات التوجيه...');

    final steeringDir = Directory('.kiro/steering');
    if (!steeringDir.existsSync()) {
      report.addError('مجلد التوجيه غير موجود: .kiro/steering');
      return;
    }

    await for (final entity in steeringDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.md')) {
        await _checkFile(entity, report, rules, autoFix, verbose);
      }
    }
  }

  /// فحص ملفات التوثيق
  static Future<void> _checkDocumentationFiles(
    ComplianceReport report,
    Map<String, dynamic> rules,
    bool autoFix,
    bool verbose,
  ) async {
    Logger.info('📚 فحص ملفات التوثيق...');

    final docsDir = Directory('Documentation');
    if (!docsDir.existsSync()) {
      report.addWarning('مجلد التوثيق غير موجود: Documentation');
      return;
    }

    await for (final entity in docsDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.md')) {
        await _checkFile(entity, report, rules, autoFix, verbose);
      }
    }
  }

  /// فحص ملفات الأدلة
  static Future<void> _checkGuideFiles(
    ComplianceReport report,
    Map<String, dynamic> rules,
    bool autoFix,
    bool verbose,
  ) async {
    Logger.info('📖 فحص ملفات الأدلة...');

    final guidesDir = Directory('docs/guides');
    if (!guidesDir.existsSync()) {
      report.addWarning('مجلد الأدلة غير موجود: docs/guides');
      return;
    }

    await for (final entity in guidesDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.md')) {
        await _checkFile(entity, report, rules, autoFix, verbose);
      }
    }
  }

  /// فحص ملف واحد
  static Future<void> _checkFile(
    File file,
    ComplianceReport report,
    Map<String, dynamic> rules,
    bool autoFix,
    bool verbose,
  ) async {
    final relativePath = file.path.replaceFirst(RegExp('^./'), '');

    // تحقق من الاستثناءات
    final exclusions = rules['exclusions'];
    if (exclusions is List && _isExcluded(relativePath, exclusions)) {
      if (verbose) Logger.info('⏭️  تم تخطي الملف (مستثنى): $relativePath');
      return;
    }

    try {
      final content = await file.readAsString();
      final fileName = file.path.split('/').last;

      if (verbose) Logger.info('🔍 فحص الملف: $relativePath');

      // فحص التقنيات غير المتوافقة
      await _checkIncompatibleTechnologies(
        file,
        content,
        fileName,
        report,
        rules,
        autoFix,
      );

      // فحص الأنماط المطلوبة
      await _checkRequiredPatterns(file, content, fileName, report, rules);

      report.filesChecked++;
    } on Exception catch (e) {
      report.addError('خطأ في قراءة الملف $relativePath: $e');
    }
  }

  /// فحص التقنيات غير المتوافقة
  static Future<void> _checkIncompatibleTechnologies(
    File file,
    String content,
    String fileName,
    ComplianceReport report,
    Map<String, dynamic> rules,
    bool autoFix,
  ) async {
    final incompatibleTechnologies = rules['incompatible_technologies'];
    if (incompatibleTechnologies is! List) return;

    for (final rule in incompatibleTechnologies) {
      if (rule is! Map<String, dynamic>) continue;

      final patternStr = rule['pattern'] as String?;
      if (patternStr == null) continue;

      final pattern = RegExp(patternStr, caseSensitive: false);
      final matches = pattern.allMatches(content);

      if (matches.isNotEmpty) {
        final severity = rule['severity'] as String? ?? 'warning';
        final message = rule['message'] as String? ?? 'مشكلة في التوافق';
        final violation = ComplianceViolation(
          file: file.path,
          line: _getLineNumber(content, matches.first.start),
          pattern: patternStr,
          message: message,
          severity: severity,
        );

        if (severity == 'error') {
          report.addViolation(violation);
        } else {
          report.addWarning('$fileName: $message');
        }

        // محاولة الإصلاح التلقائي
        final canAutoFix = rule['can_auto_fix'] as bool? ?? false;
        if (autoFix && canAutoFix) {
          await _attemptAutoFix(file, content, rule, report);
        }
      }
    }
  }

  /// فحص الأنماط المطلوبة
  static Future<void> _checkRequiredPatterns(
    File file,
    String content,
    String fileName,
    ComplianceReport report,
    Map<String, dynamic> rules,
  ) async {
    final requiredPatterns = rules['required_flutter_patterns'];
    if (requiredPatterns is! List) return;

    for (final rule in requiredPatterns) {
      if (rule is! Map<String, dynamic>) continue;

      final patternStr = rule['pattern'] as String?;
      if (patternStr == null) continue;

      final pattern = RegExp(patternStr, caseSensitive: false);
      final matches = pattern.allMatches(content);
      final minCount = rule['min_count'] as int? ?? 1;

      if (matches.length < minCount) {
        final message = rule['message'] as String? ?? 'نمط مطلوب مفقود';
        report.addWarning('$fileName: $message');
      }
    }
  }

  /// تحقق من الاستثناءات
  static bool _isExcluded(String path, List<dynamic> exclusions) {
    for (final exclusion in exclusions) {
      if (exclusion is String && RegExp(exclusion).hasMatch(path)) {
        return true;
      }
    }
    return false;
  }

  /// الحصول على رقم السطر
  static int _getLineNumber(String content, int position) =>
      content.substring(0, position).split('\n').length;

  /// محاولة الإصلاح التلقائي
  static Future<void> _attemptAutoFix(
    File file,
    String content,
    Map<String, dynamic> rule,
    ComplianceReport report,
  ) async {
    var fixedContent = content;
    final pattern = rule['pattern'] as String?;
    if (pattern == null) return;

    // قواعد الإصلاح التلقائي
    switch (pattern) {
      case r'\bnpm install\b':
        fixedContent = fixedContent.replaceAll(
          RegExp('npm install', caseSensitive: false),
          'flutter pub get',
        );
      case r'\byarn add\b':
        fixedContent = fixedContent.replaceAll(
          RegExp('yarn add', caseSensitive: false),
          'flutter pub add',
        );
      case r'\bpackage\.json\b':
        fixedContent = fixedContent.replaceAll(
          RegExp(r'package\.json', caseSensitive: false),
          'pubspec.yaml',
        );
      case r'\brequirements\.txt\b':
        fixedContent = fixedContent.replaceAll(
          RegExp(r'requirements\.txt', caseSensitive: false),
          'pubspec.yaml',
        );
    }

    if (fixedContent != content) {
      await file.writeAsString(fixedContent);
      report.addSuccess('تم إصلاح ${file.path} تلقائياً');
      report.autoFixesApplied++;
    }
  }

  /// حفظ التقرير
  static Future<void> _saveReport(ComplianceReport report) async {
    final reportFile = File(AutomatedComplianceChecker.reportFile);
    await reportFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(report.toJson()),
    );
  }
}

/// تقرير الامتثال
class ComplianceReport {
  final List<ComplianceViolation> violations = [];
  final List<String> warnings = [];
  final List<String> errors = [];
  final List<String> successes = [];
  int filesChecked = 0;
  int autoFixesApplied = 0;
  final DateTime timestamp = DateTime.now();

  void addViolation(ComplianceViolation violation) => violations.add(violation);
  void addWarning(String warning) => warnings.add(warning);
  void addError(String error) => errors.add(error);
  void addSuccess(String success) => successes.add(success);

  // Removed unused getters: hasViolations and hasWarnings

  double get complianceScore {
    final totalIssues = violations.length + errors.length + warnings.length;
    if (totalIssues == 0) return 100;

    final weightedScore =
        (violations.length * 3) + (errors.length * 2) + warnings.length;
    return ((filesChecked * 10 - weightedScore) / (filesChecked * 10) * 100)
        .clamp(0.0, 100.0);
  }

  void printReport() {
    Logger.info('\n📊 تقرير الامتثال التلقائي');
    Logger.info('=' * 50);
    Logger.info('📅 التاريخ: ${timestamp.toIso8601String()}');
    Logger.info('📁 الملفات المفحوصة: $filesChecked');
    Logger.info('🔧 الإصلاحات التلقائية: $autoFixesApplied');
    Logger.info('📈 نتيجة الامتثال: ${complianceScore.toStringAsFixed(1)}%');
    Logger.info('');

    if (successes.isNotEmpty) {
      Logger.success('✅ النجاحات (${successes.length}):');
      for (final success in successes) {
        Logger.success('  • $success');
      }
      Logger.info('');
    }

    if (violations.isNotEmpty) {
      Logger.error('❌ مخالفات الامتثال (${violations.length}):');
      for (final violation in violations) {
        Logger.error(
          '  • ${violation.file}:${violation.line} - ${violation.message}',
        );
      }
      Logger.info('');
    }

    if (errors.isNotEmpty) {
      Logger.error('🚫 الأخطاء (${errors.length}):');
      for (final error in errors) {
        Logger.error('  • $error');
      }
      Logger.info('');
    }

    if (warnings.isNotEmpty) {
      Logger.warning('⚠️  التحذيرات (${warnings.length}):');
      for (final warning in warnings) {
        Logger.warning('  • $warning');
      }
      Logger.info('');
    }

    // تقييم النتيجة
    if (complianceScore >= 95) {
      Logger.success('🎉 ممتاز! مستوى امتثال عالي');
    } else if (complianceScore >= 80) {
      Logger.info('👍 جيد! بعض التحسينات مطلوبة');
    } else if (complianceScore >= 60) {
      Logger.warning('⚠️  متوسط! تحسينات كبيرة مطلوبة');
    } else {
      Logger.error('❌ ضعيف! إصلاحات عاجلة مطلوبة');
    }
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'files_checked': filesChecked,
        'auto_fixes_applied': autoFixesApplied,
        'compliance_score': complianceScore,
        'violations': violations.map((v) => v.toJson()).toList(),
        'warnings': warnings,
        'errors': errors,
        'successes': successes,
      };
}

/// مخالفة الامتثال
class ComplianceViolation {
  ComplianceViolation({
    required this.file,
    required this.line,
    required this.pattern,
    required this.message,
    required this.severity,
  });
  final String file;
  final int line;
  final String pattern;
  final String message;
  final String severity;

  Map<String, dynamic> toJson() => {
        'file': file,
        'line': line,
        'pattern': pattern,
        'message': message,
        'severity': severity,
      };
}

/// النقطة الرئيسية للتشغيل
Future<void> main(List<String> args) async {
  final autoFix = args.contains('--auto-fix');
  final verbose = args.contains('--verbose');
  final help = args.contains('--help') || args.contains('-h');

  if (help) {
    Logger.info('''
🔍 نظام فحص الامتثال التلقائي لمشروع بصير

الاستخدام:
  dart run scripts/automated_compliance_checker.dart [options]

الخيارات:
  --auto-fix    تطبيق الإصلاحات التلقائية عند الإمكان
  --verbose     عرض تفاصيل إضافية أثناء الفحص
  --help, -h    عرض هذه المساعدة

أمثلة:
  dart run scripts/automated_compliance_checker.dart
  dart run scripts/automated_compliance_checker.dart --auto-fix
  dart run scripts/automated_compliance_checker.dart --verbose --auto-fix
''');
    return;
  }

  try {
    final report = await AutomatedComplianceChecker.runComplianceCheck(
      autoFix: autoFix,
      verbose: verbose,
    );

    report.printReport();

    // تحديد كود الخروج
    if (report.violations.isNotEmpty || report.errors.isNotEmpty) {
      exit(1); // فشل
    } else if (report.warnings.length > 5) {
      exit(2); // تحذيرات كثيرة
    } else {
      exit(0); // نجاح
    }
  } on Exception catch (e) {
    Logger.error('❌ خطأ في تشغيل فحص الامتثال: $e');
    exit(3);
  }
}
