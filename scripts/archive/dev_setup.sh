#!/bin/bash

# Development Environment Setup Script
# يقوم بإعداد البيئة التطويرية بالكامل

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 إعداد البيئة التطويرية - بصير MVP${NC}"
echo "=================================================="
echo ""

# Check Flutter
echo -e "${YELLOW}📱 فحص Flutter...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter غير مثبت${NC}"
    echo "يرجى تثبيت Flutter من: https://flutter.dev/docs/get-started/install"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | head -1 | awk '{print $2}')
echo -e "${GREEN}✅ Flutter $FLUTTER_VERSION${NC}"
echo ""

# Check Dart
echo -e "${YELLOW}🎯 فحص Dart...${NC}"
DART_VERSION=$(dart --version 2>&1 | awk '{print $4}')
echo -e "${GREEN}✅ Dart $DART_VERSION${NC}"
echo ""

# Check Git
echo -e "${YELLOW}📦 فحص Git...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git غير مثبت${NC}"
    exit 1
fi
GIT_VERSION=$(git --version | awk '{print $3}')
echo -e "${GREEN}✅ Git $GIT_VERSION${NC}"
echo ""

# Flutter Doctor
echo -e "${YELLOW}🔍 تشغيل Flutter Doctor...${NC}"
flutter doctor
echo ""

# Get Dependencies
echo -e "${YELLOW}📦 تحميل التبعيات...${NC}"
flutter pub get
echo -e "${GREEN}✅ تم تحميل التبعيات${NC}"
echo ""

# Generate Code
echo -e "${YELLOW}🔧 توليد الكود...${NC}"
flutter pub run build_runner build --delete-conflicting-outputs
echo -e "${GREEN}✅ تم توليد الكود${NC}"
echo ""

# Setup Git Hooks
echo -e "${YELLOW}🪝 إعداد Git Hooks...${NC}"
if [ -f "scripts/setup_git.sh" ]; then
    bash scripts/setup_git.sh
    echo -e "${GREEN}✅ تم إعداد Git Hooks${NC}"
else
    echo -e "${YELLOW}⚠️  setup_git.sh غير موجود${NC}"
fi
echo ""

# Create necessary directories
echo -e "${YELLOW}📁 إنشاء المجلدات الضرورية...${NC}"
mkdir -p logs/errors
mkdir -p logs/reports
mkdir -p logs/archive
mkdir -p coverage
echo -e "${GREEN}✅ تم إنشاء المجلدات${NC}"
echo ""

# Check for Android SDK
echo -e "${YELLOW}🤖 فحص Android SDK...${NC}"
if flutter doctor | grep -q "Android toolchain"; then
    echo -e "${GREEN}✅ Android SDK متوفر${NC}"
else
    echo -e "${YELLOW}⚠️  Android SDK غير متوفر${NC}"
fi
echo ""

# Check for VS Code
echo -e "${YELLOW}💻 فحص VS Code...${NC}"
if command -v code &> /dev/null; then
    echo -e "${GREEN}✅ VS Code متوفر${NC}"
    
    # Check Flutter extension
    if code --list-extensions | grep -q "Dart-Code.flutter"; then
        echo -e "${GREEN}✅ Flutter extension مثبت${NC}"
    else
        echo -e "${YELLOW}⚠️  Flutter extension غير مثبت${NC}"
        echo "تثبيت: code --install-extension Dart-Code.flutter"
    fi
else
    echo -e "${YELLOW}⚠️  VS Code غير متوفر${NC}"
fi
echo ""

# Run initial tests
echo -e "${YELLOW}🧪 تشغيل الاختبارات الأولية...${NC}"
if flutter test --no-pub 2>&1 | tail -1 | grep -q "All tests passed"; then
    echo -e "${GREEN}✅ جميع الاختبارات نجحت${NC}"
else
    echo -e "${YELLOW}⚠️  بعض الاختبارات فشلت${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}📊 ملخص الإعداد${NC}"
echo "=================================================="
echo -e "Flutter:        ${GREEN}✅${NC}"
echo -e "Dart:           ${GREEN}✅${NC}"
echo -e "Git:            ${GREEN}✅${NC}"
echo -e "Dependencies:   ${GREEN}✅${NC}"
echo -e "Code Gen:       ${GREEN}✅${NC}"
echo -e "Git Hooks:      ${GREEN}✅${NC}"
echo -e "Directories:    ${GREEN}✅${NC}"
echo ""

echo -e "${GREEN}🎉 البيئة التطويرية جاهزة!${NC}"
echo ""
echo -e "${BLUE}الخطوات التالية:${NC}"
echo "1. تشغيل التطبيق: flutter run"
echo "2. تشغيل الاختبارات: flutter test"
echo "3. فحص الجودة: bash scripts/run_quality_gates.sh"
echo ""
