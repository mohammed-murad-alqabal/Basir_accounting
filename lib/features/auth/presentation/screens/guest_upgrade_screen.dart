import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ***
/// Cognitive Foundation: GuestUpgradeScreen
///
/// The transition interface for elevating unverified (Guest) identities to
/// permanent institutional status. Ensures data continuity while enforcing
/// strong credential policies during the elevation process.
/// ***
class GuestUpgradeScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة ترقية الحساب
  const GuestUpgradeScreen({super.key});

  @override
  ConsumerState<GuestUpgradeScreen> createState() => _GuestUpgradeScreenState();
}

class _GuestUpgradeScreenState extends ConsumerState<GuestUpgradeScreen> {
  final _formKey = GlobalKey<FormState>();
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
  Widget build(BuildContext context) {
    final appIcons = ref.watch(appIconsProvider);

    return GlassScaffold(
      title: context.l10n.actionUpgradeAccount,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Form(
          key: _formKey,
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
                prefixIcon: Icon(appIcons.person, size: IconSizes.sm),
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
                prefixIcon: Icon(appIcons.lock, size: IconSizes.sm),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.errEmptyField;
                  }
                  final passwordPolicy = RegExp(
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>]).{12,}$',
                  );
                  if (!passwordPolicy.hasMatch(value)) {
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
              AppEnhancedButton(
                width: double.infinity,
                label: context.l10n.actionUpgradeAccount,
                onPressed: _isLoading ? null : _handleUpgrade,
                isLoading: _isLoading,
                icon: appIcons.upgrade,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
