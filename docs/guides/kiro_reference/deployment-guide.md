# دليل النشر الكامل

**المشروع:** بصير MVP  
**التاريخ:** 8 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## 🎯 نظرة عامة

هذا الدليل يحتوي على جميع خطوات وأفضل ممارسات نشر تطبيق بصير MVP على المنصات المختلفة.

---

## 📱 Android Deployment

### المتطلبات

- Android Studio
- Java JDK 11+
- Android SDK
- Keystore للتوقيع

### 1. إعداد Keystore

```bash
# إنشاء keystore جديد
keytool -genkey -v -keystore ~/basser-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias basser

# التحقق من الـ keystore
keytool -list -v -keystore ~/basser-release-key.jks
```

### 2. تكوين Gradle

#### android/key.properties

```properties
storePassword=<password>
keyPassword=<password>
keyAlias=basser
storeFile=<path-to-keystore>
```

#### android/app/build.gradle

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = <credential-fixture>('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 3. بناء APK

```bash
# بناء APK
flutter build apk --release

# بناء App Bundle (موصى به)
flutter build appbundle --release

# الملفات الناتجة
# APK: build/app/outputs/flutter-apk/app-release.apk
# AAB: build/app/outputs/bundle/release/app-release.aab
```

### 4. اختبار APK

```bash
# تثبيت على جهاز متصل
flutter install --release

# أو يدوياً
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 5. النشر على Google Play

#### أ. إعداد Google Play Console

1. إنشاء حساب مطور
2. إنشاء تطبيق جديد
3. ملء معلومات التطبيق
4. إعداد الأسعار والتوزيع

#### ب. رفع App Bundle

```bash
# بناء App Bundle
flutter build appbundle --release

# رفع على Google Play Console
# 1. اذهب إلى Production > Create new release
# 2. ارفع app-release.aab
# 3. أضف release notes
# 4. Review and rollout
```

#### ج. Metadata

- العنوان (30 حرف)
- الوصف القصير (80 حرف)
- الوصف الكامل (4000 حرف)
- Screenshots (2-8 صور)
- Feature Graphic (1024x500)
- App Icon (512x512)

---

## 🍎 iOS Deployment

### المتطلبات

- macOS
- Xcode 14+
- Apple Developer Account
- Certificates & Provisioning Profiles

### 1. إعداد Xcode

```bash
# فتح المشروع في Xcode
open ios/Runner.xcworkspace

# في Xcode:
# 1. اختر Runner في Navigator
# 2. اختر Signing & Capabilities
# 3. اختر Team
# 4. تأكد من Bundle Identifier
```

### 2. تكوين Info.plist

```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>بصير</string>

<key>CFBundleShortVersionString</key>
<string>1.0.0</string>

<key>CFBundleVersion</key>
<string>1</string>

<!-- Permissions -->
<key>NSCameraUsageDescription</key>
<string>نحتاج الوصول للكاميرا لمسح الفواتير</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>نحتاج الوصول للصور لحفظ الفواتير</string>
```

### 3. بناء IPA

```bash
# بناء للـ release
flutter build ios --release

# أو من Xcode:
# Product > Archive
# ثم Distribute App
```

### 4. النشر على App Store

#### أ. إعداد App Store Connect

1. إنشاء App ID
2. إنشاء App في App Store Connect
3. ملء معلومات التطبيق
4. إعداد الأسعار والتوفر

#### ب. رفع Build

```bash
# من Xcode:
# 1. Product > Archive
# 2. Window > Organizer
# 3. اختر Archive
# 4. Distribute App
# 5. App Store Connect
# 6. Upload

# أو باستخدام Transporter
# 1. Export IPA من Xcode
# 2. افتح Transporter
# 3. ارفع IPA
```

#### ج. Metadata

- App Name (30 حرف)
- Subtitle (30 حرف)
- Description (4000 حرف)
- Keywords (100 حرف)
- Screenshots (مطلوب لكل حجم)
- App Icon (1024x1024)

### 5. TestFlight

```bash
# بعد رفع Build:
# 1. اذهب إلى TestFlight في App Store Connect
# 2. اختر Build
# 3. أضف Internal Testers
# 4. أضف External Testers (يحتاج مراجعة)
```

---

## 🌐 Web Deployment

### 1. بناء Web

```bash
# بناء للـ production
flutter build web --release

# الملفات الناتجة في build/web/
```

### 2. تحسين الأداء

#### flutter build web options

```bash
flutter build web \
  --release \
  --web-renderer canvaskit \
  --pwa-strategy offline-first
```

#### تحسين الصور

```bash
# ضغط الصور
find assets/images -name "*.png" -exec pngquant --ext .png --force {} \;
find assets/images -name "*.jpg" -exec jpegoptim --max=85 {} \;
```

### 3. النشر على Firebase Hosting

```bash
# تثبيت Firebase CLI
npm install -g firebase-tools

# تسجيل الدخول
firebase login

# تهيئة المشروع
firebase init hosting

# النشر
firebase deploy --only hosting
```

#### firebase.json

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(jpg|jpeg|gif|png|svg|webp)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

### 4. النشر على Netlify

```bash
# تثبيت Netlify CLI
npm install -g netlify-cli

# تسجيل الدخول
netlify login

# النشر
netlify deploy --prod --dir=build/web
```

---

## 🔄 CI/CD

### GitHub Actions - Android

```yaml
name: Android Release

on:
  push:
    tags:
      - "v*"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - uses: actions/setup-java@v2
        with:
          distribution: "zulu"
          java-version: "11"

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.24.0"

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test

      - name: Decode keystore
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/keystore.jks

      - name: Create key.properties
        run: |
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" > android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=keystore.jks" >> android/key.properties

      - name: Build APK
        run: flutter build apk --release

      - name: Build App Bundle
        run: flutter build appbundle --release

      - name: Upload APK
        uses: actions/upload-artifact@v2
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk

      - name: Upload App Bundle
        uses: actions/upload-artifact@v2
        with:
          name: app-release.aab
          path: build/app/outputs/bundle/release/app-release.aab
```

### GitHub Actions - iOS

```yaml
name: iOS Release

on:
  push:
    tags:
      - "v*"

jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.24.0"

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test

      - name: Build iOS
        run: flutter build ios --release --no-codesign

      - name: Archive
        run: |
          cd ios
          xcodebuild -workspace Runner.xcworkspace \
            -scheme Runner \
            -configuration Release \
            -archivePath build/Runner.xcarchive \
            archive

      - name: Export IPA
        run: |
          cd ios
          xcodebuild -exportArchive \
            -archivePath build/Runner.xcarchive \
            -exportPath build \
            -exportOptionsPlist ExportOptions.plist

      - name: Upload IPA
        uses: actions/upload-artifact@v2
        with:
          name: app-release.ipa
          path: ios/build/Runner.ipa
```

---

## 📋 Versioning

### Semantic Versioning

```
MAJOR.MINOR.PATCH+BUILD

مثال: 1.2.3+45
```

- **MAJOR**: تغييرات كبيرة
- **MINOR**: ميزات جديدة
- **PATCH**: إصلاحات
- **BUILD**: رقم البناء

### تحديث الإصدار

#### pubspec.yaml

```yaml
version: 1.2.3+45
```

#### تحديث تلقائي

```bash
# زيادة PATCH
flutter pub run cider bump patch

# زيادة MINOR
flutter pub run cider bump minor

# زيادة MAJOR
flutter pub run cider bump major

# زيادة BUILD
flutter pub run cider bump build
```

---

## 🔍 Pre-Release Checklist

### قبل كل Release

- [ ] جميع الاختبارات تنجح
- [ ] flutter analyze بدون أخطاء
- [ ] التغطية > 70%
- [ ] التوثيق محدث
- [ ] CHANGELOG محدث
- [ ] الإصدار محدث في pubspec.yaml
- [ ] Screenshots محدثة
- [ ] Release notes جاهزة

### Android Specific

- [ ] Keystore آمن
- [ ] ProGuard rules محدثة
- [ ] Permissions صحيحة
- [ ] App Bundle مبني
- [ ] اختبار على أجهزة مختلفة

### iOS Specific

- [ ] Certificates صالحة
- [ ] Provisioning Profiles محدثة
- [ ] Info.plist محدث
- [ ] Archive ناجح
- [ ] اختبار على أجهزة مختلفة

---

## 🚀 Release Process

### 1. التحضير

```bash
# تحديث من main
git checkout main
git pull origin main

# إنشاء فرع release
git checkout -b release/v1.2.3

# تحديث الإصدار
# تحديث pubspec.yaml
# تحديث CHANGELOG.md

# commit
git add .
git commit -m "chore(release): prepare v1.2.3"
```

### 2. البناء والاختبار

```bash
# تشغيل الاختبارات
flutter test --coverage

# بناء Android
flutter build apk --release
flutter build appbundle --release

# بناء iOS (على macOS)
flutter build ios --release

# اختبار على أجهزة حقيقية
```

### 3. النشر

```bash
# دمج في main
git checkout main
git merge release/v1.2.3

# إنشاء tag
git tag -a v1.2.3 -m "Release version 1.2.3"

# push
git push origin main
git push origin v1.2.3

# حذف فرع release
git branch -d release/v1.2.3
```

### 4. النشر على المتاجر

#### Android

1. رفع AAB على Google Play Console
2. إضافة release notes
3. اختيار rollout percentage
4. Review and publish

#### iOS

1. رفع IPA على App Store Connect
2. إضافة release notes
3. Submit for review
4. بعد الموافقة: Release

---

## 📊 Monitoring

### Crashlytics

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}
```

### Analytics

```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
}
```

---

## 📚 المراجع

### الوثائق الرسمية

- [Flutter Deployment](https://flutter.dev/docs/deployment)
- [Android Publishing](https://developer.android.com/studio/publish)
- [iOS Distribution](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)

### المعايير الداخلية

- `.kiro/steering/core/philosophy.md` - المبادئ الأساسية
- `.kiro/steering/standards/code-quality.md` - معايير الجودة
- `.kiro/steering/guides/git-guide.md` - دليل Git

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 8 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد
