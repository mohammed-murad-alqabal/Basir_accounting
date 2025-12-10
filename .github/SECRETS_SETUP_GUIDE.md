# دليل إعداد GitHub Secrets

**المشروع:** بصير MVP  
**التاريخ:** 8 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## 🎯 نظرة عامة

هذا الدليل يشرح كيفية إعداد GitHub Secrets المطلوبة لتشغيل CI/CD workflows بشكل صحيح.

---

## 📋 Secrets المطلوبة

### 1. Android Signing Secrets

#### KEYSTORE_BASE64

**الوصف:** ملف keystore مشفر بـ base64  
**الاستخدام:** توقيع APK/AAB للإصدارات

**كيفية الإنشاء:**

```bash
# 1. إنشاء keystore (إذا لم يكن موجوداً)
keytool -genkey -v -keystore basser-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias basser

# 2. تحويل إلى base64
base64 basser-release-key.jks > keystore.base64

# 3. نسخ المحتوى وإضافته كـ Secret
cat keystore.base64
```

#### KEYSTORE_PASSWORD

**الوصف:** كلمة مرور الـ keystore  
**الاستخدام:** فك تشفير keystore

**القيمة:** كلمة المرور التي استخدمتها عند إنشاء keystore

#### KEY_PASSWORD

**الوصف:** كلمة مرور المفتاح  
**الاستخدام:** الوصول للمفتاح داخل keystore

**القيمة:** كلمة مرور المفتاح (عادة نفس KEYSTORE_PASSWORD)

#### KEY_ALIAS

**الوصف:** اسم المفتاح (alias)  
**الاستخدام:** تحديد المفتاح المستخدم

**القيمة:** `basser` (أو الاسم الذي استخدمته)

---

### 2. Code Coverage Secrets

#### CODECOV_TOKEN

**الوصف:** Token للرفع على Codecov  
**الاستخدام:** رفع تقارير التغطية

**كيفية الحصول عليه:**

1. اذهب إلى [codecov.io](https://codecov.io)
2. سجل دخول بحساب GitHub
3. أضف المستودع
4. انسخ الـ token

---

### 3. Firebase Secrets (اختياري)

#### FIREBASE_SERVICE_ACCOUNT

**الوصف:** Service account JSON  
**الاستخدام:** نشر على Firebase Hosting

**كيفية الحصول عليه:**

1. Firebase Console → Project Settings
2. Service Accounts → Generate new private key
3. نسخ محتوى JSON file

---

### 4. Notification Secrets (اختياري)

#### SLACK_WEBHOOK_URL

**الوصف:** Webhook URL للإشعارات  
**الاستخدام:** إرسال إشعارات للفريق

#### DISCORD_WEBHOOK_URL

**الوصف:** Discord webhook  
**الاستخدام:** إشعارات Discord

---

## 🔧 كيفية إضافة Secrets

### الطريقة 1: عبر GitHub UI

1. اذهب إلى المستودع على GitHub
2. Settings → Secrets and variables → Actions
3. اضغط "New repository secret"
4. أدخل الاسم والقيمة
5. اضغط "Add secret"

### الطريقة 2: عبر GitHub CLI

```bash
# تثبيت GitHub CLI
# https://cli.github.com/

# تسجيل الدخول
gh auth login

# إضافة secret
gh secret set KEYSTORE_PASSWORD

# إضافة من ملف
gh secret set KEYSTORE_BASE64 < keystore.base64
```

---

## ✅ التحقق من Secrets

### قائمة التحقق

- [ ] KEYSTORE_BASE64
- [ ] KEYSTORE_PASSWORD
- [ ] KEY_PASSWORD
- [ ] KEY_ALIAS
- [ ] CODECOV_TOKEN (اختياري)
- [ ] FIREBASE_SERVICE_ACCOUNT (اختياري)
- [ ] SLACK_WEBHOOK_URL (اختياري)

### اختبار Secrets

بعد إضافة Secrets:

1. اذهب إلى Actions tab
2. اختر workflow (مثل Flutter CI/CD)
3. اضغط "Run workflow"
4. تحقق من النتائج

---

## 🔒 أفضل الممارسات الأمنية

### ✅ افعل

- ✅ استخدم secrets قوية وفريدة
- ✅ قم بتدوير secrets بشكل دوري
- ✅ استخدم secrets مختلفة للبيئات المختلفة
- ✅ احتفظ بنسخة احتياطية آمنة من keystore
- ✅ استخدم 2FA على حساب GitHub

### ❌ لا تفعل

- ❌ لا تشارك secrets عبر البريد الإلكتروني
- ❌ لا تحفظ secrets في الكود
- ❌ لا تستخدم نفس secrets للتطوير والإنتاج
- ❌ لا تنسخ secrets في ملفات نصية غير مشفرة
- ❌ لا تشارك keystore في version control

---

## 🆘 استكشاف الأخطاء

### خطأ: "Keystore not found"

**الحل:**

```bash
# تحقق من base64 encoding
echo $KEYSTORE_BASE64 | base64 -d > test.jks
keytool -list -v -keystore test.jks
```

### خطأ: "Wrong password"

**الحل:**

- تحقق من KEYSTORE_PASSWORD
- تحقق من KEY_PASSWORD
- تأكد من عدم وجود مسافات إضافية

### خطأ: "Alias not found"

**الحل:**

```bash
# عرض جميع aliases
keytool -list -v -keystore basser-release-key.jks
```

---

## 📚 المراجع

### الوثائق الرسمية

- [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Codecov](https://docs.codecov.com/docs)

### الأدلة الداخلية

- `.github/workflows/flutter_ci.yml` - استخدام Secrets
- `.github/workflows/release.yml` - Release workflow
- `android/app/build.gradle` - Android signing config

---

## 📞 الدعم

للمساعدة:

1. راجع هذا الدليل
2. تحقق من workflow logs
3. راجع `.github/workflows/` للتفاصيل

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 8 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
