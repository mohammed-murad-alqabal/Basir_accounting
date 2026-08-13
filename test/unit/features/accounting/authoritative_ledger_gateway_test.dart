import 'package:basir_accounting_system/features/accounting/application/authoritative_ledger_gateway.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('SupabaseLedgerGateway authority contract', () {
    test('derives the same operation UUID for every retry of one local entry',
        () {
      final first = SupabaseLedgerGateway.operationIdFor('local-entry-42');
      final second = SupabaseLedgerGateway.operationIdFor('local-entry-42');
      final other = SupabaseLedgerGateway.operationIdFor('local-entry-43');

      expect(first, equals(second));
      expect(first, isNot(equals(other)));
      expect(Uuid.isValidUUID(fromString: first), isTrue);
    });

    test(
        'retains server UUID account ids and projects legacy local account ids',
        () {
      const serverId = '123e4567-e89b-42d3-a456-426614174000';

      expect(
        SupabaseLedgerGateway.authoritativeAccountIdFor(serverId),
        equals(serverId),
      );
      expect(
        SupabaseLedgerGateway.authoritativeAccountIdFor('acc-4101'),
        equals(SupabaseLedgerGateway.authoritativeAccountIdFor('acc-4101')),
      );
      expect(
        Uuid.isValidUUID(
          fromString:
              SupabaseLedgerGateway.authoritativeAccountIdFor('acc-4101'),
        ),
        isTrue,
      );
    });

    test('parses only a complete authoritative receipt', () {
      final receipt = LedgerPostReceipt.fromJson({
        'entry_id': '00000000-0000-0000-0000-000000000001',
        'entry_hash': 'entry-hash',
        'previous_hash': 'previous-hash',
        'posted_at': '2026-01-10T09:00:00.000Z',
        'idempotent_replay': true,
      });

      expect(receipt.entryHash, equals('entry-hash'));
      expect(receipt.previousHash, equals('previous-hash'));
      expect(receipt.idempotentReplay, isTrue);
      expect(receipt.postedAt, equals(DateTime.utc(2026, 1, 10, 9)));
    });

    test('rejects an incomplete receipt before cache can be updated', () {
      expect(
        () => LedgerPostReceipt.fromJson({
          'entry_id': '00000000-0000-0000-0000-000000000001',
          'posted_at': '2026-01-10T09:00:00.000Z',
        }),
        throwsFormatException,
      );
    });
  });
}
