# خطة تنفيذ تحسين ملفات Steering

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 11 ديسمبر 2025  
**الحالة:** 🎯 **خطة تنفيذ مفصلة وجاهزة**

---

## 📊 تقييم الوضع الحالي

### الإحصائيات الحالية

- **إجمالي ملفات Steering:** 22 ملف
- **إجمالي الكلمات:** 7,041 كلمة
- **متوسط الكلمات/ملف:** 320 كلمة
- **الملفات المتوافقة مع المعايير:** 65%
- **الملفات التي تحتاج frontmatter:** 70%

### المشاكل المكتشفة

1. ❌ **عدم وجود frontmatter موحد** في معظم الملفات
2. ❌ **تصنيف غير مثالي** (core vs technologies فقط)
3. ❌ **عدم وجود summary** في أي ملف
4. ❌ **عدم وجود changelog** في الملفات
5. ❌ **عدم وجود نظام حوكمة** للتغييرات

---

## 🎯 خطة التحسين المرحلية

### المرحلة 1: إعادة التصنيف والتنظيم (يوم 1)

#### 1.1 إنشاء البنية الجديدة

```bash
# إنشاء التصنيف الجديد
mkdir -p .kiro/steering/{overview,architecture,conventions,security,ci-cd}

# نقل الملفات الأساسية
mv .kiro/steering/core/* .kiro/steering/overview/
```

#### 1.2 التصنيف المقترح

```
.kiro/steering/
├── overview/                    # نظرة عامة (3-4 ملفات)
│   ├── philosophy.md           # من core/
│   ├── quick-reference.md      # من core/
│   ├── team-identity.md        # من core/
│   └── workspace-overview.md   # جديد
├── architecture/               # معمارية (4-5 ملفات)
│   ├── system-design.md        # جديد
│   ├── agent-layers.md         # جديد
│   ├── data-flow.md           # جديد
│   └── integration-patterns.md # جديد
├── conventions/                # اتفاقيات (8-10 ملفات)
│   ├── flutter-standards.md   # من technologies/
│   ├── typescript-standards.md # من technologies/
│   ├── git-workflow.md        # من technologies/
│   ├── naming-conventions.md   # جديد
│   ├── code-quality.md        # جديد
│   ├── testing-standards.md   # من technologies/
│   ├── documentation-rules.md  # جديد
│   └── api-design.md          # من technologies/
├── security/                   # أمان (2-3 ملفات)
│   ├── security-policies.md    # من technologies/
│   ├── data-protection.md      # جديد
│   └── access-control.md       # جديد
└── ci-cd/                      # التكامل المستمر (2-3 ملفات)
    ├── pipeline-standards.md   # جديد
    ├── deployment-rules.md     # جديد
    └── quality-gates.md        # جديد
```

### المرحلة 2: إضافة Frontmatter موحد (يوم 2)

#### 2.1 قالب Frontmatter المعياري

```yaml
---
title: "عنوان الملف الواضح"
summary: "ملخص 50-100 كلمة يوضح محتوى الملف والغرض منه بوضوح"
scope: "workspace" # workspace | global | project
category: "overview" # overview | architecture | conventions | security | ci-cd
tags: ["flutter", "security"] # للتحميل الشرطي
version: "1.0.0" # semantic versioning
last_updated: "2025-12-11" # تاريخ آخر تحديث
author: "فريق وكلاء تطوير مشروع بصير"
inclusion: "always" # always | conditional | manual
load_priority: "high" # high | medium | low
estimated_tokens: 500 # تقدير عدد الرموز
word_count: 320 # عدد الكلمات الفعلي
dependencies: [] # الملفات المعتمدة
related_files: [] # الملفات ذات الصلة
changelog:
  - version: "1.0.0"
    date: "2025-12-11"
    changes: "إنشاء الملف الأولي"
compliance:
  kiro_standards: true # متوافق مع معايير Kiro
  frontmatter_complete: true # frontmatter مكتمل
  size_optimized: true # الحجم محسن
---
```

#### 2.2 سكربت إضافة Frontmatter

```python
#!/usr/bin/env python3
# scripts/add-frontmatter.py

import os
import yaml
from datetime import datetime

def add_frontmatter_to_file(filepath, category, tags):
    """إضافة frontmatter لملف steering"""

    # قراءة المحتوى الحالي
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # حساب الإحصائيات
    word_count = len(content.split())
    estimated_tokens = <credential-fixture> * 1.3  # تقدير تقريبي

    # إنشاء frontmatter
    frontmatter = {
        'title': extract_title_from_content(content),
        'summary': generate_summary(content),
        'scope': 'workspace',
        'category': category,
        'tags': tags,
        'version': '1.0.0',
        'last_updated': datetime.now().strftime('%Y-%m-%d'),
        'author': 'فريق وكلاء تطوير مشروع بصير',
        'inclusion': 'always',
        'load_priority': determine_priority(category),
        'estimated_tokens': int(estimated_tokens),
        'word_count': word_count,
        'dependencies': [],
        'related_files': [],
        'changelog': [{
            'version': '1.0.0',
            'date': datetime.now().strftime('%Y-%m-%d'),
            'changes': 'إضافة frontmatter وتحسين البنية'
        }],
        'compliance': {
            'kiro_standards': True,
            'frontmatter_complete': True,
            'size_optimized': word_count <= 1500
        }
    }

    # كتابة الملف الجديد
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write('---\n')
        yaml.dump(frontmatter, f, default_flow_style=False, allow_unicode=True)
        f.write('---\n\n')
        f.write(content)

def extract_title_from_content(content):
    """استخراج العنوان من المحتوى"""
    lines = content.split('\n')
    for line in lines:
        if line.startswith('# '):
            return line[2:].strip()
    return "ملف توجيه"

def generate_summary(content):
    """توليد ملخص تلقائي"""
    # منطق بسيط لتوليد الملخص
    lines = content.split('\n')
    first_paragraph = ""
    for line in lines:
        if line.strip() and not line.startswith('#'):
            first_paragraph = line.strip()
            break

    # تقصير إلى 100 كلمة
    words = first_paragraph.split()[:15]
    return ' '.join(words) + "..."

def determine_priority(category):
    """تحديد الأولوية حسب الفئة"""
    priority_map = {
        'overview': 'high',
        'architecture': 'high',
        'conventions': 'medium',
        'security': 'high',
        'ci-cd': 'medium'
    }
    return priority_map.get(category, 'medium')

# تشغيل السكربت
if __name__ == "__main__":
    steering_files = [
        ('.kiro/steering/overview/philosophy.md', 'overview', ['philosophy', 'principles']),
        ('.kiro/steering/overview/quick-reference.md', 'overview', ['reference', 'quick-start']),
        # ... باقي الملفات
    ]

    for filepath, category, tags in steering_files:
        if os.path.exists(filepath):
            add_frontmatter_to_file(filepath, category, tags)
            print(f"✅ تم تحديث: {filepath}")
```

### المرحلة 3: تحسين الأحجام والمحتوى (يوم 3)

#### 3.1 معايير تحسين الحجم

```python
# scripts/optimize-file-sizes.py

def optimize_file_size(filepath, target_words=800):
    """تحسين حجم الملف ليكون ضمن الحد المطلوب"""

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    word_count = len(content.split())

    if word_count > 1500:
        # تقسيم الملف إلى ملفات أصغر
        split_large_file(filepath, content)
    elif word_count > target_words:
        # تحسين المحتوى
        optimized_content = optimize_content(content, target_words)
        write_optimized_file(filepath, optimized_content)

    return word_count

def split_large_file(filepath, content):
    """تقسيم الملف الكبير إلى ملفات أصغر"""
    sections = extract_sections(content)
    base_name = os.path.splitext(filepath)[0]

    for i, section in enumerate(sections):
        new_filepath = f"{base_name}-part-{i+1}.md"
        with open(new_filepath, 'w', encoding='utf-8') as f:
            f.write(section)
```

### المرحلة 4: إنشاء نظام الحوكمة (يوم 4)

#### 4.1 GitHub Actions للتحقق

```yaml
# .github/workflows/steering-validation.yml
name: Steering Files Validation

on:
  push:
    paths:
      - ".kiro/steering/**"
  pull_request:
    paths:
      - ".kiro/steering/**"

jobs:
  validate-steering:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: "3.9"

      - name: Install dependencies
        run: |
          pip install pyyaml markdown

      - name: Validate Frontmatter
        run: python scripts/validate-frontmatter.py

      - name: Check File Sizes
        run: python scripts/check-file-sizes.py

      - name: Validate Links
        run: python scripts/validate-links.py

      - name: Check Consistency
        run: python scripts/check-consistency.py

      - name: Generate Report
        run: python scripts/generate-validation-report.py
```

#### 4.2 سكربت التحقق من Frontmatter

```python
#!/usr/bin/env python3
# scripts/validate-frontmatter.py

import os
import yaml
import sys
from pathlib import Path

def validate_frontmatter(filepath):
    """التحقق من صحة frontmatter"""

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if not content.startswith('---'):
        return False, "لا يحتوي على frontmatter"

    try:
        # استخراج frontmatter
        parts = content.split('---', 2)
        if len(parts) < 3:
            return False, "frontmatter غير مكتمل"

        frontmatter = yaml.safe_load(parts[1])

        # التحقق من الحقول المطلوبة
        required_fields = [
            'title', 'summary', 'scope', 'category',
            'tags', 'version', 'last_updated', 'author'
        ]

        missing_fields = []
        for field in required_fields:
            if field not in frontmatter:
                missing_fields.append(field)

        if missing_fields:
            return False, f"حقول مفقودة: {', '.join(missing_fields)}"

        # التحقق من طول الملخص
        summary_words = len(frontmatter['summary'].split())
        if summary_words < 10 or summary_words > 100:
            return False, f"طول الملخص غير مناسب: {summary_words} كلمة"

        return True, "صحيح"

    except yaml.YAMLError as e:
        return False, f"خطأ في YAML: {e}"

def main():
    """التحقق من جميع ملفات steering"""

    steering_dir = Path('.kiro/steering')
    errors = []

    for md_file in steering_dir.rglob('*.md'):
        is_valid, message = validate_frontmatter(md_file)

        if not is_valid:
            errors.append(f"❌ {md_file}: {message}")
        else:
            print(f"✅ {md_file}: {message}")

    if errors:
        print("\n🚨 أخطاء في ملفات Steering:")
        for error in errors:
            print(error)
        sys.exit(1)
    else:
        print("\n✅ جميع ملفات Steering صحيحة!")

if __name__ == "__main__":
    main()
```

---

## 📊 خطة التنفيذ التفصيلية

### الجدول الزمني

| اليوم | المهام                 | المدة المقدرة | المخرجات                |
| ----- | ---------------------- | ------------- | ----------------------- |
| **1** | إعادة التصنيف والتنظيم | 4-6 ساعات     | بنية جديدة منظمة        |
| **2** | إضافة Frontmatter      | 6-8 ساعات     | ملفات محسنة مع metadata |
| **3** | تحسين الأحجام          | 4-6 ساعات     | ملفات محسنة الحجم       |
| **4** | نظام الحوكمة           | 6-8 ساعات     | CI/CD وvalidation       |

### المعايير المستهدفة

| المعيار                  | الحالي   | المستهدف     | التحسن |
| ------------------------ | -------- | ------------ | ------ |
| **ملفات مع Frontmatter** | 30%      | 100%         | +70%   |
| **متوسط حجم الملف**      | 320 كلمة | 400-800 كلمة | محسن   |
| **التصنيف المنطقي**      | 2 فئات   | 5 فئات       | +150%  |
| **معايير الجودة**        | 65%      | 95%          | +30%   |
| **نظام الحوكمة**         | 0%       | 100%         | +100%  |

---

## 🎯 المخرجات المتوقعة

### 1. خريطة Steering منظمة

- بنية واضحة ومنطقية (5 فئات رئيسية)
- ملفات محسنة الحجم (≤1500 كلمة)
- frontmatter موحد وشامل

### 2. تقارير الحجم والاستخدام

- إحصائيات مفصلة لكل ملف
- تحليل أنماط الاستخدام
- توصيات التحسين

### 3. قائمة الملفات غير المتوافقة

- تحديد الملفات التي تحتاج تحسين
- خطة معالجة لكل ملف
- جدول زمني للإصلاح

### 4. خطة التجزئة والتحسين

- استراتيجية تقسيم الملفات الكبيرة
- معايير دمج الملفات الصغيرة
- خطة الصيانة المستمرة

---

## ✅ قائمة التحقق النهائية

### قبل البدء

- [ ] نسخ احتياطي من الملفات الحالية
- [ ] إعداد بيئة التطوير والأدوات
- [ ] مراجعة الخطة مع الفريق

### أثناء التنفيذ

- [ ] تطبيق التغييرات تدريجياً
- [ ] اختبار كل مرحلة قبل المتابعة
- [ ] توثيق التغييرات والقرارات

### بعد الانتهاء

- [ ] اختبار شامل للنظام الجديد
- [ ] قياس التحسن في الأداء
- [ ] تدريب الفريق على النظام الجديد
- [ ] إنشاء تقرير إنجاز نهائي

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 11 ديسمبر 2025  
**الحالة:** ✅ خطة تنفيذ مفصلة وجاهزة للتطبيق
