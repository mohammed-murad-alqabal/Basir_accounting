import 'package:basir_accounting_system/core/assets/app_logo.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Setup Screen
/// Create your account to start using Basir Accounting
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSetup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // إنشاء الحساب الفعلي باستخدام AuthService
      await ref
          .read(authServiceProvider)
          .createAccount(_usernameController.text, _passwordController.text);

      if (!mounted) return;

      AppSnackbar.showSuccess(context, context.l10n.msgAccountCreated);

      // الانتقال إلى لوحة التحكم
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
              context.l10n.setupTitle,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeights.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              context.l10n.setupSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: Spacing.xl),

            // Setup Form
            Form(
              key: _formKey,
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
                      if (value.length < 3) {
                        return context.l10n.errUsernameShort;
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
                      if (value.length < 6) {
                        return context.l10n.errPasswordShort;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.lg),

                  AppEnhancedButton(
                    width: double.infinity,
                    label: context.l10n.btnCreateAccount,
                    onPressed: _handleSetup,
                    isLoading: _isLoading,
                    icon: appIcons.userAdd,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
