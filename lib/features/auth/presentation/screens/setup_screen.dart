import 'package:basser_app/core/assets/app_logo.dart';
import 'package:basser_app/core/constants.dart';
import 'package:basser_app/core/theme/app_icons.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
/// Navigator.pushNamed(context, '/setup',);
/// ```
class SetupScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة الإعداد الأولي
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _formKey = <credential-fixture><FormState>();
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

    setState(
      () => _isLoading = true,
    );

    try {
      // إنشاء الحساب الفعلي باستخدام AuthService
      await ref.read(authServiceProvider).createAccount(
            _usernameController.text,
            _passwordController.text,
          );

      if (!mounted) return;

      await ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(AppMessages.setupSuccess)))
          .closed;

      // الانتقال إلى شاشة الإعدادات الإضافية أو لوحة التحكم
      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed(
        '/dashboard',
      );
    } on Exception catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
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
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: SemanticColors.background,
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
                  key: <credential-fixture>,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // حقل اسم المستخدم
                      AppTextField(
                        label: 'اسم المستخدم',
                        hint: 'أدخل اسم المستخدم',
                        controller: _usernameController,
                        prefixIcon:
                            const Icon(AppIcons.user, size: IconSizes.sm),
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
                      const SizedBox(height: Spacing.lg),

                      // حقل كلمة المرور
                      AppTextField(
                        label: 'كلمة المرور',
                        hint: 'أدخل كلمة المرور',
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon:
                            const Icon(AppIcons.lock, size: IconSizes.sm),
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
                      const SizedBox(height: Spacing.lg),

                      // حقل تأكيد كلمة المرور
                      AppTextField(
                        label: 'تأكيد كلمة المرور',
                        hint: 'أعد إدخال كلمة المرور',
                        controller: _confirmPasswordController,
                        obscureText: true,
                        prefixIcon:
                            const Icon(AppIcons.lock, size: IconSizes.sm),
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
                      const SizedBox(height: Spacing.xl),

                      // زر الإنشاء
                      AppEnhancedButton(
                        text: 'إنشاء الحساب',
                        onPressed: _handleSetup,
                        isLoading: _isLoading,
                        icon: AppIcons.userAdd,
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
              color: SemanticColors.primary,
              borderRadius: BorderRadius.circular(Radii.lg),
              boxShadow: [
                BoxShadow(
                  color: SemanticColors.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: BasserLogo(size: 60),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          const Text(
            'إنشاء حساب جديد',
            style: TextStyle(
              fontSize: FontSizes.headlineSmall,
              fontWeight: FontWeight.bold,
              color: SemanticColors.textPrimary,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          const Text(
            'أنشئ حسابك للبدء في إدارة فواتيرك',
            style: TextStyle(
              fontSize: FontSizes.bodyMedium,
              color: SemanticColors.textSecondary,
            ),
          ),
        ],
      );
}
