#!/bin/bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🧪 Test Runner Script - بصير MVP
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 
# هذا السكريبت يقوم بتشغيل جميع الاختبارات وتوليد تقرير التغطية
# 
# الاستخدام:
#   ./test/run_tests.sh              # تشغيل جميع الاختبارات
#   ./test/run_tests.sh --coverage   # تشغيل مع التغطية
#   ./test/run_tests.sh --open       # فتح تقرير التغطية
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# الثوابت
MIN_COVERAGE=70

# دوال مساعدة
print_header() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${BLUE}$1${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# التحقق من وجود Flutter
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    
    print_success "Flutter found: $(flutter --version | head -n 1)"
}

# تنظيف الملفات القديمة
clean_old_files() {
    print_header "🧹 تنظيف الملفات القديمة"
    
    if [ -d "coverage" ]; then
        rm -rf coverage
        print_success "Removed old coverage directory"
    fi
    
    flutter clean > /dev/null 2>&1
    print_success "Flutter clean completed"
}

# تثبيت التبعيات
install_dependencies() {
    print_header "📦 تثبيت التبعيات"
    
    flutter pub get
    print_success "Dependencies installed"
}

# تشغيل التحليل
run_analysis() {
    print_header "🔍 تحليل الكود"
    
    if flutter analyze --fatal-infos --fatal-warnings; then
        print_success "Code analysis passed"
    else
        print_error "Code analysis failed"
        exit 1
    fi
}

# تشغيل الاختبارات
run_tests() {
    print_header "🧪 تشغيل الاختبارات"
    
    local coverage_flag=""
    if [ "$1" == "--with-coverage" ]; then
        coverage_flag="--coverage"
        print_info "Running tests with coverage..."
    else
        print_info "Running tests..."
    fi
    
    if flutter test $coverage_flag --reporter expanded; then
        print_success "All tests passed"
    else
        print_error "Some tests failed"
        exit 1
    fi
}

# توليد تقرير التغطية
generate_coverage_report() {
    print_header "📊 توليد تقرير التغطية"
    
    if [ ! -f "coverage/lcov.info" ]; then
        print_error "No coverage file found"
        return 1
    fi
    
    # التحقق من وجود lcov
    if ! command -v lcov &> /dev/null; then
        print_warning "lcov is not installed"
        print_info "Installing lcov..."
        
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            brew install lcov
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            sudo apt-get update && sudo apt-get install -y lcov
        else
            print_error "Unsupported OS for automatic lcov installation"
            print_info "Please install lcov manually"
            return 1
        fi
    fi
    
    # حساب التغطية
    COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep lines | awk '{print $2}' | sed 's/%//')
    
    echo ""
    print_info "Coverage: ${COVERAGE}%"
    print_info "Target: ${MIN_COVERAGE}%"
    echo ""
    
    # التحقق من التغطية
    if (( $(echo "$COVERAGE < $MIN_COVERAGE" | bc -l) )); then
        print_warning "Coverage is below target: ${COVERAGE}% < ${MIN_COVERAGE}%"
        print_info "Please add more tests to reach the target coverage"
    else
        print_success "Coverage meets target: ${COVERAGE}% ≥ ${MIN_COVERAGE}%"
    fi
    
    # توليد HTML report
    print_info "Generating HTML report..."
    
    if command -v genhtml &> /dev/null; then
        genhtml coverage/lcov.info -o coverage/html --quiet
        print_success "HTML report generated at coverage/html/index.html"
    else
        print_warning "genhtml is not installed (part of lcov)"
        print_info "HTML report not generated"
    fi
}

# فتح تقرير التغطية
open_coverage_report() {
    print_header "🌐 فتح تقرير التغطية"
    
    if [ ! -f "coverage/html/index.html" ]; then
        print_error "HTML report not found"
        print_info "Run with --coverage first to generate the report"
        return 1
    fi
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        open coverage/html/index.html
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        xdg-open coverage/html/index.html 2>/dev/null || \
        sensible-browser coverage/html/index.html 2>/dev/null || \
        print_warning "Could not open browser automatically"
    else
        print_warning "Unsupported OS for automatic browser opening"
    fi
    
    print_success "Coverage report opened in browser"
}

# الدالة الرئيسية
main() {
    print_header "🧪 Test Runner - بصير MVP"
    
    # معالجة المعاملات
    RUN_COVERAGE=false
    OPEN_REPORT=false
    
    for arg in "$@"; do
        case $arg in
            --coverage)
                RUN_COVERAGE=true
                ;;
            --open)
                OPEN_REPORT=true
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --coverage    Run tests with coverage"
                echo "  --open        Open coverage report in browser"
                echo "  --help        Show this help message"
                echo ""
                echo "Examples:"
                echo "  $0                    # Run all tests"
                echo "  $0 --coverage         # Run tests with coverage"
                echo "  $0 --coverage --open  # Run tests, generate and open report"
                echo ""
                exit 0
                ;;
            *)
                print_error "Unknown option: $arg"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    # تنفيذ الخطوات
    check_flutter
    clean_old_files
    install_dependencies
    run_analysis
    
    if [ "$RUN_COVERAGE" = true ]; then
        run_tests --with-coverage
        generate_coverage_report
        
        if [ "$OPEN_REPORT" = true ]; then
            open_coverage_report
        fi
    else
        run_tests
    fi
    
    # النتيجة النهائية
    print_header "✅ جميع الفحوصات نجحت"
    
    echo ""
    print_success "All checks passed successfully!"
    echo ""
    
    if [ "$RUN_COVERAGE" = true ]; then
        print_info "Coverage report: coverage/html/index.html"
    fi
    
    echo ""
}

# تشغيل السكريبت
main "$@"
