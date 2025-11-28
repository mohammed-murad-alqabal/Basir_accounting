import 'package:basser_app/core/constants.dart';
import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:flutter/material.dart';

/// شاشة الإعداد الأولي
///
/// تسمح للمستخدم بإنشاء حساب جديد في التطبيق
/// للمرة الأولى
///
/// Features:
/// - نموذج إنشاء حساب مع التحقق من الصحة
/// - حقل اسم المستخدم (3 أحرف على الأقل)
/// - حقل كلمة المرور (6 أحرف على الأقل)
/// - حقل تأكيد كلمة المرور
/// - التحقق من تطابق كلمات المرور
/// - زر إنشاء الحساب مع حالة تحميل
/// - رابط للانتقال إلى شاشة تسجيل الدخول
///
/// Validation:
/// - اسم المستخدم: 3 أحرف على الأقل
/// - كلمة المرور: 6 أحرف على الأقل
/// - تأكيد كلمة المرور: يجب أن يطابق كلمة المرور
///
/// Navigation:
/// - عند النجاح: ينتقل إلى /dashboard
/// - رابط إلى: /login (تسجيل الدخول)
///
/// Example:
/// ```dart
/// Navigator.pushNamed(context, '/setup');
/// ```
class SetupScreen extends StatefulWidget {
  /// إنشاء شاشة الإعداد الأولي
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
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
      // TODO: استدعاء authService.createAccount()
      // await authService.createAccount(
      //   _usernameController.text,
      //   _passwordController.text,
      // );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppMessages.setupSuccess)),
      );

      // الانتقال إلى شاشة الإعدادات الإضافية أو لوحة التحكم
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } catch (e) {
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

                // نموذج الإعداد
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
                          if (value.length < 3) {
                            return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
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
                          if (value.length < 6) {
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // حقل تأكيد كلمة المرور
                      AppTextField(
                        label: 'تأكيد كلمة المرور',
                        hint: 'أعد إدخال كلمة المرور',
                        controller: _confirmPasswordController,
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppMessages.emptyField;
                          }
                          if (value != _passwordController.text) {
                            return 'كلمات المرور غير متطابقة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // زر الإنشاء
                      AppPrimaryButton(
                        label: 'إنشاء الحساب',
                        onPressed: _handleSetup,
                        isLoading: _isLoading,
                        width: double.infinity,
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
                  color: AppColors.primary.withOpacity(0.2),
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
            'إنشاء حساب جديد',
            style: TextStyle(
              fontSize: AppTypography.headlineSmall,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'أنشئ حسابك للبدء في إدارة فواتيرك',
            style: TextStyle(
              fontSize: AppTypography.bodyMedium,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );
}
