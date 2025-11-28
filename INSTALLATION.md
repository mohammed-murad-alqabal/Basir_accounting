# تعليمات التثبيت والإعداد

هذا الملف يوفر تعليمات مفصلة لتثبيت وإعداد تطبيق بصير على أجهزة مختلفة.

## المتطلبات الأساسية

### النظام الأساسي
- **Windows**: Windows 10 أو أحدث
- **macOS**: macOS 10.13 أو أحدث
- **Linux**: Ubuntu 18.04 أو أحدث

### البرامج المطلوبة
- **Flutter**: 3.24.0 أو أحدث
- **Dart**: 3.5.0 أو أحدث
- **Git**: 2.20 أو أحدث
- **Android Studio**: 2021.1 أو أحدث (لتطوير Android)
- **Xcode**: 12 أو أحدث (لتطوير iOS على macOS)

## تثبيت Flutter

### على Windows

1. **تحميل Flutter SDK**
   - اذهب إلى [flutter.dev](https://flutter.dev)
   - حمل Flutter SDK لـ Windows

2. **استخراج الملف**
   - استخرج الملف المحمل إلى مجلد (مثال: `C:\flutter`)

3. **إضافة Flutter إلى PATH**
   - افتح "System Environment Variables"
   - أضف مسار Flutter إلى متغير PATH

4. **التحقق من التثبيت**
   ```bash
   flutter doctor
   ```

### على macOS

```bash
# استخدام Homebrew
brew install flutter

# أو التحميل اليدوي
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# التحقق من التثبيت
flutter doctor
```

### على Linux

```bash
# تحميل Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# التحقق من التثبيت
flutter doctor
```

## تثبيت المتطلبات الإضافية

### Android

```bash
# تثبيت Android SDK
flutter config --android-sdk /path/to/android/sdk

# قبول رخص Android
flutter doctor --android-licenses
```

### iOS (على macOS فقط)

```bash
# تثبيت Xcode Command Line Tools
xcode-select --install

# تثبيت CocoaPods
sudo gem install cocoapods
```

## تثبيت تطبيق بصير

### 1. استنساخ المشروع

```bash
git clone https://github.com/your-username/basser_mvp_project.git
cd basser_mvp_project
```

### 2. تثبيت المكتبات

```bash
flutter pub get
```

### 3. توليد الملفات المُنتجة

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. التحقق من الإعداد

```bash
flutter doctor
```

## تشغيل التطبيق

### على محاكي Android

```bash
# بدء محاكي Android من Android Studio أو:
emulator -avd <emulator-name>

# تشغيل التطبيق
flutter run
```

### على جهاز Android فعلي

```bash
# تفعيل وضع المطور على الجهاز
# تشغيل التطبيق
flutter run
```

### على محاكي iOS (على macOS فقط)

```bash
# بدء محاكي iOS
open -a Simulator

# تشغيل التطبيق
flutter run
```

### على جهاز iOS فعلي (على macOS فقط)

```bash
# تشغيل التطبيق
flutter run
```

## استكشاف الأخطاء

### مشكلة: Flutter غير معروف

**الحل**: تأكد من إضافة Flutter إلى PATH بشكل صحيح.

```bash
# التحقق من PATH
echo $PATH

# إضافة Flutter إلى bashrc/zshrc
export PATH="$PATH:`pwd`/flutter/bin"
```

### مشكلة: Android SDK غير موجود

**الحل**: تثبيت Android SDK من خلال Android Studio.

```bash
flutter config --android-sdk /path/to/android/sdk
```

### مشكلة: Xcode غير موجود (على macOS)

**الحل**: تثبيت Xcode من App Store.

```bash
xcode-select --install
```

### مشكلة: مشاكل في المكتبات

**الحل**: إعادة تثبيت المكتبات.

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## إعدادات التطوير

### استخدام VS Code

1. **تثبيت الإضافات**
   - Flutter
   - Dart
   - Awesome Flutter Snippets

2. **إعدادات launch.json**
   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "Flutter",
         "type": "dart",
         "request": "launch",
         "program": "lib/main.dart"
       }
     ]
   }
   ```

### استخدام Android Studio

1. **تثبيت الإضافات**
   - Flutter
   - Dart

2. **إعدادات المشروع**
   - File > Settings > Languages & Frameworks > Flutter
   - تحديد مسار Flutter SDK

## الخطوات التالية

بعد التثبيت الناجح:

1. اقرأ ملف `README.md` للحصول على نظرة عامة
2. اقرأ `DEVELOPMENT_GUIDE.md` لفهم سير العمل
3. اقرأ `ARCHITECTURE.md` لفهم البنية المعمارية
4. ابدأ التطوير!

## الدعم

إذا واجهت مشاكل:

1. تحقق من [Flutter Documentation](https://flutter.dev/docs)
2. افتح Issue على GitHub
3. تواصل مع الفريق

---

**آخر تحديث**: نوفمبر 2025
