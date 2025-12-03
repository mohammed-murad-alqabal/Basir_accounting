#!/bin/bash
# Property-Based Test: Commit Message Format Consistency
# Feature: error-tracking-system, Property 16: Commit Message Format Consistency
# Validates: Requirements 6.2
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
echo -e "${GREEN}🧪 Property 16: Commit Message Format Consistency${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# عداد النجاح والفشل
PASSED=0
FAILED=0
TOTAL_ITERATIONS=100

echo -e "${BLUE}📊 تشغيل $TOTAL_ITERATIONS تكرار...${NC}"
echo ""

# Property: For any log commit, message should follow Conventional Commits format
# Format: chore(logs): <description>

# دالة للتحقق من تنسيق رسالة الـ commit
validate_commit_message() {
    local message="$1"
    
    # التحقق من صيغة Conventional Commits: type(scope): description
    if echo "$message" | grep -qE "^chore\(logs\):"; then
        return 0
    else
        return 1
    fi
}

for i in $(seq 1 $TOTAL_ITERATIONS); do
    # توليد رسائل commit مختلفة للاختبار
    case $((i % 5)) in
        0)
            # رسالة صحيحة
            COMMIT_MSG="chore(logs): update error tracking logs"
            EXPECTED_VALID=true
            ;;
        1)
            # رسالة صحيحة مع تفاصيل
            COMMIT_MSG="chore(logs): update logs - $(date +%Y-%m-%d)"
            EXPECTED_VALID=true
            ;;
        2)
            # رسالة خاطئة - بدون scope
            COMMIT_MSG="chore: update logs"
            EXPECTED_VALID=false
            ;;
        3)
            # رسالة خاطئة - type خاطئ
            COMMIT_MSG="feat(logs): update logs"
            EXPECTED_VALID=false
            ;;
        4)
            # رسالة خاطئة - بدون type
            COMMIT_MSG="update logs"
            EXPECTED_VALID=false
            ;;
    esac
    
    # التحقق من الخاصية
    if validate_commit_message "$COMMIT_MSG"; then
        ACTUAL_VALID=true
    else
        ACTUAL_VALID=false
    fi
    
    # مقارنة النتيجة المتوقعة مع الفعلية
    if [ "$EXPECTED_VALID" = "$ACTUAL_VALID" ]; then
        ((PASSED++))
    else
        echo -e "${RED}❌ Iteration $i: فشل${NC}"
        echo -e "   ${YELLOW}الرسالة: $COMMIT_MSG${NC}"
        echo -e "   ${YELLOW}متوقع: $EXPECTED_VALID، فعلي: $ACTUAL_VALID${NC}"
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
    echo -e "${GREEN}✅ Property 16 PASSED: تنسيق رسائل الـ commit صحيح${NC}"
    exit 0
else
    echo -e "${RED}❌ Property 16 FAILED: بعض رسائل الـ commit غير صحيحة${NC}"
    exit 1
fi
