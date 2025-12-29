#!/bin/bash

# =============================================================================
# سكريبت التثبيت - نظام تتبع الأخطاء والسجلات
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# الوكيل المسؤول: وكيل التطوير (Development Agent)
# =============================================================================
# الوصف: تثبيت نظام تتبع الأخطاء والسجلات بشكل تلقائي
# الاستخدام: bash scripts/install.sh [--force] [--skip-hooks] [--skip-config]
# =============================================================================

set -e

# تحميل مكتبة معالجة الأخطاء
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/error_handler.sh" ]; then
    source "$SCRIPT_DIR/utils/error_handler.sh"
else
    # دوال بديلة إذا لم تكن المكتبة موجودة
    print_info() { echo "[INFO] $1"; }
    print_success() { echo "[SUCCESS] $1"; }
    print_error() { echo "[ERROR] $1" >&2; }
    print_warning() { echo "[WARNING] $1"; }
fi

# =============================================================================
# الثوابت
# =============================================================================

readonly VERSION="1.0.0"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly GIT_HOOKS_DIR="$PROJECT_ROOT/.git/hooks"
readonly CONFIG_DIR="$PROJECT_ROOT/.kiro/config"
readonly LOGS_DIR="$PROJECT_ROOT/logs"
readonly SCRIPTS_DIR="$PROJECT_ROOT/scripts"

# الخيارات
FORCE_INSTALL=false
SKIP_HOOKS=false
SKIP_CONFIG=false
VERBOSE=false

# =============================================================================
# دوال المساعدة
# =============================================================================

# عرض رسالة الاستخدام
show_usage() {
    cat << EOF

═══════════════════════════════════════════════════════════
  سكريبت تثبيت نظام تتبع الأخطاء والسجلات
═══════════════════════════════════════════════════════════

الاستخدام:
  bash scripts/install.sh [OPTIONS]

الخيارات:
  --force         إعادة التثبيت حتى لو كان النظام مثبتاً
  --skip-hooks    تخطي تثبيت Git Hooks
  --skip-config   تخطي إنشاء ملفات التكوين
  --verbose       عرض تفاصيل إضافية
  -h, --help      عرض هذه الرسالة

أمثلة:
  # تثبيت عادي
  bash scripts/install.sh

  # إعادة تثبيت
  bash scripts/install.sh --force

  # تثبيت بدون hooks
  bash scripts/install.sh --skip-hooks

الإصدار: $VERSION

EOF
}

# التحقق من المتطلبات
check_requirements() {
    print_info "التحقق من المتطلبات..."
    
    local missing_requirements=()
    
    # التحقق من Git
    if ! command -v git &> /dev/null; then
        missing_requirements+=("git")
    fi
    
    # التحقق من Flutter (اختياري)
    if ! command -v flutter &> /dev/null; then
        print_warning "Flutter غير مثبت - بعض الميزات قد لا تعمل"
    fi
    
    # التحقق من tar و gzip
    if ! command -v tar &> /dev/null; then
        missing_requirements+=("tar")
    fi
    
    if ! command -v gzip &> /dev/null; then
        missing_requirements+=("gzip")
    fi
    
    # إذا كانت هناك متطلبات مفقودة
    if [ ${#missing_requirements[@]} -gt 0 ]; then
        print_error "المتطلبات التالية مفقودة:"
        for req in "${missing_requirements[@]}"; do
            echo "  - $req"
        done
        return 1
    fi
    
    print_success "✓ جميع المتطلبات متوفرة"
    return 0
}

# التحقق من أن المجلد الحالي هو مستودع Git
check_git_repository() {
    print_info "التحقق من مستودع Git..."
    
    if [ ! -d "$PROJECT_ROOT/.git" ]; then
        print_error "هذا المجلد ليس مستودع Git"
        print_info "يرجى تشغيل: git init"
        return 1
    fi
    
    print_success "✓ مستودع Git موجود"
    return 0
}

# التحقق من التثبيت السابق
check_existing_installation() {
    print_info "التحقق من التثبيت السابق..."
    
    local is_installed=false
    
    # التحقق من وجود hooks
    if [ -f "$GIT_HOOKS_DIR/pre-commit" ] && grep -q "Error Tracking System" "$GIT_HOOKS_DIR/pre-commit" 2>/dev/null; then
        is_installed=true
    fi
    
    if [ "$is_installed" = true ]; then
        if [ "$FORCE_INSTALL" = false ]; then
            print_warning "النظام مثبت مسبقاً"
            print_info "استخدم --force لإعادة التثبيت"
            return 1
        else
            print_warning "سيتم إعادة التثبيت (--force)"
        fi
    fi
    
    return 0
}

# إنشاء المجلدات المطلوبة
create_directories() {
    print_info "إنشاء المجلدات المطلوبة..."
    
    local directories=(
        "$LOGS_DIR"
        "$LOGS_DIR/archive"
        "$LOGS_DIR/reports"
        "$LOGS_DIR/cache"
        "$CONFIG_DIR"
    )
    
    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            [ "$VERBOSE" = true ] && print_info "  ✓ تم إنشاء: $dir"
        else
            [ "$VERBOSE" = true ] && print_info "  ✓ موجود: $dir"
        fi
    done
    
    print_success "✓ تم إنشاء جميع المجلدات"
    return 0
}

# نسخ Git Hooks
install_git_hooks() {
    if [ "$SKIP_HOOKS" = true ]; then
        print_info "تم تخطي تثبيت Git Hooks (--skip-hooks)"
        return 0
    fi
    
    print_info "تثبيت Git Hooks..."
    
    # التأكد من وجود مجلد hooks
    mkdir -p "$GIT_HOOKS_DIR"
    
    # قائمة الـ hooks المطلوبة
    local hooks=(
        "pre-commit"
        "pre-push"
    )
    
    for hook in "${hooks[@]}"; do
        local source_file="$SCRIPTS_DIR/hooks/$hook"
        local target_file="$GIT_HOOKS_DIR/$hook"
        
        # التحقق من وجود الملف المصدر
        if [ ! -f "$source_file" ]; then
            print_warning "  ⚠ الملف غير موجود: $source_file"
            continue
        fi
        
        # نسخ الملف
        cp "$source_file" "$target_file"
        chmod +x "$target_file"
        
        [ "$VERBOSE" = true ] && print_info "  ✓ تم تثبيت: $hook"
    done
    
    print_success "✓ تم تثبيت Git Hooks"
    return 0
}

# إنشاء ملف التكوين الافتراضي
create_default_config() {
    if [ "$SKIP_CONFIG" = true ]; then
        print_info "تم تخطي إنشاء ملفات التكوين (--skip-config)"
        return 0
    fi
    
    print_info "إنشاء ملف التكوين..."
    
    local config_file="$CONFIG_DIR/error_tracking.yml"
    
    # إذا كان الملف موجوداً ولم يتم استخدام --force
    if [ -f "$config_file" ] && [ "$FORCE_INSTALL" = false ]; then
        print_info "  ✓ ملف التكوين موجود مسبقاً"
        return 0
    fi
    
    # إنشاء ملف التكوين
    cat > "$config_file" << 'EOF'
# =============================================================================
# ملف التكوين - نظام تتبع الأخطاء والسجلات
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# =============================================================================

# إعدادات Git Hooks
hooks:
  pre_commit:
    enabled: true
    timeout: 30  # بالثواني
    format_check: true
    analyze_check: true
    commit_message_check: true
  
  pre_push:
    enabled: true
    timeout: 120  # بالثواني
    run_tests: true
    secret_check: true

# إعدادات جمع السجلات
logs:
  enabled: true
  max_size: 10485760  # 10 MB
  retention_days: 7
  sanitize: true
  deduplicate: true

# إعدادات الأرشفة
archive:
  enabled: true
  age_threshold: 7  # أيام
  size_threshold: 5242880  # 5 MB
  compression: true
  backup: true

# إعدادات التقارير
reports:
  enabled: true
  format: markdown  # markdown, json, both
  include_statistics: true
  include_errors: true
  include_tests: true
  include_recommendations: true

# إعدادات الأمان
security:
  secret_detection: true
  sanitize_logs: true
  patterns:
    - api_key
    - password
    - token
    - secret
    - private_key

# إعدادات الأداء
performance:
  caching: true
  cache_ttl: 3600  # ثانية
  parallel_execution: false

# إعدادات GitHub Actions
github_actions:
  enabled: true
  create_issues: true
  comment_on_prs: true
  upload_artifacts: true
EOF
    
    print_success "✓ تم إنشاء ملف التكوين"
    return 0
}

# جعل السكريبتات قابلة للتنفيذ
make_scripts_executable() {
    print_info "جعل السكريبتات قابلة للتنفيذ..."
    
    # السكريبتات الرئيسية
    local main_scripts=(
        "$SCRIPTS_DIR/collect_logs.sh"
        "$SCRIPTS_DIR/archive_logs.sh"
        "$SCRIPTS_DIR/generate_report.sh"
    )
    
    # سكريبتات المساعدة
    local util_scripts=(
        "$SCRIPTS_DIR/utils/sanitize.sh"
        "$SCRIPTS_DIR/utils/validate.sh"
        "$SCRIPTS_DIR/utils/compress.sh"
        "$SCRIPTS_DIR/utils/error_handler.sh"
        "$SCRIPTS_DIR/utils/cache_manager.sh"
    )
    
    # سكريبتات الاختبار
    local test_scripts=(
        "$PROJECT_ROOT/test/integration/run_integration_tests.sh"
        "$PROJECT_ROOT/test/integration/test_full_workflow.sh"
        "$PROJECT_ROOT/test/integration/test_error_scenarios.sh"
        "$PROJECT_ROOT/test/security/run_security_tests.sh"
    )
    
    local all_scripts=("${main_scripts[@]}" "${util_scripts[@]}" "${test_scripts[@]}")
    
    for script in "${all_scripts[@]}"; do
        if [ -f "$script" ]; then
            chmod +x "$script"
            [ "$VERBOSE" = true ] && print_info "  ✓ $script"
        fi
    done
    
    print_success "✓ تم جعل جميع السكريبتات قابلة للتنفيذ"
    return 0
}

# اختبار التثبيت
test_installation() {
    print_info "اختبار التثبيت..."
    
    local tests_passed=0
    local tests_failed=0
    
    # اختبار 1: وجود المجلدات
    if [ -d "$LOGS_DIR" ] && [ -d "$LOGS_DIR/archive" ] && [ -d "$LOGS_DIR/reports" ]; then
        ((tests_passed++))
        [ "$VERBOSE" = true ] && print_info "  ✓ المجلدات موجودة"
    else
        ((tests_failed++))
        print_warning "  ✗ بعض المجلدات مفقودة"
    fi
    
    # اختبار 2: وجود Git Hooks
    if [ "$SKIP_HOOKS" = false ]; then
        if [ -x "$GIT_HOOKS_DIR/pre-commit" ] && [ -x "$GIT_HOOKS_DIR/pre-push" ]; then
            ((tests_passed++))
            [ "$VERBOSE" = true ] && print_info "  ✓ Git Hooks مثبتة"
        else
            ((tests_failed++))
            print_warning "  ✗ Git Hooks غير مثبتة بشكل صحيح"
        fi
    fi
    
    # اختبار 3: وجود ملف التكوين
    if [ "$SKIP_CONFIG" = false ]; then
        if [ -f "$CONFIG_DIR/error_tracking.yml" ]; then
            ((tests_passed++))
            [ "$VERBOSE" = true ] && print_info "  ✓ ملف التكوين موجود"
        else
            ((tests_failed++))
            print_warning "  ✗ ملف التكوين مفقود"
        fi
    fi
    
    # اختبار 4: السكريبتات قابلة للتنفيذ
    if [ -x "$SCRIPTS_DIR/collect_logs.sh" ]; then
        ((tests_passed++))
        [ "$VERBOSE" = true ] && print_info "  ✓ السكريبتات قابلة للتنفيذ"
    else
        ((tests_failed++))
        print_warning "  ✗ بعض السكريبتات غير قابلة للتنفيذ"
    fi
    
    # النتيجة
    if [ $tests_failed -eq 0 ]; then
        print_success "✓ جميع الاختبارات نجحت ($tests_passed/$((tests_passed + tests_failed)))"
        return 0
    else
        print_warning "⚠ بعض الاختبارات فشلت ($tests_passed/$((tests_passed + tests_failed)))"
        return 1
    fi
}

# عرض معلومات ما بعد التثبيت
show_post_install_info() {
    cat << EOF

═══════════════════════════════════════════════════════════
  ✅ تم التثبيت بنجاح!
═══════════════════════════════════════════════════════════

📋 ما تم تثبيته:
  ✓ Git Hooks (pre-commit, pre-push)
  ✓ المجلدات المطلوبة (logs, archive, reports)
  ✓ ملف التكوين (.kiro/config/error_tracking.yml)
  ✓ السكريبتات قابلة للتنفيذ

📚 الخطوات التالية:

  1. راجع ملف التكوين:
     nano .kiro/config/error_tracking.yml

  2. اختبر النظام:
     bash scripts/collect_logs.sh
     bash scripts/generate_report.sh

  3. اختبر Git Hooks:
     git add .
     git commit -m "test: اختبار النظام"

  4. راجع التوثيق:
     cat docs/ERROR_TRACKING_GUIDE.md

📖 الأوامر المفيدة:

  # جمع السجلات
  bash scripts/collect_logs.sh

  # أرشفة السجلات القديمة
  bash scripts/archive_logs.sh

  # إنشاء تقرير
  bash scripts/generate_report.sh

  # اختبار التكامل
  bash test/integration/run_integration_tests.sh

  # اختبار الأمان
  bash test/security/run_security_tests.sh

  # إلغاء التثبيت
  bash scripts/uninstall.sh

⚙️ التكوين:
  ملف التكوين: .kiro/config/error_tracking.yml
  السجلات: logs/
  الأرشيف: logs/archive/
  التقارير: logs/reports/

📞 الدعم:
  التوثيق: docs/ERROR_TRACKING_GUIDE.md
  المشاكل: افتح issue في GitHub

═══════════════════════════════════════════════════════════

EOF
}

# =============================================================================
# البرنامج الرئيسي
# =============================================================================

main() {
    # معالجة الخيارات
    while [[ $# -gt 0 ]]; do
        case $1 in
            --force)
                FORCE_INSTALL=true
                shift
                ;;
            --skip-hooks)
                SKIP_HOOKS=true
                shift
                ;;
            --skip-config)
                SKIP_CONFIG=true
                shift
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                print_error "خيار غير معروف: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # عرض رأس البرنامج
    cat << EOF

═══════════════════════════════════════════════════════════
  تثبيت نظام تتبع الأخطاء والسجلات
═══════════════════════════════════════════════════════════

المشروع: بصير MVP
الإصدار: $VERSION
التاريخ: $(date '+%Y-%m-%d %H:%M:%S')

EOF
    
    # تنفيذ خطوات التثبيت
    check_requirements || exit 1
    check_git_repository || exit 1
    check_existing_installation || exit 1
    
    echo ""
    print_info "بدء التثبيت..."
    echo ""
    
    create_directories || exit 1
    install_git_hooks || exit 1
    create_default_config || exit 1
    make_scripts_executable || exit 1
    
    echo ""
    test_installation
    
    echo ""
    show_post_install_info
    
    return 0
}

# تشغيل البرنامج الرئيسي
main "$@"
