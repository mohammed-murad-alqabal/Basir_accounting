import 'dart:async';

import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

/// واجهة الأخطاء العالمية
///
/// تعرض شاشة خطأ احترافية عند حدوث خطأ غير متوقع في Flutter
class GlobalErrorWidget extends StatelessWidget {
  /// إنشاء واجهة أخطاء
  const GlobalErrorWidget({
    required this.errorDetails,
    super.key,
  });

  /// تفاصيل الخطأ
  final FlutterErrorDetails errorDetails;

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: FontFamilies.arabic,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        ),
        home: Scaffold(
          backgroundColor: AppColors.background,
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.5),
                radius: 1.5,
                colors: [
                  AppColors.surface,
                  AppColors.background,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.xl),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Spacing.xl),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.error,
                          size: 64,
                        ),
                      ),
                      const SizedBox(height: Spacing.xl),
                      Text(
                        context.l10n.errorTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: AppTypography.headlineSmall,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      Text(
                        context.l10n.errorDescription,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: AppTypography.bodyMedium,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: Spacing.xxl),
                      AppButton(
                        label: context.l10n.btnRetry,
                        onPressed: () {
                          unawaited(
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/',
                              (route) => false,
                            ),
                          );
                        },
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
