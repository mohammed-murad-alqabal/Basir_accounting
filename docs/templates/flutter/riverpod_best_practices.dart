/// أفضل ممارسات Riverpod - بصير MVP
///
/// المشروع: بصير MVP
/// المؤلف: فريق وكلاء تطوير مشروع بصير
///
/// هذا الملف يحتوي على أفضل الممارسات والأنماط لاستخدام Riverpod
/// في مشروع بصير MVP مع Clean Architecture.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

// ═══════════════════════════════════════════════════════════════════════════════════
// 1. Repository Providers Pattern
// ═══════════════════════════════════════════════════════════════════════════════════

/// نمط Repository Provider - يوفر repository instance
///
/// ✅ أفضل الممارسات:
/// - استخدام Provider للـ repositories (ليس StateNotifierProvider)
/// - تطبيق dependency injection
/// - إمكانية override للاختبارات
final exampleRepositoryProvider = Provider<ExampleRepository>((ref) {
  final localDataSource = ref.watch(exampleLocalDataSourceProvider);
  return ExampleRepositoryImpl(localDataSource: localDataSource);
});

// ═══════════════════════════════════════════════════════════════════════════════════
// 2. State Management Pattern
// ═══════════════════════════════════════════════════════════════════════════════════

/// نمط State Management - إدارة حالة الميزة
///
/// ✅ أفضل الممارسات:
/// - استخدام StateNotifierProvider للحالات المعقدة
/// - تطبيق immutable state
/// - معالجة الأخطاء بشكل صحيح
final exampleStateProvider =
    StateNotifierProvider<ExampleNotifier, ExampleState>((ref) {
  final repository = ref.watch(exampleRepositoryProvider);
  return ExampleNotifier(repository: repository);
});

/// State class - يجب أن تكون immutable
class ExampleState {
  const ExampleState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  final List<ExampleItem> items;
  final bool isLoading;
  final String? error;

  /// إنشاء نسخة جديدة مع تغييرات
  ExampleState copyWith({
    List<ExampleItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return ExampleState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// StateNotifier class - إدارة العمليات
class ExampleNotifier extends StateNotifier<ExampleState> {
  ExampleNotifier({required this.repository}) : super(const ExampleState());

  final ExampleRepository repository;

  /// تحميل البيانات
  Future<void> loadItems() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.getAllItems();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (items) => state = state.copyWith(
        isLoading: false,
        items: items,
        error: null,
      ),
    );
  }

  /// إضافة عنصر جديد
  Future<void> addItem(ExampleItem item) async {
    final result = await repository.addItem(item);

    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (newItem) => state = state.copyWith(
        items: [...state.items, newItem],
        error: null,
      ),
    );
  }

  /// حذف عنصر
  Future<void> deleteItem(String id) async {
    final result = await repository.deleteItem(id);

    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => state = state.copyWith(
        items: state.items.where((item) => item.id != id).toList(),
        error: null,
      ),
    );
  }

  /// إعادة تعيين الحالة
  void reset() {
    state = const ExampleState();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════════
// 3. Computed Providers Pattern
// ═══════════════════════════════════════════════════════════════════════════════════

/// نمط Computed Providers - حساب قيم مشتقة من الحالة
///
/// ✅ أفضل الممارسات:
/// - استخدام Provider للقيم المحسوبة
/// - تطبيق memoization تلقائي
/// - تجنب العمليات المكلفة في build method

/// عدد العناصر
final itemsCountProvider = Provider<int>((ref) {
  final state = ref.watch(exampleStateProvider);
  return state.items.length;
});

/// العناصر المفلترة
final filteredItemsProvider =
    Provider.family<List<ExampleItem>, String>((ref, filter) {
  final state = ref.watch(exampleStateProvider);
  if (filter.isEmpty) return state.items;

  return state.items
      .where((item) => item.name.toLowerCase().contains(filter.toLowerCase()))
      .toList();
});

/// حالة التحميل
final isLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(exampleStateProvider);
  return state.isLoading;
});

// ═══════════════════════════════════════════════════════════════════════════════════
// 4. Async Providers Pattern
// ═══════════════════════════════════════════════════════════════════════════════════

/// نمط Async Providers - للعمليات غير المتزامنة
///
/// ✅ أفضل الممارسات:
/// - استخدام FutureProvider للعمليات المؤقتة
/// - استخدام StreamProvider للبيانات المتدفقة
/// - معالجة حالات التحميل والأخطاء

/// تحميل البيانات الأولية
final initialDataProvider = FutureProvider<List<ExampleItem>>((ref) async {
  final repository = ref.watch(exampleRepositoryProvider);
  final result = await repository.getAllItems();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (items) => items,
  );
});

/// مراقبة تغييرات البيانات
final dataStreamProvider = StreamProvider<List<ExampleItem>>((ref) {
  final repository = ref.watch(exampleRepositoryProvider);
  return repository.watchItems();
});

// ═══════════════════════════════════════════════════════════════════════════════════
// 5. Testing Patterns
// ═══════════════════════════════════════════════════════════════════════════════════

/// أنماط الاختبار - كيفية اختبار Providers
///
/// ✅ أفضل الممارسات:
/// - استخدام ProviderContainer للاختبارات
/// - تطبيق override للـ dependencies
/// - اختبار جميع الحالات (نجاح، فشل، تحميل)

/*
// مثال على اختبار Provider
void main() {
  group('ExampleNotifier Tests', () {
    late ProviderContainer container;
    late MockExampleRepository mockRepository;

    setUp(() {
      mockRepository = MockExampleRepository();
      container = ProviderContainer(
        overrides: [
          exampleRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should load items successfully', () async {
      // Arrange
      final items = [ExampleItem(id: '1', name: 'Test')];
      when(() => mockRepository.getAllItems())
          .thenAnswer((_) async => Right(items));

      // Act
      await container.read(exampleStateProvider.notifier).loadItems();

      // Assert
      final state = container.read(exampleStateProvider);
      expect(state.items, equals(items));
      expect(state.isLoading, false);
      expect(state.error, null);
    });
  });
}
*/

// ═══════════════════════════════════════════════════════════════════════════════════
// 6. Performance Optimization Patterns
// ═══════════════════════════════════════════════════════════════════════════════════

/// أنماط تحسين الأداء
///
/// ✅ أفضل الممارسات:
/// - استخدام select() لتجنب rebuilds غير ضرورية
/// - تطبيق family providers للمعاملات
/// - استخدام autoDispose عند الحاجة

/// مثال على استخدام select
final selectedItemProvider = Provider<ExampleItem?>((ref) {
  final state = ref.watch(exampleStateProvider.select((state) => state.items));
  return state.isNotEmpty ? state.first : null;
});

/// مثال على family provider مع autoDispose
final itemByIdProvider =
    Provider.autoDispose.family<ExampleItem?, String>((ref, id) {
  final state = ref.watch(exampleStateProvider);
  return state.items.where((item) => item.id == id).firstOrNull;
});

// ═══════════════════════════════════════════════════════════════════════════════════
// 7. Error Handling Patterns
// ═══════════════════════════════════════════════════════════════════════════════════

/// أنماط معالجة الأخطاء
///
/// ✅ أفضل الممارسات:
/// - تطبيق Either pattern للنتائج
/// - معالجة الأخطاء في StateNotifier
/// - توفير رسائل خطأ واضحة

/// Provider لحالة الخطأ
final errorStateProvider = Provider<String?>((ref) {
  final state = ref.watch(exampleStateProvider);
  return state.error;
});

/// Provider للتحقق من وجود خطأ
final hasErrorProvider = Provider<bool>((ref) {
  final error = ref.watch(errorStateProvider);
  return error != null;
});

// ═══════════════════════════════════════════════════════════════════════════════════
// Placeholder classes (يجب استبدالها بالكلاسات الفعلية)
// ═══════════════════════════════════════════════════════════════════════════════════

abstract class ExampleRepository {
  Future<Either<Failure, List<ExampleItem>>> getAllItems();
  Future<Either<Failure, ExampleItem>> addItem(ExampleItem item);
  Future<Either<Failure, void>> deleteItem(String id);
  Stream<List<ExampleItem>> watchItems();
}

class ExampleRepositoryImpl implements ExampleRepository {
  const ExampleRepositoryImpl({required this.localDataSource});

  final ExampleLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<ExampleItem>>> getAllItems() async {
    // TODO: تنفيذ العملية
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ExampleItem>> addItem(ExampleItem item) async {
    // TODO: تنفيذ العملية
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
    // TODO: تنفيذ العملية
    throw UnimplementedError();
  }

  @override
  Stream<List<ExampleItem>> watchItems() {
    // TODO: تنفيذ العملية
    throw UnimplementedError();
  }
}

abstract class ExampleLocalDataSource {}

final exampleLocalDataSourceProvider = Provider<ExampleLocalDataSource>((ref) {
  throw UnimplementedError();
});

class ExampleItem {
  const ExampleItem({required this.id, required this.name});

  final String id;
  final String name;
}

abstract class Failure {
  String get message;
}

extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
