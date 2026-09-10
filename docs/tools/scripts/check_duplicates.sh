#!/bin/bash

# سكريبت فحص الملفات المكررة في مجلد Documentation
# المؤلف: فريق وكلاء تطوير مشروع بصير
# الإصدار: 1.0

echo "🔍 فحص الملفات المكررة في مجلد Documentation"
echo "=============================================="

# ألوان للإخراج
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ملف تقرير
report_file="docs/duplicates_report_$(date +%Y%m%d_%H%M%S).md"

# متغيرات العد
total_files=0
duplicate_groups=0
duplicate_files=0

# بداية التقرير
cat > "$report_file" << EOF
# تقرير فحص الملفات المكررة - $(date '+%d %B %Y - %H:%M')

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**النوع:** تقرير فحص الملفات المكررة التلقائي

---

## 📊 ملخص النتائج

EOF

echo "البحث عن الملفات المكررة بناءً على المحتوى..."
echo ""

# إنشاء ملف مؤقت للنتائج
temp_file=$(mktemp)

# حساب hash لكل ملف .md
find Documentation -name "*.md" -type f | while read -r file; do
    hash=$(md5sum "$file" | cut -d' ' -f1)
    echo "$hash:$file"
done | sort > "$temp_file"

# البحث عن المكررات
echo "### 🔍 الملفات المكررة المكتشفة" >> "$report_file"
echo "" >> "$report_file"

current_hash=""
current_group=()

while IFS=':' read -r hash file; do
    ((total_files++))
    
    if [ "$hash" = "$current_hash" ]; then
        # نفس الـ hash - ملف مكرر
        current_group+=("$file")
    else
        # hash جديد - معالجة المجموعة السابقة
        if [ ${#current_group[@]} -gt 1 ]; then
            ((duplicate_groups++))
            echo -e "${YELLOW}📁 مجموعة مكررة ${duplicate_groups}:${NC}"
            echo "" >> "$report_file"
            echo "#### مجموعة مكررة ${duplicate_groups}" >> "$report_file"
            echo "" >> "$report_file"
            
            for dup_file in "${current_group[@]}"; do
                echo -e "  ${RED}🔄${NC} $dup_file"
                echo "- \`$dup_file\`" >> "$report_file"
                ((duplicate_files++))
            done
            echo ""
        fi
        
        # بداية مجموعة جديدة
        current_hash="$hash"
        current_group=("$file")
    fi
done < "$temp_file"

# معالجة المجموعة الأخيرة
if [ ${#current_group[@]} -gt 1 ]; then
    ((duplicate_groups++))
    echo -e "${YELLOW}📁 مجموعة مكررة ${duplicate_groups}:${NC}"
    echo "" >> "$report_file"
    echo "#### مجموعة مكررة ${duplicate_groups}" >> "$report_file"
    echo "" >> "$report_file"
    
    for dup_file in "${current_group[@]}"; do
        echo -e "  ${RED}🔄${NC} $dup_file"
        echo "- \`$dup_file\`" >> "$report_file"
        ((duplicate_files++))
    done
fi

# فحص التشابه في الأسماء
echo ""
echo "البحث عن ملفات متشابهة الأسماء..."
echo ""

echo "" >> "$report_file"
echo "### 📝 ملفات متشابهة الأسماء" >> "$report_file"
echo "" >> "$report_file"

similar_names=0

# البحث عن أسماء متشابهة
find Documentation -name "*.md" -type f -printf "%f\n" | sort | uniq -c | while read -r count name; do
    if [ "$count" -gt 1 ]; then
        echo -e "${BLUE}📄 اسم متكرر:${NC} $name (${count} ملفات)"
        echo "- **$name** - $count ملفات:" >> "$report_file"
        
        find Documentation -name "$name" -type f | while read -r file; do
            echo -e "  ${BLUE}📍${NC} $file"
            echo "  - \`$file\`" >> "$report_file"
        done
        echo ""
        ((similar_names++))
    fi
done

# تنظيف الملف المؤقت
rm -f "$temp_file"

# إضافة الإحصائيات النهائية
cat >> "$report_file" << EOF

---

## 📈 الإحصائيات النهائية

| المعيار | العدد |
|---------|-------|
| إجمالي الملفات المفحوصة | $total_files |
| مجموعات الملفات المكررة | $duplicate_groups |
| إجمالي الملفات المكررة | $duplicate_files |
| أسماء ملفات متشابهة | $similar_names |

### 🎯 معدل التفرد

EOF

if [ $total_files -gt 0 ]; then
    unique_files=$((total_files - duplicate_files))
    uniqueness_rate=$(( (unique_files * 100) / total_files ))
    echo "**معدل تفرد الملفات:** ${uniqueness_rate}%" >> "$report_file"
else
    echo "**معدل تفرد الملفات:** لا توجد ملفات" >> "$report_file"
fi

echo "" >> "$report_file"
echo "**تاريخ الفحص:** $(date '+%d %B %Y - %H:%M')" >> "$report_file"
echo "**الأداة:** check_duplicates.sh v1.0" >> "$report_file"

echo ""
echo "=============================================="
echo -e "${BLUE}📊 ملخص النتائج:${NC}"
echo "إجمالي الملفات المفحوصة: $total_files"
echo "مجموعات الملفات المكررة: $duplicate_groups"
echo "إجمالي الملفات المكررة: $duplicate_files"

if [ $total_files -gt 0 ]; then
    unique_files=$((total_files - duplicate_files))
    uniqueness_rate=$(( (unique_files * 100) / total_files ))
    echo -e "معدل التفرد: ${GREEN}${uniqueness_rate}%${NC}"
else
    echo "معدل التفرد: لا توجد ملفات"
fi

echo ""
echo -e "${BLUE}📄 تقرير مفصل محفوظ في:${NC} $report_file"

if [ $duplicate_groups -eq 0 ]; then
    echo -e "${GREEN}🎉 لا توجد ملفات مكررة!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️ تم العثور على $duplicate_groups مجموعة من الملفات المكررة${NC}"
    echo -e "${BLUE}💡 نصيحة: راجع التقرير لتحديد الملفات التي يمكن أرشفتها أو دمجها${NC}"
    exit 0
fi