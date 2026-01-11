import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/assets/domain/entities/asset_category.dart';
import 'package:basir_accounting_system/features/assets/domain/entities/fixed_asset.dart';
import 'package:basir_accounting_system/features/assets/domain/repositories/asset_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the list of all fixed assets
final fixedAssetsProvider = FutureProvider<List<FixedAsset>>((ref) async {
  final repository = ref.watch(assetRepositoryProvider);
  return repository.getAllAssets();
});

/// موفر قائمة فئات الأصول
final assetCategoriesProvider = FutureProvider<List<AssetCategory>>((
  ref,
) async {
  final repository = ref.watch(assetRepositoryProvider);
  return repository.getAllCategories();
});

/// Provider for the asset search query
final assetSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for filtered fixed assets based on search query
final filteredAssetsProvider = Provider<AsyncValue<List<FixedAsset>>>((ref) {
  final assetsAsync = ref.watch(fixedAssetsProvider);
  final searchQuery = ref.watch(assetSearchQueryProvider).toLowerCase();

  return assetsAsync.whenData((assets) {
    if (searchQuery.isEmpty) return assets;
    return assets
        .where(
          (asset) =>
              asset.nameAr.toLowerCase().contains(searchQuery) ||
              asset.nameEn.toLowerCase().contains(searchQuery) ||
              asset.code.toLowerCase().contains(searchQuery),
        )
        .toList();
  });
});

/// Notifier for asset-related actions
class AssetActionNotifier extends StateNotifier<AsyncValue<void>> {
  /// إنشاء نوتيفاير إجراءات الأصول
  AssetActionNotifier(this.repository, this.ref)
      : super(const AsyncValue.data(null));

  /// مستودع الأصول
  final AssetRepository repository;

  /// مرجع الموفر (Riverpod)
  final Ref ref;

  /// إضافة أصل جديد
  Future<bool> addAsset(FixedAsset asset) async {
    state = const AsyncValue.loading();
    try {
      await repository.addAsset(asset);
      ref.invalidate(fixedAssetsProvider);
      state = const AsyncValue.data(null);
      return true;
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// تحديث أصل موجود
  Future<bool> updateAsset(FixedAsset asset) async {
    state = const AsyncValue.loading();
    try {
      await repository.updateAsset(asset);
      ref.invalidate(fixedAssetsProvider);
      state = const AsyncValue.data(null);
      return true;
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// حذف أصل
  Future<bool> deleteAsset(String id) async {
    state = const AsyncValue.loading();
    try {
      await repository.deleteAsset(id);
      ref.invalidate(fixedAssetsProvider);
      state = const AsyncValue.data(null);
      return true;
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// إضافة فئة أصول جديدة
  Future<bool> addCategory(AssetCategory category) async {
    state = const AsyncValue.loading();
    try {
      await repository.addCategory(category);
      ref.invalidate(assetCategoriesProvider);
      state = const AsyncValue.data(null);
      return true;
    } on Object catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// موفر إجراءات الأصول (CRUD)
final assetActionProvider =
    StateNotifierProvider<AssetActionNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(assetRepositoryProvider);
  return AssetActionNotifier(repository, ref);
});
