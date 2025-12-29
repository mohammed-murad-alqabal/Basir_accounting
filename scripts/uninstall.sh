#!/bin/bash

# =============================================================================
# سكريبت إلغاء التثبيت - نظام تتبع الأخطاء والسجلات
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# الوكيل المسؤول: وكيل التطوير (Development Agent)
# =============================================================================
# الوصف: إلغاء تثبيت نظام تتبع الأخطاء والسجلات بشكل آمن
# الاستخدام: bash scripts/uninstall.sh [--keep-logs] [--keep-config] [--force]
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
readonly BACKUP_DIR="$PROJECT_ROOT/logs/backup_$(date +%Y%m%d_%H%M%S)"

# الخيارات
KEEP_LOGS=false
KEEP_CONFIG=false
FORCE_UNINSTALL=false
VERBOSE=false

# =============================================================================
# دوال المساعدة
# =============================================================================

# عرض رسالة الاستخدام
show_usage() {
    cat << EOF

═══════════════════════════════════════════════════════════
  سكريبت إلغاء تثبيت نظام تتبع الأخطاء والسجلات
═══════════════════════════════════════════════════════════

الاستخدام:
  bash scripts/uninstall.sh [OPTIONS]

الخيارات:
  --keep-logs     الحفاظ على السجلات (لا حذف)
  --keep-config   الحفاظ على ملفات التكوين
  --force         إلغاء التثبيت بدون تأكيد
  --verbose       عرض تفاصيل إضافية
  -h, --help      عرض هذه الرسالة

أمثلة:
  # إلغاء تثبيت عادي (مع تأكيد)
  bash scripts/uninstall.sh

  # إلغاء تثبيت مع الحفاظ على السجلات
  bash scripts/uninstall.sh --keep-logs

  # إلغاء تثبيت بدون تأكيد
  bash scripts/uninstall.sh --force

  # إلغاء تثبيت مع الحفاظ على كل شيء
  bash scripts/uninstall.sh --keep-logs --keep-config

الإصدار: $VERSION

⚠️  تحذير: هذا السكريبت سيقوم بإزالة:
  • Git Hooks (pre-commit, pre-push)
  • السجلات (logs/) - إلا إذا استخدمت --keep-logs
  • ملفات التكوين - إلا إذا استخدمت --keep-config
  • الملفات المؤقتة

EOF
}

# طلب التأكيد من المستخدم
confirm_uninstall() {
    if [ "$FORCE_UNINSTALL" = true ]; then
        return 0
    fi
    
    print_warning "⚠️  تحذير: سيتم إلغاء تثبيت نظام تتبع الأخطاء والسجلات"
    echo ""
    echo "سيتم إزالة:"
    echo "  • Git Hooks (pre-commit, pre-push)"
    
    if [ "$KEEP_LOGS" = false ]; then
        echo "  • السجلات (logs/)"
    else
        echo "  • السجلات: سيتم الحفاظ عليها (--keep-logs)"
    fi
    
    if [ "$KEEP_CONFIG" = false ]; then
        echo "  • ملفات التكوين (.kiro/config/error_tracking.yml)"
    else
        echo "  • ملفات التكوين: سيتم الحفاظ عليها (--keep-config)"
    fi
    
    echo ""
    read -p "هل أنت متأكد من المتابعة؟ (yes/no): " -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]] && [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "تم إلغاء العملية"
        exit 0
    fi
    
    return 0
}

# التحقق من وجود التثبيت
check_installation() {
    print_info "التحقق من وجود التثبيت..."
    
    local is_installed=false
    
    # التحقق من وجود hooks
    if [ -f "$GIT_HOOKS_DIR/pre-commit" ] && grep -q "Error Tracking System" "$GIT_HOOKS_DIR/pre-commit" 2>/dev/null; then
        is_installed=true
    fi
    
    if [ "$is_installed" = false ]; then
        print_warning "النظام غير مثبت أو تم إلغاء تثبيته مسبقاً"
        return 1
    fi
    
    print_success "✓ تم العثور على التثبيت"
    return 0
}

# أرشفة السجلات الحالية
backup_logs() {
    if [ "$KEEP_LOGS" = true ]; then
        print_info "تم تخطي أرشفة السجلات (--keep-logs)"
        return 0
    fi
    
    print_info "أرشفة السجلات الحالية..."
    
    # التحقق من وجود سجلات
    if [ ! -d "$LOGS_DIR" ] || [ -z "$(ls -A "$LOGS_DIR" 2>/dev/null)" ]; then
        print_info "  ✓ لا توجد سجلات للأرشفة"
        return 0
    fi
    
    # إنشاء مجلد النسخ الاحتياطي
    mkdir -p "$BACKUP_DIR"
    
    # نسخ السجلات
    if cp -r "$LOGS_DIR"/* "$BACKUP_DIR/" 2>/dev/null; then
        # ضغط النسخة الاحتياطية
        local backup_archive="$PROJECT_ROOT/logs_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
        if tar -czf "$backup_archive" -C "$PROJECT_ROOT" "$(basename "$BACKUP_DIR")" 2>/dev/null; then
            print_success "  ✓ تم إنشاء نسخة احتياطية: $backup_archive"
            rm -rf "$BACKUP_DIR"
        else
            print_warning "  ⚠ فشل ضغط النسخة الاحتياطية"
        fi
    else
        print_warning "  ⚠ فشل نسخ السجلات"
    fi
    
    return 0
}

# إزالة Git Hooks
remove_git_hooks() {
    print_info "إزالة Git Hooks..."
    
    local hooks=(
        "pre-commit"
        "pre-push"
    )
    
    local removed_count=0
    
    for hook in "${hooks[@]}"; do
        local hook_file="$GIT_HOOKS_DIR/$hook"
        
        if [ -f "$hook_file" ]; then
            # التحقق من أن الـ hook خاص بنظامنا
            if grep -q "Error Tracking System" "$hook_file" 2>/dev/null; then
                rm -f "$hook_file"
                ((removed_count++))
                [ "$VERBOSE" = true ] && print_info "  ✓ تم إزالة: $hook"
            else
                [ "$VERBOSE" = true ] && print_warning "  ⚠ تم تخطي: $hook (ليس من نظامنا)"
            fi
        fi
    done
    
    if [ $removed_count -gt 0 ]; then
        print_success "✓ تم إزالة $removed_count hook(s)"
    else
        print_info "  ✓ لا توجد hooks للإزالة"
    fi
    
    return 0
}

# إزالة السجلات
remove_logs() {
    if [ "$KEEP_LOGS" = true ]; then
        print_info "تم تخطي إزالة السجلات (--keep-logs)"
        return 0
    fi
    
    print_info "إزالة السجلات..."
    
    if [ -d "$LOGS_DIR" ]; then
        # حذف محتويات المجلد فقط، وليس المجلد نفسه
        rm -rf "$LOGS_DIR"/*
        print_success "✓ تم إزالة السجلات"
    else
        print_info "  ✓ لا توجد سجلات للإزالة"
    fi
    
    return 0
}

# إزالة ملفات التكوين
remove_config() {
    if [ "$KEEP_CONFIG" = true ]; then
        print_info "تم تخطي إزالة ملفات التكوين (--keep-config)"
        return 0
    fi
    
    print_info "إزالة ملفات التكوين..."
    
    local config_file="$CONFIG_DIR/error_tracking.yml"
    
    if [ -f "$config_file" ]; then
        rm -f "$config_file"
        print_success "✓ تم إزالة ملف التكوين"
    else
        print_info "  ✓ لا يوجد ملف تكوين للإزالة"
    fi
    
    return 0
}

# تنظيف الملفات المؤقتة
cleanup_temp_files() {
    print_info "تنظيف الملفات المؤقتة..."
    
    local temp_patterns=(
        "$LOGS_DIR/cache/*"
        "$LOGS_DIR/*.tmp"
        "$LOGS_DIR/.*.swp"
    )
    
    local cleaned_count=0
    
    for pattern in "${temp_patterns[@]}"; do
        if ls $pattern 2>/dev/null | grep -q .; then
            rm -f $pattern 2>/dev/null
            ((cleaned_count++))
        fi
    done
    
    if [ $cleaned_count -gt 0 ]; then
        print_success "✓ تم تنظيف الملفات المؤقتة"
    else
        print_info "  ✓ لا توجد ملفات مؤقتة للتنظيف"
    fi
    
    return 0
}

# التحقق من إلغاء التثبيت
verify_uninstall() {
    print_info "التحقق من إلغاء التثبيت..."
    
    local issues=0
    
    # التحقق من إزالة hooks
    if [ -f "$GIT_HOOKS_DIR/pre-commit" ] && grep -q "Error Tracking System" "$GIT_HOOKS_DIR/pre-commit" 2>/dev/null; then
        print_warning "  ⚠ pre-commit hook لا يزال موجوداً"
        ((issues++))
    fi
    
    if [ -f "$GIT_HOOKS_DIR/pre-push" ] && grep -q "Error Tracking System" "$GIT_HOOKS_DIR/pre-push" 2>/dev/null; then
        print_warning "  ⚠ pre-push hook لا يزال موجوداً"
        ((issues++))
    fi
    
    # التحقق من إزالة السجلات (إذا لم يتم الحفاظ عليها)
    if [ "$KEEP_LOGS" = false ]; then
        if [ -d "$LOGS_DIR" ] && [ -n "$(ls -A "$LOGS_DIR" 2>/dev/null)" ]; then
            print_warning "  ⚠ السجلات لا تزال موجودة"
            ((issues++))
        fi
    fi
    
    # التحقق من إزالة التكوين (إذا لم يتم الحفاظ عليه)
    if [ "$KEEP_CONFIG" = false ]; then
        if [ -f "$CONFIG_DIR/error_tracking.yml" ]; then
            print_warning "  ⚠ ملف التكوين لا يزال موجوداً"
            ((issues++))
        fi
    fi
    
    if [ $issues -eq 0 ]; then
        print_success "✓ تم التحقق: إلغاء التثبيت كامل"
        return 0
    else
        print_warning "⚠ تم العثور على $issues مشكلة"
        return 1
    fi
}

# عرض معلومات ما بعد إلغاء التثبيت
show_post_uninstall_info() {
    cat << EOF

═══════════════════════════════════════════════════════════
  ✅ تم إلغاء التثبيت بنجاح!
═══════════════════════════════════════════════════════════

📋 ما تم إزالته:
  ✓ Git Hooks (pre-commit, pre-push)
EOF

    if [ "$KEEP_LOGS" = false ]; then
        echo "  ✓ السجلات (logs/)"
    else
        echo "  ℹ السجلات: تم الحفاظ عليها (--keep-logs)"
    fi
    
    if [ "$KEEP_CONFIG" = false ]; then
        echo "  ✓ ملفات التكوين"
    else
        echo "  ℹ ملفات التكوين: تم الحفاظ عليها (--keep-config)"
    fi
    
    echo "  ✓ الملفات المؤقتة"
    
    cat << EOF

📦 النسخ الاحتياطية:
EOF

    # البحث عن النسخ الاحتياطية
    local backups=($(ls -t "$PROJECT_ROOT"/logs_backup_*.tar.gz 2>/dev/null))
    
    if [ ${#backups[@]} -gt 0 ]; then
        echo "  تم إنشاء نسخة احتياطية:"
        for backup in "${backups[@]}"; do
            echo "    • $(basename "$backup")"
        done
    else
        echo "  لا توجد نسخ احتياطية"
    fi
    
    cat << EOF

🔄 إعادة التثبيت:
  إذا أردت إعادة تثبيت النظام:
  bash scripts/install.sh

📚 الملفات المتبقية:
  • السكريبتات: scripts/
  • التوثيق: docs/
  • الاختبارات: test/

⚠️  ملاحظة:
  السكريبتات والتوثيق لا تزال موجودة.
  يمكنك حذفها يدوياً إذا أردت.

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
            --keep-logs)
                KEEP_LOGS=true
                shift
                ;;
            --keep-config)
                KEEP_CONFIG=true
                shift
                ;;
            --force)
                FORCE_UNINSTALL=true
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
  إلغاء تثبيت نظام تتبع الأخطاء والسجلات
═══════════════════════════════════════════════════════════

المشروع: بصير MVP
الإصدار: $VERSION
التاريخ: $(date '+%Y-%m-%d %H:%M:%S')

EOF
    
    # التحقق من وجود التثبيت
    if ! check_installation; then
        echo ""
        print_info "لا يوجد شيء لإلغاء تثبيته"
        exit 0
    fi
    
    echo ""
    
    # طلب التأكيد
    confirm_uninstall
    
    echo ""
    print_info "بدء إلغاء التثبيت..."
    echo ""
    
    # تنفيذ خطوات إلغاء التثبيت
    backup_logs
    remove_git_hooks
    remove_logs
    remove_config
    cleanup_temp_files
    
    echo ""
    verify_uninstall
    
    echo ""
    show_post_uninstall_info
    
    return 0
}

# تشغيل البرنامج الرئيسي
main "$@"
