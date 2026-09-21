import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessSettingsScreen extends ConsumerStatefulWidget {
  const BusinessSettingsScreen({super.key});

  @override
  ConsumerState<BusinessSettingsScreen> createState() => _BusinessSettingsScreenState();
}

class _BusinessSettingsScreenState extends ConsumerState<BusinessSettingsScreen> {
  final _companyNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _taxNumberController = TextEditingController();
  final _logoUrlController = TextEditingController();
  final _defaultTaxRateController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _taxNumberController.dispose();
    _logoUrlController.dispose();
    _defaultTaxRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
    title: 'إعدادات الشركة',
    actions: const [],
    body: ListView(
      padding: const EdgeInsets.all(Spacing.md),
      children: [
        TextField(
          controller: _companyNameController,
          decoration: const InputDecoration(labelText: 'اسم الشركة'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'رقم الهاتف'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: 'العنوان'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _taxNumberController,
          decoration: const InputDecoration(labelText: 'الرقم الضريبي'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _logoUrlController,
          decoration: const InputDecoration(labelText: 'رابط الشعار (Logo URL)'),
        ),
        const SizedBox(height: Spacing.md),
        TextField(
          controller: _defaultTaxRateController,
          decoration: const InputDecoration(labelText: 'نسبة الضريبة الافتراضية'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: Spacing.lg),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('تم الحفظ بنجاح')));
          },
          child: const Text('حفظ'),
        ),
      ],
    ),
  );
}
