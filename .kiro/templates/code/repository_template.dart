/// Repository template for data access layer
///
/// Usage: Replace [Entity] with your entity name (e.g., Customer, Invoice)
/// 
/// Example:
/// ```dart
/// class CustomerRepository implements CustomerRepositoryInterface {
///   final Isar isar;
///   CustomerRepository(this.isar);
///   // ... implementation
/// }
/// ```

import 'package:isar/isar.dart';

/// Repository interface for [Entity]
abstract class [Entity]RepositoryInterface {
  /// Get all [Entity] items
  Future<List<[Entity]>> getAll();
  
  /// Get [Entity] by ID
  Future<[Entity]?> getById(String id);
  
  /// Add new [Entity]
  Future<void> add([Entity] entity);
  
  /// Update existing [Entity]
  Future<void> update([Entity] entity);
  
  /// Delete [Entity] by ID
  Future<void> delete(String id);
  
  /// Search [Entity] by query
  Future<List<[Entity]>> search(String query);
}

/// Repository implementation for [Entity]
class [Entity]RepositoryImpl implements [Entity]RepositoryInterface {
  final Isar isar;

  [Entity]RepositoryImpl(this.isar);

  @override
  Future<List<[Entity]>> getAll() async {
    try {
      final models = await isar.[entity]Models.where().findAll();
      return models.map((model) => model.toEntity()).toList();
    } catch (error, stackTrace) {
      debugPrint('Error getting all [entity]: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<[Entity]?> getById(String id) async {
    try {
      final model = await isar.[entity]Models
          .filter()
          .idEqualTo(id)
          .findFirst();
      return model?.toEntity();
    } catch (error, stackTrace) {
      debugPrint('Error getting [entity] by id: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> add([Entity] entity) async {
    try {
      await isar.writeTxn(() async {
        await isar.[entity]Models.put(entity.toModel());
      });
    } catch (error, stackTrace) {
      debugPrint('Error adding [entity]: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> update([Entity] entity) async {
    try {
      await isar.writeTxn(() async {
        await isar.[entity]Models.put(entity.toModel());
      });
    } catch (error, stackTrace) {
      debugPrint('Error updating [entity]: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await isar.writeTxn(() async {
        await isar.[entity]Models.delete(id);
      });
    } catch (error, stackTrace) {
      debugPrint('Error deleting [entity]: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<[Entity]>> search(String query) async {
    try {
      final models = await isar.[entity]Models
          .filter()
          .nameContains(query, caseSensitive: false)
          .findAll();
      return models.map((model) => model.toEntity()).toList();
    } catch (error, stackTrace) {
      debugPrint('Error searching [entity]: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }
}
