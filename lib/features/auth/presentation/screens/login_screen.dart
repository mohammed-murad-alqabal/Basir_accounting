import 'dart:async';

import 'package:basser_app/core/assets/app_logo.dart';
import 'package:basser_app/core/constants.dart';
import 'package:basser_app/core/theme/app_icons.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة تسجيل الدخول
///
/// تسمح للمستخدم بتسجيل الدخول إلى التطبيق باستخدام
/// اسم المستخدم وكلمة المرور
class LoginScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة تسجيل الدخول
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = <credential-fixture><FormState>();
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
    // تفعيل validation عند أول محاولة
    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(
        () => _autovalidateMode = AutovalidateMode.onUserInteraction,
      );
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(
      () => _isLoading = true,
    );

    try {
      // تسجيل الدخول الفعلي باستخدام AuthService
      final success = await ref.read(authServiceProvider).login(
            _usernameController.text,
            _passwordController.text,
          );

      if (!success) {
        throw Exception('فشل تسجيل الدخول. يرجى التحقق من البيانات.');
      }

      if (!mounted) return;

      // حفظ حالة "البقاء مسجلاً" إذا تم اختيارها
      if (_keepLoggedIn) {
        await ref.read(authServiceProvider).setKeepLoggedIn(
              keepLoggedIn: true,
            );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppMessages.loginSuccess)),
      );

      // الانتقال إلى لوحة التحكم
      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed('/dashboard');
    } on Exception catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    } finally {
      if (mounted) {
        setState(
          () => _isLoading = false,
        );
      }
    }
  }

  Future<void> _handleGuestLogin() async {
    setState(
      () => _isLoading = true,
    );

    try {
      // تسجيل الدخول كضيف بشكل فوري (إزالة التأخير غير الضروري)
      await ref.read(authServiceProvider).loginAsGuest();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('مرحباً بك كضيف! يمكنك إنشاء حساب لاحقاً'),
        ),
      );

      // الانتقال إلى لوحة التحكم
      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed('/dashboard');
    } on Exception catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    } finally {
      if (mounted) {
        setState(
          () => _isLoading = false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            children: [
              // رأس الشاشة (Header)
              _buildHeader(colorScheme),
              const SizedBox(height: Spacing.xl),

              // نموذج تسجيل الدخول
              Form(
                key: <credential-fixture>,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // حقل اسم المستخدم
                    AppTextField(
                      label: 'اسم المستخدم',
                      hint: 'يرجى إدخال اسم المستخدم',
                      controller: _usernameController,
                      prefixIcon: const Icon(AppIcons.user, size: IconSizes.sm),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppMessages.emptyField;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Spacing.lg),

                    // حقل كلمة المرور
                    AppTextField(
                      label: 'كلمة المرور',
                      hint: 'يرجى إدخال كلمة المرور',
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: const Icon(AppIcons.lock, size: IconSizes.sm),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppMessages.emptyField;
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
                            setState(
                              () => _keepLoggedIn = value ?? true,
                            );
                          },
                        ),
                        Text(
                          'تذكرني',
                          style: TextStyles.bodyMedium.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.md),

                    // أزرار الإجراءات
                    AppPrimaryButton(
                      label: 'تسجيل الدخول',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: Spacing.md),

                    AppSecondaryButton(
                      label: 'الدخول كضيف',
                      onPressed: _handleGuestLogin,
                    ),
                    const SizedBox(height: Spacing.xl),

                    // إنشاء حساب جديد
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'لا تملك حساباً؟',
                            style: TextStyles.bodyMedium.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          AppTextButton(
                            label: 'إنشاء حساب جديد',
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
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: Radii.borderRadiusXl,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const BasserLogo(size: 60),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            'تسجيل الدخول',
            style: TextStyles.headlineSmall.copyWith(
              fontWeight: FontWeights.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            'مرحباً بك مجدداً! سجل دخولك للمتابعة',
            textAlign: TextAlign.center,
            style: TextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
}
