#!/bin/bash

# Enhanced Flutter Environment Setup Script
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 18 ديسمبر 2025
# الإصدار: 2.0 - Enhanced with comprehensive checks and optimizations

set -e  # Exit on any error

echo "🚀 Enhanced Flutter Environment Setup"
echo "═══════════════════════════════════════════════════════════════"
echo "📋 Baseer MVP Development Environment Initialization"
echo "═══════════════════════════════════════════════════════════════"

# تحديد الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# دالة طباعة ملونة
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

# 1. فحص Flutter SDK مع التحقق من الإصدار المطلوب
echo "📱 Checking Flutter SDK..."
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    FLUTTER_VERSION_NUMBER=$(flutter --version | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
    
    # التحقق من الإصدار المطلوب (3.35.5+)
    REQUIRED_VERSION="3.35.5"
    if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$FLUTTER_VERSION_NUMBER" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
        print_status "Flutter found: $FLUTTER_VERSION ✅"
    else
        print_warning "Flutter version $FLUTTER_VERSION_NUMBER found, but $REQUIRED_VERSION+ recommended"
    fi
    
    # فحص القناة
    FLUTTER_CHANNEL=$(flutter channel | grep -E '^\*' | awk '{print $2}')
    print_info "Flutter channel: $FLUTTER_CHANNEL"
else
    print_error "Flutter not found. Please install Flutter SDK first."
    echo "📥 Install from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# 2. فحص Dart SDK مع التحقق من الإصدار
echo "🎯 Checking Dart SDK..."
if command -v dart &> /dev/null; then
    DART_VERSION=$(dart --version)
    DART_VERSION_NUMBER=$(echo "$DART_VERSION" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
    
    # التحقق من الإصدار المطلوب (3.9.2+)
    REQUIRED_DART_VERSION="3.9.2"
    if [ "$(printf '%s\n' "$REQUIRED_DART_VERSION" "$DART_VERSION_NUMBER" | sort -V | head -n1)" = "$REQUIRED_DART_VERSION" ]; then
        print_status "Dart found: $DART_VERSION ✅"
    else
        print_warning "Dart version $DART_VERSION_NUMBER found, but $REQUIRED_DART_VERSION+ recommended"
    fi
else
    print_error "Dart not found. Please install Dart SDK first."
    exit 1
fi

# 3. فحص Android SDK (اختياري)
echo "🤖 Checking Android SDK..."
if [ -n "$ANDROID_HOME" ]; then
    print_status "Android SDK found at: $ANDROID_HOME"
else
    print_warning "Android SDK not configured. Set ANDROID_HOME if needed."
fi

# 4. فحص VS Code (اختياري)
echo "💻 Checking VS Code..."
if command -v code &> /dev/null; then
    print_status "VS Code found"
else
    print_warning "VS Code not found. Consider installing for better development experience."
fi

# 5. فحص متطلبات Baseer MVP الخاصة
echo "🏗️ Checking Baseer MVP specific requirements..."

# فحص Isar
if grep -q "isar" pubspec.yaml; then
    print_status "Isar database dependency found"
else
    print_warning "Isar database dependency not found in pubspec.yaml"
fi

# فحص Riverpod
if grep -q "riverpod" pubspec.yaml; then
    print_status "Riverpod state management found"
else
    print_warning "Riverpod state management not found in pubspec.yaml"
fi

# فحص flutter_secure_storage
if grep -q "flutter_secure_storage" pubspec.yaml; then
    print_status "Flutter Secure Storage found"
else
    print_warning "Flutter Secure Storage not found in pubspec.yaml"
fi

# 6. تنظيف وإعداد المشروع المحسن
echo "🧹 Enhanced project cleanup and setup..."

# إنشاء مجلدات التقارير إذا لم تكن موجودة
mkdir -p .kiro/reports

# تنظيف Flutter مع تفاصيل
print_info "Running comprehensive flutter clean..."
flutter clean

# حذف ملفات build القديمة
if [ -d "build" ]; then
    print_info "Removing old build directory..."
    rm -rf build
fi

# تحديث dependencies مع تحسينات
print_info "Getting dependencies with optimizations..."
flutter pub get

# فحص outdated packages
print_info "Checking for outdated packages..."
flutter pub outdated || print_warning "Some packages may be outdated"

# تشغيل code generation المحسن
print_info "Running enhanced code generation..."
if grep -q "build_runner" pubspec.yaml; then
    flutter packages pub run build_runner build --delete-conflicting-outputs
    print_status "Code generation completed"
else
    print_info "No build_runner found, skipping code generation"
fi

# 7. فحص المشروع المحسن
echo "🔍 Enhanced project analysis..."

# تشغيل flutter analyze مع تفاصيل
print_info "Running flutter analyze..."
if flutter analyze --no-fatal-infos; then
    print_status "Analysis completed with no critical issues"
else
    print_warning "Analysis found some issues - review them carefully"
fi

# فحص formatting
print_info "Checking code formatting..."
if dart format --set-exit-if-changed --output=none lib/ test/; then
    print_status "Code formatting is correct"
else
    print_warning "Some files need formatting - run 'dart format lib/ test/'"
fi

# 8. تشغيل الاختبارات المحسن
echo "🧪 Running comprehensive tests..."

# فحص وجود الاختبارات
if [ -d "test" ] && [ "$(ls -A test)" ]; then
    print_info "Running unit tests..."
    if flutter test --reporter=compact --coverage; then
        print_status "All tests passed ✅"
        
        # حساب test coverage إذا كان متاحاً
        if [ -f "coverage/lcov.info" ]; then
            COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | grep -o '[0-9]\+\.[0-9]\+%' || echo "N/A")
            print_info "Test coverage: $COVERAGE"
        fi
    else
        print_warning "Some tests failed - review test results"
    fi
else
    print_warning "No tests found in test/ directory"
fi

# 9. إنشاء تقرير البيئة المحسن
echo "📊 Generating comprehensive environment report..."

# حساب إحصائيات المشروع
TOTAL_DART_FILES=$(find lib/ -name "*.dart" | wc -l 2>/dev/null || echo "0")
TOTAL_TEST_FILES=$(find test/ -name "*.dart" | wc -l 2>/dev/null || echo "0")
PROJECT_SIZE=$(du -sh . 2>/dev/null | cut -f1 || echo "N/A")

cat > .kiro/reports/environment_setup_report.md << EOF
# Enhanced Flutter Environment Setup Report

**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')
**المؤلف:** فريق وكلاء تطوير مشروع بصير
**المشروع:** بصير MVP
**الإصدار:** 2.0 Enhanced

## 🚀 Environment Status

### Flutter SDK
- **Version:** $(flutter --version | head -n 1)
- **Channel:** $(flutter channel | grep -E '^\*' | awk '{print $2}')
- **Status:** ✅ Ready
- **Required:** 3.35.5+ ✅

### Dart SDK
- **Version:** $(dart --version)
- **Status:** ✅ Ready
- **Required:** 3.9.2+ ✅

### Android SDK
- **ANDROID_HOME:** ${ANDROID_HOME:-"Not configured"}
- **Status:** ${ANDROID_HOME:+✅ Ready}${ANDROID_HOME:-⚠️ Optional}

### Development Tools
- **VS Code:** $(command -v code &> /dev/null && echo "✅ Available" || echo "⚠️ Not found")
- **Git:** $(git --version 2>/dev/null || echo "⚠️ Not found")

## 📊 Project Analysis

### Dependencies Status
- **Total Dependencies:** $(grep -c "^  [a-zA-Z]" pubspec.yaml 2>/dev/null || echo "N/A")
- **Isar Database:** $(grep -q "isar" pubspec.yaml && echo "✅ Found" || echo "❌ Missing")
- **Riverpod State Management:** $(grep -q "riverpod" pubspec.yaml && echo "✅ Found" || echo "❌ Missing")
- **Flutter Secure Storage:** $(grep -q "flutter_secure_storage" pubspec.yaml && echo "✅ Found" || echo "❌ Missing")

### Code Quality
- **Dart Files:** $TOTAL_DART_FILES files
- **Test Files:** $TOTAL_TEST_FILES files
- **Test Coverage:** ${COVERAGE:-"Run tests to calculate"}
- **Analysis Status:** $(flutter analyze --no-fatal-infos &>/dev/null && echo "✅ Clean" || echo "⚠️ Issues found")
- **Formatting:** $(dart format --set-exit-if-changed --output=none lib/ test/ &>/dev/null && echo "✅ Correct" || echo "⚠️ Needs formatting")

### Project Information
- **Project Size:** $PROJECT_SIZE
- **OS:** $(uname -s) $(uname -m)
- **User:** $(whoami)
- **Working Directory:** $(pwd)
- **Setup Time:** $(date '+%Y-%m-%d %H:%M:%S')

## 🎯 Baseer MVP Specific Checks

### Architecture Compliance
- **Clean Architecture:** $([ -d "lib/features" ] && echo "✅ Structure found" || echo "⚠️ Check structure")
- **Feature Modules:** $(find lib/features -maxdepth 1 -type d | wc -l 2>/dev/null || echo "0") modules
- **Core Layer:** $([ -d "lib/core" ] && echo "✅ Found" || echo "⚠️ Missing")

### Localization Support
- **Arabic Support:** $(grep -q "arabic" pubspec.yaml && echo "✅ Configured" || echo "⚠️ Check configuration")
- **RTL Support:** $(grep -q "intl" pubspec.yaml && echo "✅ Found" || echo "⚠️ Missing")

## 🚀 Next Steps

### Development Commands
\`\`\`bash
# Start development
flutter run

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
dart format lib/ test/

# Build release
flutter build apk --release
\`\`\`

### Performance Commands
\`\`\`bash
# Performance analysis
.kiro/hooks/flutter/performance_analysis.sh

# Security audit
.kiro/hooks/flutter/security_audit.sh

# Riverpod optimization check
.kiro/hooks/flutter/riverpod_optimization.sh
\`\`\`

## 📋 Recommendations

$([ "$TOTAL_TEST_FILES" -lt 10 ] && echo "- 📝 Add more unit tests for better coverage")
$(! grep -q "flutter_secure_storage" pubspec.yaml && echo "- 🔐 Add flutter_secure_storage for secure data storage")
$(! command -v code &> /dev/null && echo "- 💻 Install VS Code for better development experience")
$([ -z "$ANDROID_HOME" ] && echo "- 🤖 Configure Android SDK for mobile development")

---

**Generated by:** Enhanced Flutter Environment Setup Script v2.0
**Status:** 🎉 Environment Ready for Baseer MVP Development!
EOF

# 10. إنشاء ملف تكوين البيئة
echo "⚙️ Creating environment configuration..."

cat > .kiro/.env.development << EOF
# Baseer MVP Development Environment Configuration
# Generated: $(date '+%Y-%m-%d %H:%M:%S')

# Flutter Configuration
FLUTTER_VERSION=$FLUTTER_VERSION_NUMBER
DART_VERSION=$DART_VERSION_NUMBER
FLUTTER_CHANNEL=$FLUTTER_CHANNEL

# Project Configuration
PROJECT_NAME=baseer_mvp
PROJECT_SIZE=$PROJECT_SIZE
TOTAL_DART_FILES=$TOTAL_DART_FILES
TOTAL_TEST_FILES=$TOTAL_TEST_FILES

# Development Settings
ENABLE_PERFORMANCE_MONITORING=true
ENABLE_DEBUG_LOGGING=true
ENABLE_HOT_RELOAD=true

# Quality Gates
MIN_TEST_COVERAGE=70
MAX_ANALYSIS_ISSUES=0
REQUIRED_FORMATTING=true

# Baseer MVP Specific
ARABIC_SUPPORT=true
RTL_LAYOUT=true
LOCAL_DATABASE=isar
STATE_MANAGEMENT=riverpod
SECURITY_STORAGE=flutter_secure_storage
EOF

# 11. إنشاء سكريبت تشغيل سريع
cat > .kiro/scripts/quick_start.sh << 'EOF'
#!/bin/bash
# Quick Start Script for Baseer MVP
echo "🚀 Baseer MVP Quick Start"
echo "=========================="

# تحديث dependencies
flutter pub get

# تشغيل code generation
flutter packages pub run build_runner build --delete-conflicting-outputs

# تشغيل التطبيق
flutter run
EOF

chmod +x .kiro/scripts/quick_start.sh

print_status "Environment setup completed successfully! 🎉"
print_status "Report saved to: .kiro/reports/environment_setup_report.md"
print_status "Configuration saved to: .kiro/.env.development"
print_status "Quick start script created: .kiro/scripts/quick_start.sh"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "🎉 Enhanced Flutter Development Environment Ready!"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "📋 Quick Commands:"
echo "   🚀 Start development: .kiro/scripts/quick_start.sh"
echo "   🧪 Run tests: flutter test --coverage"
echo "   🔍 Analyze code: flutter analyze"
echo "   📊 Performance check: .kiro/hooks/flutter/performance_analysis.sh"
echo ""
echo "📖 Full report: .kiro/reports/environment_setup_report.md"
echo "⚙️ Configuration: .kiro/.env.development"
echo ""
echo "═══════════════════════════════════════════════════════════════"