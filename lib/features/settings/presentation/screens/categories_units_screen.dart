// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// نموذج بسيط للفئة/الوحدة
class _Item {
  _Item({required this.id, required this.name});
  final String id;
  String name;
}

/// 📂 شاشة إدارة الفئات والوحدات
///
/// تجمع إدارة فئات المنتجات ووحداتها في واجهة واحدة.
/// مُنقولة ومُكيَّفة من Basir-accounting.
class CategoriesUnitsScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة الفئات والوحدات
  const CategoriesUnitsScreen({super.key});

  @override
  ConsumerState<CategoriesUnitsScreen> createState() => _CategoriesUnitsScreenState();
}

class _CategoriesUnitsScreenState extends ConsumerState<CategoriesUnitsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // بيانات تجريبية — ستُربط بـ Isar/Drift لاحقاً
  final List<_Item> _categories = [
    _Item(id: '1', name: 'مواد غذائية'),
    _Item(id: '2', name: 'مستلزمات منزلية'),
    _Item(id: '3', name: 'إلكترونيات'),
  ];

  final List<_Item> _units = [
    _Item(id: '1', name: 'قطعة'),
    _Item(id: '2', name: 'كرتون'),
    _Item(id: '3', name: 'كيلو'),
    _Item(id: '4', name: 'لتر'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الفئات والوحدات'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'الفئات', icon: Icon(Icons.category_outlined)),
            Tab(text: 'الوحدات', icon: Icon(Icons.straighten_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildItemList(_categories, 'فئة', Icons.category_outlined),
          _buildItemList(_units, 'وحدة', Icons.straighten_outlined),
        ],
      ),
    );
  }

  Widget _buildItemList(List<_Item> items, String type, IconData icon) => Column(
    children: [
      Expanded(
        child: items.isEmpty
            ? Center(child: Text('لا توجد $type بعد'))
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(item.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _showEditDialog(item, items, type),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _confirmDelete(item, items, type),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: FilledButton.icon(
          icon: const Icon(Icons.add),
          label: Text('إضافة $type جديدة'),
          onPressed: () => _showAddDialog(items, type),
        ),
      ),
    ],
  );

  Future<void> _showAddDialog(List<_Item> items, String type) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('إضافة $type جديدة'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: 'اسم $type', border: const OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('إضافة')),
        ],
      ),
    );

    if ((confirmed ?? false) && controller.text.isNotEmpty) {
      setState(() {
        items.add(
          _Item(id: DateTime.now().millisecondsSinceEpoch.toString(), name: controller.text.trim()),
        );
      });
      // TODO(m): حفظ في Isar/Drift
    }
    controller.dispose();
  }

  Future<void> _showEditDialog(_Item item, List<_Item> items, String type) async {
    final controller = TextEditingController(text: item.name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تعديل $type'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: 'اسم $type', border: const OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
        ],
      ),
    );

    if ((confirmed ?? false) && controller.text.isNotEmpty) {
      setState(() {
        item.name = controller.text.trim();
      });
      // TODO(m): تحديث في Isar/Drift
    }
    controller.dispose();
  }

  Future<void> _confirmDelete(_Item item, List<_Item> items, String type) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('حذف $type'),
        content: Text('هل تريد حذف "$type: ${item.name}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      setState(() => items.remove(item));
      // TODO(m): حذف من Isar/Drift
    }
  }
}
