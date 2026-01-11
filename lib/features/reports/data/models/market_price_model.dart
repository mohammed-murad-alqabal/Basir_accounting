import 'package:basir_app/features/reports/domain/entities/market_price.dart';
import 'package:isar/isar.dart';

part 'market_price_model.g.dart';

/// نموذج سعر السوق لـ Isar
@Collection()
class MarketPriceModel {
  /// إنشاء نموذج جديد
  MarketPriceModel();

  /// تحويل من كيان إلى نموذج
  factory MarketPriceModel.fromEntity(MarketPrice entity) => MarketPriceModel()
    ..id = entity.id
    ..itemId = entity.itemId
    ..price = entity.price
    ..asOfDate = entity.asOfDate
    ..createdAt = entity.createdAt;

  /// المعرف المحلي لـ Isar
  Id? isarId;

  /// المعرف الفريد (UUID)
  @Index(unique: true, replace: true)
  late String id;

  /// معرف صنف المخزون
  @Index()
  late String itemId;

  /// سعر السوق
  late double price;

  /// تاريخ التقييم
  @Index()
  late DateTime asOfDate;

  /// تاريخ الإنشاء
  late DateTime createdAt;

  /// تحويل من نموذج إلى كيان
  MarketPrice toEntity() => MarketPrice(
        id: id,
        itemId: itemId,
        price: price,
        asOfDate: asOfDate,
        createdAt: createdAt,
      );
}
