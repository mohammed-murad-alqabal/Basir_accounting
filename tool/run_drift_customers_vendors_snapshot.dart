import 'dart:convert';
import 'dart:io';

import 'package:basir_accounting_system/core/persistence/drift_customers_vendors_snapshot.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln(
      'Usage: dart run tool/run_drift_customers_vendors_snapshot.dart '
      '<snapshot.json>',
    );
    exitCode = 64;
    return;
  }

  try {
    final source = await File(args.single).readAsString();
    final snapshot = DriftCustomersVendorsSnapshot.fromJsonString(source);
    final report = await DriftCustomersVendorsSnapshotRunner().run(
      snapshot,
      databaseFactory: () => BasirDatabase(NativeDatabase.memory()),
    );

    stdout.writeln(
      jsonEncode({
        'clean': report.isClean,
        'migration': {
          'customers': {
            'sourceCount': report.migration.customers.sourceCount,
            'migratedCount': report.migration.customers.migratedCount,
            'complete': report.migration.customers.isComplete,
          },
          'vendors': {
            'sourceCount': report.migration.vendors.sourceCount,
            'migratedCount': report.migration.vendors.migratedCount,
            'complete': report.migration.vendors.isComplete,
          },
        },
        'parity': {
          'customersMatch': report.parity.customers.matches,
          'vendorsMatch': report.parity.vendors.matches,
          'duplicateCustomerKeyCount':
              report.parity.duplicateCustomerKeys.length,
          'duplicateVendorKeyCount': report.parity.duplicateVendorKeys.length,
        },
      }),
    );
  } on Object catch (error) {
    stderr.writeln('Snapshot run failed: ${error.runtimeType}.');
    exitCode = 1;
  }
}
