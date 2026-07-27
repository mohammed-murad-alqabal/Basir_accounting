// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:basir_accounting_system/tools/documentation/analysis/analysis_engine.dart';
import 'package:basir_accounting_system/tools/documentation/generation/generation_engine.dart';
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
  final DocumentationRepository _repository;

  /// تشغيل الأداة
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
      }
    }

    try {
      final results = await _analysisEngine.analyzeDirectory(path);
      final stats = _analysisEngine.getCoverageStats();

      if (verbose) {
        for (final result in results) {
          print(
            '│   ├── Coverage: '
            '${result.coveragePercentage.toStringAsFixed(1)}%',
          );
        }
      }

      return stats.coveragePercentage >= 70 ? 0 : 1;
    } on Exception {
      return 1;
    }
  }

  /// تشغيل أمر التوليد
  Future<int> _runGenerate(List<String> args) async {
    var path = 'lib/';
    var dryRun = false;
    var force = false;

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
          force = true;
      }
    }

    try {
      final results = await _analysisEngine.analyzeDirectory(path);
      var totalGenerated = 0;
      var totalSkipped = 0;

      for (final result in results) {
        if (result.undocumentedElements.isNotEmpty || force) {
          final docs = force
              ? _generationEngine.generateFileDocumentationForce(result)
              : _generationEngine.generateFileDocumentation(result);

          if (docs.isEmpty) continue;

          if (dryRun) {
            print(
              '📝 Would generate ${docs.length} docs for ${result.filePath}',
            );
          } else {
            await _generationEngine.applyDocumentation(
              result.filePath,
              docs,
              forceOverwrite: force,
            );
            print('✅ Generated ${docs.length} docs → ${result.filePath}');
          }
          totalGenerated += docs.length;
        } else {
          totalSkipped++;
        }
      }

      print(
        force
            ? '⚡ FORCE MODE: $totalGenerated docs regenerated'
            : '📊 Total: $totalGenerated new docs, $totalSkipped files skipped (fully documented)',
      );

      return 0;
    } on Exception {
      return 1;
    }
  }

  /// تشغيل أمر التحقق
  Future<int> _runValidate(List<String> args) async {
    var strict = false;

    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--path':
        case '-p':
          if (i + 1 < args.length) {
            i++;
          }
        case '--strict':
        case '-s':
          strict = true;
      }
    }

    try {
      final result = _validationEngine.validateProject();

      if (result.totalIssues > 0) {
        for (final fileResult in result.fileResults) {
          if (fileResult.elementResults.any((r) => r.issues.isNotEmpty)) {
            for (final elementResult in fileResult.elementResults) {
              for (final _ in elementResult.issues) {
                // can be extended later
              }
            }
          }
        }
      }

      if (strict) {
        return result.isValid && result.overallScore.score >= 90 ? 0 : 1;
      } else {
        return result.overallScore.score >= 70 ? 0 : 1;
      }
    } on Exception {
      return 1;
    }
  }

  /// تشغيل أمر التقرير
  Future<int> _runReport(List<String> args) async {
    var format = ReportFormat.markdown;
    var output = '';

    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--format':
        case '-f':
          if (i + 1 < args.length) {
            format = _parseReportFormat(args[i + 1]);
            i++;
          }
        case '--output':
        case '-o':
          if (i + 1 < args.length) {
            output = args[i + 1];
            i++;
          }
      }
    }

    try {
      final analysisResults = await _analysisEngine.analyzeDirectory('lib/');
      final stats = _analysisEngine.getCoverageStats();
      final validationResult = _validationEngine.validateProject();

      // نسخة CoverageReport المبسطة للتخزين (مسارات فقط)
      final report = CoverageReport(
        timestamp: DateTime.now(),
        analyzedFiles: analysisResults.map((r) => r.filePath).toList(),
        stats: stats,
        lowCoverageFiles: analysisResults
            .where((r) => r.coveragePercentage < 70)
            .map((r) => r.filePath)
            .toList(),
      );

      try {
        await _repository.saveCoverageReport(report);
      } on Exception {
        // non-fatal
      }

      final String content;
      switch (format) {
        case ReportFormat.json:
          content =
              _formatJsonReport(analysisResults, report, validationResult);
        case ReportFormat.markdown:
          content =
              _formatMarkdownReport(analysisResults, report, validationResult);
        case ReportFormat.html:
          content =
              _formatHtmlReport(analysisResults, report, validationResult);
        case ReportFormat.csv:
          content = _formatCsvReport(analysisResults, report, validationResult);
        case ReportFormat.text:
          content =
              _formatTextReport(analysisResults, report, validationResult);
      }

      if (output.isNotEmpty) {
        final outFile = File(output);
        if (!outFile.parent.existsSync()) {
          await outFile.parent.create(recursive: true);
        }
        await outFile.writeAsString(content);
        print('✅ Report saved to $output (${format.name})');
      } else {
        print(content);
      }

      return 0;
    } on Exception {
      return 1;
    }
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
  help        Show this help message

Options:
  --path, -p <path>       Path to analyze (default: lib/)
  --verbose, -v           Show detailed output
  --dry-run, -d           Show what would be generated without applying
  --force, -f             Force generation even if documentation exists
  --strict, -s            Use strict validation rules
  --format, -f <format>   Report format (json, html, markdown, csv)
  --output, -o <file>     Output file name

Examples:
  # Analyze documentation coverage
  dart run lib/tools/documentation/cli/documentation_cli.dart analyze

  # Generate missing documentation
  dart run lib/tools/documentation/cli/documentation_cli.dart generate --path lib/features

  # Validate documentation quality
  dart run lib/tools/documentation/cli/documentation_cli.dart validate --strict

  # Generate HTML report
  dart run lib/tools/documentation/cli/documentation_cli.dart report --format html
''');
  }

  // ==================== REPORT FORMATTERS ====================

  /// تنسيق تقرير JSON
  String _formatJsonReport(
    List<AnalysisResult> analysisResults,
    CoverageReport report,
    ProjectValidationResult validation,
  ) {
    final json = <String, dynamic>{
      'generatedAt': report.timestamp.toIso8601String(),
      'summary': {
        'totalFiles': report.analyzedFiles.length,
        'lowCoverageFiles': report.lowCoverageFiles.length,
        'coveragePercentage': report.stats.coveragePercentage,
        'totalElements': report.stats.totalElements,
        'documentedElements': report.stats.documentedElements,
        'undocumentedElements': report.stats.undocumentedElements,
        'validationValid': validation.isValid,
        'validationScore': validation.overallScore.score,
        'validationRating': validation.overallScore.rating,
        'validationTotalIssues': validation.totalIssues,
      },
      'files': <dynamic>[
        for (final f in analysisResults)
          {
            'path': f.filePath,
            'coveragePercentage': f.coveragePercentage,
            'undocumentedCount': f.undocumentedElements.length,
            'undocumentedElements': [
              for (final e in f.undocumentedElements)
                {
                  'name': e.name,
                  'type': e.type.name,
                  'line': e.lineNumber,
                },
            ],
          },
      ],
      'lowCoverageFiles': [
        for (final f in analysisResults.where((r) => r.coveragePercentage < 70))
          {
            'path': f.filePath,
            'coveragePercentage': f.coveragePercentage,
          },
      ],
    };

    const jsonEncoder = JsonEncoder.withIndent('  ');
    return jsonEncoder.convert(json);
  }

  /// تنسيق تقرير Markdown
  String _formatMarkdownReport(
    List<AnalysisResult> analysisResults,
    CoverageReport report,
    ProjectValidationResult validation,
  ) {
    final buf = StringBuffer()
      ..writeln('# 📚 Documentation Coverage Report')
      ..writeln()
      ..writeln('*Generated at: ${report.timestamp.toIso8601String()}*')
      ..writeln()
      ..writeln('## Summary')
      ..writeln()
      ..writeln('| Metric | Value |')
      ..writeln('|--------|-------|')
      ..writeln('| Total Files | ${report.analyzedFiles.length} |')
      ..writeln(
        '| Low Coverage (<70%) | ${report.lowCoverageFiles.length} |',
      )
      ..writeln(
        '| Coverage Percentage | ${report.stats.coveragePercentage.toStringAsFixed(1)}% |',
      )
      ..writeln('| Total Elements | ${report.stats.totalElements} |')
      ..writeln('| Documented | ${report.stats.documentedElements} |')
      ..writeln('| Undocumented | ${report.stats.undocumentedElements} |')
      ..writeln(
          '| Validation Valid | ${validation.isValid ? "✅ Yes" : "❌ No"} |')
      ..writeln(
        '| Validation Score | ${validation.overallScore.rating} (${validation.overallScore.score}) |',
      )
      ..writeln('| Validation Issues | ${validation.totalIssues} |')
      ..writeln();

    if (report.lowCoverageFiles.isNotEmpty) {
      buf
        ..writeln('## Low Coverage Files (Action Required)')
        ..writeln();
      for (final path in report.lowCoverageFiles) {
        final cov = analysisResults
                .where((r) => r.filePath == path)
                .firstOrNull
                ?.coveragePercentage ??
            0.0;
        buf.writeln('- ⚠️  `$path`: ${cov.toStringAsFixed(1)}%');
      }
      buf.writeln();
    }

    buf.writeln('## Per-File Breakdown');
    for (final f in analysisResults) {
      buf
        ..writeln()
        ..writeln(
          '### `${f.filePath}` — ${f.coveragePercentage.toStringAsFixed(1)}%',
        )
        ..writeln();
      if (f.undocumentedElements.isEmpty) {
        buf.writeln('✅ Fully documented!');
      } else {
        buf
          ..writeln('| Name | Type | Line |')
          ..writeln('|------|------|------|');
        for (final e in f.undocumentedElements) {
          buf.writeln('| `${e.name}` | ${e.type.name} | ${e.lineNumber} |');
        }
      }
    }

    return buf.toString();
  }

  /// تنسيق تقرير CSV
  String _formatCsvReport(
    List<AnalysisResult> analysisResults,
    CoverageReport report,
    ProjectValidationResult validation,
  ) {
    final rows = <List<String>>[
      [
        'file_path',
        'coverage_pct',
        'undocumented_count',
        'element_name',
        'element_type',
        'element_line',
      ],
    ];

    for (final f in analysisResults) {
      if (f.undocumentedElements.isEmpty) {
        rows.add([
          f.filePath,
          f.coveragePercentage.toStringAsFixed(2),
          '0',
          '',
          '',
          '',
        ]);
      } else {
        for (final e in f.undocumentedElements) {
          rows.add([
            f.filePath,
            f.coveragePercentage.toStringAsFixed(2),
            f.undocumentedElements.length.toString(),
            e.name,
            e.type.name,
            e.lineNumber.toString(),
          ]);
        }
      }
    }

    return rows
        .map(
          (r) => r.map((cell) {
            if (cell.contains(',') ||
                cell.contains('"') ||
                cell.contains('\n')) {
              return '"${cell.replaceAll('"', '""')}"';
            }
            return cell;
          }).join(','),
        )
        .join('\n');
  }

  /// تنسيق تقرير HTML
  String _formatHtmlReport(
    List<AnalysisResult> analysisResults,
    CoverageReport report,
    ProjectValidationResult validation,
  ) {
    final validClass = validation.isValid ? 'valid' : 'invalid';
    final coverageColor = report.stats.coveragePercentage >= 70
        ? 'color: #2ecc71;'
        : 'color: #e67e22;';

    final filesRows = analysisResults.map((f) {
      final badge = f.coveragePercentage >= 70
          ? '🟢'
          : (f.coveragePercentage >= 50 ? '🟡' : '🔴');
      final undocumentedRows = f.undocumentedElements.isEmpty
          ? '<tr><td colspan="3" style="color: #2ecc71;">✅ Fully documented</td></tr>'
          : f.undocumentedElements
              .map(
                (e) =>
                    '<tr><td><code>${e.name}</code></td><td>${e.type.name}</td><td>${e.lineNumber}</td></tr>',
              )
              .join();

      return '''
        <details class="file-card">
          <summary>
            <span class="badge">$badge</span>
            <code>${f.filePath}</code>
            <span class="coverage">${f.coveragePercentage.toStringAsFixed(1)}%</span>
          </summary>
          <table>
            <thead><tr><th>Element</th><th>Type</th><th>Line</th></tr></thead>
            <tbody>$undocumentedRows</tbody>
          </table>
        </details>''';
    }).join();

    return '''
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Basir Documentation Report</title>
<style>
  body { font-family: system-ui, -apple-system, sans-serif; max-width: 1100px; margin: 2rem auto; padding: 0 1rem; color: #1f2937; }
  h1 { color: #111827; }
  .summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px,1fr)); gap: 1rem; margin: 1.5rem 0; }
  .card { background: #f9fafb; padding: 1rem 1.25rem; border-radius: 0.5rem; border: 1px solid #e5e7eb; }
  .card .label { font-size: 0.85rem; color: #6b7280; text-transform: uppercase; letter-spacing: 0.02em; }
  .card .value { font-size: 1.6rem; font-weight: 700; margin-top: 0.25rem; }
  .valid .value { color: #059669; } .invalid .value { color: #dc2626; }
  details.file-card { margin: 0.5rem 0; padding: 0.75rem 1rem; background: #fff; border: 1px solid #e5e7eb; border-radius: 0.5rem; }
  summary { cursor: pointer; font-weight: 500; display: flex; align-items: center; gap: 0.5rem; }
  summary .coverage { margin-left: auto; font-variant-numeric: tabular-nums; font-weight: 600; }
  summary code { background: #f3f4f6; padding: 0.1rem 0.35rem; border-radius: 4px; }
  table { width: 100%; margin-top: 0.75rem; border-collapse: collapse; }
  th, td { padding: 0.5rem 0.75rem; border-bottom: 1px solid #f1f5f9; text-align: left; font-size: 0.92rem; }
  th { color: #64748b; font-weight: 600; background: #f8fafc; }
  code { font-family: ui-monospace, SFMono-Regular, Menlo, monospace; font-size: 0.85em; }
</style>
</head>
<body>
  <h1>📚 Basir — Documentation Coverage Report</h1>
  <p>Generated at <code>${report.timestamp.toIso8601String()}</code></p>

  <section class="summary">
    <div class="card"><div class="label">Total Files</div><div class="value">${report.analyzedFiles.length}</div></div>
    <div class="card"><div class="label">Coverage</div><div class="value" style="$coverageColor">${report.stats.coveragePercentage.toStringAsFixed(1)}%</div></div>
    <div class="card"><div class="label">Undocumented Elements</div><div class="value">${report.stats.undocumentedElements}</div></div>
    <div class="card $validClass"><div class="label">Validation (${validation.overallScore.rating})</div><div class="value">${validation.isValid ? "PASS" : "FAIL"} · ${validation.overallScore.score}/100</div></div>
    <div class="card"><div class="label">Validation Issues</div><div class="value">${validation.totalIssues}</div></div>
    <div class="card"><div class="label">Low Coverage Files</div><div class="value" style="color: #dc2626;">${report.lowCoverageFiles.length}</div></div>
  </section>

  <h2>Per-File Coverage</h2>
  $filesRows
</body>
</html>''';
  }

  /// تنسيق تقرير نصي (plain text)
  String _formatTextReport(
    List<AnalysisResult> analysisResults,
    CoverageReport report,
    ProjectValidationResult validation,
  ) {
    final buf = StringBuffer()
      ..writeln('=== Documentation Coverage Report ===')
      ..writeln('Generated at: ${report.timestamp.toIso8601String()}')
      ..writeln()
      ..writeln('SUMMARY')
      ..writeln('-------')
      ..writeln('Total Files: ${report.analyzedFiles.length}')
      ..writeln(
        'Coverage: ${report.stats.coveragePercentage.toStringAsFixed(1)}%',
      )
      ..writeln('Total Elements: ${report.stats.totalElements}')
      ..writeln('Documented: ${report.stats.documentedElements}')
      ..writeln('Undocumented: ${report.stats.undocumentedElements}')
      ..writeln('Low Coverage (<70%): ${report.lowCoverageFiles.length}')
      ..writeln(
        'Validation: ${validation.isValid ? "PASS" : "FAIL"} '
        '${validation.overallScore.rating} ${validation.overallScore.score}/100 '
        '(issues: ${validation.totalIssues})',
      )
      ..writeln();

    if (report.lowCoverageFiles.isNotEmpty) {
      buf
        ..writeln('LOW COVERAGE FILES')
        ..writeln('------------------');
      for (final path in report.lowCoverageFiles) {
        final cov = analysisResults
                .where((r) => r.filePath == path)
                .firstOrNull
                ?.coveragePercentage ??
            0.0;
        buf.writeln(
          '  ! ${cov.toStringAsFixed(1).padLeft(6)}%  $path',
        );
      }
      buf.writeln();
    }

    buf
      ..writeln('PER-FILE BREAKDOWN')
      ..writeln('-------------------');
    for (final f in analysisResults) {
      final badge = f.coveragePercentage >= 70
          ? 'OK'
          : (f.coveragePercentage >= 50 ? 'LOW' : 'BAD');
      buf.writeln(
        '[$badge] ${f.coveragePercentage.toStringAsFixed(1).padLeft(6)}%  ${f.filePath}',
      );
      if (f.undocumentedElements.isNotEmpty) {
        for (final e in f.undocumentedElements) {
          buf.writeln(
            '    - ${e.type.name.padRight(7)} :${e.lineNumber.toString().padLeft(4)}  ${e.name}',
          );
        }
      }
    }

    return buf.toString();
  }

  /// تحويل النص إلى صيغة تقرير
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
      case 'text':
      case 'txt':
        return ReportFormat.text;
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
