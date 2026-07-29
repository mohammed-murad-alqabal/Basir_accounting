import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/mfa/presentation/providers/mfa_providers.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MfaChallengeScreen extends ConsumerStatefulWidget {
  const MfaChallengeScreen({super.key, this.afterRoute});

  final String? afterRoute;

  @override
  ConsumerState<MfaChallengeScreen> createState() => _MfaChallengeScreenState();
}

class _MfaChallengeScreenState extends ConsumerState<MfaChallengeScreen> {
  final _pinController = TextEditingController();
  var _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _completeSuccess() async {
    final localAuth = ref.read(localAuthServiceProvider);
    await localAuth.recordMfaUnlock();
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _tryBiometric() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final ok = await ref.read(localAuthServiceProvider).loginWithBiometric();
      if (!mounted) return;
      if (ok) {
        await _completeSuccess();
        return;
      }
      AppSnackbar.showError(context, 'تعذرت المصادقة بالبصمة');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _tryPin() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final pin = _pinController.text.trim();
      if (pin.isEmpty) {
        AppSnackbar.showError(context, 'أدخل PIN');
        return;
      }
      final ok = await ref.read(localAuthServiceProvider).loginWithPin(pin);
      if (!mounted) return;
      if (ok) {
        await _completeSuccess();
        return;
      }
      AppSnackbar.showError(context, 'PIN غير صحيح');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _tryPattern() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      // استخدام PatternDrawScreen لرسم النمط
      final ok = await Navigator.of(context).pushNamed<bool>(
        '/pattern-draw',
        arguments: {
          'after': '/mfa-challenge',
        },
      );

      if (!mounted) return;

      if (ok ?? false) {
        await _completeSuccess();
        return;
      }
      AppSnackbar.showError(context, 'النمط غير صحيح');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final biometricAvailable =
        ref.watch(biometricAvailableProvider).value ?? false;
    final biometricEnabled = ref.watch(biometricEnabledProvider);
    final pinSet = ref.watch(pinSetProvider).value ?? false;
    final patternSet = ref.watch(patternSetProvider).value ?? false;

    final hasAnyMethod =
        (biometricAvailable && biometricEnabled) || pinSet || patternSet;

    if (!hasAnyMethod) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!context.mounted) return;
        final navigator = Navigator.of(context);
        await AppDialog.showInfo(
          context,
          title: 'لا توجد طريقة تحقق',
          message: 'قم بإعداد PIN أو بصمة أو نمط من مركز الأمان أولاً.',
        );
        if (!context.mounted) return;
        navigator.pop(true);
      });
    }

    return GlassScaffold(
      title: 'التحقق الإضافي',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Spacing.md),
            Text(
              'أكمل خطوة التحقق للمتابعة',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xl),
            if (biometricAvailable && biometricEnabled) ...[
              AppEnhancedButton(
                label: 'استخدام البصمة',
                onPressed: _isLoading ? null : _tryBiometric,
                isLoading: _isLoading,
                icon: Icons.fingerprint,
              ),
              const SizedBox(height: Spacing.lg),
            ],
            if (pinSet) ...[
              AppTextField(
                controller: _pinController,
                label: 'PIN',
                hint: 'أدخل PIN',
                obscureText: true,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.pin),
              ),
              const SizedBox(height: Spacing.md),
              AppEnhancedButton(
                label: 'تأكيد PIN',
                onPressed: _isLoading ? null : _tryPin,
                isLoading: _isLoading,
                icon: Icons.check_circle_outline,
              ),
              const SizedBox(height: Spacing.lg),
            ],
            if (patternSet) ...[
              AppEnhancedButton(
                label: 'رسم النمط',
                onPressed: _isLoading ? null : _tryPattern,
                isLoading: _isLoading,
                icon: Icons.grid_on_outlined,
              ),
              const SizedBox(height: Spacing.lg),
            ],
            const SizedBox(height: Spacing.xl),
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
}
