---
id: "location-optimization-plan"
description: "خطة تحسين مواقع الملفات في .kiro/steering"
version: "1.0"
date: "2025-12-17"
author: "فريق وكلاء تطوير مشروع بصير"
priority: "high"
---

# خطة تحسين مواقع الملفات

**التاريخ:** 17 ديسمبر 2025  
**الحالة:** 🔴 يتطلب إجراء فوري

---

## 📊 التحليل الحالي

### الوضع الحالي

- **ملفات في المكان الصحيح:** 9/27 (33%)
- **ملفات في مكان غير مثالي:** 18/27 (67%)

### المشكلة الرئيسية

⚠️ **67% من الملفات في مواقع غير مثالية** مما يؤدي إلى:

- تحميل تلقائي لملفات كبيرة (>300 سطر)
- استهلاك سياق غير ضروري
- صعوبة في الصيانة
- انتهاك استراتيجية config.json

---

## 🎯 الاستراتيجية المستهدفة

حسب `.kiro/steering/config.json`:

| الموقع             | الحجم المستهدف | الغرض                            |
| ------------------ | -------------- | -------------------------------- |
| `core/`            | <100 سطر       | أساسيات مختصرة - تُحمل تلقائياً  |
| `technologies/`    | 100-300 سطر    | معايير متوسطة - تُحمل حسب الحاجة |
| `.kiro/guides/`    | 300-500 سطر    | أدلة شاملة - تُحمل عند الطلب     |
| `.kiro/reference/` | >500 سطر       | مراجع كاملة - تُحمل صراحةً       |

---

## 🔴 المرحلة 1: عاجل (يوم واحد)

### نقل إلى .kiro/reference/

```bash
# 1 ملف ضخم (>500 سطر)
mkdir -p .kiro/reference
git mv .kiro/steering/technologies/tech-stack.md .kiro/reference/
```

**الملف:**

- `tech-stack.md` (635 سطر) → `.kiro/reference/tech-stack.md`

**الأثر المتوقع:**

- تقليل 635 سطر من التحميل التلقائي
- توفير ~3% من السياق
- تحسين سرعة التحميل

**الإجراءات المطلوبة:**

1. نقل الملف
2. تحديث `tech-stack-index.md` ليشير للموقع الجديد
3. تحديث `inclusion: manual` في frontmatter
4. تحديث config.json

---

## 🟡 المرحلة 2: مهم (أسبوع)

### نقل إلى .kiro/guides/

```bash
# 6 ملفات كبيرة (300-500 سطر)
mkdir -p .kiro/guides

git mv .kiro/steering/technologies/performance-optimization.md .kiro/guides/
git mv .kiro/steering/technologies/security-best-practices.md .kiro/guides/
git mv .kiro/steering/technologies/development-standards.md .kiro/guides/
git mv .kiro/steering/technologies/frontend-standards.md .kiro/guides/
git mv .kiro/steering/technologies/project-standards.md .kiro/guides/
git mv .kiro/steering/core/kiro-compliance.md .kiro/guides/
```

**الملفات:**

1. `performance-optimization.md` (425 سطر)
2. `security-best-practices.md` (410 سطر)
3. `development-standards.md` (355 سطر)
4. `frontend-standards.md` (343 سطر)
5. `project-standards.md` (305 سطر)
6. `kiro-compliance.md` (303 سطر)

**الأثر المتوقع:**

- تقليل 2,141 سطر من التحميل التلقائي
- توفير ~10% من السياق
- تحسين كبير في الأداء

**الإجراءات المطلوبة:**

1. نقل الملفات
2. تحديث جميع الروابط الداخلية
3. تغيير `inclusion: always` → `inclusion: manual`
4. تحديث config.json
5. إنشاء فهرس في `.kiro/guides/INDEX.md`

---

## 🟢 المرحلة 3: تحسينات (شهر)

### إعادة تنظيم core/ و technologies/

#### نقل إلى core/ (ملفات صغيرة)

```bash
# 4 ملفات صغيرة (<100 سطر)
git mv .kiro/steering/technologies/tech-stack-index.md .kiro/steering/core/
git mv .kiro/steering/technologies/testing-best-practices.md .kiro/steering/core/
git mv .kiro/steering/technologies/development-environment.md .kiro/steering/core/
git mv .kiro/steering/technologies/api-design.md .kiro/steering/core/
```

**الملفات:**

1. `tech-stack-index.md` (63 سطر) ✅ يبقى `inclusion: always`
2. `testing-best-practices.md` (70 سطر)
3. `development-environment.md` (58 سطر)
4. `api-design.md` (57 سطر)

#### نقل من core/ إلى technologies/ (ملفات متوسطة)

```bash
# 5 ملفات متوسطة (100-300 سطر)
git mv .kiro/steering/core/philosophy.md .kiro/steering/technologies/
git mv .kiro/steering/core/quality-system-index.md .kiro/steering/technologies/
git mv .kiro/steering/core/quick-reference.md .kiro/steering/technologies/
git mv .kiro/steering/core/quality-assurance-system.md .kiro/steering/technologies/
git mv .kiro/steering/core/agents/team-structure.md .kiro/steering/technologies/
```

**الملفات:**

1. `philosophy.md` (247 سطر)
2. `quality-system-index.md` (232 سطر)
3. `quick-reference.md` (195 سطر)
4. `quality-assurance-system.md` (193 سطر)
5. `team-structure.md` (136 سطر)

**الأثر المتوقع:**

- core/ يحتوي فقط على ملفات <100 سطر
- technologies/ يحتوي على ملفات 100-300 سطر
- توزيع منطقي ومتسق

---

## 📋 قائمة التحقق الكاملة

### قبل النقل

- [ ] نسخ احتياطي كامل
- [ ] توثيق جميع الروابط الحالية
- [ ] مراجعة inclusion patterns

### أثناء النقل

- [ ] استخدام `git mv` للحفاظ على التاريخ
- [ ] تحديث frontmatter في كل ملف
- [ ] تحديث inclusion patterns
- [ ] تحديث جميع الروابط الداخلية

### بعد النقل

- [ ] فحص الروابط المكسورة
- [ ] تحديث config.json
- [ ] اختبار التحميل التلقائي
- [ ] قياس استهلاك السياق
- [ ] توثيق التغييرات

---

## 📊 الأثر المتوقع

### قبل التحسين

- **ملفات محملة تلقائياً:** 23/27 (85%)
- **أسطر محملة:** ~5,000 سطر
- **استهلاك السياق:** ~22%

### بعد التحسين (المراحل 1+2)

- **ملفات محملة تلقائياً:** 15/27 (56%)
- **أسطر محملة:** ~2,200 سطر
- **استهلاك السياق:** ~9%
- **التحسن:** 59% تقليل في السياق

### بعد التحسين الكامل (المراحل 1+2+3)

- **ملفات محملة تلقائياً:** 8/27 (30%)
- **أسطر محملة:** ~600 سطر
- **استهلاك السياق:** ~3%
- **التحسن:** 86% تقليل في السياق

---

## ⚠️ المخاطر والتخفيف

### المخاطر

1. **روابط مكسورة:** 17 رابط مكسور حالياً
2. **فقدان السياق:** ملفات مهمة لن تُحمل تلقائياً
3. **تعطيل الوكلاء:** قد يحتاج الوكلاء لتحديث

### التخفيف

1. **فحص تلقائي للروابط** قبل وبعد كل نقل
2. **توثيق واضح** في INDEX.md لكل مجلد
3. **فترة انتقالية** مع روابط مزدوجة
4. **اختبار شامل** بعد كل مرحلة

---

## 🔄 خطة التنفيذ التدريجية

### الأسبوع 1

- ✅ تحليل الوضع الحالي (مكتمل)
- ⏳ المرحلة 1: نقل tech-stack.md
- ⏳ اختبار وقياس الأثر

### الأسبوع 2

- ⏳ المرحلة 2: نقل 6 ملفات إلى guides/
- ⏳ إصلاح جميع الروابط المكسورة
- ⏳ تحديث config.json

### الأسبوع 3-4

- ⏳ المرحلة 3: إعادة تنظيم core/ و technologies/
- ⏳ إنشاء فهارس INDEX.md
- ⏳ توثيق كامل للتغييرات

### الأسبوع 5

- ⏳ اختبار شامل
- ⏳ قياس الأداء النهائي
- ⏳ تقرير النتائج

---

## 📝 الخلاصة

**الحالة:** 🔴 يتطلب إجراء فوري

**الأولوية:**

1. 🔴 عاجل: نقل tech-stack.md (635 سطر)
2. 🟡 مهم: نقل 6 ملفات إلى guides/ (2,141 سطر)
3. 🟢 تحسين: إعادة تنظيم core/ و technologies/

**الفائدة المتوقعة:**

- 86% تقليل في استهلاك السياق
- تحسين كبير في الأداء
- بنية منطقية ومتسقة
- سهولة الصيانة

**الخطوة التالية:**
تنفيذ المرحلة 1 فوراً (نقل tech-stack.md)

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** 📋 خطة جاهزة للتنفيذ  
**المراجعة القادمة:** بعد كل مرحلة
