import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/accounting/application/ledger_outbox_service.dart';
import 'package:basir_accounting_system/features/accounting/application/authoritative_ledger_gateway.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of AccountingRepository for testing.
class MockAccountingRepository extends Mock implements AccountingRepository {}

/// Deterministic server receipt for tests that exercise the authoritative
/// posting boundary without a live Supabase/Postgres service.
class TestAuthoritativeLedgerGateway implements AuthoritativeLedgerGateway {
  const TestAuthoritativeLedgerGateway();

  @override
  Future<LedgerPostReceipt> post(JournalEntry entry) async => LedgerPostReceipt(
    entryId: SupabaseLedgerGateway.operationIdFor(entry.id),
    entryHash: 'test-entry-hash-${entry.id}',
    previousHash: null,
    postedAt: DateTime.utc(2025),
    idempotentReplay: false,
  );
}

/// Deterministic posting-port double for service tests that must not open Isar.
class TestLedgerPostingService implements LedgerPostingService {
  TestLedgerPostingService({required this.gateway, required this.repository});

  final AuthoritativeLedgerGateway gateway;
  final AccountingRepository repository;
  final postedEntries = <JournalEntry>[];

  @override
  Future<void> postOrEnqueue(JournalEntry entry) async {
    final receipt = await gateway.post(entry);
    final confirmedEntry = entry.copyWith(
      authoritativeEntryId: receipt.entryId,
      hash: receipt.entryHash,
      previousHash: receipt.previousHash,
      postedAt: receipt.postedAt,
      updatedAt: receipt.postedAt,
      serverUpdatedAt: receipt.postedAt,
      syncStatus: SyncStatus.synced,
      status: JournalEntryStatus.posted,
    );
    await repository.cacheAuthoritativeJournalEntry(confirmedEntry);
    postedEntries.add(confirmedEntry);
  }
}

/// Fake Account for registerFallbackValue.
class FakeAccount extends Fake implements Account {}

/// Fake JournalEntry for registerFallbackValue.
class FakeJournalEntry extends Fake implements JournalEntry {}

/// Setup function to register fallback values.
void setUpAccountingMocks() {
  registerFallbackValue(FakeAccount());
  registerFallbackValue(FakeJournalEntry());
  registerFallbackValue(DateTime.now());
}
