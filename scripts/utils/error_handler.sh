#!/bin/bash

# =============================================================================
# مكتبة معالجة الأخطاء - Error Tracking System
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# =============================================================================
# الوصف: مكتبة شاملة لمعالجة الأخطاء، التسجيل، والاسترداد
# =============================================================================

# الألوان للإخراج
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# مستويات الخطورة
readonly LEVEL_DEBUG="DEBUG"
readonly LEVEL_INFO="INFO"
readonly LEVEL_WARNING="WARNING"
readonly LEVEL_ERROR="ERROR"
readonly LEVEL_CRITICAL="CRITICAL"

# ملف السجل
ERROR_LOG_FILE="${ERROR_LOG_FILE:-logs/errors/error_$(date +%Y-%m-%d).log}"
ERROR_LOG_DIR=$(dirname "$ERROR_LOG_FILE")

# إنشاء مجلد السجلات إذا لم يكن موجوداً
mkdir -p "$ERROR_LOG_DIR" 2>/dev/null || true

# عداد الأخطاء
ERROR_COUNT=0
WARNING_COUNT=0

# =============================================================================
# دوال الطباعة الملونة
# =============================================================================

# طباعة رسالة ملونة
print_colored() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# طباعة رسالة debug
print_debug() {
    print_colored "$CYAN" "[DEBUG] $1"
}

# طباعة رسالة info
print_info() {
    print_colored "$BLUE" "[INFO] $1"
}

# طباعة رسالة warning
print_warning() {
    print_colored "$YELLOW" "[⚠ تحذير] $1"
}

# طباعة رسالة error
print_error() {
    print_colored "$RED" "[✗ خطأ] $1"
}

# طباعة رسالة critical
print_critical() {
    print_colored "$MAGENTA" "[🔥 خطأ حرج] $1"
}

# طباعة رسالة success
print_success() {
    print_colored "$GREEN" "[✓ نجح] $1"
}

# =============================================================================
# دوال التسجيل (Logging)
# =============================================================================

# تسجيل رسالة في ملف السجل
log_message() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local script_name=$(basename "$0")
    
    # تنسيق الرسالة
    local log_entry="[$timestamp] [$level] [$script_name] $message"
    
    # الكتابة إلى ملف السجل
    echo "$log_entry" >> "$ERROR_LOG_FILE" 2>/dev/null || {
        echo "تعذر الكتابة إلى ملف السجل: $ERROR_LOG_FILE" >&2
    }
}

# تسجيل debug
log_debug() {
    log_message "$LEVEL_DEBUG" "$1"
}

# تسجيل info
log_info() {
    log_message "$LEVEL_INFO" "$1"
}

# تسجيل warning
log_warning() {
    ((WARNING_COUNT++))
    log_message "$LEVEL_WARNING" "$1"
    print_warning "$1"
}

# تسجيل error
log_error() {
    ((ERROR_COUNT++))
    log_message "$LEVEL_ERROR" "$1"
    print_error "$1"
}

# تسجيل critical
log_critical() {
    ((ERROR_COUNT++))
    log_message "$LEVEL_CRITICAL" "$1"
    print_critical "$1"
}

# =============================================================================
# دوال معالجة الأخطاء
# =============================================================================

# معالج الأخطاء العام
handle_error() {
    local exit_code=$1
    local error_message=$2
    local line_number=${3:-"غير معروف"}
    local function_name=${4:-"غير معروف"}
    
    log_error "كود الخروج: $exit_code"
    log_error "الرسالة: $error_message"
    log_error "السطر: $line_number"
    log_error "الدالة: $function_name"
    
    # محاولة الاسترداد إذا كان الخطأ غير حرج
    if [ $exit_code -lt 100 ]; then
        log_info "محاولة الاسترداد من الخطأ..."
        return 0
    fi
    
    # خطأ حرج - الخروج
    log_critical "خطأ حرج - الخروج من السكريبت"
    exit $exit_code
}

# معالج أخطاء الأوامر
handle_command_error() {
    local command=$1
    local exit_code=$2
    local error_output=$3
    
    log_error "فشل تنفيذ الأمر: $command"
    log_error "كود الخروج: $exit_code"
    
    if [ -n "$error_output" ]; then
        log_error "الإخراج: $error_output"
    fi
    
    # اقتراحات للحل
    case $exit_code in
        1)
            log_info "اقتراح: تحقق من صحة المعاملات"
            ;;
        2)
            log_info "اقتراح: تحقق من الصلاحيات"
            ;;
        126)
            log_info "اقتراح: تحقق من صلاحيات التنفيذ (chmod +x)"
            ;;
        127)
            log_info "اقتراح: الأمر غير موجود - تحقق من التثبيت"
            ;;
        *)
            log_info "اقتراح: راجع السجلات للمزيد من التفاصيل"
            ;;
    esac
}

# معالج أخطاء الملفات
handle_file_error() {
    local operation=$1
    local file_path=$2
    local error_message=$3
    
    log_error "فشلت عملية الملف: $operation"
    log_error "المسار: $file_path"
    log_error "السبب: $error_message"
    
    # اقتراحات حسب نوع العملية
    case $operation in
        "read")
            log_info "اقتراح: تحقق من وجود الملف وصلاحيات القراءة"
            ;;
        "write")
            log_info "اقتراح: تحقق من صلاحيات الكتابة والمساحة المتوفرة"
            ;;
        "delete")
            log_info "اقتراح: تحقق من صلاحيات الحذف"
            ;;
        "create")
            log_info "اقتراح: تحقق من صلاحيات الإنشاء والمساحة المتوفرة"
            ;;
    esac
}

# معالج أخطاء الشبكة
handle_network_error() {
    local operation=$1
    local url=$2
    local error_code=$3
    
    log_error "فشلت عملية الشبكة: $operation"
    log_error "URL: $url"
    log_error "كود الخطأ: $error_code"
    
    case $error_code in
        "timeout")
            log_info "اقتراح: تحقق من الاتصال بالإنترنت وحاول مرة أخرى"
            ;;
        "404")
            log_info "اقتراح: تحقق من صحة الرابط"
            ;;
        "403"|"401")
            log_info "اقتراح: تحقق من صلاحيات الوصول"
            ;;
        *)
            log_info "اقتراح: تحقق من الاتصال بالإنترنت"
            ;;
    esac
}

# =============================================================================
# دوال الاسترداد (Recovery)
# =============================================================================

# محاولة إعادة تنفيذ أمر
retry_command() {
    local max_attempts=${1:-3}
    local delay=${2:-2}
    shift 2
    local command="$@"
    
    local attempt=1
    while [ $attempt -le $max_attempts ]; do
        log_info "محاولة $attempt من $max_attempts: $command"
        
        if eval "$command"; then
            log_success "نجح الأمر في المحاولة $attempt"
            return 0
        fi
        
        if [ $attempt -lt $max_attempts ]; then
            log_warning "فشلت المحاولة $attempt - إعادة المحاولة بعد ${delay}s"
            sleep $delay
        fi
        
        ((attempt++))
    done
    
    log_error "فشل الأمر بعد $max_attempts محاولات"
    return 1
}

# إنشاء نسخة احتياطية من ملف
backup_file() {
    local file_path=$1
    local backup_dir="${2:-backups}"
    
    if [ ! -f "$file_path" ]; then
        log_warning "الملف غير موجود للنسخ الاحتياطي: $file_path"
        return 1
    fi
    
    mkdir -p "$backup_dir" 2>/dev/null || {
        log_error "فشل إنشاء مجلد النسخ الاحتياطي: $backup_dir"
        return 1
    }
    
    local backup_name="$(basename "$file_path").backup.$(date +%Y%m%d_%H%M%S)"
    local backup_path="$backup_dir/$backup_name"
    
    if cp "$file_path" "$backup_path" 2>/dev/null; then
        log_success "تم إنشاء نسخة احتياطية: $backup_path"
        return 0
    else
        log_error "فشل إنشاء النسخة الاحتياطية"
        return 1
    fi
}

# استعادة من نسخة احتياطية
restore_backup() {
    local backup_path=$1
    local target_path=$2
    
    if [ ! -f "$backup_path" ]; then
        log_error "النسخة الاحتياطية غير موجودة: $backup_path"
        return 1
    fi
    
    if cp "$backup_path" "$target_path" 2>/dev/null; then
        log_success "تم استعادة النسخة الاحتياطية: $target_path"
        return 0
    else
        log_error "فشلت استعادة النسخة الاحتياطية"
        return 1
    fi
}

# =============================================================================
# دوال التحقق (Validation)
# =============================================================================

# التحقق من وجود أمر
check_command() {
    local command=$1
    
    if command -v "$command" &> /dev/null; then
        log_debug "الأمر متوفر: $command"
        return 0
    else
        log_error "الأمر غير متوفر: $command"
        log_info "اقتراح: قم بتثبيت $command أولاً"
        return 1
    fi
}

# التحقق من وجود ملف
check_file() {
    local file_path=$1
    
    if [ -f "$file_path" ]; then
        log_debug "الملف موجود: $file_path"
        return 0
    else
        log_error "الملف غير موجود: $file_path"
        return 1
    fi
}

# التحقق من وجود مجلد
check_directory() {
    local dir_path=$1
    
    if [ -d "$dir_path" ]; then
        log_debug "المجلد موجود: $dir_path"
        return 0
    else
        log_error "المجلد غير موجود: $dir_path"
        return 1
    fi
}

# التحقق من المساحة المتوفرة
check_disk_space() {
    local required_mb=${1:-100}
    local path=${2:-.}
    
    local available_mb=$(df -m "$path" 2>/dev/null | awk 'NR==2 {print $4}' || echo 0)
    
    if [ $available_mb -ge $required_mb ]; then
        log_debug "المساحة المتوفرة كافية: ${available_mb}MB"
        return 0
    else
        log_error "المساحة غير كافية: ${available_mb}MB (مطلوب: ${required_mb}MB)"
        log_info "اقتراح: قم بتحرير مساحة أو أرشفة الملفات القديمة"
        return 1
    fi
}

# التحقق من صلاحيات الكتابة
check_write_permission() {
    local path=$1
    
    if [ -w "$path" ]; then
        log_debug "صلاحيات الكتابة متوفرة: $path"
        return 0
    else
        log_error "لا توجد صلاحيات كتابة: $path"
        log_info "اقتراح: استخدم chmod لتعديل الصلاحيات"
        return 1
    fi
}

# =============================================================================
# دوال التنظيف (Cleanup)
# =============================================================================

# تنظيف الملفات المؤقتة
cleanup_temp_files() {
    local temp_dir=${1:-/tmp}
    local pattern=${2:-"basser_*"}
    
    log_info "تنظيف الملفات المؤقتة: $temp_dir/$pattern"
    
    local count=$(find "$temp_dir" -name "$pattern" 2>/dev/null | wc -l)
    
    if [ $count -gt 0 ]; then
        find "$temp_dir" -name "$pattern" -delete 2>/dev/null && {
            log_success "تم حذف $count ملف مؤقت"
        } || {
            log_warning "فشل حذف بعض الملفات المؤقتة"
        }
    else
        log_info "لا توجد ملفات مؤقتة للحذف"
    fi
}

# =============================================================================
# دوال التقارير
# =============================================================================

# طباعة ملخص الأخطاء
print_error_summary() {
    echo ""
    print_colored "$BLUE" "═══════════════════════════════════════"
    print_colored "$BLUE" "  ملخص الأخطاء والتحذيرات"
    print_colored "$BLUE" "═══════════════════════════════════════"
    echo ""
    
    if [ $ERROR_COUNT -eq 0 ] && [ $WARNING_COUNT -eq 0 ]; then
        print_success "لا توجد أخطاء أو تحذيرات! 🎉"
    else
        [ $ERROR_COUNT -gt 0 ] && print_error "إجمالي الأخطاء: $ERROR_COUNT"
        [ $WARNING_COUNT -gt 0 ] && print_warning "إجمالي التحذيرات: $WARNING_COUNT"
        echo ""
        print_info "راجع ملف السجل للتفاصيل: $ERROR_LOG_FILE"
    fi
    
    echo ""
}

# =============================================================================
# معالج الإشارات (Signal Handler)
# =============================================================================

# معالج إشارة الإنهاء
handle_exit() {
    local exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        log_error "السكريبت انتهى بخطأ (كود: $exit_code)"
    else
        log_info "السكريبت انتهى بنجاح"
    fi
    
    print_error_summary
}

# معالج إشارة المقاطعة (Ctrl+C)
handle_interrupt() {
    log_warning "تم مقاطعة السكريبت بواسطة المستخدم"
    cleanup_temp_files
    exit 130
}

# تسجيل معالجات الإشارات
trap handle_exit EXIT
trap handle_interrupt INT TERM

# =============================================================================
# رسالة التحميل
# =============================================================================

log_info "تم تحميل مكتبة معالجة الأخطاء بنجاح"
