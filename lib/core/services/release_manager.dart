/// Release Management Service for Basir ERP Development
///
/// This service handles the creation, management, and finalization of release
/// branches following ERP development best practices and semantic versioning.
///
/// Author: فريق وكلاء تطوير مشروع بصير

import 'dart:io';

/// Manages release workflows for the Basir ERP system
class ReleaseManager {
  /// Semantic version pattern for validation
  static final RegExp _versionPattern = RegExp(
    r'^v?(\d+)\.(\d+)\.(\d+)(?:-([a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*))?$',
  );

  /// ERP-specific release types and their characteristics
  static const Map<String, ReleaseTypeInfo> releaseTypes = {
    'major': ReleaseTypeInfo(
      description: 'Major version with breaking changes',
      incrementType: VersionIncrement.major,
      requiresFullTesting: true,
      requiresDocumentationUpdate: true,
      exampleChanges: [
        'New ERP modules (HR, Payroll)',
        'Breaking API changes',
        'Database schema changes',
        'Major UI/UX overhaul',
      ],
    ),
    'minor': ReleaseTypeInfo(
      description: 'Minor version with new features',
      incrementType: VersionIncrement.minor,
      requiresFullTesting: true,
      requiresDocumentationUpdate: true,
      exampleChanges: [
        'New features within existing modules',
        'Enhanced reporting capabilities',
        'Additional ZATCA compliance features',
        'Performance improvements',
      ],
    ),
    'patch': ReleaseTypeInfo(
      description: 'Patch version with bug fixes',
      incrementType: VersionIncrement.patch,
      requiresFullTesting: false,
      requiresDocumentationUpdate: false,
      exampleChanges: [
        'Bug fixes',
        'Security patches',
        'Minor UI corrections',
        'Dependency updates',
      ],
    ),
  };

  /// Creates a new release branch with proper validation
  static Future<ReleaseResult> createReleaseBranch({
    required String version,
    required String releaseType,
    String? description,
    bool dryRun = false,
  }) async {
    try {
      // Validate version format
      final versionValidation = validateVersion(version);
      if (!versionValidation.isValid) {
        return ReleaseResult.error(versionValidation.message);
      }

      // Validate release type
      if (!releaseTypes.containsKey(releaseType)) {
        return ReleaseResult.error(
          'Invalid release type: $releaseType. '
          'Valid types: ${releaseTypes.keys.join(', ')}',
        );
      }

      final releaseInfo = releaseTypes[releaseType]!;
      final branchName = 'release/$version';

      if (dryRun) {
        return ReleaseResult.success(
          'Dry run: Would create release branch $branchName',
          branchName: branchName,
        );
      }

      // Check if branch already exists
      final branchExists = await _checkBranchExists(branchName);
      if (branchExists) {
        return ReleaseResult.error('Release branch $branchName already exists');
      }

      // Create release branch from development
      final createResult = await _createBranchFromDevelopment(branchName);
      if (!createResult.success) {
        return ReleaseResult.error(createResult.message);
      }

      // Update version in pubspec.yaml
      final versionUpdateResult = await _updateVersionInPubspec(version);
      if (!versionUpdateResult.success) {
        return ReleaseResult.error(versionUpdateResult.message);
      }

      // Create release notes template
      await _createReleaseNotesTemplate(version, releaseType, description);

      // Create release checklist
      await _createReleaseChecklist(version, releaseInfo);

      return ReleaseResult.success(
        'Release branch $branchName created successfully',
        branchName: branchName,
        version: version,
        releaseType: releaseType,
      );
    } catch (e) {
      return ReleaseResult.error('Failed to create release branch: $e');
    }
  }

  /// Finalizes a release by merging to main and tagging
  static Future<ReleaseResult> finalizeRelease({
    required String version,
    required String releaseNotes,
    bool dryRun = false,
  }) async {
    try {
      final branchName = 'release/$version';

      if (dryRun) {
        return ReleaseResult.success(
          'Dry run: Would finalize release $version',
          version: version,
        );
      }

      // Validate that we're on the correct release branch
      final currentBranch = await _getCurrentBranch();
      if (currentBranch != branchName) {
        return ReleaseResult.error(
          'Must be on release branch $branchName to finalize. '
          'Current branch: $currentBranch',
        );
      }

      // Run pre-release checks
      final checksResult = await _runPreReleaseChecks();
      if (!checksResult.success) {
        return ReleaseResult.error(checksResult.message);
      }

      // Merge to main
      final mergeResult = await _mergeToMain(branchName);
      if (!mergeResult.success) {
        return ReleaseResult.error(mergeResult.message);
      }

      // Create and push tag
      final tagResult = await _createAndPushTag(version, releaseNotes);
      if (!tagResult.success) {
        return ReleaseResult.error(tagResult.message);
      }

      // Merge back to development
      final backMergeResult = await _mergeBackToDevelopment(branchName);
      if (!backMergeResult.success) {
        return ReleaseResult.error(backMergeResult.message);
      }

      // Clean up release branch
      await _cleanupReleaseBranch(branchName);

      return ReleaseResult.success(
        'Release $version finalized successfully',
        version: version,
      );
    } catch (e) {
      return ReleaseResult.error('Failed to finalize release: $e');
    }
  }

  /// Validates version format and semantic versioning rules
  static VersionValidationResult validateVersion(String version) {
    final cleanVersion = version.startsWith('v') ? version.substring(1) : version;
    final match = _versionPattern.firstMatch('v$cleanVersion');

    if (match == null) {
      return VersionValidationResult(
        isValid: false,
        message: 'Invalid version format. Expected: v1.2.3 or v1.2.3-beta',
      );
    }

    final major = int.parse(match.group(1)!);
    final minor = int.parse(match.group(2)!);
    final patch = int.parse(match.group(3)!);
    final prerelease = match.group(4);

    // Validate semantic versioning rules
    if (major < 0 || minor < 0 || patch < 0) {
      return VersionValidationResult(
        isValid: false,
        message: 'Version numbers cannot be negative',
      );
    }

    return VersionValidationResult(
      isValid: true,
      message: 'Valid version format',
      major: major,
      minor: minor,
      patch: patch,
      prerelease: prerelease,
    );
  }

  /// Gets the next version based on current version and increment type
  static String getNextVersion(
    String currentVersion,
    VersionIncrement increment,
  ) {
    final validation = validateVersion(currentVersion);
    if (!validation.isValid) {
      throw ArgumentError('Invalid current version: $currentVersion');
    }

    final major = validation.major!;
    final minor = validation.minor!;
    final patch = validation.patch!;

    switch (increment) {
      case VersionIncrement.major:
        return 'v${major + 1}.0.0';
      case VersionIncrement.minor:
        return 'v$major.${minor + 1}.0';
      case VersionIncrement.patch:
        return 'v$major.$minor.${patch + 1}';
    }
  }

  /// Lists all release branches
  static Future<List<String>> listReleaseBranches() async {
    try {
      final result = await Process.run('git', ['branch', '-r']);
      if (result.exitCode != 0) {
        return [];
      }

      final branches = result.stdout
          .toString()
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.contains('release/'))
          .map((line) => line.replaceAll('origin/', ''))
          .toList();

      return branches;
    } catch (e) {
      return [];
    }
  }

  // Private helper methods

  static Future<bool> _checkBranchExists(String branchName) async {
    try {
      final result =
          await Process.run('git', ['show-ref', '--verify', '--quiet', 'refs/heads/$branchName']);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  static Future<GitOperationResult> _createBranchFromDevelopment(String branchName) async {
    try {
      // Ensure we're on development branch
      await Process.run('git', ['checkout', 'development']);

      // Pull latest changes
      await Process.run('git', ['pull', 'origin', 'development']);

      // Create new branch
      final result = await Process.run('git', ['checkout', '-b', branchName]);

      if (result.exitCode == 0) {
        return GitOperationResult(success: true, message: 'Branch created successfully');
      } else {
        return GitOperationResult(success: false, message: result.stderr.toString());
      }
    } catch (e) {
      return GitOperationResult(success: false, message: e.toString());
    }
  }

  static Future<GitOperationResult> _updateVersionInPubspec(String version) async {
    try {
      final pubspecFile = File('pubspec.yaml');
      if (!pubspecFile.existsSync()) {
        return GitOperationResult(success: false, message: 'pubspec.yaml not found');
      }

      final content = await pubspecFile.readAsString();
      final cleanVersion = version.startsWith('v') ? version.substring(1) : version;

      // Update version line
      final updatedContent = content.replaceFirst(
        RegExp(r'^version:\s*.*$', multiLine: true),
        'version: $cleanVersion+1',
      );

      await pubspecFile.writeAsString(updatedContent);

      // Stage the change
      await Process.run('git', ['add', 'pubspec.yaml']);

      return GitOperationResult(success: true, message: 'Version updated in pubspec.yaml');
    } catch (e) {
      return GitOperationResult(success: false, message: e.toString());
    }
  }

  static Future<void> _createReleaseNotesTemplate(
    String version,
    String releaseType,
    String? description,
  ) async {
    final releaseInfo = releaseTypes[releaseType]!;
    final template = '''# Release Notes - $version

## Release Type: ${releaseInfo.description}

${description != null ? '## Description\n$description\n' : ''}
## Changes in this Release

### New Features
- [ ] Feature 1
- [ ] Feature 2

### Bug Fixes
- [ ] Fix 1
- [ ] Fix 2

### Improvements
- [ ] Improvement 1
- [ ] Improvement 2

### ERP Module Updates
- [ ] Accounting: 
- [ ] Invoices: 
- [ ] Customers: 
- [ ] Vendors: 
- [ ] Inventory: 
- [ ] Reports: 

### ZATCA Compliance
- [ ] Compliance update 1
- [ ] Compliance update 2

### Breaking Changes
${releaseType == 'major' ? '- [ ] Breaking change 1\n- [ ] Breaking change 2' : '- None'}

### Migration Guide
${releaseType == 'major' ? '- [ ] Migration step 1\n- [ ] Migration step 2' : '- No migration required'}

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] Performance testing completed

## Documentation
- [ ] API documentation updated
- [ ] User guide updated
- [ ] Developer documentation updated

---
**Prepared by:** فريق وكلاء تطوير مشروع بصير
**Date:** ${DateTime.now().toIso8601String().split('T')[0]}
''';

    final file = File('RELEASE_NOTES_$version.md');
    await file.writeAsString(template);
  }

  static Future<void> _createReleaseChecklist(
    String version,
    ReleaseTypeInfo releaseInfo,
  ) async {
    final checklist = '''# Release Checklist - $version

## Pre-Release Checks
- [ ] All tests pass (flutter test)
- [ ] Code analysis passes (flutter analyze)
- [ ] No security vulnerabilities
- [ ] Performance benchmarks meet requirements
${releaseInfo.requiresFullTesting ? '- [ ] Full regression testing completed' : ''}
${releaseInfo.requiresDocumentationUpdate ? '- [ ] Documentation updated' : ''}

## ERP-Specific Checks
- [ ] Accounting equation integrity verified
- [ ] ZATCA compliance maintained
- [ ] Invoice generation tested
- [ ] Customer/Vendor management tested
- [ ] Inventory calculations verified
- [ ] Report generation tested

## Release Process
- [ ] Release branch created from development
- [ ] Version updated in pubspec.yaml
- [ ] Release notes prepared
- [ ] All changes committed and pushed
- [ ] Pull request created for main branch
- [ ] Code review completed
- [ ] CI/CD pipeline passes

## Post-Release
- [ ] Tag created and pushed
- [ ] Release notes published
- [ ] Changes merged back to development
- [ ] Release branch cleaned up
- [ ] Stakeholders notified

---
**Release Manager:** فريق وكلاء تطوير مشروع بصير
**Date:** ${DateTime.now().toIso8601String().split('T')[0]}
''';

    final file = File('RELEASE_CHECKLIST_$version.md');
    await file.writeAsString(checklist);
  }

  static Future<String> _getCurrentBranch() async {
    final result = await Process.run('git', ['rev-parse', '--abbrev-ref', 'HEAD']);
    return result.stdout.toString().trim();
  }

  static Future<GitOperationResult> _runPreReleaseChecks() async {
    // Run flutter analyze
    final analyzeResult = await Process.run('flutter', ['analyze']);
    if (analyzeResult.exitCode != 0) {
      return GitOperationResult(
        success: false,
        message: 'Flutter analyze failed: ${analyzeResult.stderr}',
      );
    }

    // Run tests
    final testResult = await Process.run('flutter', ['test']);
    if (testResult.exitCode != 0) {
      return GitOperationResult(
        success: false,
        message: 'Tests failed: ${testResult.stderr}',
      );
    }

    return GitOperationResult(success: true, message: 'Pre-release checks passed');
  }

  static Future<GitOperationResult> _mergeToMain(String branchName) async {
    try {
      await Process.run('git', ['checkout', 'main']);
      await Process.run('git', ['pull', 'origin', 'main']);

      final result = await Process.run('git', ['merge', '--no-ff', branchName]);

      if (result.exitCode == 0) {
        await Process.run('git', ['push', 'origin', 'main']);
        return GitOperationResult(success: true, message: 'Merged to main successfully');
      } else {
        return GitOperationResult(success: false, message: result.stderr.toString());
      }
    } catch (e) {
      return GitOperationResult(success: false, message: e.toString());
    }
  }

  static Future<GitOperationResult> _createAndPushTag(String version, String releaseNotes) async {
    try {
      final result = await Process.run('git', ['tag', '-a', version, '-m', releaseNotes]);

      if (result.exitCode == 0) {
        await Process.run('git', ['push', 'origin', version]);
        return GitOperationResult(success: true, message: 'Tag created and pushed');
      } else {
        return GitOperationResult(success: false, message: result.stderr.toString());
      }
    } catch (e) {
      return GitOperationResult(success: false, message: e.toString());
    }
  }

  static Future<GitOperationResult> _mergeBackToDevelopment(String branchName) async {
    try {
      await Process.run('git', ['checkout', 'development']);
      await Process.run('git', ['pull', 'origin', 'development']);

      final result = await Process.run('git', ['merge', '--no-ff', branchName]);

      if (result.exitCode == 0) {
        await Process.run('git', ['push', 'origin', 'development']);
        return GitOperationResult(success: true, message: 'Merged back to development');
      } else {
        return GitOperationResult(success: false, message: result.stderr.toString());
      }
    } catch (e) {
      return GitOperationResult(success: false, message: e.toString());
    }
  }

  static Future<void> _cleanupReleaseBranch(String branchName) async {
    try {
      await Process.run('git', ['branch', '-d', branchName]);
      await Process.run('git', ['push', 'origin', '--delete', branchName]);
    } catch (e) {
      // Ignore cleanup errors
    }
  }
}

/// Information about different release types
class ReleaseTypeInfo {
  const ReleaseTypeInfo({
    required this.description,
    required this.incrementType,
    required this.requiresFullTesting,
    required this.requiresDocumentationUpdate,
    required this.exampleChanges,
  });

  final String description;
  final VersionIncrement incrementType;
  final bool requiresFullTesting;
  final bool requiresDocumentationUpdate;
  final List<String> exampleChanges;
}

/// Types of version increments
enum VersionIncrement { major, minor, patch }

/// Result of version validation
class VersionValidationResult {
  const VersionValidationResult({
    required this.isValid,
    required this.message,
    this.major,
    this.minor,
    this.patch,
    this.prerelease,
  });

  final bool isValid;
  final String message;
  final int? major;
  final int? minor;
  final int? patch;
  final String? prerelease;
}

/// Result of release operations
class ReleaseResult {
  const ReleaseResult({
    required this.success,
    required this.message,
    this.branchName,
    this.version,
    this.releaseType,
  });

  final bool success;
  final String message;
  final String? branchName;
  final String? version;
  final String? releaseType;

  factory ReleaseResult.success(
    String message, {
    String? branchName,
    String? version,
    String? releaseType,
  }) {
    return ReleaseResult(
      success: true,
      message: message,
      branchName: branchName,
      version: version,
      releaseType: releaseType,
    );
  }

  factory ReleaseResult.error(String message) {
    return ReleaseResult(success: false, message: message);
  }
}

/// Result of Git operations
class GitOperationResult {
  const GitOperationResult({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;
}
