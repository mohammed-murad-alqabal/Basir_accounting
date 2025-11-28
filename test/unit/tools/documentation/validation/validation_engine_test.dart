import 'package:basser_app/tools/documentation/validation/validation_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for ValidationEngine
///
/// Tests the documentation validation functionality
void main() {
  group('ValidationEngine', () {
    late ValidationEngine engine;

    setUp(() {
      engine = ValidationEngine();
    });

    group('validateElement', () {
      test('should throw UnimplementedError when not implemented', () {
        expect(
          () => engine.validateElement('/// Test documentation'),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('should accept valid documentation', () {
        const doc = '/// A test class\n///\n/// This is a detailed description';

        expect(
          () => engine.validateElement(doc),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('should accept empty documentation', () {
        expect(
          () => engine.validateElement(''),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('validateFile', () {
      test('should throw UnimplementedError when not implemented', () {
        expect(
          () => engine.validateFile('test.dart'),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('should accept valid file path', () {
        expect(
          () => engine.validateFile('lib/core/constants.dart'),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('validateProject', () {
      test('should throw UnimplementedError when not implemented', () {
        expect(
          () => engine.validateProject(),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });

  group('ValidationResult', () {
    test('should create instance with required fields', () {
      const result = ValidationResult(
        isValid: true,
        issues: [],
        qualityScore: QualityScore.perfect,
      );

      expect(result.isValid, isTrue);
      expect(result.issues, isEmpty);
      expect(result.qualityScore.score, equals(100));
    });

    test('should create invalid result with issues', () {
      const issue = ValidationIssue(
        type: IssueType.formatError,
        description: 'Missing documentation',
        severity: IssueSeverity.error,
      );

      const result = ValidationResult(
        isValid: false,
        issues: [issue],
        qualityScore: QualityScore.poor,
      );

      expect(result.isValid, isFalse);
      expect(result.issues, hasLength(1));
      expect(result.qualityScore.score, equals(40));
    });

    test('should have valid constant', () {
      expect(ValidationResult.valid.isValid, isTrue);
      expect(ValidationResult.valid.issues, isEmpty);
      expect(ValidationResult.valid.qualityScore, equals(QualityScore.perfect));
    });

    test('should store multiple issues', () {
      const issues = [
        ValidationIssue(
          type: IssueType.formatError,
          description: 'Issue 1',
          severity: IssueSeverity.error,
        ),
        ValidationIssue(
          type: IssueType.missingContent,
          description: 'Issue 2',
          severity: IssueSeverity.warning,
        ),
      ];

      const result = ValidationResult(
        isValid: false,
        issues: issues,
        qualityScore: QualityScore.fair,
      );

      expect(result.issues, hasLength(2));
    });
  });

  group('FileValidationResult', () {
    test('should create instance with required fields', () {
      const result = FileValidationResult(
        filePath: 'test.dart',
        elementResults: [],
        isValid: true,
        overallScore: QualityScore.perfect,
      );

      expect(result.filePath, equals('test.dart'));
      expect(result.elementResults, isEmpty);
      expect(result.isValid, isTrue);
      expect(result.overallScore.score, equals(100));
    });

    test('should store multiple element results', () {
      const elementResults = [
        ValidationResult.valid,
        ValidationResult(
          isValid: false,
          issues: [],
          qualityScore: QualityScore.good,
        ),
      ];

      const result = FileValidationResult(
        filePath: 'test.dart',
        elementResults: elementResults,
        isValid: false,
        overallScore: QualityScore.good,
      );

      expect(result.elementResults, hasLength(2));
    });
  });

  group('ProjectValidationResult', () {
    test('should create instance with required fields', () {
      const result = ProjectValidationResult(
        fileResults: [],
        isValid: true,
        overallScore: QualityScore.perfect,
        totalIssues: 0,
      );

      expect(result.fileResults, isEmpty);
      expect(result.isValid, isTrue);
      expect(result.overallScore.score, equals(100));
      expect(result.totalIssues, equals(0));
    });

    test('should store multiple file results', () {
      const fileResults = [
        FileValidationResult(
          filePath: 'file1.dart',
          elementResults: [],
          isValid: true,
          overallScore: QualityScore.perfect,
        ),
        FileValidationResult(
          filePath: 'file2.dart',
          elementResults: [],
          isValid: false,
          overallScore: QualityScore.good,
        ),
      ];

      const result = ProjectValidationResult(
        fileResults: fileResults,
        isValid: false,
        overallScore: QualityScore.good,
        totalIssues: 5,
      );

      expect(result.fileResults, hasLength(2));
      expect(result.totalIssues, equals(5));
    });
  });

  group('ValidationIssue', () {
    test('should create issue with required fields', () {
      const issue = ValidationIssue(
        type: IssueType.formatError,
        description: 'Invalid format',
        severity: IssueSeverity.error,
      );

      expect(issue.type, equals(IssueType.formatError));
      expect(issue.description, equals('Invalid format'));
      expect(issue.severity, equals(IssueSeverity.error));
      expect(issue.lineNumber, isNull);
      expect(issue.suggestion, isNull);
    });

    test('should create issue with optional fields', () {
      const issue = ValidationIssue(
        type: IssueType.missingContent,
        description: 'Missing parameter documentation',
        severity: IssueSeverity.warning,
        lineNumber: 10,
        suggestion: 'Add @param documentation',
      );

      expect(issue.lineNumber, equals(10));
      expect(issue.suggestion, equals('Add @param documentation'));
    });

    test('should support all issue types', () {
      const formatIssue = ValidationIssue(
        type: IssueType.formatError,
        description: 'Format error',
        severity: IssueSeverity.error,
      );

      const contentIssue = ValidationIssue(
        type: IssueType.missingContent,
        description: 'Missing content',
        severity: IssueSeverity.warning,
      );

      const qualityIssue = ValidationIssue(
        type: IssueType.lowQuality,
        description: 'Low quality',
        severity: IssueSeverity.info,
      );

      const complianceIssue = ValidationIssue(
        type: IssueType.nonCompliance,
        description: 'Non-compliant',
        severity: IssueSeverity.error,
      );

      expect(formatIssue.type, equals(IssueType.formatError));
      expect(contentIssue.type, equals(IssueType.missingContent));
      expect(qualityIssue.type, equals(IssueType.lowQuality));
      expect(complianceIssue.type, equals(IssueType.nonCompliance));
    });

    test('should support all severity levels', () {
      const errorIssue = ValidationIssue(
        type: IssueType.formatError,
        description: 'Error',
        severity: IssueSeverity.error,
      );

      const warningIssue = ValidationIssue(
        type: IssueType.missingContent,
        description: 'Warning',
        severity: IssueSeverity.warning,
      );

      const infoIssue = ValidationIssue(
        type: IssueType.lowQuality,
        description: 'Info',
        severity: IssueSeverity.info,
      );

      expect(errorIssue.severity, equals(IssueSeverity.error));
      expect(warningIssue.severity, equals(IssueSeverity.warning));
      expect(infoIssue.severity, equals(IssueSeverity.info));
    });
  });

  group('IssueType', () {
    test('should have all required types', () {
      expect(IssueType.values, hasLength(4));
      expect(IssueType.values, contains(IssueType.formatError));
      expect(IssueType.values, contains(IssueType.missingContent));
      expect(IssueType.values, contains(IssueType.lowQuality));
      expect(IssueType.values, contains(IssueType.nonCompliance));
    });
  });

  group('IssueSeverity', () {
    test('should have all required levels', () {
      expect(IssueSeverity.values, hasLength(3));
      expect(IssueSeverity.values, contains(IssueSeverity.error));
      expect(IssueSeverity.values, contains(IssueSeverity.warning));
      expect(IssueSeverity.values, contains(IssueSeverity.info));
    });
  });

  group('QualityScore', () {
    test('should create score with rating', () {
      const score = QualityScore(score: 85, rating: 'Excellent');

      expect(score.score, equals(85));
      expect(score.rating, equals('Excellent'));
    });

    test('should have perfect constant', () {
      expect(QualityScore.perfect.score, equals(100));
      expect(QualityScore.perfect.rating, equals('Perfect'));
    });

    test('should have excellent constant', () {
      expect(QualityScore.excellent.score, equals(90));
      expect(QualityScore.excellent.rating, equals('Excellent'));
    });

    test('should have good constant', () {
      expect(QualityScore.good.score, equals(75));
      expect(QualityScore.good.rating, equals('Good'));
    });

    test('should have fair constant', () {
      expect(QualityScore.fair.score, equals(60));
      expect(QualityScore.fair.rating, equals('Fair'));
    });

    test('should have poor constant', () {
      expect(QualityScore.poor.score, equals(40));
      expect(QualityScore.poor.rating, equals('Poor'));
    });

    test('should return perfect for score >= 95', () {
      expect(QualityScore.fromScore(100), equals(QualityScore.perfect));
      expect(QualityScore.fromScore(95), equals(QualityScore.perfect));
    });

    test('should return excellent for score >= 85', () {
      expect(QualityScore.fromScore(90), equals(QualityScore.excellent));
      expect(QualityScore.fromScore(85), equals(QualityScore.excellent));
    });

    test('should return good for score >= 70', () {
      expect(QualityScore.fromScore(75), equals(QualityScore.good));
      expect(QualityScore.fromScore(70), equals(QualityScore.good));
    });

    test('should return fair for score >= 55', () {
      expect(QualityScore.fromScore(60), equals(QualityScore.fair));
      expect(QualityScore.fromScore(55), equals(QualityScore.fair));
    });

    test('should return poor for score < 55', () {
      expect(QualityScore.fromScore(50), equals(QualityScore.poor));
      expect(QualityScore.fromScore(0), equals(QualityScore.poor));
    });
  });

  group('Integration scenarios', () {
    late ValidationEngine engine;

    setUp(() {
      engine = ValidationEngine();
    });

    test('should validate perfect documentation', () {
      const doc = '''
/// A well-documented class
///
/// This class provides comprehensive functionality
/// with detailed explanations and examples.
///
/// Example:
/// ```dart
/// final instance = MyClass();
/// instance.doSomething();
/// ```
''';

      expect(
        () => engine.validateElement(doc),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('should detect missing documentation', () {
      expect(
        () => engine.validateElement(''),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('should validate file with mixed quality', () {
      expect(
        () => engine.validateFile('lib/mixed_quality.dart'),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('should validate entire project', () {
      expect(
        () => engine.validateProject(),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('should create comprehensive validation result', () {
      const issues = [
        ValidationIssue(
          type: IssueType.missingContent,
          description: 'Missing parameter documentation',
          severity: IssueSeverity.warning,
          lineNumber: 10,
          suggestion: 'Add @param tags',
        ),
        ValidationIssue(
          type: IssueType.lowQuality,
          description: 'Description too short',
          severity: IssueSeverity.info,
          lineNumber: 5,
        ),
      ];

      const result = ValidationResult(
        isValid: false,
        issues: issues,
        qualityScore: QualityScore.good,
      );

      expect(result.issues, hasLength(2));
      expect(result.qualityScore.score, equals(75));
    });

    test('should aggregate file results into project result', () {
      const fileResults = [
        FileValidationResult(
          filePath: 'file1.dart',
          elementResults: [ValidationResult.valid],
          isValid: true,
          overallScore: QualityScore.perfect,
        ),
        FileValidationResult(
          filePath: 'file2.dart',
          elementResults: [
            ValidationResult(
              isValid: false,
              issues: [
                ValidationIssue(
                  type: IssueType.formatError,
                  description: 'Error',
                  severity: IssueSeverity.error,
                ),
              ],
              qualityScore: QualityScore.fair,
            ),
          ],
          isValid: false,
          overallScore: QualityScore.fair,
        ),
      ];

      const projectResult = ProjectValidationResult(
        fileResults: fileResults,
        isValid: false,
        overallScore: QualityScore.good,
        totalIssues: 1,
      );

      expect(projectResult.fileResults, hasLength(2));
      expect(projectResult.totalIssues, equals(1));
      expect(projectResult.isValid, isFalse);
    });
  });
}
