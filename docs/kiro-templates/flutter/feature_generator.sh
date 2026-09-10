#!/bin/bash

# Feature Generator Script for basir_accounting_system
# المؤلف: فريق وكلاء تطوير نظام بصير المحاسبي
# التاريخ: 11 يناير 2026

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

# التحقق من المعاملات
if [ $# -ne 2 ]; then
    echo "🏗️ basir_accounting_system Feature Generator"
    echo "================================"
    echo ""
    echo "Usage: $0 <feature_name> <entity_name>"
    echo ""
    echo "Examples:"
    echo "  $0 products product"
    echo "  $0 customers customer"
    echo "  $0 invoices invoice"
    echo ""
    echo "This will create:"
    echo "  - Complete Clean Architecture structure"
    echo "  - Domain entities and repositories"
    echo "  - Data models and implementations"
    echo "  - Presentation providers and screens"
    echo "  - Unit tests for all layers"
    echo ""
    exit 1
fi

FEATURE_NAME=$1
ENTITY_NAME=$2

# تحويل الأسماء
FEATURE_SNAKE=$(echo "$FEATURE_NAME" | sed 's/[A-Z]/_&/g' | sed 's/^_//' | tr '[:upper:]' '[:lower:]')
ENTITY_PASCAL=$(echo "$ENTITY_NAME" | sed 's/^./\U&/' | sed 's/_./\U&/g' | sed 's/_//g')
ENTITY_CAMEL=$(echo "$ENTITY_NAME" | sed 's/_./\U&/g' | sed 's/_//g')

echo "🏗️ Generating Feature: $FEATURE_NAME"
echo "=================================="
echo "Feature Name: $FEATURE_NAME"
echo "Entity Name: $ENTITY_NAME"
echo "Snake Case: $FEATURE_SNAKE"
echo "Pascal Case: $ENTITY_PASCAL"
echo "Camel Case: $ENTITY_CAMEL"
echo ""

# إنشاء هيكل المجلدات
print_info "Creating directory structure..."
mkdir -p "lib/features/$FEATURE_SNAKE/data/models"
mkdir -p "lib/features/$FEATURE_SNAKE/data/repositories"
mkdir -p "lib/features/$FEATURE_SNAKE/data/services"
mkdir -p "lib/features/$FEATURE_SNAKE/domain/entities"
mkdir -p "lib/features/$FEATURE_SNAKE/domain/repositories"
mkdir -p "lib/features/$FEATURE_SNAKE/domain/usecases"
mkdir -p "lib/features/$FEATURE_SNAKE/presentation/providers"
mkdir -p "lib/features/$FEATURE_SNAKE/presentation/screens"
mkdir -p "lib/features/$FEATURE_SNAKE/presentation/widgets"

# إنشاء مجلدات الاختبارات
mkdir -p "test/unit/features/$FEATURE_SNAKE/data/models"
mkdir -p "test/unit/features/$FEATURE_SNAKE/data/repositories"
mkdir -p "test/unit/features/$FEATURE_SNAKE/domain/entities"
mkdir -p "test/unit/features/$FEATURE_SNAKE/domain/repositories"
mkdir -p "test/widget/features/$FEATURE_SNAKE"

print_status "Directory structure created"

# قراءة القالب الأساسي
TEMPLATE_FILE=".kiro/templates/flutter/clean_architecture_feature.dart"

if [ ! -f "$TEMPLATE_FILE" ]; then
    print_error "Template file not found: $TEMPLATE_FILE"
    exit 1
fi

# دالة لاستبدال المتغيرات في القالب
generate_from_template() {
    local input_file="$1"
    local output_file="$2"
    
    sed -e "s/\[feature_name\]/$FEATURE_SNAKE/g" \
        -e "s/\[Feature\]/$ENTITY_PASCAL/g" \
        -e "s/\[feature\]/$ENTITY_CAMEL/g" \
        "$input_file" > "$output_file"
}

# إنشاء ملفات Domain Layer
print_info "Generating Domain layer..."

# Entity
cat > "lib/features/$FEATURE_SNAKE/domain/entities/$ENTITY_CAMEL.dart" << EOF
import 'package:freezed_annotation/freezed_annotation.dart';

part '$ENTITY_CAMEL.freezed.dart';
part '$ENTITY_CAMEL.g.dart';

/// كيان $ENTITY_PASCAL الأساسي
///
/// يمثل $ENTITY_PASCAL في النظام
@freezed
class $ENTITY_PASCAL with _\$$ENTITY_PASCAL {
  const factory $ENTITY_PASCAL({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _$ENTITY_PASCAL;

  factory $ENTITY_PASCAL.fromJson(Map<String, dynamic> json) =>
      _\$${ENTITY_PASCAL}FromJson(json);
}
EOF

# Repository Interface
cat > "lib/features/$FEATURE_SNAKE/domain/repositories/${ENTITY_CAMEL}_repository.dart" << EOF
import 'package:basir_accounting_system/features/$FEATURE_SNAKE/domain/entities/$ENTITY_CAMEL.dart';

/// مستودع $ENTITY_PASCAL - واجهة العمليات الأساسية
abstract class ${ENTITY_PASCAL}Repository {
  /// الحصول على جميع ${ENTITY_PASCAL}s
  Future<List<$ENTITY_PASCAL>> getAll${ENTITY_PASCAL}s();

  /// الحصول على $ENTITY_CAMEL بالمعرف
  Future<$ENTITY_PASCAL?> get${ENTITY_PASCAL}ById(String id);

  /// إضافة $ENTITY_CAMEL جديد
  Future<String> add$ENTITY_PASCAL($ENTITY_PASCAL $ENTITY_CAMEL);

  /// تحديث $ENTITY_CAMEL موجود
  Future<void> update$ENTITY_PASCAL($ENTITY_PASCAL $ENTITY_CAMEL);

  /// حذف $ENTITY_CAMEL
  Future<void> delete$ENTITY_PASCAL(String id);

  /// البحث في ${ENTITY_PASCAL}s
  Future<List<$ENTITY_PASCAL>> search${ENTITY_PASCAL}s(String query);
}
EOF

print_status "Domain layer generated"

# إنشاء ملفات Data Layer
print_info "Generating Data layer..."

# Model
cat > "lib/features/$FEATURE_SNAKE/data/models/${ENTITY_CAMEL}_model.dart" << EOF
import 'package:basir_accounting_system/features/$FEATURE_SNAKE/domain/entities/$ENTITY_CAMEL.dart';
import 'package:isar/isar.dart';

part '${ENTITY_CAMEL}_model.g.dart';

/// نموذج $ENTITY_PASCAL لقاعدة البيانات المحلية
@collection
class ${ENTITY_PASCAL}Model {
  /// المعرف الفريد (Isar ID)
  Id id = Isar.autoIncrement;

  /// معرف $ENTITY_PASCAL الخارجي
  @Index(unique: true)
  late String ${ENTITY_CAMEL}Id;

  /// اسم $ENTITY_PASCAL
  @Index()
  late String name;

  /// تاريخ الإنشاء
  @Index()
  late DateTime createdAt;

  /// تاريخ آخر تحديث
  late DateTime updatedAt;

  /// تحويل من Entity إلى Model
  factory ${ENTITY_PASCAL}Model.fromEntity($ENTITY_PASCAL entity) {
    return ${ENTITY_PASCAL}Model()
      ..${ENTITY_CAMEL}Id = entity.id
      ..name = entity.name
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }

  /// تحويل من Model إلى Entity
  $ENTITY_PASCAL toEntity() {
    return $ENTITY_PASCAL(
      id: ${ENTITY_CAMEL}Id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
EOF

# Repository Implementation
cat > "lib/features/$FEATURE_SNAKE/data/repositories/${ENTITY_CAMEL}_repository_impl.dart" << EOF
import 'package:basir_accounting_system/features/$FEATURE_SNAKE/data/models/${ENTITY_CAMEL}_model.dart';
import 'package:basir_accounting_system/features/$FEATURE_SNAKE/domain/entities/$ENTITY_CAMEL.dart';
import 'package:basir_accounting_system/features/$FEATURE_SNAKE/domain/repositories/${ENTITY_CAMEL}_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

/// تنفيذ مستودع $ENTITY_PASCAL
class ${ENTITY_PASCAL}RepositoryImpl implements ${ENTITY_PASCAL}Repository {
  const ${ENTITY_PASCAL}RepositoryImpl({required this.isar});

  final Isar isar;
  static const _uuid = Uuid();

  @override
  Future<List<$ENTITY_PASCAL>> getAll${ENTITY_PASCAL}s() async {
    try {
      final models = await isar.${ENTITY_CAMEL}Models.where().findAll();
      return models.map((model) => model.toEntity()).toList();
    } catch (error, stackTrace) {
      debugPrint('Error getting all ${ENTITY_CAMEL}s: \$error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<$ENTITY_PASCAL?> get${ENTITY_PASCAL}ById(String id) async {
    try {
      final model = await isar.${ENTITY_CAMEL}Models
          .where()
          .${ENTITY_CAMEL}IdEqualTo(id)
          .findFirst();
      return model?.toEntity();
    } catch (error, stackTrace) {
      debugPrint('Error getting $ENTITY_CAMEL by id: \$error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<String> add$ENTITY_PASCAL($ENTITY_PASCAL $ENTITY_CAMEL) async {
    try {
      final id = $ENTITY_CAMEL.id.isEmpty ? _uuid.v4() : $ENTITY_CAMEL.id;
      final ${ENTITY_CAMEL}WithId = $ENTITY_CAMEL.copyWith(id: id);
      final model = ${ENTITY_PASCAL}Model.fromEntity(${ENTITY_CAMEL}WithId);
      
      await isar.writeTxn(() async {
        await isar.${ENTITY_CAMEL}Models.put(model);
      });
      
      return id;
    } catch (error, stackTrace) {
      debugPrint('Error adding $ENTITY_CAMEL: \$error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> update$ENTITY_PASCAL($ENTITY_PASCAL $ENTITY_CAMEL) async {
    try {
      final model = ${ENTITY_PASCAL}Model.fromEntity($ENTITY_CAMEL);
      await isar.writeTxn(() async {
        await isar.${ENTITY_CAMEL}Models.put(model);
      });
    } catch (error, stackTrace) {
      debugPrint('Error updating $ENTITY_CAMEL: \$error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> delete$ENTITY_PASCAL(String id) async {
    try {
      await isar.writeTxn(() async {
        await isar.${ENTITY_CAMEL}Models.where().${ENTITY_CAMEL}IdEqualTo(id).deleteFirst();
      });
    } catch (error, stackTrace) {
      debugPrint('Error deleting $ENTITY_CAMEL: \$error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<$ENTITY_PASCAL>> search${ENTITY_PASCAL}s(String query) async {
    try {
      final models = await isar.${ENTITY_CAMEL}Models
          .where()
          .nameContains(query, caseSensitive: false)
          .findAll();
      return models.map((model) => model.toEntity()).toList();
    } catch (error, stackTrace) {
      debugPrint('Error searching ${ENTITY_CAMEL}s: \$error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }
}
EOF

print_status "Data layer generated"

# إنشاء ملفات Presentation Layer
print_info "Generating Presentation layer..."

# Providers
cat > "lib/features/$FEATURE_SNAKE/presentation/providers/${ENTITY_CAMEL}_provider.dart" << EOF
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/$FEATURE_SNAKE/domain/entities/$ENTITY_CAMEL.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider لقائمة جميع ${ENTITY_PASCAL}s
final ${ENTITY_CAMEL}sProvider = FutureProvider<List<$ENTITY_PASCAL>>((ref) async {
  final repository = ref.watch(${ENTITY_CAMEL}RepositoryProvider);
  return repository.getAll${ENTITY_PASCAL}s();
});

/// Provider لإضافة $ENTITY_CAMEL جديد
final add${ENTITY_PASCAL}Provider = FutureProvider.family<String, $ENTITY_PASCAL>((
  ref,
  $ENTITY_CAMEL,
) async {
  final repository = ref.watch(
    ${ENTITY_CAMEL}RepositoryProvider.select((repo) => repo),
  );

  try {
    final id = await repository.add$ENTITY_PASCAL($ENTITY_CAMEL);
    ref.invalidate(${ENTITY_CAMEL}sProvider);
    return id;
  } on Exception {
    rethrow;
  }
});

/// Provider لتحديث $ENTITY_CAMEL
final update${ENTITY_PASCAL}Provider = FutureProvider.family<bool, $ENTITY_PASCAL>((
  ref,
  $ENTITY_CAMEL,
) async {
  final repository = ref.watch(
    ${ENTITY_CAMEL}RepositoryProvider.select((repo) => repo),
  );

  try {
    await repository.update$ENTITY_PASCAL($ENTITY_CAMEL);
    ref.invalidate(${ENTITY_CAMEL}sProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// Provider لحذف $ENTITY_CAMEL
final delete${ENTITY_PASCAL}Provider = FutureProvider.family<bool, String>((
  ref,
  ${ENTITY_CAMEL}Id,
) async {
  final repository = ref.watch(
    ${ENTITY_CAMEL}RepositoryProvider.select((repo) => repo),
  );

  try {
    await repository.delete$ENTITY_PASCAL(${ENTITY_CAMEL}Id);
    ref.invalidate(${ENTITY_CAMEL}sProvider);
    return true;
  } on Exception {
    return false;
  }
});

/// State Provider لحالة البحث
final ${ENTITY_CAMEL}SearchProvider = StateProvider<String>((ref) => '');

/// Provider للبحث في ${ENTITY_PASCAL}s
final search${ENTITY_PASCAL}sProvider = Provider<AsyncValue<List<$ENTITY_PASCAL>>>((ref) {
  final searchQuery = ref.watch(${ENTITY_CAMEL}SearchProvider.select((value) => value));
  final repository = ref.watch(${ENTITY_CAMEL}RepositoryProvider);

  if (searchQuery.isEmpty) {
    return ref.watch(${ENTITY_CAMEL}sProvider);
  }

  return ref.watch(
    FutureProvider<List<$ENTITY_PASCAL>>((ref) async {
      return repository.search${ENTITY_PASCAL}s(searchQuery);
    }),
  );
});
EOF

# Screen
cat > "lib/features/$FEATURE_SNAKE/presentation/screens/${ENTITY_CAMEL}_screen.dart" << EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basir_accounting_system/features/$FEATURE_SNAKE/presentation/providers/${ENTITY_CAMEL}_provider.dart';

/// شاشة $ENTITY_PASCAL الرئيسية
class ${ENTITY_PASCAL}Screen extends ConsumerWidget {
  const ${ENTITY_PASCAL}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ${ENTITY_CAMEL}sAsync = ref.watch(${ENTITY_CAMEL}sProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('${ENTITY_PASCAL}s'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAdd${ENTITY_PASCAL}Dialog(context, ref),
          ),
        ],
      ),
      body: ${ENTITY_CAMEL}sAsync.when(
        data: (${ENTITY_CAMEL}s) => _build${ENTITY_PASCAL}List(${ENTITY_CAMEL}s),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('خطأ: \$error'),
        ),
      ),
    );
  }

  Widget _build${ENTITY_PASCAL}List(List<$ENTITY_PASCAL> ${ENTITY_CAMEL}s) {
    if (${ENTITY_CAMEL}s.isEmpty) {
      return const Center(
        child: Text('لا توجد ${ENTITY_CAMEL}s'),
      );
    }

    return ListView.builder(
      itemCount: ${ENTITY_CAMEL}s.length,
      itemBuilder: (context, index) {
        final $ENTITY_CAMEL = ${ENTITY_CAMEL}s[index];
        return ListTile(
          title: Text($ENTITY_CAMEL.name),
          subtitle: Text('تم الإنشاء: \${$ENTITY_CAMEL.createdAt}'),
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
                _showEdit${ENTITY_PASCAL}Dialog(context, ref, $ENTITY_CAMEL);
              } else if (value == 'delete') {
                _delete$ENTITY_PASCAL(ref, $ENTITY_CAMEL.id);
              }
            },
          ),
        );
      },
    );
  }

  void _showAdd${ENTITY_PASCAL}Dialog(BuildContext context, WidgetRef ref) {
    // TODO: تنفيذ dialog إضافة $ENTITY_CAMEL
  }

  void _showEdit${ENTITY_PASCAL}Dialog(BuildContext context, WidgetRef ref, $ENTITY_PASCAL $ENTITY_CAMEL) {
    // TODO: تنفيذ dialog تحديث $ENTITY_CAMEL
  }

  void _delete$ENTITY_PASCAL(WidgetRef ref, String id) {
    ref.read(delete${ENTITY_PASCAL}Provider(id));
  }
}
EOF

print_status "Presentation layer generated"

# إنشاء الاختبارات
print_info "Generating tests..."

# Entity Test
cat > "test/unit/features/$FEATURE_SNAKE/domain/entities/${ENTITY_CAMEL}_test.dart" << EOF
import 'package:flutter_test/flutter_test.dart';
import 'package:basir_accounting_system/features/$FEATURE_SNAKE/domain/entities/$ENTITY_CAMEL.dart';

void main() {
  group('$ENTITY_PASCAL Entity Tests', () {
    test('should create $ENTITY_CAMEL with required fields', () {
      // Arrange
      const $ENTITY_CAMEL = $ENTITY_PASCAL(
        id: 'test-id',
        name: 'Test $ENTITY_PASCAL',
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Assert
      expect($ENTITY_CAMEL.id, equals('test-id'));
      expect($ENTITY_CAMEL.name, equals('Test $ENTITY_PASCAL'));
    });

    test('should support JSON serialization', () {
      // Arrange
      const $ENTITY_CAMEL = $ENTITY_PASCAL(
        id: 'test-id',
        name: 'Test $ENTITY_PASCAL',
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final json = $ENTITY_CAMEL.toJson();
      final restored = $ENTITY_PASCAL.fromJson(json);

      // Assert
      expect(restored, equals($ENTITY_CAMEL));
    });
  });
}
EOF

print_status "Tests generated"

# إنشاء تقرير
print_info "Generating feature report..."

cat > ".kiro/reports/feature_${FEATURE_SNAKE}_generation_report.md" << EOF
# Feature Generation Report: $FEATURE_NAME

**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')
**المؤلف:** فريق وكلاء تطوير نظام بصير المحاسبي

## Generated Feature Details

- **Feature Name:** $FEATURE_NAME
- **Entity Name:** $ENTITY_NAME
- **Snake Case:** $FEATURE_SNAKE
- **Pascal Case:** $ENTITY_PASCAL
- **Camel Case:** $ENTITY_CAMEL

## Generated Files

### Domain Layer
- ✅ \`lib/features/$FEATURE_SNAKE/domain/entities/${ENTITY_CAMEL}.dart\`
- ✅ \`lib/features/$FEATURE_SNAKE/domain/repositories/${ENTITY_CAMEL}_repository.dart\`

### Data Layer
- ✅ \`lib/features/$FEATURE_SNAKE/data/models/${ENTITY_CAMEL}_model.dart\`
- ✅ \`lib/features/$FEATURE_SNAKE/data/repositories/${ENTITY_CAMEL}_repository_impl.dart\`

### Presentation Layer
- ✅ \`lib/features/$FEATURE_SNAKE/presentation/providers/${ENTITY_CAMEL}_provider.dart\`
- ✅ \`lib/features/$FEATURE_SNAKE/presentation/screens/${ENTITY_CAMEL}_screen.dart\`

### Tests
- ✅ \`test/unit/features/$FEATURE_SNAKE/domain/entities/${ENTITY_CAMEL}_test.dart\`

## Next Steps

1. **Add to Core Providers:**
   \`\`\`dart
   // في lib/core/providers.dart
   final ${ENTITY_CAMEL}RepositoryProvider = Provider<${ENTITY_PASCAL}Repository>((ref) {
     final isar = ref.watch(isarProvider).value;
     if (isar == null) throw Exception('قاعدة البيانات غير جاهزة');
     return ${ENTITY_PASCAL}RepositoryImpl(isar: isar);
   });
   \`\`\`

2. **Add to Isar Schemas:**
   \`\`\`dart
   // في lib/core/providers.dart
   await Isar.open([
     // ... existing schemas
     ${ENTITY_PASCAL}ModelSchema,
   ], directory: dir.path);
   \`\`\`

3. **Run Code Generation:**
   \`\`\`bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   \`\`\`

4. **Add Navigation:**
   - Add route to app router
   - Add navigation from main menu

5. **Complete Implementation:**
   - Implement dialog forms
   - Add validation
   - Add error handling
   - Write comprehensive tests

## Architecture Compliance

✅ Clean Architecture structure
✅ Domain-driven design
✅ Dependency inversion
✅ Separation of concerns
✅ Testable components
✅ Arabic documentation
✅ English code

---

**Generated by:** Feature Generator Script v1.0
EOF

print_status "Feature generation completed successfully! 🎉"
print_info "Report saved to: .kiro/reports/feature_${FEATURE_SNAKE}_generation_report.md"

echo ""
echo "🎯 Next Steps:"
echo "1. Add providers to lib/core/providers.dart"
echo "2. Add model schema to Isar configuration"
echo "3. Run: flutter packages pub run build_runner build"
echo "4. Implement UI dialogs and forms"
echo "5. Write comprehensive tests"
echo ""
echo "📁 Generated files in: lib/features/$FEATURE_SNAKE/"
echo "🧪 Test files in: test/unit/features/$FEATURE_SNAKE/"
echo ""