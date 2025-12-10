# CI/CD Quick Reference Guide

## Quick Commands

### Run All Quality Gates Locally

```bash
./scripts/run_quality_gates.sh
```

### Documentation Commands

```bash
# Analyze coverage
dart run lib/tools/documentation/cli/documentation_cli.dart analyze

# Generate missing docs
dart run lib/tools/documentation/cli/documentation_cli.dart generate

# Validate quality
dart run lib/tools/documentation/cli/documentation_cli.dart validate --strict

# Generate report
dart run lib/tools/documentation/cli/documentation_cli.dart report --format markdown
```

### Code Quality Commands

```bash
# Run analysis
flutter analyze

# Auto-fix issues
dart fix --apply

# Format code
dart format .
```

### Testing Commands

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Security Commands

```bash
# Check for outdated packages
flutter pub outdated

# Update dependencies
flutter pub upgrade

# Check for secrets
grep -r "api_key\|password\|secret" lib/
```

## Quality Thresholds

| Metric                   | Threshold | Status      |
| ------------------------ | --------- | ----------- |
| Documentation Coverage   | ≥ 95%     | 🎯 Required |
| Documentation Quality    | ≥ 90/100  | 🎯 Required |
| Code Errors              | 0         | 🎯 Required |
| Code Warnings            | ≤ 10      | ⚠️ Warning  |
| Test Coverage            | ≥ 70%     | 🎯 Required |
| Security Vulnerabilities | 0         | 🎯 Required |

## Workflow Status Indicators

### ✅ All Checks Passed

- Ready to merge
- All quality gates passed
- No action needed

### ❌ Documentation Failed

**Fix:**

1. Run: `dart run lib/tools/documentation/cli/documentation_cli.dart analyze`
2. Run: `dart run lib/tools/documentation/cli/documentation_cli.dart generate`
3. Review and improve docs
4. Commit and push

### ❌ Code Quality Failed

**Fix:**

1. Run: `flutter analyze`
2. Fix errors manually or: `dart fix --apply`
3. Commit and push

### ❌ Test Coverage Failed

**Fix:**

1. Run: `flutter test --coverage`
2. View: `genhtml coverage/lcov.info -o coverage/html`
3. Write tests for uncovered code
4. Commit and push

### ❌ Security Failed

**Fix:**

1. Run: `flutter pub outdated`
2. Update vulnerable packages: `flutter pub upgrade`
3. Remove hardcoded secrets
4. Commit and push

## Common Issues

### Issue: "Documentation coverage is below 95%"

```bash
# Solution
dart run lib/tools/documentation/cli/documentation_cli.dart analyze --verbose
dart run lib/tools/documentation/cli/documentation_cli.dart generate
# Review generated docs, then commit
```

### Issue: "Flutter analyze found errors"

```bash
# Solution
flutter analyze
dart fix --apply
# Fix remaining issues manually, then commit
```

### Issue: "Test coverage is below 70%"

```bash
# Solution
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
# Write tests for uncovered code, then commit
```

### Issue: "Workflow is stuck or taking too long"

```bash
# Solution
# 1. Check GitHub Actions logs
# 2. Cancel the workflow run
# 3. Fix the issue locally
# 4. Push again
```

## Pre-Commit Checklist

- [ ] Run quality gates: `./scripts/run_quality_gates.sh`
- [ ] All tests pass: `flutter test`
- [ ] No analyze errors: `flutter analyze`
- [ ] Documentation updated
- [ ] Code formatted: `dart format .`
- [ ] No hardcoded secrets

## Pre-Push Checklist

- [ ] All commits have meaningful messages
- [ ] Branch is up to date with main
- [ ] Quality gates pass locally
- [ ] Ready for code review

## PR Checklist

- [ ] Title is descriptive
- [ ] Description explains changes
- [ ] All workflows pass
- [ ] Documentation is complete
- [ ] Tests are included
- [ ] No merge conflicts

## Emergency Procedures

### Bypass Quality Gates (Use Sparingly!)

**When to use:**

- Critical hotfix needed
- Quality gates have false positives
- Approved by team lead

**How to bypass:**

1. Get approval from team lead
2. Add `[skip ci]` to commit message
3. Create follow-up issue to fix quality
4. Merge with admin override

**Note:** This should be rare and documented!

### Rollback Failed Deployment

```bash
# 1. Identify last good commit
git log --oneline

# 2. Create rollback branch
git checkout -b rollback/issue-description

# 3. Revert to last good commit
git revert <commit-hash>

# 4. Push and create PR
git push origin rollback/issue-description
```

## Useful Links

- [Full Quality Gates Documentation](.github/QUALITY_GATES.md)
- [CI/CD Integration Details](.github/CI_CD_INTEGRATION.md)
- [Documentation System Design](.kiro/specs/documentation-system/design.md)
- [GitHub Actions Workflows](.github/workflows/)

## Getting Help

1. **Check workflow logs:** GitHub Actions tab
2. **Run locally:** `./scripts/run_quality_gates.sh`
3. **Read documentation:** `.github/QUALITY_GATES.md`
4. **Ask team:** Slack #dev-help channel
5. **Create issue:** GitHub Issues

## Tips & Tricks

### Speed Up Local Testing

```bash
# Run specific test file
flutter test test/path/to/test_file.dart

# Run tests matching pattern
flutter test --name "pattern"

# Skip slow tests
flutter test --exclude-tags slow
```

### View Coverage for Specific File

```bash
flutter test --coverage
lcov --extract coverage/lcov.info 'lib/path/to/file.dart' --output-file coverage/file.info
genhtml coverage/file.info -o coverage/file_html
```

### Auto-Format on Save

Add to VS Code settings:

```json
{
  "editor.formatOnSave": true,
  "[dart]": {
    "editor.formatOnSave": true
  }
}
```

### Pre-Commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
./scripts/run_quality_gates.sh
```

---

**Keep this guide handy!** Bookmark it or print it for quick reference.

**Last Updated:** 2025-11-28
