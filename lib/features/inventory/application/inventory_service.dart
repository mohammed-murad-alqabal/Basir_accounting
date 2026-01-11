import 'package:basir_accounting_system/features/inventory/domain/entities/stock_movement.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/warehouse_transfer.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/stock_movement_repository.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/warehouse_transfer_repository.dart';
import 'package:uuid/uuid.dart';

/// خدمة إدارة المخزون (Inventory Service)
/// تتعامل مع حركات المخزون والتحويلات بين المستودعات
class InventoryService {
  /// إنشاء خدمة المخزون
  InventoryService({
    required this.inventoryRepo,
    required this.movementRepo,
    required this.transferRepo,
  });

  /// مستودع بيانات الأصناف
  final InventoryRepository inventoryRepo;

  /// مستودع بيانات حركات المخزون
  final StockMovementRepository movementRepo;

  /// مستودع بيانات تحويلات المستودعات
  final WarehouseTransferRepository transferRepo;

  /// Executes a warehouse transfer with dual-entry stock movements.
  Future<void> executeTransfer(WarehouseTransfer transfer) async {
    // 1. Validate stock levels in source warehouse
    for (final item in transfer.items) {
      final currentStock = await movementRepo.getStockLevel(
        item.itemId,
        warehouseId: transfer.sourceWarehouseId,
      );
      if (currentStock < item.quantity) {
        throw Exception(
          'Insufficient stock for item ${item.itemId} in source warehouse. '
          'Available: $currentStock, Required: ${item.quantity}',
        );
      }
    }

    // 2. Save the transfer record
    await transferRepo.addTransfer(transfer);

    // 3. Create Dual-Entry Movements
    final movements = <StockMovement>[];
    final now = DateTime.now();

    for (final item in transfer.items) {
      // Get the inventory item to fetch its current unit cost (for valuation)
      final invItem = await inventoryRepo.getItemById(item.itemId);
      final unitCost = invItem?.purchasePrice ?? 0.0;

      // Movement 1: Outbound from Source
      movements.add(
        StockMovement(
          id: const Uuid().v4(),
          itemId: item.itemId,
          warehouseId: transfer.sourceWarehouseId,
          type: StockMovementType.outbound,
          quantity: item.quantity,
          unitCost: unitCost,
          date: transfer.date,
          referenceId: transfer.id,
          description: 'Transfer to ${transfer.destinationWarehouseId} '
              '(Ref: ${transfer.transferNumber})',
          createdAt: now,
        ),
      );

      // Movement 2: Inbound to Destination
      movements.add(
        StockMovement(
          id: const Uuid().v4(),
          itemId: item.itemId,
          warehouseId: transfer.destinationWarehouseId,
          type: StockMovementType.inbound,
          quantity: item.quantity,
          unitCost: unitCost,
          date: transfer.date,
          referenceId: transfer.id,
          description: 'Transfer from ${transfer.sourceWarehouseId} '
              '(Ref: ${transfer.transferNumber})',
          createdAt: now,
        ),
      );
    }

    await movementRepo.addMovements(movements);
  }
}
