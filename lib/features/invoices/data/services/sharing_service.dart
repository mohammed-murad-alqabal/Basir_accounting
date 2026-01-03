import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// خدمة المشاركة (واتساب، ملفات، نص)
class SharingService {
  /// مشاركة نص عبر الواتساب مباشرة
  /// [phone]: رقم الهاتف مع كود الدولة (مثال: 966501234567)
  /// [message]: الرسالة المراد إرسالها
  Future<void> shareToWhatsApp({
    required String phone,
    required String message,
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    final url = Uri.parse(
      'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('لا يمكن فتح الواتساب. تأكد من تثبيت التطبيق.');
    }
  }

  /// مشاركة ملف (PDF, CSV, إلخ)
  Future<void> shareFile({
    required List<int> bytes,
    required String fileName,
    String? subject,
    String? text,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: subject,
        text: text,
      ),
    );
  }

  /// مشاركة ملف PDF (للتوافق مع الكود القديم)
  Future<void> sharePdfFile({
    required List<int> bytes,
    required String fileName,
    String? subject,
    String? text,
  }) =>
      shareFile(
        bytes: bytes,
        fileName: fileName,
        subject: subject,
        text: text,
      );

  /// مشاركة نص عام
  Future<void> shareText(String text, {String? subject}) async {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
      ),
    );
  }
}
