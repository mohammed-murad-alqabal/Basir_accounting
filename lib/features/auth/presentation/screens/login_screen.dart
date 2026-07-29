import 'dart:async';

import 'package:basir_accounting_system/core/assets/app_logo.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ***
/// Cognitive Foundation: LoginScreen
///
/// The primary interface for institutional identity verification.
/// Implements dual-path authentication:
/// 1. Hardware-stretching credentials (Username/Password).
/// 2. Transient guest-mode fallback for unverified operations.
///
/// Features accessibility compliance (Semantics) and high-fidelity UX.
/// ***
class LoginScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة تسجيل الدخول
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _keepLoggedIn = true;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;
    // تفعيل validation عند أول محاولة
    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // تسجيل الدخول الفعلي باستخدام AuthService
      final success = await ref
          .read(authServiceProvider)
          .login(_usernameController.text, _passwordController.text);

      if (!success) {
        if (!mounted) return;
        throw Exception(context.l10n.errLoginFailed);
      }

      if (!mounted) return;

      // حفظ حالة "البقاء مسجلاً" إذا تم اختيارها
      if (_keepLoggedIn) {
        await ref.read(authServiceProvider).setKeepLoggedIn(keepLoggedIn: true);
      }

      if (!mounted) return;

      AppSnackbar.showSuccess(context, context.l10n.msgLoginSuccess);

      // الانتقال إلى لوحة التحكم
      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed('/mfa-gate');
    } on Exception catch (e) {
      if (!mounted) return;

      AppSnackbar.showError(context, context.l10n.errGeneric(e.toString()));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGuestLogin() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // تسجيل الدخول كضيف بشكل فوري (إزالة التأخير غير الضروري)
      await ref.read(authServiceProvider).loginAsGuest();

      if (!mounted) return;

      AppSnackbar.showSuccess(context, context.l10n.msgGuestWelcome);

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

    return GlassScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            // رأس الشاشة (Header)
            _buildHeader(colorScheme),
            const SizedBox(height: Spacing.xl),

            // نموذج تسجيل الدخول
            Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
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
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.md),

                  // خيار تذكرني
                  Row(
                    children: [
                      Checkbox(
                        value: _keepLoggedIn,
                        activeColor: colorScheme.primary,
                        onChanged: (value) {
                          setState(() => _keepLoggedIn = value ?? true);
                        },
                      ),
                      Text(
                        context.l10n.labelRememberMe,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      // رابط نسيت كلمة المرور
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pushNamed(
                                  '/forgot-password',
                                ),
                        child: Text(
                          context.l10n.forgotPassword,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),

                  // أزرار الإجراءات
                  // أزرار الإجراءات
                  AppEnhancedButton(
                    width: double.infinity,
                    label: context.l10n.loginTitle,
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                    icon: appIcons.login,
                  ),
                  const SizedBox(height: Spacing.md),

                  AppEnhancedButton(
                    type: AppEnhancedButtonType.secondary,
                    width: double.infinity,
                    label: context.l10n.loginGuest,
                    onPressed: _isLoading ? null : _handleGuestLogin,
                    isLoading: _isLoading,
                    icon: appIcons.person,
                  ),
                  const SizedBox(height: Spacing.xl),

                  // إنشاء حساب جديد
                  Center(
                    child: Column(
                      children: [
                        Text(
                          context.l10n.msgNoAccount,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        AppEnhancedButton(
                          type: AppEnhancedButtonType.text,
                          label: context.l10n.btnCreateAccount,
                          onPressed: () {
                            unawaited(
                              Navigator.of(context).pushNamed('/setup'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) => Column(
        children: [
          Semantics(
            label: context.l10n.dashboardBasirSystemTitle,
            image: true,
            child: const BasirLogo(size: 140),
          ),
          const SizedBox(height: Spacing.lg),
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
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
}
