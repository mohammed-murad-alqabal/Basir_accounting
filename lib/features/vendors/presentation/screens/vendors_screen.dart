import 'package:basir_app/core/assets/app_illustrations.dart';
import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/vendors/domain/entities/vendor.dart';
import 'package:basir_app/features/vendors/presentation/providers/vendor_provider.dart';
import 'package:basir_app/features/vendors/presentation/screens/vendor_details_screen.dart';
import 'package:basir_app/features/vendors/presentation/screens/vendor_form_screen.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة إدارة الموردين (Vendors Screen)
class VendorsScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة الموردين
  const VendorsScreen({super.key});

  @override
  ConsumerState<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends ConsumerState<VendorsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendorsAsync = ref.watch(filteredVendorsProvider);
    final appIcons = ref.watch(appIconsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: context.l10n.vendorsScreenTitle,
        actions: [
          IconButton(
            icon: Icon(appIcons.add, size: 26),
            tooltip: context.l10n.tooltipAddVendor,
            onPressed: _addVendor,
          ),
        ],
      ),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: AppSearchField(
              controller: _searchController,
              hint: context.l10n.vendorsSearchHint,
              onChanged: (value) {
                ref.read(vendorSearchProvider.notifier).state = value;
              },
              onClear: () {
                _searchController.clear();
                ref.read(vendorSearchProvider.notifier).state = '';
              },
            ),
          ),

          // قائمة الموردين
          Expanded(
            child: vendorsAsync.when(
              data: _buildVendorsList,
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (error, stack) => Center(child: Text(error.toString())),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorsList(List<Vendor> vendors) {
    if (vendors.isEmpty) {
      return const Center(
        child: EmptyStateIllustration(
          // Using customer illustration for now if vendor specific is missing
          isCustomers: true,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final vendor = vendors[index];
        final localizedName = vendor.name(isArabic: context.isArabic);
        return Semantics(
          label: '$localizedName, '
              '${vendor.email ?? ""}, '
              '${vendor.phone ?? ""}',
          button: true,
          child: AppListCard(
            title: localizedName,
            subtitle: vendor.email ?? '',
            trailing: vendor.phone ?? '',
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(
                localizedName.isNotEmpty ? localizedName[0] : '؟',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            onTap: () => _viewVendorDetails(vendor),
          ),
        );
      },
    );
  }

  Future<void> _addVendor() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const VendorFormScreen()),
    );
    if (result ?? false) ref.invalidate(vendorsProvider);
  }

  Future<void> _viewVendorDetails(Vendor vendor) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => VendorDetailsScreen(vendor: vendor),
      ),
    );
    if (result ?? false) ref.invalidate(vendorsProvider);
  }
}
