#!/bin/bash

# سكريبت فحص تنسيق Markdown في مجلد Documentation
# المؤلف: فريق وكلاء تطوير مشروع بصير
# الإصدار: 1.0

echo "📝 فحص تنسيق ملفات Markdown في مجلد Documentation"
echo "=================================================="

# متغيرات العد
total_files=0
valid_files=0
files_with_issues=0

# ألوان للإخراج
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ملف تقرير
report_file="Documentation/markdown_report_$(date +%Y%m%d_%H%M%S).md"

# بداية التقرير
cat > "$report_file" << EOF
# تقرير فحص تنسيق Markdown - $(date '+%d %B %Y - %H:%M')

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**النوع:** تقرير فحص تنسيق Markdown التلقائي

---

## 📊 ملخص النتائج

EOF

# دالة فحص ملف واحد
check_markdown_file() {
    local file="$1"
    local issues=0
    local warnings=()
    
    echo -e "${BLUE}🔍${NC} فحص: $file"
    
    # فحص وجود عنوان رئيسي
    if ! grep -q "^# " "$file"; then
        warnings+=("❌ لا يوجد عنوان رئيسي (H1)")
        ((issues++))
    fi
    
    # فحص التواريخ
    if grep -q "التاريخ:" "$file" && ! grep -q "$(date +%Y)" "$file"; then
        warnings+=("⚠️ قد يحتوي على تاريخ قديم")
    fi
    
    # فحص الجداول المكسورة
    if grep -q "|" "$file"; then
        # فحص بسيط للجداول
        table_lines=$(grep "|" "$file" | wc -l)
        if [ $table_lines -gt 0 ]; then
            # فحص وجود خط فاصل للجدول
            if ! grep -q "|\s*[-:]\+\s*|" "$file"; then
                warnings+=("⚠️ قد يحتوي على جداول بدون خط فاصل")
            fi
        fi
    fi
    
    # فحص الروابط المكسورة البسيط
    broken_link_count=$(grep -o "\[.*\](.*)" "$file" | grep -c "]()" || true)
    if [ $broken_link_count -gt 0 ]; then
        warnings+=("❌ يحتوي على $broken_link_count رابط فارغ")
        ((issues++))
    fi
    
    # فحص العناوين المتتالية
    if grep -Pzo "^#{1,6} .*\n^#{1,6} " "$file" > /dev/null 2>&1; then
        warnings+=("⚠️ قد يحتوي على عناوين متتالية بدون محتوى")
    fi
    
    # عرض النتائج
    if [ ${#warnings[@]} -eq 0 ]; then
        echo -e "  ${GREEN}✅ الملف سليم${NC}"
        echo "- ✅ \`$file\` - سليم" >> "$report_file"
        ((valid_files++))
    else
        echo -e "  ${YELLOW}⚠️ يحتوي على ${#warnings[@]} تحذير/مشكلة${NC}"
        echo "- ⚠️ \`$file\` - ${#warnings[@]} مشكلة:" >> "$report_file"
        for warning in "${warnings[@]}"; do
            echo -e "    $warning"
            echo "  - $warning" >> "$report_file"
        done
        if [ $issues -gt 0 ]; then
            ((files_with_issues++))
        fi
    fi
    
    ((total_files++))
}

echo "البحث عن ملفات Markdown وفحصها..."
echo ""

# إضافة قسم الملفات السليمة
echo "### ✅ الملفات السليمة" >> "$report_file"
echo "" >> "$report_file"

# فحص جميع ملفات .md
find Documentation -name "*.md" -type f | sort | while read -r file; do
    check_markdown_file "$file"
done

# إضافة قسم الملفات مع المشاكل
echo "" >> "$report_file"
echo "### ⚠️ الملفات مع المشاكل" >> "$report_file"
echo "" >> "$report_file"

# إضافة الإحصائيات النهائية
cat >> "$report_file" << EOF

---

## 📈 الإحصائيات النهائية

| المعيار | العدد |
|---------|-------|
| إجمالي الملفات | $total_files |
| ملفات سليمة | $valid_files |
| ملفات مع مشاكل | $files_with_issues |

### 🎯 معدل الجودة

EOF

if [ $total_files -gt 0 ]; then
    quality_rate=$(( (valid_files * 100) / total_files ))
    echo "**معدل جودة التنسيق:** ${quality_rate}%" >> "$report_file"
else
    echo "**معدل جودة التنسيق:** لا توجد ملفات" >> "$report_file"
fi

echo "" >> "$report_file"
echo "**تاريخ الفحص:** $(date '+%d %B %Y - %H:%M')" >> "$report_file"
echo "**الأداة:** check_markdown.sh v1.0" >> "$report_file"

echo ""
echo "=================================================="
echo -e "${BLUE}📊 ملخص النتائج:${NC}"
echo "إجمالي الملفات المفحوصة: $total_files"
echo "ملفات سليمة: $valid_files"
echo "ملفات مع مشاكل: $files_with_issues"

if [ $total_files -gt 0 ]; then
    quality_rate=$(( (valid_files * 100) / total_files ))
    echo -e "معدل الجودة: ${GREEN}${quality_rate}%${NC}"
else
    echo "معدل الجودة: لا توجد ملفات"
fi

echo ""
echo -e "${BLUE}📄 تقرير مفصل محفوظ في:${NC} $report_file"

if [ $files_with_issues -eq 0 ]; then
    echo -e "${GREEN}🎉 جميع ملفات Markdown بتنسيق سليم!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️ يوجد $files_with_issues ملف يحتاج مراجعة${NC}"
    exit 0  # لا نعتبر هذا خطأ فادح
fi