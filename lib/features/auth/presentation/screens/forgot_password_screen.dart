import 'package:basir_accounting_system/core/assets/app_logo.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);

    AppSnackbar.showSuccess(
      context, 
      'تم إرسال طلب استعادة كلمة المرور بنجاح. سيتم التواصل معك قريباً.'
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appIcons = ref.watch(appIconsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.forgotPassword, 
          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.xl),
        child: Column(
          children: [
            const BasirLogo(size: 80),
            const SizedBox(height: Spacing.xl),
            
            Text(
              'استعادة كلمة المرور',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeights.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'أدخل رقم الموبايل الخاص بك وسنقوم بمساعدتك في استعادة حسابك بسهولة.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: Spacing.xxl),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    label: 'رقم الموبايل',
                    hint: 'أدخل رقم الموبايل...',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(appIcons.phone, size: IconSizes.sm),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم الموبايل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.xl),
                  AppEnhancedButton(
                    onPressed: _onSubmit,
                    label: 'طلب استعادة',
                    icon: Icons.send_rounded,
                    isLoading: _isLoading,
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
