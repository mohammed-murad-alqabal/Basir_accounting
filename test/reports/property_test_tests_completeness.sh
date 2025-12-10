#!/bin/bash

###############################################################################
# Property 8: Report Content Completeness - Tests
# الخاصية: التقارير يجب أن تتضمن نتائج الاختبارات ونسبة التغطية
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test_report_tests_$$"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASSED=0
FAILED=0
TOTAL_ITERATIONS=50

setup() {
    mkdir -p "$TEST_DIR"/{lib,test,logs/reports}
    cd "$TEST_DIR" || exit 1
    cp "$PROJECT_ROOT/scripts/generate_report.sh" "$TEST_DIR/"
    chmod +x generate_report.sh
    
    git init > /dev/null 2>&1
    git config user.email "test@example.com"
    git config user.name "Test"
    
    cat > pubspec.yaml << 'EOF'
name: test_project
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
dev_dependencies:
  flutter_test:
    sdk: flutter
EOF
    
    echo "test" > README.md
    git add .
    git commit -m "init" > /dev/null 2>&1
}

cleanup() {
    [ -d "$TEST_DIR" ] && rm -rf "$TEST_DIR"
}

trap cleanup EXIT

check_tests_section() {
    local report=$1
    
    grep -q "نتائج الاختبارات" "$report" && \
    grep -q "التغطية" "$report" && \
    grep -q "إجمالي الاختبارات" "$report"
}

run_test() {
    cat > lib/main.dart << 'EOF'
void main() {}
EOF
    
    git add . && git commit -m "add" > /dev/null 2>&1
    
    local report="logs/reports/test.md"
    ./generate_report.sh --output "$report" > /dev/null 2>&1
    
    [ -f "$report" ] && check_tests_section "$report"
}

main() {
    echo "Property 8: Report Content Completeness - Tests"
    echo ""
    
    setup
    
    for i in $(seq 1 $TOTAL_ITERATIONS); do
        if run_test; then
            ((PASSED++))
            [ $((i % 10)) -eq 0 ] && echo -e "${GREEN}  ✓ $i/$TOTAL_ITERATIONS${NC}"
        else
            ((FAILED++))
        fi
        rm -rf lib/* logs/reports/*
    done
    
    echo ""
    echo "نجح: $PASSED | فشل: $FAILED"
    
    [ $FAILED -eq 0 ] && echo -e "${GREEN}✅ PASSED${NC}" && exit 0
    echo -e "${RED}✗ FAILED${NC}" && exit 1
}

main
