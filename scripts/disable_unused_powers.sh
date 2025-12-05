#!/bin/bash

# سكريبت تعطيل Powers غير المستخدمة
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

echo "🔧 بدء تعطيل Powers غير المستخدمة..."
echo ""

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# مسار Powers
POWERS_DIR="$HOME/.kiro/powers/installed"

# دالة لتعطيل Power
disable_power() {
    local power_name=$1
    local power_path="$POWERS_DIR/$power_name/mcp.json"
    
    if [ -f "$power_path" ]; then
        echo -e "${YELLOW}⚙️  معالجة $power_name...${NC}"
        
        # قراءة الملف وتعديل disabled إلى true
        if grep -q '"disabled"' "$power_path"; then
            # تحديث القيمة الموجودة
            sed -i 's/"disabled": false/"disabled": true/g' "$power_path"
            echo -e "${GREEN}✅ تم تعطيل $power_name${NC}"
        else
            echo -e "${YELLOW}⚠️  $power_name لا يحتوي على حقل disabled${NC}"
        fi
    else
        echo -e "${RED}❌ لم يتم العثور على $power_name${NC}"
    fi
    echo ""
}

# تعطيل Powers غير المستخدمة
echo "📋 Powers المراد تعطيلها:"
echo "  - aurora-dsql"
echo "  - saas-builder"
echo "  - terraform"
echo ""

# تعطيل Aurora DSQL
disable_power "aurora-dsql"

# تعطيل SaaS Builder
disable_power "saas-builder"

# تعطيل Terraform
disable_power "terraform"

# التحقق من Dynatrace (يجب أن يكون معطلاً مسبقاً)
echo -e "${YELLOW}🔍 التحقق من Dynatrace...${NC}"
if [ -f "$POWERS_DIR/dynatrace/mcp.json" ]; then
    if grep -q '"disabled": true' "$POWERS_DIR/dynatrace/mcp.json"; then
        echo -e "${GREEN}✅ Dynatrace معطل بالفعل${NC}"
    else
        echo -e "${YELLOW}⚠️  تعطيل Dynatrace...${NC}"
        disable_power "dynatrace"
    fi
else
    echo -e "${YELLOW}⚠️  Dynatrace غير موجود${NC}"
fi
echo ""

# التحقق من Strands (يجب أن يبقى مفعلاً)
echo -e "${YELLOW}🔍 التحقق من Strands...${NC}"
if [ -f "$POWERS_DIR/strands/mcp.json" ]; then
    if grep -q '"disabled": false' "$POWERS_DIR/strands/mcp.json"; then
        echo -e "${GREEN}✅ Strands مفعل (سيبقى للمستقبل)${NC}"
    else
        echo -e "${YELLOW}⚠️  Strands معطل، قد ترغب في تفعيله للمستقبل${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Strands غير موجود${NC}"
fi
echo ""

echo -e "${GREEN}✅ تم الانتهاء من تعطيل Powers غير المستخدمة${NC}"
echo ""
echo "📝 الملاحظات:"
echo "  - تم تعطيل Powers غير الضرورية للمرحلة الحالية"
echo "  - Strands محتفظ به للاستخدام المستقبلي"
echo "  - يمكنك إعادة تفعيل أي Power عند الحاجة"
echo ""
echo "🔄 يُنصح بإعادة تشغيل Kiro لتطبيق التغييرات"
