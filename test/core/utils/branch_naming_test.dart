/// Tests for Branch Naming Convention Utility
///
/// Author: فريق وكلاء تطوير مشروع بصير
library;

import 'package:basir_app/core/utils/branch_naming.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BranchNamingConvention', () {
    group('validateBranchName', () {
      test('should validate protected branches', () {
        expect(
          BranchNamingConvention.validateBranchName('main').isValid,
          isTrue,
        );
        expect(
          BranchNamingConvention.validateBranchName('development').isValid,
          isTrue,
        );
      });

      test('should validate valid feature branches', () {
        final validFeatureBranches = [
          'feature/hr-employee-management',
          'feature/payroll-salary-calculation',
          'feature/accounting-journal-entries',
          'feature/invoices-zatca-compliance',
          'feature/inventory-stock-tracking',
        ];

        for (final branch in validFeatureBranches) {
          final result = BranchNamingConvention.validateBranchName(branch);
          expect(result.isValid, isTrue, reason: 'Branch: $branch');
          expect(result.branchType, equals('feature'));
        }
      });

      test('should reject invalid feature branches', () {
        final invalidFeatureBranches = [
          'feature/invalid-module-test',
          'feature/hr',
          'feature/HR-Employee-Management',
          'feature/hr_employee_management',
          'feature/hr employee management',
        ];

        for (final branch in invalidFeatureBranches) {
          final result = BranchNamingConvention.validateBranchName(branch);
          expect(result.isValid, isFalse, reason: 'Branch: $branch');
        }
      });

      test('should validate bugfix branches', () {
        final validBugfixBranches = [
          'bugfix/invoice-tax-calculation',
          'bugfix/customer-search-error',
          'bugfix/payment-processing',
        ];

        for (final branch in validBugfixBranches) {
          final result = BranchNamingConvention.validateBranchName(branch);
          expect(result.isValid, isTrue, reason: 'Branch: $branch');
          expect(result.branchType, equals('bugfix'));
        }
      });

      test('should validate hotfix branches', () {
        final validHotfixBranches = [
          'hotfix/zatca-compliance-error',
          'hotfix/critical-security-patch',
          'hotfix/database-connection-issue',
        ];

        for (final branch in validHotfixBranches) {
          final result = BranchNamingConvention.validateBranchName(branch);
          expect(result.isValid, isTrue, reason: 'Branch: $branch');
          expect(result.branchType, equals('hotfix'));
        }
      });

      test('should validate release branches', () {
        final validReleaseBranches = [
          'release/v1.0.0',
          'release/v1.2.3',
          'release/v2.0.0-beta',
          'release/v1.0.0-alpha-1',
        ];

        for (final branch in validReleaseBranches) {
          final result = BranchNamingConvention.validateBranchName(branch);
          expect(result.isValid, isTrue, reason: 'Branch: $branch');
          expect(result.branchType, equals('release'));
        }
      });

      test('should reject invalid release branches', () {
        final invalidReleaseBranches = [
          'release/1.0.0',
          'release/v1',
          'release/v1.0',
          'release/version-1.0.0',
        ];

        for (final branch in invalidReleaseBranches) {
          final result = BranchNamingConvention.validateBranchName(branch);
          expect(result.isValid, isFalse, reason: 'Branch: $branch');
        }
      });

      test('should validate docs and chore branches', () {
        final validBranches = [
          'docs/api-documentation',
          'docs/user-guide-update',
          'chore/dependency-updates',
          'chore/code-cleanup',
          'refactor/database-layer',
          'experiment/ai-integration',
        ];

        for (final branch in validBranches) {
          final result = BranchNamingConvention.validateBranchName(branch);
          expect(result.isValid, isTrue, reason: 'Branch: $branch');
        }
      });
    });

    group('suggestBranchNames', () {
      test('should suggest feature branch names', () {
        final suggestions = BranchNamingConvention.suggestBranchNames(
          branchType: 'feature',
          description: 'Employee Management System',
          module: 'hr',
        );

        expect(suggestions, contains('feature/hr-employee-management-system'));
      });

      test('should suggest multiple modules for feature without specific module', () {
        final suggestions = BranchNamingConvention.suggestBranchNames(
          branchType: 'feature',
          description: 'data export',
        );

        expect(suggestions.length, greaterThan(1));
        expect(suggestions, contains('feature/reports-data-export'));
        expect(suggestions, contains('feature/accounting-data-export'));
      });

      test('should suggest bugfix branch names', () {
        final suggestions = BranchNamingConvention.suggestBranchNames(
          branchType: 'bugfix',
          description: 'Invoice Tax Calculation Error',
        );

        expect(suggestions, contains('bugfix/invoice-tax-calculation-error'));
      });
    });

    group('utility methods', () {
      test('should identify ERP feature branches', () {
        expect(
          BranchNamingConvention.isErpFeatureBranch('feature/hr-management'),
          isTrue,
        );
        expect(
          BranchNamingConvention.isErpFeatureBranch('bugfix/some-issue'),
          isFalse,
        );
        expect(
          BranchNamingConvention.isErpFeatureBranch('main'),
          isFalse,
        );
      });

      test('should extract ERP module from feature branches', () {
        expect(
          BranchNamingConvention.getErpModule('feature/hr-management'),
          equals('hr'),
        );
        expect(
          BranchNamingConvention.getErpModule('feature/payroll-calculation'),
          equals('payroll'),
        );
        expect(
          BranchNamingConvention.getErpModule('bugfix/some-issue'),
          isNull,
        );
      });

      test('should return available modules', () {
        final modules = BranchNamingConvention.getAvailableModules();
        expect(modules, containsPair('hr', 'Human Resources Management'));
        expect(modules, containsPair('accounting', 'Accounting System'));
        expect(modules, containsPair('zatca', 'ZATCA Compliance'));
      });

      test('should get branch type info', () {
        final featureInfo = BranchNamingConvention.getBranchTypeInfo('feature');
        expect(featureInfo, isNotNull);
        expect(featureInfo!.requiresModule, isTrue);
        expect(featureInfo.examples, isNotEmpty);

        final bugfixInfo = BranchNamingConvention.getBranchTypeInfo('bugfix');
        expect(bugfixInfo, isNotNull);
        expect(bugfixInfo!.requiresModule, isFalse);
      });
    });

    group('edge cases', () {
      test('should handle empty and null branch names', () {
        expect(
          BranchNamingConvention.validateBranchName('').isValid,
          isFalse,
        );
      });

      test('should handle special characters in descriptions', () {
        final suggestions = BranchNamingConvention.suggestBranchNames(
          branchType: 'feature',
          description: 'Employee Management & Payroll System!!!',
          module: 'hr',
        );

        expect(
          suggestions.first,
          equals('feature/hr-employee-management-payroll-system'),
        );
      });

      test('should handle multiple spaces and hyphens in descriptions', () {
        final suggestions = BranchNamingConvention.suggestBranchNames(
          branchType: 'bugfix',
          description: '  multiple   spaces  --  and   hyphens  ',
        );

        expect(
          suggestions.first,
          equals('bugfix/multiple-spaces-and-hyphens'),
        );
      });
    });
  });
}
