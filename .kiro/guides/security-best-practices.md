---
id: "security-best-practices"
description: "أفضل ممارسات الأمان لتطبيقات Flutter"
version: "1.0"
last_updated: "2025-12-17"
inclusion: manual
author: "فريق وكلاء تطوير مشروع بصير"
metrics:
  location: ".kiro/guides/"
  size: "10KB"
  lines: 295
  context_usage: "5%"
---

# أفضل ممارسات الأمان - بصير MVP

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 17 ديسمبر 2025  
**الحالة:** ✅ نشط ومكثف

---

## 🎯 مبادئ الأمان الأساسية

### **Zero-Trust للتطبيقات المحلية**

- **Never Trust, Always Verify**: لا تثق أبداً، تحقق دائماً
- **Local-First Security**: الأمان يبدأ من الجهاز المحلي
- **Data Encryption**: تشفير جميع البيانات الحساسة
- **Input Validation**: التحقق من جميع المدخلات

---

## 🔐 الأمان في Flutter

### **تخزين البيانات الحساسة**

```dart
// استخدام flutter_secure_storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );

  // حفظ آمن
  static Future<void> storeUserPin(String pin) async {
    final hashedPin = await _hashPin(pin);
    await _storage.write(key: 'user_pin', value: hashedPin);
  }

  // قراءة آمنة
  static Future<String?> getUserPin() async {
    return await _storage.read(key: 'user_pin');
  }
}
```

### **تشفير البيانات**

```dart
import 'package:crypto/crypto.dart';
import 'dart:convert';

class EncryptionService {
  // تشفير كلمات المرور
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // تشفير البيانات الحساسة
  static String encryptSensitiveData(String data) {
    // استخدام AES-256 للتشفير
    // تنفيذ مبسط للمثال
    return base64.encode(utf8.encode(data));
  }
}
```

---

## 🛡️ التحقق من المدخلات

### **تنظيف المدخلات**

```dart
class InputValidator {
  // التحقق من البريد الإلكتروني
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // التحقق من رقم الهاتف السعودي
  static bool isValidSaudiPhone(String phone) {
    return RegExp(r'^05\d{8}$').hasMatch(phone);
  }

  // تنظيف النصوص من الأحرف الخطيرة
  static String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'[<>"\']'), '')
        .trim();
  }

  // التحقق من الأسماء العربية
  static bool isValidArabicName(String name) {
    return RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(name);
  }
}
```

---

## 🔒 أمان قاعدة البيانات المحلية

### **تشفير Isar**

```dart
@Collection()
class SecureInvoice {
  Id id = Isar.autoIncrement;

  // بيانات مشفرة
  late String encryptedCustomerData;
  late String encryptedAmount;

  // بيانات غير حساسة
  late DateTime createdAt;
  late String status;

  // تشفير البيانات قبل الحفظ
  void encryptSensitiveData(String customerData, double amount) {
    encryptedCustomerData = EncryptionService.encryptSensitiveData(customerData);
    encryptedAmount = EncryptionService.encryptSensitiveData(amount.toString());
  }
}
```

### **إدارة المفاتيح الآمنة**

```dart
class KeyManager {
  static const String _keyAlias = 'baseer_encryption_key';

  static Future<String> getOrCreateKey() async {
    const storage = FlutterSecureStorage();

    String? key = await storage.read(key: _keyAlias);
    if (key == null) {
      // إنشاء مفتاح جديد
      key = _generateSecureKey();
      await storage.write(key: _keyAlias, value: key);
    }

    return key;
  }

  static String _generateSecureKey() {
    // توليد مفتاح آمن 256-bit
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(bytes);
  }
}
```

---

## 🚨 معالجة الأخطاء الآمنة

### **إخفاء المعلومات الحساسة**

```dart
class SecureErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    // تسجيل آمن للأخطاء
    final sanitizedError = _sanitizeError(error.toString());

    // عرض رسالة آمنة للمستخدم
    final userMessage = _getUserFriendlyMessage(error);

    // تسجيل مفصل للمطورين فقط (في وضع التطوير)
    if (kDebugMode) {
      developer.log(
        'Error: $sanitizedError',
        error: error,
        stackTrace: stackTrace,
      );
    }

    // عرض الرسالة للمستخدم
    _showUserMessage(userMessage);
  }

  static String _sanitizeError(String error) {
    // إزالة المعلومات الحساسة من رسائل الخطأ
    return error
        .replaceAll(RegExp(r'\b\d{4}\s?\d{4}\s?\d{4}\s?\d{4}\b'), '[CARD]')
        .replaceAll(RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w+\b'), '[EMAIL]')
        .replaceAll(RegExp(r'\b05\d{8}\b'), '[PHONE]');
  }

  static String _getUserFriendlyMessage(Object error) {
    if (error is NetworkException) {
      return 'لا يوجد اتصال بالإنترنت';
    } else if (error is ValidationException) {
      return 'البيانات المدخلة غير صحيحة';
    } else if (error is DatabaseException) {
      return 'حدث خطأ في حفظ البيانات';
    }
    return 'حدث خطأ غير متوقع';
  }
}
```

---

## 🔍 فحص الأمان

### **قائمة التحقق الأساسية**

```dart
class SecurityAudit {
  static Future<SecurityReport> performAudit() async {
    final report = SecurityReport();

    // فحص التخزين الآمن
    report.secureStorageCheck = await _checkSecureStorage();

    // فحص التشفير
    report.encryptionCheck = await _checkEncryption();

    // فحص التحقق من المدخلات
    report.inputValidationCheck = _checkInputValidation();

    // فحص إدارة الأخطاء
    report.errorHandlingCheck = _checkErrorHandling();

    return report;
  }

  static Future<bool> _checkSecureStorage() async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'test', value: 'test');
      final value = await storage.read(key: 'test');
      await storage.delete(key: 'test');
      return value == 'test';
    } catch (e) {
      return false;
    }
  }
}

class SecurityReport {
  bool secureStorageCheck = false;
  bool encryptionCheck = false;
  bool inputValidationCheck = false;
  bool errorHandlingCheck = false;

  bool get isSecure =>
      secureStorageCheck &&
      encryptionCheck &&
      inputValidationCheck &&
      errorHandlingCheck;
}
```

---

## 📱 أمان التطبيقات المحمولة

### **حماية من التطبيقات الضارة**

```dart
class AppSecurityService {
  // فحص إذا كان الجهاز مكسور الحماية
  static Future<bool> isDeviceSecure() async {
    // فحص Root/Jailbreak
    if (Platform.isAndroid) {
      return await _checkAndroidSecurity();
    } else if (Platform.isIOS) {
      return await _checkIOSSecurity();
    }
    return true;
  }

  // منع لقطات الشاشة للبيانات الحساسة
  static void preventScreenshots() {
    if (Platform.isAndroid) {
      // تطبيق FLAG_SECURE
      // يتطلب تنفيذ native
    }
  }

  // فحص تكامل التطبيق
  static Future<bool> verifyAppIntegrity() async {
    // التحقق من التوقيع الرقمي
    // فحص التلاعب بالملفات
    return true; // تنفيذ مبسط
  }
}
```

---

## 🛠️ أدوات الأمان

### **أدوات التطوير الآمن**

```bash
# فحص التبعيات للثغرات
flutter pub deps
dart pub audit

# فحص الكود للمشاكل الأمنية
flutter analyze

# اختبار الأمان
flutter test test/security/
```

### **إعدادات البناء الآمن**

```yaml
# android/app/build.gradle
android {
buildTypes {
release {
// تفعيل ProGuard
minifyEnabled true
shrinkResources true

// إزالة معلومات التطوير
debuggable false

// تشفير الموارد
proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
}
}
}
```

---

## 📋 قائمة التحقق اليومية

### **للمطورين**

- [ ] لا توجد أسرار في الكود
- [ ] استخدام `flutter_secure_storage` للبيانات الحساسة
- [ ] التحقق من جميع المدخلات
- [ ] تشفير البيانات الحساسة
- [ ] معالجة آمنة للأخطاء
- [ ] فحص التبعيات للثغرات

### **قبل النشر**

- [ ] فحص أمني شامل
- [ ] إزالة جميع بيانات التطوير
- [ ] تفعيل التشفير والحماية
- [ ] اختبار الأمان على أجهزة مختلفة
- [ ] التحقق من أذونات التطبيق

---

## 🔗 المراجع المتقدمة

### **للتفاصيل الشاملة:**

- [ممارسات الأمان المتقدمة](../../reference/advanced-security-practices.md)

### **المعايير والأدلة:**

- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [Flutter Security Guidelines](https://flutter.dev/docs/deployment/security)
- [Android Security Best Practices](https://developer.android.com/topic/security/best-practices)

---

## 🎯 التوصيات العملية

### **للبدء:**

1. استخدم `flutter_secure_storage` فوراً
2. اتبع مبدأ "Never Trust, Always Verify"
3. شفّر جميع البيانات الحساسة
4. تحقق من جميع المدخلات

### **للتطوير المستمر:**

1. فحص أمني دوري
2. تحديث التبعيات باستمرار
3. مراجعة الكود للثغرات
4. اختبار الأمان على أجهزة حقيقية

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ ملف توجيه مكثف وآمن  
**المراجعة القادمة:** 23 ديسمبر 2025
