import 'package:basir_accounting_system/core/assets/app_illustrations.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/assets/domain/entities/fixed_asset.dart';
import 'package:basir_accounting_system/features/assets/presentation/providers/asset_provider.dart';
import 'package:basir_accounting_system/features/assets/presentation/screens/asset_form_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة إدارة الأصول الثابتة (Fixed Assets Screen)
class AssetsScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة الأصول الثابتة
  const AssetsScreen({super.key});

  @override
  ConsumerState<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends ConsumerState<AssetsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetsAsync = ref.watch(filteredAssetsProvider);
    final appIcons = ref.watch(appIconsProvider);

    return GlassScaffold(
      title: context.l10n.assetsScreenTitle,
      actions: [
        IconButton(
          icon: Icon(appIcons.add, size: 26),
          tooltip: context.l10n.tooltipAddAsset,
          onPressed: _addAsset,
        ),
      ],
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: AppSearchField(
              controller: _searchController,
              hint: context.l10n.assetsSearchHint,
              onChanged: (value) {
                ref.read(assetSearchQueryProvider.notifier).state = value;
              },
              onClear: () {
                _searchController.clear();
                ref.read(assetSearchQueryProvider.notifier).state = '';
              },
            ),
          ),

          // قائمة الأصول
          Expanded(
            child: assetsAsync.when(
              data: _buildAssetsList,
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (error, stack) => AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(fixedAssetsProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsList(List<FixedAsset> assets) {
    if (assets.isEmpty) {
      return const Center(child: EmptyStateIllustration());
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        final localizedName = asset.name(isArabic: context.isArabic);
        return Semantics(
          label: '$localizedName, '
              '${asset.code}, '
              '${asset.cost}',
          button: true,
          child: AppListCard(
            title: localizedName,
            subtitle: asset.code,
            trailing: '${asset.cost.toStringAsFixed(2)} '
                '${context.l10n.labelCurrencySAR}',
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: const Icon(
                Icons.business_center,
                color: AppColors.primary,
              ),
            ),
            onTap: () => _editAsset(asset),
          ),
        );
      },
    );
  }

  Future<void> _addAsset() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(builder: (context) => const AssetFormScreen()),
    );
    if (result ?? false) ref.invalidate(fixedAssetsProvider);
  }

  Future<void> _editAsset(FixedAsset asset) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => AssetFormScreen(asset: asset),
      ),
    );
    if (result ?? false) ref.invalidate(fixedAssetsProvider);
  }
}
