import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/mfa/presentation/providers/mfa_providers.dart';
import 'package:basir_accounting_system/features/mfa/presentation/widgets/pattern_drawing_widget.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatternDrawScreen extends ConsumerStatefulWidget {
  const PatternDrawScreen({
    super.key,
    this.afterRoute,
    this.title = 'رسم النمط',
  });

  final String? afterRoute;
  final String title;

  @override
  ConsumerState<PatternDrawScreen> createState() => _PatternDrawScreenState();
}

class _PatternDrawScreenState extends ConsumerState<PatternDrawScreen> {
  List<int>? _currentPattern;
  bool _isLoading = false;

  Future<void> _verifyPattern() async {
    if (_currentPattern == null || _currentPattern!.isEmpty) {
      AppSnackbar.showError(context, 'يرجى رسم النمط');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final localAuth = ref.read(localAuthServiceProvider);
      final ok = await localAuth.loginWithPattern(_currentPattern!);

      if (!mounted) return;

      if (ok) {
        await localAuth.recordMfaUnlock();
        if (!mounted) return;
        Navigator.of(context).pop(true);
      } else {
        AppSnackbar.showError(context, 'النمط غير صحيح');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onPatternComplete(List<int> pattern) {
    setState(() {
      _currentPattern = pattern;
    });
  }

  @override
  Widget build(BuildContext context) {
    final patternSet = ref.watch(patternSetProvider).value ?? false;

    return GlassScaffold(
      title: widget.title,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            const SizedBox(height: Spacing.md),
            Text(
              'ارسم نمطك للتحقق',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.lg),
            if (patternSet) ...[
              SizedBox(
                width: 300,
                height: 300,
                child: PatternDrawingWidget(
                  onPatternComplete: _onPatternComplete,
                  strokeWidth: 8,
                  radius: 20,
                ),
              ),
              const SizedBox(height: Spacing.xl),
              AppEnhancedButton(
                label: 'تحقق',
                onPressed: _isLoading ? null : _verifyPattern,
                isLoading: _isLoading,
                icon: Icons.check_circle_outline,
              ),
            ] else ...[
              const AppEnhancedButton(
                label: 'لا يوجد نمط مسجل',
                type: AppEnhancedButtonType.danger,
                onPressed: null,
                icon: Icons.warning_outlined,
              ),
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
