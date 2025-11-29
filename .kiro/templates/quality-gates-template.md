# Quality Gates Template

**المشروع:** [اسم المشروع]
**التاريخ:** [التاريخ]
**المؤلف:** فريق وكلاء تطوير المشروع

## بوابات الجودة الإلزامية

### 1. Code Quality Gate

- **Test Coverage:** ≥ 70%
- **Linting Errors:** 0
- **Type Safety:** 100%
- **Code Complexity:** < 10 (Cyclomatic)

### 2. Security Gate

- **Vulnerability Scan:** Pass
- **Secret Detection:** Pass
- **Dependency Audit:** Pass
- **OWASP Compliance:** Pass

### 3. Performance Gate

- **Build Time:** < 60s
- **Test Execution:** < 30s
- **Bundle Size:** Within limits
- **Memory Leaks:** 0

### 4. Documentation Gate

- **API Documentation:** 100%
- **README Updated:** ✅
- **CHANGELOG Updated:** ✅
- **Architecture Docs:** Current

## Automation Scripts

### Pre-Commit Hook

```bash
#!/bin/bash
# Quality gate enforcement

echo "🔍 Running quality checks..."

# 1. Linting
echo "📝 Checking code style..."
if ! npm run lint; then
    echo "❌ Linting failed"
    exit 1
fi

# 2. Type checking
echo "🔍 Type checking..."
if ! npm run type-check; then
    echo "❌ Type check failed"
    exit 1
fi

# 3. Unit tests
echo "🧪 Running tests..."
if ! npm run test:unit; then
    echo "❌ Tests failed"
    exit 1
fi

# 4. Secret scanning
echo "🔐 Scanning for secrets..."
if ! gitleaks detect --no-git; then
    echo "❌ Secrets detected"
    exit 1
fi

echo "✅ All quality gates passed"
```

### Pre-Push Hook

```bash
#!/bin/bash
# Comprehensive quality validation

echo "🚀 Running pre-push validation..."

# 1. Full test suite
echo "🧪 Running full test suite..."
if ! npm run test:all; then
    echo "❌ Test suite failed"
    exit 1
fi

# 2. Coverage check
echo "📊 Checking coverage..."
COVERAGE=$(npm run test:coverage | grep "Lines" | awk '{print $3}' | sed 's/%//')
if (( $(echo "$COVERAGE < 70" | bc -l) )); then
    echo "❌ Coverage below 70%: $COVERAGE%"
    exit 1
fi

# 3. Build verification
echo "🏗️ Verifying build..."
if ! npm run build; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Ready to push"
```

## CI/CD Integration

### GitHub Actions Workflow

```yaml
name: Quality Gates

on: [push, pull_request]

jobs:
  quality-check:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Environment
        uses: actions/setup-node@v3
        with:
          node-version: "18"

      - name: Install Dependencies
        run: npm ci

      - name: Lint Check
        run: npm run lint

      - name: Type Check
        run: npm run type-check

      - name: Run Tests
        run: npm run test:coverage

      - name: Security Scan
        run: npm audit --audit-level=moderate

      - name: Build
        run: npm run build

      - name: Upload Coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info

  security-scan:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Run Trivy Scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: "fs"
          scan-ref: "."
          format: "sarif"
          output: "trivy-results.sarif"

      - name: Upload Results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: "trivy-results.sarif"
```

---

**تم إعداد هذا القالب بواسطة:** فريق وكلاء تطوير المشروع
**التاريخ:** [التاريخ]
**الإصدار:** 1.0
