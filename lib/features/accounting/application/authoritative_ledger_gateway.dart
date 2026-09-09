import 'package:basir_accounting_system/core/config/supabase_config.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Transport failed before an authoritative Postgres receipt was received.
///
/// It intentionally excludes [PostgrestException], which represents a server
/// validation or authorization response and must not be retried blindly.
class LedgerTransportException implements Exception {
  const LedgerTransportException(this.cause);

  final Object cause;

  @override
  String toString() => 'LEDGER_TRANSPORT_FAILURE: $cause';
}

/// Receipt returned only after the authoritative Postgres transaction commits.
class LedgerPostReceipt {
  const LedgerPostReceipt({
    required this.entryId,
    required this.entryHash,
    required this.previousHash,
    required this.postedAt,
    required this.idempotentReplay,
  });

  factory LedgerPostReceipt.fromJson(Map<String, dynamic> json) {
    final postedAt = json['posted_at'];
    if (postedAt is! String) {
      throw const FormatException('Ledger receipt is missing posted_at');
    }

    return LedgerPostReceipt(
      entryId: _requiredString(json, 'entry_id'),
      entryHash: _requiredString(json, 'entry_hash'),
      previousHash: json['previous_hash'] as String?,
      postedAt: DateTime.parse(postedAt).toUtc(),
      idempotentReplay: json['idempotent_replay'] == true,
    );
  }

  final String entryId;
  final String entryHash;
  final String? previousHash;
  final DateTime postedAt;
  final bool idempotentReplay;

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.isEmpty) {
      throw FormatException('Ledger receipt is missing $key');
    }
    return value;
  }
}

/// Boundary for committing a final ledger fact.
///
/// Implementations must never expose a Postgres connection string to Flutter.
// ignore: one_member_abstracts
abstract class AuthoritativeLedgerGateway {
  Future<LedgerPostReceipt> post(JournalEntry entry);
}

/// Posts an accounting command through a protected Supabase/Postgres RPC.
///
/// The operation UUID is name-based and stable across retries. It is also used
/// as the authoritative entry UUID, allowing the database to enforce
/// idempotency with its primary key plus an immutable payload hash.
class SupabaseLedgerGateway implements AuthoritativeLedgerGateway {
  SupabaseLedgerGateway(this._client);

  final SupabaseClient _client;
  static const _uuidNamespace = '6ba7b811-9dad-11d1-80b4-00c04fd430c8';

  /// Maps a local journal identifier to its permanent authoritative UUID.
  static String operationIdFor(String localJournalEntryId) => const Uuid()
      .v5(_uuidNamespace, 'basir/ledger-entry/v1/$localJournalEntryId');

  /// Maps a local account identifier into the server namespace.
  ///
  /// Existing UUIDs are retained. Non-UUID local identifiers are deterministic
  /// projections and must be seeded into Postgres before a journal is posted.
  static String authoritativeAccountIdFor(String localAccountId) {
    if (Uuid.isValidUUID(fromString: localAccountId)) return localAccountId;
    return const Uuid().v5(_uuidNamespace, 'basir/account/v1/$localAccountId');
  }

  @override
  Future<LedgerPostReceipt> post(JournalEntry entry) async {
    final entryId = operationIdFor(entry.id);
    late Map<String, dynamic> response;
    try {
      response = await _client.rpc<Map<String, dynamic>>(
        'post_ledger_entry',
        params: {
          'p_entry_id': entryId,
          'p_entry_number': entry.referenceNumber,
          'p_transaction_date':
              entry.temporal.transactionDate.toUtc().toIso8601String(),
          'p_effective_date':
              entry.temporal.effectiveDate.toUtc().toIso8601String(),
          'p_standard_reference': entry.standards.standardReference,
          'p_description': entry.description,
          'p_source_document': entry.sourceDocument,
          'p_source_id': entry.sourceId,
          'p_lines': entry.lines
              .map(
                (line) => <String, dynamic>{
                  'account_id': authoritativeAccountIdFor(line.accountId),
                  'description': line.description ?? entry.description,
                  'debit': line.debit.toString(),
                  'credit': line.credit.toString(),
                  'source_document_ref': line.sourceDocumentRef,
                  'original_currency': line.originalCurrency,
                  'exchange_rate': line.exchangeRate?.toString(),
                  'original_amount': line.originalAmount?.toString(),
                },
              )
              .toList(growable: false),
        },
      );
    } on PostgrestException {
      rethrow;
    } catch (error) {
      throw LedgerTransportException(error);
    }

    return LedgerPostReceipt.fromJson(response);
  }
}

final authoritativeLedgerGatewayProvider = Provider<AuthoritativeLedgerGateway>(
  (ref) => SupabaseLedgerGateway(SupabaseConfig.client),
);
