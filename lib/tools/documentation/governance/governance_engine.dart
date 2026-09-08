// ignore_for_file: avoid_slow_async_io, avoid_types_on_closure_parameters, curly_braces_in_flow_control_structures, prefer_expression_function_bodies, require_trailing_commas, unnecessary_raw_strings, use_raw_strings

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// مستوى ملاحظة الحوكمة. في وضع advisory لا يغيّر أي مستوى كود الخروج.
enum GovernanceSeverity { info, warning, error }

/// نتيجة قاعدة واحدة قابلة للعرض في تقرير Markdown أو JSON.
class GovernanceIssue {
  const GovernanceIssue({
    required this.rule,
    required this.severity,
    required this.path,
    required this.message,
    this.line,
  });

  final String rule;
  final GovernanceSeverity severity;
  final String path;
  final String message;
  final int? line;

  Map<String, Object?> toJson() => <String, Object?>{
        'rule': rule,
        'severity': severity.name,
        'path': path,
        'line': line,
        'message': message,
      };
}

/// ملخص قابل للحفظ والقراءة الآلية لفحص الحوكمة.
class GovernanceReport {
  GovernanceReport({
    required this.mode,
    required this.changedFiles,
    required this.issues,
  });

  final String mode;
  final List<String> changedFiles;
  final List<GovernanceIssue> issues;

  int get warnings => issues
      .where((GovernanceIssue issue) =>
          issue.severity == GovernanceSeverity.warning)
      .length;

  int get errors => issues
      .where(
          (GovernanceIssue issue) => issue.severity == GovernanceSeverity.error)
      .length;

  Map<String, Object?> toJson() => <String, Object?>{
        'mode': mode,
        'changed_files': changedFiles,
        'summary': <String, int>{
          'warnings': warnings,
          'errors': errors,
          'total_issues': issues.length,
        },
        'issues':
            issues.map((GovernanceIssue issue) => issue.toJson()).toList(),
      };

  String toMarkdown() {
    final buffer = StringBuffer()
      ..writeln('# Documentation Governance Report')
      ..writeln()
      ..writeln('> **Mode:** `${mode.toUpperCase()}`')
      ..writeln('> **Changed files:** ${changedFiles.length}')
      ..writeln('> **Warnings:** $warnings')
      ..writeln('> **Errors:** $errors')
      ..writeln();

    if (issues.isEmpty) {
      buffer.writeln('No governance observations were found.');
      return buffer.toString();
    }

    buffer
      ..writeln('| Severity | Rule | Path | Observation |')
      ..writeln('| --- | --- | --- | --- |');
    for (final issue in issues) {
      final location =
          issue.line == null ? issue.path : '${issue.path}:${issue.line}';
      final message =
          issue.message.replaceAll('|', r'\|').replaceAll('\n', ' ');
      buffer.writeln(
          '| ${issue.severity.name} | `${issue.rule}` | `$location` | $message |');
    }
    buffer
      ..writeln()
      ..writeln('> Advisory observations do not block merging in this phase. ')
      ..writeln(
          '> A reviewer must either resolve each observation or record a time-bound exception.');
    return buffer.toString();
  }
}

class _ImpactDomain {
  const _ImpactDomain({
    required this.name,
    required this.paths,
    required this.requirementPrefixes,
    required this.requiresAdr,
  });

  final String name;
  final List<String> paths;
  final List<String> requirementPrefixes;
  final bool requiresAdr;
}

class _GovernancePolicy {
  const _GovernancePolicy({
    required this.mode,
    required this.metadataPaths,
    required this.requiredMetadata,
    required this.excludedDocumentationPaths,
    required this.domains,
    required this.governedClaims,
    required this.exceptionMarker,
  });

  final String mode;
  final List<String> metadataPaths;
  final List<String> requiredMetadata;
  final List<String> excludedDocumentationPaths;
  final List<_ImpactDomain> domains;
  final List<String> governedClaims;
  final String exceptionMarker;

  static Future<_GovernancePolicy> load(Directory root) async {
    final file = File(
        p.join(root.path, '.github', 'governance', 'documentation-policy.yml'));
    if (!await file.exists()) {
      throw StateError('Governance policy not found: ${file.path}');
    }
    final parsed = loadYaml(await file.readAsString());
    if (parsed is! YamlMap) {
      throw StateError('Governance policy must be a YAML map.');
    }

    List<String> stringList(Object? value) {
      if (value is! YamlList) return const <String>[];
      return value
          .map((Object? item) => item.toString())
          .toList(growable: false);
    }

    final domains = <_ImpactDomain>[];
    final rawDomains = parsed['high_impact_domains'];
    if (rawDomains is YamlMap) {
      rawDomains.forEach((Object? key, Object? value) {
        if (value is! YamlMap) return;
        domains.add(_ImpactDomain(
          name: key.toString(),
          paths: stringList(value['paths']),
          requirementPrefixes: stringList(value['requirement_prefixes']),
          requiresAdr: value['requires_adr'] == true,
        ));
      });
    }

    return _GovernancePolicy(
      mode: parsed['mode']?.toString() ?? 'advisory',
      metadataPaths: stringList(parsed['metadata_paths']),
      requiredMetadata: stringList(parsed['required_metadata']),
      excludedDocumentationPaths:
          stringList(parsed['excluded_documentation_paths']),
      domains: domains,
      governedClaims: stringList(parsed['governed_claims']),
      exceptionMarker:
          parsed['exception_marker']?.toString() ?? 'Governance exception:',
    );
  }
}

/// يفحص مجموعة ملفات متغيرة باستعمال سياسة YAML محلية، بلا أي حكم لغوي أو خدمة خارجية.
class GovernanceEngine {
  Future<List<String>> changedFiles({
    required Directory root,
    required String base,
    required String head,
  }) async {
    final result = await Process.run(
      'git',
      <String>['diff', '--name-only', base, head],
      workingDirectory: root.path,
    );
    if (result.exitCode != 0) {
      final currentHead = await Process.run(
        'git',
        <String>['rev-parse', 'HEAD'],
        workingDirectory: root.path,
      );
      final checkedOutHead = currentHead.stdout.toString().trim();
      final stderr = result.stderr.toString();
      final baseRefUnavailable =
          stderr.contains('bad object') || stderr.contains('unknown revision');
      if (baseRefUnavailable && checkedOutHead == head) {
        final fallback = await Process.run(
          'git',
          <String>['diff', '--name-only', 'HEAD~1', 'HEAD'],
          workingDirectory: root.path,
        );
        if (fallback.exitCode == 0) {
          return LineSplitter.split(fallback.stdout.toString())
              .map((String item) => item.trim())
              .where((String item) => item.isNotEmpty)
              .toList(growable: false);
        }
      }
      throw StateError('Unable to read changed files: ${result.stderr}');
    }
    return LineSplitter.split(result.stdout.toString())
        .map((String item) => item.trim())
        .where((String item) => item.isNotEmpty)
        .toList(growable: false);
  }

  Future<GovernanceReport> analyze({
    required Directory root,
    required List<String> changedFiles,
    String prBody = '',
  }) async {
    final policy = await _GovernancePolicy.load(root);
    final issues = <GovernanceIssue>[];

    for (final relativePath in changedFiles) {
      final normalized = p.posix.normalize(relativePath.replaceAll('\\', '/'));
      if (_isHighImpactFile(normalized, policy)) {
        _checkTraceability(
          path: normalized,
          prBody: prBody,
          policy: policy,
          issues: issues,
        );
      }

      if (!normalized.toLowerCase().endsWith('.md')) continue;
      if (_startsWithAny(normalized, policy.excludedDocumentationPaths))
        continue;

      final file = File(p.join(root.path, normalized));
      if (!await file.exists()) continue;
      final content = await file.readAsString();

      if (_startsWithAny(normalized, policy.metadataPaths)) {
        _checkMetadata(
          path: normalized,
          content: content,
          requiredMetadata: policy.requiredMetadata,
          issues: issues,
        );
      }
      _checkLocalLinks(
          root: root, path: normalized, content: content, issues: issues);
      _checkGovernedClaims(
        path: normalized,
        content: content,
        claims: policy.governedClaims,
        exceptionMarker: policy.exceptionMarker,
        issues: issues,
      );
    }

    return GovernanceReport(
      mode: policy.mode,
      changedFiles: changedFiles,
      issues: issues,
    );
  }

  bool _isHighImpactFile(String path, _GovernancePolicy policy) {
    return policy.domains.any((domain) => _startsWithAny(path, domain.paths));
  }

  void _checkTraceability({
    required String path,
    required String prBody,
    required _GovernancePolicy policy,
    required List<GovernanceIssue> issues,
  }) {
    for (final domain in policy.domains) {
      if (!_startsWithAny(path, domain.paths)) continue;
      final hasRequirement = domain.requirementPrefixes.any(
        (String prefix) =>
            RegExp('${RegExp.escape(prefix)}[0-9]{3}').hasMatch(prBody),
      );
      if (!hasRequirement) {
        issues.add(GovernanceIssue(
          rule: 'traceability.requirement',
          severity: GovernanceSeverity.warning,
          path: path,
          message:
              'High-impact ${domain.name} change has no ${domain.requirementPrefixes.join(' or ')} reference in the PR body.',
        ));
      }
      if (domain.requiresAdr &&
          !RegExp(r'ADR-[A-Z]+-[0-9]{3}|ADR-[0-9]{3}').hasMatch(prBody)) {
        issues.add(GovernanceIssue(
          rule: 'traceability.adr',
          severity: GovernanceSeverity.warning,
          path: path,
          message:
              'High-impact ${domain.name} change has no ADR reference in the PR body.',
        ));
      }
    }
  }

  void _checkMetadata({
    required String path,
    required String content,
    required List<String> requiredMetadata,
    required List<GovernanceIssue> issues,
  }) {
    final metadata = <String>{};
    for (final line in LineSplitter.split(content).take(80)) {
      final match = RegExp(r'^\s*>\s*\*\*([^*:]+):?\*\*:?\s*').firstMatch(line);
      if (match != null) metadata.add(match.group(1)!.trim());
    }
    for (final required in requiredMetadata) {
      if (!metadata.contains(required)) {
        issues.add(GovernanceIssue(
          rule: 'metadata.required',
          severity: GovernanceSeverity.warning,
          path: path,
          message: 'Missing required metadata field `$required`.',
        ));
      }
    }
  }

  void _checkLocalLinks({
    required Directory root,
    required String path,
    required String content,
    required List<GovernanceIssue> issues,
  }) {
    final regex = RegExp(r'\[[^\]]*\]\(([^)\s]+)(?:\s+[^)]*)?\)');
    final sourceDirectory = p.dirname(p.join(root.path, path));
    final reported = <String>{};
    for (final match in regex.allMatches(content)) {
      final rawTarget = match.group(1)!.replaceAll('<', '').replaceAll('>', '');
      if (rawTarget.startsWith('http://') ||
          rawTarget.startsWith('https://') ||
          rawTarget.startsWith('mailto:') ||
          rawTarget.startsWith('#')) {
        continue;
      }
      final target = rawTarget.split('#').first;
      if (target.isEmpty) continue;
      final targetPath = p.normalize(p.join(sourceDirectory, target));
      if (FileSystemEntity.typeSync(targetPath) ==
              FileSystemEntityType.notFound &&
          reported.add(rawTarget)) {
        issues.add(GovernanceIssue(
          rule: 'links.local',
          severity: GovernanceSeverity.warning,
          path: path,
          message: 'Broken local link `$rawTarget`.',
          line: _lineNumber(content, match.start),
        ));
      }
    }
  }

  void _checkGovernedClaims({
    required String path,
    required String content,
    required List<String> claims,
    required String exceptionMarker,
    required List<GovernanceIssue> issues,
  }) {
    if (content.contains(exceptionMarker)) return;
    final lines = LineSplitter.split(content).toList();
    for (var index = 0; index < lines.length; index++) {
      final source = lines[index];
      final line = source.toLowerCase();
      final negated = line.contains('not ') ||
          line.contains('must not') ||
          source.contains('لا ') ||
          source.contains('لا يجوز') ||
          source.contains('لا يثبت');
      if (negated) continue;
      for (final claim in claims) {
        if (!line.contains(claim.toLowerCase())) continue;
        issues.add(GovernanceIssue(
          rule: 'claims.governed',
          severity: GovernanceSeverity.warning,
          path: path,
          line: index + 1,
          message:
              'Governed claim `$claim` requires an evidence package or a time-bound exception.',
        ));
      }
    }
  }

  bool _startsWithAny(String path, List<String> prefixes) {
    return prefixes.any((String prefix) => path.startsWith(prefix));
  }

  int _lineNumber(String content, int offset) {
    return '\n'.allMatches(content.substring(0, offset)).length + 1;
  }
}
