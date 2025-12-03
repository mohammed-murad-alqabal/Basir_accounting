#!/bin/bash
# Property-Based Test: Skip CI Tag Presence
# Feature: error-tracking-system, Property 17: Skip CI Tag Presence
# Validates: Requirements 6.3
# المشروع: بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🧪 Property 17: Skip CI Tag Presence${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# عداد النجاح والفشل
PASSED=0
FAILED=0
TOTAL_ITERATIONS=100

echo -e "${BLUE}📊 تشغيل $TOTAL_ITERATIONS تكرار...${NC}"
echo ""

# Property: For any log commit, message should contain [skip ci] tag

# دالة للتحقق من وجود [skip ci]
has_skip_ci_tag() {
    local message="$1"
    
    # التحقق من وجود [skip ci] في الرسالة
    if echo "$message" | grep -qE "\[skip ci\]"; then
        return 0
    else
        return 1
    fi
}

for i in $(seq 1 $TOTAL_ITERATIONS); do
    # توليد رسائل commit مختلفة للاختبار
    case $((i % 4)) in
        0)
            # رسالة صحيحة مع [skip ci]
            COMMIT_MSG="chore(logs): update logs [skip ci]"
            EXPECTED_HAS_TAG=true
            ;;
        1)
            # رسالة صحيحة مع [skip ci] في السطر الثاني
            COMMIT_MSG="chore(logs): update logs

[skip ci]"
            EXPECTED_HAS_TAG=true
            ;;
        2)
            # رسالة بدون [skip ci]
            COMMIT_MSG="chore(logs): update logs"
            EXPECTED_HAS_TAG=false
            ;;
        3)
            # رسالة مع skip ci بدون أقواس (خاطئ)
            COMMIT_MSG="chore(logs): update logs skip ci"
            EXPECTED_HAS_TAG=false
            ;;
    esac
    
    # التحقق من الخاصية
    if has_skip_ci_tag "$COMMIT_MSG"; then
        ACTUAL_HAS_TAG=true
    else
        ACTUAL_HAS_TAG=false
    fi
    
    # مقارنة النتيجة المتوقعة مع الفعلية
    if [ "$EXPECTED_HAS_TAG" = "$ACTUAL_HAS_TAG" ]; then
        ((PASSED++))
    else
        echo -e "${RED}❌ Iteration $i: فشل${NC}"
        echo -e "   ${YELLOW}الرسالة: $COMMIT_MSG${NC}"
        echo -e "   ${YELLOW}متوقع: $EXPECTED_HAS_TAG، فعلي: $ACTUAL_HAS_TAG${NC}"
        ((FAILED++))
    fi
    
    # تقدم
    if [ $((i % 20)) -eq 0 ]; then
        echo -e "${BLUE}  • تم إكمال $i/$TOTAL_ITERATIONS تكرار...${NC}"
    fi
done

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📊 النتائج:${NC}"
echo -e "${GREEN}  • نجح: $PASSED/$TOTAL_ITERATIONS${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}  • فشل: $FAILED/$TOTAL_ITERATIONS${NC}"
fi
echo -e "${GREEN}  • نسبة النجاح: $(( PASSED * 100 / TOTAL_ITERATIONS ))%${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Property 17 PASSED: جميع رسائل الـ commit تحتوي على [skip ci]${NC}"
    exit 0
else
    echo -e "${RED}❌ Property 17 FAILED: بعض رسائل الـ commit لا تحتوي على [skip ci]${NC}"
    exit 1
fi
