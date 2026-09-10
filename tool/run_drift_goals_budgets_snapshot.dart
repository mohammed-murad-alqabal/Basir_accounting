import 'dart:convert';
import 'dart:io';

import 'package:basir_accounting_system/core/persistence/drift_goals_budgets_snapshot.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln(
      'Usage: dart run tool/run_drift_goals_budgets_snapshot.dart <snapshot.json>',
    );
    exitCode = 64;
    return;
  }

  try {
    final source = await File(args.single).readAsString();
    final snapshot = DriftGoalsBudgetsSnapshot.fromJsonString(source);
    final report = await DriftGoalsBudgetsSnapshotRunner().run(
      snapshot,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
    );

    stdout.writeln(
      jsonEncode({
        'clean': report.isClean,
        'migration': {
          'goals': {
            'sourceCount': report.migration.goals.sourceCount,
            'migratedCount': report.migration.goals.migratedCount,
            'complete': report.migration.goals.isComplete,
          },
          'budgets': {
            'sourceCount': report.migration.budgets.sourceCount,
            'migratedCount': report.migration.budgets.migratedCount,
            'complete': report.migration.budgets.isComplete,
          },
        },
        'parity': {
          'goalsMatch': report.parity.goals.matches,
          'budgetsMatch': report.parity.budgets.matches,
          'ambiguousGoalScopeCount': report.parity.ambiguousGoalScopes.length,
          'ambiguousBudgetScopeCount':
              report.parity.ambiguousBudgetScopes.length,
        },
      }),
    );
  } on Object catch (error) {
    stderr.writeln('Snapshot run failed: ${error.runtimeType}.');
    exitCode = 1;
  }
}
