// ignore_for_file: avoid_print, avoid_types_on_closure_parameters, require_trailing_commas

import 'dart:convert';
import 'dart:io';

import 'package:basir_accounting_system/tools/documentation/analysis/analysis_engine.dart';
import 'package:basir_accounting_system/tools/documentation/generation/generation_engine.dart';
import 'package:basir_accounting_system/tools/documentation/governance/governance_engine.dart';
import 'package:basir_accounting_system/tools/documentation/repository/documentation_repository.dart';
import 'package:basir_accounting_system/tools/documentation/validation/validation_engine.dart';

/// أداة سطر الأوامر لنظام التوثيق
///
/// توفر واجهة سطر أوامر لتشغيل جميع وظائف نظام التوثيق
class DocumentationCLI {
  /// إنشاء أداة CLI
  DocumentationCLI()
      : _analysisEngine = AnalysisEngine(),
        _generationEngine = GenerationEngine(),
        _validationEngine = ValidationEngine(),
        _repository = DocumentationRepository();

  /// محرك التحليل
  final AnalysisEngine _analysisEngine;

  /// محرك التوليد
  final GenerationEngine _generationEngine;

  /// محرك التحقق
  final ValidationEngine _validationEngine;

  /// مستودع التوثيق
  // ignore: unused_field
  final DocumentationRepository _repository;

  /// تشغيل الأداة
  ///
  /// Parameters:
  /// - [args]: قائمة المعاملات من سطر الأوامر
  ///
  /// Returns: كود الخروج (0 للنجاح، غير 0 للفشل)
  Future<int> run(List<String> args) async {
    if (args.isEmpty) {
      _printUsage();
      return 1;
    }

    final command = args[0];
    final commandArgs = args.skip(1).toList();

    try {
      switch (command) {
        case 'analyze':
          return await _runAnalyze(commandArgs);
        case 'generate':
          return await _runGenerate(commandArgs);
        case 'validate':
          return await _runValidate(commandArgs);
        case 'report':
          return await _runReport(commandArgs);
        case 'governance':
          return await _runGovernance(commandArgs);
        case 'help':
        case '--help':
        case '-h':
          _printUsage();
          return 0;
        default:
          _printUsage();
          return 1;
      }
    } on Exception {
      return 1;
    }
  }

  /// تشغيل أمر التحليل
  Future<int> _runAnalyze(List<String> args) async {
    var path = 'lib/';
    var verbose = false;
    var enforce = false;
    var threshold = 70.0;

    // معالجة المعاملات
    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--path':
        case '-p':
          if (i + 1 < args.length) {
            path = args[i + 1];
            i++;
          }
        case '--verbose':
        case '-v':
          verbose = true;
        case '--enforce':
          enforce = true;
        case '--threshold':
          if (i + 1 < args.length) {
            threshold = double.tryParse(args[++i]) ?? threshold;
          }
      }
    }

    try {
      // تحليل المجلد
      final results = await _analysisEngine.analyzeDirectory(path);
      final stats = _analysisEngine.getCoverageStats();

      // عرض الإحصاءات الفعلية بصيغة ثابتة تستهلكها بوابة CI.
      print('Coverage: ${stats.coveragePercentage.toStringAsFixed(1)}%');
      print(
          'Documented elements: ${stats.documentedElements}/${stats.totalElements}');
      print('Undocumented elements: ${stats.undocumentedElements}');

      if (verbose) {
        for (final result in results) {
          print(
            '│   ├── Coverage: '
            '${result.coveragePercentage.toStringAsFixed(1)}%',
          );
        }
      }

      // يعرض التحليل القياس دائمًا. لا يتحول إلى حاجز إلا عند طلب
      // enforce صراحةً؛ يتيح ذلك رفع artifact وتعليق PR حتى عند فشل الحد.
      return !enforce || stats.coveragePercentage >= threshold ? 0 : 1;
    } on Exception {
      return 1;
    }
  }

  /// تشغيل أمر التوليد
  Future<int> _runGenerate(List<String> args) async {
    var path = 'lib/';
    var dryRun = false;
    // var force = false; // TODO(basir): استخدام force في المستقبل

    // معالجة المعاملات
    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--path':
        case '-p':
          if (i + 1 < args.length) {
            path = args[i + 1];
            i++;
          }
        case '--dry-run':
        case '-d':
          dryRun = true;
        case '--force':
        case '-f':
          // force = true; // TODO(basir): استخدام force في المستقبل
          break;
      }
    }

    try {
      // تحليل أولاً
      final results = await _analysisEngine.analyzeDirectory(path);

      for (final result in results) {
        if (result.undocumentedElements.isNotEmpty) {
          // توليد التوثيق
          final docs = _generationEngine.generateFileDocumentation(result);

          if (dryRun) {
            print(
              '📝 Would generate ${docs.length} docs for ${result.filePath}',
            );
          } else {
            // تطبيق التوثيق
            await _generationEngine.applyDocumentation(result.filePath, docs);
          }
        }
      }

      return 0;
    } on Exception {
      return 1;
    }
  }

  /// تشغيل أمر التحقق
  Future<int> _runValidate(List<String> args) async {
    var strict = false;

    // معالجة المعاملات
    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--path':
        case '-p':
          if (i + 1 < args.length) {
            i++; // تخطي قيمة المسار
          }
        case '--strict':
        case '-s':
          strict = true;
      }
    }

    try {
      // التحقق من المشروع
      final result = _validationEngine.validateProject();

      // عرض النتائج
      if (result.totalIssues > 0) {
        for (final fileResult in result.fileResults) {
          if (fileResult.elementResults.any((r) => r.issues.isNotEmpty)) {
            for (final elementResult in fileResult.elementResults) {
              for (final _ in elementResult.issues) {
                // معالجة المشاكل (يمكن إضافة منطق هنا لاحقاً)
              }
            }
          }
        }
      }

      // تحديد حالة الخروج
      if (strict) {
        return result.isValid && result.overallScore.score >= 90 ? 0 : 1;
      } else {
        return result.overallScore.score >= 70 ? 0 : 1;
      }
    } on Exception {
      return 1;
    }
  }

  /// تشغيل فحص حوكمة التوثيق وقواعد التتبع الحتمية.
  Future<int> _runGovernance(List<String> args) async {
    var base = 'HEAD~1';
    var head = 'HEAD';
    String? changedFilesFile;
    String? prBodyFile;
    var output = 'governance-report.json';
    var markdownOutput = 'governance-report.md';
    var enforce = false;

    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--base':
          if (i + 1 < args.length) base = args[++i];
        case '--head':
          if (i + 1 < args.length) head = args[++i];
        case '--changed-files':
          if (i + 1 < args.length) changedFilesFile = args[++i];
        case '--pr-body-file':
          if (i + 1 < args.length) prBodyFile = args[++i];
        case '--output':
        case '-o':
          if (i + 1 < args.length) output = args[++i];
        case '--markdown-output':
          if (i + 1 < args.length) markdownOutput = args[++i];
        case '--enforce':
          enforce = true;
      }
    }

    try {
      final root = Directory.current;
      final engine = GovernanceEngine();
      final changedFiles = changedFilesFile == null
          ? await engine.changedFiles(root: root, base: base, head: head)
          : LineSplitter.split(await File(changedFilesFile).readAsString())
              .map((String value) => value.trim())
              .where((String value) => value.isNotEmpty)
              .toList(growable: false);
      final prBody =
          prBodyFile == null ? '' : await File(prBodyFile).readAsString();
      final report = await engine.analyze(
        root: root,
        changedFiles: changedFiles,
        prBody: prBody,
      );

      await File(output).writeAsString(
          const JsonEncoder.withIndent('  ').convert(report.toJson()));
      await File(markdownOutput).writeAsString(report.toMarkdown());
      print(report.toMarkdown());

      // Advisory mode always returns success. Enforced mode may be enabled only
      // after the repository has measured and resolved warning false positives.
      return enforce && report.issues.isNotEmpty ? 1 : 0;
    } on Exception catch (error) {
      stderr.writeln('Governance check failed: $error');
      return 1;
    }
  }

  /// تشغيل أمر التقرير بإخراج فعلي قابل للأرشفة في CI.
  Future<int> _runReport(List<String> args) async {
    var path = 'lib/';
    var format = 'markdown';
    var output = 'documentation-report.md';

    for (var i = 0; i < args.length; i++) {
      if (args[i].startsWith('--path=')) {
        path = args[i].substring('--path='.length);
        continue;
      }
      if (args[i].startsWith('--format=')) {
        format = args[i].substring('--format='.length);
        continue;
      }
      if (args[i].startsWith('--output=')) {
        output = args[i].substring('--output='.length);
        continue;
      }
      switch (args[i]) {
        case '--path':
        case '-p':
          if (i + 1 < args.length) path = args[++i];
        case '--format':
        case '-f':
          if (i + 1 < args.length) format = args[++i];
        case '--output':
        case '-o':
          if (i + 1 < args.length) output = args[++i];
      }
    }

    try {
      final results = await _analysisEngine.analyzeDirectory(path);
      final stats = _analysisEngine.getCoverageStats();
      final lowCoverage = results
          .where((AnalysisResult result) => result.coveragePercentage < 70)
          .toList(growable: false);
      final report = <String, Object?>{
        'path': path,
        'coverage_percentage': stats.coveragePercentage,
        'total_elements': stats.totalElements,
        'documented_elements': stats.documentedElements,
        'undocumented_elements': stats.undocumentedElements,
        'files_below_70_percent': lowCoverage
            .map((AnalysisResult result) => <String, Object?>{
                  'path': result.filePath,
                  'coverage_percentage': result.coveragePercentage,
                  'undocumented_elements': result.undocumentedElements.length,
                })
            .toList(growable: false),
      };
      final normalizedFormat = format.toLowerCase();
      final content = normalizedFormat == 'json'
          ? const JsonEncoder.withIndent('  ').convert(report)
          : _documentationReportMarkdown(report);
      await File(output).writeAsString(content);
      print('Documentation report: $output');
      print('Coverage: ${stats.coveragePercentage.toStringAsFixed(1)}%');
      return 0;
    } on Exception catch (error) {
      stderr.writeln('Documentation report failed: $error');
      return 1;
    }
  }

  String _documentationReportMarkdown(Map<String, Object?> report) {
    final lowCoverage = report['files_below_70_percent']! as List<Object?>;
    final buffer = StringBuffer()
      ..writeln('# Documentation Coverage Report')
      ..writeln()
      ..writeln('| Metric | Value |')
      ..writeln('| --- | ---: |')
      ..writeln('| Path | `${report['path']}` |')
      ..writeln(
          '| Coverage | ${(report['coverage_percentage']! as double).toStringAsFixed(1)}% |')
      ..writeln(
          '| Documented elements | ${report['documented_elements']} / ${report['total_elements']} |')
      ..writeln(
          '| Undocumented elements | ${report['undocumented_elements']} |')
      ..writeln();
    if (lowCoverage.isEmpty) {
      buffer.writeln('No files are below 70% documented coverage.');
    } else {
      buffer
        ..writeln('## Files below 70% coverage')
        ..writeln()
        ..writeln('| File | Coverage | Undocumented elements |')
        ..writeln('| --- | ---: | ---: |');
      for (final item in lowCoverage.cast<Map<String, Object?>>()) {
        buffer.writeln(
          '| `${item['path']}` | ${(item['coverage_percentage']! as double).toStringAsFixed(1)}% | ${item['undocumented_elements']} |',
        );
      }
    }
    return buffer.toString();
  }

  /// طباعة تعليمات الاستخدام
  void _printUsage() {
    print('''
📚 Documentation CLI Tool

Usage: dart run lib/tools/documentation/cli/documentation_cli.dart <command> [options]

Commands:
  analyze     Analyze documentation coverage
  generate    Generate missing documentation
  validate    Validate documentation quality
  report      Generate documentation report
  governance  Analyze documentation governance in advisory or enforced mode
  help        Show this help message

Options:
  --path, -p <path>       Path to analyze (default: lib/)
  --verbose, -v           Show detailed output
  --dry-run, -d           Show what would be generated without applying
  --force, -f             Force generation even if documentation exists
  --strict, -s            Use strict validation rules
  --enforce                Return non-zero when an applicable check fails
  --threshold <percent>    Coverage threshold used with analyze --enforce
  --format, -f <format>   Report format (json, html, markdown, csv)
  --output, -o <file>     Output file name
  --base <git-ref>        Base ref for governance changed-file detection
  --head <git-ref>        Head ref for governance changed-file detection
  --changed-files <file>  Newline-delimited changed files for governance
  --pr-body-file <file>   Pull-request body for REQ/ADR traceability checks
  --markdown-output <file> Markdown destination for governance output
  --enforce               Return non-zero when governance observations exist

Examples:
  # Analyze documentation coverage
  dart run lib/tools/documentation/cli/documentation_cli.dart analyze

  # Generate missing documentation
  dart run lib/tools/documentation/cli/documentation_cli.dart generate --path lib/features

  # Validate documentation quality
  dart run lib/tools/documentation/cli/documentation_cli.dart validate --strict

  # Generate HTML report
  dart run lib/tools/documentation/cli/documentation_cli.dart report --format html

  # Run the deterministic governance check without blocking a merge
  dart run lib/tools/documentation/cli/documentation_cli.dart governance --base origin/main --head HEAD
''');
  }

  /// تحويل النص إلى صيغة تقرير
  // ignore: unused_element
  ReportFormat _parseReportFormat(String format) {
    switch (format.toLowerCase()) {
      case 'json':
        return ReportFormat.json;
      case 'html':
        return ReportFormat.html;
      case 'markdown':
      case 'md':
        return ReportFormat.markdown;
      case 'csv':
        return ReportFormat.csv;
      default:
        return ReportFormat.markdown;
    }
  }
}

/// نقطة الدخول الرئيسية
Future<void> main(List<String> args) async {
  final cli = DocumentationCLI();
  final exitCode = await cli.run(args);
  exit(exitCode);
}
