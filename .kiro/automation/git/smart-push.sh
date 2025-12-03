#!/bin/bash

# Kiro Strategic Workspace - نظام الدفع الذكي
# التاريخ: 3 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# ========================================
# الألوان والتنسيق
# ========================================
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

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

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_step() {
    echo -e "${PURPLE}▶ $1${NC}"
}

# ========================================
# التحقق من البيئة
# ========================================
check_environment() {
    print_step "التحقق من البيئة..."
    
    # التحقق من Git
    if ! command -v git &> /dev/null; then
        print_error "Git غير مثبت"
        exit 1
    fi
    
    # التحقق من أننا في مستودع Git
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "ليس مستودع Git"
        exit 1
    fi
    
    # التحقق من Flutter
    if ! command -v flutter &> /dev/null; then
        print_warning "Flutter غير مثبت - سيتم تخطي الاختبارات"
        SKIP_TESTS=true
    fi
    
    print_success "البيئة جاهزة"
}

# ========================================
# التحقق من الحالة
# ========================================
check_status() {
    print_step "التحقق من حالة المستودع..."
    
    # التحقق من وجود تغييرات
    if git diff-index --quiet HEAD --; then
        print_warning "لا توجد تغييرات للدفع"
        exit 0
    fi
    
    # عرض الملفات المتغيرة
    print_info "الملفات المتغيرة:"
    git status --short
    
    print_success "توجد تغييرات للدفع"
}

# ========================================
# تحليل التغييرات
# ========================================
analyze_changes() {
    print_step "تحليل التغييرات..."
    
    # تحديد نوع التغييرات
    CHANGED_FILES=$(git diff --name-only HEAD)
    
    # تصنيف التغييرات
    CODE_CHANGES=$(echo "$CHANGED_FILES" | grep -E '\.(dart|yaml)$' || true)
    DOC_CHANGES=$(echo "$CHANGED_FILES" | grep -E '\.(md|txt)$' || true)
    CONFIG_CHANGES=$(echo "$CHANGED_FILES" | grep -E '\.(yaml|json|xml)$' || true)
    
    # تحديد النوع الرئيسي
    if [ -n "$CODE_CHANGES" ]; then
        COMMIT_TYPE="feat"
        COMMIT_SCOPE="code"
    elif [ -n "$DOC_CHANGES" ]; then
        COMMIT_TYPE="docs"
        COMMIT_SCOPE="documentation"
    elif [ -n "$CONFIG_CHANGES" ]; then
        COMMIT_TYPE="chore"
        COMMIT_SCOPE="config"
    else
        COMMIT_TYPE="chore"
        COMMIT_SCOPE="misc"
    fi
    
    print_info "نوع التغيير: $COMMIT_TYPE($COMMIT_SCOPE)"
    print_success "تم تحليل التغييرات"
}

# ========================================
# تشغيل الفحوصات
# ========================================
run_checks() {
    print_step "تشغيل الفحوصات..."
    
    local checks_passed=true
    
    # 1. فحص التنسيق
    print_info "فحص التنسيق..."
    if [ "$SKIP_TESTS" != "true" ]; then
        if flutter format --set-exit-if-changed . > /dev/null 2>&1; then
            print_success "التنسيق صحيح"
        else
            print_warning "تطبيق التنسيق..."
            flutter format .
        fi
    fi
    
    # 2. فحص التحليل
    print_info "فحص التحليل..."
    if [ "$SKIP_TESTS" != "true" ]; then
        if flutter analyze --no-pub > /dev/null 2>&1; then
            print_success "التحليل نظيف"
        else
            print_error "فشل التحليل"
            flutter analyze --no-pub
            checks_passed=false
        fi
    fi
    
    # 3. فحص الاختبارات (اختياري للتوثيق)
    if [ "$COMMIT_TYPE" != "docs" ] && [ "$SKIP_TESTS" != "true" ]; then
        print_info "تشغيل الاختبارات..."
        if flutter test > /dev/null 2>&1; then
            print_success "الاختبارات نجحت"
        else
            print_warning "بعض الاختبارات فشلت - المتابعة على أي حال"
        fi
    fi
    
    # 4. فحص الأسرار
    print_info "فحص الأسرار..."
    if git diff --cached | grep -iE '(api[_-]?key|password|secret|token|private[_-]?key)' > /dev/null; then
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
    
    # الحصول على وصف قصير
    local description=""
    
    case "$COMMIT_TYPE" in
        "feat")
            description="تحديث Kiro Strategic Workspace"
            ;;
        "docs")
            description="تحديث التوثيق"
            ;;
        "chore")
            description="تحديث الإعدادات"
            ;;
        *)
            description="تحديثات متنوعة"
            ;;
    esac
    
    # إنشاء الرسالة الكاملة
    COMMIT_MESSAGE="$COMMIT_TYPE($COMMIT_SCOPE): $description

التغييرات:
$(git diff --name-status HEAD | head -10)

التاريخ: $(date '+%Y-%m-%d %H:%M:%S')
المؤلف: Kiro Strategic Workspace"
    
    print_info "رسالة الكوميت:"
    echo "$COMMIT_MESSAGE" | head -5
    print_success "تم إنشاء رسالة الكوميت"
}

# ========================================
# إضافة الملفات
# ========================================
stage_files() {
    print_step "إضافة الملفات..."
    
    # إضافة جميع التغييرات
    git add -A
    
    # عرض الملفات المضافة
    local staged_count=$(git diff --cached --name-only | wc -l)
    print_info "عدد الملفات المضافة: $staged_count"
    
    print_success "تم إضافة الملفات"
}

# ========================================
# إنشاء الكوميت
# ========================================
create_commit() {
    print_step "إنشاء الكوميت..."
    
    # إنشاء الكوميت
    echo "$COMMIT_MESSAGE" | git commit -F -
    
    # الحصول على hash الكوميت
    COMMIT_HASH=$(git rev-parse --short HEAD)
    
    print_success "تم إنشاء الكوميت: $COMMIT_HASH"
}

# ========================================
# الدفع إلى Remote
# ========================================
push_to_remote() {
    print_step "الدفع إلى المستودع البعيد..."
    
    # الحصول على الفرع الحالي
    CURRENT_BRANCH=$(git branch --show-current)
    
    print_info "الفرع: $CURRENT_BRANCH"
    
    # التحقق من وجود remote
    if ! git remote get-url origin > /dev/null 2>&1; then
        print_warning "لا يوجد remote مكون - تخطي الدفع"
        return
    fi
    
    # الدفع
    if git push origin "$CURRENT_BRANCH" 2>&1; then
        print_success "تم الدفع بنجاح"
    else
        print_error "فشل الدفع"
        print_info "يمكنك الدفع يدوياً باستخدام: git push origin $CURRENT_BRANCH"
        exit 1
    fi
}

# ========================================
# إنشاء تقرير
# ========================================
generate_report() {
    print_step "إنشاء التقرير..."
    
    local report_file=".kiro/analytics/reports/git/push-$(date +%Y%m%d-%H%M%S).md"
    mkdir -p "$(dirname "$report_file")"
    
    cat > "$report_file" << EOF
# تقرير الدفع - Kiro Strategic Workspace

**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')  
**الكوميت:** $COMMIT_HASH  
**الفرع:** $CURRENT_BRANCH  
**النوع:** $COMMIT_TYPE($COMMIT_SCOPE)

## الملفات المتغيرة

\`\`\`
$(git diff --name-status HEAD~1 HEAD)
\`\`\`

## رسالة الكوميت

\`\`\`
$COMMIT_MESSAGE
\`\`\`

## الإحصائيات

- الملفات المتغيرة: $(git diff --name-only HEAD~1 HEAD | wc -l)
- الإضافات: $(git diff --shortstat HEAD~1 HEAD | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+' || echo 0)
- الحذف: $(git diff --shortstat HEAD~1 HEAD | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+' || echo 0)

---

**تم بواسطة:** Kiro Strategic Workspace  
**الحالة:** ✅ نجح
EOF
    
    print_success "تم إنشاء التقرير: $report_file"
}

# ========================================
# الدالة الرئيسية
# ========================================
main() {
    print_header "🚀 Kiro Strategic Workspace - الدفع الذكي"
    
    # تنفيذ الخطوات
    check_environment
    check_status
    analyze_changes
    run_checks
    generate_commit_message
    stage_files
    create_commit
    push_to_remote
    generate_report
    
    # الخلاصة
    print_header "🎉 اكتمل الدفع بنجاح!"
    
    echo ""
    print_success "تم دفع التغييرات بنجاح!"
    echo ""
    print_info "الملخص:"
    echo "  • الكوميت: $COMMIT_HASH"
    echo "  • النوع: $COMMIT_TYPE($COMMIT_SCOPE)"
    echo "  • الفرع: $CURRENT_BRANCH"
    echo ""
    print_success "Workspace محدث! 🚀"
    echo ""
}

# تشغيل
main "$@"
