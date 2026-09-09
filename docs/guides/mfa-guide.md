# دليل نظام المصادقة المتعددة العوامل (MFA)

## نظرة عامة

نظام المصادقة المتعددة العوامل (MFA) في تطبيق بصير يوفر مستويات متعددة من الأمان لحماية بيانات العملاء والمالية. يدعم النظام عدة طرق للتحقق:

### ✅ الطُرق المدعومة:

1. **البصمة (Biometric)** - بصمة الإصبع أو التحقق بالوجه
2. **PIN** - رمز سري مكون من 4 أرقام
3. **النمط (Pattern)** - نمط ربط أرقام محددة
4. **الهاتف (Phone OTP)** - رمز تحقق عبر SMS

---

## التثبيت والتهيئة

### المتطلبات المسبقة:

- Android SDK 21+ أو iOS 12+
- Supabase project مُعد مسبقاً
- حساب Supabase مع ميزة Phone Authentication مفعلة

### الإعداد الأولي:

1. تأكد من وجود `supabase_url` و `supabase_anon_key` في ملف الإعدادات
2. قم بتفعيل Phone Authentication في Supabase Dashboard
3. تأكد من وجود `local_auth` في `pubspec.yaml`

---

## الاستخدام

### 1. مركز الأمان (Security Center)

الوصول إلى مركز الأمان:
```
الإعدادات → مركز الأمان
```

#### الإعدادات المتاحة:

##### قفل التطبيق (App Lock)
- يطلب التحقق عند فتح التطبيق
- يدعم: Biometric, PIN, Pattern

##### القفل عند الاستئناف (Lock on Resume)
- يطلب التحقق عند العودة من الخلفية
- يتطلب: App Lock مفعل

##### المصادقة عبر الهاتف (Cloud MFA)
- يفرض التحقق برقم الجوال
- يتطلب: Supabase Phone Authentication

### 2. إعداد طرق التحقق

#### إعداد PIN:

```
مركز الأمان → تعيين PIN
```

1. أدخل PIN مكون من 4 أرقام
2. أكد الPIN
3. يتم حفظه مشفراً محلياً

#### إعداد النمط:

```
مركز الأمان → تعيين النمط
```

1. أدخل النمط بتنسيق: `1-2-3-6`
2. أكد النمط
3. يتم حفظه مشفراً محلياً

#### تفعيل البصمة:

```
مركز الأمان → البصمة → تفعيل
```

1. تأكد من دعم الجهاز للبصمة
2. اضغط على زر التفعيل
3. استخدم البصمة عند الطلب

### 3. ربط رقم الجوال

```
مركز الأمان → ربط رقم الجوال
```

1. أدخل رقم الجوال (بدون صفر أولي)
2. اضغط على "إرسال الرمز"
3. أدخل الرمز المرسل
4. يصبح الجوال موثوقاً

---

## تدفق المصادقة

### عند تسجيل الدخول:

1. المستخدم يدخل بيانات الدخول
2. النظام يتحقق من البيانات الأساسية
3. إذا كان MFA مطلوباً:
   - **الهاتف:** يرسل رمز OTP
   - **المحلي:** يطلب PIN/Pattern/Biometric

### عند فتح التطبيق:

1. النظام يتحقق من حالة التحقق
2. إذا انتهت المهلة أو App Lock مفعل:
   - يظهر شاشة التحقق (MFA Challenge)
3. المستخدم يختار طريقة التحقق

---

## البرمجة (developers)

### استخدام Services:

```dart
// LocalAuthService
final localAuth = ref.read(localAuthServiceProvider);

// Biometric
final canCheck = await localAuth.canCheckBiometric();
final authenticated = await localAuth.loginWithBiometric();

// PIN
await localAuth.setPinCode('1234');
final verified = await localAuth.loginWithPin('1234');

// Pattern
await localAuth.setPatternLock('1-2-3-6');
final verified = await localAuth.loginWithPattern('1-2-3-6');
```

```dart
// PhoneAuthService
final phoneAuth = ref.read(phoneAuthServiceProvider);

// إرسال OTP
await phoneAuth.sendOtp('501234567');

// التحقق من OTP
final verified = await phoneAuth.verifyOtp('501234567', '123456');
```

### استخدام Providers:

```dart
// Biometric enabled state
final biometricEnabled = ref.watch(biometricEnabledProvider);

// PIN set state
final pinSet = ref.watch(pinSetProvider);

// Phone verified state
final phoneVerified = ref.watch(phoneVerifiedProvider);

// Toggle biometric
ref.read(biometricEnabledProvider.notifier).toggle(enabled: true);
```

---

## الأمان

### تخزين البيانات:

- **PIN:** مشفر بـ SHA-256 + salt
- **Pattern:** مشفر بـ SHA-256 + salt
- **Biometric:** لا يُخزن (يتم التحقق عبر system API)

### حماية ضد الهجمات:

- محاولة محدودة للتحقق (3 محاولات)
- تأخير بين المحاولات الفاشلة
- تسجيل جميع محاولات التحقق

---

## الأخطاء والحلول

### خطأ: "Biometric not available"

**السبب:** الجهاز لا يدعم البصمة

**الحل:** افتح الإعدادات وتفعيل PIN أو Pattern بدل البصمة

### خطأ: "OTP verification failed"

**السبب:** الرمز غير صحيح أو انتهت صلاحيته

**الحل:** اضغط على "إعادة إرسال الرمز" في شاشة التحقق

### خطأ: "Phone not verified"

**السبب:** لم يتم ربط رقم الجوال

**الحل:** اذهب إلى مركز الأمان واربط رقم الجوال

---

## الملفات الأساسية

```
lib/features/mfa/
├── data/services/
│   └── phone_auth_service.dart
├── domain/services/
│   └── local_auth_service.dart
├── presentation/
│   ├── screens/
│   │   ├── mfa_gate_screen.dart
│   │   ├── mfa_challenge_screen.dart
│   │   ├── mfa_security_center_screen.dart
│   │   ├── phone_verification_screen.dart
│   │   └── phone_otp_screen.dart
│   ├── providers/
│   │   └── mfa_providers.dart
│   └── mfa_routes.dart
```

---

## التحديثات المستقبلية

- [ ] دعم Email MFA
- [ ] دعم Authenticator App (TOTP)
- [ ] دعم Security Key (WebAuthn)
- [ ] إعدادات متقدمة للـ Rate Limiting
- [ ] سجل أحداث التحقق (Audit Log)

---

**ملاحظة:** هذا النظام يتوافق مع معايير ZATCA Phase 2 وIFRS للحفاظ على بيانات مالية آمنة.
