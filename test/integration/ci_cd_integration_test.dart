import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Contract tests for repository CI/CD controls.
///
/// These tests verify committed policy artifacts. They do not start nested
/// Flutter invocations or expect coverage before the enclosing test command
/// has completed writing it.
void main() {
  group('CI/CD Integration Tests', () {
    group('Documentation CLI Integration', () {
      test('CLI tool file exists', () {
        final cliFile = File(
          'lib/tools/documentation/cli/documentation_cli.dart',
        );
        expect(cliFile.existsSync(), isTrue);
      });

      test('CLI tool has main function', () {
        final content = File(
          'lib/tools/documentation/cli/documentation_cli.dart',
        ).readAsStringSync();

        expect(content, contains('Future<void> main('));
        expect(content, contains('DocumentationCLI'));
      });

      test('CLI tool has analyze, validate, report, and help commands', () {
        final content = File(
          'lib/tools/documentation/cli/documentation_cli.dart',
        ).readAsStringSync();

        expect(content, contains('analyze'));
        expect(content, contains('_runAnalyze'));
        expect(content, contains('validate'));
        expect(content, contains('_runValidate'));
        expect(content, contains('report'));
        expect(content, contains('_runReport'));
        expect(content, contains('help'));
        expect(content, contains('_printUsage'));
      });
    });

    group('Production Quality Gate Contract', () {
      late String workflow;

      setUpAll(() {
        final workflowFile = File(
          '.github/workflows/production-quality-gate.yml',
        );
        expect(workflowFile.existsSync(), isTrue);
        workflow = workflowFile.readAsStringSync();
      });

      test('pins the Flutter toolchain and locks dependency resolution', () {
        expect(workflow, contains('FLUTTER_VERSION: "3.44.9"'));
        expect(workflow, contains('FLUTTER_GIT_SHA:'));
        expect(workflow, contains(r'checkout --detach "$FLUTTER_GIT_SHA"'));
        expect(workflow, contains('flutter pub get'));
        expect(workflow, contains('git diff --exit-code -- pubspec.lock'));
      });

      test('enforces Flutter sources, format, analysis, tests, and coverage',
          () {
        expect(workflow, contains('dart run build_runner build'));
        expect(workflow, contains('dart format --set-exit-if-changed'));
        expect(workflow, contains('flutter analyze --fatal-infos'));
        expect(
          workflow,
          contains('flutter test --coverage --reporter expanded'),
        );
        expect(workflow, contains('test -s coverage/lcov.info'));
        expect(workflow, contains('MIN_COVERAGE: "70"'));
        expect(workflow, contains('Coverage %.2f%% is below required'));
      });

      test('enforces Rust quality, test, and vulnerability controls', () {
        expect(workflow, contains('cargo fmt --all -- --check'));
        expect(workflow, contains('cargo clippy --workspace'));
        expect(workflow, contains('-- -D warnings'));
        expect(workflow, contains('cargo test --workspace --all-targets'));
        expect(workflow, contains('cargo audit --deny warnings'));
        expect(workflow, contains('DATABASE_URL: postgres://'));
        expect(workflow, contains('migrations/*.sql'));
      });

      test('includes mandatory secret scan and dependency review jobs', () {
        expect(workflow, contains('secret-scan:'));
        expect(workflow, contains('Install checksum-verified Gitleaks scanner'));
        expect(workflow, contains('GITLEAKS_ARCHIVE_SHA256:'));
        expect(workflow, contains('sha256sum --check --strict'));
        expect(
          workflow,
          contains(r'"$RUNNER_TEMP/gitleaks" git --redact --verbose'),
        );
        expect(workflow, contains(r'${BASE_SHA}..${HEAD_SHA}'));
        expect(workflow, contains('--log-opts="--all"'));
        expect(workflow, contains('dependency-review:'));
        expect(workflow, contains('actions/dependency-review-action@'));
        expect(workflow, contains('fail-on-severity: high'));
      });

      test('fails the aggregate gate when a mandatory check does not pass', () {
        expect(workflow, contains('quality-gate:'));
        expect(workflow, contains(r'if: ${{ always() }}'));
        expect(workflow, contains(r'"$result" != success'));
        expect(
          workflow,
          contains('A mandatory production-quality check did not pass.'),
        );
        expect(workflow, contains('exit 1'));
      });

      test('isolates release signing behind the protected environment', () {
        expect(workflow, contains('environment: production'));
        expect(workflow, contains('ANDROID_KEYSTORE_BASE64'));
        expect(workflow, contains('Build signed Android artifacts'));
        expect(workflow, contains('rm -f android/app/upload-keystore.jks'));
      });
    });

    group('Policy Documentation', () {
      test('documents the production gate and required status check', () {
        final document = File('docs/CI_PRODUCTION_GATE.md');
        expect(document.existsSync(), isTrue);

        final content = document.readAsStringSync();
        expect(content, contains('# بوابة الإنتاج في GitHub Actions'));
        expect(content, contains('Required production quality gate'));
        expect(content, contains('branch protection'));
        expect(content, contains('production'));
      });

      test('documents time-bound RustSec dependency exceptions', () {
        final document = File('docs/DEPENDENCY_SECURITY_MONITORING.md');
        expect(document.existsSync(), isTrue);

        final content = document.readAsStringSync();
        expect(content, contains('RUSTSEC-2026-0235'));
        expect(content, contains('RUSTSEC-2023-0071'));
        expect(content, contains('RUSTSEC-2026-0221'));
        expect(content, contains('2026-09-12'));
      });

      test('keeps the local quality-gate script executable', () {
        final scriptFile = File('scripts/run_quality_gates.sh');
        expect(scriptFile.existsSync(), isTrue);

        final stat = scriptFile.statSync();
        final isExecutable = (stat.mode & 0x49) != 0;
        expect(isExecutable, isTrue);
      });
    });

    group('Report Generation', () {
      test('CLI supports markdown, JSON, and HTML formats', () {
        final content = File(
          'lib/tools/documentation/cli/documentation_cli.dart',
        ).readAsStringSync();

        expect(content, contains('markdown'));
        expect(content, contains('ReportFormat.markdown'));
        expect(content, contains('json'));
        expect(content, contains('ReportFormat.json'));
        expect(content, contains('html'));
        expect(content, contains('ReportFormat.html'));
        expect(content, contains('_parseReportFormat'));
      });
    });
  });
}
