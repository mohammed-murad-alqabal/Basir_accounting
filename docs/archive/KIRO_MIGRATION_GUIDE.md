# دليل الترحيل من .kiro إلى البنية الجديدة

## ملخص التنفيذ

تم ترحيل جميع المكونات الحرجة من `.kiro` إلى مواقع قياسية في المشروع.

---

## جدول الترحيل

| المكون | الموقع القديم | الموقع الجديد | الحالة |
|--------|---------------|---------------|--------|
| Steering Docs | `.kiro/steering/` | `docs/guides/steering/` | ✅ مُرحّل |
| Standards | `.kiro/standards/` | `docs/standards/` | ✅ مُرحّل |
| Active Specs | `.kiro/specs/active/` | `docs/specs/active/` | ✅ مُرحّل |
| Completed Specs | `.kiro/specs/completed/` | `docs/specs/completed/` | ✅ مُرحّل |
| Templates | `.kiro/templates/` | `docs/templates/` | ✅ مُرحّل |
| Hooks Logic | `.kiro/hooks/*.json` | `scripts/check_spec_compliance.sh` | ✅ بديل |
| Git Hooks | `.kiro/hooks/` | `.githooks/` | ✅ موجود مسبقاً |

---

## ما تم الحفاظ عليه

### 1. الذكاء المؤسسي
- **الموقع:** `docs/guides/steering/`
- **المحتوى:**
  - `product.md` - رؤية المنتج
  - `tech.md` - المكدس التقني
  - `philosophy.md` - مبادئ PPP
  - `roadmap.md` - خارطة الطريق 2025-2030
  - `AGENTS.md` - توجيهات الوكلاء
  - `architecture-mapping.md` - هيكل البنية

### 2. المعايير الإلزامية
- **الموقع:** `docs/standards/`
- **المحتوى:**
  - `flutter.md` - معايير Flutter
  - `engineering.md` - هندسة البرمجيات
  - `accounting.md` - معايير IFRS/ZATCA
  - `naming.md` - اصطلاحات التسمية
  - `code-quality.md` - جودة الكود

### 3. أتمتة الجودة
- **الموقع:** `.githooks/` و `scripts/`
- **المحتوى:**
  - `pre-commit` - فحوصات قبل الالتزام
  - `pre-push` - فحوصات قبل الدفع
  - `check_spec_compliance.sh` - فحص الامتثال الشامل

---

## مقارنة القيمة

| الجانب | مع .kiro | بدون .kiro (البنية الجديدة) |
|--------|----------|------------------------------|
| توفر المعايير | ✅ في `.kiro/steering/` | ✅ في `docs/guides/steering/` |
| تشغيل Hooks | ✅ تلقائي بواسطة Kiro | ✅ تلقائي بواسطة Git |
| فحص الامتثال | ✅ عبر AI prompts | ✅ عبر shell script |
| استقلالية IDE | ❌ مرتبط بـ Kiro | ✅ يعمل في أي IDE |
| قابلية الصيانة | ⚠️ تعتمد على Kiro | ✅ مستقلة تماماً |
| onboarding | ⚠️ يحتاج فهم Kiro | ✅ docs قياسية |

---

## كيفية الاستخدام (بدون .kiro)

### للمطور الجديد:
```bash
# 1. قراءة الوثائق الأساسية
cat docs/QUICK_REFERENCE.md
cat docs/guides/steering/product.md

# 2. تفعيل Git Hooks
git config core.hooksPath .githooks

# 3. تشغيل فحص الامتثال
./scripts/check_spec_compliance.sh

# 4. البدء بالتطوير
flutter analyze
dart format lib/
flutter test
```

### قبل كل Commit:
```bash
# Git hooks تعمل تلقائياً، لكن يمكنك التشغيل يدوياً:
./scripts/check_spec_compliance.sh
flutter analyze
```

---

## ما يمكن حذفه من .kiro بأمان

بعد الترحيل، يمكن حذف:

```
.kiro/steering/       → نسخة إلى docs/guides/steering/
.kiro/standards/      → نسخة إلى docs/standards/
.kiro/specs/active/   → نسخة إلى docs/specs/active/
.kiro/specs/completed/→ نسخة إلى docs/specs/completed/
.kiro/templates/      → نسخة إلى docs/templates/
.kiro/hooks/*.json    → بديل في scripts/
```

## ما يجب الاحتفاظ به في .kiro (اختياري)

```
.kiro/backlog/        → إذا كنت تستخدمه
.kiro/reports/        → تقارير جلسات Kiro
.kiro/settings/       → إعدادات Kiro
```

---

## الخلاصة

| المعيار | النتيجة |
|---------|---------|
| الحفاظ على القيمة | ✅ 100% |
| استقلالية IDE | ✅ محسّن |
| قابلية الصيانة | ✅ محسّن |
| Onboarding | ✅ أسهل |
| التعقيد | ✅ أقل |

**التوصية:** البنية الجديدة توفر **نفس القيمة** مع **استقلالية أكبر** و**تعقيد أقل**.
