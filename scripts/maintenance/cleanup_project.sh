#!/bin/bash

# سكريبت تنظيف وأرشفة مشروع بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 1 ديسمبر 2025

set -e

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# دوال الطباعة
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_header() { echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

echo ""
print_header
echo -e "${BLUE}🧹 تنظيف وأرشفة مشروع بصير MVP${NC}"
print_header
echo ""

# التحقق من وجود تغييرات غير محفوظة
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    print_warning "يوجد تغييرات غير محفوظة في Git"
    read -p "هل تريد المتابعة؟ (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "تم الإلغاء"
        exit 1
    fi
fi

# إحصائيات قبل التنظيف
print_info "📊 الإحصائيات قبل التنظيف:"
BEFORE_COUNT=$(ls -1 *.md 2>/dev/null | wc -l)
BEFORE_SIZE=$(du -sh . 2>/dev/null | cut -f1)
print_info "  - ملفات MD في الجذر: $BEFORE_COUNT"
print_info "  - حجم المشروع: $BEFORE_SIZE"
echo ""

# المرحلة 1: إنشاء مجلدات الأرشيف
print_info "📁 المرحلة 1: إنشاء مجلدات الأرشيف..."
mkdir -p Documentation/Archive/Reports
mkdir -p Documentation/Archive/Old_Guides
mkdir -p Documentation/Archive/Analysis
mkdir -p Documentation/Archive/Misc
print_success "تم إنشاء مجلدات الأرشيف"
echo ""

# المرحلة 2: نقل التقارير
print_info "📦 المرحلة 2: أرشفة التقارير القديمة..."

# قائمة الملفات المراد الاحتفاظ بها في الجذر
KEEP_FILES=(
    "README.md"
    "CHANGELOG.md"
    "CONTRIBUTING.md"
    "LICENSE"
    "ARCHITECTURE.md"
    "DEVELOPMENT_GUIDE.md"
    "QUICK_START.md"
    "INSTALLATION.md"
    "SECURITY.md"
    "CODING_STANDARDS.md"
    "PERFORMANCE_OPTIMIZATION_GUIDE.md"
    "QUICK_PERFORMANCE_FIXES.md"
    "SYSTEM_DIAGNOSIS_REPORT.md"
)

# نقل التقارير
MOVED_COUNT=0

# نقل جميع ملفات REPORT
for file in *_REPORT.md; do
    if [ -f "$file" ]; then
        # التحقق من أنه ليس في قائمة الاحتفاظ
        if [[ ! " ${KEEP_FILES[@]} " =~ " ${file} " ]]; then
            mv "$file" Documentation/Archive/Reports/
            print_success "نقل: $file"
            ((MOVED_COUNT++))
        fi
    fi
done

# نقل ملفات SUMMARY
for file in *_SUMMARY.md; do
    if [ -f "$file" ]; then
        mv "$file" Documentation/Archive/Reports/
        print_success "نقل: $file"
        ((MOVED_COUNT++))
    fi
done

# نقل ملفات ANALYSIS
for file in *_ANALYSIS*.md *Analysis*.md; do
    if [ -f "$file" ]; then
        if [[ ! " ${KEEP_FILES[@]} " =~ " ${file} " ]]; then
            mv "$file" Documentation/Archive/Analysis/
            print_success "نقل: $file"
            ((MOVED_COUNT++))
        fi
    fi
done

# نقل ملفات COMPLETION
for file in *_COMPLETION*.md *COMPLETE*.md; do
    if [ -f "$file" ]; then
        mv "$file" Documentation/Archive/Reports/
        print_success "نقل: $file"
        ((MOVED_COUNT++))
    fi
done

# نقل ملفات STATUS
for file in *_STATUS*.md; do
    if [ -f "$file" ]; then
        if [[ ! " ${KEEP_FILES[@]} " =~ " ${file} " ]]; then
            mv "$file" Documentation/Archive/Reports/
            print_success "نقل: $file"
            ((MOVED_COUNT++))
        fi
    fi
done

# نقل ملفات GUIDE القديمة
for file in *_GUIDE.md; do
    if [ -f "$file" ]; then
        if [[ ! " ${KEEP_FILES[@]} " =~ " ${file} " ]]; then
            mv "$file" Documentation/Archive/Old_Guides/
            print_success "نقل: $file"
            ((MOVED_COUNT++))
        fi
    fi
done

# نقل ملفات PLAN
for file in *_PLAN.md; do
    if [ -f "$file" ]; then
        mv "$file" Documentation/Archive/Reports/
        print_success "نقل: $file"
        ((MOVED_COUNT++))
    fi
done

# نقل ملفات متفرقة
MISC_FILES=(
    "ALTERNATIVE_SAFE_APPROACH.md"
    "CHECKPOINT_*.md"
    "CORRECT_GITHUB_PATH.md"
    "DECISION_POINT_REPORT.md"
    "Engineering_Analysis_Report.md"
    "ERROR_TRACKING_SETUP_COMPLETE.md"
    "EVALUATION_REPORT.md"
    "FIX_*.md"
    "GIT_*.md"
    "IDENTITY_UPDATE_REPORT.md"
    "KIRO_*.md"
    "MANUAL_STEPS_REQUIRED.md"
    "MERGE_DECISION_FINAL.md"
    "MISSION_ACCOMPLISHED_REPORT.md"
    "NEXT_STEPS_GUIDE.md"
    "Phase_*.md"
    "PROVIDERS_INTEGRATION_GUIDE.md"
    "QUICK_REFERENCE*.md"
    "README_QUICK_FIX.md"
    "REPOSITORY_STATUS_REPORT.md"
    "SESSION_SUMMARY.md"
    "STANDARDS_IMPLEMENTATION_REPORT.md"
    "START_HERE.md"
    "STRATEGIC_*.md"
    "SUCCESS_REPORT.md"
    "WORK_COMPLETED_SUMMARY.md"
)

for pattern in "${MISC_FILES[@]}"; do
    for file in $pattern; do
        if [ -f "$file" ]; then
            if [[ ! " ${KEEP_FILES[@]} " =~ " ${file} " ]]; then
                mv "$file" Documentation/Archive/Misc/
                print_success "نقل: $file"
                ((MOVED_COUNT++))
            fi
        fi
    done
done

echo ""
print_success "تم نقل $MOVED_COUNT ملف إلى الأرشيف"
echo ""

# المرحلة 3: تنظيف ملفات النصوص
print_info "🗑️  المرحلة 3: تنظيف ملفات النصوص القديمة..."

# نقل ملفات txt القديمة
if [ -f "analysis_before_fixes.txt" ]; then
    mv analysis_before_fixes.txt Documentation/Archive/Analysis/
    print_success "نقل: analysis_before_fixes.txt"
fi

if [ -f "analysis_final.txt" ]; then
    mv analysis_final.txt Documentation/Archive/Analysis/
    print_success "نقل: analysis_final.txt"
fi

if [ -f "analysis_output.txt" ]; then
    mv analysis_output.txt Documentation/Archive/Analysis/
    print_success "نقل: analysis_output.txt"
fi

if [ -f "test_results_final.txt" ]; then
    mv test_results_final.txt Documentation/Archive/Reports/
    print_success "نقل: test_results_final.txt"
fi

if [ -f "tests_before_fixes.txt" ]; then
    mv tests_before_fixes.txt Documentation/Archive/Reports/
    print_success "نقل: tests_before_fixes.txt"
fi

echo ""

# المرحلة 4: تنظيف السكريبتات القديمة
print_info "🔧 المرحلة 4: تنظيف السكريبتات القديمة..."

if [ -f "fix_git_repository.sh" ]; then
    mv fix_git_repository.sh scripts/archive/
    print_success "نقل: fix_git_repository.sh"
fi

if [ -f "fix_git_repository_complete.sh" ]; then
    mv fix_git_repository_complete.sh scripts/archive/
    print_success "نقل: fix_git_repository_complete.sh"
fi

echo ""

# المرحلة 5: إنشاء README للأرشيف
print_info "📝 المرحلة 5: إنشاء README للأرشيف..."

cat > Documentation/Archive/README.md << 'EOF'
# أرشيف الوثائق

هذا المجلد يحتوي على الوثائق والتقارير القديمة التي تم أرشفتها للحفاظ على نظافة المشروع.

## البنية

- **Reports/** - التقارير القديمة
- **Old_Guides/** - الأدلة القديمة
- **Analysis/** - تقارير التحليل
- **Misc/** - ملفات متفرقة

## ملاحظة

هذه الملفات محفوظة للرجوع إليها عند الحاجة، ولكنها لم تعد نشطة في المشروع.

---

**تم الأرشفة بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 1 ديسمبر 2025
EOF

print_success "تم إنشاء README للأرشيف"
echo ""

# المرحلة 6: تحديث .gitignore
print_info "⚙️  المرحلة 6: تحديث .gitignore..."

if ! grep -q "Documentation/Archive/" .gitignore 2>/dev/null; then
    echo "" >> .gitignore
    echo "# Archived documentation" >> .gitignore
    echo "# Documentation/Archive/" >> .gitignore
    print_success "تم تحديث .gitignore"
else
    print_info ".gitignore محدث مسبقاً"
fi

echo ""

# إحصائيات بعد التنظيف
print_info "📊 الإحصائيات بعد التنظيف:"
AFTER_COUNT=$(ls -1 *.md 2>/dev/null | wc -l)
AFTER_SIZE=$(du -sh . 2>/dev/null | cut -f1)
print_info "  - ملفات MD في الجذر: $AFTER_COUNT"
print_info "  - حجم المشروع: $AFTER_SIZE"
print_info "  - تم نقل: $MOVED_COUNT ملف"
echo ""

# المقارنة
REDUCTION=$((BEFORE_COUNT - AFTER_COUNT))
PERCENTAGE=$((REDUCTION * 100 / BEFORE_COUNT))
print_success "تحسين: تم تقليل $REDUCTION ملف ($PERCENTAGE%)"
echo ""

# المرحلة 7: عرض الملفات المتبقية
print_info "📄 الملفات المتبقية في الجذر:"
ls -1 *.md 2>/dev/null | while read file; do
    print_info "  ✓ $file"
done
echo ""

# المرحلة 8: Git operations
print_info "🔄 المرحلة 7: عمليات Git..."

# إضافة التغييرات
git add . && print_success "تم إضافة التغييرات"

# عرض الحالة
print_info "حالة Git:"
git status --short

echo ""
print_warning "هل تريد عمل commit للتغييرات؟ (y/n)"
read -p "> " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    git commit -m "docs: تنظيف وأرشفة الوثائق القديمة

- نقل $MOVED_COUNT ملف إلى Documentation/Archive/
- تقليل ملفات MD في الجذر من $BEFORE_COUNT إلى $AFTER_COUNT
- تحسين التنظيم والأداء
- إنشاء بنية أرشيف منظمة

تم بواسطة: فريق وكلاء تطوير مشروع بصير"
    
    print_success "تم عمل commit"
    
    echo ""
    print_warning "هل تريد push إلى المستودع البعيد؟ (y/n)"
    read -p "> " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin main && print_success "تم push إلى المستودع البعيد"
    else
        print_info "يمكنك push لاحقاً باستخدام: git push origin main"
    fi
else
    print_info "يمكنك commit لاحقاً باستخدام:"
    print_info "  git commit -m 'docs: تنظيف وأرشفة الوثائق القديمة'"
fi

echo ""
print_header
print_success "🎉 تم التنظيف بنجاح!"
print_header
echo ""

# ملخص نهائي
echo "📋 الملخص:"
echo "  ✅ تم نقل $MOVED_COUNT ملف إلى الأرشيف"
echo "  ✅ تقليل الملفات من $BEFORE_COUNT إلى $AFTER_COUNT"
echo "  ✅ تحسين $PERCENTAGE% في عدد الملفات"
echo "  ✅ تنظيم أفضل للمشروع"
echo ""

print_info "💡 الخطوات التالية:"
print_info "  1. أعد تشغيل VS Code/Kiro لتطبيق التحسينات"
print_info "  2. اختبر الأداء باستخدام: time git status"
print_info "  3. راجع Documentation/Archive/ عند الحاجة"
echo ""

print_success "استمتع ببيئة تطوير نظيفة ومنظمة! 🚀"
