import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileStore', () {
    late BasirDatabase database;
    late ProfileStore store;

    setUp(() {
      database = BasirDatabase(NativeDatabase.memory());
      store = ProfileStore(database);
    });

    tearDown(() => database.close());

    test('isolates users and replaces only the matching user profile',
        () async {
      await store.save(_profile(id: 'profile-a1', userId: 'user-a'));
      await store.save(_profile(id: 'profile-b1', userId: 'user-b'));
      await store.save(_profile(id: 'profile-a2', userId: 'user-a'));

      expect((await store.readForUser('user-a'))?.id, 'profile-a2');
      expect((await store.readForUser('user-b'))?.id, 'profile-b1');
      expect(await database.select(database.profiles).get(), hasLength(2));
    });

    test('keeps anonymous and named user scopes distinct', () async {
      await store.save(_profile(id: 'profile-anonymous', userId: null));
      await store.save(_profile(id: 'profile-named', userId: 'anonymous'));

      expect((await store.readForUser(null))?.id, 'profile-anonymous');
      expect((await store.readForUser('anonymous'))?.id, 'profile-named');
    });

    test('deletes only the requested user profile', () async {
      await store.save(_profile(id: 'profile-a', userId: 'user-a'));
      await store.save(_profile(id: 'profile-b', userId: 'user-b'));

      await store.deleteForUser('user-a');

      expect(await store.readForUser('user-a'), isNull);
      expect((await store.readForUser('user-b'))?.id, 'profile-b');
    });
  });

  group('BusinessSettingsStore', () {
    late BasirDatabase database;
    late BusinessSettingsStore store;

    setUp(() {
      database = BasirDatabase(NativeDatabase.memory());
      store = BusinessSettingsStore(database);
    });

    tearDown(() => database.close());

    test('isolates users and upserts one settings record per user', () async {
      await store.save(_settings(id: 'settings-a1', userId: 'user-a'));
      await store.save(_settings(id: 'settings-b1', userId: 'user-b'));
      await store.save(
        _settings(
          id: 'settings-a2',
          userId: 'user-a',
          companyName: 'Updated company',
        ),
      );

      final userA = await store.readForUser('user-a');
      final userB = await store.readForUser('user-b');

      expect(userA?.id, 'settings-a2');
      expect(userA?.companyName, 'Updated company');
      expect(userB?.id, 'settings-b1');
      expect(
        await database.select(database.businessSettings).get(),
        hasLength(2),
      );
    });

    test('preserves nullable sync metadata and soft delete state', () async {
      await store.save(
        _settings(
          id: 'settings-a',
          userId: 'user-a',
          syncStatus: 'pendingPush',
          isDeleted: true,
        ),
      );

      final stored = await store.readForUser('user-a');

      expect(stored?.syncStatus, 'pendingPush');
      expect(stored?.serverUpdatedAt, isNull);
      expect(stored?.isDeleted, isTrue);
    });
  });
}

ProfileRecord _profile({required String id, required String? userId}) =>
    ProfileRecord(
      id: id,
      email: '$id@example.test',
      displayName: id,
      avatarUrl: null,
      phoneNumber: null,
      userId: userId,
      syncStatus: 'synced',
      serverUpdatedAt: DateTime.utc(2026, 8, 14),
      isDeleted: false,
    );

BusinessSettingsRecord _settings({
  required String id,
  required String? userId,
  String companyName = 'Basir Test',
  String syncStatus = 'synced',
  DateTime? serverUpdatedAt,
  bool isDeleted = false,
}) =>
    BusinessSettingsRecord(
      id: id,
      companyName: companyName,
      taxNumber: null,
      address: null,
      logoUrl: null,
      defaultTaxRate: 15,
      currencyCode: 'SAR',
      currencySymbol: 'ر.س',
      userId: userId,
      syncStatus: syncStatus,
      serverUpdatedAt: serverUpdatedAt,
      isDeleted: isDeleted,
    );
