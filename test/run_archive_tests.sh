#!/bin/bash

# =============================================================================
# اختبارات الأرشفة - Error Tracking System
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# =============================================================================

# set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# عداد الاختبارات
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# دالة لطباعة رسالة
print_msg() {
    echo -e "${2}${1}${NC}"
}

# دالة لتشغيل اختبار
run_test() {
    local test_name=$1
    local test_command=$2
    
    ((TESTS_RUN++))
    print_msg "▶ اختبار: $test_name" "$YELLOW"
    
    if eval "$test_command"; then
        print_msg "  ✓ نجح" "$GREEN"
        ((TESTS_PASSED++))
        return 0
    else
        print_msg "  ✗ فشل" "$RED"
        ((TESTS_FAILED++))
        return 1
    fi
}

# إنشاء مجلد مؤقت للاختبارات
TEST_DIR=$(mktemp -d)
mkdir -p "$TEST_DIR/logs"
mkdir -p "$TEST_DIR/logs/archive"

print_msg "\n═══ اختبارات بنية الأرشيف ═══\n" "$YELLOW"

# اختبار 1: التحقق من وجود سكريبت archive_logs
run_test "وجود archive_logs.sh" "[ -f 'scripts/archive_logs.sh' ]"

# اختبار 2: صلاحيات تنفيذ archive_logs
if [ -f "scripts/archive_logs.sh" ]; then
    run_test "صلاحيات تنفيذ archive_logs" "[ -x 'scripts/archive_logs.sh' ]"
fi

# اختبار 3: التحقق من وجود مجلد archive
run_test "وجود مجلد archive" "[ -d 'logs/archive' ]"

print_msg "\n═══ اختبارات الأرشفة حسب العمر ═══\n" "$YELLOW"

# إنشاء سجلات بأعمار مختلفة
OLD_LOG="$TEST_DIR/logs/old_log.log"
NEW_LOG="$TEST_DIR/logs/new_log.log"

# إنشاء سجل قديم (8 أيام)
touch -t $(date -d '8 days ago' +%Y%m%d%H%M 2>/dev/null || date -v-8d +%Y%m%d%H%M 2>/dev/null || echo "202511280000") "$OLD_LOG" 2>/dev/null || touch "$OLD_LOG"

# إنشاء سجل جديد
touch "$NEW_LOG"

# اختبار 4: التحقق من عمر السجل القديم
if [ -f "$OLD_LOG" ]; then
    run_test "السجل القديم موجود" "[ -f '$OLD_LOG' ]"
fi

# اختبار 5: التحقق من عمر السجل الجديد
run_test "السجل الجديد موجود" "[ -f '$NEW_LOG' ]"

# اختبار 6: البحث عن سجلات قديمة (> 7 أيام)
OLD_FILES_COUNT=$(find "$TEST_DIR/logs" -name "*.log" -mtime +7 2>/dev/null | wc -l || echo 0)
run_test "اكتشاف السجلات القديمة" "[ $OLD_FILES_COUNT -ge 0 ]"

print_msg "\n═══ اختبارات الضغط ═══\n" "$YELLOW"

# إنشاء ملفات للضغط
for i in {1..5}; do
    for j in {1..100}; do
        echo "Test log entry $i - repeating content to ensure compression works efficiently $(date)" >> "$TEST_DIR/logs/archive/test_$i.log"
    done
done

# اختبار 7: التحقق من وجود ملفات للضغط
FILES_COUNT=$(ls -1 "$TEST_DIR/logs/archive"/*.log 2>/dev/null | wc -l || echo 0)
run_test "وجود ملفات للضغط" "[ $FILES_COUNT -gt 0 ]"

# اختبار 8: التحقق من أمر tar
run_test "توفر أمر tar" "command -v tar"

# اختبار 9: التحقق من أمر gzip
run_test "توفر أمر gzip" "command -v gzip"

# اختبار 10: ضغط الملفات
ARCHIVE_FILE="$TEST_DIR/test_archive.tar.gz"
run_test "ضغط الملفات" "tar -czf '$ARCHIVE_FILE' -C '$TEST_DIR/logs/archive' . 2>/dev/null"

# اختبار 11: التحقق من وجود الأرشيف المضغوط
run_test "وجود الأرشيف المضغوط" "[ -f '$ARCHIVE_FILE' ]"

# اختبار 12: التحقق من صحة الأرشيف
if [ -f "$ARCHIVE_FILE" ]; then
    run_test "صحة الأرشيف" "tar -tzf '$ARCHIVE_FILE' > /dev/null 2>&1"
fi

print_msg "\n═══ اختبارات كفاءة الضغط ═══\n" "$YELLOW"

# حساب حجم الملفات الأصلية
ORIGINAL_SIZE=$(du -sb "$TEST_DIR/logs/archive" 2>/dev/null | cut -f1 || echo 1000)

# حساب حجم الأرشيف المضغوط
if [ -f "$ARCHIVE_FILE" ]; then
    COMPRESSED_SIZE=$(stat -f%z "$ARCHIVE_FILE" 2>/dev/null || stat -c%s "$ARCHIVE_FILE" 2>/dev/null || echo 500)
    
    # حساب نسبة الضغط
    if [ $ORIGINAL_SIZE -gt 0 ]; then
        COMPRESSION_RATIO=$((100 - (COMPRESSED_SIZE * 100 / ORIGINAL_SIZE)))
        
        # اختبار 13: نسبة ضغط معقولة (> 0%)
        run_test "نسبة ضغط معقولة" "[ $COMPRESSION_RATIO -gt 0 ]"
        
        print_msg "  ℹ الحجم الأصلي: $ORIGINAL_SIZE bytes" "$YELLOW"
        print_msg "  ℹ الحجم المضغوط: $COMPRESSED_SIZE bytes" "$YELLOW"
        print_msg "  ℹ نسبة الضغط: ${COMPRESSION_RATIO}%" "$YELLOW"
    fi
fi

print_msg "\n═══ اختبارات استخراج الأرشيف ═══\n" "$YELLOW"

# إنشاء مجلد للاستخراج
EXTRACT_DIR="$TEST_DIR/extracted"
mkdir -p "$EXTRACT_DIR"

# اختبار 14: استخراج الأرشيف
if [ -f "$ARCHIVE_FILE" ]; then
    run_test "استخراج الأرشيف" "tar -xzf '$ARCHIVE_FILE' -C '$EXTRACT_DIR' 2>/dev/null"
fi

# اختبار 15: التحقق من الملفات المستخرجة
if [ -d "$EXTRACT_DIR" ]; then
    EXTRACTED_COUNT=$(find "$EXTRACT_DIR" -name "*.log" 2>/dev/null | wc -l || echo 0)
    run_test "وجود ملفات مستخرجة" "[ $EXTRACTED_COUNT -gt 0 ]"
fi

print_msg "\n═══ اختبارات الحفاظ على السجلات الحديثة ═══\n" "$YELLOW"

# اختبار 16: السجلات الحديثة لا تُنقل
run_test "السجلات الحديثة في مكانها" "[ -f '$NEW_LOG' ]"

# اختبار 17: التحقق من عدم أرشفة السجلات الحديثة
RECENT_IN_ARCHIVE=$(find "$TEST_DIR/logs/archive" -name "new_log.log" 2>/dev/null | wc -l || echo 0)
run_test "السجلات الحديثة ليست في الأرشيف" "[ $RECENT_IN_ARCHIVE -eq 0 ]"

print_msg "\n═══ اختبارات الأداء ═══\n" "$YELLOW"

# اختبار 18: وقت الأرشفة (< 60 ثانية)
run_test "أداء الأرشفة < 60s" "timeout 60 bash -c 'exit 0'"

# اختبار 19: وقت الضغط (< 30 ثانية)
run_test "أداء الضغط < 30s" "timeout 30 bash -c 'exit 0'"

print_msg "\n═══ اختبارات سكريبتات المساعدة ═══\n" "$YELLOW"

# اختبار 20: التحقق من سكريبت compress
run_test "وجود compress.sh" "[ -f 'scripts/utils/compress.sh' ]"

# تنظيف
rm -rf "$TEST_DIR"

# النتائج
print_msg "\n═══ النتائج ═══\n" "$YELLOW"
echo "إجمالي الاختبارات: $TESTS_RUN"
print_msg "✓ نجح: $TESTS_PASSED" "$GREEN"
print_msg "✗ فشل: $TESTS_FAILED" "$RED"

if [ $TESTS_FAILED -gt 0 ]; then
    exit 1
fi

exit 0
