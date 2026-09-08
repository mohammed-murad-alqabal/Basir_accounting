import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypto/crypto.dart' show sha256;

/// حدود وتجريد موحد لتخزين كلمات المرور والتحقق منها.
///
/// يطبق هذا التجريد القرار [ADR-SEC-001]. لا يستخدم SHA-256 لتوليد hashes
/// جديدة؛ يقتصر استخدامه على التحقق الانتقالي من صيغ تاريخية معروفة ثم ترقية
/// التخزين إلى bcrypt بعد مصادقة صحيحة.
class PasswordHasher {
  PasswordHasher._();

  /// معامل كلفة bcrypt المعتمد في ADR-SEC-001.
  static const int bcryptCost = 12;

  /// حد bcrypt العملي على إدخال كلمة المرور بترميز UTF-8.
  static const int maxPasswordUtf8Bytes = 72;

  static final RegExp _bcryptFormat = RegExp(r'^\$2[aby]\$\d{2}\$.{53}$');
  static final RegExp _legacySha256Format = RegExp(r'^[a-f0-9]{64}$');

  /// يعيد bcrypt hash جديدًا ذاتي الوصف، ويشمل salt ومعامل الكلفة.
  static String hash(String password) {
    _ensureSupportedPasswordLength(password);
    return BCrypt.hashpw(
      password,
      BCrypt.gensalt(logRounds: bcryptCost),
    );
  }

  /// يتحقق من bcrypt hash، ويرفض الصيغ التالفة بأمان بدل تمرير الاستثناء.
  static bool verifyBcrypt(String password, String encodedHash) {
    if (!_isSupportedPasswordLength(password) || !isBcryptHash(encodedHash)) {
      return false;
    }

    return BCrypt.checkpw(password, encodedHash);
  }

  /// يحدد صيغة bcrypt المدعومة من دون افتراض أن كل قيمة مخزنة سليمة.
  static bool isBcryptHash(String value) => _bcryptFormat.hasMatch(value);

  /// يحدد صيغة SHA-256 التاريخية التي يسمح بها مسار الترحيل فقط.
  static bool isLegacySha256Hash(String value) =>
      _legacySha256Format.hasMatch(value);

  /// يتحقق من SHA-256 التاريخي غير المملح لمسار Isar القديم فقط.
  static bool verifyLegacyUnsaltedSha256(String password, String encodedHash) {
    if (!isLegacySha256Hash(encodedHash)) {
      return false;
    }

    final candidate = sha256.convert(utf8.encode(password)).toString();
    return _constantTimeEquals(candidate, encodedHash);
  }

  /// يتحقق من SHA-256 التاريخي المملح والمكرر لمسار التخزين الآمن القديم فقط.
  static bool verifyLegacySaltedSha256({
    required String password,
    required String encodedHash,
    required String userSalt,
  }) {
    if (!isLegacySha256Hash(encodedHash)) {
      return false;
    }

    const appSalt = 'basir_mvp_2025_secure_salt';
    final combinedSalt = '$appSalt$userSalt';
    var candidate =
        sha256.convert(utf8.encode('$password$combinedSalt')).toString();

    for (var iteration = 0; iteration < 1000; iteration++) {
      candidate =
          sha256.convert(utf8.encode('$candidate$combinedSalt')).toString();
    }

    return _constantTimeEquals(candidate, encodedHash);
  }

  static void _ensureSupportedPasswordLength(String password) {
    if (!_isSupportedPasswordLength(password)) {
      throw ArgumentError.value(
        password,
        'password',
        'Password must not exceed $maxPasswordUtf8Bytes UTF-8 bytes.',
      );
    }
  }

  static bool _isSupportedPasswordLength(String password) =>
      utf8.encode(password).length <= maxPasswordUtf8Bytes;

  static bool _constantTimeEquals(String first, String second) {
    if (first.length != second.length) {
      return false;
    }

    var difference = 0;
    for (var index = 0; index < first.length; index++) {
      difference |= first.codeUnitAt(index) ^ second.codeUnitAt(index);
    }
    return difference == 0;
  }
}
