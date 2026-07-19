/// ***
/// Cognitive Foundation: Auth Models
///
/// This module defines high-fidelity data structures for authentication
/// results, security posture assessments, and institutional identity
/// management.
///
/// Ref: BASIR-AUTH-SPEC-2025
/// ***
library;

import 'package:supabase_flutter/supabase_flutter.dart';

/// [PasswordStrengthResult]
///
/// Encapsulates the quantitative and qualitative analysis of credential
/// entropy. Used during setup and password change workflows to ensure
/// institutional security standards.
class PasswordStrengthResult {
  /// Initializes a strength assessment.
  const PasswordStrengthResult({
    required this.score,
    required this.isStrong,
    required this.issues,
  });

  /// Numerical entropy score (0-100).
  final int score;

  /// Binary state indicating compliance with security thresholds.
  final bool isStrong;

  /// Semantic breakdown of identified vulnerabilities.
  final List<String> issues;

  /// Natural language representation of the security grade.
  String get strengthLevel {
    if (score >= 80) return 'قوية جداً';
    if (score >= 60) return 'قوية';
    if (score >= 40) return 'متوسطة';
    if (score >= 20) return 'ضعيفة';
    return 'ضعيفة جداً';
  }
}

/// [SecurityAuditResult]
///
/// Represents the result of an institutional hardware-and-data integrity audit.
/// Evaluates the current security posture including encryption health and
/// account synchronization state.
class SecurityAuditResult {
  /// Initializes an audit report.
  const SecurityAuditResult({
    required this.securityScore,
    required this.isSecure,
    required this.issues,
    required this.hasAccount,
    required this.hasValidEncryption,
  });

  /// Aggregate posture score (0-100).
  final int securityScore;

  /// System-wide safety flag.
  final bool isSecure;

  /// Forensic log of security incidents or gaps.
  final List<String> issues;

  /// Persistence flag for registered identities.
  final bool hasAccount;

  /// Validation state of local cryptographic keys.
  final bool hasValidEncryption;

  /// Qualitative security tier.
  String get securityLevel {
    if (securityScore >= 90) return 'ممتاز';
    if (securityScore >= 80) return 'جيد جداً';
    if (securityScore >= 70) return 'جيد';
    if (securityScore >= 60) return 'مقبول';
    return 'غير آمن';
  }
}

/// [UserRole]
///
/// Defines the institutional hierarchy of operators.
enum UserRole {
  /// Full administrative privileges.
  admin,

  /// Financial data management role.
  accountant,

  /// Inventory and warehouse management role.
  storeManager,

  /// Read-only access for oversight.
  viewer,
}

/// [Permission]
///
/// Bitmask flags for granular access control.
class Permission {
  /// No permissions.
  static const int none = 0;

  /// View financial statements and reports.
  static const int viewFinancials = 1 << 0;

  /// Create and post journal entries.
  static const int postJournalEntry = 1 << 1;

  /// Manage inventory items and stock.
  static const int manageInventory = 1 << 2;

  /// User administration capabilities.
  static const int manageUsers = 1 << 3;

  /// Approve pending transactions.
  static const int approveTransactions = 1 << 4;

  /// Access to sensitive financial reports.
  static const int viewSensitiveReports = 1 << 5;

  /// All permissions combined.
  static const int all = viewFinancials |
      postJournalEntry |
      manageInventory |
      manageUsers |
      approveTransactions |
      viewSensitiveReports;
}

/// [BasirUser]
///
/// The central identity entity representing a verified operator or a guest.
/// Implements data isolation through unified ID management across Supabase
/// and local storage.
class BasirUser {
  /// Standard constructor for active identities.
  const BasirUser({
    required this.id,
    required this.email,
    this.displayName,
    this.role = UserRole.viewer,
    this.permissions = Permission.none,
    this.warehouseId,
    this.isGuest = false,
    this.metadata = const {},
  });

  /// Factory constructor for mapping cloud identities to the Basir domain.
  factory BasirUser.fromSupabase(User user) {
    // Determine role from metadata or default to viewer
    final roleStr = user.userMetadata?['role'] as String? ?? 'viewer';
    final role = UserRole.values.firstWhere(
      (e) => e.name == roleStr,
      orElse: () => UserRole.viewer,
    );

    // Determine permissions from metadata or role defaults
    final permissions = user.userMetadata?['permissions'] as int? ??
        getDefaultPermissions(role);

    return BasirUser(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String?,
      role: role,
      permissions: permissions,
      warehouseId: user.userMetadata?['warehouse_id'] as String?,
      metadata: user.userMetadata ?? {},
    );
  }

  /// Unique immutable identifier (UUID).
  final String id;

  /// Verified communication handle.
  final String email;

  /// Institutional alias.
  final String? displayName;

  /// Operational role within the organization.
  final UserRole role;

  /// Granular access control bitmask.
  final int permissions;

  /// Scope isolation identifier for inventory management.
  final String? warehouseId;

  /// Transient state flag for unverified operators.
  final bool isGuest;

  /// Polymorphic metadata for role-based access or settings.
  final Map<String, dynamic> metadata;

  /// Checks if the user has a specific permission.
  bool hasPermission(int permission) =>
      (permissions & permission) == permission;

  /// Checks if the user accesses a specific warehouse scope.
  bool hasAccessToWarehouse(String targetWarehouseId) {
    if (role == UserRole.admin) return true;
    return warehouseId == targetWarehouseId;
  }

  /// Returns default permissions for a given role.
  static int getDefaultPermissions(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Permission.all;
      case UserRole.accountant:
        return Permission.viewFinancials |
            Permission.postJournalEntry |
            Permission.viewSensitiveReports;
      case UserRole.storeManager:
        return Permission.manageInventory;
      case UserRole.viewer:
        return Permission.viewFinancials;
    }
  }
}
