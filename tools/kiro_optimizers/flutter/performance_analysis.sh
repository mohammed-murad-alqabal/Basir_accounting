#!/bin/bash

# Flutter Performance Analysis
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

echo -e "${BLUE}🚀 Flutter Performance Analysis${NC}"
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

# التحقق من وجود Flutter
if ! command -v flutter &> /dev/null; then
    print_error "Flutter not found. Please install Flutter first."
    exit 1
fi

echo -e "${YELLOW}📊 Analyzing Flutter project performance...${NC}"

# 1. تحليل حجم التطبيق
echo -e "${PURPLE}📦 App Size Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

if [ -d "build/app/outputs/flutter-apk" ]; then
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk 2>/dev/null | cut -f1 || echo "N/A")
    echo -e "📱 APK Size: ${APK_SIZE}"
else
    print_info "No release APK found. Run 'flutter build apk --release' first."
fi

# 2. تحليل التبعيات
echo -e "\n${PURPLE}📚 Dependencies Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

DEPS_COUNT=$(grep -c "^  [a-zA-Z]" pubspec.yaml || echo "0")
DEV_DEPS_COUNT=$(grep -A 100 "dev_dependencies:" pubspec.yaml | grep -c "^  [a-zA-Z]" || echo "0")

echo -e "📦 Production Dependencies: ${DEPS_COUNT}"
echo -e "🛠️  Dev Dependencies: ${DEV_DEPS_COUNT}"
echo -e "📊 Total Dependencies: $((DEPS_COUNT + DEV_DEPS_COUNT))"

# 3. تحليل الكود
echo -e "\n${PURPLE}📝 Code Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# عدد ملفات Dart
DART_FILES=$(find lib -name "*.dart" | wc -l)
echo -e "📄 Dart Files: ${DART_FILES}"

# عدد الأسطر
TOTAL_LINES=$(find lib -name "*.dart" -exec wc -l {} + | tail -1 | awk '{print $1}' || echo "0")
echo -e "📏 Total Lines of Code: ${TOTAL_LINES}"

# متوسط الأسطر لكل ملف
if [ "$DART_FILES" -gt 0 ]; then
    AVG_LINES=$((TOTAL_LINES / DART_FILES))
    echo -e "📊 Average Lines per File: ${AVG_LINES}"
fi

# 4. تحليل الأداء المحتمل
echo -e "\n${PURPLE}⚡ Performance Indicators${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# البحث عن مشاكل أداء محتملة
PRINT_STATEMENTS=$(grep -r "print(" lib --include="*.dart" | wc -l || echo "0")
DEBUGPRINT_STATEMENTS=$(grep -r "debugPrint(" lib --include="*.dart" | wc -l || echo "0")
SETSTATE_CALLS=$(grep -r "setState(" lib --include="*.dart" | wc -l || echo "0")

echo -e "🖨️  Print Statements: ${PRINT_STATEMENTS}"
echo -e "🐛 Debug Print Statements: ${DEBUGPRINT_STATEMENTS}"
echo -e "🔄 setState Calls: ${SETSTATE_CALLS}"

# تحذيرات الأداء
if [ "$PRINT_STATEMENTS" -gt 0 ]; then
    print_warning "Found ${PRINT_STATEMENTS} print() statements that should be removed in production"
fi

if [ "$SETSTATE_CALLS" -gt 50 ]; then
    print_warning "High number of setState calls (${SETSTATE_CALLS}) - consider state management optimization"
fi

# 5. تحليل الـ widgets
echo -e "\n${PURPLE}🎨 Widget Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

STATEFUL_WIDGETS=$(grep -r "StatefulWidget" lib --include="*.dart" | wc -l || echo "0")
STATELESS_WIDGETS=$(grep -r "StatelessWidget" lib --include="*.dart" | wc -l || echo "0")
CONST_CONSTRUCTORS=$(grep -r "const.*(" lib --include="*.dart" | wc -l || echo "0")

echo -e "🔄 StatefulWidget: ${STATEFUL_WIDGETS}"
echo -e "📄 StatelessWidget: ${STATELESS_WIDGETS}"
echo -e "🔒 Const Constructors: ${CONST_CONSTRUCTORS}"

# نسبة const constructors
TOTAL_WIDGETS=$((STATEFUL_WIDGETS + STATELESS_WIDGETS))
if [ "$TOTAL_WIDGETS" -gt 0 ]; then
    CONST_RATIO=$((CONST_CONSTRUCTORS * 100 / TOTAL_WIDGETS))
    echo -e "📊 Const Usage Ratio: ${CONST_RATIO}%"
    
    if [ "$CONST_RATIO" -lt 30 ]; then
        print_warning "Low const constructor usage (${CONST_RATIO}%) - consider adding more const constructors"
    else
        print_success "Good const constructor usage (${CONST_RATIO}%)"
    fi
fi

# 6. تحليل Riverpod
echo -e "\n${PURPLE}🏪 State Management Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

PROVIDERS=$(grep -r "Provider" lib --include="*.dart" | wc -l || echo "0")
CONSUMERS=$(grep -r "Consumer" lib --include="*.dart" | wc -l || echo "0")
WATCH_CALLS=$(grep -r "\.watch(" lib --include="*.dart" | wc -l || echo "0")
SELECT_CALLS=$(grep -r "\.select(" lib --include="*.dart" | wc -l || echo "0")

echo -e "🏪 Providers: ${PROVIDERS}"
echo -e "👀 Consumers: ${CONSUMERS}"
echo -e "⏰ Watch Calls: ${WATCH_CALLS}"
echo -e "🎯 Select Calls: ${SELECT_CALLS}"

# نسبة select إلى watch (للأداء)
if [ "$WATCH_CALLS" -gt 0 ]; then
    SELECT_RATIO=$((SELECT_CALLS * 100 / WATCH_CALLS))
    echo -e "📊 Select/Watch Ratio: ${SELECT_RATIO}%"
    
    if [ "$SELECT_RATIO" -lt 20 ]; then
        print_warning "Low select() usage (${SELECT_RATIO}%) - consider using select() for better performance"
    else
        print_success "Good select() usage (${SELECT_RATIO}%)"
    fi
fi

# 7. تحليل قاعدة البيانات
echo -e "\n${PURPLE}🗄️  Database Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

ISAR_QUERIES=$(grep -r "isar\." lib --include="*.dart" | wc -l || echo "0")
ISAR_COLLECTIONS=$(grep -r "@collection" lib --include="*.dart" | wc -l || echo "0")
ISAR_INDEXES=$(grep -r "@Index" lib --include="*.dart" | wc -l || echo "0")

echo -e "🔍 Isar Queries: ${ISAR_QUERIES}"
echo -e "📚 Collections: ${ISAR_COLLECTIONS}"
echo -e "📇 Indexes: ${ISAR_INDEXES}"

# نسبة الفهارس إلى المجموعات
if [ "$ISAR_COLLECTIONS" -gt 0 ]; then
    INDEX_RATIO=$((ISAR_INDEXES * 100 / ISAR_COLLECTIONS))
    echo -e "📊 Index/Collection Ratio: ${INDEX_RATIO}%"
    
    if [ "$INDEX_RATIO" -lt 50 ]; then
        print_warning "Low index usage (${INDEX_RATIO}%) - consider adding more indexes for better query performance"
    else
        print_success "Good index usage (${INDEX_RATIO}%)"
    fi
fi

# 8. تحليل الأصول (Assets)
echo -e "\n${PURPLE}🖼️  Assets Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

if [ -d "assets" ]; then
    IMAGES_COUNT=$(find assets -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" | wc -l || echo "0")
    ICONS_COUNT=$(find assets -name "*.svg" -o -name "*.ico" | wc -l || echo "0")
    FONTS_COUNT=$(find assets -name "*.ttf" -o -name "*.otf" | wc -l || echo "0")
    
    echo -e "🖼️  Images: ${IMAGES_COUNT}"
    echo -e "🎨 Icons: ${ICONS_COUNT}"
    echo -e "🔤 Fonts: ${FONTS_COUNT}"
    
    # حجم مجلد الأصول
    ASSETS_SIZE=$(du -sh assets 2>/dev/null | cut -f1 || echo "N/A")
    echo -e "📦 Assets Size: ${ASSETS_SIZE}"
else
    print_info "No assets directory found"
fi

# 9. توصيات الأداء
echo -e "\n${PURPLE}💡 Performance Recommendations${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

RECOMMENDATIONS=()

# فحص التوصيات
if [ "$PRINT_STATEMENTS" -gt 0 ]; then
    RECOMMENDATIONS+=("Remove ${PRINT_STATEMENTS} print() statements from production code")
fi

if [ "$CONST_CONSTRUCTORS" -lt $((TOTAL_WIDGETS / 2)) ] && [ "$TOTAL_WIDGETS" -gt 0 ]; then
    RECOMMENDATIONS+=("Add more const constructors to widgets (current: ${CONST_RATIO}%)")
fi

if [ "$SELECT_CALLS" -lt $((WATCH_CALLS / 4)) ] && [ "$WATCH_CALLS" -gt 0 ]; then
    RECOMMENDATIONS+=("Use more select() calls instead of watch() for better performance")
fi

if [ "$ISAR_INDEXES" -lt "$ISAR_COLLECTIONS" ] && [ "$ISAR_COLLECTIONS" -gt 0 ]; then
    RECOMMENDATIONS+=("Add more database indexes for better query performance")
fi

# عرض التوصيات
if [ ${#RECOMMENDATIONS[@]} -eq 0 ]; then
    print_success "No major performance issues found!"
else
    echo -e "${YELLOW}📋 Recommendations:${NC}"
    for i in "${!RECOMMENDATIONS[@]}"; do
        echo -e "   $((i+1)). ${RECOMMENDATIONS[$i]}"
    done
fi

# 10. ملخص الأداء
echo -e "\n${PURPLE}📊 Performance Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

SCORE=100

# خصم نقاط للمشاكل
if [ "$PRINT_STATEMENTS" -gt 0 ]; then
    SCORE=$((SCORE - PRINT_STATEMENTS * 2))
fi

if [ "$CONST_RATIO" -lt 30 ] && [ "$TOTAL_WIDGETS" -gt 0 ]; then
    SCORE=$((SCORE - 10))
fi

if [ "$SELECT_RATIO" -lt 20 ] && [ "$WATCH_CALLS" -gt 0 ]; then
    SCORE=$((SCORE - 15))
fi

if [ "$INDEX_RATIO" -lt 50 ] && [ "$ISAR_COLLECTIONS" -gt 0 ]; then
    SCORE=$((SCORE - 10))
fi

# تحديد اللون حسب النتيجة
if [ "$SCORE" -ge 90 ]; then
    SCORE_COLOR=$GREEN
    SCORE_STATUS="🎉 Excellent"
elif [ "$SCORE" -ge 80 ]; then
    SCORE_COLOR=$YELLOW
    SCORE_STATUS="👍 Good"
elif [ "$SCORE" -ge 70 ]; then
    SCORE_COLOR=$YELLOW
    SCORE_STATUS="⚠️  Needs Improvement"
else
    SCORE_COLOR=$RED
    SCORE_STATUS="❌ Poor"
fi

echo -e "🏆 Performance Score: ${SCORE_COLOR}${SCORE}/100${NC} - ${SCORE_STATUS}"

# معلومات إضافية
echo -e "\n${CYAN}💡 Additional Tips:${NC}"
echo -e "   • Use 'flutter build apk --analyze-size' for detailed size analysis"
echo -e "   • Use Flutter DevTools for runtime performance profiling"
echo -e "   • Consider using 'flutter build apk --split-per-abi' to reduce APK size"
echo -e "   • Profile your app with 'flutter run --profile' for performance testing"

echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
print_success "Performance analysis completed!"

exit 0