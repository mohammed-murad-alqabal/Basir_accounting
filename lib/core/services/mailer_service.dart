import 'package:flutter/foundation.dart';

/// Email service abstraction interface.
///
/// Provides a contract for email sending operations, allowing easy
/// substitution of email providers (SendGrid, Mailgun, etc.).
///
/// ## Implementation Notes
/// Implement this interface for production email services.
/// Use [LogMailer] for development and testing.
// ignore: one_member_abstracts
abstract class MailerService {
  /// Sends an email message.
  ///
  /// ## Parameters
  /// - [to]: Recipient email address.
  /// - [subject]: Email subject line.
  /// - [body]: Email body content.
  /// - [attachmentPath]: Optional file path for attachment (e.g., invoice PDF).
  ///
  /// ## Returns
  /// `true` if the email was sent successfully, `false` otherwise.
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    String? attachmentPath,
  });
}

/// Debug logging implementation of [MailerService].
///
/// Logs email attempts to the debug console instead of actual sending.
/// Useful for development and testing environments.
///
/// ## Usage
/// ```dart
/// final mailer = LogMailer();
/// await mailer.sendEmail(
///   to: 'customer@example.com',
///   subject: 'Invoice #12345',
///   body: 'Please find attached...',
///   attachmentPath: '/path/to/invoice.pdf',
/// );
/// ```
class LogMailer implements MailerService {
  @override
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    String? attachmentPath,
  }) async {
    // Simulate network latency
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
