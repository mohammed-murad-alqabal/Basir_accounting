import 'dart:async';

import 'package:basser_app/core/extensions/context_extensions.dart';
import 'package:basser_app/core/providers.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة ترقية حساب الضيف (Guest Upgrade Screen)
///
/// تتيح للمستخدم تحويل حساب الضيف إلى حساب دائم
class GuestUpgradeScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة ترقية الحساب
  const GuestUpgradeScreen({super.key});

  @override
  ConsumerState<GuestUpgradeScreen> createState() => _GuestUpgradeScreenState();
}

class _GuestUpgradeScreenState extends ConsumerState<GuestUpgradeScreen> {
  final _formKey = <credential-fixture><FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleUpgrade() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authServiceProvider).convertGuestToUser(
            _usernameController.text.trim(),
            _passwordController.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.msgAccountUpgraded)),
        );
        // Navigate back or to home
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppAppBar(title: context.l10n.actionUpgradeAccount),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Form(
            key: <credential-fixture>,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.guestUpgradeDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: Spacing.xl),
                AppTextField(
                  controller: _usernameController,
                  label: context.l10n.labelUsername,
                  hint: context.l10n.hintEnterUsername,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.errEmptyField;
                    }
                    if (value.length < 3) {
                      return context.l10n.errUsernameShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Spacing.lg),
                AppTextField(
                  controller: _passwordController,
                  label: context.l10n.labelPassword,
                  hint: context.l10n.hintEnterPassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.errEmptyField;
                    }
                    if (value.length < 6) {
                      return context.l10n.errPasswordShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: Spacing.xl),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.lg),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                AppPrimaryButton(
                  label: context.l10n.actionUpgradeAccount,
                  onPressed: _isLoading ? null : _handleUpgrade,
                  isLoading: _isLoading,
                  icon: Icons.upgrade,
                ),
              ],
            ),
          ),
        ),
      );
}
