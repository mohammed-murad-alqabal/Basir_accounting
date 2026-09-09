import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';

/// Enforces the single-authority contract for the general ledger.
///
/// A device may create and retain drafts, but it must never create a final
/// `Posted` fact locally. Final entries are cached only after Postgres has
/// committed the entry and returned its immutable receipt fields.
abstract final class LedgerAuthorityPolicy {
  /// Rejects the former local posting path.
  static void assertLocalWriteAllowed(JournalEntry entry) {
    if (entry.status == JournalEntryStatus.posted) {
      throw StateError(
        'LOCAL_POSTED_LEDGER_WRITE_FORBIDDEN: post through the authoritative '
        'ledger gateway and cache only the returned server receipt.',
      );
    }
  }

  /// Verifies that a local `Posted` record is a server-confirmed cache entry.
  static void assertAuthoritativeCache(JournalEntry entry) {
    if (entry.status != JournalEntryStatus.posted) {
      throw StateError(
        'AUTHORITATIVE_CACHE_REQUIRES_POSTED_ENTRY',
      );
    }
    if (entry.authoritativeEntryId == null ||
        entry.authoritativeEntryId!.isEmpty ||
        entry.hash == null ||
        entry.hash!.isEmpty ||
        entry.postedAt == null) {
      throw StateError(
        'AUTHORITATIVE_RECEIPT_REQUIRED_FOR_POSTED_CACHE',
      );
    }
  }
}
