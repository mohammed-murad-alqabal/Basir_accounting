import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة إدارة العملاء (Customers Screen)
///
/// شاشة رئيسية لعرض وإدارة قائمة العملاء في التطبيق.
/// توفر واجهة شاملة لعرض، بحث، إضافة، تعديل، وحذف العملاء.
///
/// **الميزات:**
/// - عرض قائمة جميع العملاء
/// - بحث في العملاء (الاسم، البريد، الهاتف)
/// - إضافة عميل جديد
/// - عرض تفاصيل العميل
/// - تحديث بيانات العميل
/// - حذف عميل
///
/// **الاستخدام:**
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => const CustomersScreen(),
///   ),
/// );
/// ```
///
/// **State Management:**
/// - يستخدم [customersProvider] لجلب قائمة العملاء
/// - يستخدم [ConsumerStatefulWidget] للتفاعل مع Riverpod
/// - يدير حالة البحث محليًا باستخدام [TextEditingController]
///
/// **UI Components:**
/// - [AppAppBar]: شريط التطبيق مع زر الإضافة
/// - [AppSearchField]: حقل البحث
/// - [AppListCard]: بطاقة لكل عميل
/// - حالات فارغة وتحميل وأخطاء
class CustomersScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة العملاء
  ///
  /// **مثال:**
  /// ```dart
  /// const CustomersScreen()
  /// ```
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  /// متحكم حقل البحث
  ///
  /// يدير نص البحث ويتم التخلص منه عند إغلاق الشاشة.
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'العملاء',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO(dev): فتح شاشة إضافة عميل جديد
            },
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
              onClear: _searchController.clear,
            ),
          ),

          // قائمة العملاء
          Expanded(
            child: customersAsync.when(
              data: _buildCustomersList,
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('خطأ في تحميل العملاء: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// بناء قائمة العملاء
  ///
  /// يعرض قائمة العملاء أو رسالة فارغة إذا لم يكن هناك عملاء.
  ///
  /// **السلوك:**
  /// - إذا كانت القائمة فارغة: يعرض رسالة "لا توجد عملاء"
  /// - إذا كانت القائمة تحتوي على عملاء: يعرض [ListView] مع بطاقات العملاء
  ///
  /// **UI Components:**
  /// - [AppListCard]: بطاقة لكل عميل
  /// - [CircleAvatar]: صورة دائرية بالحرف الأول من الاسم
  /// - حالة فارغة مع أيقونة ورسالة
  ///
  /// **Parameters:**
  /// - [customers]: قائمة العملاء المراد عرضها
  ///
  /// **Returns:** Widget يعرض القائمة أو الحالة الفارغة
  Widget _buildCustomersList(List<Customer> customers) {
    if (customers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'لا توجد عملاء',
              style: TextStyle(
                fontSize: AppTypography.bodyLarge,
                color: AppColors.textSecondary,
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
          onTap: () {
            // TODO(dev): فتح تفاصيل العميل
          },
        );
      },
    );
  }
}
