import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/mfa/presentation/providers/mfa_providers.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneOtpScreen extends ConsumerStatefulWidget {
  const PhoneOtpScreen({required this.phone, this.afterRoute, super.key});

  final String phone;
  final String? afterRoute;

  @override
  ConsumerState<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends ConsumerState<PhoneOtpScreen> {
  final _otpController = TextEditingController();
  var _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final otp = _otpController.text.trim();
      if (otp.isEmpty) {
        AppSnackbar.showError(context, 'أدخل رمز التحقق');
        return;
      }

      final ok = await ref.read(phoneAuthServiceInterfaceProvider).verifyOtp(
            widget.phone,
            otp,
          );
      if (!mounted) return;
      if (!ok) {
        AppSnackbar.showError(context, 'رمز غير صحيح');
        return;
      }

      ref.invalidate(phoneVerifiedProvider);
      ref.invalidate(storedPhoneNumberProvider);

      Navigator.of(context).pop(true);
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
        title: 'رمز التحقق',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Spacing.md),
              Text(
                'أدخل الرمز المرسل إلى ${widget.phone}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.xl),
              AppTextField(
                controller: _otpController,
                label: 'الرمز',
                hint: 'xxxxxx',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.lock_open_outlined),
              ),
              const SizedBox(height: Spacing.xl),
              AppEnhancedButton(
                label: 'تحقق',
                onPressed: _isLoading ? null : _verify,
                isLoading: _isLoading,
                icon: Icons.verified_outlined,
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
