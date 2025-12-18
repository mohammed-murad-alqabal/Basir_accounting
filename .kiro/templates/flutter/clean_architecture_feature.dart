// Clean Architecture Feature Template
// المؤلف: فريق وكلاء تطوير مشروع بصير

/*
استخدم هذا القالب لإنشاء ميزة جديدة باستخدام Clean Architecture

البنية المطلوبة:
lib/features/[feature_name]/
├── data/
│   ├── models/
│   │   └── [feature]_model.dart
│   ├── repositories/
│   │   └── [feature]_repository_impl.dart
│   └── services/
│       └── [feature]_service.dart
├── domain/
│   ├── entities/
│   │   └── [feature].dart
│   ├── repositories/
│   │   └── [feature]_repository.dart
│   └── usecases/
│       └── [feature]_usecases.dart
└── presentation/
    ├── providers/
    │   └── [feature]_provider.dart
    ├── screens/
    │   └── [feature]_screen.dart
    └── widgets/
        └── [feature]_widgets.dart

خطوات الإنشاء:
1. استبدل [feature_name] باسم الميزة
2. استبدل [feature] باسم الكيان
3. اتبع التوثيق العربي للواجهات
4. استخدم الإنجليزية للكود
*/

// ═══════════════════════════════════════════════════════════════
// 1. DOMAIN LAYER - طبقة المجال
// ═══════════════════════════════════════════════════════════════

// entities/[feature].dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '[feature].freezed.dart';
part '[feature].g.dart';

/// كيان [Feature] الأساسي
///
/// يمثل [وصف الكيان] في النظام
///
/// Properties:
/// - [id]: المعرف الفريد
/// - [name]: الاسم
/// - [createdAt]: تاريخ الإنشاء
/// - [updatedAt]: تاريخ آخر تحديث
///
/// Example:
/// ```dart
/// final [feature] = [Feature](
///   id: 'unique-id',
///   name: 'اسم الكيان',
///   createdAt: DateTime.now(),
///   updatedAt: DateTime.now(),
/// );
/// ```
@freezed
class [Feature] with _$[Feature] {
  const factory [Feature]({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _[Feature];

  factory [Feature].fromJson(Map<String, dynamic> json) =>
      _$[Feature]FromJson(json);
}

// ═══════════════════════════════════════════════════════════════
// repositories/[feature]_repository.dart
// ═══════════════════════════════════════════════════════════════

import 'package:basser_app/features/[feature_name]/domain/entities/[feature].dart';

/// مستودع [Feature] - واجهة العمليات الأساسية
///
/// يحدد العمليات المطلوبة للتعامل مع [Feature] entities
/// يتبع مبادئ Clean Architecture
///
/// Operations:
/// - CRUD operations (Create, Read, Update, Delete)
/// - Search and filtering
/// - Batch operations
///
/// Example:
/// ```dart
/// final repository = ref.watch([feature]RepositoryProvider);
/// final [feature]s = await repository.getAll[Feature]s();
/// ```
abstract class [Feature]Repository {
  /// الحصول على جميع [Feature]s
  ///
  /// Returns: قائمة بجميع [Feature]s المحفوظة
  ///
  /// Example:
  /// ```dart
  /// final [feature]s = await repository.getAll[Feature]s();
  /// print('عدد [Feature]s: ${[feature]s.length}');
  /// ```
  Future<List<[Feature]>> getAll[Feature]s();

  /// الحصول على [feature] بالمعرف
  ///
  /// Parameters:
  /// - [id]: معرف [Feature] المطلوب
  ///
  /// Returns: [Feature] أو null إذا لم يوجد
  ///
  /// Example:
  /// ```dart
  /// final [feature] = await repository.get[Feature]ById('id-123');
  /// if ([feature] != null) {
  ///   print('[Feature]: ${[feature].name}');
  /// }
  /// ```
  Future<[Feature]?> get[Feature]ById(String id);

  /// إضافة [feature] جديد
  ///
  /// Parameters:
  /// - [[feature]]: [Feature] المراد إضافته
  ///
  /// Returns: معرف [Feature] الجديد
  ///
  /// Example:
  /// ```dart
  /// final id = await repository.add[Feature]([feature]);
  /// print('تم إنشاء [feature] بمعرف: $id');
  /// ```
  Future<String> add[Feature]([Feature] [feature]);

  /// تحديث [feature] موجود
  ///
  /// Parameters:
  /// - [[feature]]: [Feature] المحدث
  ///
  /// Example:
  /// ```dart
  /// await repository.update[Feature](updated[Feature]);
  /// ```
  Future<void> update[Feature]([Feature] [feature]);

  /// حذف [feature]
  ///
  /// Parameters:
  /// - [id]: معرف [Feature] المراد حذفه
  ///
  /// Example:
  /// ```dart
  /// await repository.delete[Feature]('id-123');
  /// ```
  Future<void> delete[Feature](String id);

  /// البحث في [Feature]s
  ///
  /// Parameters:
  /// - [query]: نص البحث
  ///
  /// Returns: قائمة [Feature]s المطابقة
  ///
  /// Example:
  /// ```dart
  /// final results = await repository.search[Feature]s('نص البحث');
  /// print('النتائج: ${results.length}');
  /// ```
  Future<List<[Feature]>> search[Feature]s(String query);
}

// ═══════════════════════════════════════════════════════════════
// 2. DATA LAYER - طبقة البيانات
// ═══════════════════════════════════════════════════════════════

// models/[feature]_model.dart
import 'package:basser_app/features/[feature_name]/domain/entities/[feature].dart';
import 'package:isar/isar.dart';

part '[feature]_model.g.dart';

/// نموذج [Feature] لقاعدة البيانات المحلية
///
/// يمثل [Feature] في قاعدة بيانات Isar
/// يحول بين Entity والنموذج المحلي
@collection
class [Feature]Model {
  /// المعرف الفريد (Isar ID)
  Id id = Isar.autoIncrement;

  /// معرف [Feature] الخارجي
  @Index(unique: true)
  late String [feature]Id;

  /// اسم [Feature]
  @Index()
  late String name;

  /// تاريخ الإنشاء
  @Index()
  late DateTime createdAt;

  /// تاريخ آخر تحديث
  late DateTime updatedAt;

  /// تحويل من Entity إلى Model
  factory [Feature]Model.fromEntity([Feature] entity) {
    return [Feature]Model()
      ..[feature]Id = entity.id
      ..name = entity.name
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }

  /// تحويل من Model إلى Entity
  [Feature] toEntity() {
    return [Feature](
      id: [feature]Id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// repositories/[feature]_repository_impl.dart
// ═══════════════════════════════════════════════════════════════

import 'package:basser_app/features/[feature_name]/data/models/[feature]_model.dart';
import 'package:basser_app/features/[feature_name]/domain/entities/[feature].dart';
import 'package:basser_app/features/[feature_name]/domain/repositories/[feature]_repository.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

/// تنفيذ مستودع [Feature]
///
/// ينفذ واجهة [Feature]Repository باستخدام قاعدة بيانات Isar المحلية
class [Feature]RepositoryImpl implements [Feature]Repository {
  const [Feature]RepositoryImpl({required this.isar});

  final Isar isar;
  static const _uuid = Uuid();

  @override
  Future<List<[Feature]>> getAll[Feature]s() async {
    try {
      final models = await isar.[feature]Models.where().findAll();
      return models.map((model) => model.toEntity()).toList();
    } catch (error, stackTrace) {
      debugPrint('Error getting all [feature]s: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<[Feature]?> get[Feature]ById(String id) async {
    try {
      final model = await isar.[feature]Models
          .where()
          .[feature]IdEqualTo(id)
          .findFirst();
      return model?.toEntity();
    } catch (error, stackTrace) {
      debugPrint('Error getting [feature] by id: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<String> add[Feature]([Feature] [feature]) async {
    try {
      final id = [feature].id.isEmpty ? _uuid.v4() : [feature].id;
      final [feature]WithId = [feature].copyWith(id: id);
      final model = [Feature]Model.fromEntity([feature]WithId);
      
      await isar.writeTxn(() async {
        await isar.[feature]Models.put(model);
      });
      
      return id;
    } catch (error, stackTrace) {
      debugPrint('Error adding [feature]: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> update[Feature]([Feature] [feature]) async {
    try {
      final model = [Feature]Model.fromEntity([feature]);
      await isar.writeTxn(() async {
        await isar.[feature]Models.put(model);
      });
    } catch (error, stackTrace) {
      debugPrint('Error updating [feature]: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> delete[Feature](String id) async {
    try {
      await isar.writeTxn(() async {
        await isar.[feature]Models.where().[feature]IdEqualTo(id).deleteFirst();
      });
    } catch (error, stackTrace) {
      debugPrint('Error deleting [feature]: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<[Feature]>> search[Feature]s(String query) async {
    try {
      final models = await isar.[feature]Models
          .where()
          .nameContains(query, caseSensitive: false)
          .findAll();
      return models.map((model) => model.toEntity()).toList();
    } catch (error, stackTrace) {
      debugPrint('Error searching [feature]s: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// 3. PRESENTATION LAYER - طبقة العرض
// ═══════════════════════════════════════════════════════════════

// providers/[feature]_provider.dart
import 'package:basser_app/core/providers.dart';
import 'package:basser_app/features/[feature_name]/domain/entities/[feature].dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider لقائمة جميع [Feature]s
final [feature]sProvider = FutureProvider<List<[Feature]>>((ref) async {
  final repository = ref.watch([feature]RepositoryProvider);
  return repository.getAll[Feature]s();
});

/// Provider لإضافة [feature] جديد
final add[Feature]Provider = FutureProvider.family<String, [Feature]>((
  ref,
  [feature],
) async {
  final repository = ref.watch(
    [feature]RepositoryProvider.select((repo) => repo),
  );

  try {
    final id = await repository.add[Feature]([feature]);
    ref.invalidate([feature]sProvider);
    return id;
  } on Exception {
    rethrow;
  }
});

/// Provider لتحديث [feature]
final update[Feature]Provider = FutureProvider.family<bool, [Feature]>((
  ref,
  [feature],
) async {
  final repository = ref.watch(
    [feature]RepositoryProvider.select((repo) => repo),
  );

  try {
    await repository.update[Feature]([feature]);
    ref.invalidate([feature]sProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// Provider لحذف [feature]
final delete[Feature]Provider = FutureProvider.family<bool, String>((
  ref,
  [feature]Id,
) async {
  final repository = ref.watch(
    [feature]RepositoryProvider.select((repo) => repo),
  );

  try {
    await repository.delete[Feature]([feature]Id);
    ref.invalidate([feature]sProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// State Provider لحالة البحث
final [feature]SearchProvider = StateProvider<String>((ref) => '');

/// Provider للبحث في [Feature]s
final search[Feature]sProvider = Provider<AsyncValue<List<[Feature]>>>((ref) {
  final searchQuery = ref.watch([feature]SearchProvider.select((value) => value));
  final repository = ref.watch([feature]RepositoryProvider);

  if (searchQuery.isEmpty) {
    return ref.watch([feature]sProvider);
  }

  return ref.watch(
    FutureProvider<List<[Feature]>>((ref) async {
      return repository.search[Feature]s(searchQuery);
    }),
  );
});

// ═══════════════════════════════════════════════════════════════
// screens/[feature]_screen.dart
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basser_app/features/[feature_name]/presentation/providers/[feature]_provider.dart';

/// شاشة [Feature] الرئيسية
///
/// تعرض قائمة [Feature]s مع إمكانيات:
/// - عرض جميع [Feature]s
/// - البحث والفلترة
/// - إضافة [feature] جديد
/// - تحديث وحذف [Feature]s
class [Feature]Screen extends ConsumerWidget {
  const [Feature]Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final [feature]sAsync = ref.watch([feature]sProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('[Feature]s'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAdd[Feature]Dialog(context, ref),
          ),
        ],
      ),
      body: [feature]sAsync.when(
        data: ([feature]s) => _build[Feature]List([feature]s),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('خطأ: $error'),
        ),
      ),
    );
  }

  Widget _build[Feature]List(List<[Feature]> [feature]s) {
    if ([feature]s.isEmpty) {
      return const Center(
        child: Text('لا توجد [feature]s'),
      );
    }

    return ListView.builder(
      itemCount: [feature]s.length,
      itemBuilder: (context, index) {
        final [feature] = [feature]s[index];
        return ListTile(
          title: Text([feature].name),
          subtitle: Text('تم الإنشاء: ${[feature].createdAt}'),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('تحديث'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('حذف'),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                _showEdit[Feature]Dialog(context, ref, [feature]);
              } else if (value == 'delete') {
                _delete[Feature](ref, [feature].id);
              }
            },
          ),
        );
      },
    );
  }

  void _showAdd[Feature]Dialog(BuildContext context, WidgetRef ref) {
    // تنفيذ dialog إضافة [feature]
  }

  void _showEdit[Feature]Dialog(BuildContext context, WidgetRef ref, [Feature] [feature]) {
    // تنفيذ dialog تحديث [feature]
  }

  void _delete[Feature](WidgetRef ref, String id) {
    ref.read(delete[Feature]Provider(id));
  }
}

// ═══════════════════════════════════════════════════════════════
// 4. TESTING TEMPLATES - قوالب الاختبارات
// ═══════════════════════════════════════════════════════════════

// test/unit/features/[feature_name]/domain/entities/[feature]_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:basser_app/features/[feature_name]/domain/entities/[feature].dart';

void main() {
  group('[Feature] Entity Tests', () {
    test('should create [feature] with required fields', () {
      // Arrange
      const [feature] = [Feature](
        id: 'test-id',
        name: 'Test [Feature]',
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Assert
      expect([feature].id, equals('test-id'));
      expect([feature].name, equals('Test [Feature]'));
    });

    test('should support JSON serialization', () {
      // Arrange
      const [feature] = [Feature](
        id: 'test-id',
        name: 'Test [Feature]',
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final json = [feature].toJson();
      final restored = [Feature].fromJson(json);

      // Assert
      expect(restored, equals([feature]));
    });
  });
}

// ═══════════════════════════════════════════════════════════════
// USAGE INSTRUCTIONS - تعليمات الاستخدام
// ═══════════════════════════════════════════════════════════════

/*
خطوات إنشاء ميزة جديدة:

1. إنشاء المجلدات:
   mkdir -p lib/features/[feature_name]/{data/{models,repositories,services},domain/{entities,repositories,usecases},presentation/{providers,screens,widgets}}

2. نسخ القوالب وتخصيصها:
   - استبدال [feature_name] باسم الميزة
   - استبدال [Feature] باسم الكلاس
   - استبدال [feature] باسم المتغير

3. تشغيل code generation:
   flutter packages pub run build_runner build

4. إضافة الـ providers إلى core/providers.dart:
   final [feature]RepositoryProvider = Provider<[Feature]Repository>((ref) {
     final isar = ref.watch(isarProvider).value;
     if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
     return [Feature]RepositoryImpl(isar: isar);
   });

5. إضافة الـ model إلى Isar schemas في core/providers.dart:
   await Isar.open([..., [Feature]ModelSchema], ...)

6. كتابة الاختبارات:
   - Unit tests للـ entities
   - Repository tests
   - Provider tests
   - Widget tests

7. تحديث التوثيق والـ README

مثال كامل لميزة "المنتجات":
- feature_name: products
- Feature: Product
- feature: product
*/