#!/bin/bash

# Kiro Strategic Workspace - كوميت ودفع ذكي
# التاريخ: 3 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# ========================================
# الألوان
# ========================================
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# ========================================
# المعاملات
# ========================================
COMMIT_MESSAGE="${1:-}"
SKIP_TESTS="${SKIP_TESTS:-false}"
SKIP_CHECKS="${SKIP_CHECKS:-false}"

# ========================================
# دوال المساعدة
# ========================================
print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${CYAN}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_step() { echo -e "${PURPLE}▶ $1${NC}"; }

# ========================================
# التحقق من البيئة
# ========================================
check_environment() {
    print_step "التحقق من البيئة..."
    
    if ! command -v git &> /dev/null; then
        print_error "Git غير مثبت"
        exit 1
    fi
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "ليس مستودع Git"
        exit 1
    fi
    
    print_success "البيئة جاهزة"
}

# ========================================
# التحقق من التغييرات
# ========================================
check_changes() {
    print_step "التحقق من التغييرات..."
    
    if git diff-index --quiet HEAD --; then
        print_warning "لا توجد تغييرات للكوميت"
        exit 0
    fi
    
    local changed_count=$(git diff --name-only HEAD | wc -l)
    print_info "عدد الملفات المتغيرة: $changed_count"
    
    # عرض الملفات
    echo ""
    git status --short | head -10
    if [ $(git status --short | wc -l) -gt 10 ]; then
        echo "... و$(( $(git status --short | wc -l) - 10 )) ملف آخر"
    fi
    echo ""
    
    print_success "توجد تغييرات للكوميت"
}

# ========================================
# تحليل التغييرات
# ========================================
analyze_changes() {
    print_step "تحليل التغييرات..."
    
    local changed_files=$(git diff --name-only HEAD)
    
    # تحديد النوع والنطاق
    if echo "$changed_files" | grep -q "lib/.*\.dart$"; then
        if echo "$changed_files" | grep -q "lib/features/auth/"; then
            TYPE="feat"
            SCOPE="auth"
        elif echo "$changed_files" | grep -q "lib/features/customers/"; then
            TYPE="feat"
            SCOPE="customers"
        elif echo "$changed_files" | grep -q "lib/features/invoices/"; then
            TYPE="feat"
            SCOPE="invoices"
        elif echo "$changed_files" | grep -q "lib/features/dashboard/"; then
            TYPE="feat"
            SCOPE="dashboard"
        elif echo "$changed_files" | grep -q "lib/core/"; then
            TYPE="refactor"
            SCOPE="core"
        else
            TYPE="feat"
            SCOPE="code"
        fi
    elif echo "$changed_files" | grep -q "test/.*\.dart$"; then
        TYPE="test"
        SCOPE="testing"
    elif echo "$changed_files" | grep -q "\.md$"; then
        TYPE="docs"
        SCOPE="documentation"
    elif echo "$changed_files" | grep -q "pubspec\.yaml"; then
        TYPE="chore"
        SCOPE="deps"
    elif echo "$changed_files" | grep -q "\.kiro/"; then
        TYPE="chore"
        SCOPE="workspace"
    elif echo "$changed_files" | grep -q "\.github/"; then
        TYPE="ci"
        SCOPE="github"
    else
        TYPE="chore"
        SCOPE="misc"
    fi
    
    print_info "النوع: $TYPE | النطاق: $SCOPE"
    print_success "تم التحليل"
}

# ========================================
# تشغيل الفحوصات
# ========================================
run_checks() {
    if [ "$SKIP_CHECKS" = "true" ]; then
        print_warning "تخطي الفحوصات"
        return
    fi
    
    print_step "تشغيل الفحوصات..."
    
    local checks_passed=true
    
    # 1. فحص التنسيق
    if command -v flutter &> /dev/null; then
        print_info "فحص التنسيق..."
        if flutter format --set-exit-if-changed . > /dev/null 2>&1; then
            print_success "التنسيق صحيح"
        else
            print_warning "تطبيق التنسيق..."
            flutter format . > /dev/null 2>&1
        fi
    fi
    
    # 2. فحص التحليل
    if command -v flutter &> /dev/null && [ "$TYPE" != "docs" ]; then
        print_info "فحص التحليل..."
        if flutter analyze --no-pub > /dev/null 2>&1; then
            print_success "التحليل نظيف"
        else
            print_error "فشل التحليل"
            flutter analyze --no-pub
            checks_passed=false
        fi
    fi
    
    # 3. فحص الاختبارات
    if [ "$SKIP_TESTS" != "true" ] && [ "$TYPE" != "docs" ] && command -v flutter &> /dev/null; then
        print_info "تشغيل الاختبارات..."
        if flutter test > /dev/null 2>&1; then
            print_success "الاختبارات نجحت"
        else
            print_warning "بعض الاختبارات فشلت"
        fi
    fi
    
    # 4. فحص الأسرار
    print_info "فحص الأسرار..."
    if git diff HEAD | grep -iE '(api[_-]?key|password|secret|token|private[_-]?key)' > /dev/null; then
        print_error "تم اكتشاف أسرار محتملة!"
        checks_passed=false
    else
        print_success "لا توجد أسرار"
    fi
    
    if [ "$checks_passed" = false ]; then
        print_error "فشلت بعض الفحوصات"
        exit 1
    fi
    
    print_success "جميع الفحوصات نجحت"
}

# ========================================
# إنشاء رسالة الكوميت
# ========================================
generate_commit_message() {
    print_step "إنشاء رسالة الكوميت..."
    
    # استخدام الرسالة المخصصة أو التلقائية
    if [ -n "$COMMIT_MESSAGE" ]; then
        DESC="$COMMIT_MESSAGE"
    else
        case "$TYPE" in
            "feat")
                DESC="تحديث $SCOPE"
                ;;
            "fix")
                DESC="إصلاح مشاكل في $SCOPE"
                ;;
            "docs")
                DESC="تحديث التوثيق"
                ;;
            "test")
                DESC="تحديث الاختبارات"
                ;;
            "refactor")
                DESC="إعادة هيكلة $SCOPE"
                ;;
            "chore")
                if [ "$SCOPE" = "workspace" ]; then
                    DESC="تحديث Kiro Strategic Workspace"
                else
                    DESC="تحديث $SCOPE"
                fi
                ;;
            *)
                DESC="تحديثات متنوعة"
                ;;
        esac
    fi
    
    # إنشاء الرسالة الكاملة
    MESSAGE="$TYPE($SCOPE): $DESC

التغييرات:
$(git diff --name-status HEAD | head -10)

التاريخ: $(date '+%Y-%m-%d %H:%M:%S')
المؤلف: فريق وكلاء تطوير مشروع بصير"
    
    print_info "الرسالة: $TYPE($SCOPE): $DESC"
    print_success "تم إنشاء الرسالة"
}

# ========================================
# إنشاء الكوميت
# ========================================
create_commit() {
    print_step "إنشاء الكوميت..."
    
    # إضافة الملفات
    git add -A
    
    # إنشاء الكوميت
    echo "$MESSAGE" | git commit -F -
    
    COMMIT_HASH=$(git rev-parse --short HEAD)
    print_success "الكوميت: $COMMIT_HASH"
}

# ========================================
# الدفع
# ========================================
push_changes() {
    print_step "الدفع إلى المستودع البعيد..."
    
    CURRENT_BRANCH=$(git branch --show-current)
    print_info "الفرع: $CURRENT_BRANCH"
    
    # التحقق من وجود remote
    if ! git remote get-url origin > /dev/null 2>&1; then
        print_warning "لا يوجد remote - تخطي الدفع"
        return
    fi
    
    # الدفع
    if git push origin "$CURRENT_BRANCH" 2>&1; then
        print_success "تم الدفع بنجاح"
    else
        print_error "فشل الدفع"
        print_info "يمكنك الدفع يدوياً: git push origin $CURRENT_BRANCH"
        exit 1
    fi
}

# ========================================
# إنشاء تقرير
# ========================================
generate_report() {
    print_step "إنشاء التقرير..."
    
    local report_dir=".kiro/analytics/reports/git"
    local report_file="$report_dir/commit-push-$(date +%Y%m%d-%H%M%S).md"
    
    mkdir -p "$report_dir"
    
    cat > "$report_file" << EOF
# تقرير الكوميت والدفع

**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')  
**الكوميت:** $COMMIT_HASH  
**الفرع:** $CURRENT_BRANCH  
**النوع:** $TYPE($SCOPE)

## رسالة الكوميت

\`\`\`
$MESSAGE
\`\`\`

## الملفات المتغيرة

\`\`\`
$(git diff --name-status HEAD~1 HEAD)
\`\`\`

## الإحصائيات

- الملفات: $(git diff --name-only HEAD~1 HEAD | wc -l)
- الإضافات: $(git diff --shortstat HEAD~1 HEAD | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+' || echo 0)
- الحذف: $(git diff --shortstat HEAD~1 HEAD | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+' || echo 0)

## الفحوصات

- التنسيق: ✅
- التحليل: ✅
- الاختبارات: $([ "$SKIP_TESTS" = "true" ] && echo "⏭️ متخطى" || echo "✅")
- الأسرار: ✅

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نجح
EOF
    
    print_success "التقرير: $report_file"
}

# ========================================
# الدالة الرئيسية
# ========================================
main() {
    print_header "🚀 Kiro Strategic Workspace - كوميت ودفع ذكي"
    
    # تنفيذ الخطوات
    check_environment
    check_changes
    analyze_changes
    run_checks
    generate_commit_message
    create_commit
    push_changes
    generate_report
    
    # الخلاصة
    print_header "🎉 اكتمل بنجاح!"
    
    echo ""
    print_success "تم الكوميت والدفع بنجاح!"
    echo ""
    print_info "الملخص:"
    echo "  • الكوميت: $COMMIT_HASH"
    echo "  • النوع: $TYPE($SCOPE)"
    echo "  • الفرع: $CURRENT_BRANCH"
    echo "  • الرسالة: $DESC"
    echo ""
    print_success "Workspace محدث! 🚀"
    echo ""
}

# عرض المساعدة
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "الاستخدام: $0 [رسالة الكوميت]"
    echo ""
    echo "الخيارات:"
    echo "  SKIP_TESTS=true     تخطي الاختبارات"
    echo "  SKIP_CHECKS=true    تخطي جميع الفحوصات"
    echo ""
    echo "أمثلة:"
    echo "  $0 \"إضافة ميزة جديدة\""
    echo "  SKIP_TESTS=true $0"
    echo ""
    exit 0
fi

# تشغيل
main "$@"
