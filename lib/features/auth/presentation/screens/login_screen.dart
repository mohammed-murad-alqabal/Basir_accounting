import 'package:basser_app/core/constants.dart';
import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:flutter/material.dart';

/// شاشة تسجيل الدخول
///
/// تسمح للمستخدم بتسجيل الدخول إلى التطبيق باستخدام
/// اسم المستخدم وكلمة المرور
///
/// Features:
/// - نموذج تسجيل دخول مع التحقق من الصحة
/// - حقل اسم المستخدم
/// - حقل كلمة المرور مع إخفاء/إظهار
/// - زر تسجيل الدخول مع حالة تحميل
/// - رابط للانتقال إلى شاشة الإعداد
/// - رسائل خطأ ونجاح
///
/// Navigation:
/// - عند النجاح: ينتقل إلى /dashboard
/// - رابط إلى: /setup (إنشاء حساب جديد)
///
/// Example:
/// ```dart
/// Navigator.pushNamed(context, '/login');
/// ```
class LoginScreen extends StatefulWidget {
  /// إنشاء شاشة تسجيل الدخول
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _keepLoggedIn = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO(dev): استدعاء authService.login()
      // final result = await authService.login(
      //   _usernameController.text,
      //   _passwordController.text,
      // );

      // حفظ إعداد البقاء مسجلاً
      // await authService.setKeepLoggedIn(_keepLoggedIn);

      if (!mounted) return;

      await ScaffoldMessenger.of(context)
          .showSnackBar(
            const SnackBar(content: Text(AppMessages.loginSuccess)),
          )
          .closed;

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
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGuestLogin() async {
    setState(() => _isLoading = true);

    try {
      // TODO(dev): استدعاء authService.loginAsGuest()
      // await authService.loginAsGuest();

      if (!mounted) return;

      await ScaffoldMessenger.of(context)
          .showSnackBar(
            const SnackBar(
              content: Text('مرحباً بك كضيف! يمكنك إنشاء حساب لاحقاً'),
            ),
          )
          .closed;

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
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // رأس الشاشة
                _buildHeader(),
                const SizedBox(height: AppSpacing.xl),

                // نموذج تسجيل الدخول
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // حقل اسم المستخدم
                      AppTextField(
                        label: 'اسم المستخدم',
                        hint: 'أدخل اسم المستخدم',
                        controller: _usernameController,
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppMessages.emptyField;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // حقل كلمة المرور
                      AppTextField(
                        label: 'كلمة المرور',
                        hint: 'أدخل كلمة المرور',
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppMessages.emptyField;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // خيار البقاء مسجلاً
                      Row(
                        children: [
                          Checkbox(
                            value: _keepLoggedIn,
                            onChanged: (value) {
                              setState(() => _keepLoggedIn = value ?? true);
                            },
                          ),
                          const Text(
                            'البقاء مسجلاً',
                            style: TextStyle(
                              fontSize: AppTypography.bodyMedium,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // زر تسجيل الدخول
                      AppPrimaryButton(
                        label: 'تسجيل الدخول',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                        width: double.infinity,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // زر الدخول كضيف
                      AppSecondaryButton(
                        label: 'الدخول كضيف',
                        onPressed: _handleGuestLogin,
                        width: double.infinity,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // خيار إنشاء حساب جديد
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ليس لديك حساب؟ ',
                              style: TextStyle(
                                fontSize: AppTypography.bodyMedium,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            AppTextButton(
                              label: 'أنشئ حساباً الآن',
                              onPressed: () async {
                                await Navigator.of(context).pushNamed('/setup');
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

  Widget _buildHeader() => Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'بصير',
                style: TextStyle(
                  fontSize: AppTypography.headlineLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'تسجيل الدخول',
            style: TextStyle(
              fontSize: AppTypography.headlineSmall,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'رحباً بك مجدداً! سجل دخولك للمتابعة',
            style: TextStyle(
              fontSize: AppTypography.bodyMedium,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
}
