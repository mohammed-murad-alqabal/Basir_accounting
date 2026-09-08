import 'package:basir_accounting_system/features/inventory/data/models/inventory_item_model.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final item = InventoryItem(
    id: 'item-1',
    nameAr: 'قلم',
    nameEn: 'Pen',
    sku: 'SKU-001',
    barcode: '6291234567890',
    createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
    updatedAt: DateTime.parse('2026-01-02T00:00:00.000Z'),
  );

  test('persists the barcode in the Isar item model round trip', () {
    final model = InventoryItemModel.fromEntity(item);

    expect(model.barcode, '6291234567890');
    expect(model.toEntity().barcode, '6291234567890');
  });
}
