#!/bin/bash

# =============================================================================
# مدير التخزين المؤقت (Cache Manager)
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# =============================================================================
# الوصف: نظام تخزين مؤقت لتحسين أداء العمليات المتكررة
# =============================================================================

# مجلد الكاش
CACHE_DIR="${CACHE_DIR:-.cache}"
CACHE_TTL="${CACHE_TTL:-3600}"  # مدة الصلاحية بالثواني (افتراضي: ساعة)

# إنشاء مجلد الكاش
mkdir -p "$CACHE_DIR" 2>/dev/null || true

# =============================================================================
# دوال التخزين المؤقت
# =============================================================================

# توليد مفتاح كاش من نص
cache_key() {
    local input="$1"
    echo -n "$input" | md5sum 2>/dev/null | cut -d' ' -f1 || echo "$input" | shasum | cut -d' ' -f1
}

# التحقق من وجود كاش صالح
cache_exists() {
    local key=$1
    local cache_file="$CACHE_DIR/$key"
    
    # التحقق من وجود الملف
    if [ ! -f "$cache_file" ]; then
        return 1
    fi
    
    # التحقق من صلاحية الكاش
    local file_time=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null || echo 0)
    local current_time=$(date +%s)
    local age=$((current_time - file_time))
    
    if [ $age -gt $CACHE_TTL ]; then
        # الكاش منتهي الصلاحية
        rm -f "$cache_file" 2>/dev/null || true
        return 1
    fi
    
    return 0
}

# قراءة من الكاش
cache_get() {
    local key=$1
    local cache_file="$CACHE_DIR/$key"
    
    if cache_exists "$key"; then
        cat "$cache_file"
        return 0
    fi
    
    return 1
}

# الكتابة إلى الكاش
cache_set() {
    local key=$1
    local value=$2
    local cache_file="$CACHE_DIR/$key"
    
    echo "$value" > "$cache_file" 2>/dev/null || return 1
    return 0
}

# حذف من الكاش
cache_delete() {
    local key=$1
    local cache_file="$CACHE_DIR/$key"
    
    rm -f "$cache_file" 2>/dev/null || true
    return 0
}

# مسح جميع الكاش
cache_clear() {
    rm -rf "$CACHE_DIR"/* 2>/dev/null || true
    return 0
}

# مسح الكاش المنتهي الصلاحية
cache_cleanup() {
    local current_time=$(date +%s)
    local deleted=0
    
    for cache_file in "$CACHE_DIR"/*; do
        if [ -f "$cache_file" ]; then
            local file_time=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null || echo 0)
            local age=$((current_time - file_time))
            
            if [ $age -gt $CACHE_TTL ]; then
                rm -f "$cache_file" 2>/dev/null && ((deleted++))
            fi
        fi
    done
    
    echo "$deleted"
    return 0
}

# الحصول على حجم الكاش
cache_size() {
    du -sh "$CACHE_DIR" 2>/dev/null | cut -f1 || echo "0"
}

# عدد عناصر الكاش
cache_count() {
    find "$CACHE_DIR" -type f 2>/dev/null | wc -l || echo "0"
}

# =============================================================================
# دوال مساعدة للاستخدام السهل
# =============================================================================

# تنفيذ أمر مع كاش
cached_command() {
    local command="$1"
    local cache_key_input="${2:-$command}"
    
    # توليد مفتاح الكاش
    local key=$(cache_key "$cache_key_input")
    
    # محاولة القراءة من الكاش
    if cache_get "$key"; then
        return 0
    fi
    
    # تنفيذ الأمر وحفظ النتيجة
    local result=$(eval "$command" 2>&1)
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        cache_set "$key" "$result"
        echo "$result"
    fi
    
    return $exit_code
}

# =============================================================================
# دوال خاصة بالمشروع
# =============================================================================

# كاش نتائج Flutter Analyze
cache_flutter_analyze() {
    local key="flutter_analyze_$(git rev-parse HEAD 2>/dev/null || echo 'no-git')"
    
    if cache_get "$key"; then
        return 0
    fi
    
    local result=$(flutter analyze --no-pub 2>&1)
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        cache_set "$key" "$result"
        echo "$result"
    fi
    
    return $exit_code
}

# كاش نتائج الاختبارات
cache_flutter_test() {
    local key="flutter_test_$(git rev-parse HEAD 2>/dev/null || echo 'no-git')"
    
    if cache_get "$key"; then
        return 0
    fi
    
    local result=$(flutter test --no-pub 2>&1)
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        cache_set "$key" "$result"
        echo "$result"
    fi
    
    return $exit_code
}

# كاش قائمة الملفات
cache_file_list() {
    local directory="${1:-.}"
    local pattern="${2:-*}"
    local key=$(cache_key "file_list_${directory}_${pattern}")
    
    if cache_get "$key"; then
        return 0
    fi
    
    local result=$(find "$directory" -name "$pattern" -type f 2>/dev/null)
    cache_set "$key" "$result"
    echo "$result"
    
    return 0
}

# =============================================================================
# معلومات الكاش
# =============================================================================

cache_info() {
    echo "═══ معلومات الكاش ═══"
    echo "المجلد: $CACHE_DIR"
    echo "مدة الصلاحية: $CACHE_TTL ثانية"
    echo "عدد العناصر: $(cache_count)"
    echo "الحجم: $(cache_size)"
    echo ""
}

# =============================================================================
# الاستخدام من سطر الأوامر
# =============================================================================

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    case "${1:-}" in
        get)
            cache_get "$2"
            ;;
        set)
            cache_set "$2" "$3"
            ;;
        delete)
            cache_delete "$2"
            ;;
        clear)
            cache_clear
            echo "تم مسح جميع الكاش"
            ;;
        cleanup)
            deleted=$(cache_cleanup)
            echo "تم حذف $deleted عنصر منتهي الصلاحية"
            ;;
        info)
            cache_info
            ;;
        *)
            echo "الاستخدام: $0 {get|set|delete|clear|cleanup|info} [args]"
            echo ""
            echo "الأوامر:"
            echo "  get KEY           - قراءة من الكاش"
            echo "  set KEY VALUE     - الكتابة إلى الكاش"
            echo "  delete KEY        - حذف من الكاش"
            echo "  clear             - مسح جميع الكاش"
            echo "  cleanup           - مسح الكاش المنتهي"
            echo "  info              - عرض معلومات الكاش"
            exit 1
            ;;
    esac
fi
