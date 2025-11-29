# 🪝 Kiro Hooks - دليل الاستخدام

## نظرة عامة

الـ Hooks هي آليات أتمتة وقائية تعمل تلقائياً عند أحداث معينة لضمان جودة الكود والأمان.

---

## 📁 أنواع الـ Hooks

### 1. on-commit (عند الـ Commit)

**الوظيفة:** تعمل قبل إتمام الـ commit

#### 🔒 10_security_scan.sh

**الوصف:** فحص أمني شامل للكشف عن الأسرار

**ما يفحصه:**

- API keys, passwords, tokens
- ملفات Android/iOS الحساسة
- google-services.json, GoogleService-Info.plist
- key.properties, _.jks, _.keystore
- أنماط .gitignore

**الاستخدام:**

```bash
# تلقائي عند git commit
git commit -m "message"

# يدوي
bash .kiro/hooks/on-commit/10_security_scan.sh
```

**النتيجة:**

- ✅ يسمح بالـ commit إذا لم يجد أسرار
- ❌ يوقف الـ commit إذا وجد أسرار

---

### 2. on-push (عند الـ Push)

**الوظيفة:** تعمل قبل إتمام الـ push

#### 🔍 20_quality_gate.sh

**الوصف:** فحص جودة الكود الشامل

**ما يفحصه:**

1. **التنسيق:** dart format
2. **التحليل:** flutter analyze
3. **الاختبارات:** flutter test
4. **التبعيات:** flutter pub outdated
5. **حجم التطبيق:** APK size check

**الاستخدام:**

```bash
# تلقائي عند git push
git push origin main

# يدوي
bash .kiro/hooks/on-push/20_quality_gate.sh
```

**النتيجة:**

- ✅ يسمح بالـ push إذا نجحت جميع الفحوصات
- ❌ يوقف الـ push إذا فشلت أي فحص

**معايير النجاح:**

- تنسيق صحيح (0 errors)
- تحليل نظيف (0 errors, 0 warnings)
- جميع الاختبارات ناجحة
- حجم APK < 50 MB

---

### 3. on-save (عند الحفظ)

**الوظيفة:** تعمل عند حفظ ملف

#### 📝 10_lint_and_format.kiro.hook

**الوصف:** تنسيق وفحص تلقائي عند حفظ ملفات Dart

**ما يفعله:**

1. تشغيل dart format
2. تشغيل flutter analyze
3. إصلاح المشاكل التلقائية
4. التحقق من DartDoc comments

**الاستخدام:**

- يعمل تلقائياً في Kiro IDE عند حفظ ملف .dart

**الفوائد:**

- ✅ كود منسق دائماً
- ✅ اكتشاف المشاكل مبكراً
- ✅ توثيق محدث

---

#### 📖 30_update_docs.sh

**الوصف:** تحديث التوثيق تلقائياً

**ما يفعله:**

1. التحقق من DartDoc comments في lib/
2. تحديث SPECS_ANALYSIS_REPORT.md عند تعديل specs
3. فحص الروابط في README.md

**الاستخدام:**

```bash
# تلقائي في Kiro IDE
# أو يدوي
bash .kiro/hooks/on-save/30_update_docs.sh lib/some_file.dart
```

---

### 4. manual (يدوي)

**الوظيفة:** تعمل عند الطلب (زر في Kiro IDE)

#### 🔍 20_dependency_check.kiro.hook

**الوصف:** فحص التبعيات القديمة

**ما يفعله:**

1. تشغيل flutter pub outdated
2. تصنيف التحديثات (major, minor, patch)
3. فحص الثغرات الأمنية
4. اقتراح التحديثات الآمنة
5. التحذير من breaking changes

**الاستخدام:**

- في Kiro IDE: اضغط زر "🔍 فحص التبعيات"
- أو اطلب من Kiro: "افحص التبعيات"

**الفوائد:**

- ✅ تبعيات محدثة
- ✅ أمان محسّن
- ✅ أداء أفضل

---

## 🔧 التفعيل والإعداد

### تفعيل الـ Hooks

```bash
# جعل الـ shell scripts قابلة للتنفيذ
chmod +x .kiro/hooks/on-commit/*.sh
chmod +x .kiro/hooks/on-push/*.sh
chmod +x .kiro/hooks/on-save/*.sh

# التحقق من الأذونات
ls -la .kiro/hooks/on-commit/
ls -la .kiro/hooks/on-push/
ls -la .kiro/hooks/on-save/
```

### ربط مع Git (اختياري)

```bash
# إنشاء Git hooks
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
bash .kiro/hooks/on-commit/10_security_scan.sh
EOF

cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
bash .kiro/hooks/on-push/20_quality_gate.sh
EOF

chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/pre-push
```

---

## 📊 مصفوفة الـ Hooks

| Hook             | النوع     | التلقائي | اليدوي | الوقت |  الأهمية   |
| :--------------- | :-------- | :------: | :----: | :---- | :--------: |
| security_scan    | on-commit |    ✅    |   ✅   | ~5s   | ⭐⭐⭐⭐⭐ |
| quality_gate     | on-push   |    ✅    |   ✅   | ~30s  | ⭐⭐⭐⭐⭐ |
| lint_and_format  | on-save   |    ✅    |   ❌   | ~2s   |  ⭐⭐⭐⭐  |
| update_docs      | on-save   |    ✅    |   ✅   | ~1s   |   ⭐⭐⭐   |
| dependency_check | manual    |    ❌    |   ✅   | ~10s  |  ⭐⭐⭐⭐  |

---

## 🎯 أفضل الممارسات

### 1. الأمان

- ✅ لا تتجاوز security_scan أبداً
- ✅ أضف ملفات حساسة إلى .gitignore
- ✅ استخدم flutter_secure_storage للأسرار

### 2. الجودة

- ✅ أصلح المشاكل قبل الـ push
- ✅ حافظ على تغطية 70%+ اختبارات
- ✅ اتبع معايير dart format

### 3. الإنتاجية

- ✅ استخدم lint_and_format لتوفير الوقت
- ✅ افحص التبعيات أسبوعياً
- ✅ حدّث التوثيق باستمرار

---

## 🐛 استكشاف الأخطاء

### المشكلة: Hook لا يعمل

**الحل:**

```bash
# تحقق من الأذونات
ls -la .kiro/hooks/on-commit/10_security_scan.sh

# إذا لم يكن executable
chmod +x .kiro/hooks/on-commit/10_security_scan.sh

# اختبر يدوياً
bash .kiro/hooks/on-commit/10_security_scan.sh
```

### المشكلة: security_scan يعطي false positive

**الحل:**

```bash
# راجع الملف المشكوك فيه
# إذا كان TODO أو FIXME، أضف تعليق
# مثال:
# TODO: add api_key configuration (not actual key)
```

### المشكلة: quality_gate بطيء جداً

**الحل:**

```bash
# تخطي الاختبارات مؤقتاً (غير موصى به)
# عدّل .kiro/hooks/on-push/20_quality_gate.sh
# وعلّق على قسم الاختبارات

# أو حسّن الاختبارات لتكون أسرع
```

---

## 📚 الموارد

### للمزيد من المعلومات

- `.kiro/steering/security.md` - معايير الأمان
- `.kiro/steering/testing-best-practices.md` - أفضل ممارسات الاختبارات
- `.kiro/steering/git-best-practices.md` - أفضل ممارسات Git

### للدعم

- راجع `.kiro/README.md`
- اطلب من فريق وكلاء تطوير مشروع بصير
- افتح issue

---

## ✅ قائمة التحقق

قبل الـ Commit:

- [ ] الكود منسق (dart format)
- [ ] لا توجد أخطاء (flutter analyze)
- [ ] لا توجد أسرار في الكود
- [ ] التوثيق محدث

قبل الـ Push:

- [ ] جميع الاختبارات ناجحة
- [ ] التغطية ≥ 70%
- [ ] لا توجد warnings
- [ ] حجم APK مقبول

---

**تم التحديث:** 27 نوفمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ جاهز للاستخدام
