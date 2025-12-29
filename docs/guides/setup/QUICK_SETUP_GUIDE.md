# دليل الإعداد السريع - بيئة التطوير

**المشروع:** بصير MVP  
**التاريخ:** 4 ديسمبر 2025  
**الوقت المتوقع:** 5-10 دقائق

---

## الحالة الحالية

✅ **البيئة جيدة جداً** - جاهزة للتطوير مع بعض التحسينات البسيطة

**التقييم:** ⭐⭐⭐⭐☆ (85/100)

---

## الإعداد السريع (5 دقائق)

### الطريقة 1: السكريبت التلقائي (موصى به) 🚀

```bash
# تشغيل سكريبت الإعداد
./scripts/setup_dev_environment.sh

# اختر: 1 (إعداد كامل)
```

### الطريقة 2: الإعداد اليدوي

#### 1. إعداد Git (إلزامي) ⚠️

```bash
# ضبط معلومات المستخدم
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# التحقق
git config --global user.name
git config --global user.email
```

#### 2. إعداد متغيرات البيئة (موصى به) 🔄

```bash
# إضافة إلى ~/.bashrc
cat >> ~/.bashrc << 'EOF'

# Android SDK
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Java (من Android Studio)
export JAVA_HOME=/snap/android-studio/209/jbr
export PATH=$PATH:$JAVA_HOME/bin

# Flutter
export PATH=$PATH:$HOME/flutter/bin
EOF

# تطبيق التغييرات
source ~/.bashrc
```

#### 3. إعادة تشغيل Terminal

```bash
# أو
source ~/.bashrc
```

---

## التحقق من الإعداد

```bash
# التحقق الشامل
flutter doctor -v

# التحقق من Git
git config --global user.name
git config --global user.email

# التحقق من المتغيرات
echo $ANDROID_HOME
echo $JAVA_HOME

# التحقق من المشروع
flutter analyze
flutter test
```

---

## الإعداد الاختياري (10 دقائق)

### 1. GitHub CLI

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install gh

# تسجيل الدخول
gh auth login
```

### 2. Android Studio Plugins

1. فتح Android Studio
2. File → Settings → Plugins
3. تثبيت: Flutter Plugin + Dart Plugin

### 3. yq (معالجة YAML)

```bash
# Ubuntu/Debian
sudo apt install yq

# أو
sudo snap install yq
```

---

## المكونات المثبتة ✅

| المكون         | الإصدار  |  الحالة  |
| :------------- | :------: | :------: |
| Flutter        |  3.35.5  | ✅ ممتاز |
| Dart           |  3.9.2   | ✅ ممتاز |
| Android SDK    |  36.1.0  | ✅ أحدث  |
| Android Studio | 2025.1.3 | ✅ أحدث  |
| VS Code        | 1.105.1  | ✅ أحدث  |
| Git            |  2.43.0  |  ✅ جيد  |

---

## المكونات المطلوبة ⚠️

| المكون         | الحالة | الأولوية  |
| :------------- | :----: | :-------: |
| Git user.name  |   ❌   | 🔴 عالية  |
| Git user.email |   ❌   | 🔴 عالية  |
| ANDROID_HOME   |   ❌   | 🟡 متوسطة |
| JAVA_HOME      |   ❌   | 🟡 متوسطة |

---

## الموارد المتاحة

| المورد  |    المتاح    |   الحالة    |
| :------ | :----------: | :---------: |
| المساحة |    229 GB    |  ✅ ممتاز   |
| الذاكرة |    13 GB     | ✅ جيد جداً |
| المعالج | Intel HD 530 |  ✅ مناسب   |

---

## الأجهزة المتصلة

- ✅ **U693CL** - Android 9 (API 28)
- ✅ **Chrome** - Web Browser
- ✅ **Linux** - Ubuntu 24.04

---

## الخطوات التالية

### الآن

1. ✅ تشغيل سكريبت الإعداد
2. ✅ إعادة تشغيل Terminal
3. ✅ التحقق من flutter doctor

### قريباً

1. 🔄 تثبيت GitHub CLI (اختياري)
2. 🔄 تثبيت Android Studio Plugins
3. 🔄 مراجعة flutter pub outdated

### لاحقاً

1. 🔄 تحديث التبعيات (إذا لزم الأمر)
2. 🔄 إعداد أدوات إضافية

---

## المساعدة والدعم

### التقارير الكاملة

- [../development/DEV_ENVIRONMENT_ANALYSIS.md](../development/DEV_ENVIRONMENT_ANALYSIS.md) - تحليل شامل
- [../../reports/fixes/POWERS_ANALYSIS_REPORT.md](../../reports/fixes/POWERS_ANALYSIS_REPORT.md) - تحليل Powers

### السكريبتات

- `scripts/setup_dev_environment.sh` - إعداد تلقائي
- `scripts/disable_unused_powers.sh` - تعطيل Powers

### الوثائق

- [README.md](../../../README.md) - نظرة عامة
- [DEVELOPMENT_GUIDE.md](../../reports/engineering/DEV_ENVIRONMENT_ANALYSIS.md) - دليل التطوير
- [CONTRIBUTING.md](../../../CONTRIBUTING.md) - المساهمة

---

## الأسئلة الشائعة

### هل يجب إعداد Git؟

**نعم!** ضروري للـ commits. لن تتمكن من عمل commit بدونه.

### هل يجب ضبط ANDROID_HOME؟

**موصى به** لكن ليس ضرورياً. بعض الأدوات قد تحتاجه.

### هل يجب تثبيت GitHub CLI؟

**اختياري** لكن يسهل إدارة GitHub من Terminal.

### كم يستغرق الإعداد؟

- **الأساسي:** 5 دقائق
- **الكامل:** 10-15 دقيقة

---

## قائمة التحقق السريعة

- [ ] تشغيل سكريبت الإعداد
- [ ] إعداد Git user.name و user.email
- [ ] ضبط متغيرات البيئة
- [ ] إعادة تشغيل Terminal
- [ ] التحقق من flutter doctor
- [ ] تشغيل flutter analyze
- [ ] تشغيل flutter test

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 4 ديسمبر 2025

**🚀 جاهز للتطوير!**
