import 'package:basir_accounting_system/features/reports/data/models/market_price_model.dart';
import 'package:basir_accounting_system/features/settings/data/models/barcode_config_model.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:isar/isar.dart';

/// أسماء شرائح الاستيراد التجريبي. تبقى مستقلة لكي يصبح كل cutover قابلًا
/// للمراجعة والرجوع على حدة.
abstract final class DriftPilotMigrationSlice {
  static const barcodeConfig = 'barcode-config-v1';
  static const marketPrices = 'market-prices-v1';
}

/// قارئ إعدادات الباركود في المحرك القديم؛ يفصل المهاجر عن Isar في الاختبارات.
typedef BarcodeConfigMigrationReader = Future<BarcodeConfigRecord?> Function();

/// قارئ أسعار السوق في المحرك القديم؛ لا ينفذ أي كتابة على Isar.
typedef MarketPriceMigrationReader = Future<List<MarketPriceRecord>> Function();

/// قراءة شريحة الباركود من Isar وتحويلها إلى DTO محايد عن طبقة domain.
class IsarBarcodeConfigMigrationSource {
  IsarBarcodeConfigMigrationSource(this._isar);

  final Isar _isar;

  Future<BarcodeConfigRecord?> readDefault() async {
    final model = await _isar.barcodeConfigModels
        .filter()
        .idEqualTo('default')
        .findFirst();
    return model == null ? null : _toRecord(model);
  }

  static BarcodeConfigRecord _toRecord(BarcodeConfigModel model) =>
      BarcodeConfigRecord(
        id: model.id,
        printerType: model.printerType.name,
        columnsPerRow: model.columnsPerRow,
        heightMm: model.height,
        widthMm: model.width,
        marginMm: model.margin,
        showItemName: model.showItemName,
        showPrice: model.showPrice,
      );
}

/// قراءة سجل أسعار السوق من Isar. يطبق الفرز المعين نفسه قبل الإرجاع حتى يكون
/// الاستيراد قابلًا لإعادة التشغيل بصورة حتمية مهما اختلف ترتيب القراءة الأساسي.
class IsarMarketPriceMigrationSource {
  IsarMarketPriceMigrationSource(this._isar);

  final Isar _isar;

  Future<List<MarketPriceRecord>> readAll() async {
    final models = await _isar.marketPriceModels.where().findAll();
    final records = models.map(_toRecord).toList(growable: false)
      ..sort(_compareMarketPriceRecords);
    return records;
  }

  static MarketPriceRecord _toRecord(MarketPriceModel model) =>
      MarketPriceRecord(
        id: model.id,
        itemId: model.itemId,
        price: model.price,
        asOfDate: model.asOfDate.toUtc(),
        createdAt: model.createdAt.toUtc(),
      );
}

/// ناتج تشغيل المهاجر. لا يتضمن بيانات أعمال، ويصلح للتسجيل التشخيصي فقط.
class DriftPilotMigrationReport {
  const DriftPilotMigrationReport({
    required this.barcodeConfig,
    required this.marketPrices,
  });

  final MigrationCheckpoint barcodeConfig;
  final MigrationCheckpoint marketPrices;

  bool get isComplete => barcodeConfig.isComplete && marketPrices.isComplete;
}

/// يستورد شريحتي pilot بصورة idempotent. Isar مصدر قراءة فقط، وDrift هدف كتابة
/// فقط؛ لا يبدل هذا الكائن أي Riverpod provider ولا يغير مسار التطبيق النشط.
class DriftPilotMigrator {
  DriftPilotMigrator({
    required BarcodeConfigMigrationReader barcodeSource,
    required MarketPriceMigrationReader marketPriceSource,
    required BarcodeConfigStorage barcodeStorage,
    required MarketPriceStorage marketPriceStorage,
    required MigrationCheckpointStorage checkpoints,
  })  : _barcodeSource = barcodeSource,
        _marketPriceSource = marketPriceSource,
        _barcodeStorage = barcodeStorage,
        _marketPriceStorage = marketPriceStorage,
        _checkpoints = checkpoints;

  final BarcodeConfigMigrationReader _barcodeSource;
  final MarketPriceMigrationReader _marketPriceSource;
  final BarcodeConfigStorage _barcodeStorage;
  final MarketPriceStorage _marketPriceStorage;
  final MigrationCheckpointStorage _checkpoints;

  Future<DriftPilotMigrationReport> migrate({int batchSize = 250}) async {
    if (batchSize <= 0) {
      throw ArgumentError.value(batchSize, 'batchSize', 'Must be positive.');
    }

    final barcodeConfig = await _migrateBarcodeConfig();
    final marketPrices = await _migrateMarketPrices(batchSize: batchSize);
    return DriftPilotMigrationReport(
      barcodeConfig: barcodeConfig,
      marketPrices: marketPrices,
    );
  }

  Future<MigrationCheckpoint> _migrateBarcodeConfig() async {
    final record = await _barcodeSource();
    if (record != null) await _barcodeStorage.save(record);

    final checkpoint = MigrationCheckpoint(
      slice: DriftPilotMigrationSlice.barcodeConfig,
      sourceCount: record == null ? 0 : 1,
      migratedCount: record == null ? 0 : 1,
      completedAt: DateTime.now().toUtc(),
    );
    await _checkpoints.save(checkpoint);
    return checkpoint;
  }

  Future<MigrationCheckpoint> _migrateMarketPrices({
    required int batchSize,
  }) async {
    final records = await _marketPriceSource();
    var migratedCount = 0;

    for (var start = 0; start < records.length; start += batchSize) {
      final end = start + batchSize < records.length
          ? start + batchSize
          : records.length;
      for (final record in records.sublist(start, end)) {
        await _marketPriceStorage.upsert(record);
        migratedCount += 1;
      }

      await _checkpoints.save(
        MigrationCheckpoint(
          slice: DriftPilotMigrationSlice.marketPrices,
          sourceCount: records.length,
          migratedCount: migratedCount,
          completedAt: null,
        ),
      );
    }

    final checkpoint = MigrationCheckpoint(
      slice: DriftPilotMigrationSlice.marketPrices,
      sourceCount: records.length,
      migratedCount: migratedCount,
      completedAt: DateTime.now().toUtc(),
    );
    await _checkpoints.save(checkpoint);
    return checkpoint;
  }
}

int _compareMarketPriceRecords(
  MarketPriceRecord left,
  MarketPriceRecord right,
) {
  final item = left.itemId.compareTo(right.itemId);
  if (item != 0) return item;
  final asOf = left.asOfDate.compareTo(right.asOfDate);
  if (asOf != 0) return asOf;
  final created = left.createdAt.compareTo(right.createdAt);
  if (created != 0) return created;
  return left.id.compareTo(right.id);
}
