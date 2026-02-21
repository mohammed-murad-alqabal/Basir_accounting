import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journal_entry_providers.g.dart';

/// Provides a list of journal entries filtered by a specific account ID.
///
/// This supports the "Drill-Down" feature where users can click on a line
/// in the Balance Sheet or Income Statement to see the underlying transactions.
@riverpod
Future<List<JournalEntry>> filteredJournalEntries(
  FilteredJournalEntriesRef ref, {
  String? accountId,
}) async {
  final entries = await ref.watch(accountingServiceProvider.future);
  if (accountId == null) return entries;

  return entries
      .where((entry) => entry.lines.any((line) => line.accountId == accountId))
      .toList();
}

/// Provides journal entries filtered by a sub-ledger entity (Customer/Supplier).
@riverpod
Future<List<JournalEntry>> subLedgerJournalEntries(
  SubLedgerJournalEntriesRef ref, {
  required String entityId,
  required bool isCustomer,
}) async {
  final entries = await ref.watch(accountingServiceProvider.future);
  final customerRepo = ref.read(customerRepositoryProvider);
  final vendorRepo = ref.read(vendorRepositoryProvider);

  String? targetAccountId;
  if (isCustomer) {
    final customer = await customerRepo.getCustomerById(entityId);
    targetAccountId = customer?.receivableAccountId ?? 'acc-1201';
  } else {
    final vendor = await vendorRepo.getVendorById(entityId);
    targetAccountId = vendor?.payableAccountId ?? 'acc-2101';
  }

  return entries
      .where(
        (entry) => entry.lines.any(
          (line) =>
              line.accountId == targetAccountId ||
              (targetAccountId == 'acc-1201' &&
                  line.accountName.contains(entityId)) ||
              (targetAccountId == 'acc-2101' &&
                  line.accountName.contains(entityId)),
        ),
      )
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
}
