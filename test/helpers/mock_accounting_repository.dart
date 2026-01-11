import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of AccountingRepository for testing.
class MockAccountingRepository extends Mock implements AccountingRepository {}

/// Fake Account for registerFallbackValue.
class FakeAccount extends Fake implements Account {}

/// Fake JournalEntry for registerFallbackValue.
class FakeJournalEntry extends Fake implements JournalEntry {}

/// Setup function to register fallback values.
void setUpAccountingMocks() {
  registerFallbackValue(FakeAccount());
  registerFallbackValue(FakeJournalEntry());
}
