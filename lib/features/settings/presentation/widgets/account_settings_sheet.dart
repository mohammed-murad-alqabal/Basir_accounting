import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/settings/presentation/providers/settings_controller.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// واجهة تعديل بيانات الحساب
class AccountSettingsSheet extends ConsumerStatefulWidget {
  /// إنشاء واجهة تعديل بيانات الحساب
  const AccountSettingsSheet({super.key, this.currentUsername});

  /// اسم المستخدم الحالي
  final String? currentUsername;

  /// عرض الواجهة
  static Future<void> show(BuildContext context, String? username) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AccountSettingsSheet(currentUsername: username),
      );

  @override
  ConsumerState<AccountSettingsSheet> createState() =>
      _AccountSettingsSheetState();
}

class _AccountSettingsSheetState extends ConsumerState<AccountSettingsSheet> {
  late final TextEditingController _usernameController;
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  bool _showPasswordFields = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.currentUsername);
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(settingsControllerProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Radii.xl),
        ),
      ),
      padding: EdgeInsets.only(
        top: Spacing.lg,
        left: Spacing.lg,
        right: Spacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + Spacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(Radii.full),
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            context.l10n.editAccountTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.lg),
          AppTextField(
            controller: _usernameController,
            label: context.l10n.labelUsername,
            hint: context.l10n.hintEnterNewUsername,
            prefixIcon: const Icon(Icons.person),
          ),
          const SizedBox(height: Spacing.md),
          if (!_showPasswordFields)
            TextButton.icon(
              onPressed: () => setState(() => _showPasswordFields = true),
              icon: const Icon(Icons.lock_reset),
              label: const Text('تغيير كلمة المرور'),
            )
          else ...[
            AppTextField(
              controller: _oldPasswordController,
              label: 'كلمة المرور القديمة',
              obscureText: true,
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _newPasswordController,
              label: context.l10n.labelNewPassword,
              hint: context.l10n.hintEnterNewPassword,
              obscureText: true,
              prefixIcon: const Icon(Icons.lock_open),
            ),
          ],
          const SizedBox(height: Spacing.xl),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: Text(
                state.error!,
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          AppEnhancedButton(
            width: double.infinity,
            label: context.l10n.dialogSave,
            isLoading: state.isLoading,
            onPressed: () async {
              final navigator = Navigator.of(context);
              final success = await ref
                  .read(settingsControllerProvider.notifier)
                  .updateAccount(
                    username: _usernameController.text.trim(),
                    oldPassword: _showPasswordFields
                        ? _oldPasswordController.text
                        : null,
                    newPassword: _showPasswordFields
                        ? _newPasswordController.text
                        : null,
                  );

              if (success && mounted) {
                navigator.pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
