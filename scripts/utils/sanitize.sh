#!/bin/bash
# Sanitize Sensitive Data - Utility Script
# المشروع: بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير

# دالة لتنظيف ملف من البيانات الحساسة
sanitize_file() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "الملف غير موجود: $file"
        return 1
    fi
    
    # أنماط البيانات الحساسة
    local patterns=(
        "password"
        "token"
        "api[_-]?key"
        "secret"
        "bearer"
        "private[_-]?key"
        "access[_-]?token"
    )
    
    local sanitized=false
    
    for pattern in "${patterns[@]}"; do
        # استبدال القيم الحساسة
        if grep -iq "$pattern.*=.*['\"]" "$file"; then
            sed -i.bak "s/\($pattern.*=.*['\"][^'\"]*\)['\"]/**REDACTED**/gi" "$file"
            sanitized=true
        fi
    done
    
    # حذف الملف الاحتياطي
    rm -f "${file}.bak"
    
    if [ "$sanitized" = true ]; then
        echo "✅ تم تنظيف: $file"
        return 0
    else
        echo "ℹ️  لا توجد بيانات حساسة في: $file"
        return 0
    fi
}

# تصدير الدالة
export -f sanitize_file

# إذا تم استدعاء السكريبت مباشرة
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ $# -eq 0 ]; then
        echo "الاستخدام: $0 <file>"
        exit 1
    fi
    
    sanitize_file "$1"
fi
