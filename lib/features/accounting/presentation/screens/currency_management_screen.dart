// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// نموذج بسيط للعملة (للعرض — سيُربط بـ CurrencyModel/Isar لاحقاً)
class _Currency {
  _Currency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.rate,
    this.isDefault = false,
  });
  final String id;
  String name;
  String symbol;
  double rate;
  bool isDefault;
}

/// 💱 شاشة إدارة العملات وأسعار الصرف
///
/// تتيح إضافة وتعديل وحذف العملات وتعيين العملة الافتراضية.
/// مُنقولة ومُكيَّفة من Basir-accounting (add_currency_screen.dart).
class CurrencyManagementScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة إدارة العملات
  const CurrencyManagementScreen({super.key});

  @override
  ConsumerState<CurrencyManagementScreen> createState() => _CurrencyManagementScreenState();
}

class _CurrencyManagementScreenState extends ConsumerState<CurrencyManagementScreen> {
  // بيانات تجريبية — ستُربط بـ CurrencyRepository/Isar لاحقاً
  final List<_Currency> _currencies = [
    _Currency(id: '1', name: 'ريال سعودي', symbol: 'ر.س', rate: 1, isDefault: true),
    _Currency(id: '2', name: 'دولار أمريكي', symbol: r'$', rate: 3.75),
    _Currency(id: '3', name: 'يورو', symbol: '€', rate: 4.10),
    _Currency(id: '4', name: 'ريال يمني', symbol: 'ر.ي', rate: 0.0014),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة العملات'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCurrencyDialog,
        icon: const Icon(Icons.add),
        label: const Text('إضافة عملة'),
      ),
      body: _currencies.isEmpty
          ? const Center(child: Text('لا توجد عملات'))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
              itemCount: _currencies.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final c = _currencies[index];
                return _CurrencyTile(
                  currency: c,
                  onEdit: () => _showEditDialog(c),
                  onDelete: c.isDefault ? null : () => _confirmDelete(c),
                  onSetDefault: c.isDefault ? null : () => _setDefault(c),
                );
              },
            ),
    );
  }

  Future<void> _showAddCurrencyDialog() async {
    final result = await showDialog<_Currency>(
      context: context,
      builder: (_) => const _CurrencyFormDialog(),
    );
    if (result != null) {
      setState(() => _currencies.add(result));
      // TODO(m): حفظ في CurrencyRepository/Isar
    }
  }

  Future<void> _showEditDialog(_Currency currency) async {
    final result = await showDialog<_Currency>(
      context: context,
      builder: (_) => _CurrencyFormDialog(existing: currency),
    );
    if (result != null) {
      setState(() {
        currency
          ..name = result.name
          ..symbol = result.symbol
          ..rate = result.rate;
      });
      // TODO(m): تحديث في CurrencyRepository/Isar
    }
  }

  Future<void> _confirmDelete(_Currency currency) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف عملة'),
        content: Text('هل تريد حذف "${currency.name}"؟'),
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
      setState(() => _currencies.remove(currency));
      // TODO(m): حذف من CurrencyRepository/Isar
    }
  }

  void _setDefault(_Currency currency) {
    setState(() {
      for (final c in _currencies) {
        c.isDefault = c.id == currency.id;
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('✅ تم تعيين "${currency.name}" كعملة افتراضية')));
    // TODO(m): حفظ في CurrencyRepository/Isar
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.currency,
    required this.onEdit,
    this.onDelete,
    this.onSetDefault,
  });

  final _Currency currency;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(
      backgroundColor: currency.isDefault
          ? Colors.green.shade100
          : Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        currency.symbol,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: currency.isDefault ? Colors.green : Theme.of(context).colorScheme.primary,
        ),
      ),
    ),
    title: Row(
      children: [
        Text(currency.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        if (currency.isDefault) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'افتراضية',
              style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ],
    ),
    subtitle: Text('سعر الصرف: ${currency.rate.toStringAsFixed(4)}'),
    trailing: PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') onEdit();
        if (value == 'delete') onDelete?.call();
        if (value == 'default') onSetDefault?.call();
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'edit', child: Text('تعديل')),
        if (onSetDefault != null)
          const PopupMenuItem(value: 'default', child: Text('تعيين كافتراضية')),
        if (onDelete != null)
          const PopupMenuItem(
            value: 'delete',
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
      ],
    ),
  );
}

class _CurrencyFormDialog extends StatefulWidget {
  const _CurrencyFormDialog({this.existing});

  final _Currency? existing;

  @override
  State<_CurrencyFormDialog> createState() => _CurrencyFormDialogState();
}

class _CurrencyFormDialogState extends State<_CurrencyFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _symbolCtrl;
  late final TextEditingController _rateCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _symbolCtrl = TextEditingController(text: widget.existing?.symbol ?? '');
    _rateCtrl = TextEditingController(text: widget.existing?.rate.toString() ?? '1.0');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _symbolCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return AlertDialog(
      title: Text(isEdit ? 'تعديل العملة' : 'إضافة عملة جديدة'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'اسم العملة',
                border: OutlineInputBorder(),
                hintText: 'مثال: ريال سعودي',
              ),
              validator: (v) => v == null || v.isEmpty ? 'أدخل اسم العملة' : null,
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _symbolCtrl,
              decoration: const InputDecoration(
                labelText: 'رمز العملة',
                border: OutlineInputBorder(),
                hintText: 'مثال: ر.س',
              ),
              validator: (v) => v == null || v.isEmpty ? 'أدخل رمز العملة' : null,
            ),
            const SizedBox(height: Spacing.md),
            TextFormField(
              controller: _rateCtrl,
              decoration: const InputDecoration(
                labelText: 'سعر الصرف',
                border: OutlineInputBorder(),
                hintText: '1.0',
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'أدخل سعر الصرف';
                if (double.tryParse(v) == null) return 'قيمة غير صالحة';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.pop(
                context,
                _Currency(
                  id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameCtrl.text.trim(),
                  symbol: _symbolCtrl.text.trim(),
                  rate: double.parse(_rateCtrl.text),
                ),
              );
            }
          },
          child: Text(isEdit ? 'حفظ' : 'إضافة'),
        ),
      ],
    );
  }
}
