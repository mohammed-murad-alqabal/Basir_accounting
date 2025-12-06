#!/bin/bash

# Compress Script - ضغط الملفات والأرشيف
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

# الإعدادات الافتراضية
DEFAULT_FORMAT="tar.gz"
DEFAULT_LEVEL=6

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

# دالة لحساب حجم الملف
get_file_size() {
    local file="$1"
    if [[ -f "$file" ]]; then
        du -h "$file" | cut -f1
    else
        echo "0"
    fi
}

# دالة لحساب نسبة الضغط
calculate_compression_ratio() {
    local original_size="$1"
    local compressed_size="$2"
    
    if [[ $original_size -eq 0 ]]; then
        echo "0"
        return
    fi
    
    local ratio=$(awk "BEGIN {printf \"%.1f\", (1 - $compressed_size / $original_size) * 100}")
    echo "$ratio"
}

# دالة لضغط ملف واحد بصيغة gzip
compress_gzip() {
    local input="$1"
    local output="$2"
    local level="${3:-$DEFAULT_LEVEL}"
    
    if [[ ! -f "$input" ]]; then
        print_error "الملف غير موجود: $input"
        return 1
    fi
    
    print_info "جاري الضغط بصيغة gzip (مستوى: $level)..."
    
    local original_size=$(stat -c%s "$input")
    
    if gzip -c -"$level" "$input" > "$output" 2>/dev/null; then
        local compressed_size=$(stat -c%s "$output")
        local ratio=$(calculate_compression_ratio "$original_size" "$compressed_size")
        
        print_success "تم الضغط بنجاح: $output"
        print_info "الحجم الأصلي: $(get_file_size "$input")"
        print_info "الحجم المضغوط: $(get_file_size "$output")"
        print_info "نسبة الضغط: ${ratio}%"
        return 0
    else
        print_error "فشل الضغط"
        return 1
    fi
}

# دالة لضغط مجلد بصيغة tar.gz
compress_tar_gz() {
    local input="$1"
    local output="$2"
    local level="${3:-$DEFAULT_LEVEL}"
    
    if [[ ! -d "$input" ]]; then
        print_error "المجلد غير موجود: $input"
        return 1
    fi
    
    print_info "جاري الضغط بصيغة tar.gz (مستوى: $level)..."
    
    local original_size=$(du -sb "$input" | cut -f1)
    
    if tar -czf "$output" --use-compress-program="gzip -$level" -C "$(dirname "$input")" "$(basename "$input")" 2>/dev/null; then
        local compressed_size=$(stat -c%s "$output")
        local ratio=$(calculate_compression_ratio "$original_size" "$compressed_size")
        
        print_success "تم الضغط بنجاح: $output"
        print_info "الحجم الأصلي: $(du -sh "$input" | cut -f1)"
        print_info "الحجم المضغوط: $(get_file_size "$output")"
        print_info "نسبة الضغط: ${ratio}%"
        return 0
    else
        print_error "فشل الضغط"
        return 1
    fi
}

# دالة لضغط بصيغة tar.bz2
compress_tar_bz2() {
    local input="$1"
    local output="$2"
    
    if [[ ! -d "$input" ]]; then
        print_error "المجلد غير موجود: $input"
        return 1
    fi
    
    print_info "جاري الضغط بصيغة tar.bz2..."
    
    local original_size=$(du -sb "$input" | cut -f1)
    
    if tar -cjf "$output" -C "$(dirname "$input")" "$(basename "$input")" 2>/dev/null; then
        local compressed_size=$(stat -c%s "$output")
        local ratio=$(calculate_compression_ratio "$original_size" "$compressed_size")
        
        print_success "تم الضغط بنجاح: $output"
        print_info "الحجم الأصلي: $(du -sh "$input" | cut -f1)"
        print_info "الحجم المضغوط: $(get_file_size "$output")"
        print_info "نسبة الضغط: ${ratio}%"
        return 0
    else
        print_error "فشل الضغط"
        return 1
    fi
}

# دالة لضغط بصيغة zip
compress_zip() {
    local input="$1"
    local output="$2"
    local level="${3:-$DEFAULT_LEVEL}"
    
    if [[ ! -e "$input" ]]; then
        print_error "المسار غير موجود: $input"
        return 1
    fi
    
    print_info "جاري الضغط بصيغة zip (مستوى: $level)..."
    
    local original_size
    if [[ -d "$input" ]]; then
        original_size=$(du -sb "$input" | cut -f1)
    else
        original_size=$(stat -c%s "$input")
    fi
    
    if zip -r -"$level" -q "$output" "$input" 2>/dev/null; then
        local compressed_size=$(stat -c%s "$output")
        local ratio=$(calculate_compression_ratio "$original_size" "$compressed_size")
        
        print_success "تم الضغط بنجاح: $output"
        if [[ -d "$input" ]]; then
            print_info "الحجم الأصلي: $(du -sh "$input" | cut -f1)"
        else
            print_info "الحجم الأصلي: $(get_file_size "$input")"
        fi
        print_info "الحجم المضغوط: $(get_file_size "$output")"
        print_info "نسبة الضغط: ${ratio}%"
        return 0
    else
        print_error "فشل الضغط"
        return 1
    fi
}

# دالة لفك الضغط
decompress() {
    local input="$1"
    local output_dir="${2:-.}"
    
    if [[ ! -f "$input" ]]; then
        print_error "الملف غير موجود: $input"
        return 1
    fi
    
    local extension="${input##*.}"
    
    print_info "جاري فك الضغط..."
    
    case "$extension" in
        gz|tgz)
            if tar -xzf "$input" -C "$output_dir" 2>/dev/null; then
                print_success "تم فك الضغط بنجاح إلى: $output_dir"
                return 0
            else
                print_error "فشل فك الضغط"
                return 1
            fi
            ;;
        bz2)
            if tar -xjf "$input" -C "$output_dir" 2>/dev/null; then
                print_success "تم فك الضغط بنجاح إلى: $output_dir"
                return 0
            else
                print_error "فشل فك الضغط"
                return 1
            fi
            ;;
        zip)
            if unzip -q "$input" -d "$output_dir" 2>/dev/null; then
                print_success "تم فك الضغط بنجاح إلى: $output_dir"
                return 0
            else
                print_error "فشل فك الضغط"
                return 1
            fi
            ;;
        *)
            print_error "صيغة غير مدعومة: $extension"
            return 1
            ;;
    esac
}

# دالة لعرض المساعدة
show_help() {
    cat << EOF
الاستخدام: $0 [OPTIONS] <INPUT> <OUTPUT>

ضغط وفك ضغط الملفات والمجلدات

الخيارات:
  -c, --compress          ضغط الملف أو المجلد
  -d, --decompress        فك ضغط الملف
  -f, --format FORMAT     صيغة الضغط (tar.gz, tar.bz2, zip, gzip)
  -l, --level LEVEL       مستوى الضغط (1-9، الافتراضي: 6)
  -h, --help              عرض هذه المساعدة

الصيغ المدعومة:
  tar.gz, tgz    - ضغط tar مع gzip (الافتراضي)
  tar.bz2        - ضغط tar مع bzip2
  zip            - ضغط zip
  gzip, gz       - ضغط gzip (للملفات فقط)

أمثلة:
  $0 -c logs/ logs_archive.tar.gz
  $0 -c -f zip logs/ logs_archive.zip
  $0 -c -l 9 logs/ logs_archive.tar.gz
  $0 -d logs_archive.tar.gz ./extracted/

EOF
}

# المعالجة الرئيسية
main() {
    if [[ $# -eq 0 ]]; then
        show_help
        exit 1
    fi
    
    local action=""
    local format="$DEFAULT_FORMAT"
    local level="$DEFAULT_LEVEL"
    local input=""
    local output=""
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c|--compress)
                action="compress"
                shift
                ;;
            -d|--decompress)
                action="decompress"
                shift
                ;;
            -f|--format)
                format="$2"
                shift 2
                ;;
            -l|--level)
                level="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                if [[ -z "$input" ]]; then
                    input="$1"
                elif [[ -z "$output" ]]; then
                    output="$1"
                fi
                shift
                ;;
        esac
    done
    
    if [[ -z "$action" ]]; then
        print_error "يجب تحديد الإجراء (-c أو -d)"
        exit 1
    fi
    
    if [[ -z "$input" ]]; then
        print_error "يجب تحديد المدخل"
        exit 1
    fi
    
    case "$action" in
        compress)
            if [[ -z "$output" ]]; then
                print_error "يجب تحديد اسم الملف المضغوط"
                exit 1
            fi
            
            case "$format" in
                tar.gz|tgz)
                    compress_tar_gz "$input" "$output" "$level"
                    ;;
                tar.bz2)
                    compress_tar_bz2 "$input" "$output"
                    ;;
                zip)
                    compress_zip "$input" "$output" "$level"
                    ;;
                gzip|gz)
                    compress_gzip "$input" "$output" "$level"
                    ;;
                *)
                    print_error "صيغة غير مدعومة: $format"
                    exit 1
                    ;;
            esac
            ;;
        decompress)
            decompress "$input" "${output:-.}"
            ;;
    esac
}

main "$@"
