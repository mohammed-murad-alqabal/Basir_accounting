#!/bin/bash

# سكريبت إعداد نظام فحص التوافق الكامل
# Complete setup script for steering compatibility system

set -e

# الألوان للمخرجات
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# دالة طباعة الرسائل الملونة
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "${BLUE}$1${NC}"
    echo "================================================"
}

# دالة التحقق من المتطلبات
check_requirements() {
    print_info "التحقق من المتطلبات..."
    
    # التحقق من Python
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 غير مثبت. يرجى تثبيته أولاً."
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1-2)
    print_success "Python $PYTHON_VERSION متوفر"
    
    # التحقق من Git
    if ! command -v git &> /dev/null; then
        print_error "Git غير مثبت. يرجى تثبيته أولاً."
        exit 1
    fi
    
    print_success "Git متوفر"
    
    # التحقق من وجود Git repository
    if [[ ! -d ".git" ]]; then
        print_error "هذا المجلد ليس Git repository"
        exit 1
    fi
    
    print_success "Git repository موجود"
}

# دالة إعداد الأذونات
setup_permissions() {
    print_info "إعداد أذونات الملفات..."
    
    # جعل السكريبتات قابلة للتنفيذ
    chmod +x scripts/*.sh 2>/dev/null || true
    chmod +x scripts/hooks/* 2>/dev/null || true
    
    print_success "تم إعداد الأذونات"
}

# دالة إنشاء المجلدات المطلوبة
create_directories() {
    print_info "إنشاء المجلدات المطلوبة..."
    
    # مجلد التقارير
    mkdir -p reports/compatibility
    
    # مجلد النسخ الاحتياطية
    mkdir -p backups/steering
    
    print_success "تم إنشاء المجلدات"
}

# دالة اختبار النظام
test_system() {
    print_info "اختبار النظام..."
    
    if [[ -f "scripts/test_steering_compatibility.sh" ]]; then
        if bash scripts/test_steering_compatibility.sh; then
            print_success "جميع الاختبارات نجحت"
        else
            print_error "فشلت بعض الاختبارات"
            return 1
        fi
    else
        print_warning "سكريبت الاختبار غير موجود"
    fi
}

# دالة تثبيت Git hooks
install_hooks() {
    print_info "تثبيت Git hooks..."
    
    if [[ -f "scripts/install_steering_hooks.sh" ]]; then
        if bash scripts/install_steering_hooks.sh; then
            print_success "تم تثبيت Git hooks"
        else
            print_error "فشل تثبيت Git hooks"
            return 1
        fi
    else
        print_error "سكريبت تثبيت hooks غير موجود"
        return 1
    fi
}

# دالة إنشاء ملف تكوين المشروع
create_project_config() {
    print_info "إنشاء ملف تكوين المشروع..."
    
    cat > .steering-compatibility.conf << EOF
# تكوين نظام فحص التوافق لمشروع بصير
# Steering Compatibility System Configuration for Basir Project

# معلومات المشروع
PROJECT_NAME="بصير MVP"
PROJECT_STACK="Flutter/Dart"
FLUTTER_VERSION="3.35.5+"
DART_VERSION="3.9.2+"

# إعدادات الفحص
DEFAULT_SEVERITY="medium"
FAIL_ON_ISSUES=true
OUTPUT_FORMAT="both"

# مسارات الملفات
STEERING_DIR=".kiro/steering"
REPORTS_DIR="reports/compatibility"
BACKUP_DIR="backups/steering"

# إعدادات Git hooks
ENABLE_PRE_COMMIT=true
ENABLE_POST_COMMIT=true
PERIODIC_CHECK_INTERVAL=10

# إعدادات CI/CD
ENABLE_GITHUB_ACTIONS=true
CI_SEVERITY_THRESHOLD="medium"
SCHEDULE_CRON="0 2 * * *"

# تاريخ الإعداد
SETUP_DATE="$(date +%Y-%m-%d\ %H:%M:%S)"
SETUP_VERSION="1.0.0"
EOF

    print_success "تم إنشاء ملف التكوين: .steering-compatibility.conf"
}

# دالة عرض معلومات الاستخدام
show_usage_info() {
    echo ""
    print_header "معلومات الاستخدام"
    
    echo "🔍 الفحص اليدوي:"
    echo "  ./scripts/check_steering_compatibility.sh"
    echo ""
    
    echo "📁 فحص ملف واحد:"
    echo "  ./scripts/check_steering_compatibility.sh --file path/to/file.md"
    echo ""
    
    echo "⚙️ فحص للـ CI/CD:"
    echo "  ./scripts/check_steering_compatibility.sh --ci --severity high"
    echo ""
    
    echo "🧪 اختبار النظام:"
    echo "  ./scripts/test_steering_compatibility.sh"
    echo ""
    
    echo "📚 التوثيق الكامل:"
    echo "  cat scripts/README_STEERING_COMPATIBILITY.md"
    echo ""
}

# دالة عرض حالة النظام
show_system_status() {
    echo ""
    print_header "حالة النظام"
    
    # فحص الملفات الأساسية
    local files=(
        "scripts/steering_compatibility_checker.py"
        "scripts/check_steering_compatibility.sh"
        "scripts/incompatible_technologies.json"
        "scripts/steering_rules.yml"
        "scripts/hooks/pre-commit-steering-check"
        ".github/workflows/steering_compatibility_check.yml"
    )
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            echo "  ✅ $file"
        else
            echo "  ❌ $file"
        fi
    done
    
    # فحص Git hooks
    echo ""
    echo "Git Hooks:"
    if [[ -f ".git/hooks/pre-commit" ]]; then
        echo "  ✅ pre-commit hook مثبت"
    else
        echo "  ❌ pre-commit hook غير مثبت"
    fi
    
    if [[ -f ".git/hooks/post-commit" ]]; then
        echo "  ✅ post-commit hook مثبت"
    else
        echo "  ❌ post-commit hook غير مثبت"
    fi
    
    # فحص المجلدات
    echo ""
    echo "المجلدات:"
    if [[ -d "reports/compatibility" ]]; then
        echo "  ✅ مجلد التقارير موجود"
    else
        echo "  ❌ مجلد التقارير غير موجود"
    fi
    
    if [[ -d "backups/steering" ]]; then
        echo "  ✅ مجلد النسخ الاحتياطية موجود"
    else
        echo "  ❌ مجلد النسخ الاحتياطية غير موجود"
    fi
}

# الدالة الرئيسية
main() {
    print_header "إعداد نظام فحص التوافق التلقائي"
    echo "نظام شامل لفحص ملفات التوجيه ومنع إضافة مراجع غير متوافقة"
    echo ""
    
    # التحقق من المعاملات
    SKIP_TESTS=false
    SKIP_HOOKS=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-tests)
                SKIP_TESTS=true
                shift
                ;;
            --skip-hooks)
                SKIP_HOOKS=true
                shift
                ;;
            --help)
                echo "الاستخدام: $0 [--skip-tests] [--skip-hooks] [--help]"
                echo ""
                echo "الخيارات:"
                echo "  --skip-tests   تجاهل تشغيل الاختبارات"
                echo "  --skip-hooks   تجاهل تثبيت Git hooks"
                echo "  --help         عرض هذه المساعدة"
                exit 0
                ;;
            *)
                print_error "معامل غير معروف: $1"
                exit 1
                ;;
        esac
    done
    
    # تنفيذ خطوات الإعداد
    check_requirements
    setup_permissions
    create_directories
    create_project_config
    
    # اختبار النظام (اختياري)
    if [[ "$SKIP_TESTS" == false ]]; then
        test_system
    else
        print_warning "تم تجاهل الاختبارات"
    fi
    
    # تثبيت Git hooks (اختياري)
    if [[ "$SKIP_HOOKS" == false ]]; then
        install_hooks
    else
        print_warning "تم تجاهل تثبيت Git hooks"
    fi
    
    # عرض النتائج
    echo ""
    print_header "اكتمل الإعداد بنجاح!"
    
    show_system_status
    show_usage_info
    
    echo ""
    print_success "نظام فحص التوافق التلقائي جاهز للاستخدام!"
    echo ""
    print_info "للبدء، جرب: ./scripts/check_steering_compatibility.sh"
}

# تشغيل الإعداد
main "$@"