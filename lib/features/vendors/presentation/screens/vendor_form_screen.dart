import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';
import 'package:basir_accounting_system/features/vendors/presentation/providers/vendor_provider.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// شاشة إضافة/تعديل مورد (Vendor Form Screen)
class VendorFormScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة نموذج المورد
  const VendorFormScreen({super.key, this.vendor});

  /// المورد المراد تعديله (إن وجد)
  final Vendor? vendor;

  @override
  ConsumerState<VendorFormScreen> createState() => _VendorFormScreenState();
}

class _VendorFormScreenState extends ConsumerState<VendorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _vatController;
  late TextEditingController _registrationController;

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(
      text: widget.vendor?.nameAr ?? '',
    );
    _nameEnController = TextEditingController(
      text: widget.vendor?.nameEn ?? '',
    );
    _emailController = TextEditingController(text: widget.vendor?.email ?? '');
    _phoneController = TextEditingController(text: widget.vendor?.phone ?? '');
    _vatController =
        TextEditingController(text: widget.vendor?.vatNumber ?? '');
    _registrationController = TextEditingController(
      text: widget.vendor?.registrationNumber ?? '',
    );
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _vatController.dispose();
    _registrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.vendor != null;

    return GlassScaffold(
      title:
          isEdit ? context.l10n.titleEditVendor : context.l10n.titleAddVendor,
      actions: const [],
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.lg),
          children: [
            // الاسم بالعربية
            AppTextField(
              controller: _nameArController,
              label: context.l10n.labelNameAr,
              hint: 'مثال: شركة التوريدات المحدودة',
              validator: (value) =>
                  value?.isEmpty ?? true ? context.l10n.errEmptyField : null,
              prefixIcon: const Icon(Icons.business),
            ),
            const SizedBox(height: Spacing.md),

            // الاسم بالإنجليزية
            AppTextField(
              controller: _nameEnController,
              label: context.l10n.labelNameEn,
              hint: 'Example: Supply Co. Ltd',
              validator: (value) =>
                  value?.isEmpty ?? true ? context.l10n.errEmptyField : null,
              prefixIcon: const Icon(Icons.business_outlined),
            ),
            const SizedBox(height: Spacing.md),

            // البريد الإلكتروني
            AppTextField(
              controller: _emailController,
              label: context.l10n.labelEmail,
              hint: 'example@company.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: Spacing.md),

            // رقم الهاتف
            AppTextField(
              controller: _phoneController,
              label: context.l10n.labelPhone,
              hint: '05xxxxxxxx',
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone),
            ),
            const SizedBox(height: Spacing.md),

            // الرقم الضريبي
            AppTextField(
              controller: _vatController,
              label: context.l10n.labelVatNumber,
              hint: '3xxxxxxxxxxxxxx',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.description),
            ),
            const SizedBox(height: Spacing.md),

            // رقم السجل التجاري
            AppTextField(
              controller: _registrationController,
              label: context.l10n.labelRegistrationNumber,
              hint: '10xxxxxxxx',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.app_registration),
            ),
            const SizedBox(height: Spacing.xl),

            // زر الحفظ
            AppEnhancedButton(label: context.l10n.btnSave, onPressed: _save),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final vendor = widget.vendor?.copyWith(
          nameAr: _nameArController.text,
          nameEn: _nameEnController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          vatNumber: _vatController.text,
          registrationNumber: _registrationController.text,
          updatedAt: DateTime.now(),
        ) ??
        Vendor(
          id: const Uuid().v4(),
          nameAr: _nameArController.text,
          nameEn: _nameEnController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          vatNumber: _vatController.text,
          registrationNumber: _registrationController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

    try {
      if (widget.vendor != null) {
        await ref.read(vendorsProvider.notifier).updateVendor(vendor);
      } else {
        await ref.read(vendorsProvider.notifier).addVendor(vendor);
      }
      if (mounted) Navigator.pop(context, true);
    } on Object catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, e.toString());
      }
    }
  }
}
