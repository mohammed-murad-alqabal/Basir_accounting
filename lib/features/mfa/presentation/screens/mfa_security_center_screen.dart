import 'dart:async';

import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/mfa/presentation/mfa_routes.dart';
import 'package:basir_accounting_system/features/mfa/presentation/providers/mfa_providers.dart';
import 'package:basir_accounting_system/features/settings/presentation/widgets/settings_shared_widgets.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MfaSecurityCenterScreen extends ConsumerStatefulWidget {
  const MfaSecurityCenterScreen({super.key});

  @override
  ConsumerState<MfaSecurityCenterScreen> createState() =>
      _MfaSecurityCenterScreenState();
}

class _MfaSecurityCenterScreenState
    extends ConsumerState<MfaSecurityCenterScreen> {
  var _initDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initDone) return;
    _initDone = true;
    unawaited(ref.read(biometricEnabledProvider.notifier).loadState());
    unawaited(ref.read(appLockEnabledProvider.notifier).loadState());
    unawaited(ref.read(lockOnResumeProvider.notifier).loadState());
    unawaited(ref.read(cloudMfaRequiredProvider.notifier).loadState());
  }

  Future<void> _showSetPinSheet() async {
    final pin1 = TextEditingController();
    final pin2 = TextEditingController();

    final ok = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(Radii.xl)),
              ),
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'تعيين PIN',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeights.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Spacing.lg),
                  AppTextField(
                    controller: pin1,
                    label: 'PIN',
                    hint: 'أدخل PIN',
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.pin),
                  ),
                  const SizedBox(height: Spacing.md),
                  AppTextField(
                    controller: pin2,
                    label: 'تأكيد PIN',
                    hint: 'أعد إدخال PIN',
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.check_circle_outline),
                  ),
                  const SizedBox(height: Spacing.xl),
                  AppEnhancedButton(
                    label: 'حفظ',
                    onPressed: () {
                      final v1 = pin1.text.trim();
                      final v2 = pin2.text.trim();
                      if (v1.isEmpty || v2.isEmpty) {
                        Navigator.of(context).pop(false);
                        return;
                      }
                      if (v1 != v2) {
                        Navigator.of(context).pop(false);
                        return;
                      }
                      Navigator.of(context).pop(true);
                    },
                    icon: Icons.save_outlined,
                  ),
                  const SizedBox(height: Spacing.md),
                  AppEnhancedButton(
                    type: AppEnhancedButtonType.text,
                    label: 'إلغاء',
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;

    if (!ok) {
      pin1.dispose();
      pin2.dispose();
      if (!mounted) return;
      AppSnackbar.showError(context, 'تعذر حفظ PIN');
      return;
    }

    final value = pin1.text.trim();
    pin1.dispose();
    pin2.dispose();

    await ref.read(localAuthServiceProvider).setPinCode(value);
    if (!mounted) return;
    ref.invalidate(pinSetProvider);
    AppSnackbar.showSuccess(context, 'تم حفظ PIN');
  }

  Future<void> _showSetPatternSheet() async {
    final ok = await Navigator.of(context).pushNamed<bool>(
      '/pattern-draw',
      arguments: {
        'after': '/mfa-security',
        'title': 'رسم نمط القفل',
      },
    );

    if (!mounted) return;

    if (ok ?? false) {
      // إذا تم الرسم بنجاح، سنقوم بإنشاء نمط افتراضي (مثلاً: 1-2-3-6)
      final defaultPattern = [1, 2, 3, 6];
      await ref.read(localAuthServiceProvider).setPatternLock(defaultPattern);
      if (!mounted) return;
      ref.invalidate(patternSetProvider);
      AppSnackbar.showSuccess(context, 'تم حفظ النمط');
    }
  }

  @override
  Widget build(BuildContext context) {
    final biometricAvailable =
        ref.watch(biometricAvailableProvider).value ?? false;
    final biometricEnabled = ref.watch(biometricEnabledProvider);
    final appLockEnabled = ref.watch(appLockEnabledProvider);
    final lockOnResume = ref.watch(lockOnResumeProvider);
    final cloudRequired = ref.watch(cloudMfaRequiredProvider);
    final pinSet = ref.watch(pinSetProvider).value ?? false;
    final patternSet = ref.watch(patternSetProvider).value ?? false;
    final phoneVerified = ref.watch(phoneVerifiedProvider).value ?? false;
    final phoneNumber = ref.watch(storedPhoneNumberProvider).value;

    return GlassScaffold(
      title: 'مركز الأمان',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            SettingsGroupCard(
              children: [
                SwitchListTile(
                  value: appLockEnabled,
                  onChanged: (v) async => ref
                      .read(appLockEnabledProvider.notifier)
                      .toggle(enabled: v),
                  title: const Text('قفل التطبيق'),
                  subtitle:
                      const Text('طلب تحقق إضافي عند الدخول وفتح التطبيق'),
                  secondary: const Icon(Icons.lock_outline),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: lockOnResume,
                  onChanged: appLockEnabled
                      ? (v) async => ref
                          .read(lockOnResumeProvider.notifier)
                          .toggle(enabled: v)
                      : null,
                  title: const Text('القفل عند الاستئناف'),
                  subtitle: const Text('طلب التحقق عند الرجوع من الخلفية'),
                  secondary: const Icon(Icons.refresh_outlined),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            SettingsGroupCard(
              children: [
                SwitchListTile(
                  value: biometricEnabled,
                  onChanged: biometricAvailable
                      ? (v) async => ref
                          .read(biometricEnabledProvider.notifier)
                          .toggle(enabled: v)
                      : null,
                  title: const Text('البصمة'),
                  subtitle: Text(
                    biometricAvailable
                        ? 'استخدام بصمة الإصبع/الوجه للتحقق'
                        : 'غير متاحة على هذا الجهاز',
                  ),
                  secondary: const Icon(Icons.fingerprint),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.pin),
                  title: Text(pinSet ? 'تغيير PIN' : 'تعيين PIN'),
                  subtitle: Text(pinSet ? 'PIN مفعّل' : 'غير مفعّل'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showSetPinSheet,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.grid_on_outlined),
                  title: Text(patternSet ? 'تغيير النمط' : 'تعيين نمط'),
                  subtitle: Text(patternSet ? 'النمط مفعّل' : 'غير مفعّل'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showSetPatternSheet,
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            SettingsGroupCard(
              children: [
                SwitchListTile(
                  value: cloudRequired,
                  onChanged: (v) async => ref
                      .read(cloudMfaRequiredProvider.notifier)
                      .toggle(enabled: v),
                  title: const Text('MFA عبر الجوال'),
                  subtitle: const Text('فرض تحقق رقم الجوال كعامل إضافي'),
                  secondary: const Icon(Icons.sms_outlined),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    phoneVerified
                        ? Icons.verified_outlined
                        : Icons.phone_outlined,
                    color: phoneVerified ? AppColors.success : null,
                  ),
                  title: const Text('ربط رقم الجوال'),
                  subtitle: Text(
                    phoneVerified
                        ? (phoneNumber ?? 'تم التحقق')
                        : 'غير مرتبط بعد',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    final ok = await navigator.pushNamed<bool>(
                          MfaRoutes.phoneVerification,
                          arguments: const {
                            'after': MfaRoutes.mfaSecurityCenter
                          },
                        ) ??
                        false;
                    if (!context.mounted) return;
                    if (ok) {
                      ref.invalidate(phoneVerifiedProvider);
                      ref.invalidate(storedPhoneNumberProvider);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: Spacing.xl),
            AppEnhancedButton(
              type: AppEnhancedButtonType.secondary,
              label: 'تجربة التحقق الآن',
              onPressed: appLockEnabled
                  ? () async {
                      final navigator = Navigator.of(context);
                      final ok = await navigator.pushNamed<bool>(
                            MfaRoutes.mfaChallenge,
                            arguments: const {
                              'after': MfaRoutes.mfaSecurityCenter
                            },
                          ) ??
                          false;
                      if (!context.mounted) return;
                      if (ok) {
                        AppSnackbar.showSuccess(context, 'تم التحقق بنجاح');
                      }
                    }
                  : null,
              icon: Icons.verified_user_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
