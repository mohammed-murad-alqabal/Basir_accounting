#!/bin/bash

# Comprehensive Flutter Analysis Hook
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 18 ديسمبر 2025

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

echo "🔍 Comprehensive Flutter Analysis"
echo "════════════════════════════════════════════════════════════════"

# إنشاء مجلد التقارير
mkdir -p .kiro/reports/analysis

REPORT_FILE=".kiro/reports/analysis/comprehensive_analysis_$(date +%Y%m%d_%H%M%S).md"

# بدء التقرير
cat > "$REPORT_FILE" << EOF
# Comprehensive Flutter Analysis Report

**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')
**المؤلف:** فريق وكلاء تطوير مشروع بصير

---

## Analysis Results

EOF

# 1. Flutter Analyze
print_info "Running flutter analyze..."
ANALYZE_OUTPUT=$(mktemp)
if flutter analyze --no-fatal-infos > "$ANALYZE_OUTPUT" 2>&1; then
    ANALYZE_STATUS="✅ Clean"
    ANALYZE_ISSUES=0
else
    ANALYZE_STATUS="⚠️ Issues Found"
    ANALYZE_ISSUES=$(grep -c "error •" "$ANALYZE_OUTPUT" 2>/dev/null || echo "0")
fi

cat >> "$REPORT_FILE" << EOF
### 1. Flutter Analyze
- **Status:** $ANALYZE_STATUS
- **Issues Found:** $ANALYZE_ISSUES
- **Details:** See analyze_output.txt

EOF

cp "$ANALYZE_OUTPUT" ".kiro/reports/analysis/analyze_output.txt"
rm "$ANALYZE_OUTPUT"

print_status "Flutter analyze completed: $ANALYZE_STATUS"

# 2. Code Metrics
print_info "Calculating code metrics..."

DART_FILES=$(find lib/ -name "*.dart" | wc -l 2>/dev/null || echo "0")
TOTAL_LINES=$(find lib/ -name "*.dart" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
AVG_LINES=$((TOTAL_LINES / (DART_FILES > 0 ? DART_FILES : 1)))

# حساب complexity (تقريبي بناءً على عدد الأقواس والشروط)
COMPLEXITY=$(grep -r -E "(if|for|while|switch|catch)" lib/ | wc -l 2>/dev/null || echo "0")

cat >> "$REPORT_FILE" << EOF
### 2. Code Metrics
- **Dart Files:** $DART_FILES
- **Total Lines:** $TOTAL_LINES
- **Average Lines per File:** $AVG_LINES
- **Estimated Complexity:** $COMPLEXITY control structures

EOF

print_status "Code metrics calculated"

# 3. Code Quality Checks
print_info "Running code quality checks..."

# TODO/FIXME comments
TODO_COUNT=$(grep -r "TODO" lib/ | wc -l 2>/dev/null || echo "0")
FIXME_COUNT=$(grep -r "FIXME" lib/ | wc -l 2>/dev/null || echo "0")
HACK_COUNT=$(grep -r "HACK" lib/ | wc -l 2>/dev/null || echo "0")

# Debug statements
PRINT_COUNT=$(grep -r "print(" lib/ | wc -l 2>/dev/null || echo "0")
DEBUG_PRINT_COUNT=$(grep -r "debugPrint(" lib/ | wc -l 2>/dev/null || echo "0")

# Commented code
COMMENTED_LINES=$(grep -r "^[[:space:]]*\/\/" lib/ | wc -l 2>/dev/null || echo "0")

cat >> "$REPORT_FILE" << EOF
### 3. Code Quality
- **TODO Comments:** $TODO_COUNT
- **FIXME Comments:** $FIXME_COUNT
- **HACK Comments:** $HACK_COUNT
- **print() Statements:** $PRINT_COUNT
- **debugPrint() Statements:** $DEBUG_PRINT_COUNT
- **Commented Lines:** $COMMENTED_LINES

EOF

if [ "$PRINT_COUNT" -gt 0 ]; then
    print_warning "Found $PRINT_COUNT print() statements"
fi

if [ "$TODO_COUNT" -gt 10 ]; then
    print_warning "High number of TODO comments: $TODO_COUNT"
fi

print_status "Code quality checks completed"

# 4. Architecture Analysis
print_info "Analyzing architecture..."

# Clean Architecture layers
FEATURES=$(find lib/features -maxdepth 1 -type d 2>/dev/null | wc -l || echo "0")
FEATURES=$((FEATURES - 1)) # exclude the features directory itself

DOMAIN_FILES=$(find lib/features -path "*/domain/*" -name "*.dart" 2>/dev/null | wc -l || echo "0")
DATA_FILES=$(find lib/features -path "*/data/*" -name "*.dart" 2>/dev/null | wc -l || echo "0")
PRESENTATION_FILES=$(find lib/features -path "*/presentation/*" -name "*.dart" 2>/dev/null | wc -l || echo "0")

cat >> "$REPORT_FILE" << EOF
### 4. Architecture Analysis
- **Feature Modules:** $FEATURES
- **Domain Layer Files:** $DOMAIN_FILES
- **Data Layer Files:** $DATA_FILES
- **Presentation Layer Files:** $PRESENTATION_FILES
- **Architecture:** $([ -d "lib/features" ] && echo "✅ Clean Architecture" || echo "⚠️ Check structure")

EOF

print_status "Architecture analysis completed"

# 5. Dependencies Analysis
print_info "Analyzing dependencies..."

if [ -f "pubspec.yaml" ]; then
    TOTAL_DEPS=$(grep -c "^  [a-zA-Z]" pubspec.yaml 2>/dev/null || echo "0")
    DEV_DEPS=$(grep -A 100 "dev_dependencies:" pubspec.yaml | grep -c "^  [a-zA-Z]" 2>/dev/null || echo "0")
    PROD_DEPS=$((TOTAL_DEPS - DEV_DEPS))
    
    # فحص dependencies محددة
    HAS_RIVERPOD=$(grep -q "riverpod" pubspec.yaml && echo "✅" || echo "❌")
    HAS_ISAR=$(grep -q "isar" pubspec.yaml && echo "✅" || echo "❌")
    HAS_SECURE_STORAGE=$(grep -q "flutter_secure_storage" pubspec.yaml && echo "✅" || echo "❌")
    HAS_FREEZED=$(grep -q "freezed" pubspec.yaml && echo "✅" || echo "❌")
    
    cat >> "$REPORT_FILE" << EOF
### 5. Dependencies
- **Total Dependencies:** $TOTAL_DEPS
- **Production Dependencies:** $PROD_DEPS
- **Dev Dependencies:** $DEV_DEPS

#### Key Dependencies
- **Riverpod (State Management):** $HAS_RIVERPOD
- **Isar (Database):** $HAS_ISAR
- **Flutter Secure Storage:** $HAS_SECURE_STORAGE
- **Freezed (Code Generation):** $HAS_FREEZED

EOF
fi

print_status "Dependencies analysis completed"

# 6. Test Coverage Analysis
print_info "Analyzing test coverage..."

TEST_FILES=$(find test/ -name "*.dart" 2>/dev/null | wc -l || echo "0")
UNIT_TESTS=$(find test/unit -name "*.dart" 2>/dev/null | wc -l || echo "0")
WIDGET_TESTS=$(find test/widget -name "*.dart" 2>/dev/null | wc -l || echo "0")
INTEGRATION_TESTS=$(find test/integration -name "*.dart" 2>/dev/null | wc -l || echo "0")

# حساب test coverage إذا كان متاحاً
if [ -f "coverage/lcov.info" ]; then
    COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | grep -o '[0-9]\+\.[0-9]\+%' || echo "N/A")
else
    COVERAGE="Run 'flutter test --coverage' to calculate"
fi

cat >> "$REPORT_FILE" << EOF
### 6. Test Coverage
- **Total Test Files:** $TEST_FILES
- **Unit Tests:** $UNIT_TESTS
- **Widget Tests:** $WIDGET_TESTS
- **Integration Tests:** $INTEGRATION_TESTS
- **Coverage:** $COVERAGE

EOF

print_status "Test coverage analysis completed"

# 7. Performance Indicators
print_info "Checking performance indicators..."

# Riverpod optimization
SELECT_CALLS=$(grep -r "\.select(" lib/ | wc -l 2>/dev/null || echo "0")
WATCH_CALLS=$(grep -r "\.watch(" lib/ | wc -l 2>/dev/null || echo "0")
TOTAL_PROVIDER_CALLS=$((SELECT_CALLS + WATCH_CALLS))

if [ "$TOTAL_PROVIDER_CALLS" -gt 0 ]; then
    SELECT_RATIO=$((SELECT_CALLS * 100 / TOTAL_PROVIDER_CALLS))
else
    SELECT_RATIO=0
fi

# Widget optimization
CONST_WIDGETS=$(grep -r "const " lib/ | grep -c "Widget" 2>/dev/null || echo "0")
STATELESS_WIDGETS=$(grep -r "StatelessWidget" lib/ | wc -l 2>/dev/null || echo "0")
STATEFUL_WIDGETS=$(grep -r "StatefulWidget" lib/ | wc -l 2>/dev/null || echo "0")

cat >> "$REPORT_FILE" << EOF
### 7. Performance Indicators
- **Riverpod select() calls:** $SELECT_CALLS
- **Riverpod watch() calls:** $WATCH_CALLS
- **Select/Watch Ratio:** $SELECT_RATIO%
- **Const Widgets:** $CONST_WIDGETS
- **StatelessWidget:** $STATELESS_WIDGETS
- **StatefulWidget:** $STATEFUL_WIDGETS

EOF

if [ "$SELECT_RATIO" -lt 25 ]; then
    print_warning "Low select/watch ratio: $SELECT_RATIO% (target: 25%+)"
fi

print_status "Performance indicators checked"

# 8. Security Checks
print_info "Running security checks..."

# فحص hardcoded secrets
POTENTIAL_SECRETS=$(grep -r -i -E "(password|secret|api_key|token)" lib/ | grep -v "//\|/\*" | wc -l 2>/dev/null || echo "0")

# فحص HTTP vs HTTPS
HTTP_USAGE=$(grep -r "http://" lib/ | wc -l 2>/dev/null || echo "0")
HTTPS_USAGE=$(grep -r "https://" lib/ | wc -l 2>/dev/null || echo "0")

cat >> "$REPORT_FILE" << EOF
### 8. Security Checks
- **Potential Hardcoded Secrets:** $POTENTIAL_SECRETS
- **HTTP Usage:** $HTTP_USAGE
- **HTTPS Usage:** $HTTPS_USAGE
- **Secure Storage Usage:** $HAS_SECURE_STORAGE

EOF

if [ "$POTENTIAL_SECRETS" -gt 0 ]; then
    print_warning "Found $POTENTIAL_SECRETS potential hardcoded secrets"
fi

if [ "$HTTP_USAGE" -gt 0 ]; then
    print_warning "Found $HTTP_USAGE HTTP (non-secure) URLs"
fi

print_status "Security checks completed"

# 9. Localization Check
print_info "Checking localization..."

ARABIC_STRINGS=$(grep -r "[\u0600-\u06FF]" lib/ | wc -l 2>/dev/null || echo "0")
HAS_INTL=$(grep -q "intl" pubspec.yaml && echo "✅" || echo "❌")
L10N_FILES=$(find lib/l10n -name "*.arb" 2>/dev/null | wc -l || echo "0")

cat >> "$REPORT_FILE" << EOF
### 9. Localization
- **Arabic Strings in Code:** $ARABIC_STRINGS
- **Intl Package:** $HAS_INTL
- **L10n Files:** $L10N_FILES

EOF

print_status "Localization check completed"

# 10. Overall Score
print_info "Calculating overall score..."

SCORE=100

# Deductions
[ "$ANALYZE_ISSUES" -gt 0 ] && SCORE=$((SCORE - ANALYZE_ISSUES * 2))
[ "$PRINT_COUNT" -gt 0 ] && SCORE=$((SCORE - PRINT_COUNT))
[ "$TODO_COUNT" -gt 20 ] && SCORE=$((SCORE - 5))
[ "$SELECT_RATIO" -lt 25 ] && SCORE=$((SCORE - 10))
[ "$POTENTIAL_SECRETS" -gt 0 ] && SCORE=$((SCORE - 15))
[ "$HTTP_USAGE" -gt 0 ] && SCORE=$((SCORE - 5))

# Ensure score doesn't go below 0
[ "$SCORE" -lt 0 ] && SCORE=0

# Grade
if [ "$SCORE" -ge 90 ]; then
    GRADE="A+"
elif [ "$SCORE" -ge 80 ]; then
    GRADE="A"
elif [ "$SCORE" -ge 70 ]; then
    GRADE="B"
elif [ "$SCORE" -ge 60 ]; then
    GRADE="C"
else
    GRADE="D"
fi

cat >> "$REPORT_FILE" << EOF
---

## Overall Assessment

### Quality Score: $SCORE/100 ($GRADE)

### Recommendations

EOF

# إضافة توصيات بناءً على النتائج
if [ "$ANALYZE_ISSUES" -gt 0 ]; then
    echo "- 🔧 Fix $ANALYZE_ISSUES analysis issues" >> "$REPORT_FILE"
fi

if [ "$PRINT_COUNT" -gt 0 ]; then
    echo "- 🐛 Replace $PRINT_COUNT print() statements with debugPrint()" >> "$REPORT_FILE"
fi

if [ "$SELECT_RATIO" -lt 25 ]; then
    echo "- ⚡ Improve Riverpod select/watch ratio (current: $SELECT_RATIO%, target: 25%+)" >> "$REPORT_FILE"
fi

if [ "$POTENTIAL_SECRETS" -gt 0 ]; then
    echo "- 🔐 Review and remove $POTENTIAL_SECRETS potential hardcoded secrets" >> "$REPORT_FILE"
fi

if [ "$HTTP_USAGE" -gt 0 ]; then
    echo "- 🔒 Replace $HTTP_USAGE HTTP URLs with HTTPS" >> "$REPORT_FILE"
fi

if [ "$TODO_COUNT" -gt 20 ]; then
    echo "- 📝 Address high number of TODO comments ($TODO_COUNT)" >> "$REPORT_FILE"
fi

if [ "$TEST_FILES" -lt 10 ]; then
    echo "- 🧪 Add more tests (current: $TEST_FILES files)" >> "$REPORT_FILE"
fi

cat >> "$REPORT_FILE" << EOF

---

**Generated by:** Comprehensive Flutter Analysis Hook  
**Report Location:** $REPORT_FILE
EOF

echo ""
echo "════════════════════════════════════════════════════════════════"
print_status "Analysis completed!"
echo ""
echo "📊 Overall Score: $SCORE/100 ($GRADE)"
echo "📁 Report saved to: $REPORT_FILE"
echo ""

if [ "$SCORE" -lt 70 ]; then
    print_warning "Score below 70 - review recommendations"
    exit 1
elif [ "$SCORE" -lt 90 ]; then
    print_info "Good score - some improvements recommended"
    exit 0
else
    print_status "Excellent score!"
    exit 0
fi
