import 'dart:io';

import 'package:basir_accounting_system/features/assets/data/models/asset_category_model.dart';
import 'package:basir_accounting_system/features/assets/data/models/fixed_asset_model.dart';
import 'package:basir_accounting_system/features/assets/data/repositories/asset_repository_impl.dart';
import 'package:basir_accounting_system/features/assets/domain/entities/asset_category.dart';
import 'package:basir_accounting_system/features/assets/domain/entities/fixed_asset.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  late Directory temporaryDirectory;
  late Isar isar;
  late AssetRepositoryImpl repository;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    temporaryDirectory = Directory.systemTemp.createTempSync('asset_repo_');
    isar = await Isar.open(
      [FixedAssetModelSchema, AssetCategoryModelSchema],
      directory: temporaryDirectory.path,
    );
    repository = AssetRepositoryImpl(isar: isar, userId: 'asset-user');
  });

  tearDown(() async {
    await isar.close();
    if (temporaryDirectory.existsSync()) {
      temporaryDirectory.deleteSync(recursive: true);
    }
  });

  group('AssetRepositoryImpl', () {
    test('يحفظ الفئات والأصول ويعزلها عن المستخدم الآخر', () async {
      final category = _category(id: 'vehicles');
      final vehicle = _asset(id: 'asset-vehicle', categoryId: category.id!);
      await repository.addCategory(category);
      await repository.addAsset(vehicle);

      final otherUser = AssetRepositoryImpl(isar: isar, userId: 'other-user');
      await otherUser.addCategory(_category(id: 'other-category'));
      await otherUser.addAsset(
        _asset(
          id: 'other-asset',
          categoryId: 'other-category',
        ).copyWith(code: 'AST-002'),
      );

      expect(await repository.getAllCategories(), [category]);
      final storedAssets = await repository.getAllAssets();
      expect(storedAssets, hasLength(1));
      expect(storedAssets.single.id, vehicle.id);
      expect(storedAssets.single.code, vehicle.code);
      expect(storedAssets.single.categoryId, category.id);
    });

    test('يبحث في الاسم والكود ويحدّث الأصل والفئة ثم يحذفهما', () async {
      final category = _category(id: 'equipment');
      final asset = _asset(id: 'printer', categoryId: category.id!);
      await repository.addCategory(category);
      await repository.addAsset(asset);

      expect(
        (await repository.searchAssets('طابعة')).single.id,
        asset.id,
      );
      expect(
        (await repository.searchAssets('laser')).single.nameEn,
        'Laser Printer',
      );
      expect((await repository.searchAssets('AST-001')).single.code, 'AST-001');

      await repository.updateAsset(
        asset.copyWith(
          nameAr: 'طابعة المحاسبة',
          accumulatedDepreciation: 125.5,
        ),
      );
      await repository.updateCategory(
        category.copyWith(defaultUsefulLifeYears: 7),
      );

      final updatedAsset = (await repository.getAllAssets()).single;
      expect(updatedAsset.nameAr, 'طابعة المحاسبة');
      expect(updatedAsset.accumulatedDepreciation, 125.5);
      expect(
        (await repository.getAllCategories()).single.defaultUsefulLifeYears,
        7,
      );

      await repository.deleteAsset(asset.id!);
      await repository.deleteCategory(category.id!);
      await repository.deleteAsset('unknown');
      await repository.deleteCategory('unknown');

      expect(await repository.getAllAssets(), isEmpty);
      expect(await repository.getAllCategories(), isEmpty);
    });

    test('يرفض تحديث أصل أو فئة لا يملكها المستخدم الحالي', () async {
      await expectLater(
        repository.updateAsset(_asset(id: 'missing', categoryId: 'none')),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        repository.updateCategory(_category(id: 'missing')),
        throwsA(isA<Exception>()),
      );
    });
  });
}

AssetCategory _category({required String id}) => AssetCategory(
      id: id,
      nameAr: 'معدات تقنية',
      nameEn: 'Technology equipment',
      defaultDepreciationMethod: 'straight_line',
      defaultUsefulLifeYears: 5,
    );

FixedAsset _asset({required String id, required String categoryId}) =>
    FixedAsset(
      id: id,
      code: 'AST-001',
      nameAr: 'طابعة ليزر',
      nameEn: 'Laser Printer',
      categoryId: categoryId,
      acquisitionDate: DateTime.utc(2026),
      cost: 2500,
      residualValue: 250,
      usefulLifeYears: 5,
      depreciationMethod: 'straight_line',
      assetAccountId: 'asset-account',
      depreciationAccountId: 'expense-account',
      accumDepreciationAccountId: 'accum-account',
    );
