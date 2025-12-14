/// ثوابت الاختبار
///
/// يحتوي على جميع الثوابت المستخدمة في الاختبارات
/// ⚠️ هذه القيم للاختبار فقط - ليست للإنتاج
library;

/// ثوابت المصادقة للاختبار
class TestAuthConstants {
  // كلمات مرور للاختبار - ليست للإنتاج
  static const String validPassword = 'TestPass123!';
  static const String shortPassword = '12345'; // أقل من 6 أحرف
  static const String newPassword = 'NewTestPass456!';

  // أسماء مستخدمين للاختبار
  static const String validUsername = 'testuser';
  static const String shortUsername = 'ab'; // أقل من 3 أحرف
  static const String longUsername = 'verylongusernamethatexceedslimit';

  // بيانات وهمية أخرى
  static const String testEmail = 'test@example.com';
  static const String invalidEmail = 'invalid-email';
}

/// ثوابت PDF للاختبار
class TestPdfConstants {
  static const String samplePdfPath = 'test/fixtures/sample.pdf';
  static const String invalidPdfPath = 'test/fixtures/invalid.pdf';
  static const String largePdfPath = 'test/fixtures/large.pdf';
}

/// ثوابت التوثيق للاختبار
class TestDocConstants {
  static const String sampleMarkdown = '''
# Test Document
This is a test document for generation testing.

## Section 1
Content here.
''';

  static const String complexMarkdown = '''
# Complex Document
## Multiple Sections
### Subsection
- List item 1
- List item 2

**Bold text** and *italic text*.
''';
}
