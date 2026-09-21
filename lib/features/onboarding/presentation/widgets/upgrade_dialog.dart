// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// 💎 نافذة الترقية والاشتراك
///
/// تعرض عند محاولة الوصول إلى ميزة مدفوعة.
/// مُنقولة ومُكيَّفة من Basir-accounting.
Future<void> showUpgradeDialog(BuildContext context, {String? featureName}) => showDialog(
  context: context,
  builder: (ctx) => _UpgradeDialog(featureName: featureName),
);

class _UpgradeDialog extends StatelessWidget {
  const _UpgradeDialog({this.featureName});

  final String? featureName;

  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    title: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.workspace_premium_outlined, size: 48, color: AppColors.primary),
        ),
        const SizedBox(height: Spacing.sm),
        const Text(
          'ميزة حصرية',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (featureName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.sm),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.xs),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Text(
                '🔒 $featureName',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
              ),
            ),
          ),
        const Text(
          'هذه الميزة للنسخة المفعّلة فقط\n'
          'احصل على نسختك المفعّلة وتمتّع بجميع الميزات:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: Spacing.md),
        _buildFeatureItem('✅ فواتير وتقارير غير محدودة'),
        _buildFeatureItem('✅ طباعة حرارية 58mm و80mm'),
        _buildFeatureItem('✅ نسخ احتياطي Google Drive'),
        _buildFeatureItem('✅ تقارير ZATCA و IFRS'),
        _buildFeatureItem('✅ إدارة متعددة للمستخدمين'),
        _buildFeatureItem('✅ تقرير الحركة اليومية'),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('المتابعة بالنسخة التجريبية'),
      ),
      FilledButton.icon(
        style: FilledButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
        icon: const Icon(Icons.shopping_cart_outlined),
        label: const Text('اشترك الآن'),
        onPressed: () async {
          Navigator.pop(context);
          // TODO(m): ربط برابط الاشتراك الفعلي
          final uri = Uri.parse('https://wa.me/967770493381');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      ),
    ],
  );

  Widget _buildFeatureItem(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        const SizedBox(width: Spacing.sm),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
      ],
    ),
  );
}
