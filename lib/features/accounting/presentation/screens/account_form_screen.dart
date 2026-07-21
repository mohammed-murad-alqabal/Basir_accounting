// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Form screen for creating or editing a Chart of Accounts entry.
class AccountFormScreen extends ConsumerStatefulWidget {
  /// Creates translated [AccountFormScreen].
  const AccountFormScreen({
    super.key,
    this.account,
    this.initialParentId,
  });

  /// Existing account to edit, or null for creation.
  final Account? account;

  /// Optional pre-selected parent account.
  final String? initialParentId;

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;
  late TextEditingController _codeController;

  AccountType _selectedType = AccountType.asset;
  AccountNature _selectedNature = AccountNature.debit;
  String? _selectedParentId;
  Ifrs18Category _selectedIfrsCategory = Ifrs18Category.none;
  bool _isParent = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameArController =
        TextEditingController(text: widget.account?.nameAr ?? '');
    _nameEnController =
        TextEditingController(text: widget.account?.nameEn ?? '');
    _codeController = TextEditingController(text: widget.account?.code ?? '');

    if (widget.account != null) {
      _selectedType = widget.account!.type;
      _selectedNature = widget.account!.nature;
      _selectedParentId = widget.account!.parentId;
      _selectedIfrsCategory =
          widget.account!.ifrs18Category ?? Ifrs18Category.none;
      _isParent = widget.account!.isParent;
    } else {
      _selectedParentId = widget.initialParentId;
    }
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(getAccountsProvider);

    return GlassScaffold(
      title: widget.account == null ? 'إضافة حساب جديد' : 'تعديل حساب',
      body: _isLoading
          ? const Center(child: AppLoadingIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNameFields(),
                    const SizedBox(height: Spacing.md),
                    _buildTypeAndNature(),
                    const SizedBox(height: Spacing.md),
                    _buildHierarchySelection(accountsAsync),
                    const SizedBox(height: Spacing.md),
                    _buildCodeField(),
                    const SizedBox(height: Spacing.md),
                    _buildIfrsMapping(),
                    const SizedBox(height: Spacing.xl),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildNameFields() => Column(
        children: [
          AppTextField(
            controller: _nameArController,
            label: 'الاسم (بالعربية)',
            validator: (v) => v!.isEmpty ? 'يرجى إدخال الاسم بالعربية' : null,
          ),
          const SizedBox(height: Spacing.md),
          AppTextField(
            controller: _nameEnController,
            label: 'Name (English)',
            validator: (v) =>
                v!.isEmpty ? 'Please enter name in English' : null,
          ),
        ],
      );

  Widget _buildTypeAndNature() => Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<AccountType>(
              initialValue: _selectedType,
              decoration: const InputDecoration(labelText: 'نوع الحساب'),
              items: AccountType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                  .toList(),
              onChanged: widget.account?.isSystem ?? false
                  ? null
                  : (val) {
                      if (val != null) {
                        setState(() {
                          _selectedType = val;
                          _selectedNature = (val == AccountType.asset ||
                                  val == AccountType.expense)
                              ? AccountNature.debit
                              : AccountNature.credit;
                        });
                      }
                    },
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: DropdownButtonFormField<AccountNature>(
              initialValue: _selectedNature,
              decoration: const InputDecoration(labelText: 'طبيعة الحساب'),
              items: AccountNature.values
                  .map((n) => DropdownMenuItem(value: n, child: Text(n.name)))
                  .toList(),
              onChanged: widget.account?.isSystem ?? false
                  ? null
                  : (val) {
                      if (val != null) setState(() => _selectedNature = val);
                    },
            ),
          ),
        ],
      );

  Widget _buildHierarchySelection(AsyncValue<List<Account>> accountsAsync) =>
      accountsAsync.when(
        data: (accounts) {
          final parentOptions = accounts.where((a) => a.isParent).toList();
          return Column(
            children: [
              DropdownButtonFormField<String?>(
                initialValue: _selectedParentId,
                decoration: const InputDecoration(labelText: 'الحساب الأب'),
                items: [
                  const DropdownMenuItem(child: Text('جذر (لا يوجد أب)')),
                  ...parentOptions.map(
                    (a) => DropdownMenuItem(
                      value: a.id,
                      child: Text('${a.code} - ${a.nameAr}'),
                    ),
                  ),
                ],
                onChanged: widget.account?.isSystem ?? false
                    ? null
                    : (val) async {
                        setState(() => _selectedParentId = val);
                        if (val != null) {
                          final parent =
                              accounts.firstWhere((a) => a.id == val);
                          setState(() {
                            _selectedType = parent.type;
                            _selectedNature = parent.nature;
                          });
                          await _suggestNextCode(val, accounts);
                        }
                      },
              ),
              const SizedBox(height: Spacing.sm),
              CheckboxListTile(
                title:
                    const Text('هل هذا حساب رئيسي؟ (يحتوي على حسابات تابعة)'),
                value: _isParent,
                onChanged: (val) => setState(() => _isParent = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          );
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (_, __) => AppErrorWidget(
          message: 'خطأ في تحميل الحسابات',
          onRetry: () => ref.invalidate(getAccountsProvider),
        ),
      );

  Widget _buildCodeField() => AppTextField(
        controller: _codeController,
        label: 'رمز الحساب (Code)',
        keyboardType: TextInputType.number,
        validator: (v) => v!.isEmpty ? 'يرجى إدخال رمز الحساب' : null,
      );

  Widget _buildIfrsMapping() => DropdownButtonFormField<Ifrs18Category>(
        initialValue: _selectedIfrsCategory,
        decoration: const InputDecoration(labelText: 'تصنيف IFRS 18'),
        items: Ifrs18Category.values
            .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
            .toList(),
        onChanged: (val) {
          if (val != null) setState(() => _selectedIfrsCategory = val);
        },
      );

  Widget _buildSubmitButton() => AppEnhancedButton(
        label: widget.account == null ? 'إنشاء حساب' : 'حفظ التعديلات',
        onPressed: _saveAccount,
        isLoading: _isLoading,
      );

  Future<void> _suggestNextCode(
    String parentId,
    List<Account> allAccounts,
  ) async {
    final children = allAccounts.where((a) => a.parentId == parentId).toList();
    final parent = allAccounts.firstWhere((a) => a.id == parentId);

    if (children.isEmpty) {
      _codeController.text = '${parent.code}01';
    } else {
      children.sort((a, b) => b.code.compareTo(a.code));
      final lastCode = children.first.code;
      try {
        final lastNum = int.parse(lastCode);
        _codeController.text = (lastNum + 1).toString();
      } on FormatException catch (_) {
        _codeController.text = '${parent.code}${children.length + 1}';
      }
    }
  }

  Future<void> _saveAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final service = ref.read(accountingServiceProvider.notifier);
      final accountId = widget.account?.id ?? const Uuid().v4();

      final account = Account(
        id: accountId,
        code: _codeController.text,
        nameAr: _nameArController.text,
        nameEn: _nameEnController.text,
        type: _selectedType,
        nature: _selectedNature,
        balance: widget.account?.balance ?? Decimal.zero,
        parentId: _selectedParentId,
        isParent: _isParent,
        ifrs18Category: _selectedIfrsCategory,
        isSystem: widget.account?.isSystem ?? false,
      );

      if (widget.account == null) {
        await service.addAccount(account);
      } else {
        await service.updateAccount(account);
      }

      if (mounted) Navigator.pop(context);
    } on Exception {
      if (mounted) {
        AppSnackbar.showError(context, 'خطأ أثناء الحفظ');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
