import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';

/// ودجيت عرض الخطأ (Error Widget)
///
/// يعرض رسالة خطأ مع أيقونة وزر اختياري لإعادة المحاولة.
class AppErrorWidget extends StatelessWidget {
  /// إنشاء ودجيت خطأ جديد.
  const AppErrorWidget({required this.message, super.key, this.onRetry});

  /// رسالة الخطأ المراد عرضها.
  final String message;

  /// وظيفة إعادة المحاولة (اختيارية).
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                AppEnhancedButton(
                  label: 'إعادة المحاولة',
                  onPressed: onRetry,
                  type: AppEnhancedButtonType.outlined,
                ),
              ],
            ],
          ),
        ),
      );
}
