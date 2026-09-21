import 'dart:async';

import 'package:basir_accounting_system/core/assets/app_logo.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Login Screen
/// Simple authentication interface for users
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await ref
          .read(authServiceProvider)
          .login(_usernameController.text, _passwordController.text);

      if (!success) {
        if (!mounted) return;
        throw Exception(context.l10n.errLoginFailed);
      }

      if (!mounted) return;

      AppSnackbar.showSuccess(context, context.l10n.msgLoginSuccess);

      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed('/dashboard');
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, context.l10n.errGeneric(e.toString()));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appIcons = ref.watch(appIconsProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: Spacing.xl),

            // Logo
            Semantics(
              label: context.l10n.dashboardBasirSystemTitle,
              image: true,
              child: const BasirLogo(size: 100),
            ),
            const SizedBox(height: Spacing.lg),

            // Title
            Text(
              context.l10n.loginTitle,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeights.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              context.l10n.loginSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: Spacing.xl),

            // Login Form
            Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Column(
                children: [
                  AppTextField(
                    label: context.l10n.labelUsername,
                    hint: context.l10n.hintEnterUsername,
                    controller: _usernameController,
                    prefixIcon: Icon(appIcons.person, size: IconSizes.sm),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.errEmptyField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.lg),

                  AppTextField(
                    label: context.l10n.labelPassword,
                    hint: context.l10n.hintEnterPassword,
                    controller: _passwordController,
                    obscureText: true,
                    prefixIcon: Icon(appIcons.lock, size: IconSizes.sm),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.errEmptyField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.lg),

                  AppEnhancedButton(
                    width: double.infinity,
                    label: context.l10n.loginTitle,
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                    icon: appIcons.login,
                  ),
                  const SizedBox(height: Spacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
