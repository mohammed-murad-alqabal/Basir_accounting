import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/vendors/domain/entities/vendor.dart';
import 'package:basir_app/features/vendors/presentation/providers/vendor_provider.dart';
import 'package:basir_app/shared/widgets/index.dart';
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

  @override
  void initState() {
    super.initState();
    _nameArController =
        TextEditingController(text: widget.vendor?.nameAr ?? '');
    _nameEnController =
        TextEditingController(text: widget.vendor?.nameEn ?? '');
    _emailController = TextEditingController(text: widget.vendor?.email ?? '');
    _phoneController = TextEditingController(text: widget.vendor?.phone ?? '');
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.vendor != null;

    return Scaffold(
      appBar: AppAppBar(
        title:
            isEdit ? context.l10n.titleEditVendor : context.l10n.titleAddVendor,
      ),
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
            const SizedBox(height: Spacing.xl),

            // زر الحفظ
            AppButton(
              label: context.l10n.btnSave,
              onPressed: _save,
            ),
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
          updatedAt: DateTime.now(),
        ) ??
        Vendor(
          id: const Uuid().v4(),
          nameAr: _nameArController.text,
          nameEn: _nameEnController.text,
          email: _emailController.text,
          phone: _phoneController.text,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
