import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_items_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows barcode details in the catalog card and Arabic semantics',
      (tester) async {
    final item = InventoryItem(
      id: 'item-1',
      nameAr: 'قلم حبر',
      nameEn: 'Ink pen',
      sku: 'PEN-001',
      barcode: '6291234567890',
      currentQuantity: 12,
      unit: 'قطعة',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inventoryItemsProvider.overrideWith((ref) async => [item]),
          appIconsProvider.overrideWithValue(const MaterialAppIcons()),
        ],
        child: const MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const InventoryItemsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('قلم حبر'), findsOneWidget);
    expect(find.textContaining('6291234567890'), findsOneWidget);
    const catalogLabel =
        'قلم حبر, رمز الصنف (SKU): PEN-001 • الباركود: 6291234567890, 12 قطعة';
    final semanticLabels = tester
        .widgetList<Semantics>(find.byType(Semantics))
        .map((widget) => widget.properties.label);
    expect(semanticLabels, contains(catalogLabel));
  });
}
