#!/bin/bash

# سكريبت تحديث التواريخ في ملفات Documentation
# المؤلف: فريق وكلاء تطوير مشروع بصير
# الإصدار: 1.0

echo "📅 تحديث التواريخ في ملفات Documentation"
echo "========================================="

# ألوان للإخراج
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# التاريخ الحالي بصيغ مختلفة
current_date_ar=$(date '+%d %B %Y' | sed 's/January/يناير/g; s/February/فبراير/g; s/March/مارس/g; s/April/أبريل/g; s/May/مايو/g; s/June/يونيو/g; s/July/يوليو/g; s/August/أغسطس/g; s/September/سبتمبر/g; s/October/أكتوبر/g; s/November/نوفمبر/g; s/December/ديسمبر/g')
current_date_en=$(date '+%d %B %Y')
current_date_iso=$(date '+%Y-%m-%d')

# متغيرات العد
total_files=0
updated_files=0
files_with_dates=0

# ملف تقرير
report_file="docs/date_update_report_$(date +%Y%m%d_%H%M%S).md"

# بداية التقرير
cat > "$report_file" << EOF
# تقرير تحديث التواريخ - $(date '+%d %B %Y - %H:%M')

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**النوع:** تقرير تحديث التواريخ التلقائي

---

## 📊 ملخص العملية

**التاريخ المستهدف:** $current_date_ar

EOF

echo "البحث عن ملفات تحتوي على تواريخ قديمة..."
echo ""

# دالة تحديث التواريخ في ملف واحد
update_file_dates() {
    local file="$1"
    local changes=0
    local temp_file=$(mktemp)
    
    echo -e "${BLUE}🔍${NC} فحص: $file"
    
    # نسخ الملف للتعديل
    cp "$file" "$temp_file"
    
    # تحديث "آخر تحديث:"
    if grep -q "آخر تحديث:" "$temp_file"; then
        sed -i "s/آخر تحديث:.*/آخر تحديث:** $current_date_ar/" "$temp_file"
        ((changes++))
        echo -e "  ${GREEN}✅${NC} تم تحديث 'آخر تحديث'"
    fi
    
    # تحديث "التاريخ:"
    if grep -q "التاريخ:" "$temp_file"; then
        # فقط إذا كان التاريخ قديم (ليس من هذا الشهر)
        current_month=$(date '+%m')
        current_year=$(date '+%Y')
        
        if ! grep -q "$current_year" "$temp_file" || ! grep -q "ديسمبر $current_year" "$temp_file"; then
            sed -i "s/التاريخ:.*/التاريخ:** $current_date_ar/" "$temp_file"
            ((changes++))
            echo -e "  ${GREEN}✅${NC} تم تحديث 'التاريخ'"
        fi
    fi
    
    # تحديث تواريخ إنجليزية
    if grep -q "Date:" "$temp_file"; then
        sed -i "s/Date:.*/Date:** $current_date_en/" "$temp_file"
        ((changes++))
        echo -e "  ${GREEN}✅${NC} تم تحديث 'Date'"
    fi
    
    # تحديث تواريخ ISO
    if grep -q "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}" "$temp_file"; then
        # فقط التواريخ القديمة
        if ! grep -q "$current_date_iso" "$temp_file"; then
            sed -i "s/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}/$current_date_iso/g" "$temp_file"
            ((changes++))
            echo -e "  ${GREEN}✅${NC} تم تحديث التواريخ بصيغة ISO"
        fi
    fi
    
    # إذا تم إجراء تغييرات، احفظ الملف
    if [ $changes -gt 0 ]; then
        mv "$temp_file" "$file"
        echo "- ✅ \`$file\` - تم تحديث $changes تاريخ" >> "$report_file"
        ((updated_files++))
        echo -e "  ${GREEN}💾 تم حفظ التغييرات ($changes تحديث)${NC}"
    else
        rm -f "$temp_file"
        echo -e "  ${YELLOW}ℹ️ لا يحتاج تحديث${NC}"
        echo "- ℹ️ \`$file\` - لا يحتاج تحديث" >> "$report_file"
    fi
    
    ((total_files++))
    if grep -q "التاريخ:\|آخر تحديث:\|Date:" "$file"; then
        ((files_with_dates++))
    fi
}

# معالجة جميع ملفات .md
echo "### 📝 الملفات المعالجة" >> "$report_file"
echo "" >> "$report_file"

find Documentation -name "*.md" -type f | sort | while read -r file; do
    update_file_dates "$file"
done

# إضافة الإحصائيات النهائية
cat >> "$report_file" << EOF

---

## 📈 الإحصائيات النهائية

| المعيار | العدد |
|---------|-------|
| إجمالي الملفات المفحوصة | $total_files |
| ملفات تحتوي على تواريخ | $files_with_dates |
| ملفات تم تحديثها | $updated_files |

### 🎯 معدل التحديث

EOF

if [ $files_with_dates -gt 0 ]; then
    update_rate=$(( (updated_files * 100) / files_with_dates ))
    echo "**معدل الملفات المحدثة:** ${update_rate}%" >> "$report_file"
else
    echo "**معدل الملفات المحدثة:** لا توجد ملفات بتواريخ" >> "$report_file"
fi

echo "" >> "$report_file"
echo "**تاريخ التحديث:** $(date '+%d %B %Y - %H:%M')" >> "$report_file"
echo "**الأداة:** update_dates.sh v1.0" >> "$report_file"

echo ""
echo "========================================="
echo -e "${BLUE}📊 ملخص النتائج:${NC}"
echo "إجمالي الملفات المفحوصة: $total_files"
echo "ملفات تحتوي على تواريخ: $files_with_dates"
echo "ملفات تم تحديثها: $updated_files"

if [ $files_with_dates -gt 0 ]; then
    update_rate=$(( (updated_files * 100) / files_with_dates ))
    echo -e "معدل التحديث: ${GREEN}${update_rate}%${NC}"
else
    echo "معدل التحديث: لا توجد ملفات بتواريخ"
fi

echo ""
echo -e "${BLUE}📄 تقرير مفصل محفوظ في:${NC} $report_file"

if [ $updated_files -gt 0 ]; then
    echo -e "${GREEN}🎉 تم تحديث $updated_files ملف بنجاح!${NC}"
    echo -e "${BLUE}💡 نصيحة: راجع الملفات المحدثة للتأكد من صحة التواريخ${NC}"
else
    echo -e "${GREEN}✅ جميع التواريخ محدثة بالفعل!${NC}"
fi

exit 0