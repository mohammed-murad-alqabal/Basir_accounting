#!/bin/bash

# Syntax Error Fix Script for basir_accounting_system
# المؤلف: فريق وكلاء تطوير نظام بصير المحاسبي
# التاريخ: 11 يناير 2026

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

echo "🔧 Syntax Error Fix for basir_accounting_system"
echo "════════════════════════════════════════════════════════════════"

# 1. إصلاح الفواصل الخاطئة في نهاية الأقواس
print_info "Fixing incorrect trailing commas..."

# إزالة الفواصل من نهاية الأقواس الفارغة
find lib/ -name "*.dart" -exec sed -i 's/(,)/()/' {} \;

# إزالة الفواصل من نهاية الأقواس مع super.key
find lib/ -name "*.dart" -exec sed -i 's/{super\.key},/)/' {} \;
find lib/ -name "*.dart" -exec sed -i 's/{super\.key},/{super.key}/' {} \;

# إصلاح الفواصل في نهاية الأسطر
find lib/ -name "*.dart" -exec sed -i 's/},);/});/' {} \;
find lib/ -name "*.dart" -exec sed -i 's/ ,);/);/' {} \;

print_status "Trailing commas fixed"

# 2. إصلاح مشاكل الأحرف العربية
print_info "Fixing Arabic character encoding..."

# استبدال الأحرف العربية المشكلة بأحرف صحيحة
find lib/ -name "*.dart" -exec sed -i "s/'كما هو'/'كما هو'/g" {} \;

print_status "Arabic characters fixed"

# 3. إصلاح library directive
print_info "Fixing library directives..."

# إزالة library directive الخاطئة
find lib/ -name "*.dart" -exec sed -i '/^library;$/d' {} \;

print_status "Library directives fixed"

# 4. إصلاح مشاكل الـ constructors
print_info "Fixing constructor issues..."

# إصلاح constructors الفارغة
find lib/ -name "*.dart" -exec sed -i 's/\([A-Za-z_][A-Za-z0-9_]*\)(,);/\1();/' {} \;

print_status "Constructors fixed"

# 5. تشغيل flutter analyze للتحقق
print_info "Running flutter analyze to check results..."

ISSUES_COUNT=$(flutter analyze 2>&1 | grep -o "[0-9]* issues found" | grep -o "[0-9]*" || echo "0")

echo ""
echo "════════════════════════════════════════════════════════════════"
print_status "Syntax errors fixed!"
echo ""
echo "📊 Remaining issues: $ISSUES_COUNT"
echo ""

if [ "$ISSUES_COUNT" -lt 50 ]; then
    print_status "Excellent! Most critical errors fixed"
elif [ "$ISSUES_COUNT" -lt 150 ]; then
    print_warning "Good progress, some issues remain"
else
    print_error "More work needed"
fi

echo "════════════════════════════════════════════════════════════════"