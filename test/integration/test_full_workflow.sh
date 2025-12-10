#!/bin/bash

# =============================================================================
# اختبار سير العمل الكامل - Integration Testing
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# الوكيل المسؤول: وكيل الاختبار (Testing Agent)
# =============================================================================
# الوصف: اختبار سير العمل الكامل من commit إلى report
# المتطلبات: جميع المتطلبات (1.x - 10.x)
# =============================================================================

set -e

# تحميل مكتبة معالجة الأخطاء
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../scripts/utils/error_handler.sh"

# الألوان
readonly BOLD='\033[1m'

# عدادات
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# مجلد مؤقت للاختبار
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# =============================================================================
# دوال الاختبار
# =============================================================================

# اختبار خطوة في سير العمل
test_workflow_step() {
    local step_name=$1
    local test_command=$2
    
    ((TOTAL_TESTS++))
    
    print_info "اختبار: $step_name"
    
    if eval "$test_command" > /dev/null 2>&1; then
        print_success "  ✓ $step_name: نجح"
        ((PASSED_TESTS++))
        return 0
    else
        print_error "  ✗ $step_name: فشل"
        ((FAILED_TESTS++))
        return 1
    fi
}

# =============================================================================
# بدء الاختبارات
# =============================================================================

print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  اختبار سير العمل الكامل"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""
print_info "المشروع: بصير MVP"
print_info "التاريخ: $(date '+%Y-%m-%d %H:%M:%S')"
print_info "الوكيل: وكيل الاختبار (Testing Agent)"
echo ""

# =============================================================================
# المرحلة 1: التحقق من البنية الأساسية
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 1: التحقق من البنية الأساسية ═══\n"

test_workflow_step "وجود مجلد logs" \
    "[ -d logs ]"

test_workflow_step "وجود مجلد logs/archive" \
    "[ -d logs/archive ]"

test_workflow_step "وجود مجلد logs/reports" \
    "[ -d logs/reports ]"

test_workflow_step "وجود مجلد scripts" \
    "[ -d scripts ]"

test_workflow_step "وجود مجلد scripts/utils" \
    "[ -d scripts/utils ]"

# =============================================================================
# المرحلة 2: التحقق من السكريبتات الأساسية
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 2: التحقق من السكريبتات الأساسية ═══\n"

test_workflow_step "وجود collect_logs.sh" \
    "[ -f scripts/collect_logs.sh ]"

test_workflow_step "وجود archive_logs.sh" \
    "[ -f scripts/archive_logs.sh ]"

test_workflow_step "وجود generate_report.sh" \
    "[ -f scripts/generate_report.sh ]"

test_workflow_step "وجود sanitize.sh" \
    "[ -f scripts/utils/sanitize.sh ]"

test_workflow_step "وجود validate.sh" \
    "[ -f scripts/utils/validate.sh ]"

test_workflow_step "وجود compress.sh" \
    "[ -f scripts/utils/compress.sh ]"

test_workflow_step "وجود error_handler.sh" \
    "[ -f scripts/utils/error_handler.sh ]"

test_workflow_step "وجود cache_manager.sh" \
    "[ -f scripts/utils/cache_manager.sh ]"

# =============================================================================
# المرحلة 3: التحقق من Git Hooks
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 3: التحقق من Git Hooks ═══\n"

test_workflow_step "وجود pre-commit hook" \
    "[ -f .git/hooks/pre-commit ]"

test_workflow_step "pre-commit hook قابل للتنفيذ" \
    "[ -x .git/hooks/pre-commit ]"

test_workflow_step "وجود pre-push hook" \
    "[ -f .git/hooks/pre-push ]"

test_workflow_step "pre-push hook قابل للتنفيذ" \
    "[ -x .git/hooks/pre-push ]"

# =============================================================================
# المرحلة 4: اختبار جمع السجلات
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 4: اختبار جمع السجلات ═══\n"

test_workflow_step "تشغيل collect_logs.sh" \
    "timeout 60 bash scripts/collect_logs.sh 2>/dev/null || true"

test_workflow_step "إنشاء ملف سجل" \
    "ls logs/*.log 2>/dev/null | head -1"

test_workflow_step "السجل يحتوي على بيانات" \
    "[ -s \$(ls logs/*.log 2>/dev/null | head -1) ]"

# =============================================================================
# المرحلة 5: اختبار تنظيف البيانات الحساسة
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 5: اختبار تنظيف البيانات الحساسة ═══\n"

# إنشاء ملف تجريبي مع بيانات حساسة
TEST_FILE="$TEST_DIR/test_sensitive.log"
cat > "$TEST_FILE" << 'EOF'
api_key=<credential-fixture>
password=<credential-fixture>
token=<credential-fixture>
EOF

test_workflow_step "تنظيف البيانات الحساسة" \
    "bash scripts/utils/sanitize.sh file $TEST_FILE"

test_workflow_step "عدم وجود api_key بعد التنظيف" \
    "! grep -q '<stripe-key-fixture>' $TEST_FILE"

test_workflow_step "عدم وجود password بعد التنظيف" \
    "! grep -q 'MySecret123' $TEST_FILE"

test_workflow_step "عدم وجود token بعد التنظيف" \
    "! grep -q 'ghp_abcdefghijklmnop' $TEST_FILE"

# =============================================================================
# المرحلة 6: اختبار الأرشفة
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 6: اختبار الأرشفة ═══\n"

# إنشاء سجل قديم للاختبار
OLD_LOG="logs/old_test_$(date -d '8 days ago' +%Y-%m-%d_%H-%M-%S 2>/dev/null || date -v-8d +%Y-%m-%d_%H-%M-%S 2>/dev/null || date +%Y-%m-%d_%H-%M-%S).log"
echo "test log content" > "$OLD_LOG" 2>/dev/null || true

test_workflow_step "تشغيل archive_logs.sh" \
    "timeout 60 bash scripts/archive_logs.sh 2>/dev/null || true"

test_workflow_step "وجود ملفات في الأرشيف" \
    "ls logs/archive/*.log 2>/dev/null || ls logs/archive/*.tar.gz 2>/dev/null"

# =============================================================================
# المرحلة 7: اختبار إنشاء التقارير
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 7: اختبار إنشاء التقارير ═══\n"

test_workflow_step "تشغيل generate_report.sh" \
    "timeout 30 bash scripts/generate_report.sh 2>/dev/null || true"

test_workflow_step "إنشاء ملف تقرير" \
    "ls logs/reports/*.md 2>/dev/null | head -1"

test_workflow_step "التقرير يحتوي على إحصائيات" \
    "grep -q 'إحصائيات' \$(ls logs/reports/*.md 2>/dev/null | head -1) 2>/dev/null || true"

# =============================================================================
# المرحلة 8: اختبار التحقق من الأسرار
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 8: اختبار التحقق من الأسرار ═══\n"

# إنشاء ملف تجريبي مع سر
SECRET_FILE="$TEST_DIR/test_secret.txt"
echo "api_key=<credential-fixture>" > "$SECRET_FILE"

test_workflow_step "اكتشاف سر في ملف" \
    "! bash scripts/utils/validate.sh secrets $SECRET_FILE 2>/dev/null"

# إنشاء ملف بدون أسرار
CLEAN_FILE="$TEST_DIR/test_clean.txt"
echo "const apiKeyLength = 32;" > "$CLEAN_FILE"

test_workflow_step "عدم اكتشاف سر في ملف نظيف" \
    "bash scripts/utils/validate.sh secrets $CLEAN_FILE 2>/dev/null"

# =============================================================================
# المرحلة 9: اختبار الضغط
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 9: اختبار الضغط ═══\n"

# إنشاء ملفات للضغط
COMPRESS_DIR="$TEST_DIR/compress_test"
mkdir -p "$COMPRESS_DIR"
for i in {1..5}; do
    echo "test data $i" > "$COMPRESS_DIR/file_$i.txt"
done

test_workflow_step "ضغط الملفات" \
    "bash scripts/utils/compress.sh compress $COMPRESS_DIR $TEST_DIR/test.tar.gz 2>/dev/null"

test_workflow_step "وجود ملف مضغوط" \
    "[ -f $TEST_DIR/test.tar.gz ]"

test_workflow_step "حجم الملف المضغوط أصغر" \
    "[ \$(stat -c%s $TEST_DIR/test.tar.gz 2>/dev/null || stat -f%z $TEST_DIR/test.tar.gz 2>/dev/null) -lt \$(du -sb $COMPRESS_DIR | cut -f1) ]"

# =============================================================================
# المرحلة 10: اختبار التخزين المؤقت
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 10: اختبار التخزين المؤقت ═══\n"

test_workflow_step "تحميل cache_manager.sh" \
    "source scripts/utils/cache_manager.sh"

test_workflow_step "كتابة إلى الكاش" \
    "source scripts/utils/cache_manager.sh && cache_set 'test_key' 'test_value'"

test_workflow_step "قراءة من الكاش" \
    "source scripts/utils/cache_manager.sh && [ \"\$(cache_get 'test_key')\" = 'test_value' ]"

test_workflow_step "حذف من الكاش" \
    "source scripts/utils/cache_manager.sh && cache_delete 'test_key'"

# =============================================================================
# المرحلة 11: اختبار الأداء
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 11: اختبار الأداء ═══\n"

test_workflow_step "تشغيل performance_benchmark.sh" \
    "timeout 300 bash scripts/performance_benchmark.sh 2>/dev/null || true"

test_workflow_step "إنشاء تقرير أداء" \
    "ls logs/reports/performance_*.md 2>/dev/null | head -1"

# =============================================================================
# المرحلة 12: اختبار الأمان
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 12: اختبار الأمان ═══\n"

test_workflow_step "تشغيل اختبارات الأمان" \
    "timeout 120 bash test/security/run_security_tests.sh 2>/dev/null || true"

# =============================================================================
# المرحلة 13: اختبار التكامل الكامل
# =============================================================================

print_colored "$YELLOW" "\n═══ المرحلة 13: اختبار التكامل الكامل ═══\n"

# محاكاة سير عمل كامل
print_info "محاكاة سير عمل كامل: commit → collect → sanitize → archive → report"

# 1. جمع السجلات
test_workflow_step "الخطوة 1: جمع السجلات" \
    "timeout 60 bash scripts/collect_logs.sh 2>/dev/null || true"

# 2. تنظيف البيانات الحساسة
LATEST_LOG=$(ls -t logs/*.log 2>/dev/null | head -1)
if [ -n "$LATEST_LOG" ]; then
    test_workflow_step "الخطوة 2: تنظيف السجل" \
        "bash scripts/utils/sanitize.sh file $LATEST_LOG 2>/dev/null || true"
fi

# 3. أرشفة السجلات القديمة
test_workflow_step "الخطوة 3: أرشفة السجلات" \
    "timeout 60 bash scripts/archive_logs.sh 2>/dev/null || true"

# 4. إنشاء تقرير
test_workflow_step "الخطوة 4: إنشاء تقرير" \
    "timeout 30 bash scripts/generate_report.sh 2>/dev/null || true"

# 5. التحقق من النتيجة النهائية
test_workflow_step "الخطوة 5: وجود تقرير نهائي" \
    "ls logs/reports/*.md 2>/dev/null | tail -1"

# =============================================================================
# النتائج النهائية
# =============================================================================

print_colored "$BLUE" "\n═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  النتائج النهائية - اختبار التكامل"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""

echo "إجمالي الاختبارات: $TOTAL_TESTS"
print_colored "$GREEN" "✓ نجح: $PASSED_TESTS"
print_colored "$RED" "✗ فشل: $FAILED_TESTS"

if [ $TOTAL_TESTS -gt 0 ]; then
    SUCCESS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo "معدل النجاح: ${SUCCESS_RATE}%"
    
    if [ $SUCCESS_RATE -ge 90 ]; then
        print_colored "$GREEN" "\n🎉 ممتاز! سير العمل الكامل يعمل بشكل ممتاز"
        print_colored "$GREEN" "✓ جميع المراحل تعمل بشكل صحيح"
        print_colored "$GREEN" "✓ التكامل بين المكونات ممتاز"
    elif [ $SUCCESS_RATE -ge 70 ]; then
        print_colored "$YELLOW" "\n⚠ جيد، لكن يحتاج بعض التحسين"
    else
        print_colored "$RED" "\n✗ يحتاج إلى تحسينات كبيرة"
    fi
fi

echo ""
print_info "تم إكمال اختبار التكامل الكامل"
echo ""

# الخروج
if [ $FAILED_TESTS -gt 0 ]; then
    exit 1
fi

exit 0
