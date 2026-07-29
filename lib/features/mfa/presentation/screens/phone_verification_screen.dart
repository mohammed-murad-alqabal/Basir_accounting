import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/mfa/presentation/mfa_routes.dart';
import 'package:basir_accounting_system/features/mfa/presentation/providers/mfa_providers.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneVerificationScreen extends ConsumerStatefulWidget {
  const PhoneVerificationScreen({super.key, this.afterRoute});

  final String? afterRoute;

  @override
  ConsumerState<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState
    extends ConsumerState<PhoneVerificationScreen> {
  final _phoneController = TextEditingController();
  var _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        AppSnackbar.showError(context, 'أدخل رقم الجوال');
        return;
      }
      await ref.read(phoneAuthServiceInterfaceProvider).sendOtp(phone);
      if (!mounted) return;
      final ok = await Navigator.of(context).pushNamed<bool>(
            MfaRoutes.phoneOtp,
            arguments: {
              'phone': phone,
              'after': widget.afterRoute,
            },
          ) ??
          false;
      if (!mounted) return;
      if (ok) {
        Navigator.of(context).pop(true);
      }
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
        title: 'ربط رقم الجوال',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Spacing.md),
              Text(
                'سنرسل رمز تحقق لمرة واحدة (OTP) إلى رقم جوالك',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.xl),
              AppTextField(
                controller: _phoneController,
                label: 'رقم الجوال',
                hint: '05xxxxxxxx',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              const SizedBox(height: Spacing.xl),
              AppEnhancedButton(
                label: 'إرسال الرمز',
                onPressed: _isLoading ? null : _sendOtp,
                isLoading: _isLoading,
                icon: Icons.sms_outlined,
              ),
              const SizedBox(height: Spacing.lg),
              AppEnhancedButton(
                type: AppEnhancedButtonType.text,
                label: 'إلغاء',
                onPressed:
                    _isLoading ? null : () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        ),
      );
}
