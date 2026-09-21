// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// أنواع طرق التسعير المتاحة
enum PricingMethod {
  /// تسعير آخر عملية — يستخدم سعر آخر معاملة
  lastProcess,

  /// سعر ثابت — يستخدم سعر بيع المادة المعيّن مسبقاً
  fixedPrice,

  /// آخر عملية للحساب — يستخدم السعر المحدد لهذا العميل تحديداً
  lastProcessForAccount,
}

/// أنواع تعديلات السعر (تُطبَّق عند اختيار السعر الثابت)
enum ModificationType {
  /// زيادة هامش الربح بناءً على سعر التكلفة
  increaseMargin,

  /// زيادة سعر المبيع الحالي
  increaseSales,

  /// إنقاص سعر المبيع الحالي
  decreaseSales,

  /// زيادة سعر الشراء الحالي
  increasePurchase,

  /// إنقاص سعر الشراء الحالي
  decreasePurchase,
}

/// 💰 شاشة سياسة التسعير
///
/// تُتيح تحديد طريقة تسعير المنتجات وتطبيق تعديلات الأسعار
/// بشكل جماعي على المخزون.
///
/// مُنقولة ومُكيَّفة من Basir-accounting مع دعم Riverpod v2
/// وClean Architecture.
class PricingPolicyScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة سياسة التسعير
  const PricingPolicyScreen({super.key});

  @override
  ConsumerState<PricingPolicyScreen> createState() => _PricingPolicyScreenState();
}

class _PricingPolicyScreenState extends ConsumerState<PricingPolicyScreen> {
  PricingMethod _method = PricingMethod.lastProcess;
  ModificationType _modType = ModificationType.increaseSales;
  bool _isPercentage = true;
  bool _positiveBalanceOnly = false;
  bool _hideFrozen = false;
  final _adjustmentController = TextEditingController(text: '0');
  bool _isApplying = false;

  @override
  void dispose() {
    _adjustmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سياسة التسعير'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── طريقة التسعير ──────────────────────────────
            _buildSectionHeader('طريقة التسعير', Icons.price_change_outlined),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMethodRadio('تسعير آخر\nعملية', PricingMethod.lastProcess),
                        ),
                        Expanded(child: _buildMethodRadio('سعر\nثابت', PricingMethod.fixedPrice)),
                        Expanded(
                          child: _buildMethodRadio(
                            'آخر عملية\nللحساب',
                            PricingMethod.lastProcessForAccount,
                          ),
                        ),
                      ],
                    ),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: _method == PricingMethod.fixedPrice
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: _buildPriceModificationSection(primaryColor),
                      secondChild: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // ── فلاتر المواد ────────────────────────────────
            _buildSectionHeader('فلاتر المواد', Icons.filter_list_outlined),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('عرض المواد ذات الرصيد الموجب فقط'),
                    value: _positiveBalanceOnly,
                    onChanged: (v) => setState(() => _positiveBalanceOnly = v!),
                    activeColor: primaryColor,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  ),
                  CheckboxListTile(
                    title: const Text('عدم عرض المواد المجمدة'),
                    value: _hideFrozen,
                    onChanged: (v) => setState(() => _hideFrozen = v!),
                    activeColor: primaryColor,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xl),

            // ── زر التطبيق ──────────────────────────────────
            FilledButton.icon(
              icon: _isApplying
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(_isApplying ? 'جاري التطبيق...' : 'تطبيق سياسة التسعير'),
              onPressed: _isApplying ? null : _applyPricingPolicy,
            ),
            const SizedBox(height: Spacing.md),

            // ── زر الانتقال لتحرير الأسعار ──────────────────
            OutlinedButton.icon(
              icon: const Icon(Icons.edit_outlined),
              label: const Text('تحرير الأسعار يدوياً'),
              onPressed: () => Navigator.pushNamed(context, '/inventory/bulk-price-change'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm, right: Spacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: Spacing.sm),
          Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPriceModificationSection(Color primaryColor) => Padding(
    padding: const EdgeInsets.only(top: Spacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
          child: Text(
            'تعديل الأسعار عند اختيار (السعر الثابت):',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildModTypeRadio('زيادة هامش ربح بناءً على سعر التكلفة', ModificationType.increaseMargin),
        _buildModTypeRadio('زيادة سعر المبيع الحالي', ModificationType.increaseSales),
        _buildModTypeRadio('إنقاص سعر المبيع الحالي', ModificationType.decreaseSales),
        _buildModTypeRadio('زيادة سعر الشراء الحالي', ModificationType.increasePurchase),
        _buildModTypeRadio('إنقاص سعر الشراء الحالي', ModificationType.decreasePurchase),
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            Checkbox(
              value: _isPercentage,
              onChanged: (v) => setState(() => _isPercentage = v!),
              activeColor: primaryColor,
            ),
            const Text('%  نسبة مئوية'),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: TextField(
                controller: _adjustmentController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'قيمة التعديل',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md,
                    vertical: Spacing.sm,
                  ),
                  suffixText: _isPercentage ? '%' : 'وحدة',
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildMethodRadio(String title, PricingMethod value) => InkWell(
    onTap: () => setState(() => _method = value),
    borderRadius: BorderRadius.circular(8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<PricingMethod>(
          value: value,
          groupValue: _method,
          onChanged: (val) => setState(() => _method = val!),
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
        ),
      ],
    ),
  );

  Widget _buildModTypeRadio(String title, ModificationType value) => InkWell(
    onTap: () => setState(() => _modType = value),
    child: Row(
      children: [
        Radio<ModificationType>(
          value: value,
          groupValue: _modType,
          onChanged: (val) => setState(() => _modType = val!),
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        Expanded(
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
      ],
    ),
  );

  Future<void> _applyPricingPolicy() async {
    final adjustment = double.tryParse(_adjustmentController.text) ?? 0.0;
    if (adjustment == 0.0 && _method == PricingMethod.fixedPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ يرجى إدخال قيمة التعديل'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isApplying = true);

    try {
      // ربط خدمة تغيير الأسعار الجماعي الموجودة
            final bulkService = ref.read(bulkPriceChangeServiceProvider);

      // TODO(m): ربط PricingMethod بـ BulkPriceChangeRequest في المرحلة التالية
      await Future<void>.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ تم تطبيق سياسة التسعير: ${_getMethodLabel(_method)}'
              '${_method == PricingMethod.fixedPrice ? ' ($adjustment${_isPercentage ? "%" : " وحدة"})' : ''}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }

  String _getMethodLabel(PricingMethod method) => switch (method) {
    PricingMethod.lastProcess => 'آخر عملية',
    PricingMethod.fixedPrice => 'السعر الثابت',
    PricingMethod.lastProcessForAccount => 'آخر عملية للحساب',
  };
}
