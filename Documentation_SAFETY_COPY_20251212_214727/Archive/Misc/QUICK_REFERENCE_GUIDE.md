# دليل مرجعي سريع - بصير MVP

## Quick Reference Guide

**آخر تحديث:** 2025-11-28

---

## 🚀 البدء السريع

### إعداد المشروع

```bash
# 1. استنساخ المشروع
git clone <repository-url>
cd Basser_MVP

# 2. إعداد Git
./scripts/setup_git.sh

# 3. تثبيت التبعيات
flutter pub get

# 4. تشغيل الاختبارات
flutter test

# 5. تشغيل التطبيق
flutter run
```

---

## 📝 Conventional Commits

### الصيغة

```
type(scope): description

[optional body]

[optional footer]
```

### الأنواع الشائعة

| النوع       | الاستخدام   | مثال                           |
| :---------- | :---------- | :----------------------------- |
| `feat:`     | ميزة جديدة  | `feat(auth): إضافة تسجيل دخول` |
| `fix:`      | إصلاح خطأ   | `fix(invoice): إصلاح الحساب`   |
| `docs:`     | توثيق       | `docs: تحديث README`           |
| `test:`     | اختبارات    | `test(auth): إضافة اختبارات`   |
| `refactor:` | إعادة هيكلة | `refactor(core): تحسين البنية` |
| `feat!:`    | تغيير كبير  | `feat!: تغيير API`             |

---

## 🌿 Git Workflow

### إنشاء ميزة جديدة

```bash
# 1. إنشاء فرع
git checkout -b feature/my-feature

# 2. كتابة الكود
# ...

# 3. Commit
git add .
git commit -m "feat(module): إضافة ميزة جديدة"

# 4. Push
git push -u origin feature/my-feature

# 5. إنشاء PR على GitHub
```

### إصلاح خطأ

```bash
# 1. إنشاء فرع
git checkout -b fix/bug-name

# 2. إصلاح الخطأ
# ...

# 3. Commit
git commit -m "fix(module): إصلاح الخطأ"

# 4. Push
git push -u origin fix/bug-name
```

---

## 🏷️ إنشاء إصدار جديد

### الطريقة الكاملة

```bash
# 1. تحديث CHANGELOG.md
# أضف التغييرات تحت [X.Y.Z]

# 2. Commit التغييرات
git add CHANGELOG.md
git commit -m "chore: تحديث CHANGELOG لـ v1.2.0"

# 3. إنشاء tag
git tag -a v1.2.0 -m "Release 1.2.0"

# 4. Push
git push origin main
git push origin v1.2.0

# 5. GitHub Actions سينشئ Release تلقائياً
```

---

## 🧪 الاختبارات

### تشغيل الاختبارات

```bash
# جميع الاختبارات
flutter test

# مع التغطية
flutter test --coverage

# اختبار محدد
flutter test test/unit/auth_test.dart

# مع تقرير مفصل
flutter test --reporter expanded
```

### فحص التغطية

```bash
# تثبيت lcov
sudo apt-get install lcov

# توليد تقرير HTML
genhtml coverage/lcov.info -o coverage/html

# فتح التقرير
open coverage/html/index.html
```

---

## 🔍 فحص الجودة

### Flutter Analyze

```bash
# فحص الكود
flutter analyze

# فحص بدون pub get
flutter analyze --no-pub
```

### Flutter Format

```bash
# تنسيق الكود
flutter format lib/ test/

# فحص التنسيق فقط
flutter format --set-exit-if-changed lib/ test/
```

---

## 📊 السجلات والتقارير

### جمع السجلات

```bash
# جمع السجلات فقط
./scripts/collect_and_push_logs.sh

# جمع ودفع إلى Git
./scripts/collect_and_push_logs.sh --push
```

### تسجيل الأخطاء

```bash
# تشغيل نظام تسجيل الأخطاء
./scripts/log_error.sh
```

### عرض التقارير

```bash
# التقرير اليومي
cat logs/reports/daily_report_$(date +%Y-%m-%d).md

# التقرير الشامل
cat logs/reports/comprehensive_report_$(date +%Y-%m-%d).md
```

---

## 🔧 Git Hooks

### تفعيل/تعطيل

```bash
# تفعيل
git config core.hooksPath .githooks

# تعطيل مؤقت (commit واحد)
git commit --no-verify

# تعطيل دائم
git config core.hooksPath ""
```

---

## 🏗️ البناء

### Android

```bash
# APK
flutter build apk --release

# App Bundle
flutter build appbundle --release

# فحص الحجم
du -h build/app/outputs/flutter-apk/app-release.apk
```

### iOS

```bash
# بدون توقيع
flutter build ios --release --no-codesign

# مع توقيع
flutter build ios --release
```

---

## 🔒 الأمان

### فحص الأسرار

```bash
# فحص يدوي
grep -r "password\|api_key\|secret\|token" lib/ --include="*.dart"

# سيتم الفحص تلقائياً في:
# - pre-push hook
# - GitHub Actions
```

### فحص الثغرات

```bash
# فحص التبعيات
flutter pub outdated --mode=null-safety

# فحص شامل
flutter analyze
```

---

## 📚 التوثيق

### توليد DartDoc

```bash
# توليد التوثيق
dart doc .

# عرض التوثيق
open doc/api/index.html
```

---

## 🤖 GitHub Actions

### عرض النتائج

1. اذهب إلى **Actions** في GitHub
2. اختر Workflow
3. اختر Run
4. شاهد النتائج

### Workflows المتوفرة

| Workflow                | التشغيل        | الوظيفة            |
| :---------------------- | :------------- | :----------------- |
| **Flutter CI/CD**       | Push, PR       | بناء واختبار       |
| **Error Tracking**      | Push, PR, يومي | تتبع الأخطاء       |
| **Quality Gates**       | PR             | بوابات الجودة      |
| **Semantic Versioning** | Push, PR       | التحقق من Commits  |
| **Release**             | Tag            | إنشاء إصدار        |
| **CodeQL**              | Push, PR, يومي | فحص أمان           |
| **Dependency Review**   | PR             | مراجعة التبعيات    |
| **Performance**         | Push, PR       | مراقبة الأداء      |
| **Documentation**       | Push, PR       | فحص التوثيق        |
| **Auto-merge**          | PR             | دمج تلقائي         |
| **Stale**               | يومي           | إغلاق Issues قديمة |

---

## 🆘 استكشاف الأخطاء

### Commit مرفوض

```bash
# السبب: رسالة غير صحيحة
# الحل:
git commit --amend -m "feat: رسالة صحيحة"
```

### Push مرفوض

```bash
# السبب: أخطاء في الكود
# الحل:
flutter analyze
flutter test
# أصلح الأخطاء ثم:
git push
```

### Merge Conflict

```bash
# 1. تحديث الفرع
git fetch origin
git merge origin/develop

# 2. حل التعارضات يدوياً

# 3. إكمال الدمج
git add .
git commit
```

---

## 📞 المساعدة

### الموارد

- **التوثيق:** `Documentation/`
- **الأدلة:** `Documentation/*_GUIDE.md`
- **المواصفات:** `.kiro/specs/`

### الأوامر المفيدة

```bash
# مساعدة Git
git help <command>

# مساعدة Flutter
flutter help <command>

# عرض التكوين
git config --list
```

---

## 🎯 نصائح سريعة

### قبل كل Commit

```bash
flutter format lib/ test/
flutter analyze
flutter test
```

### قبل كل Push

```bash
# سيتم تشغيلها تلقائياً في pre-push hook
# لكن يمكنك تشغيلها يدوياً:
flutter analyze
flutter test
```

### قبل إنشاء PR

- ✅ تأكد من نجاح جميع الاختبارات
- ✅ تأكد من عدم وجود أخطاء في Analyze
- ✅ تأكد من تنسيق الكود
- ✅ تأكد من التوثيق
- ✅ تحديث CHANGELOG إذا لزم

---

**للمزيد من التفاصيل، راجع:**

- `Documentation/GIT_GITHUB_GUIDE.md`
- `Documentation/ERROR_TRACKING_GUIDE.md`
- `.kiro/specs/error-tracking-system/BEST_PRACTICES_AUDIT.md`
