// ignore_for_file: avoid_print, lines_longer_than_80_chars
import 'dart:io';
import 'dart:math';

import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

/// Benchmark suite for ForensicAuditService performance testing.
///
/// This suite measures execution time for key audit operations
/// with varying data volumes to establish performance baselines.
void main() {
  late Isar isar;

  setUp(() async {
    final tempDir = Directory.systemTemp.createTempSync('isar_forensic_');
    isar = await Isar.open(
      [JournalEntryModelSchema],
      directory: tempDir.path,
      name: 'forensic_bench_${DateTime.now().microsecondsSinceEpoch}',
      inspector: false,
    );
  });

  tearDown(() async {
    await isar.close();
  });

  Future<void> prepareJournalEntries(int count) async {
    final random = Random();
    final entries = <JournalEntryModel>[];

    for (var i = 0; i < count; i++) {
      final now = DateTime.now();
      final temporal = TemporalJustificationModel()
        ..transactionDate = now
        ..effectiveDate = now
        ..recordingDate = now;

      final standards = StandardsJustificationModel()
        ..standardReference = 'IAS 1'
        ..recognitionBasis = 'Accrual'
        ..measurementBasis = 'Historical Cost';

      final entry = JournalEntryModel()
        ..id = 'je-$i'
        ..referenceNumber = 'JE-${i.toString().padLeft(5, '0')}'
        ..date = DateTime.now().subtract(Duration(days: random.nextInt(365)))
        ..temporal = temporal
        ..standards = standards
        ..description = 'Benchmark Entry $i'
        ..status = JournalEntryStatus.posted
        ..lines = [
          JournalEntryLineModel()
            ..accountId = 'acc-1101'
            ..accountName = 'Cash'
            ..debit = Decimal.fromInt(1000 + random.nextInt(9000)).toString()
            ..credit = '0',
          JournalEntryLineModel()
            ..accountId = 'acc-4100'
            ..accountName = 'Revenue'
            ..debit = '0'
            ..credit = Decimal.fromInt(1000 + random.nextInt(9000)).toString(),
        ]
        ..sourceDocument = 'benchmark'
        ..sourceId = 'bench-$i'
        ..createdBy = 'benchmark-user'
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now()
        ..userId = 'benchmark-user'
        ..syncStatus = SyncStatus.synced
        ..isDeleted = false;

      entries.add(entry);
    }

    await isar.writeTxn(() async {
      await isar.journalEntryModels.clear();
      await isar.journalEntryModels.putAll(entries);
    });
  }

  group('ForensicAuditService Benchmarks', () {
    test('verifyAllEntriesBalanced - 1k entries', () async {
      await prepareJournalEntries(1000);

      final stopwatch = Stopwatch()..start();
      final entries = await isar.journalEntryModels.where().findAll();
      for (final entry in entries) {
        // Simulate balance check
        final _ = entry.toEntity().isBalanced;
      }
      stopwatch.stop();

      print(
        '\n[BENCHMARK] verifyAllEntriesBalanced (1k): '
        '${stopwatch.elapsedMilliseconds}ms',
      );
      expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // Target: < 1s
    });

    test('verifyAllEntriesBalanced - 10k entries', () async {
      await prepareJournalEntries(10000);

      final stopwatch = Stopwatch()..start();
      final entries = await isar.journalEntryModels.where().findAll();
      for (final entry in entries) {
        final _ = entry.toEntity().isBalanced;
      }
      stopwatch.stop();

      print(
        '\n[BENCHMARK] verifyAllEntriesBalanced (10k): '
        '${stopwatch.elapsedMilliseconds}ms',
      );
      expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Target: < 5s
    });

    test('queryByDateRange - index performance', () async {
      await prepareJournalEntries(5000);

      final startDate = DateTime.now().subtract(const Duration(days: 30));

      final stopwatch = Stopwatch()..start();
      final entries = await isar.journalEntryModels
          .filter()
          .dateGreaterThan(startDate)
          .findAll();
      stopwatch.stop();

      print(
        '\n[BENCHMARK] queryByDateRange (5k, 30d filter): '
        '${stopwatch.elapsedMilliseconds}ms (found: ${entries.length})',
      );
      expect(stopwatch.elapsedMilliseconds, lessThan(500)); // Target: < 500ms
    });

    test('queryByStatus - index performance', () async {
      await prepareJournalEntries(5000);

      final stopwatch = Stopwatch()..start();
      final entries = await isar.journalEntryModels
          .filter()
          .statusEqualTo(JournalEntryStatus.posted)
          .findAll();
      stopwatch.stop();

      print(
        '\n[BENCHMARK] queryByStatus (5k, posted filter): '
        '${stopwatch.elapsedMilliseconds}ms (found: ${entries.length})',
      );
      expect(stopwatch.elapsedMilliseconds, lessThan(500)); // Target: < 500ms
    });
  });
}
