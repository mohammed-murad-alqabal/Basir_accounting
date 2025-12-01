# دليل سريع لإصلاح مستودع Git

**⏱️ الوقت المتوقع:** 5-10 دقائق  
**🎯 الهدف:** إصلاح مشاكل الفروع وتوحيد المستودع

---

## 🚀 التنفيذ السريع

### الطريقة 1: استخدام السكريبت التلقائي (موصى به)

```bash
# تشغيل السكريبت
./fix_git_repository.sh
```

**ماذا سيفعل السكريبت؟**

1. ✅ التحقق من الفرع الحالي
2. ✅ إنشاء نسخة احتياطية
3. ✅ حذف origin/main (بعد التأكيد)
4. ✅ تنظيف المراجع
5. ✅ التحقق من النتيجة

### الطريقة 2: التنفيذ اليدوي

```bash
# 1. التأكد من الفرع
git checkout master
git pull origin master

# 2. نسخة احتياطية
git branch backup-master-$(date +%Y%m%d)
git push origin backup-master-$(date +%Y%m%d)

# 3. حذف origin/main
git push origin --delete main

# 4. تنظيف
git fetch --all --prune
git remote prune origin

# 5. التحقق
git branch -a
git status
```

---

## ⚠️ قبل البدء

### تحقق من:

- [ ] أنت على الفرع `master`
- [ ] لا توجد تغييرات غير محفوظة
- [ ] لديك اتصال بالإنترنت
- [ ] لديك صلاحيات على GitHub

### إذا كان لديك تغييرات غير محفوظة:

```bash
# احفظها
git add .
git commit -m "save: work in progress"

# أو خزنها مؤقتاً
git stash
```

---

## 📊 المشاكل المكتشفة

### المشكلة الرئيسية

```
❌ وجود فرعين رئيسيين:
   - origin/master (نشط، محدث)
   - origin/main (قديم، متخلف 62 commit)
```

### التأثير

- ⚠️ ارتباك في الفرع الأساسي
- ⚠️ صعوبة في التعاون
- ⚠️ مشاكل محتملة في CI/CD

---

## ✅ الحل

### الخطة

1. **الاحتفاظ بـ master** (الفرع النشط)
2. **حذف origin/main** (الفرع القديم)
3. **تنظيف المراجع**
4. **تحديث GitHub settings**

### لماذا master؟

- ✅ يحتوي على أحدث التغييرات (13 commits جديدة)
- ✅ جودة الكود ممتازة (0 errors)
- ✅ جميع الاختبارات تعمل (174 tests)
- ✅ الفرع النشط حالياً

---

## 🎯 بعد التنفيذ

### 1. تحديث GitHub (مهم!)

اذهب إلى:

```
https://github.com/mohammed-murad-alqabal/Basser_MVP/settings/branches
```

غير الفرع الافتراضي إلى `master`

### 2. التحقق من النجاح

```bash
# يجب أن يظهر فقط master
git branch -a

# يجب أن يظهر: up to date
git status

# يجب أن يعمل بدون مشاكل
flutter analyze --no-pub
flutter test --no-pub
```

### 3. إعلام الفريق (إن وجد)

```bash
# يجب على الجميع تنفيذ:
git fetch --all --prune
git checkout master
git pull origin master
```

---

## 🆘 إذا حدث خطأ

### استعادة النسخة الاحتياطية

```bash
# عرض النسخ الاحتياطية
git branch -a | grep backup

# استعادة master
git checkout backup-master-YYYYMMDD
git branch -D master
git checkout -b master
git push -f origin master
```

### استعادة origin/main

```bash
# إذا كنت بحاجة لاستعادته
git checkout backup-main-YYYYMMDD
git push origin backup-main-YYYYMMDD:main
```

---

## 📋 قائمة التحقق

### قبل التنفيذ

- [ ] قرأت التعليمات
- [ ] فهمت ما سيحدث
- [ ] لديك نسخة احتياطية
- [ ] جاهز للبدء

### أثناء التنفيذ

- [ ] تم إنشاء النسخة الاحتياطية
- [ ] تم حذف origin/main
- [ ] تم تنظيف المراجع
- [ ] تم التحقق من النتيجة

### بعد التنفيذ

- [ ] تم تحديث GitHub settings
- [ ] تم التحقق من العمليات الأساسية
- [ ] تم إعلام الفريق (إن وجد)
- [ ] تم تحديث الوثائق

---

## 💡 نصائح

### للتأكد من النجاح

```bash
# 1. الفروع
git branch -a
# يجب أن يظهر فقط:
# * master
# remotes/origin/master
# remotes/origin/backup-*

# 2. الحالة
git status
# يجب أن يظهر:
# On branch master
# Your branch is up to date with 'origin/master'

# 3. الجودة
flutter analyze --no-pub
# يجب أن يظهر:
# No issues found!

# 4. الاختبارات
flutter test --no-pub
# يجب أن يظهر:
# All tests passed!
```

### للمستقبل

- ✅ استخدم فرع واحد رئيسي فقط
- ✅ نظف الفروع القديمة بانتظام
- ✅ استخدم Branch Protection على GitHub
- ✅ اتبع Git best practices

---

## 📚 الملفات المرجعية

### للتفاصيل الكاملة

1. **GIT_REPOSITORY_ANALYSIS_AND_FIX.md** - التحليل الشامل
2. **GIT_WORKFLOW_ANALYSIS.md** - تحليل سير العمل
3. **CONTRIBUTING.md** - دليل المساهمة
4. **fix_git_repository.sh** - السكريبت التلقائي

### للمساعدة

- راجع الملفات أعلاه
- افتح Issue على GitHub
- استشر الفريق

---

## ✅ الخلاصة

### ما سيتم

- ✅ توحيد على `master`
- ✅ حذف `origin/main`
- ✅ تنظيف المراجع
- ✅ نسخ احتياطية آمنة

### النتيجة

- ✅ فرع رئيسي واحد واضح
- ✅ لا ارتباك
- ✅ سهولة التعاون
- ✅ مستودع نظيف ومنظم

---

**🚀 جاهز؟ ابدأ الآن:**

```bash
./fix_git_repository.sh
```

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 30 نوفمبر 2025  
**الحالة:** ✅ جاهز للتنفيذ
