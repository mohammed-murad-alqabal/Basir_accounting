import 'package:flutter/foundation.dart';

/// واجهة خدمة البريد الإلكتروني (Mailer Service Interface)
///
/// توفر تجريداً (Abstraction) لإرسال رسائل البريد الإلكتروني
/// تسمح بتبديل مزود الخدمة (مثل SendGrid, Mailgun) بسهولة
// ignore: one_member_abstracts
abstract class MailerService {
  /// إرسال بريد إلكتروني
  ///
  /// Parameters:
  /// - [to]: البريد الإلكتروني للمستلم
  /// - [subject]: عنوان الرسالة
  /// - [body]: نص الرسالة
  /// - [attachmentPath]: مسار مرفق اختياري (مثل فاتورة PDF)
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    String? attachmentPath,
  });
}

/// تطبيق محاكاة لخدمة البريد (Logging Mailer)
///
/// يقوم بتسجيل محاولات الإرسال في السجل بدلاً من الإرسال الفعلي
/// مفيد لأغراض التطوير والاختبار
class LogMailer implements MailerService {
  @override
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    String? attachmentPath,
  }) async {
    // محاكاة تأخير الشبكة
    await Future<void>.delayed(const Duration(milliseconds: 500));

    debugPrint('📧 [MAILER] Sending email to: $to');
    debugPrint('📧 [MAILER] Subject: $subject');
    debugPrint('📧 [MAILER] Body: $body');
    if (attachmentPath != null) {
      debugPrint('📧 [MAILER] Attachment: $attachmentPath');
    }

    return true;
  }
}
