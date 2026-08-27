import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftStorageContract', () {
    test('uses stable anonymous and user scope keys', () {
      expect(DriftStorageContract.scopeKeyForUser(null), 'anonymous');
      expect(DriftStorageContract.scopeKeyForUser('u-1'), 'user:u-1');
    });

    test('builds a deterministic compound identity', () {
      final identity = DriftScopedIdentity.forUser(
        userId: 'u-1',
        recordId: 'record-7',
      );

      expect(identity.scopeKey, 'user:u-1');
      expect(identity.recordId, 'record-7');
      expect(identity.canonicalKey, 'user:u-1\u001frecord-7');
      expect(() => identity.validate(), returnsNormally);
    });

    test('rejects empty record identity', () {
      final identity = DriftScopedIdentity.forUser(
        userId: null,
        recordId: '',
      );

      expect(identity.validate, throwsArgumentError);
    });

    test('round-trips all legal sync status values', () {
      for (final status in DriftSyncStatusValue.values) {
        expect(
          DriftSyncStatusValue.parse(status.storageValue),
          status,
        );
      }
    });

    test('rejects unknown sync status values', () {
      expect(
        () => DriftSyncStatusValue.parse('unknown'),
        throwsFormatException,
      );
    });

    test('normalizes metadata to UTC without changing status', () {
      final local = DateTime(2026, 8, 23, 15, 30);
      final server = DateTime(2026, 8, 23, 12, 30);
      final normalized = DriftSyncMetadata(
        updatedAt: local,
        serverUpdatedAt: server,
        syncStatus: DriftSyncStatusValue.pendingPush,
      ).toUtc();

      expect(normalized.updatedAt.isUtc, isTrue);
      expect(normalized.serverUpdatedAt?.isUtc, isTrue);
      expect(normalized.syncStatus, DriftSyncStatusValue.pendingPush);
      expect(() => normalized.validate(), returnsNormally);
    });

    test('rejects non-UTC metadata at the storage boundary', () {
      final metadata = DriftSyncMetadata(
        updatedAt: DateTime(2026, 8, 23),
        syncStatus: DriftSyncStatusValue.synced,
      );

      expect(metadata.validate, throwsArgumentError);
    });
  });
}
