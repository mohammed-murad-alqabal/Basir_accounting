import 'dart:async';

import 'package:basser_app/core/extensions/context_extensions.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/app_button.dart';
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
        home: Scaffold(
          backgroundColor: SemanticColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.xl),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: SemanticColors.error,
                      size: 80,
                    ),
                    const SizedBox(height: Spacing.xl),
                    const Text(
                      'عذراً، حدث خطأ غير متوقع',
                      style: TextStyle(
                        fontSize: FontSizes.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: SemanticColors.textPrimary,
                        fontFamily: FontFamilies.arabic,
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    const Text(
                      'نحن نعمل على إصلاح المشكلة حالياً.'
                      ' يرجى محاولة إعادة تشغيل التطبيق.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSizes.bodyMedium,
                        color: SemanticColors.textSecondary,
                        fontFamily: FontFamilies.arabic,
                      ),
                    ),
                    const SizedBox(height: Spacing.xl),
                    AppPrimaryButton(
                      label: context.l10n.btnRetry,
                      onPressed: () {
                        // إعادة تشغيل التطبيق
                        // (من الناحية الفنية، نعود للشاشة الرئيسية)
                        unawaited(
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/',
                            (route) => false,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
