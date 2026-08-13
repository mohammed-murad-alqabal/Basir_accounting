import 'dart:convert';

import 'package:basir_accounting_system/core/security/password_hasher.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordHasher', () {
    test('creates a bcrypt hash that verifies the original password', () {
      const password = '<credential-fixture>';

      final encodedHash = PasswordHasher.hash(password);

      expect(PasswordHasher.isBcryptHash(encodedHash), isTrue);
      expect(PasswordHasher.verifyBcrypt(password, encodedHash), isTrue);
      expect(
        PasswordHasher.verifyBcrypt('incorrect-password', encodedHash),
        isFalse,
      );
    });

    test('rejects new passwords that exceed bcrypt UTF-8 byte limit', () {
      final oversizedPassword = List<String>.filled(73, 'a').join();

      expect(
        () => PasswordHasher.hash(oversizedPassword),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('verifies an explicitly recognized legacy unsalted SHA-256 hash', () {
      const password = '<credential-fixture>';
      final legacyHash = sha256.convert(utf8.encode(password)).toString();

      expect(
        PasswordHasher.verifyLegacyUnsaltedSha256(password, legacyHash),
        isTrue,
      );
      expect(
        PasswordHasher.verifyLegacyUnsaltedSha256('wrong-password', legacyHash),
        isFalse,
      );
    });

    test('verifies an explicitly recognized legacy salted SHA-256 hash', () {
      const password = '<credential-fixture>';
      const userSalt = 'legacy-user-salt';
      const appSalt = 'basir_mvp_2025_secure_salt';
      const combinedSalt = '$appSalt$userSalt';
      var legacyHash =
          sha256.convert(utf8.encode('$password$combinedSalt')).toString();
      for (var iteration = 0; iteration < 1000; iteration++) {
        legacyHash =
            sha256.convert(utf8.encode('$legacyHash$combinedSalt')).toString();
      }

      expect(
        PasswordHasher.verifyLegacySaltedSha256(
          password: <credential-fixture>
          encodedHash: legacyHash,
          userSalt: userSalt,
        ),
        isTrue,
      );
      expect(
        PasswordHasher.verifyLegacySaltedSha256(
          password: <credential-fixture>
          encodedHash: legacyHash,
          userSalt: 'different-salt',
        ),
        isFalse,
      );
    });
  });
}
