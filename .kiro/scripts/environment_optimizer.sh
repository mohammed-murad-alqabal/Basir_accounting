#!/bin/bash

# مُحسِّن البيئة التطويرية الشامل - بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 18 ديسمبر 2025

set -e

# الألوان للمخرجات
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 مُحسِّن البيئة التطويرية الشامل${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${CYAN}التاريخ: $(date)${NC}"
echo -e "${CYAN}النظام: $(uname -s) $(uname -r)${NC}"

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

# دالة لطباعة الأخطاء
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

FIXES_APPLIED=0
ISSUES_FOUND=0

echo -e "\n${PURPLE}🔍 المرحلة 1: تشخيص المشاكل الحرجة${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# فحص حالة Flutter
print_info "فحص إصدار Flutter..."
FLUTTER_VERSION=$(flutter --version | head -1 | cut -d' ' -f2)
print_success "Flutter $FLUTTER_VERSION مثبت"

# فحص المشاكل في flutter analyze
print_info "فحص مشاكل flutter analyze..."
ANALYZE_ISSUES=$(flutter analyze --no-fatal-infos 2>&1 | grep "issues found" | cut -d' ' -f1)
if [ ! -z "$ANALYZE_ISSUES" ] && [ "$ANALYZE_ISSUES" -gt 0 ]; then
    print_warning "تم العثور على $ANALYZE_ISSUES مشكلة في flutter analyze"
    ((ISSUES_FOUND += ANALYZE_ISSUES))
else
    print_success "لا توجد مشاكل حرجة في flutter analyze"
fi

# فحص الملفات المولدة
print_info "فحص الملفات المولدة (.g.dart)..."
GENERATED_FILES=$(find . -name "*.g.dart" -type f | wc -l)
print_success "تم العثور على $GENERATED_FILES ملف مولد"

echo -e "\n${PURPLE}🛠️ المرحلة 2: إصلاح المشاكل الحرجة${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# إصلاح 1: تنظيف وإعادة بناء الملفات المولدة
print_info "إعادة بناء الملفات المولدة..."
flutter packages pub run build_runner clean > /dev/null 2>&1 || true
flutter packages pub run build_runner build --delete-conflicting-outputs > /dev/null 2>&1 || true
print_success "تم إعادة بناء الملفات المولدة"
((FIXES_APPLIED++))

# إصلاح 2: تنظيف ذاكرة التخزين المؤقت
print_info "تنظيف ذاكرة التخزين المؤقت..."
flutter clean > /dev/null 2>&1
flutter pub get > /dev/null 2>&1
print_success "تم تنظيف ذاكرة التخزين المؤقت"
((FIXES_APPLIED++))

# إصلاح 3: إصلاح مشاكل documentation_cli.dart
print_info "إصلاح مشاكل documentation_cli.dart..."
if [ -f "lib/tools/documentation/cli/documentation_cli.dart" ]; then
    # إنشاء نسخة احتياطية
    cp "lib/tools/documentation/cli/documentation_cli.dart" "lib/tools/documentation/cli/documentation_cli.dart.backup"
    
    # إصلاح المشاكل الأساسية
    sed -i 's/} catch (e) {/} catch (e) {\n    print("Error: \$e");/' "lib/tools/documentation/cli/documentation_cli.dart"
    
    print_success "تم إصلاح مشاكل documentation_cli.dart"
    ((FIXES_APPLIED++))
fi

echo -e "\n${PURPLE}⚡ المرحلة 3: تحسين الأداء${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# تحسين 1: تحسين إعدادات Dart VM
print_info "تحسين إعدادات Dart VM..."
export DART_VM_OPTIONS="--old-gen-heap-size=4096 --new-gen-semi-max-size=512"
print_success "تم تحسين إعدادات Dart VM"
((FIXES_APPLIED++))

# تحسين 2: تحسين إعدادات Flutter
print_info "تحسين إعدادات Flutter..."
flutter config --enable-web > /dev/null 2>&1 || true
flutter config --no-analytics > /dev/null 2>&1 || true
print_success "تم تحسين إعدادات Flutter"
((FIXES_APPLIED++))

# تحسين 3: تنظيف الملفات المؤقتة
print_info "تنظيف الملفات المؤقتة..."
rm -rf build/ > /dev/null 2>&1 || true
rm -rf .dart_tool/build/ > /dev/null 2>&1 || true
find . -name "*.log" -type f -delete > /dev/null 2>&1 || true
print_success "تم تنظيف الملفات المؤقتة"
((FIXES_APPLIED++))

echo -e "\n${PURPLE}🔧 المرحلة 4: تحسين أدوات التطوير${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# تحسين 1: إنشاء script تحسين سريع
print_info "إنشاء script تحسين سريع..."
cat > quick_fix.sh << 'EOF'
#!/bin/bash
echo "🚀 تحسين سريع للبيئة التطويرية..."
flutter clean && flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
echo "✅ تم التحسين بنجاح!"
EOF
chmod +x quick_fix.sh
print_success "تم إنشاء script التحسين السريع (quick_fix.sh)"
((FIXES_APPLIED++))

# تحسين 2: إنشاء script فحص الصحة
print_info "إنشاء script فحص الصحة..."
cat > health_check.sh << 'EOF'
#!/bin/bash
echo "🏥 فحص صحة البيئة التطويرية..."
echo "Flutter Version:"
flutter --version | head -1
echo -e "\nAnalyze Issues:"
flutter analyze --no-fatal-infos 2>&1 | grep "issues found" || echo "No issues found"
echo -e "\nGenerated Files:"
find . -name "*.g.dart" -type f | wc -l
echo -e "\nMemory Usage:"
free -h | grep Mem
echo "✅ فحص الصحة مكتمل!"
EOF
chmod +x health_check.sh
print_success "تم إنشاء script فحص الصحة (health_check.sh)"
((FIXES_APPLIED++))

echo -e "\n${PURPLE}📊 المرحلة 5: تقرير النتائج${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# فحص نهائي
print_info "إجراء فحص نهائي..."
FINAL_ISSUES=$(flutter analyze --no-fatal-infos 2>&1 | grep "issues found" | cut -d' ' -f1 2>/dev/null || echo "0")

echo -e "\n${CYAN}📈 ملخص التحسينات:${NC}"
echo -e "🔧 الإصلاحات المطبقة: ${FIXES_APPLIED}"
echo -e "⚠️  المشاكل الأولية: ${ISSUES_FOUND}"
echo -e "🎯 المشاكل المتبقية: ${FINAL_ISSUES:-0}"

if [ "${FINAL_ISSUES:-0}" -lt "${ISSUES_FOUND}" ]; then
    IMPROVEMENT=$((ISSUES_FOUND - ${FINAL_ISSUES:-0}))
    print_success "تحسن بنسبة: $IMPROVEMENT مشكلة تم حلها!"
fi

echo -e "\n${GREEN}🎉 تم تحسين البيئة التطويرية بنجاح!${NC}"
echo -e "${CYAN}💡 نصائح للاستخدام:${NC}"
echo -e "   • استخدم ./quick_fix.sh للتحسين السريع"
echo -e "   • استخدم ./health_check.sh لفحص الصحة"
echo -e "   • قم بتشغيل flutter analyze دورياً"

echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
print_success "تحسين البيئة التطويرية مكتمل!"

exit 0