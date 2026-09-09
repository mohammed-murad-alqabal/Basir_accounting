import 'package:basir_accounting_system/features/mfa/presentation/mfa_routes.dart';
import 'package:basir_accounting_system/features/mfa/presentation/providers/mfa_providers.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MfaGateScreen extends ConsumerStatefulWidget {
  const MfaGateScreen({super.key});

  @override
  ConsumerState<MfaGateScreen> createState() => _MfaGateScreenState();
}

class _MfaGateScreenState extends ConsumerState<MfaGateScreen> {
  var _navigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_navigated) return;
    _navigated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final navigator = Navigator.of(context);
      final localAuth = ref.read(localAuthServiceProvider);
      final appLockEnabled = await localAuth.isAppLockEnabled();
      final cloudRequired = await localAuth.isCloudMfaRequired();
      final phoneVerified = await ref.read(phoneVerifiedProvider.future);

      if (cloudRequired && !phoneVerified) {
        final ok = await navigator.pushNamed<bool>(
              MfaRoutes.phoneVerification,
              arguments: {'after': MfaRoutes.mfaGate},
            ) ??
            false;
        if (!ok || !mounted) {
          await navigator.pushReplacementNamed('/login');
          return;
        }
      }

      if (!mounted) return;

      if (appLockEnabled) {
        final ok = await navigator.pushNamed<bool>(
              MfaRoutes.mfaChallenge,
              arguments: const {'after': '/dashboard'},
            ) ??
            false;

        if (!mounted) return;

        if (ok) {
          await navigator.pushReplacementNamed('/dashboard');
          return;
        }

        await navigator.pushReplacementNamed('/login');
        return;
      }

      await navigator.pushReplacementNamed('/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) => const GlassScaffold(
        body: Center(
          child: AppLoadingIndicator(),
        ),
      );
}
