import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

part 'basir_database.g.dart';

/// بيانات محلية عامة، مثل مستوى اكتمال ترحيل الميزة أو إعداد لا يحتاج تشفيرًا.
/// لا تضع الرموز أو بيانات الاعتماد في هذا الجدول.
class LocalMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get valueJson => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// إعدادات الباركود منخفضة المخاطر هي أول شريحة feature تُنقل تجريبيًا.
/// تخزن قيمة PrinterType كنص ثابت، فلا يرتبط المخطط بترتيب enum في Dart.
class BarcodeConfigs extends Table {
  TextColumn get id => text()();
  TextColumn get printerType =>
      text().withDefault(const Constant('thermal'))(); // thermal | a4
  IntColumn get columnsPerRow => integer().withDefault(const Constant(1))();
  RealColumn get heightMm => real().withDefault(const Constant(30.0))();
  RealColumn get widthMm => real().withDefault(const Constant(50.0))();
  RealColumn get marginMm => real().withDefault(const Constant(2.0))();
  BoolColumn get showItemName => boolean().withDefault(const Constant(true))();
  BoolColumn get showPrice => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
    "CHECK (printer_type IN ('thermal', 'a4'))",
    'CHECK (columns_per_row > 0)',
    'CHECK (height_mm > 0)',
    'CHECK (width_mm > 0)',
    'CHECK (margin_mm >= 0)',
  ];
}

/// سجل عمليات محلية تنتظر الإرسال إلى Supabase.
/// هذا الجدول إضافة تحضيرية فقط؛ لا تُفعّل المزامنة من هذا الـSpike.
class SyncOutbox extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text().withLength(min: 1, max: 64)();
  TextColumn get entityId => text().withLength(min: 1, max: 128)();
  TextColumn get operation =>
      text().withLength(min: 1, max: 16)(); // upsert | delete
  TextColumn get payloadJson => text()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {entityType, entityId, operation},
  ];
}

/// نقطة الدخول إلى قاعدة SQLite المحلية الجديدة.
/// تبقى منفصلة تمامًا عن Isar خلال كل مراحل الـSpike والـdual-run.
@DriftDatabase(tables: [LocalMetadata, BarcodeConfigs, SyncOutbox])
class BasirDatabase extends _$BasirDatabase {
  BasirDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      // كل تغيير لاحق يرفع schemaVersion ويُضاف كمهمة ترحيل صريحة ومختبرة.
    },
    beforeOpen: (details) async {
      // تعمل SQLite foreign keys افتراضيًا في نطاق الاتصال؛ لا نفترض WAL على Web.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'basir_drift_vnext',
      native: DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
        shareAcrossIsolates: true,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty) {
            debugPrint(
              'Drift Web fallback: ${result.chosenImplementation}; '
              'missing: ${result.missingFeatures.join(', ')}',
            );
          }
        },
      ),
    );
  }

  Future<void> setMetadata(String key, String valueJson) async {
    await into(localMetadata).insertOnConflictUpdate(
      LocalMetadataCompanion.insert(
        key: key,
        valueJson: valueJson,
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<String?> readMetadata(String key) async {
    final row = await (select(localMetadata)..where((row) => row.key.equals(key)))
        .getSingleOrNull();
    return row?.valueJson;
  }

  Future<void> queueSyncOperation({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payloadJson,
  }) async {
    await into(syncOutbox).insertOnConflictUpdate(
      SyncOutboxCompanion.insert(
        id: id,
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        payloadJson: payloadJson,
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}
