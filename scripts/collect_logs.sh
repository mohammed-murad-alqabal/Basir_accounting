#!/bin/bash
# Log Collection Script - Error Tracking System
# المشروع: بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 3 ديسمبر 2025

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# المتغيرات
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
LOGS_DIR="logs"
PUSH_TO_GIT=false

# معالجة الخيارات
while [[ $# -gt 0 ]]; do
    case $1 in
        --push)
            PUSH_TO_GIT=true
            shift
            ;;
        --help|-h)
            echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${GREEN}📊 سكريبت جمع السجلات${NC}"
            echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""
            echo -e "${BLUE}الاستخدام:${NC}"
            echo -e "  $0 [OPTIONS]"
            echo ""
            echo -e "${BLUE}الخيارات:${NC}"
            echo -e "  --push    دفع السجلات إلى Git بعد الجمع"
            echo -e "  --help    عرض هذه المساعدة"
            echo ""
            echo -e "${BLUE}أمثلة:${NC}"
            echo -e "  $0                # جمع السجلات فقط"
            echo -e "  $0 --push         # جمع ودفع إلى Git"
            echo ""
            echo -e "${BLUE}الوظائف:${NC}"
            echo -e "  ✅ جمع سجلات Flutter Analyze"
            echo -e "  ✅ جمع سجلات الاختبارات"
            echo -e "  ✅ تنظيف البيانات الحساسة"
            echo -e "  ✅ إزالة السجلات المكررة"
            echo -e "  ✅ دفع إلى Git (اختياري)"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}❌ خيار غير معروف: $1${NC}"
            echo -e "${YELLOW}استخدم --help لعرض المساعدة${NC}"
            exit 1
            ;;
    esac
done

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📊 جمع السجلات - Error Tracking System${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

START_TIME=$(date +%s)

# ===== 1. جمع سجلات Flutter Analyze =====
echo -e "${BLUE}🔬 جمع سجلات Flutter Analyze...${NC}"

ANALYZE_LOG="${LOGS_DIR}/flutter_analyze_${TIMESTAMP}.log"

if flutter analyze --no-pub > "$ANALYZE_LOG" 2>&1; then
    echo -e "${GREEN}✅ تم جمع سجلات التحليل (لا توجد أخطاء)${NC}"
else
    # حساب الأخطاء والتحذيرات
    ERROR_COUNT=$(grep -c "error •" "$ANALYZE_LOG" 2>/dev/null || echo "0")
    WARNING_COUNT=$(grep -c "warning •" "$ANALYZE_LOG" 2>/dev/null || echo "0")
    INFO_COUNT=$(grep -c "info •" "$ANALYZE_LOG" 2>/dev/null || echo "0")
    
    echo -e "${YELLOW}⚠️  تم جمع سجلات التحليل:${NC}"
    echo -e "   ${RED}• أخطاء: $ERROR_COUNT${NC}"
    echo -e "   ${YELLOW}• تحذيرات: $WARNING_COUNT${NC}"
    echo -e "   ${BLUE}• معلومات: $INFO_COUNT${NC}"
    
    # إضافة metadata للسجل
    {
        echo "# Flutter Analyze Log"
        echo "# Timestamp: $TIMESTAMP"
        echo "# Errors: $ERROR_COUNT"
        echo "# Warnings: $WARNING_COUNT"
        echo "# Info: $INFO_COUNT"
        echo "# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        cat "$ANALYZE_LOG"
    } > "${ANALYZE_LOG}.tmp"
    mv "${ANALYZE_LOG}.tmp" "$ANALYZE_LOG"
fi

echo ""

# ===== 2. جمع سجلات الاختبارات =====
echo -e "${BLUE}🧪 جمع سجلات الاختبارات...${NC}"

TEST_LOG="${LOGS_DIR}/flutter_test_${TIMESTAMP}.log"

if flutter test --no-pub > "$TEST_LOG" 2>&1; then
    # حساب الاختبارات
    PASSED_COUNT=$(grep -c "✓" "$TEST_LOG" 2>/dev/null || echo "0")
    
    echo -e "${GREEN}✅ تم جمع سجلات الاختبارات${NC}"
    echo -e "   ${GREEN}• اختبارات ناجحة: $PASSED_COUNT${NC}"
    
    # إضافة metadata
    {
        echo "# Flutter Test Log"
        echo "# Timestamp: $TIMESTAMP"
        echo "# Passed: $PASSED_COUNT"
        echo "# Failed: 0"
        echo "# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        cat "$TEST_LOG"
    } > "${TEST_LOG}.tmp"
    mv "${TEST_LOG}.tmp" "$TEST_LOG"
else
    FAILED_COUNT=$(grep -c "✗" "$TEST_LOG" 2>/dev/null || echo "0")
    PASSED_COUNT=$(grep -c "✓" "$TEST_LOG" 2>/dev/null || echo "0")
    
    echo -e "${RED}❌ بعض الاختبارات فشلت${NC}"
    echo -e "   ${GREEN}• ناجحة: $PASSED_COUNT${NC}"
    echo -e "   ${RED}• فاشلة: $FAILED_COUNT${NC}"
    
    # إضافة metadata
    {
        echo "# Flutter Test Log (FAILED)"
        echo "# Timestamp: $TIMESTAMP"
        echo "# Passed: $PASSED_COUNT"
        echo "# Failed: $FAILED_COUNT"
        echo "# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        cat "$TEST_LOG"
    } > "${TEST_LOG}.tmp"
    mv "${TEST_LOG}.tmp" "$TEST_LOG"
fi

echo ""

# ===== 3. تنظيف البيانات الحساسة =====
echo -e "${BLUE}🔐 تنظيف البيانات الحساسة...${NC}"

# قراءة أنماط الأسرار من التكوين
SENSITIVE_PATTERNS=(
    "password"
    "token"
    "api[_-]?key"
    "secret"
    "bearer"
)

SANITIZED_COUNT=0

for log_file in "$ANALYZE_LOG" "$TEST_LOG"; do
    if [ -f "$log_file" ]; then
        for pattern in "${SENSITIVE_PATTERNS[@]}"; do
            # استبدال القيم الحساسة بـ [REDACTED]
            if grep -iq "$pattern.*=.*['\"]" "$log_file"; then
                sed -i.bak "s/\($pattern.*=.*['\"][^'\"]*\)['\"]/**REDACTED**/gi" "$log_file"
                ((SANITIZED_COUNT++))
            fi
        done
        # حذف الملف الاحتياطي
        rm -f "${log_file}.bak"
    fi
done

if [ $SANITIZED_COUNT -gt 0 ]; then
    echo -e "${YELLOW}⚠️  تم تنظيف $SANITIZED_COUNT نمط حساس${NC}"
else
    echo -e "${GREEN}✅ لا توجد بيانات حساسة${NC}"
fi

echo ""

# ===== 4. إزالة التكرار =====
echo -e "${BLUE}🔄 إزالة السجلات المكررة...${NC}"

# البحث عن سجلات مشابهة
DUPLICATE_COUNT=0

for current_log in "$LOGS_DIR"/*.log; do
    if [ -f "$current_log" ] && [ "$current_log" != "$ANALYZE_LOG" ] && [ "$current_log" != "$TEST_LOG" ]; then
        # مقارنة الحجم والمحتوى
        if [ -f "$ANALYZE_LOG" ]; then
            if cmp -s "$current_log" "$ANALYZE_LOG" 2>/dev/null; then
                echo -e "${YELLOW}  • حذف مكرر: $(basename $current_log)${NC}"
                rm "$current_log"
                ((DUPLICATE_COUNT++))
            fi
        fi
    fi
done

if [ $DUPLICATE_COUNT -gt 0 ]; then
    echo -e "${YELLOW}⚠️  تم حذف $DUPLICATE_COUNT سجل مكرر${NC}"
else
    echo -e "${GREEN}✅ لا توجد سجلات مكررة${NC}"
fi

echo ""

# ===== 5. دفع إلى Git (اختياري) =====
if [ "$PUSH_TO_GIT" = true ]; then
    echo -e "${BLUE}📤 دفع السجلات إلى Git...${NC}"
    
    # التحقق من وجود تغييرات
    cd "$(git rev-parse --show-toplevel)" 2>/dev/null || {
        echo -e "${RED}❌ خطأ: المجلد الحالي ليس مستودع Git${NC}"
        exit 1
    }
    
    # التحقق من وجود ملفات جديدة أو معدلة
    if [ -z "$(git status --porcelain "$LOGS_DIR"/*.log 2>/dev/null)" ]; then
        echo -e "${YELLOW}ℹ️  لا توجد تغييرات جديدة في السجلات${NC}"
        echo -e "${BLUE}  • تم تخطي عملية الـ commit والـ push${NC}"
    else
        # عرض الملفات التي سيتم إضافتها
        echo -e "${BLUE}📝 الملفات المعدلة:${NC}"
        git status --porcelain "$LOGS_DIR"/*.log 2>/dev/null | while read -r line; do
            echo -e "   ${YELLOW}$line${NC}"
        done
        echo ""
        
        # إضافة السجلات إلى Git staging area
        if git add "$LOGS_DIR"/*.log 2>/dev/null; then
            echo -e "${GREEN}✅ تم إضافة السجلات إلى Git staging area${NC}"
        else
            echo -e "${RED}❌ فشل إضافة السجلات${NC}"
            exit 1
        fi
        
        # إنشاء commit بصيغة Conventional Commits
        COMMIT_MSG="chore(logs): update error tracking logs [skip ci]

- Updated Flutter Analyze logs
- Updated Test logs
- Timestamp: $TIMESTAMP"
        
        if git commit -m "$COMMIT_MSG" --no-verify 2>/dev/null; then
            echo -e "${GREEN}✅ تم إنشاء commit بنجاح${NC}"
            echo -e "${BLUE}  • الرسالة: chore(logs): update error tracking logs [skip ci]${NC}"
        else
            echo -e "${RED}❌ فشل إنشاء commit${NC}"
            exit 1
        fi
        
        # دفع إلى Git مع معالجة الأخطاء
        echo -e "${BLUE}🚀 جاري دفع التغييرات إلى Git...${NC}"
        
        if git push --no-verify 2>&1; then
            echo -e "${GREEN}✅ تم دفع السجلات إلى Git بنجاح${NC}"
        else
            PUSH_EXIT_CODE=$?
            echo -e "${YELLOW}⚠️  تحذير: فشل دفع السجلات إلى Git${NC}"
            echo -e "${YELLOW}  • رمز الخطأ: $PUSH_EXIT_CODE${NC}"
            echo -e "${YELLOW}  • السجلات محفوظة محلياً${NC}"
            echo -e "${YELLOW}  • يمكنك المحاولة يدوياً بـ: git push${NC}"
            # لا نخرج بخطأ لأن السجلات محفوظة محلياً
        fi
    fi
    
    echo ""
fi

# ===== النتيجة النهائية =====
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ اكتمل جمع السجلات بنجاح!${NC}"
echo -e "${GREEN}⏱️  الوقت المستغرق: ${DURATION} ثانية${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}📁 السجلات المحفوظة:${NC}"
echo -e "   • $ANALYZE_LOG"
echo -e "   • $TEST_LOG"
echo ""

exit 0
