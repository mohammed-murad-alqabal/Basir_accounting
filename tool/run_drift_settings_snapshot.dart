import 'dart:convert';
import 'dart:io';

import 'package:basir_accounting_system/core/persistence/drift_settings_parity.dart';
import 'package:basir_accounting_system/core/persistence/drift_settings_snapshot.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1) {
    stderr.writeln(
      'Usage: dart run tool/run_drift_settings_snapshot.dart <snapshot.json>',
    );
    exitCode = 64;
    return;
  }

  try {
    final source = await File(arguments.single).readAsString();
    final snapshot = DriftSettingsSnapshot.fromJsonString(source);
    final report = await DriftSettingsSnapshotRunner().run(
      snapshot,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
    );

    stdout.writeln(
      jsonEncode({
        'clean': report.isClean,
        'migration': {
          'profiles': _checkpoint(report.migration.profiles),
          'businessSettings': _checkpoint(report.migration.businessSettings),
        },
        'parity': {
          'profiles': _comparison(report.parity.profiles),
          'businessSettings': _comparison(report.parity.businessSettings),
          'ambiguousProfileScopes': report.parity.ambiguousProfileScopes.length,
          'ambiguousBusinessSettingsScopes':
              report.parity.ambiguousBusinessSettingsScopes.length,
        },
      }),
    );
  } on Object catch (error) {
    stderr.writeln('Snapshot verification failed: ${error.runtimeType}');
    exitCode = 1;
  }
}

Map<String, Object?> _checkpoint(MigrationCheckpoint checkpoint) => {
      'sourceCount': checkpoint.sourceCount,
      'migratedCount': checkpoint.migratedCount,
      'complete': checkpoint.isComplete,
    };

Map<String, Object?> _comparison(DriftSettingsParityComparison comparison) => {
      'expectedCount': comparison.expectedCount,
      'actualCount': comparison.actualCount,
      'matches': comparison.matches,
    };
