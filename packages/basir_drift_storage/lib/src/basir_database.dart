import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

part 'basir_database.g.dart';

/// Metadata محايد للتخزين المحلي؛ لا يحفظ أسرارًا أو رموز دخول.
class LocalMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get valueJson => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// صف إعدادات باركود محايد عن domain في التطبيق الرئيسي.
class BarcodeConfigs extends Table {
  TextColumn get id => text()();
  TextColumn get printerType =>
      text().withDefault(const Constant('thermal'))(); // thermal | a4
  IntColumn get columnsPerRow => integer().withDefault(const Constant(1))();
  RealColumn get heightMm => real().withDefault(const Constant<double>(30))();
  RealColumn get widthMm => real().withDefault(const Constant<double>(50))();
  RealColumn get marginMm => real().withDefault(const Constant<double>(2))();
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

/// سجل زمني محايد لأسعار السوق؛ يطابق UUID الكيان بدلاً من معرف Isar المحلي.
@TableIndex(
  name: 'market_prices_item_as_of_idx',
  columns: {#itemId, #asOfDate},
)
class MarketPrices extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text()();
  RealColumn get price => real()();
  DateTimeColumn get asOfDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// ملف شخصي واحد لكل نطاق مستخدم؛ [scopeKey] يميز المستخدم المجهول عن أي
/// قيمة userId نصية ويمنع ظهور سجل مستخدم لآخر في الاستعلامات المحلية.
class Profiles extends Table {
  TextColumn get scopeKey => text()();
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get userId => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {scopeKey};

  @override
  List<String> get customConstraints => const [
        "CHECK (sync_status IN ('synced', 'pendingPush', 'pendingPull', 'conflict'))",
      ];
}

/// إعدادات عمل واحدة لكل نطاق مستخدم؛ المفتاح ليس UUID الكيان حتى يسمح
/// بالحفظ اللاحق باستبدال الإعدادات المقيدة بالمستخدم نفسه لا بإنشاء نسخة أخرى.
class BusinessSettings extends Table {
  TextColumn get scopeKey => text()();
  TextColumn get id => text()();
  TextColumn get companyName => text()();
  TextColumn get taxNumber => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get logoUrl => text().nullable()();
  RealColumn get defaultTaxRate => real()();
  TextColumn get currencyCode => text()();
  TextColumn get currencySymbol => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {scopeKey};

  @override
  List<String> get customConstraints => const [
        "CHECK (sync_status IN ('synced', 'pendingPush', 'pendingPull', 'conflict'))",
      ];
}

/// Outbox تحضيري فقط؛ لا يوجد عامل مزامنة مفعل في هذه الحزمة بعد.
class SyncOutbox extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text().withLength(min: 1, max: 64)();
  TextColumn get entityId => text().withLength(min: 1, max: 128)();
  TextColumn get operation => text().withLength(min: 1, max: 16)();
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

/// قاعدة Drift متعددة المنصات، منفصلة عن تطبيق Basir وكياناته.
@DriftDatabase(
  tables: [
    LocalMetadata,
    BarcodeConfigs,
    MarketPrices,
    Profiles,
    BusinessSettings,
    SyncOutbox,
  ],
)
class BasirDatabase extends _$BasirDatabase {
  BasirDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async => migrator.createAll(),
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.createTable(marketPrices);
          }
          if (from < 3) {
            await migrator.createTable(profiles);
            await migrator.createTable(businessSettings);
          }
        },
        beforeOpen: (details) => customStatement('PRAGMA foreign_keys = ON'),
      );

  static QueryExecutor _openConnection() => driftDatabase(
        name: 'basir_drift_vnext',
        native: const DriftNativeOptions(
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
