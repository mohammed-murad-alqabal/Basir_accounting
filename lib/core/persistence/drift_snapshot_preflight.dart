import 'dart:convert';

import 'drift_stock_movements_golden.dart';

/// تصنيف آمن لفشل preflight دون إرجاع السطر أو القيمة الحساسة.
enum DriftSnapshotPreflightFailure {
  secretPattern,
  invalidJson,
  invalidCatalog,
}

class DriftSnapshotPreflightReport {
  const DriftSnapshotPreflightReport._({
    required this.isValid,
    required this.sanitized,
    required this.fixtureVersion,
    required this.cleanFixtureCount,
    required this.blockedFixtureCount,
    this.failure,
  });

  const DriftSnapshotPreflightReport.valid({
    required bool sanitized,
    required int fixtureVersion,
    required int cleanFixtureCount,
    required int blockedFixtureCount,
  }) : this._(
         isValid: true,
         sanitized: sanitized,
         fixtureVersion: fixtureVersion,
         cleanFixtureCount: cleanFixtureCount,
         blockedFixtureCount: blockedFixtureCount,
       );

  const DriftSnapshotPreflightReport.invalid(
    DriftSnapshotPreflightFailure failure,
  ) : this._(
         isValid: false,
         sanitized: false,
         fixtureVersion: 0,
         cleanFixtureCount: 0,
         blockedFixtureCount: 0,
         failure: failure,
       );

  final bool isValid;
  final bool sanitized;
  final int fixtureVersion;
  final int cleanFixtureCount;
  final int blockedFixtureCount;
  final DriftSnapshotPreflightFailure? failure;

  Map<String, Object?> toSafeJson() => {
    'valid': isValid,
    'sanitized': sanitized,
    'fixtureVersion': fixtureVersion,
    'cleanFixtureCount': cleanFixtureCount,
    'blockedFixtureCount': blockedFixtureCount,
    if (failure != null) 'failure': failure!.name,
  };
}

/// فحص offline لا يكتب SQLite/Isar ولا يعيد محتوى snapshot.
class DriftSnapshotPreflight {
  const DriftSnapshotPreflight._();

  static DriftSnapshotPreflightReport validate(String source) {
    if (_containsSecretPattern(source)) {
      return const DriftSnapshotPreflightReport.invalid(
        DriftSnapshotPreflightFailure.secretPattern,
      );
    }

    late final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException {
      return const DriftSnapshotPreflightReport.invalid(
        DriftSnapshotPreflightFailure.invalidJson,
      );
    }

    if (decoded is! Map<String, Object?> || decoded['sanitized'] != true) {
      return const DriftSnapshotPreflightReport.invalid(
        DriftSnapshotPreflightFailure.invalidCatalog,
      );
    }

    try {
      final catalog = StockMovementGoldenCatalog.fromJson(decoded);
      return DriftSnapshotPreflightReport.valid(
        sanitized: true,
        fixtureVersion: catalog.fixtureVersion,
        cleanFixtureCount: catalog.cleanFixtures.length,
        blockedFixtureCount: catalog.blockedFixtures.length,
      );
    } on Object {
      return const DriftSnapshotPreflightReport.invalid(
        DriftSnapshotPreflightFailure.invalidCatalog,
      );
    }
  }

  static bool _containsSecretPattern(String source) => _secretPatterns.any(
    (pattern) => pattern.hasMatch(source),
  );

  static final List<RegExp> _secretPatterns = [
    RegExp(r'ghp_[A-Za-z0-9]{20,}'),
    RegExp(r'github_pat_[A-Za-z0-9_]{20,}'),
    RegExp(r'AKIA[0-9A-Z]{16}'),
    RegExp(
      r'Bearer\s+[A-Za-z0-9._-]{20,}',
      caseSensitive: false,
    ),
    RegExp(r'-----BEGIN [^-]*PRIVATE KEY-----'),
    RegExp(
      r'''(?:password|passwd|secret|token|api[_-]?key)\s*[:=]\s*["']?[^"'\s,]{8,}''',
      caseSensitive: false,
    ),
    RegExp(
      r'(?:postgres|mysql|mongodb(?:\+srv)?|redis)://[^/\s:@]+:[^@\s]+@',
      caseSensitive: false,
    ),
    RegExp(
      r'aws_secret_access_key\s*[:=]',
      caseSensitive: false,
    ),
  ];
}
