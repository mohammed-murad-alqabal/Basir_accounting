import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

/// Tests for validating GitHub workflow files
///
/// These tests ensure workflow files are properly structured
void main() {
  group('Workflow Validation Tests', () {
    group('Documentation Check Workflow', () {
      late File workflowFile;
      late YamlMap workflow;

      setUp(() {
        workflowFile = File('.github/workflows/documentation_check.yml');
        final content = workflowFile.readAsStringSync();
        workflow = loadYaml(content) as YamlMap;
      });

      test('should have correct name', () {
        expect(workflow['name'], equals('Documentation Check'));
      });

      test('should trigger on push and pull_request', () {
        final on = workflow['on'] as YamlMap;
        expect(on.containsKey('push'), isTrue);
        expect(on.containsKey('pull_request'), isTrue);
      });

      test('should have documentation-coverage job', () {
        final jobs = workflow['jobs'] as YamlMap;
        expect(jobs.containsKey('documentation-coverage'), isTrue);
      });

      test('should use correct Flutter version', () {
        final jobs = workflow['jobs'] as YamlMap;
        final docJob = jobs['documentation-coverage'] as YamlMap;
        final steps = docJob['steps'] as YamlList;

        final setupFlutterStep = steps.firstWhere(
          (step) => (step as YamlMap)['name'] == 'Setup Flutter',
        ) as YamlMap;

        final with_ = setupFlutterStep['with'] as YamlMap;
        expect(with_['flutter-version'], equals('3.44.9'));
      });

      test('should run analyze command', () {
        final jobs = workflow['jobs'] as YamlMap;
        final docJob = jobs['documentation-coverage'] as YamlMap;
        final steps = docJob['steps'] as YamlList;

        final analyzeStep = steps.firstWhere(
          (step) => (step as YamlMap)['name'] == 'Run documentation analysis',
        ) as YamlMap;

        expect(analyzeStep['run'], contains('analyze'));
      });

      test('should run validate command', () {
        final jobs = workflow['jobs'] as YamlMap;
        final docJob = jobs['documentation-coverage'] as YamlMap;
        final steps = docJob['steps'] as YamlList;

        final validateStep = steps.firstWhere(
          (step) =>
              (step as YamlMap)['name'] == 'Validate documentation quality',
        ) as YamlMap;

        expect(validateStep['run'], contains('validate'));
      });

      test('should generate reports', () {
        final jobs = workflow['jobs'] as YamlMap;
        final docJob = jobs['documentation-coverage'] as YamlMap;
        final steps = docJob['steps'] as YamlList;

        final reportStep = steps.firstWhere(
          (step) =>
              (step as YamlMap)['name'] == 'Generate documentation report',
        ) as YamlMap;

        expect(reportStep['run'], contains('report'));
      });

      test('should upload artifacts', () {
        final jobs = workflow['jobs'] as YamlMap;
        final docJob = jobs['documentation-coverage'] as YamlMap;
        final steps = docJob['steps'] as YamlList;

        final uploadStep = steps.firstWhere(
          (step) => (step as YamlMap)['name'] == 'Upload report artifacts',
        ) as YamlMap;

        expect(uploadStep['uses'], contains('upload-artifact'));
      });

      test('should comment on PR', () {
        final jobs = workflow['jobs'] as YamlMap;
        final docJob = jobs['documentation-coverage'] as YamlMap;
        final steps = docJob['steps'] as YamlList;

        final commentStep = steps.firstWhere(
          (step) => (step as YamlMap)['name'] == 'Comment on PR',
        ) as YamlMap;

        expect(commentStep['uses'], contains('github-script'));
      });
    });

    group('Quality Gates Workflow', () {
      late File workflowFile;
      late YamlMap workflow;

      setUp(() {
        workflowFile = File('.github/workflows/quality_gates.yml');
        final content = workflowFile.readAsStringSync();
        workflow = loadYaml(content) as YamlMap;
      });

      test('should have correct name', () {
        expect(workflow['name'], equals('Quality Gates'));
      });

      test('should have concurrency control', () {
        expect(workflow.containsKey('concurrency'), isTrue);
        final concurrency = workflow['concurrency'] as YamlMap;
        expect(concurrency.containsKey('group'), isTrue);
        expect(concurrency['cancel-in-progress'], isTrue);
      });

      test('should have all required quality gate jobs', () {
        final jobs = workflow['jobs'] as YamlMap;

        expect(jobs.containsKey('documentation-quality-gate'), isTrue);
        expect(jobs.containsKey('code-quality-gate'), isTrue);
        expect(jobs.containsKey('test-quality-gate'), isTrue);
        expect(jobs.containsKey('security-quality-gate'), isTrue);
        expect(jobs.containsKey('quality-gate-summary'), isTrue);
      });

      test('documentation gate should check coverage', () {
        final jobs = workflow['jobs'] as YamlMap;
        final docGate = jobs['documentation-quality-gate'] as YamlMap;
        final steps = docGate['steps'] as YamlList;

        final coverageStep = steps.firstWhere(
          (step) => (step as YamlMap)['name'] == 'Check documentation coverage',
        ) as YamlMap;

        expect(coverageStep['run'], contains('analyze'));
      });

      test('documentation gate should check quality', () {
        final jobs = workflow['jobs'] as YamlMap;
        final docGate = jobs['documentation-quality-gate'] as YamlMap;
        final steps = docGate['steps'] as YamlList;

        final qualityStep = steps.firstWhere(
          (step) => (step as YamlMap)['name'] == 'Check documentation quality',
        ) as YamlMap;

        expect(qualityStep['run'], contains('validate'));
      });

      test('code gate should run flutter analyze', () {
        final jobs = workflow['jobs'] as YamlMap;
        final codeGate = jobs['code-quality-gate'] as YamlMap;
        final steps = codeGate['steps'] as YamlList;

        final analyzeStep = steps.firstWhere(
          (step) => (step as YamlMap)['name'] == 'Run Flutter analyze',
        ) as YamlMap;

        expect(analyzeStep['run'], contains('flutter analyze'));
      });

      test('test gate should run tests with coverage', () {
        final jobs = workflow['jobs'] as YamlMap;
        final testGate = jobs['test-quality-gate'] as YamlMap;
        final steps = testGate['steps'] as YamlList;

        final testStep = steps.firstWhere(
          (step) => (step as YamlMap)['name'] == 'Run tests with coverage',
        ) as YamlMap;

        final runCommand = testStep['run'] as String;
        expect(runCommand, contains('flutter test'));
        expect(runCommand, contains('--concurrency=1'));
        expect(runCommand, contains('--coverage'));
      });

      test('test gate should enforce coverage from the lcov report', () {
        final jobs = workflow['jobs'] as YamlMap;
        final testGate = jobs['test-quality-gate'] as YamlMap;
        final steps = testGate['steps'] as YamlList;

        final coverageStep = steps.firstWhere(
          (step) => (step as YamlMap)['name'] == 'Check Test Coverage',
        ) as YamlMap;
        final runCommand = coverageStep['run'] as String;

        expect(runCommand, contains('coverage/lcov.info'));
        expect(runCommand, contains('awk'));
        expect(runCommand, contains('BASELINE=25.98'));
        expect(runCommand, contains('TARGET=70'));
        expect(runCommand, contains('::warning::'));
      });

      test('security gate should check vulnerabilities', () {
        final jobs = workflow['jobs'] as YamlMap;
        final securityGate = jobs['security-quality-gate'] as YamlMap;
        final steps = securityGate['steps'] as YamlList;

        final vulnStep = steps.firstWhere(
          (step) =>
              (step as YamlMap)['name'] == 'Check for security vulnerabilities',
        ) as YamlMap;

        expect(vulnStep['run'], contains('pub outdated'));
      });

      test('summary job should depend on all gates', () {
        final jobs = workflow['jobs'] as YamlMap;
        final summary = jobs['quality-gate-summary'] as YamlMap;

        expect(summary.containsKey('needs'), isTrue);
        final needs = summary['needs'] as YamlList;

        expect(needs, contains('documentation-quality-gate'));
        expect(needs, contains('code-quality-gate'));
        expect(needs, contains('test-quality-gate'));
        expect(needs, contains('security-quality-gate'));
      });

      test('summary job should always run', () {
        final jobs = workflow['jobs'] as YamlMap;
        final summary = jobs['quality-gate-summary'] as YamlMap;

        expect(summary['if'], equals('always()'));
      });
    });

    group('Configuration File Validation', () {
      test('should have valid quality gates config', () {
        final configFile = File('.github/quality_gates_config.yml');
        expect(configFile.existsSync(), isTrue);

        final content = configFile.readAsStringSync();
        final config = loadYaml(content) as YamlMap;

        // Check documentation section
        expect(config.containsKey('documentation'), isTrue);
        final doc = config['documentation'] as YamlMap;
        expect(doc['min_coverage'], equals(95));
        expect(doc['min_quality_score'], equals(90));

        // Check code quality section
        expect(config.containsKey('code_quality'), isTrue);
        final code = config['code_quality'] as YamlMap;
        expect(code['max_errors'], equals(0));

        // Check test coverage section
        expect(config.containsKey('test_coverage'), isTrue);
        final test = config['test_coverage'] as YamlMap;
        expect(test['min_coverage'], equals(70));

        // Check security section
        expect(config.containsKey('security'), isTrue);
        final security = config['security'] as YamlMap;
        expect(security['check_vulnerabilities'], isTrue);
      });
    });

    group('Script Validation', () {
      test('should have executable quality gates script', () {
        final scriptFile = File('scripts/run_quality_gates.sh');
        expect(scriptFile.existsSync(), isTrue);

        final content = scriptFile.readAsStringSync();

        // Check for shebang
        expect(content, startsWith('#!/bin/bash'));

        // Check for required functions
        expect(content, contains('run_gate'));

        // Check for quality gates
        expect(content, contains('Documentation Quality Gate'));
        expect(content, contains('Code Quality Gate'));
        expect(content, contains('Test Quality Gate'));
        expect(content, contains('Security Quality Gate'));

        // Check for summary
        expect(content, contains('Quality Gates Summary'));
      });
    });
  });
}
