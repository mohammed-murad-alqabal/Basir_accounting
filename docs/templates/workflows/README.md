# Enhanced Workflow Templates - بصير MVP v2.0

**Project:** Basir App  
**Date:** December 8, 2025  
**Version:** 2.0 (Enhanced)  
**Status:** ✅ Active

---

## 🎯 Philosophy Principles

All workflows implement our core principles:

- ⭐ **COLLABORATION FIRST** - Validate commit messages
- ⭐ **KISS** - Check code complexity
- ⭐ **ENGLISH FOR CODE** - Validate code language
- ⭐ **Security First** - Check for secrets
- ⭐ **Quality First** - Enforce 70%+ coverage

---

## 📁 Available Workflows

### 1. enhanced_ci.yml ⭐ (Recommended)

**Enhanced CI with philosophy principles integration**

**Location:** `.github/workflows/enhanced_ci.yml`

**Features:**

- ✅ Standards validation (commit messages, English code, KISS)
- ✅ Code quality checks (formatting, analysis, line length)
- ✅ Comprehensive testing (70%+ coverage)
- ✅ Security scanning (secrets, dependencies)
- ✅ Build validation (APK size check)
- ✅ Detailed final report

**Jobs:**

1. **validate-standards** - Philosophy principles checks
2. **code-quality** - Formatting, analysis, line length
3. **testing** - Tests with coverage validation
4. **security** - Security First checks
5. **build** - Android build with size check
6. **report** - Comprehensive final report

**Triggers:**

- Push to `main` or `develop`
- Pull requests to `main` or `develop`
- Manual workflow dispatch

### 2. flutter_ci.yml (Current Production)

**Current production CI/CD workflow**

**Location:** `.github/workflows/flutter_ci.yml`

**Features:**

- ✅ Analysis and testing
- ✅ Android build
- ✅ iOS build (optional)
- ✅ Security scan
- ✅ Final report

**Status:** Active, will be replaced by enhanced_ci.yml

### 3. ci_template.yml (Template)

**Basic CI template**

**Location:** `.kiro/templates/workflows/ci_template.yml`

**Usage:** Copy to `.github/workflows/` for basic CI

### 4. cd_template.yml (Template)

**Basic CD template**

**Location:** `.kiro/templates/workflows/cd_template.yml`

**Usage:** Copy to `.github/workflows/` for deployment

### 5. quality_gate_template.yml (Template)

**Quality gate template**

**Location:** `.kiro/templates/workflows/quality_gate_template.yml`

**Usage:** Copy to `.github/workflows/` for quality checks

---

## 🚀 Quick Start

### Option 1: Use Enhanced CI (Recommended) ⭐

The enhanced CI is already in place at `.github/workflows/enhanced_ci.yml`

**No action needed!** It will run automatically on:

- Push to `main` or `develop`
- Pull requests
- Manual trigger

### Option 2: Use Templates

```bash
# Copy template to workflows directory
cp .kiro/templates/workflows/ci_template.yml .github/workflows/my_ci.yml

# Edit as needed
nano .github/workflows/my_ci.yml

# Commit and push
git add .github/workflows/my_ci.yml
git commit -m "ci: add custom CI workflow"
git push
```

---

## 📊 Enhanced CI Details

### Standards Validation Job

**Checks:**

1. **Commit Messages** (COLLABORATION FIRST)

   - Validates Conventional Commits format
   - Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build
   - Format: `type(scope): description`

2. **English for Code** (ENGLISH FOR CODE)

   - Checks for Arabic in code (excluding comments/strings)
   - Ensures all code is in English

3. **KISS Principle**
   - Checks function complexity
   - Flags functions > 30 lines
   - Recommends breaking down complex functions

**Example Output:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Commit Message Validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Valid: feat(customers): add search functionality
✅ Valid: fix(invoices): resolve PDF encoding issue

✅ All commit messages are valid

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Code Quality Job

**Checks:**

1. **Formatting**

   - Validates code formatting
   - Uses `dart format`

2. **Static Analysis**

   - Runs `flutter analyze --fatal-infos`
   - Catches potential issues

3. **Line Length**
   - Checks for lines > 80 characters
   - Recommends breaking long lines

### Testing Job

**Checks:**

1. **All Tests**

   - Runs all unit, widget, and integration tests
   - Uses `flutter test --coverage`

2. **Coverage Validation** (Quality First)
   - Enforces 70%+ coverage
   - Fails if below threshold
   - Uploads to Codecov

### Security Job

**Checks:**

1. **Hardcoded Secrets** (Security First)

   - Scans for passwords, API keys, tokens
   - Fails if secrets found
   - Recommends flutter_secure_storage

2. **Password Hashing**

   - Checks for proper password hashing
   - Recommends SHA-256+

3. **Dependencies**
   - Checks for outdated dependencies
   - Scans for vulnerabilities

### Build Job

**Checks:**

1. **Android Build**

   - Builds release APK
   - Checks APK size (< 50MB)
   - Uploads artifact

2. **Size Validation** (KISS)
   - Ensures app stays lightweight
   - Warns if > 50MB

---

## 💡 Usage Examples

### Example 1: Trigger Enhanced CI

```bash
# Push to main (triggers CI)
git push origin main

# Create PR (triggers CI)
gh pr create --title "feat: add feature" --body "Description"

# Manual trigger
gh workflow run enhanced_ci.yml
```

### Example 2: Check CI Status

```bash
# View workflow runs
gh run list --workflow=enhanced_ci.yml

# View specific run
gh run view <run-id>

# View logs
gh run view <run-id> --log
```

### Example 3: Debug Failed CI

```bash
# Download logs
gh run view <run-id> --log > ci_logs.txt

# Check specific job
gh run view <run-id> --job=<job-id>
```

---

## 🎓 Best Practices

### 1. Always Use Enhanced CI

The enhanced CI provides comprehensive checks aligned with our philosophy principles.

### 2. Fix Issues Locally First

```bash
# Run quality checks locally before pushing
./.kiro/scripts/testing/check-quality-enhanced.sh

# If all pass, push
git push
```

### 3. Monitor CI Results

- Check CI status before merging PRs
- Fix all failures before merging
- Maintain 70%+ coverage

### 4. Use Conventional Commits

```bash
# Good commit messages
git commit -m "feat(customers): add search functionality"
git commit -m "fix(invoices): resolve PDF encoding"
git commit -m "docs(readme): update installation guide"

# Bad commit messages
git commit -m "update"
git commit -m "fix bug"
git commit -m "changes"
```

---

## 📚 References

### Internal

- **Philosophy:** `.kiro/steering/core/philosophy.md`
- **Standards:** `.kiro/steering/standards/`
- **Scripts:** `.kiro/scripts/README.md`
- **Enhanced CI:** `.github/workflows/enhanced_ci.yml`

### External

- [GitHub Actions](https://docs.github.com/en/actions)
- [Conventional Commits](https://www.conventionalcommits.org)
- [Flutter CI/CD](https://flutter.dev/docs/deployment/cd)

---

## 🔄 Migration Guide

### From flutter_ci.yml to enhanced_ci.yml

**Current:** `.github/workflows/flutter_ci.yml`  
**New:** `.github/workflows/enhanced_ci.yml`

**Steps:**

1. **Test Enhanced CI**

   ```bash
   # Trigger manually to test
   gh workflow run enhanced_ci.yml
   ```

2. **Monitor Results**

   - Check all jobs pass
   - Verify reports are correct
   - Ensure no false positives

3. **Switch (Optional)**

   ```bash
   # Rename old workflow (disable)
   mv .github/workflows/flutter_ci.yml .github/workflows/flutter_ci.yml.old

   # Enhanced CI is now the primary workflow
   ```

**Note:** Both workflows can run in parallel during transition.

---

## 🎉 Benefits of Enhanced CI

### Before (flutter_ci.yml)

- ✅ Basic testing
- ✅ Basic security checks
- ✅ Build validation
- ❌ No philosophy principles checks
- ❌ No commit message validation
- ❌ No complexity checks
- ❌ No English code validation

### After (enhanced_ci.yml) ⭐

- ✅ Comprehensive testing
- ✅ Advanced security checks
- ✅ Build validation
- ✅ **Philosophy principles checks**
- ✅ **Commit message validation**
- ✅ **Complexity checks (KISS)**
- ✅ **English code validation**
- ✅ **Detailed reporting**

**Improvement:** +200% more checks, aligned with philosophy principles

---

**Prepared by:** Basir Project Development Agents Team  
**Date:** December 8, 2025  
**Version:** 2.0  
**Status:** ✅ Active and Enhanced
