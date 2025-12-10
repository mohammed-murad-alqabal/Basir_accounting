#!/bin/bash

# نظام أرشفة السجلات - بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 4 ديسمبر 2025

set -e

# الألوان للإخراج
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# المتغيرات الأساسية
LOGS_DIR="logs"
ARCHIVE_DIR="logs/archive"
MAX_AGE_DAYS=7
MAX_ARCHIVE_SIZE_MB=10
COMPRESSION_FORMAT="tar.gz"

# إنشاء مجلد الأرشيف إذا لم يكن موجوداً
mkdir -p "$ARCHIVE_DIR"

# دالة لطباعة رسائل ملونة
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# دالة لنقل السجلات القديمة إلى الأرشيف
archive_old_logs() {
    print_message "$YELLOW" "🔄 جاري نقل السجلات القديمة (أكثر من ${MAX_AGE_DAYS} أيام)..."
    
    local count=0
    
    # البحث عن ملفات السجلات القديمة (باستثناء مجلد الأرشيف)
    while IFS= read -r -d '' file; do
        # التحقق من أن الملف ليس في مجلد الأرشيف
        if [[ ! "$file" =~ ^${ARCHIVE_DIR} ]]; then
            # نقل الملف إلى الأرشيف
            mv "$file" "$ARCHIVE_DIR/"
            ((count++))
            print_message "$GREEN" "  ✓ تم نقل: $(basename "$file")"
        fi
    done < <(find "$LOGS_DIR" -maxdepth 1 -name "*.log" -type f -mtime +${MAX_AGE_DAYS} -print0)
    
    if [ $count -eq 0 ]; then
        print_message "$YELLOW" "  ℹ️  لا توجد سجلات قديمة للنقل"
    else
        print_message "$GREEN" "✅ تم نقل ${count} ملف سجل إلى الأرشيف"
    fi
    
    return $count
}

# دالة لحساب حجم الأرشيف بالميجابايت
get_archive_size_mb() {
    local size_bytes=$(du -sb "$ARCHIVE_DIR" 2>/dev/null | cut -f1)
    local size_mb=$((size_bytes / 1024 / 1024))
    echo $size_mb
}

# دالة لضغط الأرشيف
compress_archive() {
    local archive_size=$(get_archive_size_mb)
    
    print_message "$YELLOW" "📊 حجم الأرشيف الحالي: ${archive_size} MB"
    
    if [ $archive_size -gt $MAX_ARCHIVE_SIZE_MB ]; then
        print_message "$YELLOW" "🗜️  جاري ضغط الأرشيف..."
        
        local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
        local archive_file="logs/archive_${timestamp}.${COMPRESSION_FORMAT}"
        
        # ضغط جميع ملفات السجلات في الأرشيف
        tar -czf "$archive_file" -C "$ARCHIVE_DIR" . 2>/dev/null
        
        if [ $? -eq 0 ]; then
            # حساب حجم الملف المضغوط
            local compressed_size=$(du -h "$archive_file" | cut -f1)
            local original_size="${archive_size}M"
            
            # حذف الملفات الأصلية بعد الضغط الناجح
            rm -f "$ARCHIVE_DIR"/*.log 2>/dev/null
            
            print_message "$GREEN" "✅ تم ضغط الأرشيف بنجاح"
            print_message "$GREEN" "  📦 الملف المضغوط: $archive_file"
            print_message "$GREEN" "  📏 الحجم الأصلي: $original_size"
            print_message "$GREEN" "  📏 الحجم المضغوط: $compressed_size"
            
            return 0
        else
            print_message "$RED" "❌ فشل ضغط الأرشيف"
            return 1
        fi
    else
        print_message "$GREEN" "✅ حجم الأرشيف ضمن الحد المسموح (${MAX_ARCHIVE_SIZE_MB} MB)"
        return 0
    fi
}

# دالة لاستخراج السجلات من الأرشيف
extract_archive() {
    local archive_file=$1
    
    if [ -z "$archive_file" ]; then
        print_message "$RED" "❌ يرجى تحديد ملف الأرشيف للاستخراج"
        echo "الاستخدام: $0 --extract <archive_file>"
        return 1
    fi
    
    if [ ! -f "$archive_file" ]; then
        print_message "$RED" "❌ ملف الأرشيف غير موجود: $archive_file"
        return 1
    fi
    
    print_message "$YELLOW" "📂 جاري استخراج الأرشيف: $archive_file"
    
    # إنشاء مجلد مؤقت للاستخراج
    local extract_dir="logs/extracted_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$extract_dir"
    
    # استخراج الأرشيف
    tar -xzf "$archive_file" -C "$extract_dir" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        local file_count=$(find "$extract_dir" -type f | wc -l)
        print_message "$GREEN" "✅ تم استخراج ${file_count} ملف إلى: $extract_dir"
        return 0
    else
        print_message "$RED" "❌ فشل استخراج الأرشيف"
        rm -rf "$extract_dir"
        return 1
    fi
}

# دالة لعرض معلومات الأرشيف
show_archive_info() {
    print_message "$YELLOW" "📊 معلومات الأرشيف:"
    
    # عدد ملفات السجلات في الأرشيف
    local log_count=$(find "$ARCHIVE_DIR" -name "*.log" -type f 2>/dev/null | wc -l)
    print_message "$GREEN" "  📄 عدد ملفات السجلات: $log_count"
    
    # عدد الملفات المضغوطة
    local compressed_count=$(find logs -maxdepth 1 -name "archive_*.${COMPRESSION_FORMAT}" -type f 2>/dev/null | wc -l)
    print_message "$GREEN" "  📦 عدد الملفات المضغوطة: $compressed_count"
    
    # حجم الأرشيف
    local archive_size=$(get_archive_size_mb)
    print_message "$GREEN" "  💾 حجم الأرشيف: ${archive_size} MB"
    
    # قائمة الملفات المضغوطة
    if [ $compressed_count -gt 0 ]; then
        print_message "$YELLOW" "\n📦 الملفات المضغوطة:"
        find logs -maxdepth 1 -name "archive_*.${COMPRESSION_FORMAT}" -type f -exec ls -lh {} \; | \
            awk '{print "  " $9 " (" $5 ")"}'
    fi
}

# دالة لعرض المساعدة
show_help() {
    echo "نظام أرشفة السجلات - بصير MVP"
    echo ""
    echo "الاستخدام:"
    echo "  $0                    # تشغيل الأرشفة التلقائية"
    echo "  $0 --extract <file>   # استخراج ملف أرشيف"
    echo "  $0 --info             # عرض معلومات الأرشيف"
    echo "  $0 --help             # عرض هذه المساعدة"
    echo ""
    echo "الإعدادات:"
    echo "  MAX_AGE_DAYS=$MAX_AGE_DAYS          # عمر السجلات للأرشفة (أيام)"
    echo "  MAX_ARCHIVE_SIZE_MB=$MAX_ARCHIVE_SIZE_MB   # الحد الأقصى لحجم الأرشيف (MB)"
    echo ""
}

# المعالج الرئيسي
main() {
    print_message "$GREEN" "═══════════════════════════════════════════"
    print_message "$GREEN" "   نظام أرشفة السجلات - بصير MVP"
    print_message "$GREEN" "═══════════════════════════════════════════"
    echo ""
    
    # معالجة المعاملات
    case "${1:-}" in
        --extract)
            extract_archive "$2"
            ;;
        --info)
            show_archive_info
            ;;
        --help|-h)
            show_help
            ;;
        "")
            # الأرشفة التلقائية
            archive_old_logs
            compress_archive
            echo ""
            show_archive_info
            ;;
        *)
            print_message "$RED" "❌ معامل غير معروف: $1"
            show_help
            exit 1
            ;;
    esac
    
    echo ""
    print_message "$GREEN" "═══════════════════════════════════════════"
    print_message "$GREEN" "✅ اكتملت عملية الأرشفة بنجاح"
    print_message "$GREEN" "═══════════════════════════════════════════"
}

# تشغيل البرنامج
main "$@"
