#!/bin/bash

# Sanitize Script - تنظيف البيانات الحساسة من السجلات
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# الأنماط الحساسة
declare -a SENSITIVE_PATTERNS=(
    "password"
    "passwd"
    "pwd"
    "token"
    "api[_-]?key"
    "apikey"
    "secret"
    "private[_-]?key"
    "access[_-]?key"
    "auth[_-]?token"
    "bearer"
    "credentials"
    "AKIA[0-9A-Z]{16}"  # AWS Access Key
)

# الكلمات المفتاحية الحساسة
declare -a SENSITIVE_KEYWORDS=(
    "password"
    "token"
    "key"
    "secret"
    "credential"
    "auth"
    "bearer"
)

# دالة لطباعة رسالة خطأ
print_error() {
    echo -e "${RED}[خطأ]${NC} $1" >&2
}

# دالة لطباعة رسالة نجاح
print_success() {
    echo -e "${GREEN}[نجاح]${NC} $1"
}

# دالة لطباعة رسالة تحذير
print_warning() {
    echo -e "${YELLOW}[تحذير]${NC} $1"
}

# دالة لتنظيف ملف واحد
sanitize_file() {
    local file="$1"
    local backup="${file}.backup"
    local temp="${file}.temp"
    
    if [[ ! -f "$file" ]]; then
        print_error "الملف غير موجود: $file"
        return 1
    fi
    
    # إنشاء نسخة احتياطية
    cp "$file" "$backup"
    
    # نسخ المحتوى إلى ملف مؤقت
    cp "$file" "$temp"
    
    local changes=0
    
    # تنظيف الأنماط الحساسة
    for pattern in "${SENSITIVE_PATTERNS[@]}"; do
        if grep -qiE "$pattern" "$temp" 2>/dev/null; then
            sed -i -E "s/${pattern}[[:space:]]*[:=][[:space:]]*['\"]?[^'\"[:space:]]+['\"]?/${pattern}=[REDACTED]/gi" "$temp"
            ((changes++))
        fi
    done
    
    # تنظيف الكلمات المفتاحية الحساسة
    for keyword in "${SENSITIVE_KEYWORDS[@]}"; do
        if grep -qiE "${keyword}[[:space:]]*[:=]" "$temp" 2>/dev/null; then
            sed -i -E "s/(${keyword}[[:space:]]*[:=][[:space:]]*)['\"]?[^'\"[:space:]]+['\"]?/\1[REDACTED]/gi" "$temp"
            ((changes++))
        fi
    done
    
    # تنظيف عناوين URL التي تحتوي على بيانات حساسة
    if grep -qE "https?://[^@]+:[^@]+@" "$temp" 2>/dev/null; then
        sed -i -E "s|(https?://)[^:]+:[^@]+@|\1[REDACTED]:[REDACTED]@|g" "$temp"
        ((changes++))
    fi
    
    # تنظيف مفاتيح AWS
    if grep -qE "AKIA[0-9A-Z]{16}" "$temp" 2>/dev/null; then
        sed -i -E "s/AKIA[0-9A-Z]{16}/AKIA[REDACTED]/g" "$temp"
        ((changes++))
    fi
    
    if [[ $changes -gt 0 ]]; then
        mv "$temp" "$file"
        print_success "تم تنظيف الملف: $file (تم إجراء $changes تغيير)"
        return 0
    else
        rm "$temp"
        rm "$backup"
        return 0
    fi
}

# دالة لتنظيف مجلد
sanitize_directory() {
    local dir="$1"
    local count=0
    
    if [[ ! -d "$dir" ]]; then
        print_error "المجلد غير موجود: $dir"
        return 1
    fi
    
    print_warning "جاري تنظيف المجلد: $dir"
    
    while IFS= read -r -d '' file; do
        if sanitize_file "$file"; then
            ((count++))
        fi
    done < <(find "$dir" -type f \( -name "*.log" -o -name "*.txt" -o -name "*.json" \) -print0)
    
    print_success "تم تنظيف $count ملف في المجلد: $dir"
}

# دالة للتحقق من وجود بيانات حساسة
check_sensitive_data() {
    local file="$1"
    local found=0
    
    if [[ ! -f "$file" ]]; then
        print_error "الملف غير موجود: $file"
        return 1
    fi
    
    for pattern in "${SENSITIVE_PATTERNS[@]}"; do
        if grep -qiE "$pattern" "$file" 2>/dev/null; then
            print_warning "تم العثور على نمط حساس في $file: $pattern"
            ((found++))
        fi
    done
    
    if [[ $found -eq 0 ]]; then
        print_success "لا توجد بيانات حساسة في: $file"
        return 0
    else
        print_error "تم العثور على $found نمط حساس في: $file"
        return 1
    fi
}

# دالة لعرض المساعدة
show_help() {
    cat << EOF
الاستخدام: $0 [OPTIONS] <FILE|DIRECTORY>

تنظيف البيانات الحساسة من السجلات

الخيارات:
  -f, --file FILE         تنظيف ملف واحد
  -d, --dir DIRECTORY     تنظيف جميع الملفات في المجلد
  -c, --check FILE        التحقق من وجود بيانات حساسة فقط
  -h, --help              عرض هذه المساعدة

أمثلة:
  $0 -f logs/error.log
  $0 -d logs/
  $0 -c logs/error.log

EOF
}

# المعالجة الرئيسية
main() {
    if [[ $# -eq 0 ]]; then
        show_help
        exit 1
    fi
    
    case "$1" in
        -f|--file)
            if [[ -z "$2" ]]; then
                print_error "يجب تحديد اسم الملف"
                exit 1
            fi
            sanitize_file "$2"
            ;;
        -d|--dir)
            if [[ -z "$2" ]]; then
                print_error "يجب تحديد اسم المجلد"
                exit 1
            fi
            sanitize_directory "$2"
            ;;
        -c|--check)
            if [[ -z "$2" ]]; then
                print_error "يجب تحديد اسم الملف"
                exit 1
            fi
            check_sensitive_data "$2"
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "خيار غير معروف: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
