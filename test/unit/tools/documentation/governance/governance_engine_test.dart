// ignore_for_file: avoid_slow_async_io, require_trailing_commas

import 'dart:io';

import 'package:basir_accounting_system/tools/documentation/governance/governance_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory root;
  late GovernanceEngine engine;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('basir-governance-test-');
    engine = GovernanceEngine();
    await _writePolicy(root);
  });

  tearDown(() async {
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('reports missing metadata for an authoritative document', () async {
    await _write(root, 'docs/00-governance/missing.md', '''
# Missing metadata

> **document_id:** GOV-001
> **status:** ACTIVE
''');

    final report = await engine.analyze(
      root: root,
      changedFiles: const <String>['docs/00-governance/missing.md'],
    );

    expect(report.issues.where((issue) => issue.rule == 'metadata.required'),
        isNotEmpty);
    expect(
      report.issues.any((issue) => issue.message.contains('`owner`')),
      isTrue,
    );
  });

  test('does not report complete metadata or a valid local link', () async {
    await _write(root, 'docs/00-governance/target.md', '# Target\n');
    await _write(root, 'docs/00-governance/valid.md', '''
# Valid document

> **document_id:** GOV-002
> **status:** ACTIVE
> **authority_level:** 1
> **owner:** Engineering Lead
> **approved_by:** Repository Owner
> **effective_from:** 2026-08-13
> **review_due:** 2026-11-13

[Target](target.md)
''');

    final report = await engine.analyze(
      root: root,
      changedFiles: const <String>['docs/00-governance/valid.md'],
    );

    expect(report.issues, isEmpty);
  });

  test('reports a broken local Markdown link', () async {
    await _write(root, 'README.md', '[Broken](missing.md)\n');

    final report = await engine.analyze(
      root: root,
      changedFiles: const <String>['README.md'],
    );

    expect(
      report.issues
          .any((issue) => issue.rule == 'links.local' && issue.line == 1),
      isTrue,
    );
  });

  test('requires REQ and ADR references for a security change', () async {
    await _write(
        root, 'lib/features/auth/auth_service.dart', 'class AuthService {}\n');

    final report = await engine.analyze(
      root: root,
      changedFiles: const <String>['lib/features/auth/auth_service.dart'],
      prBody: 'Security implementation without governance references.',
    );

    expect(
      report.issues.where((issue) => issue.rule == 'traceability.requirement'),
      hasLength(1),
    );
    expect(
      report.issues.where((issue) => issue.rule == 'traceability.adr'),
      hasLength(1),
    );
  });

  test('accepts matching REQ and ADR references for a security change',
      () async {
    await _write(
        root, 'lib/features/auth/auth_service.dart', 'class AuthService {}\n');

    final report = await engine.analyze(
      root: root,
      changedFiles: const <String>['lib/features/auth/auth_service.dart'],
      prBody: 'Implements REQ-SEC-001 according to ADR-SEC-001.',
    );

    expect(
      report.issues.where((issue) => issue.rule.startsWith('traceability.')),
      isEmpty,
    );
  });

  test('reports a governed claim but ignores an explicit negation', () async {
    await _write(root, 'README.md', '''
This release is production ready.
This document is not compliant by itself.
''');

    final report = await engine.analyze(
      root: root,
      changedFiles: const <String>['README.md'],
    );

    expect(
      report.issues.where((issue) => issue.rule == 'claims.governed'),
      hasLength(1),
    );
    expect(report.toMarkdown(), contains('production ready'));
  });
}

Future<void> _writePolicy(Directory root) async {
  await _write(root, '.github/governance/documentation-policy.yml', '''
version: 1
mode: advisory
metadata_paths:
  - docs/00-governance/
required_metadata:
  - document_id
  - status
  - authority_level
  - owner
  - approved_by
  - effective_from
  - review_due
excluded_documentation_paths: []
high_impact_domains:
  security:
    paths:
      - lib/features/auth/
    requirement_prefixes:
      - REQ-SEC-
    requires_adr: true
governed_claims:
  - production ready
  - compliant
exception_marker: "Governance exception:"
''');
}

Future<void> _write(Directory root, String relativePath, String content) async {
  final file = File('${root.path}/$relativePath');
  await file.parent.create(recursive: true);
  await file.writeAsString(content);
}
