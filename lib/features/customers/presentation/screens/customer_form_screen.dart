import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/presentation/providers/customer_provider.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// شاشة إضافة/تعديل عميل
///
/// تسمح بإضافة عميل جديد أو تعديل عميل موجود.
class CustomerFormScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة نموذج العميل
  const CustomerFormScreen({super.key, this.customer});

  /// العميل المراد تعديله (null للإضافة)
  final Customer? customer;

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _creditLimitController = TextEditingController(text: '0.0');

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameArController.text = widget.customer!.nameAr;
      _nameEnController.text = widget.customer!.nameEn;
      _emailController.text = widget.customer!.email ?? '';
      _phoneController.text = widget.customer!.phone ?? '';
      _addressController.text = widget.customer!.address ?? '';
      _notesController.text = widget.customer!.notes ?? '';
      _creditLimitController.text = widget.customer!.creditLimit.toString();
    }
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.customer != null;
    final appIcons = ref.watch(appIconsProvider);

    return GlassScaffold(
      title: isEditing
          ? context.l10n.customerFormTitleEdit
          : context.l10n.customerFormTitleAdd,
      actions: const [],
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // زر اختيار من جهات الاتصال
              if (!isEditing)
                AppEnhancedButton(
                  label: context.l10n.btnSelectFromContacts,
                  onPressed: _selectFromContacts,
                  icon: appIcons.users,
                  type: AppEnhancedButtonType.secondary,
                  width: double.infinity,
                ),
              if (!isEditing) const SizedBox(height: Spacing.md),

              // اسم العميل بالعربية
              AppTextField(
                controller: _nameArController,
                label: '${context.l10n.labelCustomerName} (العربية)',
                hint: context.l10n.hintCustomerName,
                prefixIcon: Icon(appIcons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.errCustomerNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.md),

              // اسم العميل بالإنجليزية
              AppTextField(
                controller: _nameEnController,
                label: '${context.l10n.labelCustomerName} (English)',
                hint: 'Customer Name in English',
                prefixIcon: Icon(appIcons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.errCustomerNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.md),

              // البريد الإلكتروني
              AppTextField(
                controller: _emailController,
                label: context.l10n.labelEmailOptional,
                hint: 'example@email.com',
                prefixIcon: Icon(appIcons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return context.l10n.errInvalidEmail;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.md),

              // رقم الهاتف
              AppTextField(
                controller: _phoneController,
                label: context.l10n.labelPhoneOptional,
                hint: '05xxxxxxxx',
                prefixIcon: Icon(appIcons.phone),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!value.startsWith('05')) {
                      return context.l10n.errPhoneStart05;
                    }
                    if (value.length != 10) {
                      return context.l10n.errPhoneLength;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.md),

              // العنوان
              AppTextField(
                controller: _addressController,
                label: context.l10n.labelAddressOptional,
                hint: context.l10n.hintAddress,
                prefixIcon: Icon(appIcons.location),
                maxLines: 2,
              ),
              const SizedBox(height: Spacing.md),

              // ملاحظات
              AppTextField(
                controller: _notesController,
                label: context.l10n.labelNotesOptional,
                hint: context.l10n.hintCustomerNotes,
                prefixIcon: Icon(appIcons.note),
                maxLines: 3,
              ),
              const SizedBox(height: Spacing.md),

              // سقف الائتمان
              AppTextField(
                controller: _creditLimitController,
                label: context.l10n.labelCreditLimit,
                hint: '0.0',
                prefixIcon: Icon(appIcons.accounting),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return context.l10n.errInvalidNumber;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: Spacing.xl),

              // زر الحفظ
              AppEnhancedButton(
                label: isEditing
                    ? context.l10n.customerFormTitleEdit
                    : context.l10n.customerFormTitleAdd,
                onPressed: _isLoading ? null : _saveCustomer,
                isLoading: _isLoading,
                icon: appIcons.save,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectFromContacts() async {
    final contactService = ref.read(contactServiceProvider);
    try {
      final contacts = await contactService.getContacts();
      if (contacts.isEmpty) {
        if (!mounted) return;
        AppSnackbar.showInfo(context, context.l10n.msgNoContactsFound);
        return;
      }

      if (!mounted) return;
      final dynamic result = await showModalBottomSheet<dynamic>(
        context: context,
        builder: (context) {
          final appIcons = ref.watch(appIconsProvider);
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                leading: Icon(appIcons.person),
                title: Text('${contact.name.first} ${contact.name.last}'),
                subtitle: Text(
                  contact.phones.isNotEmpty ? contact.phones.first.number : '',
                ),
                onTap: () => Navigator.pop(context, contact),
              );
            },
          );
        },
      );

      if (result != null && result is Contact) {
        final selectedContact = result;
        setState(() {
          _nameArController.text = '${selectedContact.name.first} '
              '${selectedContact.name.last}';
          _nameEnController.text = '${selectedContact.name.first} '
              '${selectedContact.name.last}';
          if (selectedContact.phones.isNotEmpty) {
            _phoneController.text = selectedContact.phones.first.number;
          }
          if (selectedContact.emails.isNotEmpty) {
            _emailController.text = selectedContact.emails.first.address;
          }
        });
      }
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(
        context,
        context.l10n.errContactAccess(e.toString()),
      );
    }
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
        nameAr: _nameArController.text.trim(),
        nameEn: _nameEnController.text.trim(),
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
        creditLimit: double.tryParse(_creditLimitController.text) ?? 0.0,
        balance: widget.customer?.balance ?? 0.0,
        createdAt: widget.customer?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final isEditing = widget.customer != null;
      final result = isEditing
          ? await ref.read(updateCustomerProvider(customer).future)
          : await ref.read(addCustomerProvider(customer).future);

      if (!mounted) return;

      if (result) {
        AppSnackbar.showSuccess(
          context,
          isEditing
              ? context.l10n.msgCustomerUpdated
              : context.l10n.msgCustomerAdded,
        );
        Navigator.pop(context, true);
      } else {
        AppSnackbar.showError(
          context,
          isEditing
              ? context.l10n.errCustomerUpdate
              : context.l10n.errCustomerAdd,
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, context.l10n.errGeneric(e.toString()));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
