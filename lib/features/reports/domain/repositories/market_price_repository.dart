import 'package:basir_app/features/reports/domain/entities/market_price.dart';

/// واجهة مستودع أسعار السوق (Market Price Repository Interface)
abstract class MarketPriceRepository {
  /// الحصول على أحدث سعر سوق لصنف
  Future<MarketPrice?> getLatestPrice(String itemId, DateTime asOfDate);

  /// إضافة سعر سوق جديد
  Future<void> addPrice(MarketPrice price);

  /// الحصول على كل أسعار السوق التاريخية لصنف
  Future<List<MarketPrice>> getPriceHistory(String itemId);

  /// الحصول على كل أسعار السوق لتاريخ محدد
  Future<List<MarketPrice>> getPricesForDate(DateTime asOfDate);
}
