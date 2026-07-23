import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/zatca/application/zatca_simulation_service.dart';
import 'package:basir_accounting_system/features/zatca/domain/zatca_types.dart';
import 'package:basir_accounting_system/shared/widgets/glass_card.dart';
import 'package:basir_accounting_system/shared/widgets/glass_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for simulating the ZATCA Phase 2 onboarding process.
///
/// Handles OTP entry, CSR generation (simulated), and CSID receipt.
class ZatcaOnboardingScreen extends ConsumerStatefulWidget {
  /// Creates a [ZatcaOnboardingScreen].
  const ZatcaOnboardingScreen({super.key});

  /// Name of the route.
  static const routeName = '/zatca-onboarding';

  @override
  ConsumerState<ZatcaOnboardingScreen> createState() =>
      _ZatcaOnboardingScreenState();
}

class _ZatcaOnboardingScreenState extends ConsumerState<ZatcaOnboardingScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  ZatcaSubmissionResult? _result;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleOnboard() async {
    if (_otpController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final result = await ref
          .read(zatcaSimulationServiceProvider.notifier)
          .onboardDevice(otp: _otpController.text);

      setState(() {
        _result = result;
        _isLoading = false;
      });

      if (result.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (!result.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
        title: 'ZATCA Phase 2 Simulation',
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_result?.status == ZatcaSubmissionStatus.reported)
                  _buildSuccessState()
                else
                  _buildOnboardingForm(),
              ],
            ),
          ),
        ),
      );

  Widget _buildOnboardingForm() => GlassCard(
        padding: const EdgeInsets.all(Spacing.xl),
        width: 500, // Constrained width for web/desktop
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.verified_user_outlined,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              'Device Onboarding',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'Enter the 6-digit OTP from Fatoora Portal to '
              'simulate CSR & CSID generation.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xl),
            TextFormField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                hintText: 'e.g. 123456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.vpn_key_outlined),
              ),
              keyboardType: <credential-fixture>,
              maxLength: 6,
            ),
            const SizedBox(height: Spacing.lg),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleOnboard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simulate Onboarding'),
              ),
            ),
          ],
        ),
      );

  Widget _buildSuccessState() => GlassCard(
        padding: const EdgeInsets.all(Spacing.xl),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppColors.success,
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              'Device Onboarded!',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              'This simulation device is now ready to report '
              'invoices to ZATCA Phase 2.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: Spacing.xl),
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(Radii.sm),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Compliance Status:',
                        style: AppTextStyles.labelMedium,
                      ),
                      Text(
                        'Active',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mode:', style: AppTextStyles.labelMedium),
                      Text(
                        'Simulation (Developer)',
                        style: AppTextStyles.labelLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
