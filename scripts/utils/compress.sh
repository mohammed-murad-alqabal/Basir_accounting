#!/bin/bash
# Compression Utility - Error Tracking System
# المشروع: بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير

# دالة لضغط مجلد
compress_directory() {
    local source_dir="$1"
    local output_file="$2"
    
    if [ ! -d "$source_dir" ]; then
        echo "المجلد غير موجود: $source_dir"
        return 1
    fi
    
    # ضغط باستخدام tar + gzip
    if tar -czf "$output_file" -C "$source_dir" . 2>/dev/null; then
        # حساب نسبة الضغط
        local original_size=$(du -sk "$source_dir" | cut -f1)
        local compressed_size=$(du -sk "$output_file" | cut -f1)
        local ratio=$(( (original_size - compressed_size) * 100 / original_size ))
        
        echo "✅ تم الضغط بنجاح"
        echo "   • الحجم الأصلي: $((original_size / 1024)) MB"
        echo "   • الحجم المضغوط: $((compressed_size / 1024)) MB"
        echo "   • نسبة الضغط: ${ratio}%"
        return 0
    else
        echo "❌ فشل الضغط"
        return 1
    fi
}

# دالة لفك ضغط ملف
extract_archive() {
    local archive_file="$1"
    local output_dir="$2"
    
    if [ ! -f "$archive_file" ]; then
        echo "الملف غير موجود: $archive_file"
        return 1
    fi
    
    # إنشاء المجلد إذا لم يكن موجوداً
    mkdir -p "$output_dir"
    
    # فك الضغط
    if tar -xzf "$archive_file" -C "$output_dir" 2>/dev/null; then
        echo "✅ تم فك الضغط بنجاح إلى: $output_dir"
        return 0
    else
        echo "❌ فشل فك الضغط"
        return 1
    fi
}

# تصدير الدوال
export -f compress_directory
export -f extract_archive

# إذا تم استدعاء السكريبت مباشرة
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    case "${1:-}" in
        compress)
            compress_directory "$2" "$3"
            ;;
        extract)
            extract_archive "$2" "$3"
            ;;
        *)
            echo "الاستخدام:"
            echo "  $0 compress <source_dir> <output_file>"
            echo "  $0 extract <archive_file> <output_dir>"
            exit 1
            ;;
    esac
fi
