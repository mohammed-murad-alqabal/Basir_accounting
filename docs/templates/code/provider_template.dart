/// Riverpod provider template
///
/// Usage: Replace [Entity] with your entity name
/// 
/// Example:
/// ```dart
/// @riverpod
/// class CustomersNotifier extends _$CustomersNotifier {
///   // ... implementation
/// }
/// ```

import 'package:riverpod_annotation/riverpod_annotation.dart';

part '[entity]_provider.g.dart';

/// Provider for [Entity] repository
@riverpod
[Entity]Repository [entity]Repository([Entity]RepositoryRef ref) {
  final isar = ref.watch(isarProvider);
  return [Entity]RepositoryImpl(isar);
}

/// State notifier for [Entity] list
@riverpod
class [Entity]sNotifier extends _$[Entity]sNotifier {
  @override
  Future<List<[Entity]>> build() async {
    final repository = ref.watch([entity]RepositoryProvider);
    return repository.getAll();
  }

  Future<void> add([Entity] entity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read([entity]RepositoryProvider);
      await repository.add(entity);
      return repository.getAll();
    });
  }

  Future<void> update([Entity] entity) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read([entity]RepositoryProvider);
      await repository.update(entity);
      return repository.getAll();
    });
  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read([entity]RepositoryProvider);
      await repository.delete(id);
      return repository.getAll();
    });
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read([entity]RepositoryProvider);
      return repository.search(query);
    });
  }
}
