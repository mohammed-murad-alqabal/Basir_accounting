#!/bin/bash

# Flutter Pre-Commit Validation Hook
# المشروع: بصير MVP - workspace-transformation
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# الألوان للمخرجات
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Flutter Pre-Commit Validation${NC}"
echo -e "${BLUE}═══════════════════════════════════${NC}"

# متغيرات التحكم
VALIDATION_ERRORS=0
START_TIME=$(date +%s)

# دالة لطباعة الأخطاء
print_error() {
    echo -e "${RED}❌ $1${NC}"
    VALIDATION_ERRORS=$((VALIDATION_ERRORS + 1))
}

# دالة لطباعة النجاح
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# دالة لطباعة التحذيرات
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# التحقق من وجود Flutter
echo -e "${YELLOW}🔍 Checking Flutter installation...${NC}"
if ! command -v flutter &> /dev/null; then
    print_error "Flutter not found. Please install Flutter first."
    exit 1
fi
print_success "Flutter found: $(flutter --version | head -n1)"

# التحقق من وجود الملفات المعدلة
CHANGED_DART_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(dart)$' || true)
CHANGED_YAML_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(yaml|yml)$' || true)

if [ -z "$CHANGED_DART_FILES" ] && [ -z "$CHANGED_YAML_FILES" ]; then
    print_success "No Dart or YAML files to validate"
    exit 0
fi

# 1. التحقق من تنسيق الكود
if [ -n "$CHANGED_DART_FILES" ]; then
    echo -e "${YELLOW}📝 Validating code formatting...${NC}"
    for file in $CHANGED_DART_FILES; do
        if [ -f "$file" ]; then
            if ! dart format --set-exit-if-changed "$file" > /dev/null 2>&1; then
                print_error "File not properly formatted: $file"
                echo -e "   ${BLUE}→${NC} Run: dart format $file"
            fi
        fi
    done
fi

# 2. تشغيل flutter analyze
echo -e "${YELLOW}🔍 Running Flutter analyze...${NC}"
ANALYZE_OUTPUT=$(flutter analyze --no-preamble 2>&1)
ANALYZE_EXIT_CODE=$?

if [ $ANALYZE_EXIT_CODE -eq 0 ]; then
    print_success "Flutter analyze passed"
else
    print_error "Flutter analyze failed"
    echo -e "${RED}$ANALYZE_OUTPUT${NC}"
fi

# 3. التحقق من pubspec.yaml إذا تم تعديله
if echo "$CHANGED_YAML_FILES" | grep -q "pubspec.yaml"; then
    echo -e "${YELLOW}📦 Validating pubspec.yaml...${NC}"
    
    # التحقق من صحة YAML syntax
    if flutter pub deps > /dev/null 2>&1; then
        print_success "pubspec.yaml is valid"
    else
        print_error "pubspec.yaml has issues"
        flutter pub deps
    fi
    
    # التحقق من الأمان في dependencies
    if grep -q "git:" pubspec.yaml; then
        print_warning "Git dependencies found in pubspec.yaml - ensure they are from trusted sources"
    fi
fi

# 4. التحقق من TODO comments
if [ -n "$CHANGED_DART_FILES" ]; then
    echo -e "${YELLOW}📋 Checking for TODO comments...${NC}"
    TODO_COUNT=0
    for file in $CHANGED_DART_FILES; do
        if [ -f "$file" ]; then
            TODOS=$(grep -n "// TODO\|//TODO\|/* TODO\|/*TODO" "$file" || true)
            if [ -n "$TODOS" ]; then
                TODO_COUNT=$((TODO_COUNT + 1))
                echo -e "  ${YELLOW}→${NC} TODOs found in $file:"
                echo "$TODOS" | sed 's/^/    /'
            fi
        fi
    done
    
    if [ $TODO_COUNT -gt 0 ]; then
        print_warning "$TODO_COUNT file(s) contain TODO comments"
    else
        print_success "No TODO comments found"
    fi
fi

# 5. التحقق من استخدام print() statements
if [ -n "$CHANGED_DART_FILES" ]; then
    echo -e "${YELLOW}🖨️  Checking for print() statements...${NC}"
    PRINT_COUNT=0
    for file in $CHANGED_DART_FILES; do
        if [ -f "$file" ]; then
            # تجاهل ملفات الاختبار
            if [[ "$file" != test/* ]]; then
                PRINTS=$(grep -n "print(" "$file" || true)
                if [ -n "$PRINTS" ]; then
                    PRINT_COUNT=$((PRINT_COUNT + 1))
                    print_warning "print() statements found in $file:"
                    echo "$PRINTS" | sed 's/^/    /'
                fi
            fi
        fi
    done
    
    if [ $PRINT_COUNT -gt 0 ]; then
        print_warning "$PRINT_COUNT file(s) contain print() statements - consider using proper logging"
    else
        print_success "No print() statements found in production code"
    fi
fi

# 6. التحقق من حجم الملفات
if [ -n "$CHANGED_DART_FILES" ]; then
    echo -e "${YELLOW}📏 Checking file sizes...${NC}"
    LARGE_FILES=0
    for file in $CHANGED_DART_FILES; do
        if [ -f "$file" ]; then
            FILE_SIZE=$(wc -l < "$file")
            if [ "$FILE_SIZE" -gt 300 ]; then
                LARGE_FILES=$((LARGE_FILES + 1))
                print_warning "Large file detected: $file ($FILE_SIZE lines)"
                echo -e "   ${BLUE}→${NC} Consider breaking this file into smaller components"
            fi
        fi
    done
    
    if [ $LARGE_FILES -eq 0 ]; then
        print_success "All files are reasonably sized"
    fi
fi

# حساب الوقت المستغرق
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo -e "${BLUE}═══════════════════════════════════${NC}"

# النتيجة النهائية
if [ $VALIDATION_ERRORS -eq 0 ] && [ $ANALYZE_EXIT_CODE -eq 0 ]; then
    print_success "All validations passed! (${DURATION}s)"
    echo -e "${GREEN}🎉 Ready to commit!${NC}"
    exit 0
else
    print_error "Validation failed with $VALIDATION_ERRORS error(s)"
    echo -e "${RED}❌ Please fix the issues before committing${NC}"
    exit 1
fi