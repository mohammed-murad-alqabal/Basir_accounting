/// Branch Naming Convention Utility for Basir ERP Development
///
/// This utility class provides validation and management for Git branch naming
/// conventions specific to ERP development workflows.
///
/// Author: فريق وكلاء تطوير مشروع بصير

class BranchNamingConvention {
  /// ERP module prefixes for feature branches
  static const Map<String, String> erpModules = {
    'hr': 'Human Resources Management',
    'payroll': 'Payroll Calculation System',
    'inventory': 'Inventory Management',
    'accounting': 'Accounting System',
    'invoices': 'Invoice Management',
    'customers': 'Customer Relationship Management',
    'vendors': 'Vendor Management',
    'reports': 'Reporting System',
    'erp': 'General ERP Features',
    'zatca': 'ZATCA Compliance',
    'tax': 'Tax Management',
    'ui': 'User Interface & Experience',
    'core': 'Core System Features',
    'security': 'Security Enhancements',
  };

  /// Branch type patterns with their descriptions
  static const Map<String, BranchTypeInfo> branchTypes = {
    'feature': BranchTypeInfo(
      pattern: r'^feature/([a-z]+)-([a-z0-9-]+)$',
      description: 'New feature development',
      requiresModule: true,
      examples: [
        'feature/hr-employee-management',
        'feature/payroll-salary-calculation',
        'feature/accounting-journal-entries',
      ],
    ),
    'bugfix': BranchTypeInfo(
      pattern: r'^bugfix/([a-z0-9-]+)$',
      description: 'Bug fixes',
      requiresModule: false,
      examples: [
        'bugfix/invoice-tax-calculation',
        'bugfix/customer-search-error',
      ],
    ),
    'hotfix': BranchTypeInfo(
      pattern: r'^hotfix/([a-z0-9-]+)$',
      description: 'Critical production fixes',
      requiresModule: false,
      examples: [
        'hotfix/zatca-compliance-error',
        'hotfix/payment-processing-failure',
      ],
    ),
    'release': BranchTypeInfo(
      pattern: r'^release/v([0-9]+)\.([0-9]+)\.([0-9]+)(-[a-z0-9-]+)?$',
      description: 'Release preparation',
      requiresModule: false,
      examples: [
        'release/v1.2.0',
        'release/v1.2.0-beta',
      ],
    ),
    'docs': BranchTypeInfo(
      pattern: r'^docs/([a-z0-9-]+)$',
      description: 'Documentation updates',
      requiresModule: false,
      examples: [
        'docs/api-documentation',
        'docs/user-guide-update',
      ],
    ),
    'chore': BranchTypeInfo(
      pattern: r'^chore/([a-z0-9-]+)$',
      description: 'Maintenance and housekeeping',
      requiresModule: false,
      examples: [
        'chore/dependency-updates',
        'chore/code-cleanup',
      ],
    ),
    'refactor': BranchTypeInfo(
      pattern: r'^refactor/([a-z0-9-]+)$',
      description: 'Code refactoring',
      requiresModule: false,
      examples: [
        'refactor/database-layer',
        'refactor/ui-components',
      ],
    ),
    'experiment': BranchTypeInfo(
      pattern: r'^experiment/([a-z0-9-]+)$',
      description: 'Experimental features',
      requiresModule: false,
      examples: [
        'experiment/ai-categorization',
        'experiment/blockchain-integration',
      ],
    ),
  };

  /// Protected branch names that should never be deleted or force-pushed
  static const Set<String> protectedBranches = {
    'main',
    'development',
  };

  /// Validates a branch name against ERP naming conventions
  static BranchValidationResult validateBranchName(String branchName) {
    // Check for protected branches
    if (protectedBranches.contains(branchName)) {
      return BranchValidationResult(
        isValid: true,
        branchType: 'protected',
        message: 'Protected branch',
      );
    }

    // Check against each branch type pattern
    for (final entry in branchTypes.entries) {
      final branchType = entry.key;
      final info = entry.value;
      final regex = RegExp(info.pattern);
      final match = regex.firstMatch(branchName);

      if (match != null) {
        // For feature branches, validate the module
        if (branchType == 'feature' && info.requiresModule) {
          final module = match.group(1);
          if (module != null && !erpModules.containsKey(module)) {
            return BranchValidationResult(
              isValid: false,
              branchType: branchType,
              message: 'Invalid ERP module: $module. '
                  'Valid modules: ${erpModules.keys.join(', ')}',
            );
          }
        }

        return BranchValidationResult(
          isValid: true,
          branchType: branchType,
          message: 'Valid $branchType branch',
          module: branchType == 'feature' ? match.group(1) : null,
        );
      }
    }

    return BranchValidationResult(
      isValid: false,
      branchType: 'unknown',
      message: 'Branch name does not match any valid pattern',
    );
  }

  /// Suggests a proper branch name based on input
  static List<String> suggestBranchNames({
    required String branchType,
    required String description,
    String? module,
  }) {
    final suggestions = <String>[];
    final cleanDescription = _cleanDescription(description);

    switch (branchType.toLowerCase()) {
      case 'feature':
        if (module != null && erpModules.containsKey(module)) {
          suggestions.add('feature/$module-$cleanDescription');
        } else {
          // Suggest all possible modules
          for (final moduleKey in erpModules.keys) {
            suggestions.add('feature/$moduleKey-$cleanDescription');
          }
        }
        break;
      case 'bugfix':
        suggestions.add('bugfix/$cleanDescription');
        break;
      case 'hotfix':
        suggestions.add('hotfix/$cleanDescription');
        break;
      case 'docs':
        suggestions.add('docs/$cleanDescription');
        break;
      case 'chore':
        suggestions.add('chore/$cleanDescription');
        break;
      case 'refactor':
        suggestions.add('refactor/$cleanDescription');
        break;
      case 'experiment':
        suggestions.add('experiment/$cleanDescription');
        break;
    }

    return suggestions;
  }

  /// Cleans and formats a description for use in branch names
  static String _cleanDescription(String description) {
    return description
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Gets information about a specific branch type
  static BranchTypeInfo? getBranchTypeInfo(String branchType) {
    return branchTypes[branchType];
  }

  /// Lists all available ERP modules
  static Map<String, String> getAvailableModules() {
    return Map.from(erpModules);
  }

  /// Checks if a branch name indicates an ERP feature
  static bool isErpFeatureBranch(String branchName) {
    final result = validateBranchName(branchName);
    return result.isValid &&
        result.branchType == 'feature' &&
        result.module != null &&
        erpModules.containsKey(result.module);
  }

  /// Gets the ERP module from a feature branch name
  static String? getErpModule(String branchName) {
    final result = validateBranchName(branchName);
    return result.module;
  }
}

/// Information about a branch type
class BranchTypeInfo {
  const BranchTypeInfo({
    required this.pattern,
    required this.description,
    required this.requiresModule,
    required this.examples,
  });

  final String pattern;
  final String description;
  final bool requiresModule;
  final List<String> examples;
}

/// Result of branch name validation
class BranchValidationResult {
  const BranchValidationResult({
    required this.isValid,
    required this.branchType,
    required this.message,
    this.module,
  });

  final bool isValid;
  final String branchType;
  final String message;
  final String? module;

  @override
  String toString() {
    return 'BranchValidationResult('
        'isValid: $isValid, '
        'branchType: $branchType, '
        'message: $message'
        '${module != null ? ', module: $module' : ''}'
        ')';
  }
}
