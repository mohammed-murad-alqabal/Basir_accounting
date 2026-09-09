# خطة الترحيل الكاملة من .kiro

## الملخص التنفيذي

| الفئة | الحجم | التوصية | السبب |
|-------|-------|---------|-------|
| ✅ تم ترحيله | 84K | منتهي | steering, standards, specs/active |
| 📦 انقل إذا احتجته | 568K | اختياري | templates, reference, troubleshooting |
| 🗄️ أرشيف تاريخي | 6.4M | أرشيف | specs/archived, docs/reports |
| ❌ احذف | 900K+ | احذف | prompts, settings, scripts (مكرر) |

---

## التفاصيل

### 1. ✅ تم ترحيله بالفعل (منتهي)

```
.kiro/steering/       → docs/guides/steering/     (7 ملفات)
.kiro/standards/      → docs/standards/           (9 ملفات)
.kiro/specs/active/   → docs/specs/active/        (3 مجلدات)
.kiro/templates/      → docs/templates/           (تم النسخ)
```

---

### 2. 📦 انقل إذا احتجته (اختياري)

#### templates/ (296K)
يحتوي على:
- `flutter/` - قوالب widgets, providers, tests
- `code/` - قوالب model, repository, service
- `docs/` - قوالب API docs, changelog
- `specs/` - قوالب spec templates

**الأمر:**
```bash
cp -r .kiro/templates docs/kiro-templates
```

#### reference/ (272K)
يحتوي على:
- `arabic-dictionary.md` - قاموس عربي تقني
- `best-practices.md` - أفضل الممارسات
- `advanced-*.md` - مراجع متقدمة

**الأمر:**
```bash
cp -r .kiro/reference docs/reference
```

#### troubleshooting/ (28K)
يحتوي على:
- `mcp-github-complete-solution.md` - حلول MCP

**الأمر:**
```bash
cp -r .kiro/troubleshooting docs/troubleshooting
```

---

### 3. 🗄️ أرشيف تاريخي (احتفظ به خارج المشروع)

#### specs/archived/ (4.6M)
يحتوي على 235 ملف من المشاريع المكتملة.

**الأمر:**
```bash
# إنشاء أرشيف خارجي
tar -czf ~/basir-kiro-archive-specs-$(date +%Y%m%d).tar.gz .kiro/specs/archived

# أو نقل إلى مجلد أرشيف
mkdir -p docs/archive/specs-archived-$(date +%Y%m%d)
mv .kiro/specs/archived/* docs/archive/specs-archived-$(date +%Y%m%d)/
```

#### docs/reports/ (1.8M)
يحتوي على 146 تقرير تاريخي.

**الأمر:**
```bash
tar -czf ~/basir-kiro-archive-reports-$(date +%Y%m%d).tar.gz .kiro/docs
```

---

### 4. ❌ احذف (مكرر أو Kiro-specific)

#### prompts/ (504K)
- 62 ملف
- مخصص لـ Kiro فقط
- لا فائدة منه بدون Kiro

**الأمر:**
```bash
rm -rf .kiro/prompts
```

#### settings/ (40K)
- 5 ملفات
- `mcp.json`, `editor.json`, إلخ
- إعدادات Kiro فقط

**الأمر:**
```bash
rm -rf .kiro/settings
```

#### scripts/ (392K)
- 40 ملف
- معظمها مكرر من `scripts/` الرئيسي
- لديك 34 سكريبت في `scripts/`

**الأمر:**
```bash
# تحقق من الفروق أولاً
diff -rq scripts .kiro/scripts

# إذا لا توجد فروق مهمة
rm -rf .kiro/scripts
```

#### reports/ (24K)
- 3 ملفات
- تقارير قديمة

**الأمر:**
```bash
rm -rf .kiro/reports
```

#### backlog/ (32K)
- 5 ملفات
- خطط مستقبلية

**إذا لم تعد تحتاجها:**
```bash
rm -rf .kiro/backlog
```

---

## 🚀 سكريبت التنفيذ الكامل

```bash
#!/bin/bash
# migrate_kiro_complete.sh

set -e

echo "=== ترحيل .kiro الكامل ==="

# 1. نقل الملفات المفيدة
echo "[1/4] نقل الملفات المفيدة..."
cp -r .kiro/templates docs/kiro-templates 2>/dev/null || true
cp -r .kiro/reference docs/reference 2>/dev/null || true
cp -r .kiro/troubleshooting docs/troubleshooting 2>/dev/null || true

# 2. أرشفة التاريخ
echo "[2/4] أرشفة الملفات التاريخية..."
mkdir -p docs/archive
tar -czf docs/archive/kiro-specs-archived-$(date +%Y%m%d).tar.gz \
    .kiro/specs/archived 2>/dev/null || true
tar -czf docs/archive/kiro-docs-history-$(date +%Y%m%d).tar.gz \
    .kiro/docs 2>/dev/null || true

# 3. حذف المكرر و Kiro-specific
echo "[3/4] حذف الملفات غير الضرورية..."
rm -rf .kiro/prompts
rm -rf .kiro/settings
rm -rf .kiro/scripts
rm -rf .kiro/reports
rm -rf .kiro/backlog
rm -rf .kiro/docs
rm -rf .kiro/specs/archived

# 4. حذف الفارغ (إذا بقي)
echo "[4/4] التنظيف النهائي..."
find .kiro -type d -empty -delete 2>/dev/null || true

echo "✅ اكتمل الترحيل"
echo ""
echo "المتبقي في .kiro:"
ls -la .kiro/ 2>/dev/null || echo "تم حذف .kiro بالكامل"
```

---

## 📊 النتيجة المتوقعة

### قبل:
```
.kiro/ = ~7.5 MB (575+ ملف)
```

### بعد (خيار 1 - حذف كامل):
```
docs/guides/steering/   = 40K
docs/standards/         = 44K
docs/specs/active/      = موجود
docs/templates/         = 296K
docs/reference/         = 272K
docs/troubleshooting/   = 28K
docs/archive/           = 6.4M (مضغوط)

Total = ~680K active + 6.4M archived
```

### بعد (خيار 2 - احتفاظ جزئي):
```
.kiro/ = فارغ أو محذوف
docs/ = يحتوي كل شيء مهم
```

---

## التوصية النهائية

**للاستقلالية الكاملة:**
1. انفذ سكريبت الترحيل
2. احذف `.kiro` بالكامل
3. اعتمد على `docs/` و `.githooks/`

**للاحتفاظ ببعض Kiro:**
1. احتفظ بـ `.kiro/steering/` و `.kiro/standards/` (للتوافق مع Kiro)
2. احذف الباقي
