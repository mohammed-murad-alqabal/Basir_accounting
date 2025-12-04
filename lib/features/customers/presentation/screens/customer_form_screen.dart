import 'dart:async';

import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// شاشة إضافة/تعديل عميل
///
/// تسمح بإضافة عميل جديد أو تعديل عميل موجود.
class CustomerFormScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة نموذج العميل
  const CustomerFormScreen({
    super.key,
    this.customer,
  });

  /// العميل المراد تعديله (null للإضافة)
  final Customer? customer;

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameController.text = widget.customer!.name;
      _emailController.text = widget.customer!.email ?? '';
      _phoneController.text = widget.customer!.phone ?? '';
      _addressController.text = widget.customer!.address ?? '';
      _notesController.text = widget.customer!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.customer != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: isEditing ? 'تعديل العميل' : 'إضافة عميل جديد',
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // اسم العميل
              AppTextField(
                controller: _nameController,
                label: 'اسم العميل',
                hint: 'أدخل اسم العميل',
                prefixIcon: const Icon(Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'اسم العميل مطلوب';
                  }
                  if (value.length < 2) {
                    return 'الاسم يجب أن يحتوي على حرفين على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // البريد الإلكتروني
              AppTextField(
                controller: _emailController,
                label: 'البريد الإلكتروني (اختياري)',
                hint: 'example@email.com',
                prefixIcon: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'البريد الإلكتروني غير صحيح';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // رقم الهاتف
              AppTextField(
                controller: _phoneController,
                label: 'رقم الهاتف (اختياري)',
                hint: '05xxxxxxxx',
                prefixIcon: const Icon(Icons.phone),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!value.startsWith('05')) {
                      return 'رقم الهاتف يجب أن يبدأ بـ 05';
                    }
                    if (value.length != 10) {
                      return 'رقم الهاتف يجب أن يتكون من 10 أرقام';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // العنوان
              AppTextField(
                controller: _addressController,
                label: 'العنوان (اختياري)',
                hint: 'أدخل عنوان العميل',
                prefixIcon: const Icon(Icons.location_on),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.md),

              // ملاحظات
              AppTextField(
                controller: _notesController,
                label: 'ملاحظات (اختياري)',
                hint: 'أضف ملاحظات عن العميل',
                prefixIcon: const Icon(Icons.note),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),

              // زر الحفظ
              AppPrimaryButton(
                label: isEditing ? 'حفظ التعديلات' : 'إضافة العميل',
                onPressed: _isLoading ? null : _saveCustomer,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCustomer() {
    unawaited(_saveCustomerAsync());
  }

  Future<void> _saveCustomerAsync() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final customer = Customer(
        id: widget.customer?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: widget.customer?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final isEditing = widget.customer != null;
      final result = isEditing
          ? await ref.read(updateCustomerProvider(customer).future)
          : await ref.read(addCustomerProvider(customer).future);

      if (!mounted) return;

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'تم تحديث بيانات العميل بنجاح'
                  : 'تم إضافة العميل بنجاح',
            ),
            backgroundColor: AppColors.secondary,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'فشل تحديث بيانات العميل' : 'فشل إضافة العميل',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
