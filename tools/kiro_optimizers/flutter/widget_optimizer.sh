#!/bin/bash

# Flutter Widget Performance Optimizer
# المشروع: بصير MVP - workspace-transformation
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# Initialize counters
OPTIMIZATIONS_MADE=0
FILES_PROCESSED=0

# الألوان للمخرجات
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎨 Flutter Widget Performance Optimizer${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

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



# دالة لإضافة const constructor
optimize_const_constructors() {
    local file="$1"
    local temp_file=$(mktemp)
    
    # البحث عن constructors بدون const
    if grep -q "Widget(" "$file" && ! grep -q "const.*Widget(" "$file"; then
        print_info "Optimizing const constructors in $(basename "$file")"
        
        # إضافة const للـ constructors المناسبة
        sed 's/\([A-Z][a-zA-Z]*\)(/const \1(/g' "$file" > "$temp_file"
        
        if ! cmp -s "$file" "$temp_file"; then
            mv "$temp_file" "$file"
            ((OPTIMIZATIONS_MADE++))
            print_success "Added const constructors to $(basename "$file")"
        else
            rm "$temp_file"
        fi
    fi
}

# دالة لتحسين setState calls
optimize_setstate_calls() {
    local file="$1"
    
    # البحث عن setState calls غير محسنة
    if grep -q "setState(" "$file"; then
        local setstate_count=$(grep -c "setState(" "$file")
        if [ "$setstate_count" -gt 3 ]; then
            print_warning "File $(basename "$file") has $setstate_count setState calls - consider state management optimization"
        fi
    fi
}

# دالة لإزالة print statements
remove_print_statements() {
    local file="$1"
    local temp_file=$(mktemp)
    
    # إزالة print statements (لكن ليس debugPrint)
    if grep -q "print(" "$file" && ! grep -q "debugPrint(" "$file"; then
        print_info "Removing print statements from $(basename "$file")"
        
        # إزالة أسطر print
        grep -v "print(" "$file" > "$temp_file"
        
        if ! cmp -s "$file" "$temp_file"; then
            mv "$temp_file" "$file"
            ((OPTIMIZATIONS_MADE++))
            print_success "Removed print statements from $(basename "$file")"
        else
            rm "$temp_file"
        fi
    fi
}

# دالة لتحسين widget rebuilds
optimize_widget_rebuilds() {
    local file="$1"
    
    # البحث عن مشاكل rebuild محتملة
    if grep -q "build(" "$file"; then
        # فحص استخدام context في build method
        if grep -A 20 "Widget build(" "$file" | grep -q "context\." && ! grep -q "const.*Widget" "$file"; then
            print_warning "File $(basename "$file") may have rebuild issues - consider using const widgets"
        fi
    fi
}

# دالة لتحسين Riverpod usage
optimize_riverpod_usage() {
    local file="$1"
    
    # البحث عن watch calls بدون select
    if grep -q "\.watch(" "$file" && ! grep -q "\.select(" "$file"; then
        local watch_count=$(grep -c "\.watch(" "$file")
        if [ "$watch_count" -gt 2 ]; then
            print_warning "File $(basename "$file") has $watch_count watch() calls - consider using select() for better performance"
        fi
    fi
}

echo -e "${YELLOW}🔍 Scanning Flutter widgets for optimization opportunities...${NC}"

# معالجة جميع ملفات Dart في lib
if [ -d "lib" ]; then
    for file in $(find lib -name "*.dart" -type f); do
        ((FILES_PROCESSED++))
        
        echo -e "${CYAN}Processing: $(basename "$file")${NC}"
        
        # تطبيق التحسينات
        optimize_const_constructors "$file"
        optimize_setstate_calls "$file"
        remove_print_statements "$file"
        optimize_widget_rebuilds "$file"
        optimize_riverpod_usage "$file"
    done
else
    print_error "lib directory not found!"
    exit 1
fi

echo -e "\n${PURPLE}📊 Widget Optimization Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

echo -e "📁 Files Processed: ${FILES_PROCESSED}"
echo -e "🔧 Optimizations Made: ${OPTIMIZATIONS_MADE}"

if [ "$OPTIMIZATIONS_MADE" -gt 0 ]; then
    print_success "Widget optimization completed with $OPTIMIZATIONS_MADE improvements!"
    
    echo -e "\n${YELLOW}📋 Next Steps:${NC}"
    echo -e "   1. Run 'flutter analyze' to check for any issues"
    echo -e "   2. Run tests to ensure functionality is preserved"
    echo -e "   3. Test the app to verify performance improvements"
    echo -e "   4. Consider adding more const constructors manually"
else
    print_info "No automatic optimizations were needed - your widgets are already well optimized!"
fi

echo -e "\n${PURPLE}💡 Manual Optimization Tips${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

echo -e "${CYAN}🎯 Performance Best Practices:${NC}"
echo -e "   • Use const constructors wherever possible"
echo -e "   • Prefer StatelessWidget over StatefulWidget when state is not needed"
echo -e "   • Use select() instead of watch() in Riverpod for specific properties"
echo -e "   • Avoid creating widgets in build methods"
echo -e "   • Use ListView.builder for large lists"
echo -e "   • Cache expensive computations"
echo -e "   • Use RepaintBoundary for complex widgets"

echo -e "\n${CYAN}🏪 Riverpod Optimization:${NC}"
echo -e "   • Use select() to watch specific properties: ref.watch(provider.select((s) => s.property))"
echo -e "   • Use autoDispose for providers that don't need to persist"
echo -e "   • Combine related state into single providers"
echo -e "   • Use family providers for parameterized state"

echo -e "\n${CYAN}🗄️  Database Optimization:${NC}"
echo -e "   • Add indexes to frequently queried fields"
echo -e "   • Use composite indexes for multi-field queries"
echo -e "   • Limit query results with .limit()"
echo -e "   • Use .where() filters before .sortBy()"

echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
print_success "Widget optimization analysis completed!"

exit 0