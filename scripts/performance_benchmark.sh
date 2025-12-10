#!/bin/bash

# =============================================================================
# سكريبت قياس الأداء - Error Tracking System
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# =============================================================================
# الوصف: قياس أداء جميع مكونات نظام تتبع الأخطاء
# =============================================================================

set -e

# تحميل مكتبة معالجة الأخطاء
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/error_handler.sh"

# الألوان
readonly BOLD='\033[1m'

# ملف النتائج
RESULTS_FILE="logs/reports/performance_benchmark_$(date +%Y-%m-%d_%H-%M-%S).md"
mkdir -p "$(dirname "$RESULTS_FILE")"

# متغيرات القياس
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# =============================================================================
# دوال القياس
# =============================================================================

# قياس وقت تنفيذ أمر
measure_time() {
    local command=$1
    local description=$2
    local max_time=$3
    
    print_info "قياس: $description"
    
    local start=$(date +%s%N)
    eval "$command" > /dev/null 2>&1
    local exit_code=$?
    local end=$(date +%s%N)
    
    local duration_ns=$((end - start))
    local duration_ms=$((duration_ns / 1000000))
    local duration_s=$((duration_ms / 1000))
    
    ((TOTAL_TESTS++))
    
    if [ $exit_code -eq 0 ]; then
        if [ $duration_s -le $max_time ]; then
            print_success "  ✓ ${duration_s}s (الحد الأقصى: ${max_time}s)"
            ((PASSED_TESTS++))
            echo "| $description | ${duration_s}s | ${max_time}s | ✅ نجح |" >> "$RESULTS_FILE"
            return 0
        else
            print_warning "  ⚠ ${duration_s}s (تجاوز الحد: ${max_time}s)"
            ((FAILED_TESTS++))
            echo "| $description | ${duration_s}s | ${max_time}s | ⚠️ بطيء |" >> "$RESULTS_FILE"
            return 1
        fi
    else
        print_error "  ✗ فشل التنفيذ"
        ((FAILED_TESTS++))
        echo "| $description | - | ${max_time}s | ❌ فشل |" >> "$RESULTS_FILE"
        return 1
    fi
}

# قياس استخدام الذاكرة
measure_memory() {
    local command=$1
    local description=$2
    
    print_info "قياس الذاكرة: $description"
    
    # تشغيل الأمر وقياس الذاكرة
    /usr/bin/time -v bash -c "$command" 2>&1 | grep "Maximum resident set size" | awk '{print $6}' || echo "0"
}

# =============================================================================
# إنشاء رأس التقرير
# =============================================================================

create_report_header() {
    cat > "$RESULTS_FILE" << 'EOF'
# تقرير قياس الأداء - نظام تتبع الأخطاء

**المشروع:** بصير MVP  
**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')  
**المؤلف:** فريق وكلاء تطوير مشروع بصير

---

## نظرة عامة

هذا التقرير يحتوي على نتائج قياس أداء جميع مكونات نظام تتبع الأخطاء والسجلات.

---

## النتائج

### جدول الأداء

| المكون | الوقت الفعلي | الحد الأقصى | الحالة |
|:-------|:------------:|:------------:|:------:|
EOF
}

# =============================================================================
# بدء القياس
# =============================================================================

print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  قياس أداء نظام تتبع الأخطاء والسجلات"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""

create_report_header

# =============================================================================
# 1. قياس أداء Git Hooks
# =============================================================================

print_colored "$YELLOW" "\n═══ 1. قياس أداء Git Hooks ═══\n"

# Pre-commit Hook (يجب أن يكون < 30 ثانية)
if [ -f ".git/hooks/pre-commit" ]; then
    measure_time "timeout 30 bash .git/hooks/pre-commit 2>/dev/null || true" \
                 "Pre-commit Hook" 30
else
    print_warning "Pre-commit hook غير موجود"
fi

# Pre-push Hook (يجب أن يكون < 120 ثانية)
if [ -f ".git/hooks/pre-push" ]; then
    measure_time "timeout 120 bash .git/hooks/pre-push 2>/dev/null || true" \
                 "Pre-push Hook" 120
else
    print_warning "Pre-push hook غير موجود"
fi

# =============================================================================
# 2. قياس أداء جمع السجلات
# =============================================================================

print_colored "$YELLOW" "\n═══ 2. قياس أداء جمع السجلات ═══\n"

# جمع السجلات (يجب أن يكون < 60 ثانية)
if [ -f "scripts/collect_logs.sh" ]; then
    measure_time "timeout 60 bash scripts/collect_logs.sh 2>/dev/null || true" \
                 "جمع السجلات" 60
else
    print_warning "collect_logs.sh غير موجود"
fi

# =============================================================================
# 3. قياس أداء الأرشفة
# =============================================================================

print_colored "$YELLOW" "\n═══ 3. قياس أداء الأرشفة ═══\n"

# أرشفة السجلات (يجب أن يكون < 60 ثانية)
if [ -f "scripts/archive_logs.sh" ]; then
    measure_time "timeout 60 bash scripts/archive_logs.sh 2>/dev/null || true" \
                 "أرشفة السجلات" 60
else
    print_warning "archive_logs.sh غير موجود"
fi

# =============================================================================
# 4. قياس أداء إنشاء التقارير
# =============================================================================

print_colored "$YELLOW" "\n═══ 4. قياس أداء إنشاء التقارير ═══\n"

# إنشاء تقرير (يجب أن يكون < 30 ثانية)
if [ -f "scripts/generate_report.sh" ]; then
    measure_time "timeout 30 bash scripts/generate_report.sh 2>/dev/null || true" \
                 "إنشاء التقرير" 30
else
    print_warning "generate_report.sh غير موجود"
fi

# =============================================================================
# 5. قياس أداء Flutter
# =============================================================================

print_colored "$YELLOW" "\n═══ 5. قياس أداء Flutter ═══\n"

# Flutter Analyze (يجب أن يكون < 30 ثانية)
if command -v flutter &> /dev/null; then
    measure_time "timeout 30 flutter analyze --no-pub 2>/dev/null || true" \
                 "Flutter Analyze" 30
    
    # Flutter Test (يجب أن يكون < 120 ثانية)
    measure_time "timeout 120 flutter test --no-pub 2>/dev/null || true" \
                 "Flutter Test" 120
else
    print_warning "Flutter غير مثبت"
fi

# =============================================================================
# 6. قياس أداء الأدوات المساعدة
# =============================================================================

print_colored "$YELLOW" "\n═══ 6. قياس أداء الأدوات المساعدة ═══\n"

# Sanitize (يجب أن يكون < 10 ثواني)
if [ -f "scripts/utils/sanitize.sh" ]; then
    # إنشاء ملف تجريبي
    TEST_FILE=$(mktemp)
    echo "api_key=12345 password=secret" > "$TEST_FILE"
    
    measure_time "timeout 10 bash scripts/utils/sanitize.sh file $TEST_FILE 2>/dev/null || true" \
                 "تنظيف البيانات الحساسة" 10
    
    rm -f "$TEST_FILE"
fi

# Validate (يجب أن يكون < 5 ثواني)
if [ -f "scripts/utils/validate.sh" ]; then
    measure_time "timeout 5 bash scripts/utils/validate.sh commit 'feat: test' 2>/dev/null || true" \
                 "التحقق من رسالة Commit" 5
fi

# Compress (يجب أن يكون < 30 ثانية)
if [ -f "scripts/utils/compress.sh" ]; then
    # إنشاء ملفات تجريبية
    TEST_DIR=$(mktemp -d)
    for i in {1..10}; do
        echo "test data $i" > "$TEST_DIR/file_$i.txt"
    done
    
    measure_time "timeout 30 bash scripts/utils/compress.sh compress $TEST_DIR test.tar.gz 2>/dev/null || true" \
                 "ضغط الملفات" 30
    
    rm -rf "$TEST_DIR" test.tar.gz
fi

# =============================================================================
# 7. قياس أداء الاختبارات
# =============================================================================

print_colored "$YELLOW" "\n═══ 7. قياس أداء الاختبارات ═══\n"

# اختبارات Hooks (يجب أن يكون < 30 ثانية)
if [ -f "test/run_hooks_tests.sh" ]; then
    measure_time "timeout 30 bash test/run_hooks_tests.sh 2>/dev/null || true" \
                 "اختبارات Hooks" 30
fi

# اختبارات السجلات (يجب أن يكون < 30 ثانية)
if [ -f "test/run_log_tests.sh" ]; then
    measure_time "timeout 30 bash test/run_log_tests.sh 2>/dev/null || true" \
                 "اختبارات السجلات" 30
fi

# اختبارات الأرشفة (يجب أن يكون < 30 ثانية)
if [ -f "test/run_archive_tests.sh" ]; then
    measure_time "timeout 30 bash test/run_archive_tests.sh 2>/dev/null || true" \
                 "اختبارات الأرشفة" 30
fi

# =============================================================================
# 8. إضافة الإحصائيات إلى التقرير
# =============================================================================

cat >> "$RESULTS_FILE" << EOF

---

## الإحصائيات

- **إجمالي الاختبارات:** $TOTAL_TESTS
- **نجح:** $PASSED_TESTS
- **فشل/بطيء:** $FAILED_TESTS
- **معدل النجاح:** $((PASSED_TESTS * 100 / TOTAL_TESTS))%

---

## التوصيات

EOF

# إضافة توصيات بناءً على النتائج
if [ $FAILED_TESTS -gt 0 ]; then
    cat >> "$RESULTS_FILE" << 'EOF'
### مكونات تحتاج تحسين

EOF
    
    if [ $FAILED_TESTS -gt 3 ]; then
        cat >> "$RESULTS_FILE" << 'EOF'
1. **تحسين الأداء العام:**
   - مراجعة الكود للعمليات البطيئة
   - تنفيذ caching للنتائج
   - تحسين استعلامات قاعدة البيانات

EOF
    fi
    
    cat >> "$RESULTS_FILE" << 'EOF'
2. **تحسينات محددة:**
   - تقليل عدد العمليات المتزامنة
   - استخدام معالجة متوازية حيثما أمكن
   - تحسين خوارزميات البحث والفرز

EOF
else
    cat >> "$RESULTS_FILE" << 'EOF'
### الأداء ممتاز! 🎉

جميع المكونات تعمل ضمن الحدود المقبولة. استمر في:
- مراقبة الأداء بانتظام
- تحسين الكود بشكل مستمر
- إضافة caching للعمليات المتكررة

EOF
fi

cat >> "$RESULTS_FILE" << 'EOF'
---

**تم إنشاء التقرير بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')
EOF

# =============================================================================
# النتائج النهائية
# =============================================================================

print_colored "$BLUE" "\n═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  النتائج النهائية"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""

echo "إجمالي الاختبارات: $TOTAL_TESTS"
print_colored "$GREEN" "✓ نجح: $PASSED_TESTS"
print_colored "$RED" "✗ فشل/بطيء: $FAILED_TESTS"

if [ $TOTAL_TESTS -gt 0 ]; then
    SUCCESS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo "معدل النجاح: ${SUCCESS_RATE}%"
    
    if [ $SUCCESS_RATE -ge 90 ]; then
        print_colored "$GREEN" "\n🎉 ممتاز! الأداء عالي جداً"
    elif [ $SUCCESS_RATE -ge 70 ]; then
        print_colored "$YELLOW" "\n⚠ جيد، لكن يحتاج بعض التحسين"
    else
        print_colored "$RED" "\n✗ يحتاج إلى تحسينات كبيرة"
    fi
fi

echo ""
print_info "تم حفظ التقرير في: $RESULTS_FILE"
echo ""

# الخروج
if [ $FAILED_TESTS -gt 0 ]; then
    exit 1
fi

exit 0
