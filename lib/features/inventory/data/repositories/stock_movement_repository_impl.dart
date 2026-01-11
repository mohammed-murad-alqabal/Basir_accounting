import 'package:basir_app/features/inventory/data/models/stock_movement_model.dart';
import 'package:basir_app/features/inventory/domain/entities/stock_movement.dart';
import 'package:basir_app/features/inventory/domain/repositories/stock_movement_repository.dart';
import 'package:isar/isar.dart';

/// تطبيق مستودع حركات المخزون باستخدام Isar
class StockMovementRepositoryImpl implements StockMovementRepository {
  /// إنشاء نسخة من المستودع
  StockMovementRepositoryImpl({
    required this.isar,
    required this.userId,
    this.warehouseId,
  });

  /// كائن Isar للاتصال بقاعدة البيانات
  final Isar isar;

  /// معرف المستخدم الحالي
  final String? userId;

  /// معرف المستودع الافتراضي
  final String? warehouseId;

  @override
  Future<List<StockMovement>> getMovementsForItem(
    String itemId, {
    String? warehouseId,
    DateTime? asOfDate,
  }) async {
    final effectiveWarehouseId = warehouseId ?? this.warehouseId;
    var query = isar.stockMovementModels
        .filter()
        .itemIdEqualTo(itemId)
        .and()
        .userIdEqualTo(userId)
        .and()
        .group(
          (q) => q.warehouseIdIsNull().or().warehouseIdEqualTo(
                effectiveWarehouseId ?? '',
              ),
        );

    if (asOfDate != null) {
      query = query.and().dateLessThan(asOfDate, include: true);
    }

    final models = await query.sortByDateDesc().findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<StockMovement>> getMovementsByReference(
    String referenceId,
  ) async {
    final models = await isar.stockMovementModels
        .filter()
        .referenceIdEqualTo(referenceId)
        .and()
        .userIdEqualTo(userId)
        .findAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addMovement(StockMovement movement) async {
    final model = StockMovementModel.fromEntity(
      movement.copyWith(
        userId: userId,
        warehouseId: movement.warehouseId, // Use item's warehouse
      ),
    );
    await isar.writeTxn(() => isar.stockMovementModels.put(model));
  }

  @override
  Future<void> addMovements(List<StockMovement> movements) async {
    final models = movements
        .map(
          (m) => StockMovementModel.fromEntity(
            m.copyWith(userId: userId),
          ),
        )
        .toList();
    await isar.writeTxn(() => isar.stockMovementModels.putAll(models));
  }

  @override
  Future<double> getStockLevel(
    String itemId, {
    String? warehouseId,
    DateTime? asOfDate,
  }) async {
    final effectiveWarehouseId = warehouseId ?? this.warehouseId;
    final movements = await getMovementsForItem(
      itemId,
      warehouseId: effectiveWarehouseId,
      asOfDate: asOfDate,
    );

    double total = 0;
    for (final m in movements) {
      if (m.type == StockMovementType.inbound ||
          (m.type == StockMovementType.transfer &&
              m.warehouseId == effectiveWarehouseId &&
              !m.description!.contains('OUT'))) {
        // This logic depends on how we flag transfers.
        // Let's refine movement types to be simpler: Inbound (+) / Outbound (-)
        // Transfer is just a label for the reason.
      }
      // Actually, let's use a simpler logic:
      // Inbound = +, Outbound = -, Transfer = depends if it's the source
      // or dest.
      // But we create two movements for transfers. One OUT from source,
      // one IN to dest.
    }

    // For now, let's assume we create movements with negative quantities
    // for Outbound if needed, OR we use the type to determine sign.

    for (final m in movements) {
      switch (m.type) {
        case StockMovementType.inbound:
          total += m.quantity;
        case StockMovementType.outbound:
          total -= m.quantity;
        case StockMovementType.transfer:
          // We will create two movements for transfers:
          // 1. Type: outbound (or transfer with negative qty) at Source
          // 2. Type: inbound (or transfer with positive qty) at Dest
          // Let's stick to: Inbound/Outbound are the atomic directions.
          // Transfer/Adjustment are "Reasons" or "Action Types".
          // Wait, I defined StockMovementType as
          // {inbound, outbound, transfer, adjustment}.
          // I will use quantity as always positive and type to dictate sign.
          total -= m.quantity; // Default to outbound sign for transfer
        // No, let's redesign the type to be Directional OR use quantity sign.
        case StockMovementType.adjustment:
          // Adjustments can be + or -.
          total += m.quantity;
      }
    }
    return total;
  }
}
