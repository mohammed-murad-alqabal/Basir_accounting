import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/assets/domain/entities/asset_category.dart';
import 'package:basir_accounting_system/features/assets/domain/entities/fixed_asset.dart';
import 'package:basir_accounting_system/features/assets/domain/repositories/asset_repository.dart';
import 'package:basir_accounting_system/features/assets/presentation/screens/asset_form_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryAssetRepository implements AssetRepository {
  _MemoryAssetRepository([List<FixedAsset>? assets]) : _assets = [...?assets];

  final List<FixedAsset> _assets;

  @override
  Future<void> addAsset(FixedAsset asset) async => _assets.add(asset);

  @override
  Future<void> addCategory(AssetCategory category) async {}

  @override
  Future<void> deleteAsset(String id) async =>
      _assets.removeWhere((asset) => asset.id == id);

  @override
  Future<void> deleteCategory(String id) async {}

  @override
  Future<List<FixedAsset>> getAllAssets() async => List.unmodifiable(_assets);

  @override
  Future<List<AssetCategory>> getAllCategories() async => const [];

  @override
  Future<List<FixedAsset>> searchAssets(String query) async => _assets
      .where(
        (asset) => asset.nameAr.contains(query) || asset.code.contains(query),
      )
      .toList();

  @override
  Future<void> updateAsset(FixedAsset asset) async {
    final index = _assets.indexWhere((existing) => existing.id == asset.id);
    if (index >= 0) _assets[index] = asset;
  }

  @override
  Future<void> updateCategory(AssetCategory category) async {}
}

FixedAsset existingAsset() => FixedAsset(
      id: 'asset-1',
      code: 'AST-001',
      nameAr: 'جهاز قديم',
      nameEn: 'Legacy device',
      categoryId: 'equipment',
      acquisitionDate: DateTime.utc(2024),
      cost: 5000,
      residualValue: 500,
      usefulLifeYears: 5,
      depreciationMethod: 'Straight Line',
      assetAccountId: 'asset-account',
      depreciationAccountId: 'expense-account',
      accumDepreciationAccountId: 'accum-account',
    );

Widget testApp({
  required AssetRepository repository,
  FixedAsset? asset,
}) =>
    ProviderScope(
      overrides: [assetRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AssetFormScreen(asset: asset),
      ),
    );

void main() {
  group('AssetFormScreen', () {
    testWidgets('يرفض الحفظ عند غياب الاسمَين الإلزاميين', (tester) async {
      final repository = _MemoryAssetRepository();
      await tester.pumpWidget(testApp(repository: repository));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppEnhancedButton).last);
      await tester.pumpAndSettle();

      expect(await repository.getAllAssets(), isEmpty);
      expect(find.text('هذا الحقل مطلوب'), findsNWidgets(2));
    });

    testWidgets('ينشئ أصلاً ثابتاً بالحقول والقيم العددية المدخلة', (
      tester,
    ) async {
      final repository = _MemoryAssetRepository();
      await tester.pumpWidget(testApp(repository: repository));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'معدات خادم');
      await tester.enterText(fields.at(1), 'Server equipment');
      await tester.enterText(fields.at(2), 'AST-2025-01');
      await tester.enterText(fields.at(3), '12000.50');
      await tester.enterText(fields.at(4), '1200.25');
      await tester.enterText(fields.at(5), '8');

      await tester.tap(find.byType(AppEnhancedButton).last);
      await tester.pumpAndSettle();

      final assets = await repository.getAllAssets();
      expect(assets, hasLength(1));
      expect(assets.single.nameAr, 'معدات خادم');
      expect(assets.single.nameEn, 'Server equipment');
      expect(assets.single.code, 'AST-2025-01');
      expect(assets.single.cost, 12000.50);
      expect(assets.single.residualValue, 1200.25);
      expect(assets.single.usefulLifeYears, 8);
    });

    testWidgets('يعرض بيانات الأصل القائم ويحدّثها عبر مسار التعديل', (
      tester,
    ) async {
      final original = existingAsset();
      final repository = _MemoryAssetRepository([original]);
      await tester.pumpWidget(testApp(repository: repository, asset: original));
      await tester.pumpAndSettle();

      expect(find.text('تعديل بيانات الأصل'), findsAtLeastNWidgets(1));
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'جهاز خادم محدث');
      await tester.enterText(fields.at(3), '6500');

      await tester.tap(find.byType(AppEnhancedButton).last);
      await tester.pumpAndSettle();

      final updated = (await repository.getAllAssets()).single;
      expect(updated.id, original.id);
      expect(updated.nameAr, 'جهاز خادم محدث');
      expect(updated.cost, 6500);
      expect(updated.isActive, isTrue);
    });
  });
}
