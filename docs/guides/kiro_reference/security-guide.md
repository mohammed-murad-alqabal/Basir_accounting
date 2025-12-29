# دليل الأمان الكامل

**المشروع:** بصير MVP  
**التاريخ:** 8 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## 🎯 نظرة عامة

هذا الدليل يحتوي على جميع معايير وأفضل ممارسات الأمان في مشروع بصير MVP.

**المبدأ الأساسي:** لا تنازل عن الأمان في أي مرحلة ✅

---

## 🔐 التخزين الآمن

### flutter_secure_storage

استخدم `flutter_secure_storage` لتخزين البيانات الحساسة:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  // كتابة
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // قراءة
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // حذف
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // حذف الكل
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
```

### ما يجب تخزينه بشكل آمن

✅ **يجب:**

- كلمات المرور (مع hashing)
- Tokens
- API Keys
- بيانات المصادقة
- معلومات الدفع
- البيانات الشخصية الحساسة

❌ **لا يجب:**

- الإعدادات العامة
- اللغة المفضلة
- الثيم
- البيانات غير الحساسة

### مثال عملي

```dart
// ✅ صحيح - تخزين آمن
class AuthService {
  final SecureStorageService _secureStorage;

  Future<void> saveAuthToken(String token) async {
    await _secureStorage.write('auth_token', token);
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.read('auth_token');
  }

  Future<void> logout() async {
    await _secureStorage.delete('auth_token');
  }
}

// ❌ خطأ - تخزين غير آمن
class AuthService {
  final SharedPreferences _prefs;

  Future<void> saveAuthToken(String token) async {
    await _prefs.setString('auth_token', token); // غير آمن!
  }
}
```

---

## 🔒 Hashing و Encryption

### Hashing (SHA-256)

استخدم hashing لكلمات المرور:

```dart
import 'package:crypto/crypto.dart';
import 'dart:convert';

class HashingService {
  /// Hash password using SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  /// Verify password
  bool verifyPassword(String password, String hashedPassword) {
    final hash = hashPassword(password);
    return hash == hashedPassword;
  }

  /// Hash with salt
  String hashWithSalt(String password, String salt) {
    final combined = password + salt;
    final bytes = utf8.encode(combined);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
```

### Salt Generation

```dart
import 'dart:math';

class SaltGenerator {
  static String generate({int length = 32}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
```

### مثال كامل

```dart
class PasswordService {
  final HashingService _hashing;
  final SecureStorageService _storage;

  Future<void> savePassword(String userId, String password) async {
    // توليد salt
    final salt = SaltGenerator.generate();

    // hash مع salt
    final hashedPassword = _hashing.hashWithSalt(password, salt);

    // حفظ آمن
    await _storage.write('${userId}_password', hashedPassword);
    await _storage.write('${userId}_salt', salt);
  }

  Future<bool> verifyPassword(String userId, String password) async {
    // قراءة البيانات المحفوظة
    final storedHash = await _storage.read('${userId}_password');
    final salt = await _storage.read('${userId}_salt');

    if (storedHash == null || salt == null) return false;

    // hash وتحقق
    final hash = _hashing.hashWithSalt(password, salt);
    return hash == storedHash;
  }
}
```

---

## ✅ Input Validation

### قواعد التحقق

#### 1. رقم الهاتف السعودي

```dart
class PhoneValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }

    // إزالة المسافات
    value = value.replaceAll(' ', '');

    // التحقق من البداية
    if (!value.startsWith('05')) {
      return 'رقم الهاتف يجب أن يبدأ بـ 05';
    }

    // التحقق من الطول
    if (value.length != 10) {
      return 'رقم الهاتف يجب أن يتكون من 10 أرقام';
    }

    // التحقق من الأرقام فقط
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'رقم الهاتف يجب أن يحتوي على أرقام فقط';
    }

    return null;
  }
}
```

#### 2. البريد الإلكتروني

```dart
class EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }

    // regex للبريد الإلكتروني
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );

    if (!emailRegex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }

    return null;
  }
}
```

#### 3. كلمة المرور

```dart
class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    if (value.length < 8) {
      return 'كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل';
    }

    // حرف كبير
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل';
    }

    // حرف صغير
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف صغير واحد على الأقل';
    }

    // رقم
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
    }

    // رمز خاص
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'كلمة المرور يجب أن تحتوي على رمز خاص واحد على الأقل';
    }

    return null;
  }
}
```

#### 4. الاسم

```dart
class NameValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }

    if (value.length < 2) {
      return 'الاسم يجب أن يحتوي على حرفين على الأقل';
    }

    if (value.length > 100) {
      return 'الاسم طويل جداً (الحد الأقصى 100 حرف)';
    }

    // حروف عربية وإنجليزية ومسافات فقط
    if (!RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$').hasMatch(value)) {
      return 'الاسم يجب أن يحتوي على حروف فقط';
    }

    return null;
  }
}
```

### Sanitization

```dart
class InputSanitizer {
  /// إزالة HTML tags
  static String removeHtmlTags(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// إزالة SQL injection patterns
  static String sanitizeSql(String input) {
    return input
        .replaceAll("'", "''")
        .replaceAll(';', '')
        .replaceAll('--', '');
  }

  /// إزالة المسافات الزائدة
  static String trimSpaces(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// تنظيف شامل
  static String sanitize(String input) {
    String result = input;
    result = removeHtmlTags(result);
    result = sanitizeSql(result);
    result = trimSpaces(result);
    return result;
  }
}
```

---

## 🛡️ حماية من الهجمات

### 1. SQL Injection

```dart
// ❌ خطأ - عرضة لـ SQL injection
Future<List<Customer>> searchCustomers(String query) async {
  final sql = "SELECT * FROM customers WHERE name = '$query'";
  return await db.rawQuery(sql);
}

// ✅ صحيح - استخدام parameterized queries
Future<List<Customer>> searchCustomers(String query) async {
  return await db.query(
    'customers',
    where: 'name = ?',
    whereArgs: [query],
  );
}

// ✅ أفضل - استخدام Isar (NoSQL)
Future<List<Customer>> searchCustomers(String query) async {
  return await isar.customerModels
      .filter()
      .nameContains(query)
      .findAll();
}
```

### 2. XSS (Cross-Site Scripting)

```dart
// ❌ خطأ - عرضة لـ XSS
Text(userInput) // قد يحتوي على HTML/JS

// ✅ صحيح - تنظيف المدخلات
Text(InputSanitizer.removeHtmlTags(userInput))

// ✅ أفضل - استخدام Text widget (آمن افتراضياً)
Text(userInput) // Flutter Text widget آمن من XSS
```

### 3. Path Traversal

```dart
// ❌ خطأ - عرضة لـ path traversal
Future<File> getFile(String filename) async {
  final path = '/data/files/$filename';
  return File(path);
}

// ✅ صحيح - التحقق من المسار
Future<File> getFile(String filename) async {
  // إزالة .. و /
  final sanitized = filename.replaceAll('..', '').replaceAll('/', '');

  // استخدام مسار آمن
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/$sanitized';

  return File(path);
}
```

---

## 🔑 المصادقة والتفويض

### JWT Tokens

```dart
class TokenService {
  final SecureStorageService _storage;

  Future<void> saveToken(String token) async {
    await _storage.write('jwt_token', token);
  }

  Future<String?> getToken() async {
    return await _storage.read('jwt_token');
  }

  Future<void> clearToken() async {
    await _storage.delete('jwt_token');
  }

  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
      );

      final exp = payload['exp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      return now > exp;
    } catch (e) {
      return true;
    }
  }
}
```

### Session Management

```dart
class SessionService {
  final TokenService _tokenService;
  Timer? _refreshTimer;

  Future<void> startSession(String token) async {
    await _tokenService.saveToken(token);
    _scheduleTokenRefresh();
  }

  Future<void> endSession() async {
    _refreshTimer?.cancel();
    await _tokenService.clearToken();
  }

  void _scheduleTokenRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => _refreshToken(),
    );
  }

  Future<void> _refreshToken() async {
    final token = await _tokenService.getToken();
    if (token == null) return;

    if (_tokenService.isTokenExpired(token)) {
      // Refresh token logic
    }
  }
}
```

---

## 🌐 Network Security

### HTTPS Only

```dart
// ✅ صحيح - استخدام HTTPS فقط
class ApiClient {
  static const baseUrl = 'https://api.example.com';

  Future<Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    // التحقق من HTTPS
    if (url.scheme != 'https') {
      throw SecurityException('Only HTTPS is allowed');
    }

    return await http.get(url);
  }
}
```

### Certificate Pinning

```dart
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

class SecureApiClient {
  late Dio _dio;

  SecureApiClient() {
    _dio = Dio();

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        // التحقق من الشهادة
        return cert.sha1.toString() == 'expected_certificate_hash';
      };
      return client;
    };
  }
}
```

### Request Timeout

```dart
class ApiClient {
  final dio = Dio(
    BaseOptions(
      connectTimeout: 10000, // 10 seconds
      receiveTimeout: 10000,
      sendTimeout: 10000,
    ),
  );
}
```

---

## 📱 Device Security

### Root/Jailbreak Detection

```dart
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class DeviceSecurityService {
  Future<bool> isDeviceSecure() async {
    try {
      final isJailbroken = await FlutterJailbreakDetection.jailbroken;
      final isDeveloperMode = await FlutterJailbreakDetection.developerMode;

      return !isJailbroken && !isDeveloperMode;
    } catch (e) {
      return false;
    }
  }

  Future<void> checkDeviceSecurity() async {
    final isSecure = await isDeviceSecure();

    if (!isSecure) {
      throw SecurityException(
        'التطبيق لا يعمل على أجهزة معدلة لأسباب أمنية'
      );
    }
  }
}
```

### Biometric Authentication

```dart
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canUseBiometric() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'يرجى المصادقة للمتابعة',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
```

---

## 🔍 Logging و Monitoring

### Secure Logging

```dart
class SecureLogger {
  static void log(String message, {LogLevel level = LogLevel.info}) {
    // إزالة البيانات الحساسة
    final sanitized = _sanitizeMessage(message);

    // Log حسب المستوى
    switch (level) {
      case LogLevel.debug:
        debugPrint('[DEBUG] $sanitized');
        break;
      case LogLevel.info:
        debugPrint('[INFO] $sanitized');
        break;
      case LogLevel.warning:
        debugPrint('[WARNING] $sanitized');
        break;
      case LogLevel.error:
        debugPrint('[ERROR] $sanitized');
        break;
    }
  }

  static String _sanitizeMessage(String message) {
    // إزالة كلمات المرور
    message = message.replaceAll(
      RegExp(r'password["\s:=]+[^\s,}]+', caseSensitive: false),
      'password=***'
    );

    // إزالة tokens
    message = message.replaceAll(
      RegExp(r'token["\s:=]+[^\s,}]+', caseSensitive: false),
      'token=***'
    );

    // إزالة API keys
    message = message.replaceAll(
      RegExp(r'api[_-]?key["\s:=]+[^\s,}]+', caseSensitive: false),
      'api_key=***'
    );

    return message;
  }
}

enum LogLevel { debug, info, warning, error }
```

---

## ❌ الأخطاء الشائعة

### 1. تخزين البيانات الحساسة في SharedPreferences

```dart
// ❌ خطأ
final prefs = await SharedPreferences.getInstance();
await prefs.setString('password', password);

// ✅ صحيح
final storage = FlutterSecureStorage();
await storage.write(key: 'password', value: hashedPassword);
```

### 2. عدم التحقق من المدخلات

```dart
// ❌ خطأ
Future<void> addCustomer(String name) async {
  await repository.add(Customer(name: name));
}

// ✅ صحيح
Future<void> addCustomer(String name) async {
  final error = NameValidator.validate(name);
  if (error != null) {
    throw ValidationException(error);
  }

  final sanitized = InputSanitizer.sanitize(name);
  await repository.add(Customer(name: sanitized));
}
```

### 3. Hardcoded Secrets

```dart
// ❌ خطأ
const apiKey = 'redacted';

// ✅ صحيح
final apiKey = await _storage.read('api_key');
// أو استخدام environment variables
```

---

## 📚 المراجع

### الوثائق الرسمية

- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [Flutter Security Best Practices](https://flutter.dev/docs/deployment/security)
- [Dart Security](https://dart.dev/guides/security)

### المعايير الداخلية

- `.kiro/steering/core/philosophy.md` - المبادئ الأساسية
- `.kiro/steering/standards/code-quality.md` - معايير الجودة
- `.kiro/steering/reference/best-practices.md` - أفضل الممارسات

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 8 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
