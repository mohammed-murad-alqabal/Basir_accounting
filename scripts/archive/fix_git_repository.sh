#!/bin/bash

# سكريبت إصلاح شامل لمستودع Git
# المشروع: بصير MVP
# التاريخ: 30 نوفمبر 2025

set -e  # إيقاف عند أي خطأ

# الألوان للإخراج
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# دالة للطباعة الملونة
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# عنوان السكريبت
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║     إصلاح شامل لمستودع Git - مشروع بصير MVP              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# التحقق من أننا في مستودع Git
if [ ! -d ".git" ]; then
    print_error "هذا المجلد ليس مستودع Git!"
    exit 1
fi

# التحقق من الاتصال بالإنترنت
print_step "التحقق من الاتصال بالمستودع البعيد..."
if ! git ls-remote origin &> /dev/null; then
    print_error "لا يمكن الاتصال بالمستودع البعيد!"
    exit 1
fi
print_success "الاتصال بالمستودع البعيد ناجح"

# 1. التأكد من الفرع الصحيح
print_step "التحقق من الفرع الحالي..."
CURRENT_BRANCH=$(git branch --show-current)
echo "   الفرع الحالي: $CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" != "master" ]; then
    print_warning "الفرع الحالي ليس master، سيتم التبديل..."
    git checkout master
    print_success "تم التبديل إلى master"
fi

# 2. التحقق من وجود تغييرات غير محفوظة
print_step "التحقق من وجود تغييرات غير محفوظة..."
if ! git diff-index --quiet HEAD --; then
    print_error "يوجد تغييرات غير محفوظة!"
    echo "   يرجى حفظ أو إلغاء التغييرات قبل المتابعة:"
    echo "   git add . && git commit -m 'save changes'"
    echo "   أو"
    echo "   git stash"
    exit 1
fi
print_success "لا توجد تغييرات غير محفوظة"

# 3. تحديث الفرع الحالي
print_step "تحديث الفرع master..."
git pull origin master
print_success "تم تحديث master"

# 4. إنشاء نسخة احتياطية
print_step "إنشاء نسخة احتياطية..."
BACKUP_NAME="backup-master-$(date +%Y%m%d-%H%M%S)"
git branch $BACKUP_NAME
git push origin $BACKUP_NAME
print_success "تم إنشاء نسخة احتياطية: $BACKUP_NAME"

# 5. التحقق من وجود origin/main
print_step "التحقق من وجود origin/main..."
if git ls-remote --heads origin main | grep -q main; then
    print_warning "تم العثور على origin/main"
    
    # طلب تأكيد من المستخدم
    echo ""
    echo "   هل تريد حذف origin/main؟"
    echo "   (سيتم الاحتفاظ بنسخة احتياطية)"
    read -p "   اكتب 'yes' للتأكيد: " CONFIRM
    
    if [ "$CONFIRM" = "yes" ]; then
        print_step "حذف origin/main..."
        
        # إنشاء نسخة احتياطية من main أيضاً
        BACKUP_MAIN="backup-main-$(date +%Y%m%d-%H%M%S)"
        git fetch origin main:$BACKUP_MAIN
        git push origin $BACKUP_MAIN
        print_success "تم إنشاء نسخة احتياطية من main: $BACKUP_MAIN"
        
        # حذف origin/main
        git push origin --delete main
        print_success "تم حذف origin/main"
    else
        print_warning "تم إلغاء حذف origin/main"
    fi
else
    print_success "origin/main غير موجود (جيد!)"
fi

# 6. تنظيف المراجع المحلية
print_step "تنظيف المراجع المحلية..."
git fetch --all --prune
git remote prune origin
print_success "تم تنظيف المراجع"

# 7. التحقق من النتيجة
print_step "التحقق من النتيجة..."
echo ""
echo "   📊 الفروع الحالية:"
echo "   ─────────────────────"
git branch -a | sed 's/^/   /'
echo ""

# 8. التحقق من حالة المستودع
print_step "التحقق من حالة المستودع..."
git status
echo ""

# 9. اختبار جودة الكود
print_step "اختبار جودة الكود..."
if command -v flutter &> /dev/null; then
    echo "   تشغيل flutter analyze..."
    if flutter analyze --no-pub 2>&1 | grep -q "No issues found"; then
        print_success "flutter analyze: لا توجد مشاكل"
    else
        print_warning "flutter analyze: توجد بعض المشاكل"
    fi
else
    print_warning "Flutter غير مثبت، تم تخطي الاختبار"
fi

# 10. الخلاصة
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    ✅ اكتمل الإصلاح!                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
print_success "تم إصلاح المستودع بنجاح!"
echo ""
echo "📋 الخطوات التالية:"
echo "   1. تحديث الفرع الافتراضي على GitHub إلى 'master'"
echo "      الرابط: https://github.com/mohammed-murad-alqabal/Basser_MVP/settings/branches"
echo ""
echo "   2. إعلام أعضاء الفريق (إن وجدوا) بتنفيذ:"
echo "      git fetch --all --prune"
echo "      git checkout master"
echo "      git pull origin master"
echo ""
echo "   3. مراجعة الملفات المنشأة:"
echo "      - GIT_REPOSITORY_ANALYSIS_AND_FIX.md"
echo "      - GIT_WORKFLOW_ANALYSIS.md"
echo "      - CONTRIBUTING.md"
echo ""
print_success "النسخ الاحتياطية المتوفرة:"
git branch -a | grep backup | sed 's/^/   /'
echo ""
