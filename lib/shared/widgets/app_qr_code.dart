import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// ودجت رمز الاستجابة السريعة الموحد (Unified App QR Code)
///
/// يستخدم لعرض رموز QR متوافقة مع متطلبات ZATCA أو أي روابط أخرى.
class AppQrCode extends StatelessWidget {
  /// إنشاء رمز QR
  const AppQrCode({
    required this.data,
    super.key,
    this.size = 150,
    this.padding = Spacing.md,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.errorStateBuilder,
  });

  /// البيانات المراد تشفيرها في الرمز
  final String data;

  /// الحجم (العرض والارتفاع)
  final double size;

  /// الحشوة الداخلية
  final double padding;

  /// لون الخلفية
  final Color backgroundColor;

  /// لون الرمز
  final Color foregroundColor;

  /// منشئ حالة الخطأ
  final QrErrorBuilder? errorStateBuilder;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        width: size,
        height: size,
        color: AppColors.surfaceVariant,
        child: const Center(
          child: Icon(Icons.qr_code_2, color: AppColors.textHint),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: Radii.borderRadiusMd,
        boxShadow: Elevation.sm > 0
            ? [
                const BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: Elevation.sm * 2,
                  offset: Offset(0, Elevation.sm),
                ),
              ]
            : null,
      ),
      child: QrImageView(
        data: data,
        size: size,
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: foregroundColor,
        ),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: foregroundColor,
        ),
        errorStateBuilder: errorStateBuilder,
        gapless: false,
      ),
    );
  }
}
