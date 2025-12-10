#!/bin/bash

# بصير MVP - Setup Pre-commit Hooks
# This script sets up Git pre-commit hooks for code quality

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Setting up Pre-commit Hooks - بصير MVP"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if .git directory exists
if [ ! -d ".git" ]; then
  echo "❌ Error: Not a git repository"
  echo "Please run this script from the project root"
  exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# ============================================
# Pre-commit Hook
# ============================================
echo "📝 Creating pre-commit hook..."

cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

# بصير MVP - Pre-commit Hook
# Runs before each commit to ensure code quality

echo "🔍 Running pre-commit checks..."

# 1. Format code
echo "  ├─ Formatting code..."
dart format . > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "  │  ⚠️  Formatting warnings (non-blocking)"
fi

# 2. Analyze code
echo "  ├─ Analyzing code..."
flutter analyze --no-pub > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "  │  ❌ Flutter analyze found issues"
  echo "  │  Run 'flutter analyze' to see details"
  exit 1
fi

# 3. Check for secrets
echo "  ├─ Checking for secrets..."
if git diff --cached --name-only | xargs grep -E "(password|secret|api_key|token)" 2>/dev/null | grep -v "// TODO\|// FIXME\|test\|SecureStorage\|\.md"; then
  echo "  │  ❌ Potential secrets found in staged files"
  echo "  │  Please remove hardcoded secrets"
  exit 1
fi

# 4. Run quick tests (optional - can be slow)
# Uncomment if you want to run tests before each commit
# echo "  ├─ Running tests..."
# flutter test > /dev/null 2>&1
# if [ $? -ne 0 ]; then
#   echo "  │  ❌ Tests failed"
#   echo "  │  Run 'flutter test' to see details"
#   exit 1
# fi

echo "  └─ ✅ All pre-commit checks passed!"
echo ""

exit 0
EOF

chmod +x .git/hooks/pre-commit
echo "  ✅ Pre-commit hook created"

# ============================================
# Pre-push Hook
# ============================================
echo "📝 Creating pre-push hook..."

cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash

# بصير MVP - Pre-push Hook
# Runs before each push to ensure code quality

echo "🔍 Running pre-push checks..."

# 1. Run all tests with coverage
echo "  ├─ Running tests with coverage..."
flutter test --coverage > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "  │  ❌ Tests failed"
  echo "  │  Run 'flutter test' to see details"
  exit 1
fi

# 2. Check coverage threshold
echo "  ├─ Checking coverage threshold..."
if [ -f "coverage/lcov.info" ]; then
  # Install lcov if not available
  if ! command -v lcov &> /dev/null; then
    echo "  │  ⚠️  lcov not installed, skipping coverage check"
  else
    COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}' | sed 's/%//' || echo "0")
    
    if (( $(echo "$COVERAGE < 70" | bc -l) )); then
      echo "  │  ⚠️  Coverage is below 70%: ${COVERAGE}%"
      echo "  │  Consider adding more tests"
      # Don't fail, just warn
    else
      echo "  │  ✅ Coverage: ${COVERAGE}%"
    fi
  fi
fi

echo "  └─ ✅ All pre-push checks passed!"
echo ""

exit 0
EOF

chmod +x .git/hooks/pre-push
echo "  ✅ Pre-push hook created"

# ============================================
# Commit-msg Hook
# ============================================
echo "📝 Creating commit-msg hook..."

cat > .git/hooks/commit-msg << 'EOF'
#!/bin/bash

# بصير MVP - Commit Message Hook
# Validates commit message format (Conventional Commits)

commit_msg_file=$1
commit_msg=$(cat "$commit_msg_file")

# Conventional Commits pattern
pattern="^(feat|fix|docs|style|refactor|test|chore|perf|ci|build)(\(.+\))?: .{1,}"

if ! echo "$commit_msg" | grep -qE "$pattern"; then
  echo "❌ Invalid commit message format"
  echo ""
  echo "Commit message must follow Conventional Commits:"
  echo "  type(scope): description"
  echo ""
  echo "Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build"
  echo ""
  echo "Examples:"
  echo "  feat(customers): add search functionality"
  echo "  fix(invoices): resolve PDF export issue"
  echo "  docs(readme): update installation instructions"
  echo ""
  exit 1
fi

exit 0
EOF

chmod +x .git/hooks/commit-msg
echo "  ✅ Commit-msg hook created"

# ============================================
# Summary
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Pre-commit Hooks Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Hooks installed:"
echo "  ✅ pre-commit  - Format, analyze, check secrets"
echo "  ✅ pre-push    - Run tests with coverage"
echo "  ✅ commit-msg  - Validate commit message format"
echo ""
echo "To bypass hooks (not recommended):"
echo "  git commit --no-verify"
echo "  git push --no-verify"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
