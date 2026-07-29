// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';

import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/invoices/data/models/invoice_model.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

/// Benchmark suite for large-scale invoice processing.
void main() {
  late Isar isar;

  setUp(() async {
    final tempDir = Directory.systemTemp.createTempSync('isar_load_');
    isar = await Isar.open(
      [InvoiceModelSchema],
      directory: tempDir.path,
      name: 'load_bench_${DateTime.now().microsecondsSinceEpoch}',
      inspector: false,
    );
  });

  tearDown(() async {
    await isar.close();
  });

  Future<void> prepareInvoices(int count) async {
    final random = Random();
    final invoices = <InvoiceModel>[];

    for (var i = 0; i < count; i++) {
      final now = DateTime.now();
      final invoice = InvoiceModel()
        ..invoiceId = 'inv-$i'
        ..invoiceNumber = 'INV-${i.toString().padLeft(6, '0')}'
        ..issuedDate = now.subtract(Duration(days: random.nextInt(30)))
        ..dueDate = now.add(const Duration(days: 30))
        ..customerName = 'Benchmark Customer ${random.nextInt(100)}'
        ..customerId = 'cust-${random.nextInt(100)}'
        ..items = [
          InvoiceItemModel()
            ..id = 'item-1'
            ..name = 'Product A'
            ..description = 'Bulk Purchase'
            ..quantity = 1.0
            ..price = 1000.0
            ..taxRate = 15.0
            ..taxCategory = 'Standard'
            ..total = 1150.0
            ..taxAmount = 150.0,
        ]
        ..subtotalAmount = 1000.0
        ..taxAmount = 150.0
        ..taxRate = 15.0
        ..totalAmount = 1150.0
        ..paidAmount = random.nextBool() ? 1150.0 : 0.0
        ..status = InvoiceStatus.paid
        ..type = InvoiceType.sales
        ..currency = 'SAR'
        ..exchangeRate = 1.0
        ..discountAmount = 0.0
        ..discountRate = 0.0
        ..createdAt = now
        ..updatedAt = now
        ..syncStatus = SyncStatus.synced
        ..zatcaCounter = i
        ..isDeleted = false;

      invoices.add(invoice);
    }

    await isar.writeTxn(() async {
      await isar.invoiceModels.clear();
      await isar.invoiceModels.putAll(invoices);
    });
  }

  group('LoadSimulationBenchmark', () {
    test('Process 1000 invoices - aggregation performance', () async {
      await prepareInvoices(1000);

      final stopwatch = Stopwatch()..start();
      final models = await isar.invoiceModels.where().findAll();
      // ...

      var totalVolume = 0.0;
      for (final model in models) {
        final entity = model.toEntity();
        totalVolume += double.parse(entity.totalAmount.toString());
      }
      stopwatch.stop();

      print(
        '\n[BENCHMARK] Process 1000 invoices: '
        '${stopwatch.elapsedMilliseconds}ms (Total Volume: $totalVolume)',
      );
      // Requirement: processing 1k records should be under 500ms
      // on most hardware.
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });

    test('Filter 5000 invoices by payment status', () async {
      await prepareInvoices(5000);

      final stopwatch = Stopwatch()..start();
      final paidInvoices = await isar.invoiceModels.filter().paidAmountGreaterThan(0).findAll();
      stopwatch.stop();

      print(
        '\n[BENCHMARK] Filter 5000 invoices (partially/fully paid): '
        '${stopwatch.elapsedMilliseconds}ms (Found: ${paidInvoices.length})',
      );
      expect(stopwatch.elapsedMilliseconds, lessThan(300));
    });
  });
}
