# دليل إعداد CI/CD لمشروع Basser MVP

## نظرة عامة

هذا الدليل يوضح كيفية إعداد مسار التكامل المستمر والنشر المستمر (CI/CD) لمشروع Basser MVP باستخدام GitHub Actions.

## المتطلبات

- حساب GitHub مع صلاحيات الإدارة على المستودع
- Flutter SDK محدث
- Dart SDK محدث
- أدوات البناء الأساسية (Android SDK، Xcode للـ iOS)

## خطوات الإعداد

### 1. إنشاء ملف Workflow

قم بإنشاء ملف جديد في المسار `.github/workflows/ci.yml` مع المحتوى التالي:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'

      - name: Get Flutter dependencies
        run: flutter pub get

      - name: Run code analysis
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
          flags: unittests
          name: codecov-umbrella

  build:
    runs-on: ubuntu-latest
    needs: test

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'

      - name: Get Flutter dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK artifact
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

### 2. تفعيل Workflows في إعدادات المستودع

1. انتقل إلى **Settings** في مستودع GitHub
2. اختر **Actions** من القائمة الجانبية
3. تأكد من تفعيل **GitHub Actions**
4. انتقل إلى **Workflow permissions** وتأكد من منح الصلاحيات اللازمة

### 3. تشغيل الـ Workflow

عند كل push إلى الفرع `main` أو `develop`، سيتم تشغيل الـ Workflow تلقائياً.

## مراحل الـ Workflow

### المرحلة 1: الاختبار (Test)

- **Checkout code:** جلب الكود من المستودع
- **Setup Flutter:** تثبيت Flutter SDK
- **Get dependencies:** تثبيت المكتبات المطلوبة
- **Code analysis:** تحليل الكود بحثاً عن أخطاء
- **Run tests:** تشغيل جميع الاختبارات
- **Upload coverage:** رفع تقارير التغطية إلى Codecov

### المرحلة 2: البناء (Build)

- **Checkout code:** جلب الكود من المستودع
- **Setup Flutter:** تثبيت Flutter SDK
- **Get dependencies:** تثبيت المكتبات المطلوبة
- **Build APK:** بناء ملف APK للإصدار
- **Upload artifact:** رفع ملف APK كـ artifact

## الخطوات التالية

### 1. إضافة اختبارات إضافية

يجب إضافة اختبارات لطبقة `Presentation` (UI Tests) و `Data` (Integration Tests) لزيادة تغطية الاختبارات.

### 2. إضافة فحوصات الأمان

يمكن إضافة خطوات إضافية للفحص عن الثغرات الأمنية في المكتبات الخارجية:

```yaml
- name: Run security checks
  run: flutter pub audit
```

### 3. إضافة بناء iOS

يمكن إضافة خطوة لبناء تطبيق iOS (يتطلب macOS runner):

```yaml
- name: Build iOS
  run: flutter build ios --release --no-codesign
```

### 4. النشر التلقائي

يمكن إضافة خطوات لنشر التطبيق تلقائياً إلى Google Play Store و App Store.

## استكشاف الأخطاء

### الخطأ: "refusing to allow a GitHub App to create or update workflow"

**السبب:** المستودع لا يملك الصلاحيات اللازمة لـ GitHub Actions.

**الحل:** 
1. انتقل إلى **Settings** → **Actions** → **General**
2. تأكد من تفعيل **GitHub Actions**
3. انتقل إلى **Workflow permissions** واختر **Read and write permissions**

### الخطأ: "Flutter command not found"

**السبب:** Flutter SDK لم يتم تثبيته بشكل صحيح.

**الحل:** تأكد من استخدام الإصدار الصحيح من Flutter في الـ Workflow:

```yaml
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.24.0'
    channel: 'stable'
```

## المراجع

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://flutter.dev/docs/deployment/cd)
- [Codecov Integration](https://codecov.io/gh)
