import 'package:basir_accounting_system/features/reports/data/models/market_price_model.dart';
import 'package:basir_accounting_system/features/reports/domain/entities/market_price.dart';
import 'package:basir_accounting_system/features/reports/domain/repositories/market_price_repository.dart';
import 'package:isar/isar.dart';

/// تنفيذ مستودع أسعار السوق باستخدام Isar
class MarketPriceRepositoryImpl implements MarketPriceRepository {
  /// إنشاء نسخة من المستودع
  MarketPriceRepositoryImpl({required this.isar});

  /// كائن Isar للاتصال بقاعدة البيانات
  final Isar isar;

  @override
  Future<MarketPrice?> getLatestPrice(String itemId, DateTime asOfDate) async {
    final model = await isar.marketPriceModels
        .filter()
        .itemIdEqualTo(itemId)
        .and()
        .asOfDateLessThan(asOfDate, include: true)
        .sortByAsOfDateDesc()
        .findFirst();
    return model?.toEntity();
  }

  @override
  Future<void> addPrice(MarketPrice price) async {
    await isar.writeTxn(() async {
      await isar.marketPriceModels.put(MarketPriceModel.fromEntity(price));
    });
  }

  @override
  Future<List<MarketPrice>> getPriceHistory(String itemId) async {
    final models = await isar.marketPriceModels
        .filter()
        .itemIdEqualTo(itemId)
        .sortByAsOfDateDesc()
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<MarketPrice>> getPricesForDate(DateTime asOfDate) async {
    // نأخذ أحدث سعر لكل صنف لا يتجاوز التاريخ المطلوب
    final allItems = await isar.marketPriceModels
        .filter()
        .asOfDateLessThan(asOfDate, include: true)
        .findAll();

    // تجميع حسب الصنف واختيار الأحدث
    final latestPrices = <String, MarketPriceModel>{};
    for (final model in allItems) {
      final existing = latestPrices[model.itemId];
      if (existing == null || model.asOfDate.isAfter(existing.asOfDate)) {
        latestPrices[model.itemId] = model;
      }
    }

    return latestPrices.values.map((m) => m.toEntity()).toList();
  }
}
