#!/bin/bash

# Validate Script - التحقق من صحة البيانات والملفات
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# دالة لطباعة رسالة معلومات
print_info() {
    echo -e "${BLUE}[معلومات]${NC} $1"
}

# دالة للتحقق من صحة رسالة commit
validate_commit_message() {
    local message="$1"
    
    # التحقق من أن الرسالة غير فارغة
    if [[ -z "$message" ]]; then
        print_error "رسالة الـ commit فارغة"
        return 1
    fi
    
    # التحقق من صيغة Conventional Commits
    local pattern="^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert|audit)(\(.+\))?: .+"
    
    if [[ ! "$message" =~ $pattern ]]; then
        print_error "رسالة الـ commit لا تتبع صيغة Conventional Commits"
        print_info "الصيغة المطلوبة: type(scope): description"
        print_info "الأنواع المسموحة: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert, audit"
        return 1
    fi
    
    # التحقق من طول الرسالة
    local length=${#message}
    if [[ $length -gt 100 ]]; then
        print_warning "رسالة الـ commit طويلة جداً ($length حرف). يُفضل أن تكون أقل من 100 حرف"
    fi
    
    print_success "رسالة الـ commit صحيحة"
    return 0
}

# دالة للتحقق من صحة ملف JSON
validate_json() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        print_error "الملف غير موجود: $file"
        return 1
    fi
    
    if command -v jq &> /dev/null; then
        if jq empty "$file" 2>/dev/null; then
            print_success "ملف JSON صحيح: $file"
            return 0
        else
            print_error "ملف JSON غير صحيح: $file"
            return 1
        fi
    else
        print_warning "jq غير مثبت. لا يمكن التحقق من صحة JSON"
        return 0
    fi
}

# دالة للتحقق من صحة ملف YAML
validate_yaml() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        print_error "الملف غير موجود: $file"
        return 1
    fi
    
    if command -v yamllint &> /dev/null; then
        if yamllint "$file" 2>/dev/null; then
            print_success "ملف YAML صحيح: $file"
            return 0
        else
            print_error "ملف YAML غير صحيح: $file"
            return 1
        fi
    else
        print_warning "yamllint غير مثبت. لا يمكن التحقق من صحة YAML"
        return 0
    fi
}

# دالة للتحقق من صحة بنية السجل
validate_log_structure() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        print_error "الملف غير موجود: $file"
        return 1
    fi
    
    local has_timestamp=false
    local has_level=false
    local has_message=false
    
    # التحقق من وجود timestamp
    if grep -qE "[0-9]{4}-[0-9]{2}-[0-9]{2}" "$file"; then
        has_timestamp=true
    fi
    
    # التحقق من وجود مستوى السجل
    if grep -qiE "(error|warning|info|debug|critical)" "$file"; then
        has_level=true
    fi
    
    # التحقق من وجود رسالة
    if [[ -s "$file" ]]; then
        has_message=true
    fi
    
    if [[ "$has_timestamp" == true && "$has_level" == true && "$has_message" == true ]]; then
        print_success "بنية السجل صحيحة: $file"
        return 0
    else
        print_error "بنية السجل غير كاملة: $file"
        [[ "$has_timestamp" == false ]] && print_warning "  - لا يوجد timestamp"
        [[ "$has_level" == false ]] && print_warning "  - لا يوجد مستوى سجل"
        [[ "$has_message" == false ]] && print_warning "  - لا توجد رسالة"
        return 1
    fi
}

# دالة للتحقق من صحة ملف الأرشيف
validate_archive() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        print_error "الملف غير موجود: $file"
        return 1
    fi
    
    local extension="${file##*.}"
    
    case "$extension" in
        gz|tgz)
            if gzip -t "$file" 2>/dev/null; then
                print_success "ملف الأرشيف صحيح: $file"
                return 0
            else
                print_error "ملف الأرشيف تالف: $file"
                return 1
            fi
            ;;
        zip)
            if unzip -t "$file" &>/dev/null; then
                print_success "ملف الأرشيف صحيح: $file"
                return 0
            else
                print_error "ملف الأرشيف تالف: $file"
                return 1
            fi
            ;;
        *)
            print_warning "نوع الأرشيف غير مدعوم: $extension"
            return 0
            ;;
    esac
}

# دالة للتحقق من المساحة المتاحة
validate_disk_space() {
    local path="$1"
    local min_space_mb="${2:-100}"  # الحد الأدنى 100 ميجابايت
    
    if [[ ! -d "$path" ]]; then
        print_error "المسار غير موجود: $path"
        return 1
    fi
    
    local available_space=$(df -m "$path" | awk 'NR==2 {print $4}')
    
    if [[ $available_space -lt $min_space_mb ]]; then
        print_error "المساحة المتاحة غير كافية: ${available_space}MB (الحد الأدنى: ${min_space_mb}MB)"
        return 1
    else
        print_success "المساحة المتاحة كافية: ${available_space}MB"
        return 0
    fi
}

# دالة للتحقق من الأذونات
validate_permissions() {
    local path="$1"
    local required_perm="${2:-rw}"  # الأذونات المطلوبة
    
    if [[ ! -e "$path" ]]; then
        print_error "المسار غير موجود: $path"
        return 1
    fi
    
    local has_read=false
    local has_write=false
    local has_execute=false
    
    [[ -r "$path" ]] && has_read=true
    [[ -w "$path" ]] && has_write=true
    [[ -x "$path" ]] && has_execute=true
    
    local valid=true
    
    if [[ "$required_perm" == *"r"* && "$has_read" == false ]]; then
        print_error "لا توجد صلاحية قراءة: $path"
        valid=false
    fi
    
    if [[ "$required_perm" == *"w"* && "$has_write" == false ]]; then
        print_error "لا توجد صلاحية كتابة: $path"
        valid=false
    fi
    
    if [[ "$required_perm" == *"x"* && "$has_execute" == false ]]; then
        print_error "لا توجد صلاحية تنفيذ: $path"
        valid=false
    fi
    
    if [[ "$valid" == true ]]; then
        print_success "الأذونات صحيحة: $path"
        return 0
    else
        return 1
    fi
}

# دالة لعرض المساعدة
show_help() {
    cat << EOF
الاستخدام: $0 [OPTIONS] <TARGET>

التحقق من صحة البيانات والملفات

الخيارات:
  -c, --commit MESSAGE    التحقق من صحة رسالة commit
  -j, --json FILE         التحقق من صحة ملف JSON
  -y, --yaml FILE         التحقق من صحة ملف YAML
  -l, --log FILE          التحقق من صحة بنية السجل
  -a, --archive FILE      التحقق من صحة ملف الأرشيف
  -s, --space PATH [MB]   التحقق من المساحة المتاحة
  -p, --perm PATH [PERM]  التحقق من الأذونات
  -h, --help              عرض هذه المساعدة

أمثلة:
  $0 -c "feat(auth): add login feature"
  $0 -j config.json
  $0 -l logs/error.log
  $0 -a logs/archive.tar.gz
  $0 -s /var/logs 500
  $0 -p scripts/test.sh rwx

EOF
}

# المعالجة الرئيسية
main() {
    if [[ $# -eq 0 ]]; then
        show_help
        exit 1
    fi
    
    case "$1" in
        -c|--commit)
            if [[ -z "$2" ]]; then
                print_error "يجب تحديد رسالة الـ commit"
                exit 1
            fi
            validate_commit_message "$2"
            ;;
        -j|--json)
            if [[ -z "$2" ]]; then
                print_error "يجب تحديد اسم الملف"
                exit 1
            fi
            validate_json "$2"
            ;;
        -y|--yaml)
            if [[ -z "$2" ]]; then
                print_error "يجب تحديد اسم الملف"
                exit 1
            fi
            validate_yaml "$2"
            ;;
        -l|--log)
            if [[ -z "$2" ]]; then
                print_error "يجب تحديد اسم الملف"
                exit 1
            fi
            validate_log_structure "$2"
            ;;
        -a|--archive)
            if [[ -z "$2" ]]; then
                print_error "يجب تحديد اسم الملف"
                exit 1
            fi
            validate_archive "$2"
            ;;
        -s|--space)
            if [[ -z "$2" ]]; then
                print_error "يجب تحديد المسار"
                exit 1
            fi
            validate_disk_space "$2" "${3:-100}"
            ;;
        -p|--perm)
            if [[ -z "$2" ]]; then
                print_error "يجب تحديد المسار"
                exit 1
            fi
            validate_permissions "$2" "${3:-rw}"
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
