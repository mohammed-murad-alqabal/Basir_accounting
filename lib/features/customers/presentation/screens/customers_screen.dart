import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:basser_app/features/customers/presentation/screens/customer_details_screen.dart';
import 'package:basser_app/features/customers/presentation/screens/customer_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة إدارة العملاء (Customers Screen)
class CustomersScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة العملاء
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(filteredCustomersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'العملاء',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 26),
            tooltip: 'إضافة عميل جديد',
            onPressed: _addCustomer,
          ),
        ],
      ),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppSearchField(
              controller: _searchController,
              hint: 'ابحث عن عميل...',
              onChanged: (value) {
                ref.read(customerSearchProvider.notifier).state = value;
              },
              onClear: () {
                _searchController.clear();
                ref.read(customerSearchProvider.notifier).state = '';
              },
            ),
          ),

          // قائمة العملاء
          Expanded(
            child: customersAsync.when(
              data: _buildCustomersList,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('خطأ في تحميل العملاء: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomersList(List<Customer> customers) {
    if (customers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'لا توجد عملاء',
              style: TextStyle(
                fontSize: AppTypography.bodyLarge,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'اضغط على + لإضافة عميل جديد',
              style: TextStyle(
                fontSize: AppTypography.bodyMedium,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return AppListCard(
          title: customer.name,
          subtitle: customer.email ?? '',
          trailing: customer.phone ?? '',
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Text(
              customer.name.isNotEmpty ? customer.name[0] : '؟',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          onTap: () => _viewCustomerDetails(customer),
        );
      },
    );
  }

  Future<void> _addCustomer() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const CustomerFormScreen()),
    );

    if (result ?? false) {
      ref.invalidate(customersProvider);
    }
  }

  Future<void> _viewCustomerDetails(Customer customer) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailsScreen(customer: customer),
      ),
    );

    if (result ?? false) {
      ref.invalidate(customersProvider);
    }
  }
}
