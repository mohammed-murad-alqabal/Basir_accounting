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
