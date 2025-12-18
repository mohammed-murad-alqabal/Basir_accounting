/// Repository Test Template - ${REPOSITORY_NAME}
/// 
/// المشروع: بصير MVP
/// المؤلف: فريق وكلاء تطوير مشروع بصير
/// 
/// يختبر: ${REPOSITORY_NAME} Repository
/// 
/// هذا القالب يوفر هيكل موحد لاختبارات الـ repositories مع:
/// - اختبار Clean Architecture patterns
/// - اختبار Either<Failure, Success> results
/// - اختبار Isar database operations
/// - معالجة الأخطاء والحالات الاستثنائية

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';

// Import the repository under test
// import 'package:basser_app/features/${FEATURE_NAME}/domain/repositories/${REPOSITORY_NAME}.dart';
// import 'package:basser_app/features/${FEATURE_NAME}/data/repositories/${REPOSITORY_NAME}_impl.dart';
// import 'package:basser_app/features/${FEATURE_NAME}/data/datasources/${DATASOURCE_NAME}.dart';
// import 'package:basser_app/features/${FEATURE_NAME}/data/models/${MODEL_NAME}.dart';
// import 'package:basser_app/features/${FEATURE_NAME}/domain/entities/${ENTITY_NAME}.dart';

// Import test helpers
import '../../helpers/test_helpers.dart';

// Generate mocks
@GenerateMocks([${DATASOURCE_NAME}])
import '${REPOSITORY_NAME}_test.mocks.dart';

void main() {
  group('${REPOSITORY_NAME} Tests', () {
    late ${REPOSITORY_NAME}Impl repository;
    late Mock${DATASOURCE_NAME} mockDataSource;
    late Isar isar;

    setUpAll(() async {
      // إنشاء Isar instance للاختبارات
      isar = await TestHelpers.createTestIsar();
    });

    setUp(() {
      // إنشاء mock datasource
      mockDataSource = Mock${DATASOURCE_NAME}();
      
      // إنشاء repository instance
      repository = ${REPOSITORY_NAME}Impl(
        localDataSource: mockDataSource,
      );
    });

    tearDown(() async {
      // تنظيف البيانات بين الاختبارات
      await isar.writeTxn(() async {
        await isar.${MODEL_NAME_PLURAL}.clear();
      });
      reset(mockDataSource);
    });

    tearDownAll(() async {
      // تنظيف Isar instance
      await TestHelpers.cleanupTestIsar(isar);
    });

    group('${GET_ALL_METHOD} Method', () {
      test('should return Right with list of entities when successful', () async {
        // Arrange
        final testModels = [
          ${MODEL_NAME}(
            id: '1',
            ${MODEL_PROPERTIES}
          ),
          ${MODEL_NAME}(
            id: '2',
            ${MODEL_PROPERTIES_2}
          ),
        ];
        
        when(mockDataSource.${GET_ALL_METHOD}())
            .thenAnswer((_) async => testModels);

        // Act
        final result = await repository.${GET_ALL_METHOD}();

        // Assert
        expect(result, isA<Right<Failure, List<${ENTITY_NAME}>>>());
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (entities) {
            expect(entities.length, equals(2));
            expect(entities[0].id, equals('1'));
            expect(entities[1].id, equals('2'));
          },
        );
        verify(mockDataSource.${GET_ALL_METHOD}()).called(1);
      });

      test('should return Left with LocalFailure when datasource throws exception', () async {
        // Arrange
        const errorMessage = 'Database connection failed';
        when(mockDataSource.${GET_ALL_METHOD}())
            .thenThrow(Exception(errorMessage));

        // Act
        final result = await repository.${GET_ALL_METHOD}();

        // Assert
        expect(result, isA<Left<Failure, List<${ENTITY_NAME}>>>());
        result.fold(
          (failure) {
            expect(failure, isA<LocalFailure>());
            expect(failure.message, contains(errorMessage));
          },
          (entities) => fail('Expected Left but got Right: $entities'),
        );
        verify(mockDataSource.${GET_ALL_METHOD}()).called(1);
      });

      test('should return empty list when no data exists', () async {
        // Arrange
        when(mockDataSource.${GET_ALL_METHOD}())
            .thenAnswer((_) async => <${MODEL_NAME}>[]);

        // Act
        final result = await repository.${GET_ALL_METHOD}();

        // Assert
        expect(result, isA<Right<Failure, List<${ENTITY_NAME}>>>());
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (entities) => expect(entities, isEmpty),
        );
      });
    });

    group('${GET_BY_ID_METHOD} Method', () {
      test('should return Right with entity when found', () async {
        // Arrange
        const testId = 'test-id';
        final testModel = ${MODEL_NAME}(
          id: testId,
          ${MODEL_PROPERTIES}
        );
        
        when(mockDataSource.${GET_BY_ID_METHOD}(testId))
            .thenAnswer((_) async => testModel);

        // Act
        final result = await repository.${GET_BY_ID_METHOD}(testId);

        // Assert
        expect(result, isA<Right<Failure, ${ENTITY_NAME}>>());
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (entity) {
            expect(entity.id, equals(testId));
            expect(entity.${ENTITY_PROPERTY}, equals(${EXPECTED_VALUE}));
          },
        );
        verify(mockDataSource.${GET_BY_ID_METHOD}(testId)).called(1);
      });

      test('should return Left with NotFoundFailure when entity not found', () async {
        // Arrange
        const testId = 'non-existent-id';
        when(mockDataSource.${GET_BY_ID_METHOD}(testId))
            .thenThrow(NotFoundException('${ENTITY_NAME} not found'));

        // Act
        final result = await repository.${GET_BY_ID_METHOD}(testId);

        // Assert
        expect(result, isA<Left<Failure, ${ENTITY_NAME}>>());
        result.fold(
          (failure) {
            expect(failure, isA<NotFoundFailure>());
            expect(failure.message, contains('not found'));
          },
          (entity) => fail('Expected Left but got Right: $entity'),
        );
      });

      test('should validate input parameters', () async {
        // Arrange & Act & Assert
        expect(
          () => repository.${GET_BY_ID_METHOD}(''),
          throwsA(isA<ArgumentError>()),
        );
        
        expect(
          () => repository.${GET_BY_ID_METHOD}(null),
          throwsA(isA<ArgumentError>()),
        );
        
        verifyNever(mockDataSource.${GET_BY_ID_METHOD}(any));
      });
    });

    group('${ADD_METHOD} Method', () {
      test('should return Right with created entity when successful', () async {
        // Arrange
        final testEntity = ${ENTITY_NAME}(
          id: 'new-id',
          ${ENTITY_PROPERTIES}
        );
        
        final expectedModel = ${MODEL_NAME}(
          id: 'new-id',
          ${MODEL_PROPERTIES}
        );
        
        when(mockDataSource.${ADD_METHOD}(any))
            .thenAnswer((_) async => expectedModel);

        // Act
        final result = await repository.${ADD_METHOD}(testEntity);

        // Assert
        expect(result, isA<Right<Failure, ${ENTITY_NAME}>>());
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (entity) {
            expect(entity.id, equals('new-id'));
            expect(entity.${ENTITY_PROPERTY}, equals(${EXPECTED_VALUE}));
          },
        );
        verify(mockDataSource.${ADD_METHOD}(any)).called(1);
      });

      test('should return Left with ValidationFailure for invalid entity', () async {
        // Arrange
        final invalidEntity = ${ENTITY_NAME}(
          id: '',
          ${INVALID_ENTITY_PROPERTIES}
        );

        // Act
        final result = await repository.${ADD_METHOD}(invalidEntity);

        // Assert
        expect(result, isA<Left<Failure, ${ENTITY_NAME}>>());
        result.fold(
          (failure) {
            expect(failure, isA<ValidationFailure>());
            expect(failure.message, contains('validation'));
          },
          (entity) => fail('Expected Left but got Right: $entity'),
        );
        verifyNever(mockDataSource.${ADD_METHOD}(any));
      });

      test('should handle duplicate key errors', () async {
        // Arrange
        final testEntity = ${ENTITY_NAME}(
          id: 'duplicate-id',
          ${ENTITY_PROPERTIES}
        );
        
        when(mockDataSource.${ADD_METHOD}(any))
            .thenThrow(DuplicateKeyException('Entity already exists'));

        // Act
        final result = await repository.${ADD_METHOD}(testEntity);

        // Assert
        expect(result, isA<Left<Failure, ${ENTITY_NAME}>>());
        result.fold(
          (failure) {
            expect(failure, isA<ConflictFailure>());
            expect(failure.message, contains('already exists'));
          },
          (entity) => fail('Expected Left but got Right: $entity'),
        );
      });
    });

    group('${UPDATE_METHOD} Method', () {
      test('should return Right with updated entity when successful', () async {
        // Arrange
        final testEntity = ${ENTITY_NAME}(
          id: 'existing-id',
          ${UPDATED_ENTITY_PROPERTIES}
        );
        
        final updatedModel = ${MODEL_NAME}(
          id: 'existing-id',
          ${UPDATED_MODEL_PROPERTIES}
        );
        
        when(mockDataSource.${UPDATE_METHOD}(any))
            .thenAnswer((_) async => updatedModel);

        // Act
        final result = await repository.${UPDATE_METHOD}(testEntity);

        // Assert
        expect(result, isA<Right<Failure, ${ENTITY_NAME}>>());
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (entity) {
            expect(entity.id, equals('existing-id'));
            expect(entity.${ENTITY_PROPERTY}, equals(${UPDATED_VALUE}));
          },
        );
        verify(mockDataSource.${UPDATE_METHOD}(any)).called(1);
      });

      test('should return Left with NotFoundFailure when entity does not exist', () async {
        // Arrange
        final testEntity = ${ENTITY_NAME}(
          id: 'non-existent-id',
          ${ENTITY_PROPERTIES}
        );
        
        when(mockDataSource.${UPDATE_METHOD}(any))
            .thenThrow(NotFoundException('Entity not found'));

        // Act
        final result = await repository.${UPDATE_METHOD}(testEntity);

        // Assert
        expect(result, isA<Left<Failure, ${ENTITY_NAME}>>());
        result.fold(
          (failure) {
            expect(failure, isA<NotFoundFailure>());
            expect(failure.message, contains('not found'));
          },
          (entity) => fail('Expected Left but got Right: $entity'),
        );
      });
    });

    group('${DELETE_METHOD} Method', () {
      test('should return Right when deletion is successful', () async {
        // Arrange
        const testId = 'existing-id';
        when(mockDataSource.${DELETE_METHOD}(testId))
            .thenAnswer((_) async => {});

        // Act
        final result = await repository.${DELETE_METHOD}(testId);

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (_) => {}, // Success
        );
        verify(mockDataSource.${DELETE_METHOD}(testId)).called(1);
      });

      test('should return Left with NotFoundFailure when entity does not exist', () async {
        // Arrange
        const testId = 'non-existent-id';
        when(mockDataSource.${DELETE_METHOD}(testId))
            .thenThrow(NotFoundException('Entity not found'));

        // Act
        final result = await repository.${DELETE_METHOD}(testId);

        // Assert
        expect(result, isA<Left<Failure, void>>());
        result.fold(
          (failure) {
            expect(failure, isA<NotFoundFailure>());
            expect(failure.message, contains('not found'));
          },
          (_) => fail('Expected Left but got Right'),
        );
      });
    });

    group('Performance Tests', () {
      test('should handle large datasets efficiently', () async {
        // Arrange
        final largeDataset = List.generate(1000, (index) => ${MODEL_NAME}(
          id: 'id_$index',
          ${MODEL_PROPERTIES_GENERATED}
        ));
        
        when(mockDataSource.${GET_ALL_METHOD}())
            .thenAnswer((_) async => largeDataset);

        // Act
        final stopwatch = Stopwatch()..start();
        final result = await repository.${GET_ALL_METHOD}();
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // < 1 second
        expect(result, isA<Right<Failure, List<${ENTITY_NAME}>>>());
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (entities) => expect(entities.length, equals(1000)),
        );
      });

      test('should handle concurrent operations', () async {
        // Arrange
        final testEntities = List.generate(10, (index) => ${ENTITY_NAME}(
          id: 'concurrent_$index',
          ${ENTITY_PROPERTIES_GENERATED}
        ));
        
        when(mockDataSource.${ADD_METHOD}(any))
            .thenAnswer((_) async => ${MODEL_NAME}(
              id: 'added',
              ${MODEL_PROPERTIES}
            ));

        // Act
        final futures = testEntities.map((entity) => repository.${ADD_METHOD}(entity));
        final results = await Future.wait(futures);

        // Assert
        expect(results.length, equals(10));
        expect(results.every((result) => result.isRight()), isTrue);
        verify(mockDataSource.${ADD_METHOD}(any)).called(10);
      });
    });

    group('Edge Cases', () {
      test('should handle null responses from datasource', () async {
        // Arrange
        when(mockDataSource.${GET_ALL_METHOD}())
            .thenAnswer((_) async => null);

        // Act
        final result = await repository.${GET_ALL_METHOD}();

        // Assert
        expect(result, isA<Right<Failure, List<${ENTITY_NAME}>>>());
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (entities) => expect(entities, isEmpty),
        );
      });

      test('should handle malformed data from datasource', () async {
        // Arrange
        when(mockDataSource.${GET_ALL_METHOD}())
            .thenThrow(FormatException('Invalid data format'));

        // Act
        final result = await repository.${GET_ALL_METHOD}();

        // Assert
        expect(result, isA<Left<Failure, List<${ENTITY_NAME}>>>());
        result.fold(
          (failure) {
            expect(failure, isA<DataFormatFailure>());
            expect(failure.message, contains('Invalid data format'));
          },
          (entities) => fail('Expected Left but got Right: $entities'),
        );
      });
    });
  });
}

// ═══════════════════════════════════════════════════════════════════════════════════
// Template Variables (replace when using this template):
// ═══════════════════════════════════════════════════════════════════════════════════
// 
// ${REPOSITORY_NAME} - اسم الـ Repository (مثل: CustomerRepository)
// ${FEATURE_NAME} - اسم الميزة (مثل: customers)
// ${DATASOURCE_NAME} - اسم الـ DataSource (مثل: CustomerLocalDataSource)
// ${MODEL_NAME} - اسم الـ Model (مثل: CustomerModel)
// ${MODEL_NAME_PLURAL} - جمع اسم الـ Model (مثل: customerModels)
// ${ENTITY_NAME} - اسم الـ Entity (مثل: Customer)
// ${GET_ALL_METHOD} - دالة الحصول على الكل (مثل: getAllCustomers)
// ${GET_BY_ID_METHOD} - دالة الحصول بالمعرف (مثل: getCustomerById)
// ${ADD_METHOD} - دالة الإضافة (مثل: addCustomer)
// ${UPDATE_METHOD} - دالة التحديث (مثل: updateCustomer)
// ${DELETE_METHOD} - دالة الحذف (مثل: deleteCustomer)
// ${MODEL_PROPERTIES} - خصائص الـ Model (مثل: name: 'Test Customer', email: 'test@example.com')
// ${MODEL_PROPERTIES_2} - خصائص الـ Model الثانية
// ${ENTITY_PROPERTIES} - خصائص الـ Entity
// ${ENTITY_PROPERTY} - خاصية الـ Entity (مثل: name)
// ${EXPECTED_VALUE} - القيمة المتوقعة
// ${INVALID_ENTITY_PROPERTIES} - خصائص Entity غير صحيحة
// ${UPDATED_ENTITY_PROPERTIES} - خصائص Entity محدثة
// ${UPDATED_MODEL_PROPERTIES} - خصائص Model محدثة
// ${UPDATED_VALUE} - القيمة المحدثة
// ${MODEL_PROPERTIES_GENERATED} - خصائص Model مولدة
// ${ENTITY_PROPERTIES_GENERATED} - خصائص Entity مولدة