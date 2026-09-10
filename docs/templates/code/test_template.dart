/// Unit test template
///
/// Usage: Replace [Entity] with your entity name
/// 
/// Example:
/// ```dart
/// void main() {
///   group('CustomerRepository', () {
///     // ... tests
///   });
/// }
/// ```

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  group('[Entity]Repository', () {
    late Isar isar;
    late [Entity]Repository repository;

    setUp(() async {
      // Setup before each test
      isar = await Isar.open(
        [[Entity]ModelSchema],
        directory: '',
        name: 'test_${DateTime.now().millisecondsSinceEpoch}',
      );
      repository = [Entity]RepositoryImpl(isar);
    });

    tearDown(() async {
      // Cleanup after each test
      await isar.close(deleteFromDisk: true);
    });

    group('getAll', () {
      test('should return empty list when no items', () async {
        // Act
        final result = await repository.getAll();

        // Assert
        expect(result, isEmpty);
      });

      test('should return all items', () async {
        // Arrange
        final entity = [Entity](id: '1', name: 'Test');
        await repository.add(entity);

        // Act
        final result = await repository.getAll();

        // Assert
        expect(result.length, 1);
        expect(result.first.name, 'Test');
      });
    });

    group('add', () {
      test('should add item successfully', () async {
        // Arrange
        final entity = [Entity](id: '1', name: 'Test');

        // Act
        await repository.add(entity);
        final result = await repository.getAll();

        // Assert
        expect(result.length, 1);
        expect(result.first.name, 'Test');
      });

      test('should throw exception for invalid data', () async {
        // Arrange
        final entity = [Entity](id: '1', name: '');

        // Act & Assert
        expect(
          () => repository.add(entity),
          throwsA(isA<ValidationException>()),
        );
      });
    });
  });
}
