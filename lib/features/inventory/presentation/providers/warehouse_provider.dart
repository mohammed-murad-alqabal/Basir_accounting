import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/inventory/domain/entities/warehouse.dart';
import 'package:basir_app/features/inventory/domain/entities/warehouse_transfer.dart';
import 'package:basir_app/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// مزود قائمة المستودعات
final warehousesProvider = FutureProvider<List<Warehouse>>((ref) async {
  final repository = ref.watch(warehouseRepositoryProvider);
  return repository.getAllWarehouses();
});

/// مزود قائمة التحويلات
final warehouseTransfersProvider =
    FutureProvider<List<WarehouseTransfer>>((ref) async {
  final repository = ref.watch(warehouseTransferRepositoryProvider);
  return repository.getAllTransfers();
});

/// نوتيفاير إجراءات التحويل
class TransferNotifier extends StateNotifier<AsyncValue<void>> {
  /// إنشاء نوتيفاير التحويل
  TransferNotifier({required this.ref}) : super(const AsyncValue.data(null));

  /// مرجع لمزودي الخدمة
  final Ref ref;

  /// تنفيذ عملية التحويل
  Future<bool> executeTransfer(WarehouseTransfer transfer) async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(inventoryServiceProvider);
      await service.executeTransfer(transfer);
      ref.invalidate(warehouseTransfersProvider);
      ref.invalidate(inventoryItemsProvider); // Update stock levels
      state = const AsyncValue.data(null);
      return true;
    } on Object catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

/// مزود إجراءات التحويل
final transferActionProvider =
    StateNotifierProvider<TransferNotifier, AsyncValue<void>>(
  (ref) => TransferNotifier(ref: ref),
);
