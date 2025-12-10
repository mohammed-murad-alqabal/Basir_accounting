# اختبارات نظام دفع السجلات إلى Git

**المشروع:** بصير MVP  
**التاريخ:** 4 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ مكتمل

---

## نظرة عامة

هذا المجلد يحتوي على اختبارات الخصائص (Property-Based Tests) لنظام دفع السجلات إلى Git. جميع الاختبارات تستخدم منهجية PBT مع 100 iteration لضمان صحة الخصائص.

---

## الاختبارات المتوفرة

### 1. Property 16: Commit Message Format Consistency

**الملف:** `property_test_commit_format.sh`  
**المتطلبات:** Requirements 6.2  
**الخاصية:** رسائل الـ commit يجب أن تتبع صيغة Conventional Commits (type(scope): description).  
**التكرارات:** 100

**أمثلة على الصيغة الصحيحة:**

- `chore(logs): update logs`
- `feat(logs): add new log collection`
- `fix(logs): fix sanitization issue`

### 2. Property 17: Skip CI Tag Presence

**الملف:** `property_test_skip_ci.sh`  
**المتطلبات:** Requirements 6.3  
**الخاصية:** رسائل الـ commit يجب أن تحتوي على [skip ci] لتجنب تشغيل workflows غير ضرورية.  
**التكرارات:** 100

**مثال:**

```
chore(logs): update logs [skip ci]
```

### 3. Property 18: No-Change Detection

**الملف:** `property_test_no_change.sh`  
**المتطلبات:** Requirements 6.5  
**الخاصية:** عدم إنشاء commit عندما لا توجد تغييرات جديدة في السجلات.  
**التكرارات:** 100

---

## تشغيل الاختبارات

### تشغيل جميع الاختبارات

```bash
cd test
./run_git_push_tests.sh
```

### تشغيل اختبار واحد

```bash
cd test/git_push
./property_test_commit_format.sh
```

---

## متطلبات التشغيل

- Git 2.0+
- Bash 4.0+
- Flutter SDK 3.24.0+
- مساحة كافية للملفات المؤقتة

---

## بنية الاختبار

كل اختبار يتبع البنية التالية:

1. **الإعداد (Setup):** إنشاء git repository معزول
2. **التوليد (Generation):** إنشاء تغييرات في السجلات
3. **التنفيذ (Execution):** تشغيل السكريبت مع --push
4. **التحقق (Verification):** التحقق من الخاصية
5. **التنظيف (Cleanup):** إزالة الملفات المؤقتة

---

## النتائج المتوقعة

جميع الاختبارات يجب أن تنجح بنسبة 100%. أي فشل يشير إلى:

- خلل في وظيفة --push
- عدم اتباع Conventional Commits
- عدم إضافة [skip ci]
- إنشاء commits غير ضرورية

---

## استكشاف الأخطاء

### الاختبار يفشل: "Invalid commit format"

**السبب:** رسالة الـ commit لا تتبع Conventional Commits  
**الحل:** تحقق من دالة `push_logs_to_git` في `collect_logs.sh`

### الاختبار يفشل: "Missing [skip ci] tag"

**السبب:** رسالة الـ commit لا تحتوي على [skip ci]  
**الحل:** تأكد من إضافة [skip ci] في رسالة الـ commit

### الاختبار يفشل: "Unnecessary commit created"

**السبب:** يتم إنشاء commit حتى عندما لا توجد تغييرات  
**الحل:** تحقق من منطق التحقق من التغييرات في السكريبت

---

## الإحصائيات

- **إجمالي الاختبارات:** 3
- **إجمالي التكرارات:** 300
- **الوقت المتوقع:** 5-8 دقائق
- **التغطية:** Requirements 6.2, 6.3, 6.5

---

## ملاحظات مهمة

### Git Configuration

الاختبارات تقوم بإنشاء git repositories مؤقتة مع تكوين محلي:

```bash
git config user.email "test@example.com"
git config user.name "Test User"
```

### عزل الاختبارات

كل اختبار يعمل في مجلد معزول تماماً ولا يؤثر على:

- Git repository الرئيسي
- السجلات الحقيقية
- أي ملفات في المشروع

### التنظيف التلقائي

جميع الملفات المؤقتة يتم حذفها تلقائياً عند:

- إكمال الاختبار بنجاح
- فشل الاختبار
- إيقاف الاختبار (Ctrl+C)

---

## أمثلة على الاستخدام

### مثال 1: تشغيل اختبار واحد

```bash
cd test/git_push
./property_test_commit_format.sh
```

**النتيجة المتوقعة:**

```
==========================================
Property 16: Commit Message Format
==========================================

الخاصية: رسائل الـ commit يجب أن تتبع صيغة Conventional Commits
عدد التكرارات: 100

✓ Iteration 1: PASS (Commit message follows Conventional Commits)
✓ Iteration 2: PASS (Commit message follows Conventional Commits)
...
✓ Iteration 100: PASS (Commit message follows Conventional Commits)

==========================================
النتائج النهائية
==========================================
إجمالي: 100
نجح: 100
فشل: 0
نسبة النجاح: 100%

✓ الخاصية محققة - جميع الـ commits تتبع الصيغة الصحيحة
```

### مثال 2: تشغيل جميع الاختبارات

```bash
cd test
./run_git_push_tests.sh
```

---

## التكامل مع CI/CD

يمكن دمج هذه الاختبارات في GitHub Actions:

```yaml
- name: Run Git Push Tests
  run: |
    cd test
    ./run_git_push_tests.sh
```

---

**تم إعداد هذه الوثيقة بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 4 ديسمبر 2025
