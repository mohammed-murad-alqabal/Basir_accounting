# Git Workflow Guide - Basir ERP Development

**Document Version:** 1.0  
**Last Updated:** January 11, 2026  
**Author:** فريق وكلاء تطوير مشروع بصير

---

## 📋 Overview

This guide provides comprehensive instructions for using the Git workflow system implemented for Basir ERP development. The workflow is designed to ensure code quality, maintain accounting integrity, and support collaborative development of enterprise-grade financial software.

## 🏗️ Branch Structure

### Protected Branches

#### `main`

- **Purpose:** Production-ready code
- **Protection:** Requires 2 code reviews, all CI checks must pass
- **Access:** Only through approved pull requests
- **Deployment:** Automatically deployed to production

#### `development`

- **Purpose:** Integration branch for ongoing development
- **Protection:** Requires 1 code review, basic CI checks must pass
- **Access:** Through pull requests from feature branches
- **Testing:** Continuous integration and automated testing

### Feature Branches

All feature development must follow the ERP-specific naming convention:

```
feature/<module>-<description>
```

#### Supported ERP Modules

| Module       | Description                | Examples                               |
| ------------ | -------------------------- | -------------------------------------- |
| `hr`         | Human Resources Management | `feature/hr-employee-onboarding`       |
| `payroll`    | Payroll Calculation System | `feature/payroll-overtime-calculation` |
| `inventory`  | Inventory Management       | `feature/inventory-stock-alerts`       |
| `accounting` | Accounting System          | `feature/accounting-trial-balance`     |
| `invoices`   | Invoice Management         | `feature/invoices-zatca-integration`   |
| `customers`  | Customer Management        | `feature/customers-credit-limits`      |
| `vendors`    | Vendor Management          | `feature/vendors-payment-terms`        |
| `reports`    | Reporting System           | `feature/reports-financial-dashboard`  |
| `zatca`      | ZATCA Compliance           | `feature/zatca-phase2-implementation`  |
| `tax`        | Tax Management             | `feature/tax-vat-calculation`          |
| `ui`         | User Interface             | `feature/ui-mobile-responsive`         |
| `core`       | Core System Features       | `feature/core-database-optimization`   |
| `security`   | Security Enhancements      | `feature/security-audit-logging`       |

## 🚀 Development Workflow

### 1. Starting New Feature Development

```bash
# 1. Ensure you're on development branch
git checkout development
git pull origin development

# 2. Create feature branch
git checkout -b feature/accounting-journal-entries

# 3. Verify branch name (automatic validation)
# The pre-push hook will validate the branch name
```

### 2. Development Process

```bash
# 1. Make your changes following Clean Architecture
# 2. Run tests frequently
flutter test

# 3. Run code analysis
flutter analyze

# 4. Commit changes with conventional commits
git add .
git commit -m "feat(accounting): implement journal entry validation

- Add double-entry bookkeeping validation
- Implement accounting equation checks (A = L + E)
- Add IFRS compliance validation rules
- Include comprehensive test coverage

المؤلف: فريق وكلاء تطوير مشروع بصير"
```

### 3. Code Quality Checks

The system automatically runs the following checks:

#### Pre-Commit Hooks

- Code formatting (`dart format`)
- Basic linting
- Branding consistency checks

#### Pre-Push Hooks

- Branch naming validation
- ERP module verification

#### CI/CD Pipeline (GitHub Actions)

- **Code Quality:** `flutter analyze`, `flutter test`
- **Security Scan:** Secret detection, dependency vulnerabilities
- **ERP Compliance:** Architecture validation, accounting integrity
- **Performance:** Anti-pattern detection, optimization checks
- **Build Test:** Multi-platform build verification

## 📦 Release Management

### Creating a Release

```bash
# Use the release script
./scripts/release.sh create v1.2.0 minor

# This automatically:
# - Creates release branch from development
# - Updates version in pubspec.yaml
# - Creates release notes template
# - Creates release checklist
```

### Release Types

#### Major Release (v1.0.0 → v2.0.0)

- **When:** Breaking changes, new ERP modules
- **Examples:** Adding HR system, changing database schema
- **Requirements:** Full regression testing, documentation updates

#### Minor Release (v1.0.0 → v1.1.0)

- **When:** New features, enhancements
- **Examples:** New reports, enhanced ZATCA compliance
- **Requirements:** Feature testing, documentation updates

#### Patch Release (v1.0.0 → v1.0.1)

- **When:** Bug fixes, security patches
- **Examples:** Invoice fixes, security patches
- **Requirements:** Targeted testing

## 🔧 Tools and Scripts

### Release Management Script

```bash
# Create release
./scripts/release.sh create v1.2.0 minor

# List releases
./scripts/release.sh list

# Validate version
./scripts/release.sh validate v1.2.0

# Calculate next version
./scripts/release.sh next v1.1.0 minor

# Finalize release
./scripts/release.sh finalize v1.2.0
```

### Git Hooks Setup

```bash
# Setup Git hooks
./scripts/setup-git-hooks.sh

# This configures:
# - Pre-push branch name validation
# - ERP module verification
# - Automatic hook installation
```

## 🛡️ Security and Compliance

### Automated Security Checks

- **Secret Detection:** Prevents committing API keys, passwords
- **Dependency Scanning:** Checks for vulnerable packages
- **Code Analysis:** Identifies security anti-patterns

### ERP Compliance Checks

- **Accounting Integrity:** Validates accounting equation (A = L + E)
- **ZATCA Compliance:** Ensures Saudi tax compliance
- **Architecture Validation:** Enforces Clean Architecture
- **Module Structure:** Validates ERP module organization

## 🔄 Backup and Recovery

### Automated Backups

The system automatically creates backups of:

- Git branches (main, development)
- Database snapshots
- Configuration files
- Critical project files

### Branch Recovery

```bash
# Recover deleted branch within 30 days
# This is handled automatically by the backup service
```

## 📊 Monitoring and Metrics

### Branch Health Monitoring

- **Code Quality Metrics:** Test coverage, analysis scores
- **Security Metrics:** Vulnerability counts, compliance status
- **Performance Metrics:** Build times, test execution times

### Release Metrics

- **Release Frequency:** Track deployment cadence
- **Lead Time:** Measure feature development time
- **Failure Rate:** Monitor production issues

## 🚨 Troubleshooting

### Common Issues

#### Branch Name Validation Fails

```bash
# Error: Invalid branch name
# Solution: Rename branch to follow ERP conventions
git branch -m old-name feature/accounting-new-feature
```

#### CI Checks Failing

```bash
# Run checks locally first
flutter analyze
flutter test

# Fix issues before pushing
```

#### Merge Conflicts

```bash
# Update your branch with latest development
git checkout development
git pull origin development
git checkout your-feature-branch
git rebase development

# Resolve conflicts and continue
git add .
git rebase --continue
```

## 📚 Best Practices

### Commit Messages

Use conventional commit format:

```
<type>(<scope>): <description>

<body>

<footer>
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

**Scopes:**

- ERP modules: `accounting`, `invoices`, `hr`, `payroll`
- Technical: `core`, `ui`, `security`, `performance`

### Code Review Guidelines

#### For Authors

- Keep PRs small and focused
- Include comprehensive description
- Add tests for new features
- Update documentation
- Ensure all CI checks pass

#### For Reviewers

- Focus on business logic correctness
- Verify accounting integrity
- Check security implications
- Validate architectural compliance
- Test the changes locally

### Testing Strategy

#### Unit Tests

- Test business logic in isolation
- Mock external dependencies
- Achieve >80% code coverage

#### Integration Tests

- Test feature workflows end-to-end
- Validate database interactions
- Test API integrations

#### ERP-Specific Tests

- Accounting equation validation
- ZATCA compliance verification
- Multi-currency calculations
- Tax computation accuracy

## 📞 Support and Resources

### Getting Help

1. **Documentation:** Check this guide first
2. **Team Chat:** Ask in development channel
3. **Code Review:** Request help in PR comments
4. **Architecture Questions:** Consult senior developers

### Additional Resources

- [Flutter Development Guidelines](../guides/flutter-development.md)
- [Clean Architecture Principles](../guides/clean-architecture.md)
- [ERP Module Structure](../guides/erp-modules.md)
- [ZATCA Compliance Guide](../guides/zatca-compliance.md)

---

**Document Control:**

- **Version:** 1.0
- **Prepared by:** فريق وكلاء تطوير مشروع بصير
- **Review Cycle:** Monthly
- **Next Review:** February 11, 2026
