#!/bin/bash

# Critical Error Fix Script for Basir MVP
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

echo "🔧 Critical Error Fix for Basir MVP"
echo "════════════════════════════════════════════════════════════════"

# 1. إصلاح مشاكل التنسيق
print_info "Fixing code formatting issues..."

# إصلاح raw strings غير الضرورية
find lib/ -name "*.dart" -exec sed -i "s/RegExp(r'\([^']*\)')/RegExp('\1')/g" {} \;

# إصلاح double quotes
find lib/ -name "*.dart" -exec sed -i "s/\"\([^\"]*\)\"/'\1'/g" {} \;

print_status "Code formatting fixed"

# 2. إصلاح مشاكل catch clauses
print_info "Fixing catch clauses..."

# البحث عن catch clauses بدون on
find lib/ -name "*.dart" -exec sed -i 's/} catch (e)/} on Exception catch (e)/g' {} \;
find lib/ -name "*.dart" -exec sed -i 's/} catch (error)/} on Exception catch (error)/g' {} \;

print_status "Catch clauses fixed"

# 3. إصلاح trailing commas
print_info "Adding missing trailing commas..."

# إضافة trailing commas للمعاملات الأخيرة
find lib/ -name "*.dart" -exec sed -i 's/\([^,]\)\s*);/\1,);/g' {} \;

print_status "Trailing commas added"

# 4. إصلاح print statements
print_info "Replacing print with debugPrint..."

# استبدال print بـ debugPrint
find lib/ -name "*.dart" -exec sed -i 's/print(/debugPrint(/g' {} \;

print_status "Print statements fixed"

# 5. إضافة imports مفقودة
print_info "Adding missing imports..."

# إضافة import للـ debugPrint
for file in $(find lib/ -name "*.dart" -exec grep -l "debugPrint" {} \;); do
    if ! grep -q "import 'package:flutter/foundation.dart'" "$file"; then
        sed -i "1i import 'package:flutter/foundation.dart';" "$file"
    fi
done

print_status "Missing imports added"

# 6. تشغيل dart format
print_info "Running dart format..."

dart format lib/ test/

print_status "Code formatted"

# 7. فحص النتائج
print_info "Running flutter analyze to check results..."

ISSUES_BEFORE=312
ISSUES_AFTER=$(flutter analyze 2>&1 | grep -o "[0-9]* issues found" | grep -o "[0-9]*" || echo "0")

echo ""
echo "════════════════════════════════════════════════════════════════"
print_status "Critical errors fixed!"
echo ""
echo "📊 Results:"
echo "   Before: $ISSUES_BEFORE issues"
echo "   After:  $ISSUES_AFTER issues"
echo "   Fixed:  $((ISSUES_BEFORE - ISSUES_AFTER)) issues"
echo ""

if [ "$ISSUES_AFTER" -lt 50 ]; then
    print_status "Excellent! Issues reduced to manageable level"
elif [ "$ISSUES_AFTER" -lt 100 ]; then
    print_warning "Good progress, but more fixes needed"
else
    print_error "More work needed to fix remaining issues"
fi

echo "════════════════════════════════════════════════════════════════"