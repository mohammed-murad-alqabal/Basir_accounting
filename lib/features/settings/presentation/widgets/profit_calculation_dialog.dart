// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// طريقة احتساب الربح
enum ProfitCalculationMethod {
  /// الطريقة القديمة — تسمح ببيع المواد بكمية سالبة
  legacy,

  /// الطريقة الحديثة — لا تسمح بالكميات السالبة (موصى بها)
  modern,
}

/// مزود طريقة احتساب الربح
final profitMethodProvider = StateNotifierProvider<ProfitMethodNotifier, ProfitCalculationMethod>(
  (ref) => ProfitMethodNotifier(),
);

/// مُدير حالة طريقة احتساب الربح
class ProfitMethodNotifier extends StateNotifier<ProfitCalculationMethod> {
  ProfitMethodNotifier() : super(ProfitCalculationMethod.modern) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final isLegacy = prefs.getBool('profit_method_legacy') ?? false;
    state = isLegacy ? ProfitCalculationMethod.legacy : ProfitCalculationMethod.modern;
  }

  /// تحديث طريقة الاحتساب وحفظها
  Future<void> setMethod(ProfitCalculationMethod method) async {
    state = method;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profit_method_legacy', method == ProfitCalculationMethod.legacy);
  }
}

/// 💡 حوار اختيار طريقة احتساب الربح
///
/// مُنقول ومُكيَّف من Basir-accounting.
/// يُعرض من شاشة الإعدادات.
Future<void> showProfitCalculationDialog(BuildContext context) =>
    showDialog(context: context, builder: (ctx) => const _ProfitCalculationDialog());

class _ProfitCalculationDialog extends ConsumerWidget {
  const _ProfitCalculationDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMethod = ref.watch(profitMethodProvider);

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.calculate_outlined),
          SizedBox(width: Spacing.sm),
          Text('طريقة احتساب الربح'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'اختر الطريقة المناسبة لحساب أرباح المبيعات:',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: Spacing.md),
          _MethodTile(
            title: '🆕 الطريقة الحديثة (موصى بها)',
            subtitle: 'لا تسمح ببيع كميات سالبة — أكثر دقةً ومصداقيةً',
            value: ProfitCalculationMethod.modern,
            groupValue: currentMethod,
            onChanged: (val) => ref.read(profitMethodProvider.notifier).setMethod(val!),
          ),
          const Divider(height: 1),
          _MethodTile(
            title: '🕰 الطريقة القديمة',
            subtitle: 'تسمح ببيع مواد بكميات سالبة (للأنظمة القديمة)',
            value: ProfitCalculationMethod.legacy,
            groupValue: currentMethod,
            onChanged: (val) => ref.read(profitMethodProvider.notifier).setMethod(val!),
          ),
          if (currentMethod == ProfitCalculationMethod.legacy)
            Container(
              margin: const EdgeInsets.only(top: Spacing.md),
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_outlined, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تحذير: الطريقة القديمة قد تعطي أرقام ربح غير دقيقة',
                      style: TextStyle(fontSize: 11, color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '✅ تم الحفظ: ${currentMethod == ProfitCalculationMethod.modern ? "الطريقة الحديثة" : "الطريقة القديمة"}',
                ),
              ),
            );
          },
          child: const Text('تأكيد'),
        ),
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final ProfitCalculationMethod value;
  final ProfitCalculationMethod groupValue;
  final ValueChanged<ProfitCalculationMethod?> onChanged;

  @override
  Widget build(BuildContext context) => RadioListTile<ProfitCalculationMethod>(
    title: Text(title, style: const TextStyle(fontSize: 13)),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
    value: value,
    groupValue: groupValue,
    onChanged: onChanged,
    activeColor: Theme.of(context).colorScheme.primary,
  );
}
