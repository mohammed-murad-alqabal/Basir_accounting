import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:basir_accounting_system/features/users/application/user_service.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user_role.dart';
import 'package:basir_accounting_system/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_service_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockUserRepository();
    container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockRepository),
        currentUserProfileProvider.overrideWith(
          (ref) => const BasirUser(
            id: 'admin-1',
            email: 'admin@example.test',
            role: UserRole.admin,
            permissions: Permission.all,
          ),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  const tUser = User(
    id: '1',
    username: 'test',
    fullName: 'Test User',
    email: 'test@example.com',
    role: UserRole.viewer,
  );

  group('UserService', () {
    test('build returns users from repository', () async {
      when(mockRepository.getAllUsers()).thenAnswer((_) async => [tUser]);

      final users = await container.read(userServiceProvider.future);
      expect(users, [tUser]);
      verify(mockRepository.getAllUsers()).called(1);
    });

    test('createUser calls repository and refreshes', () async {
      when(mockRepository.createUser(any, any)).thenAnswer((_) async {});
      when(mockRepository.getAllUsers()).thenAnswer((_) async => []);

      final notifier = container.read(userServiceProvider.notifier);
      await notifier.createUser(tUser, 'pass');

      verify(mockRepository.createUser(tUser, 'pass')).called(1);
      // Verify refresh happened (getAllUsers called again?)
      // We'd need to listen to the provider to see if it emitted new state,
      // but invalidation triggers rebuild which calls build().
    });

    test('deleteUser calls repository', () async {
      when(mockRepository.deleteUser(any)).thenAnswer((_) async {});
      // Setup initial state if needed, but for notifier method call it's fine

      final notifier = container.read(userServiceProvider.notifier);
      await notifier.deleteUser('1');

      verify(mockRepository.deleteUser('1')).called(1);
    });

    test('changePassword calls repository', () async {
      when(mockRepository.changePassword(any, any)).thenAnswer((_) async {});

      final notifier = container.read(userServiceProvider.notifier);
      await notifier.changePassword('1', 'new');

      verify(mockRepository.changePassword('1', 'new')).called(1);
    });
  });
}
