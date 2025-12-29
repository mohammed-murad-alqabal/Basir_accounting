# خطة التنفيذ: تنظيف جذر المشروع

**المشروع:** بصير MVP  
**التاريخ:** 9 ديسمبر 2025  
**المخطط:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** 📋 جاهز للتنفيذ

---

## 🎯 الهدف

تنظيف جذر المشروع من 61+ ملف إلى 7 ملفات ضرورية فقط، مع تحسين التنظيم بنسبة 88.5%.

---

## 📋 المراحل التنفيذية

### المرحلة 1: النسخ الاحتياطي والتحضير

**الأولوية:** 🔴 حرجة  
**الوقت المقدر:** 2 دقيقة

#### الخطوات

1. **إنشاء نسخة احتياطية:**

   ```bash
   git add -A
   git commit -m "backup: قبل التنظيف الشامل للجذر"
   ```

2. **التحقق من الحالة:**

   ```bash
   git status
   ls -la | wc -l
   ```

3. **إنشاء المجلدات المطلوبة:**
   ```bash
   mkdir -p logs/flutter
   mkdir -p logs/git
   mkdir -p scripts/maintenance
   mkdir -p .kiro/data
   mkdir -p docs/api
   ```

#### معايير النجاح

- ✅ commit ناجح
- ✅ جميع المجلدات موجودة
- ✅ لا أخطاء

---

### المرحلة 2: نقل ملفات MD (30 ملف)

**الأولوية:** 🔴 عالية جداً  
**الوقت المقدر:** 10 دقائق

#### 2.1: تقارير Kiro (7 ملفات)

**الوجهة:** `.kiro/docs/reports/kiro/`

```bash
# نقل الملفات
mv KIRO_AUDIT_COMPLETION_REPORT.md .kiro/docs/reports/kiro/
mv KIRO_AUDIT_SUMMARY.md .kiro/docs/reports/kiro/
mv KIRO_IMPROVEMENT_FINAL_REPORT.md .kiro/docs/reports/kiro/
mv KIRO_PRIORITY_1_COMPLETION_REPORT.md .kiro/docs/reports/kiro/
mv DOCUMENTATION_ORGANIZATION_SUCCESS.md .kiro/docs/reports/kiro/
mv ERROR_TRACKING_SPECS_SUMMARY.md .kiro/docs/reports/kiro/
mv REPOSITORY_IMPROVEMENTS_COMPLETE.md .kiro/docs/reports/kiro/

# التحقق
ls -1 .kiro/docs/reports/kiro/*.md | wc -l
# المتوقع: 15 (8 موجودة + 7 جديدة)
```

#### 2.2: تقارير Git (4 ملفات)

**الوجهة:** `docs/reports/fixes/`

```bash
# نقل الملفات
mv GIT_PUSH_COMPREHENSIVE_SUCCESS.md docs/reports/fixes/
mv GIT_PUSH_STRATEGY.md docs/reports/fixes/
mv GIT_PUSH_SUCCESS_REPORT_V2.md docs/reports/fixes/
mv GIT_STATUS_ANALYSIS_REPORT.md docs/reports/fixes/

# التحقق
ls -1 docs/reports/fixes/GIT*.md | wc -l
# المتوقع: 4
```

#### 2.3: تقارير GitHub Workflows (4 ملفات)

**الوجهة:** `docs/reports/fixes/`

```bash
# نقل الملفات
mv GITHUB_WORKFLOWS_COMPLETE.md docs/reports/fixes/
mv GITHUB_WORKFLOWS_FIX_REPORT.md docs/reports/fixes/
mv GITHUB_WORKFLOWS_STATUS.md docs/reports/fixes/
mv WORKFLOWS_FIX_FINAL_REPORT.md docs/reports/fixes/

# التحقق
ls -1 docs/reports/fixes/*WORKFLOW*.md | wc -l
# المتوقع: 4
```

#### 2.4: تقارير MCP (8 ملفات)

**الوجهة:** `.kiro/docs/reports/components/`

```bash
# نقل الملفات
mv MCP_FINAL_SUMMARY.md .kiro/docs/reports/components/
mv MCP_IMPLEMENTATION_COMPLETE.md .kiro/docs/reports/components/
mv MCP_NEXT_STEPS_ANALYSIS.md .kiro/docs/reports/components/
mv MCP_SERVERS_COMPLETE_SETUP.md .kiro/docs/reports/components/
mv MCP_SERVERS_FIX_REPORT.md .kiro/docs/reports/components/
mv MCP_SERVERS_QUICK_GUIDE.md .kiro/docs/reports/components/
mv MCP_STATUS.md .kiro/docs/reports/components/
mv MCP_USAGE_EXAMPLES.md .kiro/docs/reports/components/

# التحقق
ls -1 .kiro/docs/reports/components/MCP*.md | wc -l
# المتوقع: 10 (2 موجودة + 8 جديدة)
```

#### 2.5: تقارير Mobile (2 ملف)

**الوجهة:** `docs/reports/fixes/`

```bash
# نقل الملفات
mv MOBILE_FIX_REPORT.md docs/reports/fixes/
mv MOBILE_TEST_STATUS.md docs/reports/fixes/

# التحقق
ls -1 docs/reports/fixes/MOBILE*.md | wc -l
# المتوقع: 2
```

#### 2.6: تقارير Phases (3 ملفات)

**الوجهة:** `.kiro/docs/reports/phases/`

```bash
# نقل الملفات
mv PHASE_1_COMPLETION_REPORT.md .kiro/docs/reports/phases/
mv PHASE_2_COMPLETION_REPORT.md .kiro/docs/reports/phases/
mv PHASE_3_COMPLETION_REPORT.md .kiro/docs/reports/phases/

# التحقق
ls -1 .kiro/docs/reports/phases/PHASE*.md | wc -l
# المتوقع: 6 (3 موجودة + 3 جديدة)
```

#### 2.7: ملفات متنوعة (2 ملف)

```bash
# نقل ACTION_ITEMS.md
mv ACTION_ITEMS.md docs/

# نقل RECOMMENDED_ACTIONS.md
mv RECOMMENDED_ACTIONS.md docs/

# نقل TASK_COMPLETION_SUMMARY.md
mv TASK_COMPLETION_SUMMARY.md .kiro/docs/reports/sessions/

# التحقق
ls -1 docs/ACTION*.md | wc -l
# المتوقع: 1
```

#### معايير النجاح المرحلة 2

- ✅ 30 ملف منقول
- ✅ 7 ملفات MD متبقية في الجذر
- ✅ جميع الملفات في أماكنها الصحيحة

---

### المرحلة 3: حذف ملفات LOG (16 ملف)

**الأولوية:** 🔴 عالية  
**الوقت المقدر:** 1 دقيقة

#### الخطوات

```bash
# حذف جميع ملفات flutter_*.log
rm -f flutter_*.log

# التحقق
ls -1 flutter_*.log 2>/dev/null | wc -l
# المتوقع: 0
```

#### معايير النجاح

- ✅ 0 ملفات log في الجذر
- ✅ لا أخطاء

---

### المرحلة 4: نقل ملفات SH (3 ملفات)

**الأولوية:** 🟡 متوسطة  
**الوقت المقدر:** 2 دقيقة

#### الخطوات

```bash
# نقل الملفات
mv cleanup_project.sh scripts/maintenance/
mv fix_all_issues.sh scripts/maintenance/
mv optimize_environment.sh scripts/maintenance/

# التحقق
ls -1 scripts/maintenance/*.sh | wc -l
# المتوقع: 3+
```

#### معايير النجاح

- ✅ 3 ملفات sh منقولة
- ✅ 0 ملفات sh في الجذر

---

### المرحلة 5: دمج docs/docs

**الأولوية:** 🟡 متوسطة  
**الوقت المقدر:** 2 دقيقة

#### الخطوات

```bash
# نقل docs/api/ إلى docs/
if [ -d "docs/api" ]; then
  mv docs/api docs/
fi

# حذف مجلد docs/ إذا كان فارغاً
if [ -z "$(ls -A docs)" ]; then
  rmdir docs
fi

# التحقق
ls -d docs/api
# المتوقع: docs/api
```

#### معايير النجاح

- ✅ `docs/api/` منقول إلى `docs/api/`
- ✅ مجلد `docs/` محذوف
- ✅ لا تكرار

---

### المرحلة 6: تنظيف ملفات متنوعة

**الأولوية:** 🟢 منخفضة  
**الوقت المقدر:** 3 دقائق

#### 6.1: .bash_aliases_basser

```bash
# نقل أو حذف
mv .bash_aliases_basser scripts/maintenance/ || rm .bash_aliases_basser
```

#### 6.2: git_fsck_report.txt

```bash
# نقل إلى logs/git/
mv git_fsck_report.txt logs/git/
```

#### 6.3: sqlite_mcp_server.db

```bash
# نقل إلى .kiro/data/
mv sqlite_mcp_server.db .kiro/data/
```

#### 6.4: fix_int_literals.py

```bash
# نقل إلى scripts/maintenance/
mv fix_int_literals.py scripts/maintenance/
```

#### 6.5: libisar.so

```bash
# التحقق من .gitignore
grep -q "libisar.so" .gitignore || echo "*.so" >> .gitignore

# حذف إذا كان في .gitignore
rm -f libisar.so
```

#### معايير النجاح

- ✅ جميع الملفات المتنوعة منظمة
- ✅ جذر نظيف

---

### المرحلة 7: التحديثات والتوثيق

**الأولوية:** 🟡 متوسطة  
**الوقت المقدر:** 5 دقائق

#### 7.1: تحديث .gitignore

```bash
# التأكد من تجاهل الملفات المؤقتة
cat >> .gitignore << 'EOF'

# Temporary files in root
/*.log
/*.tmp
/*.temp
/*.bak

# Database files
/*.db
/*.sqlite

# Shared libraries
/*.so
/*.dll
/*.dylib
EOF
```

#### 7.2: تحديث README.md

تحديث أي روابط قديمة في README.md

#### 7.3: إنشاء تقرير النجاح

إنشاء ملف `PROJECT_ROOT_CLEANUP_SUCCESS_REPORT.md`

#### معايير النجاح

- ✅ .gitignore محدث
- ✅ README.md محدث
- ✅ تقرير النجاح موجود

---

### المرحلة 8: التحقق النهائي والـ Commit

**الأولوية:** 🔴 حرجة  
**الوقت المقدر:** 3 دقيقة

#### الخطوات

```bash
# 1. التحقق من عدد الملفات في الجذر
ls -1 *.md | wc -l
# المتوقع: 7

ls -1 *.log | wc -l
# المتوقع: 0

ls -1 *.sh | wc -l
# المتوقع: 0

# 2. التحقق من البنية
tree -L 2 .kiro/docs/reports/
tree -L 2 docs/reports/
tree -L 2 scripts/

# 3. Git status
git status

# 4. Git add
git add -A

# 5. Git commit
git commit -m "refactor: تنظيف شامل لجذر المشروع

- نقل 30 ملف MD إلى أماكنها المناسبة
- حذف 16 ملف log قديم
- نقل 3 ملفات sh إلى scripts/maintenance/
- دمج docs/docs
- تنظيف 5+ ملفات متنوعة
- تحديث .gitignore
- تحسين التنظيم بنسبة 88.5%

Refs: .kiro/docs/reports/reorganization/PROJECT_ROOT_CLEANUP_ANALYSIS.md"

# 6. التحقق النهائي
git log -1 --stat
```

#### معايير النجاح

- ✅ 7 ملفات MD فقط في الجذر
- ✅ 0 ملفات log
- ✅ 0 ملفات sh
- ✅ commit ناجح
- ✅ لا أخطاء

---

## 📊 ملخص التنفيذ

### الإحصائيات

| المرحلة        | الملفات     | الوقت        | الأولوية      |
| -------------- | ----------- | ------------ | ------------- |
| 1. التحضير     | -           | 2 دقيقة      | 🔴 حرجة       |
| 2. نقل MD      | 30 ملف      | 10 دقيقة     | 🔴 عالية جداً |
| 3. حذف LOG     | 16 ملف      | 1 دقيقة      | 🔴 عالية      |
| 4. نقل SH      | 3 ملفات     | 2 دقيقة      | 🟡 متوسطة     |
| 5. دمج docs    | -           | 2 دقيقة      | 🟡 متوسطة     |
| 6. تنظيف متنوع | 5+ ملفات    | 3 دقيقة      | 🟢 منخفضة     |
| 7. التوثيق     | -           | 5 دقيقة      | 🟡 متوسطة     |
| 8. التحقق      | -           | 3 دقيقة      | 🔴 حرجة       |
| **الإجمالي**   | **54+ ملف** | **28 دقيقة** | -             |

### النتائج المتوقعة

**قبل:**

- 61+ ملف في الجذر
- فوضى: 8.5/10
- صيانة: 3/10

**بعد:**

- 7 ملفات في الجذر
- فوضى: 1.5/10
- صيانة: 9/10

**التحسين:**

- تقليل الملفات: 88.5% ⬇️
- تحسين الفوضى: 82% ⬆️
- تحسين الصيانة: 200% ⬆️

---

## ⚠️ نقاط الانتباه

### قبل التنفيذ

1. ✅ نسخة احتياطية (commit)
2. ✅ التحقق من المراجع
3. ✅ قراءة الخطة كاملة

### أثناء التنفيذ

1. ✅ تنفيذ مرحلة واحدة في كل مرة
2. ✅ التحقق بعد كل مرحلة
3. ✅ عدم تخطي الخطوات

### بعد التنفيذ

1. ✅ التحقق النهائي
2. ✅ اختبار الروابط
3. ✅ commit ناجح

---

## 🎯 الخطوة التالية

**انتظار موافقة المستخدم للبدء في التنفيذ**

عند الموافقة، سيتم تنفيذ جميع المراحل بالترتيب مع التحقق بعد كل مرحلة.

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 9 ديسمبر 2025  
**الحالة:** 📋 جاهز للتنفيذ
