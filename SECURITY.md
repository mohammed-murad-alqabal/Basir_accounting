# 🔒 سياسة الأمان - مشروع بصير MVP

## نظرة عامة

الأمان هو أولويتنا القصوى. هذا المستند يوضح سياسة الأمان وكيفية الإبلاغ عن الثغرات.

---

## 🎯 المبدأ الصفري: Security First

> "يجب أن تلتزم جميع أنشطة التطوير بمعايير الأمان المحددة"

راجع `.kiro/steering/security.md` للتفاصيل الكاملة.

---

## 🛡️ الإصدارات المدعومة

| الإصدار     | الدعم |
| :---------- | :---: |
| 1.0.x (MVP) |  ✅   |
| < 1.0       |  ❌   |

---

## 🚨 الإبلاغ عن ثغرة أمنية

### ⚠️ لا تفتح Issue عام!

إذا اكتشفت ثغرة أمنية، يرجى **عدم** فتح issue عام. بدلاً من ذلك:

### 1. الإبلاغ الخاص

أرسل تقرير مفصل إلى:

- **Email:** [security@example.com]
- **Subject:** [SECURITY] وصف مختصر للثغرة

### 2. ما يجب تضمينه

```markdown
**نوع الثغرة:**
[e.g. SQL Injection, XSS, etc.]

**الخطورة:**
[Critical / High / Medium / Low]

**الوصف:**
وصف تفصيلي للثغرة

**خطوات إعادة الإنتاج:**

1. ...
2. ...
3. ...

**التأثير:**
ما الذي يمكن أن يحدث؟

**الحل المقترح:**
(اختياري) كيف يمكن إصلاحها؟

**البيئة:**

- OS: ...
- Flutter: ...
- Device: ...
```

### 3. ما نتوقعه منك

- ✅ إعطاءنا وقت معقول للإصلاح (90 يوم)
- ✅ عدم الكشف العلني قبل الإصلاح
- ✅ عدم استغلال الثغرة
- ✅ التعاون معنا لحل المشكلة

### 4. ما تتوقعه منا

- ✅ تأكيد الاستلام خلال 48 ساعة
- ✅ تحديث منتظم عن التقدم
- ✅ إصلاح سريع حسب الخطورة
- ✅ شكر علني (إذا رغبت)

---

## 🔐 معايير الأمان

### 1. تخزين البيانات

#### البيانات الحساسة

- ✅ استخدام `flutter_secure_storage`
- ✅ تجزئة كلمات المرور بـ bcrypt مع salt فريد
- ⚠️ يجب تشغيل ترحيل legacy hashes والتحقق منه في بيئة الإصدار
- ✅ عدم تخزين بيانات بطاقات الائتمان
- ❌ عدم تخزين أسرار في SharedPreferences

#### البيانات العادية

- ✅ استخدام Isar (قاعدة بيانات محلية)
- ⚠️ تشفير قاعدة البيانات غير متاح أصليًا في Isar الحالي؛ لا يُعد خيارًا إنتاجيًا بعد
- ✅ نسخ احتياطي مع SHA-256 integrity checks، بينما تشفير النسخ النهائي ما زال مطلوبًا

### 2. المصادقة

#### كلمات المرور

- ✅ الحد الأدنى: 8 أحرف
- ✅ Hashing: bcrypt + salt فريد
- ⚠️ recovery يعتمد على جلسة Supabase موثقة؛ لا يُسمح بتغيير كلمة المرور عبر اسم المستخدم فقط
- ✅ عدم تخزين نصي
- ⚠️ قفل المحاولات يحتاج تنفيذًا خادميًا/محليًا قابلًا للإثبات

#### الجلسات

- ⚠️ انتهاء الجلسة بعد 30 دقيقة وتسجيل الخروج التلقائي يحتاجان اختبارًا على الجهاز الفعلي
- ⚠️ يجب تطبيق idle timeout وabsolute timeout وإبطال الجلسات بعد تغيير كلمة المرور
- ✅ logout يمسح حالة الجلسة المحلية ووضع الضيف

### 3. الشبكة (عند تفعيل التكامل السحابي)

#### HTTPS

- ✅ استخدام HTTPS فقط
- ⚠️ Certificate pinning يحتاج قرارًا واختبارًا خاصًا بالمنصات قبل ادعائه
- ✅ عدم السماح بـ HTTP

#### API

- ✅ مصادقة بـ Token
- ⚠️ Rate limiting يجب أن يفرضه backend/Supabase Edge Function، وليس عميل Flutter
- ✅ Input Validation

### 4. الأذونات

#### Android

```xml
<!-- الأذونات الضرورية فقط -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

#### iOS

```xml
<!-- الأذونات الضرورية فقط -->
<key>NSPhotoLibraryUsageDescription</key>
<string>لحفظ الفواتير كصور</string>
```

### 5. الكود

#### Input Validation

```dart
// ✅ جيد
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'البريد الإلكتروني مطلوب';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'البريد الإلكتروني غير صحيح';
  }
  return null;
}

// ❌ سيء
String? validateEmail(String? value) {
  return null; // لا يوجد تحقق!
}
```

#### SQL Injection Prevention

```dart
// ✅ جيد - استخدام Isar (آمن)
await isar.customers.filter()
  .nameEqualTo(customerName)
  .findAll();

// ❌ سيء - استخدام raw SQL
await db.rawQuery('SELECT * FROM customers WHERE name = "$customerName"');
```

#### XSS Prevention

```dart
// ✅ جيد - تنظيف المدخلات
String sanitize(String input) {
  return input
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}
```

---

## 🔍 فحوصات الأمان

### التلقائية

#### 1. Pre-Commit Hook

```bash
# يعمل تلقائياً عند git commit
.kiro/hooks/on-commit/10_security_scan.sh
```

**ما يفحصه:**

- API keys, passwords, tokens
- ملفات حساسة (google-services.json, etc.)
- أنماط .gitignore

#### 2. CI/CD

```yaml
# يعمل تلقائياً عند push/PR
.github/workflows/flutter_ci.yml
```

**ما يفحصه:**

- فحص الأسرار
- فحص التبعيات للثغرات
- تحليل الكود

### اليدوية

#### 1. فحص التبعيات

```bash
# شهرياً
flutter pub outdated
```

#### 2. مراجعة الكود

- مراجعة جميع PRs
- التركيز على الأمان
- استخدام checklist

---

## 📋 قائمة التحقق الأمنية

### للمطورين

قبل كل Commit:

- [ ] لا توجد أسرار في الكود
- [ ] Input validation موجود
- [ ] استخدام flutter_secure_storage للبيانات الحساسة
- [ ] لا توجد ملفات حساسة في Git

قبل كل Release:

- [ ] فحص شامل للأمان
- [ ] تحديث التبعيات
- [ ] مراجعة الأذونات
- [ ] اختبار الاختراق (Penetration Testing)

### للمراجعين

عند مراجعة PR:

- [ ] فحص الأمان
- [ ] Input validation
- [ ] معالجة الأخطاء
- [ ] تخزين البيانات
- [ ] الأذونات

---

## 🛠️ أدوات الأمان

### المستخدمة حالياً

1. **flutter_secure_storage** - تخزين آمن
2. **crypto** - تشفير
3. **Security Scan Hook** - فحص تلقائي
4. **flutter analyze** - تحليل الكود

### موصى بها (مستقبلي)

1. **OWASP Dependency Check** - فحص التبعيات
2. **SonarQube** - تحليل الأمان
3. **Snyk** - فحص الثغرات
4. **GitGuardian** - فحص الأسرار

---

## 📚 الموارد

### الداخلية

- `.kiro/steering/security.md` - معايير الأمان الكاملة
- `.kiro/steering/philosophy.md` - المبدأ الصفري
- `.kiro/hooks/on-commit/10_security_scan.sh` - فحص الأمان

### الخارجية

- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)
- [Dart Security](https://dart.dev/guides/security)

---

## 🏆 شكر وتقدير

نشكر جميع الباحثين الأمنيين الذين ساعدوا في تحسين أمان بصير:

- (قائمة الباحثين سيتم تحديثها)

---

## 📞 الاتصال

للأمور الأمنية فقط:

- **Email:** [security@example.com]
- **PGP Key:** [رابط المفتاح]

للأمور العامة:

- **GitHub Issues:** للـ bugs العامة
- **Email:** [contact@example.com]

---

## 📜 التحديثات

| التاريخ    | الإصدار | التغيير    |
| :--------- | :------ | :--------- |
| 2025-11-27 | 1.0     | إصدار أولي |

---

**آخر تحديث:** 27 نوفمبر 2025  
**الحالة:** ✅ نشط

**تذكر: الأمان مسؤولية الجميع! 🔒**
