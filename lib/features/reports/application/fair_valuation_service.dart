import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/stock_movement_repository.dart';
import 'package:basir_accounting_system/features/reports/domain/repositories/market_price_repository.dart';

/// خدمة التقييم العادل (Fair Valuation Service)
/// تدمج كميات المخزون مع أسعار السوق لتوفير تعديلات المركز المالي
class FairValuationService {
  /// إنشاء نسخة من الخدمة
  FairValuationService({
    required this.marketPriceRepo,
    required this.movementRepo,
    required this.inventoryRepo,
  });

  /// مستودع أسعار السوق
  final MarketPriceRepository marketPriceRepo;

  /// مستودع حركات المخزون
  final StockMovementRepository movementRepo;

  /// مستودع الأصناف
  final InventoryRepository inventoryRepo;

  /// الحصول على تحديثات القيمة العادلة لكل حساب مخزون
  /// المفتاح هو UUID الحساب، والقيمة هي الرصيد الجديد المطلوب
  /// (Quantity * Market Price)
  Future<Map<String, double>> getFairValueAdjustments(DateTime asOfDate) async {
    final adjustments = <String, double>{};

    // 1. جلب كل أصناف المخزون
    final items = await inventoryRepo.getAllItems();

    // 2. لكل صنف، جلب الكمية وأحدث سعر سوق
    for (final item in items) {
      if (item.assetAccountId == null) continue;

      final quantity =
          await movementRepo.getStockLevel(item.id, asOfDate: asOfDate);
      if (quantity <= 0) continue;

      final marketPrice =
          await marketPriceRepo.getLatestPrice(item.id, asOfDate);
      if (marketPrice == null) continue;

      final fairValue = quantity * marketPrice.price;

      // تجميع القيمة العادلة لكل حساب (قد ترتبط عدة أصناف بنفس الحساب)
      adjustments[item.assetAccountId!] =
          (adjustments[item.assetAccountId!] ?? 0) + fairValue;
    }

    return adjustments;
  }
}
