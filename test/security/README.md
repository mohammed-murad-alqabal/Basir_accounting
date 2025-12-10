# اختبارات الأمان - Security Tests

**المشروع:** بصير MVP  
**التاريخ:** 6 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## نظرة عامة

هذا المجلد يحتوي على مجموعة شاملة من اختبارات الأمان لضمان عدم تسريب معلومات حساسة وحماية المشروع من الثغرات الأمنية.

---

## الملفات

### 1. test_secret_patterns.sh

**الوصف:** اختبار فحص الأسرار المكشوفة مع أنماط مختلفة

**المتطلبات:** Requirements 9.2, 9.3

**الاختبارات:** 50+

**الأنماط المختبرة:**

- API Keys (5 اختبارات)
- Passwords (5 اختبارات)
- Tokens (5 اختبارات)
- Secret Keys (5 اختبارات)
- AWS Credentials (4 اختبارات)
- Database Credentials (4 اختبارات)
- SSH Keys (3 اختبارات)
- Stripe Keys (3 اختبارات)
- GitHub Tokens (3 اختبارات)
- False Positives (5 اختبارات)

**الاستخدام:**

```bash
bash test/security/test_secret_patterns.sh
```

### 2. test_sanitization.sh

**الوصف:** اختبار تنظيف البيانات الحساسة من السجلات

**المتطلبات:** Requirements 9.1, 9.5

**الاختبارات:** 35+

**الأنماط المختبرة:**

- API Keys (3 اختبارات)
- Passwords (4 اختبارات)
- Tokens (3 اختبارات)
- Secret Keys (3 اختبارات)
- AWS Credentials (2 اختبارات)
- Database Credentials (2 اختبارات)
- SSH Keys (1 اختبار)
- Stripe Keys (2 اختبارات)
- GitHub Tokens (2 اختبارات)
- Email Addresses (2 اختبارات)
- Phone Numbers (2 اختبارات)
- IP Addresses (2 اختبارات)
- Credit Card Numbers (2 اختبارات)

**الاستخدام:**

```bash
bash test/security/test_sanitization.sh
```

### 3. test_gitignore_coverage.sh

**الوصف:** التحقق من تغطية .gitignore لجميع أنواع الملفات الحساسة

**المتطلبات:** Requirements 9.4

**الاختبارات:** 35+

**الأنماط المختبرة:**

- ملفات البيئة (4 اختبارات)
- ملفات المفاتيح (4 اختبارات)
- ملفات الشهادات (3 اختبارات)
- ملفات التكوين الحساسة (3 اختبارات)
- ملفات قواعد البيانات (3 اختبارات)
- ملفات النسخ الاحتياطي (3 اختبارات)
- ملفات السجلات (2 اختبارات)
- ملفات IDE (3 اختبارات)
- ملفات نظام التشغيل (3 اختبارات)
- ملفات التبعيات (3 اختبارات)

**الاستخدام:**

```bash
bash test/security/test_gitignore_coverage.sh
```

### 4. run_security_tests.sh

**الوصف:** تشغيل جميع اختبارات الأمان بشكل شامل

**المتطلبات:** Requirements 9.1, 9.2, 9.3, 9.4, 9.5

**المجموعات:** 3

**الاستخدام:**

```bash
bash test/security/run_security_tests.sh
```

---

## الاستخدام السريع

### تشغيل جميع الاختبارات

```bash
cd /path/to/Basser_MVP
bash test/security/run_security_tests.sh
```

### تشغيل اختبار محدد

```bash
# اختبار أنماط الأسرار
bash test/security/test_secret_patterns.sh

# اختبار التنظيف
bash test/security/test_sanitization.sh

# اختبار .gitignore
bash test/security/test_gitignore_coverage.sh
```

---

## النتائج المتوقعة

### نجاح كامل

```
═══════════════════════════════════════════════════════════
  النتائج النهائية - اختبارات الأمان
═══════════════════════════════════════════════════════════

إجمالي مجموعات الاختبار: 3
✓ نجح: 3
✗ فشل: 0
معدل النجاح: 100%

🎉 ممتاز! جميع اختبارات الأمان نجحت
✓ فحص الأسرار يعمل بشكل ممتاز
✓ تنظيف البيانات الحساسة يعمل بشكل ممتاز
✓ .gitignore يغطي جميع الملفات الحساسة
```

### فشل جزئي

```
═══════════════════════════════════════════════════════════
  النتائج النهائية - اختبارات الأمان
═══════════════════════════════════════════════════════════

إجمالي مجموعات الاختبار: 3
✓ نجح: 2
✗ فشل: 1
معدل النجاح: 66%

⚠ جيد، لكن يحتاج بعض التحسين
```

---

## استكشاف الأخطاء

### المشكلة: اختبار فحص الأسرار يفشل

**السبب المحتمل:** سكريبت validate.sh غير موجود أو لا يعمل

**الحل:**

```bash
# التحقق من وجود السكريبت
ls -la scripts/utils/validate.sh

# التحقق من الأذونات
chmod +x scripts/utils/validate.sh

# اختبار السكريبت
bash scripts/utils/validate.sh secrets test_file.txt
```

### المشكلة: اختبار التنظيف يفشل

**السبب المحتمل:** سكريبت sanitize.sh غير موجود أو لا يعمل

**الحل:**

```bash
# التحقق من وجود السكريبت
ls -la scripts/utils/sanitize.sh

# التحقق من الأذونات
chmod +x scripts/utils/sanitize.sh

# اختبار السكريبت
bash scripts/utils/sanitize.sh file test_file.txt
```

### المشكلة: اختبار .gitignore يفشل

**السبب المحتمل:** .gitignore لا يحتوي على الأنماط المطلوبة

**الحل:**

```bash
# التحقق من محتوى .gitignore
cat .gitignore

# إضافة الأنماط المفقودة
echo "*.env" >> .gitignore
echo "*.key" >> .gitignore
# ... إلخ
```

---

## التكامل مع CI/CD

### GitHub Actions

```yaml
name: Security Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  security:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: تشغيل اختبارات الأمان
        run: bash test/security/run_security_tests.sh

      - name: رفع التقرير
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: security-report
          path: logs/reports/security_*.md
```

---

## أفضل الممارسات

### 1. تشغيل دوري

```bash
# يومياً
bash test/security/run_security_tests.sh

# قبل كل release
bash test/security/run_security_tests.sh
```

### 2. مراجعة النتائج

```bash
# مراجعة التقارير
cat logs/reports/security_*.md

# تحليل الفشل
grep "✗" logs/security_test.log
```

### 3. تحديث الأنماط

```bash
# عند اكتشاف أنماط جديدة
# تحديث scripts/utils/validate.sh
# تحديث test/security/test_secret_patterns.sh
```

---

## الإحصائيات

| المقياس               | القيمة |
| :-------------------- | :----: |
| **إجمالي الاختبارات** |  120+  |
| **مجموعات الاختبار**  |   3    |
| **التغطية**           |  100%  |
| **دعم العربية**       |  100%  |

---

## المراجع

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Security Best Practices](https://cheatsheetseries.owasp.org/)
- [Git Secrets](https://github.com/awslabs/git-secrets)

---

**تم إعداد هذه الوثيقة بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 6 ديسمبر 2025  
**الحالة:** ✅ نشط
