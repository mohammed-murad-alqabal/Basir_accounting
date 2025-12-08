#!/bin/bash
# Build Android - Enhanced
# Implements: KISS principle (simple and efficient build)

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

MAX_APK_SIZE_MB=50

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🤖 Enhanced Android Build - بصير MVP v2.0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Pre-build checks
echo -e "${BLUE}🔍 Pre-build checks...${NC}"

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | head -1 | awk '{print $2}')
echo "📱 Flutter version: $FLUTTER_VERSION"

# Check dependencies
echo "📦 Checking dependencies..."
flutter pub get
echo ""

# Clean previous builds
echo -e "${BLUE}🧹 Cleaning previous builds...${NC}"
flutter clean
flutter pub get
echo ""

# Build APK
echo -e "${BLUE}🏗️  Building APK (release)...${NC}"
START_TIME=$(date +%s)
flutter build apk --release
END_TIME=$(date +%s)
APK_BUILD_TIME=$((END_TIME - START_TIME))
echo -e "${GREEN}✅ APK built in ${APK_BUILD_TIME}s${NC}"
echo ""

# Check APK size (KISS principle: keep it simple and small)
if [ -f build/app/outputs/flutter-apk/app-release.apk ]; then
  APK_SIZE_MB=$(du -m build/app/outputs/flutter-apk/app-release.apk | cut -f1)
  APK_SIZE_KB=$(du -k build/app/outputs/flutter-apk/app-release.apk | cut -f1)
  
  echo "📦 APK Size: ${APK_SIZE_MB}MB (${APK_SIZE_KB}KB)"
  echo "🎯 Target: < ${MAX_APK_SIZE_MB}MB"
  
  if [ "$APK_SIZE_MB" -gt "$MAX_APK_SIZE_MB" ]; then
    echo -e "${YELLOW}⚠️  APK size exceeds target${NC}"
    echo -e "${YELLOW}💡 KISS Principle: Keep the app simple and lightweight${NC}"
  else
    echo -e "${GREEN}✅ APK size is within target${NC}"
  fi
  echo ""
fi

# Build App Bundle
echo -e "${BLUE}🏗️  Building App Bundle (release)...${NC}"
START_TIME=$(date +%s)
flutter build appbundle --release
END_TIME=$(date +%s)
AAB_BUILD_TIME=$((END_TIME - START_TIME))
echo -e "${GREEN}✅ App Bundle built in ${AAB_BUILD_TIME}s${NC}"
echo ""

# Check App Bundle size
if [ -f build/app/outputs/bundle/release/app-release.aab ]; then
  AAB_SIZE_MB=$(du -m build/app/outputs/bundle/release/app-release.aab | cut -f1)
  AAB_SIZE_KB=$(du -k build/app/outputs/bundle/release/app-release.aab | cut -f1)
  
  echo "📦 App Bundle Size: ${AAB_SIZE_MB}MB (${AAB_SIZE_KB}KB)"
  echo ""
fi

# Final report
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Android Build Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Build Status: SUCCESS"
echo ""
echo "📦 Artifacts:"
echo "   APK: build/app/outputs/flutter-apk/app-release.apk"
echo "   Size: ${APK_SIZE_MB}MB"
echo "   Build time: ${APK_BUILD_TIME}s"
echo ""
echo "   App Bundle: build/app/outputs/bundle/release/app-release.aab"
echo "   Size: ${AAB_SIZE_MB}MB"
echo "   Build time: ${AAB_BUILD_TIME}s"
echo ""
echo "🎯 KISS Principle: Simple, efficient build process"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📅 Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
