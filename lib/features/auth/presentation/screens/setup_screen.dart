// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:basir_accounting_system/core/assets/app_logo.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/services/icon_customization_service.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// الشاشة الموحدة لتسجيل الدخول
/// تحتوي على (الدولة، اللغة، الشركة، رقم الموبايل، وكلمة المرور)
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // وحدات التحكم
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // المتغيرات لحالة القوائم المنسدلة
  String _selectedCountry = 'Yemen';
  String _selectedLanguage = 'ar';
  String? _selectedCompany;
  
  bool _isLoading = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // البيانات الوهمية للقوائم (سيتم ربطها بقواعد البيانات لاحقاً)
  final Map<String, String> _countries = {
    'Yemen': 'اليمن (+967)',
    'Saudi Arabia': 'السعودية (+966)',
    'Egypt': 'مصر (+20)',
    'UAE': 'الإمارات (+971)',
  };

  final Map<String, String> _languages = {
    'ar': 'العربية',
    'en': 'English',
  };

  final List<String> _companies = [
    'الشركة الرئيسية (المركز الإداري)',
    'فرع الرياض',
    'فرع جدة',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCompany = _companies.first;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSetup() async {
    if (_isLoading) return;

    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // إرسال رقم الموبايل كاسم مستخدم لخدمة المصادقة
      await ref
          .read(authServiceProvider)
          .createAccount(_phoneController.text, _passwordController.text);

      if (!mounted) return;
      AppSnackbar.showSuccess(context, context.l10n.msgAccountCreated);

      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed('/dashboard');
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, context.l10n.errGeneric(e.toString().replaceAll('Exception: ', '')));
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الشعار
              Semantics(
                label: context.l10n.dashboardBasirSystemTitle,
                image: true,
                child: const BasirLogo(size: 100),
              ),
              const SizedBox(height: Spacing.lg),

              // العنوان
              Text(
                'مرحباً بك في بصير',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeights.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                'إنشاء حساب جديد في بصير',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: Spacing.xl),

              // نموذج تسجيل الدخول الموحد
              Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. الصف الأول: الدولة واللغة
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // قائمة الدولة
                        DropdownButtonFormField<String>(
isExpanded: true,
                            value: _selectedCountry,
                            decoration: InputDecoration(
                              labelText: 'الدولة',
                              prefixIcon: const Icon(Icons.public_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                            ),
                            items: _countries.entries.map((e) {
                              return DropdownMenuItem(
                                value: e.key,
                                child: Text(e.value, style: const TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCountry = val);
                            },
                          ),
                        const SizedBox(height: Spacing.lg),
                        // قائمة اللغة
                        DropdownButtonFormField<String>(
isExpanded: true,
                            value: _selectedLanguage,
                            decoration: InputDecoration(
                              labelText: 'اللغة',
                              prefixIcon: const Icon(Icons.language_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                            ),
                            items: _languages.entries.map((e) {
                              return DropdownMenuItem(
                                value: e.key,
                                child: Text(e.value, style: const TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedLanguage = val);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: Spacing.lg),

                    // 2. قائمة اختيار الشركة/قاعدة البيانات
                    DropdownButtonFormField<String>(
isExpanded: true,
                      value: _selectedCompany,
                      decoration: InputDecoration(
                        labelText: 'الشركة / قاعدة البيانات',
                        prefixIcon: const Icon(Icons.business_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      items: _companies.map((company) {
                        return DropdownMenuItem(
                          value: company,
                          child: Text(company, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedCompany = val);
                      },
                    ),
                    const SizedBox(height: Spacing.lg),

                    // 3. حقل رقم الموبايل
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
                        if (value.length < 6) {
                          return 'رقم الموبايل غير صالح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: Spacing.lg),

                    // 4. حقل كلمة المرور
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

                    

                    // زر تسجيل الدخول
                    AppEnhancedButton(
                      width: double.infinity,
                      label: 'إنشاء الحساب',
                      onPressed: _handleSetup,
                      isLoading: _isLoading,
                      icon: appIcons.userAdd,
                    ),
                    const SizedBox(height: Spacing.xl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
