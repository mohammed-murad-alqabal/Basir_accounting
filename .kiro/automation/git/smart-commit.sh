#!/bin/bash

# Kiro Strategic Workspace - نظام الكوميت الذكي
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
CYAN='\033[0;36m'
NC='\033[0m'

# ========================================
# المعاملات
# ========================================
COMMIT_TYPE="${1:-auto}"
COMMIT_SCOPE="${2:-auto}"
COMMIT_MESSAGE="${3:-}"

# ========================================
# دوال المساعدة
# ========================================
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${CYAN}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

# ========================================
# تحليل التغييرات التلقائي
# ========================================
auto_analyze() {
    print_info "تحليل التغييرات تلقائياً..."
    
    local changed_files=$(git diff --name-only HEAD)
    
    # تحديد النوع بناءً على الملفات
    if echo "$changed_files" | grep -q "\.dart$"; then
        if echo "$changed_files" | grep -q "test/"; then
            TYPE="test"
            SCOPE="testing"
        else
            TYPE="feat"
            SCOPE="code"
        fi
    elif echo "$changed_files" | grep -q "\.md$"; then
        TYPE="docs"
        SCOPE="documentation"
    elif echo "$changed_files" | grep -q "\.yaml$\|\.json$"; then
        TYPE="chore"
        SCOPE="config"
    elif echo "$changed_files" | grep -q "\.kiro/"; then
        TYPE="chore"
        SCOPE="workspace"
    else
        TYPE="chore"
        SCOPE="misc"
    fi
    
    # تحديد الوصف
    if [ -z "$COMMIT_MESSAGE" ]; then
        case "$TYPE" in
            "feat")
                DESC="تحديث الميزات"
                ;;
            "test")
                DESC="تحديث الاختبارات"
                ;;
            "docs")
                DESC="تحديث التوثيق"
                ;;
            "chore")
                if [ "$SCOPE" = "workspace" ]; then
                    DESC="تحديث Kiro Strategic Workspace"
                else
                    DESC="تحديث الإعدادات"
                fi
                ;;
            *)
                DESC="تحديثات متنوعة"
                ;;
        esac
    else
        DESC="$COMMIT_MESSAGE"
    fi
    
    print_success "النوع: $TYPE | النطاق: $SCOPE"
}

# ========================================
# إنشاء رسالة الكوميت
# ========================================
create_message() {
    print_info "إنشاء رسالة الكوميت..."
    
    # تحديد النوع والنطاق
    if [ "$COMMIT_TYPE" = "auto" ]; then
        auto_analyze
    else
        TYPE="$COMMIT_TYPE"
        SCOPE="$COMMIT_SCOPE"
        DESC="${COMMIT_MESSAGE:-تحديثات}"
    fi
    
    # إنشاء الرسالة
    MESSAGE="$TYPE($SCOPE): $DESC

التغييرات:
$(git diff --name-status HEAD | head -10)

$(date '+%Y-%m-%d %H:%M:%S') - Kiro Strategic Workspace"
    
    echo "$MESSAGE"
}

# ========================================
# الدالة الرئيسية
# ========================================
main() {
    echo ""
    echo -e "${BLUE}🤖 Kiro Strategic Workspace - الكوميت الذكي${NC}"
    echo ""
    
    # التحقق من وجود تغييرات
    if git diff-index --quiet HEAD --; then
        print_warning "لا توجد تغييرات"
        exit 0
    fi
    
    # إضافة الملفات
    print_info "إضافة الملفات..."
    git add -A
    print_success "تم إضافة $(git diff --cached --name-only | wc -l) ملف"
    
    # إنشاء الرسالة
    local message=$(create_message)
    
    # عرض الرسالة
    echo ""
    print_info "رسالة الكوميت:"
    echo -e "${CYAN}$message${NC}" | head -5
    echo ""
    
    # إنشاء الكوميت
    echo "$message" | git commit -F -
    
    local commit_hash=$(git rev-parse --short HEAD)
    print_success "تم الكوميت: $commit_hash"
    
    echo ""
}

# تشغيل
main "$@"
