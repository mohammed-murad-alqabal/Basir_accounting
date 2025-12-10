#!/bin/bash

################################################################################
# سكريبت جمع السجلات - نظام تتبع الأخطاء والسجلات
#
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025 (محدث)
# المؤلف: فريق وكلاء تطوير مشروع بصير
# الإصدار: 2.0 (مع معالجة أخطاء شاملة)
#
# الوصف:
#   يقوم هذا السكريبت بجمع السجلات من مصادر متعددة:
#   - سجلات Flutter Analyze
#   - سجلات الاختبارات
#   - سجلات الأخطاء
#   ثم يقوم بتنظيف البيانات الحساسة وإزالة التكرار
#
# الاستخدام:
#   ./collect_logs.sh [OPTIONS]
#
# الخيارات:
#   --push          دفع السجلات إلى Git بعد الجمع
#   --help          عرض هذه الرسالة
#   --info          عرض معلومات عن السجلات الحالية
#
# المتطلبات:
#   - Flutter SDK 3.24.0+
#   - Git 2.0+
#   - Bash 4.0+
#
################################################################################

# إعدادات عامة
set -o pipefail  # فشل pipeline إذا فشل أي أمر
set -o errexit   # الخروج عند أي خطأ
set -o nounset   # الخروج عند استخدام متغير غير معرف

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOGS_DIR="$PROJECT_ROOT/logs"
ARCHIVE_DIR="$LOGS_DIR/archive"
ERRORS_DIR="$LOGS_DIR/errors"
REPORTS_DIR="$LOGS_DIR/reports"

# تحميل مكتبة معالجة الأخطاء
if [ -f "$SCRIPT_DIR/utils/error_handler.sh" ]; then
    source "$SCRIPT_DIR/utils/error_handler.sh"
else
    echo "خطأ: لم يتم العثور على مكتبة معالجة الأخطاء" >&2
    exit 1
fi

# متغيرات عامة
PUSH_TO_GIT=false
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
TEMP_DIR="$LOGS_DIR/.temp_$$"

################################################################################
# دوال مساعدة
################################################################################

# طباعة رسالة ملونة
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# طباعة رسالة نجاح
print_success() {
    print_message "$GREEN" "✓ $1"
}

# طباعة رسالة خطأ
print_error() {
    print_message "$RED" "✗ $1"
}

# طباعة رسالة تحذير
print_warning() {
    print_message "$YELLOW" "⚠ $1"
}

# طباعة رسالة معلومات
print_info() {
    print_message "$BLUE" "ℹ $1"
}

# التحقق من وجود أمر
check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_error "الأمر '$1' غير موجود. يرجى تثبيته أولاً."
        exit 1
    fi
}

# إنشاء المجلدات المطلوبة
create_directories() {
    mkdir -p "$LOGS_DIR" "$ARCHIVE_DIR" "$ERRORS_DIR" "$REPORTS_DIR" "$TEMP_DIR"
}

# تنظيف الملفات المؤقتة
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}

# معالج الإشارات للتنظيف عند الخروج
trap cleanup EXIT INT TERM

################################################################################
# دوال جمع السجلات
################################################################################

# جمع سجلات Flutter Analyze
collect_analyze_logs() {
    print_info "جاري جمع سجلات Flutter Analyze..."
    
    local log_file="$LOGS_DIR/flutter_analyze_$TIMESTAMP.log"
    local temp_file="$TEMP_DIR/analyze_raw.log"
    
    cd "$PROJECT_ROOT" || exit 1
    
    # تشغيل Flutter Analyze وحفظ النتائج
    if flutter analyze --no-pub > "$temp_file" 2>&1; then
        print_success "Flutter Analyze: لا توجد أخطاء"
        echo "=== Flutter Analyze Results ===" > "$log_file"
        echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >> "$log_file"
        echo "Status: SUCCESS" >> "$log_file"
        echo "No errors or warnings found." >> "$log_file"
    else
        print_warning "Flutter Analyze: تم اكتشاف أخطاء أو تحذيرات"
        echo "=== Flutter Analyze Results ===" > "$log_file"
        echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >> "$log_file"
        echo "Status: FAILED" >> "$log_file"
        echo "" >> "$log_file"
        cat "$temp_file" >> "$log_file"
    fi
    
    # تنظيف البيانات الحساسة
    sanitize_log_file "$log_file"
    
    print_success "تم حفظ سجل Flutter Analyze: $(basename "$log_file")"
}

# جمع سجلات الاختبارات
collect_test_logs() {
    print_info "جاري جمع سجلات الاختبارات..."
    
    local log_file="$LOGS_DIR/flutter_test_$TIMESTAMP.log"
    local temp_file="$TEMP_DIR/test_raw.log"
    
    cd "$PROJECT_ROOT" || exit 1
    
    # تشغيل الاختبارات وحفظ النتائج
    if flutter test --no-pub > "$temp_file" 2>&1; then
        print_success "الاختبارات: نجحت جميع الاختبارات"
        echo "=== Flutter Test Results ===" > "$log_file"
        echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >> "$log_file"
        echo "Status: SUCCESS" >> "$log_file"
        echo "" >> "$log_file"
        cat "$temp_file" >> "$log_file"
    else
        print_warning "الاختبارات: فشلت بعض الاختبارات"
        echo "=== Flutter Test Results ===" > "$log_file"
        echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >> "$log_file"
        echo "Status: FAILED" >> "$log_file"
        echo "" >> "$log_file"
        cat "$temp_file" >> "$log_file"
    fi
    
    # تنظيف البيانات الحساسة
    sanitize_log_file "$log_file"
    
    print_success "تم حفظ سجل الاختبارات: $(basename "$log_file")"
}

# جمع سجلات الأخطاء من ملفات السجل الموجودة
collect_error_logs() {
    print_info "جاري جمع سجلات الأخطاء..."
    
    local error_log="$LOGS_DIR/errors_summary_$TIMESTAMP.log"
    local error_count=0
    
    echo "=== Error Summary ===" > "$error_log"
    echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >> "$error_log"
    echo "" >> "$error_log"
    
    # البحث عن الأخطاء في سجلات Flutter Analyze
    if ls "$LOGS_DIR"/flutter_analyze_*.log 1> /dev/null 2>&1; then
        echo "--- Flutter Analyze Errors ---" >> "$error_log"
        for log in "$LOGS_DIR"/flutter_analyze_*.log; do
            if grep -i "error\|warning" "$log" >> "$error_log" 2>/dev/null; then
                ((error_count++))
            fi
        done
        echo "" >> "$error_log"
    fi
    
    # البحث عن الأخطاء في سجلات الاختبارات
    if ls "$LOGS_DIR"/flutter_test_*.log 1> /dev/null 2>&1; then
        echo "--- Test Errors ---" >> "$error_log"
        for log in "$LOGS_DIR"/flutter_test_*.log; do
            if grep -i "failed\|error" "$log" >> "$error_log" 2>/dev/null; then
                ((error_count++))
            fi
        done
        echo "" >> "$error_log"
    fi
    
    if [ $error_count -eq 0 ]; then
        print_success "لم يتم العثور على أخطاء"
        rm "$error_log"
    else
        print_warning "تم العثور على $error_count خطأ/أخطاء"
        sanitize_log_file "$error_log"
        print_success "تم حفظ ملخص الأخطاء: $(basename "$error_log")"
    fi
}

################################################################################
# دوال تنظيف البيانات
################################################################################

# تنظيف البيانات الحساسة من ملف سجل
sanitize_log_file() {
    local file=$1
    
    if [ ! -f "$file" ]; then
        return
    fi
    
    # أنماط البيانات الحساسة
    local patterns=(
        's/password[[:space:]]*[:=][[:space:]]*[^[:space:]]*/password: <credential-fixture>'
        's/api[_-]?key[[:space:]]*[:=][[:space:]]*[^[:space:]]*/api_key: <credential-fixture>'
        's/token[[:space:]]*[:=][[:space:]]*[^[:space:]]*/token: <credential-fixture>'
        's/secret[[:space:]]*[:=][[:space:]]*[^[:space:]]*/secret: <credential-fixture>'
        's/bearer[[:space:]]+[a-zA-Z0-9_-]+/bearer [REDACTED]/gi'
        's/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/[EMAIL_REDACTED]/g'
        's/\b\d{3}[-.]?\d{3}[-.]?\d{4}\b/[PHONE_REDACTED]/g'
    )
    
    # تطبيق التنظيف
    local temp_file="$TEMP_DIR/sanitize_temp.log"
    cp "$file" "$temp_file"
    
    for pattern in "${patterns[@]}"; do
        sed -i "$pattern" "$temp_file" 2>/dev/null || true
    done
    
    mv "$temp_file" "$file"
}

# إزالة السجلات المكررة
remove_duplicate_logs() {
    print_info "جاري إزالة السجلات المكررة..."
    
    local duplicates_found=0
    local temp_file="$TEMP_DIR/seen_hashes.txt"
    touch "$temp_file"
    
    # فحص كل ملف سجل
    for log_file in "$LOGS_DIR"/*.log; do
        if [ ! -f "$log_file" ]; then
            continue
        fi
        
        # حساب hash للمحتوى (بدون timestamp)
        local content_hash=$(grep -v "Timestamp:" "$log_file" 2>/dev/null | md5sum | cut -d' ' -f1)
        
        # التحقق من التكرار
        if grep -q "^$content_hash$" "$temp_file"; then
            print_warning "تم العثور على سجل مكرر: $(basename "$log_file")"
            mv "$log_file" "$ERRORS_DIR/"
            ((duplicates_found++))
        else
            echo "$content_hash" >> "$temp_file"
        fi
    done
    
    if [ $duplicates_found -eq 0 ]; then
        print_success "لم يتم العثور على سجلات مكررة"
    else
        print_success "تم نقل $duplicates_found سجل/سجلات مكررة إلى $ERRORS_DIR"
    fi
}

################################################################################
# دوال Git
################################################################################

# دفع السجلات إلى Git
push_logs_to_git() {
    print_info "جاري دفع السجلات إلى Git..."
    
    cd "$PROJECT_ROOT" || exit 1
    
    # التحقق من وجود تغييرات
    if ! git diff --quiet logs/ || ! git diff --cached --quiet logs/; then
        # إضافة السجلات
        git add logs/
        
        # إنشاء commit
        local commit_message="chore(logs): update logs [skip ci]

تم تحديث السجلات تلقائياً في $TIMESTAMP

- سجلات Flutter Analyze
- سجلات الاختبارات
- ملخص الأخطاء"
        
        if git commit -m "$commit_message"; then
            print_success "تم إنشاء commit للسجلات"
            
            # محاولة push
            if git push; then
                print_success "تم دفع السجلات إلى Git بنجاح"
            else
                print_warning "فشل دفع السجلات إلى Git. يرجى المحاولة يدوياً."
                return 1
            fi
        else
            print_error "فشل إنشاء commit للسجلات"
            return 1
        fi
    else
        print_info "لا توجد تغييرات جديدة في السجلات"
    fi
}

################################################################################
# دوال المعلومات
################################################################################

# عرض معلومات عن السجلات
show_info() {
    print_info "معلومات السجلات:"
    echo ""
    
    # عدد السجلات
    local log_count=$(find "$LOGS_DIR" -maxdepth 1 -name "*.log" 2>/dev/null | wc -l)
    echo "عدد السجلات: $log_count"
    
    # حجم السجلات
    local logs_size=$(du -sh "$LOGS_DIR" 2>/dev/null | cut -f1)
    echo "حجم السجلات: $logs_size"
    
    # عدد السجلات المؤرشفة
    local archive_count=$(find "$ARCHIVE_DIR" -name "*.log" -o -name "*.tar.gz" 2>/dev/null | wc -l)
    echo "عدد السجلات المؤرشفة: $archive_count"
    
    # أحدث سجل
    local latest_log=$(ls -t "$LOGS_DIR"/*.log 2>/dev/null | head -1)
    if [ -n "$latest_log" ]; then
        echo "أحدث سجل: $(basename "$latest_log")"
        echo "تاريخ الإنشاء: $(stat -c %y "$latest_log" 2>/dev/null | cut -d'.' -f1)"
    fi
    
    echo ""
}

# عرض رسالة المساعدة
show_help() {
    cat << EOF
سكريبت جمع السجلات - نظام تتبع الأخطاء والسجلات

الاستخدام:
    $0 [OPTIONS]

الخيارات:
    --push          دفع السجلات إلى Git بعد الجمع
    --help          عرض هذه الرسالة
    --info          عرض معلومات عن السجلات الحالية

الأمثلة:
    # جمع السجلات فقط
    $0

    # جمع السجلات ودفعها إلى Git
    $0 --push

    # عرض معلومات السجلات
    $0 --info

المتطلبات:
    - Flutter SDK 3.24.0+
    - Git 2.0+
    - Bash 4.0+

المؤلف: فريق وكلاء تطوير مشروع بصير
التاريخ: 4 ديسمبر 2025
الإصدار: 1.0
EOF
}

################################################################################
# الدالة الرئيسية
################################################################################

main() {
    # معالجة المعاملات
    while [[ $# -gt 0 ]]; do
        case $1 in
            --push)
                PUSH_TO_GIT=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            --info)
                show_info
                exit 0
                ;;
            *)
                print_error "خيار غير معروف: $1"
                echo "استخدم --help لعرض المساعدة"
                exit 1
                ;;
        esac
    done
    
    # التحقق من المتطلبات
    check_command flutter
    check_command git
    
    # إنشاء المجلدات
    create_directories
    
    # بداية العملية
    print_info "بدء جمع السجلات..."
    echo ""
    
    # جمع السجلات
    collect_analyze_logs
    collect_test_logs
    collect_error_logs
    
    echo ""
    
    # إزالة التكرار
    remove_duplicate_logs
    
    echo ""
    
    # دفع إلى Git إذا طُلب ذلك
    if [ "$PUSH_TO_GIT" = true ]; then
        push_logs_to_git
        echo ""
    fi
    
    # عرض الملخص
    print_success "اكتملت عملية جمع السجلات بنجاح!"
    show_info
}

# تشغيل الدالة الرئيسية
main "$@"
