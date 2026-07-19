import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_price.freezed.dart';
part 'market_price.g.dart';

/// كيان سعر السوق (Market Price Entity)
/// يستخدم لتقييم المخزون بالقيمة العادلة (IFRS Fair Value)
@freezed
class MarketPrice with _$MarketPrice {
  /// إنشاء كيان سعر سوق جديد
  const factory MarketPrice({
    /// المعرف الفريد
    required String id,

    /// معرف صنف المخزون
    required String itemId,

    /// سعر السوق (القيمة العادلة)
    required double price,

    /// تاريخ التقييم
    required DateTime asOfDate,

    /// تاريخ الإنشاء
    required DateTime createdAt,
  }) = _MarketPrice;

  /// إنشاء سعر سوق من JSON
  factory MarketPrice.fromJson(Map<String, dynamic> json) =>
      _$MarketPriceFromJson(json);
}
