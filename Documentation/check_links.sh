#!/bin/bash

# سكريبت فحص الروابط الداخلية في مجلد Documentation
# المؤلف: فريق وكلاء تطوير مشروع بصير

echo "🔍 فحص الروابط الداخلية في مجلد Documentation..."
echo "=================================================="

# متغيرات العد
total_links=0
working_links=0
broken_links=0

# دالة فحص رابط واحد
check_link() {
    local file="$1"
    local link="$2"
    local base_dir=$(dirname "$file")
    
    # تحويل الرابط النسبي إلى مسار مطلق
    if [[ "$link" == ./* ]]; then
        target_path="$base_dir/${link#./}"
    elif [[ "$link" == ../* ]]; then
        target_path="$base_dir/$link"
    else
        target_path="$link"
    fi
    
    # تنظيف المسار
    target_path=$(realpath -m "$target_path" 2>/dev/null)
    
    if [[ -f "$target_path" ]]; then
        echo "✅ $file -> $link"
        ((working_links++))
    else
        echo "❌ $file -> $link (المسار: $target_path)"
        ((broken_links++))
    fi
    ((total_links++))
}

# البحث عن جميع الروابط الداخلية
echo "البحث عن الروابط الداخلية..."
echo ""

# فحص الروابط في جميع ملفات .md
find Documentation -name "*.md" -type f | while read -r file; do
    # استخراج الروابط الداخلية (التي تنتهي بـ .md وليست http)
    grep -oP '\[.*?\]\(\K[^)]*\.md(?=\))' "$file" 2>/dev/null | while read -r link; do
        # تجاهل الروابط الخارجية
        if [[ ! "$link" =~ ^https?:// ]]; then
            check_link "$file" "$link"
        fi
    done
done

echo ""
echo "=================================================="
echo "📊 ملخص النتائج:"
echo "إجمالي الروابط المفحوصة: $total_links"
echo "روابط تعمل: $working_links"
echo "روابط مكسورة: $broken_links"

if [ $broken_links -eq 0 ]; then
    echo "🎉 جميع الروابط تعمل بشكل صحيح!"
    exit 0
else
    echo "⚠️  يوجد $broken_links رابط مكسور يحتاج إصلاح"
    exit 1
fi