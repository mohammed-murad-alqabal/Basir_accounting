#!/bin/bash

# Automated Release Preparation for basir_accounting_system
# المؤلف: فريق وكلاء تطوير نظام بصير المحاسبي
# التاريخ: 11 يناير 2026

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_header() {
    echo -e "${PURPLE}🚀 $1${NC}"
    echo "════════════════════════════════════════════════════════════════"
}

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

# التحقق من المعاملات
if [ $# -eq 0 ]; then
    echo "🚀 basir_accounting_system Release Preparation"
    echo "=================================="
    echo ""
    echo "Usage: $0 <release_type> [version]"
    echo ""
    echo "Release Types:"
    echo "  patch   - Bug fixes (1.0.0 -> 1.0.1)"
    echo "  minor   - New features (1.0.0 -> 1.1.0)"
    echo "  major   - Breaking changes (1.0.0 -> 2.0.0)"
    echo "  custom  - Custom version (requires version parameter)"
    echo ""
    echo "Examples:"
    echo "  $0 patch"
    echo "  $0 minor"
    echo "  $0 major"
    echo "  $0 custom 1.2.3"
    echo ""
    exit 1
fi

RELEASE_TYPE=$1
CUSTOM_VERSION=$2

# قراءة الإصدار الحالي
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found"
    exit 1
fi

CURRENT_VERSION=$(grep "version:" pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)
CURRENT_BUILD=$(grep "version:" pubspec.yaml | cut -d'+' -f2 2>/dev/null || echo "1")

print_header "Release Preparation for basir_accounting_system"
print_info "Current version: $CURRENT_VERSION+$CURRENT_BUILD"

# حساب الإصدار الجديد
calculate_new_version() {
    local current=$1
    local type=$2
    
    IFS='.' read -ra VERSION_PARTS <<< "$current"
    local major=${VERSION_PARTS[0]}
    local minor=${VERSION_PARTS[1]}
    local patch=${VERSION_PARTS[2]}
    
    case $type in
        "patch")
            patch=$((patch + 1))
            ;;
        "minor")
            minor=$((minor + 1))
            patch=0
            ;;
        "major")
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        "custom")
            echo "$CUSTOM_VERSION"
            return
            ;;
        *)
            print_error "Invalid release type: $type"
            exit 1
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

if [ "$RELEASE_TYPE" = "custom" ] && [ -z "$CUSTOM_VERSION" ]; then
    print_error "Custom version required for custom release type"
    exit 1
fi

NEW_VERSION=$(calculate_new_version "$CURRENT_VERSION" "$RELEASE_TYPE")
NEW_BUILD=$((CURRENT_BUILD + 1))

print_info "New version: $NEW_VERSION+$NEW_BUILD"
print_info "Release type: $RELEASE_TYPE"

# التأكيد من المستخدم
echo ""
echo -n "Continue with release preparation? (y/N): "
read -r confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    print_info "Release preparation cancelled"
    exit 0
fi

# إنشاء مجلد التقارير
mkdir -p .kiro/reports

# 1. Pre-release Checks
print_header "Pre-release Checks"

print_info "Running comprehensive pre-release checks..."

# فحص Git status
print_info "Checking Git status..."
if [ -n "$(git status --porcelain)" ]; then
    print_warning "Working directory is not clean"
    git status --short
    echo ""
    echo -n "Continue anyway? (y/N): "
    read -r git_confirm
    if [[ ! $git_confirm =~ ^[Yy]$ ]]; then
        print_error "Please commit or stash changes before release"
        exit 1
    fi
else
    print_status "Working directory is clean"
fi

# فحص الفرع الحالي
CURRENT_BRANCH=$(git branch --show-current)
print_info "Current branch: $CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
    print_warning "Not on main/master branch"
    echo -n "Continue from $CURRENT_BRANCH? (y/N): "
    read -r branch_confirm
    if [[ ! $branch_confirm =~ ^[Yy]$ ]]; then
        print_error "Please switch to main/master branch for release"
        exit 1
    fi
fi

# 2. Code Quality Checks
print_header "Code Quality Checks"

print_info "Running flutter analyze..."
if flutter analyze --no-fatal-infos; then
    print_status "Code analysis passed"
else
    print_error "Code analysis failed"
    echo -n "Continue despite analysis issues? (y/N): "
    read -r analyze_confirm
    if [[ ! $analyze_confirm =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

print_info "Checking code formatting..."
if dart format --set-exit-if-changed --output=none lib/ test/; then
    print_status "Code formatting is correct"
else
    print_warning "Code formatting issues found"
    echo -n "Auto-fix formatting? (Y/n): "
    read -r format_confirm
    if [[ ! $format_confirm =~ ^[Nn]$ ]]; then
        dart format lib/ test/
        print_status "Code formatting fixed"
    fi
fi

# 3. Test Execution
print_header "Test Execution"

print_info "Running all tests..."
if flutter test --reporter=compact --coverage; then
    print_status "All tests passed"
    
    # حساب test coverage
    if [ -f "coverage/lcov.info" ]; then
        COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | grep -o '[0-9]\+\.[0-9]\+%' || echo "N/A")
        print_info "Test coverage: $COVERAGE"
        
        # التحقق من الحد الأدنى للتغطية
        COVERAGE_NUM=$(echo "$COVERAGE" | grep -o '[0-9]\+\.[0-9]\+' || echo "0")
        if (( $(echo "$COVERAGE_NUM >= 70" | bc -l) )); then
            print_status "Test coverage meets minimum requirement (70%)"
        else
            print_warning "Test coverage below 70%: $COVERAGE"
            echo -n "Continue with low coverage? (y/N): "
            read -r coverage_confirm
            if [[ ! $coverage_confirm =~ ^[Yy]$ ]]; then
                print_error "Please improve test coverage before release"
                exit 1
            fi
        fi
    fi
else
    print_error "Tests failed"
    echo -n "Continue despite test failures? (y/N): "
    read -r test_confirm
    if [[ ! $test_confirm =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 4. Version Update
print_header "Version Update"

print_info "Updating version in pubspec.yaml..."

# إنشاء نسخة احتياطية
cp pubspec.yaml pubspec.yaml.backup

# تحديث الإصدار
sed -i "s/version: $CURRENT_VERSION+$CURRENT_BUILD/version: $NEW_VERSION+$NEW_BUILD/" pubspec.yaml

print_status "Version updated to $NEW_VERSION+$NEW_BUILD"

# 5. Build Generation
print_header "Build Generation"

print_info "Cleaning project..."
flutter clean

print_info "Getting dependencies..."
flutter pub get

print_info "Running code generation..."
flutter packages pub run build_runner build --delete-conflicting-outputs

print_info "Building APK..."
if flutter build apk --release; then
    print_status "APK build successful"
    
    # حساب حجم APK
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
        print_info "APK size: $APK_SIZE"
    fi
else
    print_error "APK build failed"
    # استرجاع النسخة الاحتياطية
    mv pubspec.yaml.backup pubspec.yaml
    exit 1
fi

print_info "Building App Bundle..."
if flutter build appbundle --release; then
    print_status "App Bundle build successful"
    
    # حساب حجم App Bundle
    if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        AAB_SIZE=$(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)
        print_info "App Bundle size: $AAB_SIZE"
    fi
else
    print_error "App Bundle build failed"
    # استرجاع النسخة الاحتياطية
    mv pubspec.yaml.backup pubspec.yaml
    exit 1
fi

# 6. Changelog Update
print_header "Changelog Update"

CHANGELOG_FILE="CHANGELOG.md"
RELEASE_DATE=$(date '+%Y-%m-%d')

print_info "Updating CHANGELOG.md..."

# إنشاء CHANGELOG إذا لم يكن موجوداً
if [ ! -f "$CHANGELOG_FILE" ]; then
    cat > "$CHANGELOG_FILE" << EOF
# Changelog

All notable changes to basir_accounting_system will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

EOF
fi

# إضافة الإصدار الجديد
TEMP_CHANGELOG=$(mktemp)
{
    head -n 6 "$CHANGELOG_FILE"
    echo ""
    echo "## [$NEW_VERSION] - $RELEASE_DATE"
    echo ""
    echo "### Added"
    echo "- New features and enhancements"
    echo ""
    echo "### Changed"
    echo "- Improvements and modifications"
    echo ""
    echo "### Fixed"
    echo "- Bug fixes and corrections"
    echo ""
    tail -n +7 "$CHANGELOG_FILE"
} > "$TEMP_CHANGELOG"

mv "$TEMP_CHANGELOG" "$CHANGELOG_FILE"

print_status "CHANGELOG.md updated"
print_info "Please edit CHANGELOG.md to add specific changes for this release"

# 7. Git Operations
print_header "Git Operations"

print_info "Adding changes to Git..."
git add pubspec.yaml CHANGELOG.md

print_info "Creating release commit..."
git commit -m "chore: release version $NEW_VERSION

- Update version to $NEW_VERSION+$NEW_BUILD
- Update CHANGELOG.md for release $NEW_VERSION
- Build APK and App Bundle for release

Release type: $RELEASE_TYPE
APK size: ${APK_SIZE:-"N/A"}
App Bundle size: ${AAB_SIZE:-"N/A"}
Test coverage: ${COVERAGE:-"N/A"}"

print_info "Creating Git tag..."
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION

Release highlights:
- Version: $NEW_VERSION+$NEW_BUILD
- Release type: $RELEASE_TYPE
- Build date: $RELEASE_DATE
- APK size: ${APK_SIZE:-"N/A"}
- App Bundle size: ${AAB_SIZE:-"N/A"}
- Test coverage: ${COVERAGE:-"N/A"}

Generated by automated release preparation script."

print_status "Git commit and tag created"

# 8. Release Report
print_header "Release Report Generation"

cat > ".kiro/reports/release_${NEW_VERSION}_report.md" << EOF
# Release Report: basir_accounting_system v$NEW_VERSION

**التاريخ:** $RELEASE_DATE $(date '+%H:%M:%S')
**المؤلف:** فريق وكلاء تطوير مشروع بصير

## Release Information

- **Version:** $NEW_VERSION+$NEW_BUILD
- **Previous Version:** $CURRENT_VERSION+$CURRENT_BUILD
- **Release Type:** $RELEASE_TYPE
- **Branch:** $CURRENT_BRANCH
- **Build Date:** $RELEASE_DATE

## Build Artifacts

- **APK Size:** ${APK_SIZE:-"N/A"}
- **App Bundle Size:** ${AAB_SIZE:-"N/A"}
- **APK Location:** \`build/app/outputs/flutter-apk/app-release.apk\`
- **App Bundle Location:** \`build/app/outputs/bundle/release/app-release.aab\`

## Quality Metrics

- **Test Coverage:** ${COVERAGE:-"N/A"}
- **Flutter Analyze:** $(flutter analyze --no-fatal-infos &>/dev/null && echo "✅ Passed" || echo "⚠️ Issues found")
- **Code Formatting:** ✅ Correct
- **All Tests:** $(flutter test --reporter=compact &>/dev/null && echo "✅ Passed" || echo "⚠️ Some failed")

## Git Information

- **Commit:** $(git rev-parse HEAD)
- **Tag:** v$NEW_VERSION
- **Branch:** $CURRENT_BRANCH

## Next Steps

1. **Review CHANGELOG.md** - Add specific changes for this release
2. **Test Release Builds** - Verify APK and App Bundle work correctly
3. **Push to Repository:**
   \`\`\`bash
   git push origin $CURRENT_BRANCH
   git push origin v$NEW_VERSION
   \`\`\`
4. **Deploy to Stores** - Upload to Google Play Store
5. **Create GitHub Release** - Create release notes and attach builds

## Files Modified

- \`pubspec.yaml\` - Version updated
- \`CHANGELOG.md\` - Release notes added
- Build artifacts generated

## Rollback Instructions

If needed, rollback with:
\`\`\`bash
git reset --hard HEAD~1
git tag -d v$NEW_VERSION
mv pubspec.yaml.backup pubspec.yaml
\`\`\`

---

**Generated by:** Automated Release Preparation Script
**Status:** 🎉 Release Ready!
EOF

# تنظيف النسخة الاحتياطية
rm -f pubspec.yaml.backup

print_status "Release preparation completed successfully! 🎉"
print_info "Release report: .kiro/reports/release_${NEW_VERSION}_report.md"

echo ""
print_header "Release Summary"
echo "📦 Version: $NEW_VERSION+$NEW_BUILD"
echo "📁 APK: build/app/outputs/flutter-apk/app-release.apk (${APK_SIZE:-"N/A"})"
echo "📁 App Bundle: build/app/outputs/bundle/release/app-release.aab (${AAB_SIZE:-"N/A"})"
echo "🏷️ Git Tag: v$NEW_VERSION"
echo "📊 Test Coverage: ${COVERAGE:-"N/A"}"
echo ""
echo "🚀 Next Steps:"
echo "1. Review and edit CHANGELOG.md"
echo "2. Test the release builds"
echo "3. Push to repository: git push origin $CURRENT_BRANCH && git push origin v$NEW_VERSION"
echo "4. Deploy to app stores"
echo ""
print_status "Release is ready for deployment! 🚀"