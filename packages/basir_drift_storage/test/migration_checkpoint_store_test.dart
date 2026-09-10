import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalMetadataMigrationCheckpointStore', () {
    late BasirDatabase database;
    late LocalMetadataMigrationCheckpointStore store;

    setUp(() {
      database = BasirDatabase(NativeDatabase.memory());
      store = LocalMetadataMigrationCheckpointStore(database);
    });

    tearDown(() => database.close());

    test('persists and reads a completed checkpoint', () async {
      final checkpoint = MigrationCheckpoint(
        slice: 'market-prices-v1',
        sourceCount: 3,
        migratedCount: 3,
        completedAt: DateTime.utc(2026, 8, 14, 12),
      );

      await store.save(checkpoint);
      final restored = await store.read('market-prices-v1');

      expect(restored, isNotNull);
      expect(restored!.slice, checkpoint.slice);
      expect(restored.sourceCount, checkpoint.sourceCount);
      expect(restored.migratedCount, checkpoint.migratedCount);
      expect(restored.completedAt, checkpoint.completedAt);
      expect(restored.isComplete, isTrue);
    });

    test('updates the checkpoint for the same migration slice', () async {
      await store.save(
        const MigrationCheckpoint(
          slice: 'market-prices-v1',
          sourceCount: 5,
          migratedCount: 2,
          completedAt: null,
        ),
      );
      await store.save(
        MigrationCheckpoint(
          slice: 'market-prices-v1',
          sourceCount: 5,
          migratedCount: 5,
          completedAt: DateTime.utc(2026, 8, 14, 12),
        ),
      );

      final restored = await store.read('market-prices-v1');

      expect(restored!.migratedCount, 5);
      expect(restored.isComplete, isTrue);
    });
  });
}
