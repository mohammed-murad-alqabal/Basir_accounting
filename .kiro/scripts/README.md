# Enhanced Scripts - بصير MVP v2.0

**Project:** Basser MVP  
**Date:** December 8, 2025  
**Version:** 2.0 (Enhanced)  
**Status:** ✅ Active

---

## 🎯 Philosophy Principles

All scripts implement our core principles:

- ⭐ **KISS** - Keep It Simple, Stupid
- ⭐ **Security First** - No compromises on security
- ⭐ **Quality First** - 70%+ test coverage
- ⭐ **ENGLISH FOR CODE** - All code in English

---

## 📁 Categories

### Setup (4 scripts)

| Script                     | Description            | Principles     |
| :------------------------- | :--------------------- | :------------- |
| `setup-project.sh`         | Complete project setup | KISS           |
| `install-dependencies.sh`  | Install dependencies   | KISS           |
| `configure-environment.sh` | Configure environment  | Security First |
| `setup-git-hooks.sh`       | Setup git hooks        | Quality First  |

### Testing (8 scripts) ✨

| Script                      | Description                         | Principles           |
| :-------------------------- | :---------------------------------- | :------------------- |
| `run-tests.sh`              | Run all tests                       | Quality First        |
| `generate-coverage.sh`      | Generate coverage report (Enhanced) | Quality First (70%+) |
| `run-integration-tests.sh`  | Run integration tests               | Quality First        |
| `check-quality.sh`          | Check code quality                  | All principles       |
| `check-quality-enhanced.sh` | **Enhanced quality check** ⭐       | **All principles**   |
| `performance-test.sh`       | **Performance testing** 🆕          | **Quality First**    |
| `accessibility-test.sh`     | **Accessibility testing** 🆕        | **Quality First**    |
| `i18n-test.sh`              | **I18n testing** 🆕                 | **Quality First**    |

### Deployment (6 scripts) 🆕

| Script             | Description                 | Principles |
| :----------------- | :-------------------------- | :--------- |
| `build-android.sh` | Build Android (Enhanced)    | KISS       |
| `build-ios.sh`     | **Build iOS (Enhanced)** 🆕 | KISS       |
| `build-web.sh`     | **Build Web (Enhanced)** 🆕 | KISS       |
| `build-all.sh`     | Build all platforms         | KISS       |

### Maintenance (5 scripts) 🆕

| Script                   | Description                       | Principles     |
| :----------------------- | :-------------------------------- | :------------- |
| `cleanup.sh`             | Clean build artifacts             | KISS           |
| `update-dependencies.sh` | **Update dependencies (Safe)** 🆕 | Security First |
| `backup.sh`              | Backup project                    | Security First |
| `format-code.sh`         | Format code                       | Quality First  |

### Documentation (1 script) 🆕

| Script             | Description                   | Principles    |
| :----------------- | :---------------------------- | :------------ |
| `generate-docs.sh` | **Generate documentation** 🆕 | Quality First |

---

## 🚀 Quick Start

### Make Scripts Executable

```bash
# Make all scripts executable
chmod +x .kiro/scripts/**/*.sh

# Or individually
chmod +x .kiro/scripts/testing/check-quality-enhanced.sh
```

### Run Enhanced Quality Check ⭐

```bash
# Run the enhanced quality check (recommended)
./.kiro/scripts/testing/check-quality-enhanced.sh
```

**What it checks:**

- ✅ Code formatting
- ✅ Static analysis
- ✅ ENGLISH FOR CODE principle
- ✅ KISS principle (complexity)
- ✅ Line length (80 chars)
- ✅ Security First (no hardcoded secrets)
- ✅ Test coverage (70%+)
- ✅ All tests pass

### Generate Enhanced Coverage Report

```bash
# Generate coverage with detailed report
./.kiro/scripts/testing/generate-coverage.sh
```

**Outputs:**

- 📄 HTML report: `coverage/html/index.html`
- 📋 Detailed report: `coverage/detailed_report.txt`
- 📊 LCOV data: `coverage/lcov.info`

### Build Android (Enhanced)

```bash
# Build Android with size check
./.kiro/scripts/deployment/build-android.sh
```

**Features:**

- ✅ Pre-build checks
- ✅ Clean build
- ✅ APK + App Bundle
- ✅ Size validation (KISS: < 50MB)
- ✅ Build time tracking

---

## 📊 Enhanced Features (v2.0)

### What's New

1. **Philosophy Principles Integration** ⭐

   - All scripts now implement core principles
   - Automated checks for KISS, Security First, Quality First
   - ENGLISH FOR CODE validation

2. **Better Error Handling**

   - Colored output for better readability
   - Detailed error messages
   - Exit codes for CI/CD integration

3. **Comprehensive Reporting**

   - Detailed summaries
   - Metrics tracking
   - Actionable recommendations

4. **Performance Tracking**
   - Build time measurement
   - Size tracking
   - Coverage trends

---

## 💡 Usage Examples

### Example 1: Pre-commit Quality Check

```bash
# Run before committing
./.kiro/scripts/testing/check-quality-enhanced.sh

# If all checks pass, commit
git add .
git commit -m "feat(feature): add new feature"
```

### Example 2: Pre-deployment Build

```bash
# 1. Run quality checks
./.kiro/scripts/testing/check-quality-enhanced.sh

# 2. Generate coverage report
./.kiro/scripts/testing/generate-coverage.sh

# 3. Build for Android
./.kiro/scripts/deployment/build-android.sh
```

### Example 3: CI/CD Integration

```bash
# In your CI/CD pipeline
./.kiro/scripts/testing/check-quality-enhanced.sh || exit 1
./.kiro/scripts/deployment/build-android.sh || exit 1
```

---

## 🔍 Script Details

### check-quality-enhanced.sh ⭐

**Enhanced quality check with philosophy principles**

**Checks:**

1. Code formatting (dart format)
2. Static analysis (flutter analyze)
3. ENGLISH FOR CODE (no Arabic in code)
4. KISS principle (function complexity < 30 lines)
5. Line length (< 80 characters)
6. Security First (no hardcoded secrets)
7. All tests pass
8. Coverage ≥ 70% (Quality First)

**Exit Codes:**

- `0` - All checks passed
- `1` - One or more checks failed

**Example Output:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 Enhanced Quality Check - بصير MVP v2.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 Checking code formatting...
✅ Code is properly formatted

🔬 Running static analysis...
✅ No analysis issues found

🌍 Checking ENGLISH FOR CODE principle...
✅ All code is in English

🎯 Checking KISS principle (function complexity)...
✅ No overly complex functions (>30 lines)

📏 Checking line length (max: 80)...
✅ All lines within 80 characters

🔒 Security First - Checking for hardcoded secrets...
✅ No hardcoded secrets found

🧪 Running tests...
✅ All tests passed

📊 Checking test coverage (Quality First: 70%+)...
📈 Coverage: 72.5%
🎯 Target: 70%
✅ Coverage meets target: 72.5% ≥ 70%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Quality Check Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ All quality checks passed!

🎯 Philosophy Principles Applied:
   ✅ KISS - Code complexity checked
   ✅ ENGLISH FOR CODE - Code language validated
   ✅ Security First - No hardcoded secrets
   ✅ Quality First - 70%+ coverage maintained

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🎓 Best Practices

### 1. Run Quality Checks Before Commit

```bash
# Add to your workflow
./.kiro/scripts/testing/check-quality-enhanced.sh && git commit
```

### 2. Generate Coverage Reports Regularly

```bash
# Weekly coverage check
./.kiro/scripts/testing/generate-coverage.sh
```

### 3. Use Enhanced Scripts in CI/CD

```yaml
# In .github/workflows/ci.yml
- name: Quality Check
  run: ./.kiro/scripts/testing/check-quality-enhanced.sh
```

---

## 📚 References

### Internal

- **Philosophy:** `.kiro/steering/core/philosophy.md`
- **Standards:** `.kiro/steering/standards/`
- **Workflows:** `.github/workflows/enhanced_ci.yml`

### External

- [Flutter Testing](https://flutter.dev/docs/testing)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [LCOV](http://ltp.sourceforge.net/coverage/lcov.php)

---

## 🆕 New Scripts (v2.0)

### 1. build-ios.sh (Enhanced iOS Build)

**Description:** Enhanced iOS build script with philosophy principles

**Features:**

- ✅ Pre-build checks (Flutter, Xcode)
- ✅ Quality checks (format, analyze, tests)
- ✅ Build tracking (time, size)
- ✅ IPA size validation (KISS: <50MB)
- ✅ Comprehensive reporting

**Usage:**

```bash
./.kiro/scripts/deployment/build-ios.sh
```

### 2. build-web.sh (Enhanced Web Build)

**Description:** Enhanced web build script with asset optimization

**Features:**

- ✅ Pre-build checks
- ✅ Quality checks
- ✅ Asset compression (PNG, JPEG)
- ✅ Bundle size validation (KISS: <5MB)
- ✅ Gzip compression
- ✅ Comprehensive reporting

**Usage:**

```bash
./.kiro/scripts/deployment/build-web.sh
```

### 3. update-dependencies.sh (Safe Dependency Updates)

**Description:** Safe dependency update script with rollback

**Features:**

- ✅ Automatic backup creation
- ✅ Outdated package detection
- ✅ Interactive confirmation (COLLABORATION FIRST)
- ✅ Automatic testing after update
- ✅ Security audit
- ✅ Automatic rollback on failure

**Usage:**

```bash
./.kiro/scripts/maintenance/update-dependencies.sh
```

### 4. generate-docs.sh (Documentation Generator)

**Description:** Automatic documentation generator

**Features:**

- ✅ DartDoc generation
- ✅ HTML enhancement with custom CSS
- ✅ PDF generation (optional)
- ✅ Coverage report integration
- ✅ GitHub Pages deployment (optional)
- ✅ Comprehensive index

**Usage:**

```bash
./.kiro/scripts/documentation/generate-docs.sh
```

### 5. performance-test.sh (Performance Testing)

**Description:** Performance testing and profiling

**Features:**

- ✅ Startup time measurement
- ✅ Memory usage tracking
- ✅ Frame performance analysis
- ✅ Navigation performance
- ✅ Build size checking
- ✅ Detailed recommendations

**Usage:**

```bash
./.kiro/scripts/testing/performance-test.sh
```

### 6. accessibility-test.sh (Accessibility Testing)

**Description:** Comprehensive accessibility testing

**Features:**

- ✅ Semantic labels check
- ✅ Contrast ratio validation
- ✅ Text size verification
- ✅ Touch target size check
- ✅ Keyboard navigation support
- ✅ Screen reader compatibility
- ✅ RTL support verification

**Usage:**

```bash
./.kiro/scripts/testing/accessibility-test.sh
```

### 7. i18n-test.sh (Internationalization Testing)

**Description:** I18n and localization testing

**Features:**

- ✅ Translation file detection
- ✅ Missing keys detection
- ✅ Hardcoded strings check
- ✅ RTL support verification
- ✅ Text overflow handling
- ✅ Locale switching validation
- ✅ Date/number formatting check

**Usage:**

```bash
./.kiro/scripts/testing/i18n-test.sh
```

### 8. Git Hooks (Enhanced)

**Location:** `.githooks/`

**Files:**

- `pre-commit` - Runs before each commit
- `pre-push` - Runs before each push
- `README.md` - Installation and usage guide

**Features:**

- ✅ Code formatting check
- ✅ Static analysis
- ✅ Security checks (hardcoded secrets)
- ✅ Commit message format validation
- ✅ ENGLISH FOR CODE validation
- ✅ KISS principle check
- ✅ Test execution
- ✅ Coverage validation (70%+)

**Installation:**

```bash
# Method 1: Manual
cp .githooks/pre-commit .git/hooks/pre-commit
cp .githooks/pre-push .git/hooks/pre-push
chmod +x .git/hooks/pre-commit .git/hooks/pre-push

# Method 2: Git config
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit .githooks/pre-push
```

---

## 🔄 Version History

### v2.0 (December 8, 2025) - Current ⭐

**Major enhancements:**

- Integrated philosophy principles (KISS, Security First, Quality First)
- Added `check-quality-enhanced.sh` with comprehensive checks
- Enhanced `generate-coverage.sh` with detailed reporting
- Enhanced `build-android.sh` with size validation
- Improved error handling and colored output
- Added performance tracking

### v1.0 (Before December 8, 2025)

**Original scripts:**

- Basic quality checks
- Simple coverage generation
- Standard build scripts

---

**Prepared by:** Basser Project Development Agents Team  
**Date:** December 8, 2025  
**Version:** 2.0  
**Status:** ✅ Active and Enhanced
