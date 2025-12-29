#!/bin/bash

# سكريبت فحص الروابط الداخلية المحسن في مجلد Documentation
# المؤلف: فريق وكلاء تطوير مشروع بصير
# الإصدار: 2.0 - محسن ومطور

echo "🔍 فحص الروابط الداخلية في مجلد Documentation (الإصدار المحسن)"
echo "=================================================================="

# متغيرات العد
total_links=0
working_links=0
broken_links=0
external_links=0

# ألوان للإخراج
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ملف تقرير مفصل
report_file="Documentation/links_report_$(date +%Y%m%d_%H%M%S).md"

# بداية التقرير
cat > "$report_file" << EOF
# تقرير فحص الروابط - $(date '+%d %B %Y - %H:%M')

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**النوع:** تقرير فحص الروابط التلقائي

---

## 📊 ملخص النتائج

EOF

# دالة فحص رابط واحد محسنة
check_link() {
    local file="$1"
    local link="$2"
    local base_dir=$(dirname "$file")
    
    # تحويل الرابط النسبي إلى مسار مطلق
    if [[ "$link" == ./* ]]; then
        target_path="$base_dir/${link#./}"
    elif [[ "$link" == ../* ]]; then
        target_path="$base_dir/$link"
    elif [[ "$link" == /* ]]; then
        target_path="$link"
    else
        # رابط نسبي بدون ./
        target_path="$base_dir/$link"
    fi
    
    # تنظيف المسار وحل الروابط النسبية
    target_path=$(realpath -m "$target_path" 2>/dev/null)
    
    if [[ -f "$target_path" ]]; then
        echo -e "${GREEN}✅${NC} $file -> $link"
        echo "- ✅ \`$file\` -> \`$link\`" >> "$report_file"
        ((working_links++))
    else
        echo -e "${RED}❌${NC} $file -> $link ${YELLOW}(المسار: $target_path)${NC}"
        echo "- ❌ \`$file\` -> \`$link\` (المسار المفقود: \`$target_path\`)" >> "$report_file"
        ((broken_links++))
    fi
    ((total_links++))
}

# فحص الروابط الخارجية
check_external_link() {
    local file="$1"
    local link="$2"
    
    echo -e "${BLUE}🌐${NC} $file -> $link (رابط خارجي)"
    echo "- 🌐 \`$file\` -> \`$link\` (رابط خارجي)" >> "$report_file"
    ((external_links++))
}

# البحث عن جميع الروابط
echo "البحث عن الروابط الداخلية والخارجية..."
echo ""

# إضافة قسم الروابط العاملة في التقرير
echo "### ✅ الروابط العاملة" >> "$report_file"
echo "" >> "$report_file"

# فحص الروابط في جميع ملفات .md
# فحص الروابط في جميع ملفات .md
while read -r file; do
    # استخراج جميع الروابط
    while read -r link; do
        if [[ "$link" =~ ^https?:// ]]; then
            # رابط خارجي
            check_external_link "$file" "$link"
        elif [[ "$link" =~ ^# ]]; then
            # رابط داخلي (anchor) - تجاهل
            :
        elif [[ "$link" =~ \.md$ ]]; then
            # رابط داخلي لملف markdown
            check_link "$file" "$link"
        fi
    done < <(grep -oP '\[.*?\]\(\K[^)]*(?=\))' "$file" 2>/dev/null)
done < <(find Documentation -name "*.md" -type f | sort)

# إضافة قسم الروابط المكسورة في التقرير
echo "" >> "$report_file"
echo "### ❌ الروابط المكسورة" >> "$report_file"
echo "" >> "$report_file"

# إضافة قسم الروابط الخارجية في التقرير
echo "" >> "$report_file"
echo "### 🌐 الروابط الخارجية" >> "$report_file"
echo "" >> "$report_file"

# إضافة الإحصائيات النهائية للتقرير
cat >> "$report_file" << EOF

---

## 📈 الإحصائيات النهائية

| النوع | العدد |
|-------|-------|
| إجمالي الروابط الداخلية | $total_links |
| الروابط العاملة | $working_links |
| الروابط المكسورة | $broken_links |
| الروابط الخارجية | $external_links |

### 🎯 معدل النجاح

EOF

if [ $total_links -gt 0 ]; then
    success_rate=$(( (working_links * 100) / total_links ))
    echo "**معدل نجاح الروابط الداخلية:** ${success_rate}%" >> "$report_file"
else
    echo "**معدل نجاح الروابط الداخلية:** لا توجد روابط داخلية" >> "$report_file"
fi

echo "" >> "$report_file"
echo "**تاريخ الفحص:** $(date '+%d %B %Y - %H:%M')" >> "$report_file"
echo "**الأداة:** check_links.sh v2.0" >> "$report_file"

echo ""
echo "=================================================================="
echo -e "${BLUE}📊 ملخص النتائج:${NC}"
echo "إجمالي الروابط الداخلية المفحوصة: $total_links"
echo "روابط تعمل: $working_links"
echo "روابط مكسورة: $broken_links"
echo "روابط خارجية: $external_links"

if [ $total_links -gt 0 ]; then
    success_rate=$(( (working_links * 100) / total_links ))
    echo -e "معدل النجاح: ${GREEN}${success_rate}%${NC}"
else
    echo "معدل النجاح: لا توجد روابط داخلية"
fi

echo ""
echo -e "${BLUE}📄 تقرير مفصل محفوظ في:${NC} $report_file"

if [ $broken_links -eq 0 ]; then
    echo -e "${GREEN}🎉 جميع الروابط الداخلية تعمل بشكل صحيح!${NC}"
    exit 0
else
    echo -e "${RED}⚠️  يوجد $broken_links رابط مكسور يحتاج إصلاح${NC}"
    exit 1
fi