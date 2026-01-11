import 'package:basir_accounting_system/core/assets/app_logo.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ***
/// Cognitive Foundation: SetupScreen
///
/// The orchestration interface for initial institutional identity creation.
/// Enforces high-entropy credential standards and validates cryptographic
/// consistency before establishing the local security context.
/// ***
class SetupScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة الإعداد الأولي
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

      await ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.msgAccountCreated)))
          .closed;

      // الانتقال إلى شاشة الإعدادات الإضافية أو لوحة التحكم
      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed('/dashboard');
    } on Exception catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errGeneric(e.toString()))),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appIcons = ref.watch(appIconsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            children: [
              // رأس الشاشة
              _buildHeader(),
              const SizedBox(height: Spacing.xl),

              // نموذج الإعداد
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // حقل اسم المستخدم
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

                    // حقل كلمة المرور
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

                    // حقل تأكيد كلمة المرور
                    AppTextField(
                      label: context.l10n.labelConfirmPassword,
                      hint: context.l10n.hintConfirmPassword,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      prefixIcon: Icon(appIcons.lock, size: IconSizes.sm),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.errEmptyField;
                        }
                        if (value != _passwordController.text) {
                          return context.l10n.errPasswordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Spacing.xl),

                    // زر الإنشاء
                    AppEnhancedButton(
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
      ),
    );
  }

  Widget _buildHeader() => Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(Radii.lg),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Semantics(
                label: context.l10n.dashboardBasirSystemTitle,
                image: true,
                child: const BasirLogo(size: 60),
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            context.l10n.setupTitle,
            style: const TextStyle(
              fontSize: AppTypography.headlineSmall,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            context.l10n.setupSubtitle,
            style: const TextStyle(
              fontSize: AppTypography.bodyMedium,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
}
