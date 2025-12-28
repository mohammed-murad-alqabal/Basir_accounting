#!/bin/bash

# Flutter Test Coverage Analysis
# المشروع: بصير MVP - workspace-transformation
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# الألوان للمخرجات
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}📊 Flutter Test Coverage Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# متغيرات التحكم
COVERAGE_THRESHOLD=70
GENERATE_HTML=true
OPEN_REPORT=false
VERBOSE=false

# معالجة المعاملات
while [[ $# -gt 0 ]]; do
  case $1 in
    --threshold)
      COVERAGE_THRESHOLD="$2"
      shift 2
      ;;
    --html)
      GENERATE_HTML=true
      shift
      ;;
    --no-html)
      GENERATE_HTML=false
      shift
      ;;
    --open)
      OPEN_REPORT=true
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    --help)
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  --threshold N    Set coverage threshold (default: 70)"
      echo "  --html          Generate HTML report (default: true)"
      echo "  --no-html       Skip HTML report generation"
      echo "  --open          Open HTML report in browser"
      echo "  --verbose       Show detailed output"
      echo "  --help          Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# دالة لطباعة الأخطاء
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# دالة لطباعة النجاح
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# دالة لطباعة التحذيرات
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# دالة لطباعة المعلومات
print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# التحقق من وجود Flutter
if ! command -v flutter &> /dev/null; then
    print_error "Flutter not found. Please install Flutter first."
    exit 1
fi

# التحقق من وجود lcov (للـ HTML report)
if [ "$GENERATE_HTML" = true ] && ! command -v genhtml &> /dev/null; then
    print_warning "genhtml not found. HTML report will be skipped."
    print_info "Install lcov: sudo apt-get install lcov (Ubuntu) or brew install lcov (macOS)"
    GENERATE_HTML=false
fi

# إنشاء مجلد coverage إذا لم يكن موجوداً
mkdir -p coverage

echo -e "${YELLOW}🧪 Running Flutter tests with coverage...${NC}"

# تشغيل الاختبارات مع تجميع التغطية
START_TIME=$(date +%s)

if [ "$VERBOSE" = true ]; then
    flutter test --coverage --reporter=expanded
else
    flutter test --coverage --reporter=compact
fi

TEST_EXIT_CODE=$?
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

if [ $TEST_EXIT_CODE -ne 0 ]; then
    print_error "Tests failed. Coverage analysis aborted."
    exit $TEST_EXIT_CODE
fi

print_success "Tests completed in ${DURATION}s"

# التحقق من وجود ملف التغطية
if [ ! -f "coverage/lcov.info" ]; then
    print_error "Coverage file not found. Make sure tests ran successfully."
    exit 1
fi

echo -e "${YELLOW}📈 Analyzing coverage data...${NC}"

# تحليل التغطية باستخدام lcov
if command -v lcov &> /dev/null; then
    # إزالة الملفات المولدة والاختبارات من التقرير
    lcov --remove coverage/lcov.info \
        '**/*.g.dart' \
        '**/*.freezed.dart' \
        '**/*.mocks.dart' \
        '**/test/**' \
        '**/tests/**' \
        --output-file coverage/lcov_cleaned.info > /dev/null 2>&1

    # حساب إجمالي التغطية
    COVERAGE_SUMMARY=$(lcov --summary coverage/lcov_cleaned.info 2>&1)
    COVERAGE_PERCENTAGE=$(echo "$COVERAGE_SUMMARY" | grep -o 'lines......: [0-9.]*%' | grep -o '[0-9.]*')
    
    if [ -z "$COVERAGE_PERCENTAGE" ]; then
        print_warning "Could not parse coverage percentage"
        COVERAGE_PERCENTAGE="0"
    fi
else
    print_warning "lcov not found. Using basic coverage analysis."
    # تحليل أساسي بدون lcov
    TOTAL_LINES=$(grep -c "^SF:" coverage/lcov.info || echo "0")
    HIT_LINES=$(grep -c "^DA:" coverage/lcov.info | grep -v ",0$" || echo "0")
    
    if [ "$TOTAL_LINES" -gt 0 ]; then
        COVERAGE_PERCENTAGE=$(echo "scale=1; $HIT_LINES * 100 / $TOTAL_LINES" | bc -l 2>/dev/null || echo "0")
    else
        COVERAGE_PERCENTAGE="0"
    fi
fi

# عرض النتائج
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${PURPLE}📊 Coverage Report${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# تحديد لون النتيجة حسب العتبة
COVERAGE_INT=$(echo "$COVERAGE_PERCENTAGE" | cut -d. -f1)
if [ "$COVERAGE_INT" -ge "$COVERAGE_THRESHOLD" ]; then
    COVERAGE_COLOR=$GREEN
    COVERAGE_STATUS="✅ PASSED"
else
    COVERAGE_COLOR=$RED
    COVERAGE_STATUS="❌ FAILED"
fi

echo -e "📈 Total Coverage: ${COVERAGE_COLOR}${COVERAGE_PERCENTAGE}%${NC}"
echo -e "🎯 Target Threshold: ${COVERAGE_THRESHOLD}%"
echo -e "📊 Status: ${COVERAGE_STATUS}"
echo -e "⏱️  Test Duration: ${DURATION}s"

# إنشاء HTML report إذا طُلب
if [ "$GENERATE_HTML" = true ]; then
    echo -e "${YELLOW}🌐 Generating HTML coverage report...${NC}"
    
    if [ -f "coverage/lcov_cleaned.info" ]; then
        genhtml coverage/lcov_cleaned.info \
            --output-directory coverage/html \
            --title "بصير MVP - Test Coverage Report" \
            --show-details \
            --highlight \
            --legend \
            --quiet > /dev/null 2>&1
    else
        genhtml coverage/lcov.info \
            --output-directory coverage/html \
            --title "بصير MVP - Test Coverage Report" \
            --show-details \
            --highlight \
            --legend \
            --quiet > /dev/null 2>&1
    fi
    
    if [ $? -eq 0 ]; then
        print_success "HTML report generated: coverage/html/index.html"
        
        if [ "$OPEN_REPORT" = true ]; then
            if command -v xdg-open &> /dev/null; then
                xdg-open coverage/html/index.html
            elif command -v open &> /dev/null; then
                open coverage/html/index.html
            else
                print_info "Open coverage/html/index.html in your browser"
            fi
        fi
    else
        print_error "Failed to generate HTML report"
    fi
fi

# تحليل مفصل للملفات (إذا كان verbose مفعلاً)
if [ "$VERBOSE" = true ] && command -v lcov &> /dev/null; then
    echo -e "${YELLOW}📋 Detailed Coverage by File:${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    
    # استخراج تفاصيل التغطية لكل ملف
    lcov --list coverage/lcov_cleaned.info 2>/dev/null | grep -E "\.dart$" | head -20 | while read line; do
        if [[ $line == *".dart"* ]]; then
            FILE_PATH=$(echo "$line" | awk '{print $1}')
            COVERAGE=$(echo "$line" | awk '{print $2}')
            
            # تحديد اللون حسب التغطية
            COVERAGE_NUM=$(echo "$COVERAGE" | sed 's/%//')
            if (( $(echo "$COVERAGE_NUM >= 80" | bc -l) )); then
                COLOR=$GREEN
            elif (( $(echo "$COVERAGE_NUM >= 60" | bc -l) )); then
                COLOR=$YELLOW
            else
                COLOR=$RED
            fi
            
            echo -e "${COLOR}${COVERAGE}${NC} - $(basename "$FILE_PATH")"
        fi
    done
fi

# إحصائيات إضافية
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${PURPLE}📈 Additional Statistics${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# عدد ملفات الاختبار
TEST_FILES=$(find test -name "*.dart" -type f | wc -l)
echo -e "🧪 Test Files: ${TEST_FILES}"

# عدد الاختبارات (تقدير تقريبي)
if [ "$VERBOSE" = true ]; then
    TEST_COUNT=$(grep -r "test(" test --include="*.dart" | wc -l)
    echo -e "🔬 Estimated Tests: ${TEST_COUNT}"
fi

# حجم ملف التغطية
COVERAGE_SIZE=$(du -h coverage/lcov.info 2>/dev/null | cut -f1 || echo "N/A")
echo -e "📄 Coverage File Size: ${COVERAGE_SIZE}"

# توصيات للتحسين
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${PURPLE}💡 Recommendations${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

if [ "$COVERAGE_INT" -lt "$COVERAGE_THRESHOLD" ]; then
    NEEDED_IMPROVEMENT=$((COVERAGE_THRESHOLD - COVERAGE_INT))
    echo -e "${YELLOW}📈 Coverage needs improvement by ${NEEDED_IMPROVEMENT}%${NC}"
    echo -e "${CYAN}💡 Focus on:${NC}"
    echo -e "   • Add unit tests for business logic"
    echo -e "   • Add widget tests for UI components"
    echo -e "   • Add integration tests for user flows"
    echo -e "   • Test error handling and edge cases"
else
    echo -e "${GREEN}🎉 Great job! Coverage meets the target threshold${NC}"
    echo -e "${CYAN}💡 Consider:${NC}"
    echo -e "   • Adding more edge case tests"
    echo -e "   • Testing performance scenarios"
    echo -e "   • Adding golden file tests for UI consistency"
fi

echo -e "${BLUE}═══════════════════════════════════════${NC}"

# النتيجة النهائية
if [ "$COVERAGE_INT" -ge "$COVERAGE_THRESHOLD" ]; then
    print_success "Coverage analysis completed successfully!"
    exit 0
else
    print_error "Coverage below threshold (${COVERAGE_PERCENTAGE}% < ${COVERAGE_THRESHOLD}%)"
    exit 1
fi