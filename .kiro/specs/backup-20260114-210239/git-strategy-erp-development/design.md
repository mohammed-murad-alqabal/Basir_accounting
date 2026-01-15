# تصميم استراتيجية Git لتطوير ERP متكامل - مشروع بصير

## نظرة عامة

تهدف هذه الاستراتيجية إلى إنشاء نظام Git متقدم وآمن يدعم التطوير المتوازي لميزات ERP المختلفة مع ضمان استقرار الفرع الرئيسي وجودة الكود العالية.

## الهيكل المعماري

### نموذج Git Flow المحسّن لـ ERP

```mermaid
gitgraph
    commit id: "Initial"
    branch development
    checkout development
    commit id: "Dev Setup"

    branch feature/hr-payroll
    checkout feature/hr-payroll
    commit id: "HR: Employee Model"
    commit id: "HR: Payroll Logic"

    checkout development
    branch feature/inventory-advanced
    checkout feature/inventory-advanced
    commit id: "INV: Warehouse Management"
    commit id: "INV: Stock Tracking"

    checkout development
    merge feature/hr-payroll
    commit id: "Integration Test"

    checkout main
    branch release/v2.0.0
    checkout release/v2.0.0
    commit id: "Release Prep"
    commit id: "Bug Fixes"

    checkout main
    merge release/v2.0.0
    commit id: "v2.0.0" tag: "v2.0.0"

    checkout main
    branch hotfix/critical-bug
    checkout hotfix/critical-bug
    commit id: "Critical Fix"

    checkout main
    merge hotfix/critical-bug
    commit id: "v2.0.1" tag: "v2.0.1"
```

### هيكل الفروع

#### 1. الفروع الدائمة

```
main (الإنتاج)
├── الكود المستقر والجاهز للنشر
├── محمي بـ branch protection rules
├── يتطلب PR مع مراجعة
└── اختبارات تلقائية إجبارية

development (التطوير)
├── تكامل الميزات الجديدة
├── اختبارات التكامل المستمرة
├── نقطة انطلاق للـ feature branches
└── مصدر الـ release branches
```

#### 2. الفروع المؤقتة

```
feature/* (ميزات ERP)
├── feature/hr-management
├── feature/payroll-system
├── feature/advanced-inventory
├── feature/project-management
├── feature/supply-chain
└── feature/manufacturing

release/* (الإصدارات)
├── release/v2.0.0-erp-foundation
├── release/v2.1.0-hr-payroll
├── release/v2.2.0-advanced-features
└── release/v3.0.0-full-erp

hotfix/* (الإصلاحات العاجلة)
├── hotfix/security-patch
├── hotfix/data-corruption-fix
└── hotfix/performance-critical
```

## المكونات والواجهات

### 1. نظام حماية الفروع

```yaml
# .github/branch-protection.yml
main:
  protection_rules:
    required_status_checks:
      strict: true
      contexts:
        - "flutter-analyze"
        - "flutter-test"
        - "integration-tests"
        - "security-scan"
    enforce_admins: true
    required_pull_request_reviews:
      required_approving_review_count: 2
      dismiss_stale_reviews: true
      require_code_owner_reviews: true
    restrictions:
      users: []
      teams: ["senior-developers"]
    allow_force_pushes: false
    allow_deletions: false

development:
  protection_rules:
    required_status_checks:
      strict: true
      contexts:
        - "flutter-analyze"
        - "flutter-test"
    required_pull_request_reviews:
      required_approving_review_count: 1
    allow_force_pushes: false
```

### 2. نظام تسمية الفروع

```dart
class BranchNamingConvention {
  static const Map<String, String> patterns = {
    'feature': 'feature/erp-module-description',
    'release': 'release/v{major}.{minor}.{patch}-description',
    'hotfix': 'hotfix/critical-issue-description',
    'bugfix': 'bugfix/issue-number-description',
  };

  static bool isValidBranchName(String branchName) {
    return patterns.values.any((pattern) =>
      RegExp(pattern.replaceAll('{', r'\d+').replaceAll('}', ''))
        .hasMatch(branchName)
    );
  }
}
```

### 3. نظام المراجعة التلقائية

```yaml
# .github/workflows/pr-checks.yml
name: Pull Request Checks
on:
  pull_request:
    branches: [main, development]

jobs:
  code-quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
      - name: Flutter Analyze
        run: flutter analyze --fatal-infos
      - name: Flutter Test
        run: flutter test --coverage
      - name: Upload Coverage
        uses: codecov/codecov-action@v3

  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Security Scan
        run: |
          # فحص الثغرات الأمنية
          flutter pub deps --json | jq '.packages[] | select(.kind == "direct")' | audit-tool
```

### 4. نظام إدارة الإصدارات

```dart
class ReleaseManager {
  // إنشاء فرع إصدار جديد
  Future<String> createReleaseBranch(String version) async {
    final branchName = 'release/v$version';
    await _gitService.createBranch(branchName, from: 'development');
    await _updateVersionFiles(version);
    return branchName;
  }

  // إنهاء الإصدار ودمجه
  Future<void> finishRelease(String version) async {
    final releaseBranch = 'release/v$version';

    // دمج في main
    await _gitService.mergeBranch(releaseBranch, into: 'main');
    await _gitService.createTag('v$version');

    // دمج في development
    await _gitService.mergeBranch(releaseBranch, into: 'development');

    // حذف فرع الإصدار
    await _gitService.deleteBranch(releaseBranch);

    // إنشاء release notes
    await _generateReleaseNotes(version);
  }
}
```

## نماذج البيانات

### معلومات الفرع

```dart
@freezed
class BranchInfo with _$BranchInfo {
  const factory BranchInfo({
    required String name,
    required BranchType type,
    required String baseBranch,
    required DateTime createdAt,
    required String author,
    required BranchStatus status,
    String? associatedIssue,
    String? description,
  }) = _BranchInfo;
}

enum BranchType {
  main,
  development,
  feature,
  release,
  hotfix,
  bugfix,
}

enum BranchStatus {
  active,
  readyForReview,
  underReview,
  approved,
  merged,
  abandoned,
}
```

### معلومات Pull Request

```dart
@freezed
class PullRequestInfo with _$PullRequestInfo {
  const factory PullRequestInfo({
    required String id,
    required String title,
    required String description,
    required String sourceBranch,
    required String targetBranch,
    required String author,
    required List<String> reviewers,
    required PRStatus status,
    required List<CheckResult> checks,
    DateTime? mergedAt,
  }) = _PullRequestInfo;
}

enum PRStatus {
  draft,
  readyForReview,
  changesRequested,
  approved,
  merged,
  closed,
}
```

## خصائص الصحة

_خاصية هي سمة أو سلوك يجب أن يكون صحيحاً عبر جميع التنفيذات الصالحة للنظام - في الأساس، بيان رسمي حول ما يجب أن يفعله النظام._

### خاصية 1: حماية الفرع الرئيسي

_لأي_ محاولة push مباشرة إلى main، يجب أن يرفضها النظام ويتطلب PR
**يتحقق من: المتطلبات 1.1**

### خاصية 2: جودة الكود الإجبارية

_لأي_ PR، يجب أن تنجح جميع فحوصات الجودة قبل السماح بالدمج
**يتحقق من: المتطلبات 6.1, 6.2**

### خاصية 3: تسمية الفروع المعيارية

_لأي_ فرع جديد، يجب أن يتبع نمط التسمية المحدد أو يرفض النظام إنشاءه
**يتحقق من: المتطلبات 3.2**

### خاصية 4: التكامل الآمن

_لأي_ ميزة مكتملة، يجب أن تمر عبر development قبل الوصول إلى main
**يتحقق من: المتطلبات 2.1**

### خاصية 5: المراجعة الإجبارية

_لأي_ PR إلى main، يجب أن يحصل على موافقة مطورين اثنين كحد أدنى
**يتحقق من: المتطلبات 1.2**

### خاصية 6: الاختبارات الشاملة

_لأي_ دمج في main، يجب أن تنجح جميع الاختبارات التلقائية
**يتحقق من: المتطلبات 1.4**

### خاصية 7: تتبع الميزات

_لأي_ فرع ميزة ERP، يجب أن يكون مرتبط بـ issue أو epic
**يتحقق من: المتطلبات 7.1**

### خاصية 8: النسخ الاحتياطية التلقائية

_لأي_ push إلى أي فرع، يجب أن ينشئ النظام نسخة احتياطية تلقائياً
**يتحقق من: المتطلبات 8.1**

## معالجة الأخطاء

### استراتيجية التعافي من الأخطاء

```dart
class GitErrorRecovery {
  // التعافي من تعارضات الدمج
  Future<void> resolveMergeConflicts(String branchName) async {
    try {
      await _gitService.checkout(branchName);
      await _gitService.pull('development');

      // إشعار المطور بالتعارضات
      await _notificationService.notifyDeveloper(
        'Merge conflicts detected in $branchName'
      );

    } catch (e) {
      await _logService.logError('Merge conflict resolution failed', e);
      throw GitRecoveryException('Unable to resolve conflicts');
    }
  }

  // استعادة فرع محذوف
  Future<void> recoverDeletedBranch(String branchName) async {
    final backups = await _backupService.findBranchBackups(branchName);
    if (backups.isNotEmpty) {
      await _gitService.createBranchFromCommit(
        branchName,
        backups.first.lastCommit
      );
    }
  }
}
```

### نظام التنبيهات

```dart
class GitNotificationSystem {
  // تنبيه عند فشل الاختبارات
  Future<void> notifyTestFailure(PullRequestInfo pr) async {
    await _slackService.sendMessage(
      channel: '#development',
      message: '🚨 Tests failed for PR #${pr.id}: ${pr.title}'
    );
  }

  // تنبيه عند اكتمال الدمج
  Future<void> notifyMergeSuccess(PullRequestInfo pr) async {
    await _emailService.sendEmail(
      to: pr.author,
      subject: 'PR Merged Successfully',
      body: 'Your PR "${pr.title}" has been merged to ${pr.targetBranch}'
    );
  }
}
```

## استراتيجية الاختبار

### اختبارات Git Workflow

```dart
class GitWorkflowTests {
  @Test('Feature branch creation follows naming convention')
  void testFeatureBranchNaming() {
    final validNames = [
      'feature/hr-employee-management',
      'feature/payroll-calculation-engine',
      'feature/inventory-warehouse-integration'
    ];

    for (final name in validNames) {
      expect(BranchNamingConvention.isValidBranchName(name), isTrue);
    }
  }

  @Test('Main branch protection prevents direct push')
  void testMainBranchProtection() async {
    expect(
      () => gitService.pushDirectly('main', commits),
      throwsA(isA<BranchProtectionException>())
    );
  }

  @Test('PR requires minimum reviewers')
  void testPRReviewRequirement() async {
    final pr = await createTestPR(targetBranch: 'main');

    expect(pr.requiredReviewers, greaterThanOrEqualTo(2));
    expect(pr.canMerge, isFalse); // قبل المراجعة
  }
}
```

### اختبارات التكامل

```dart
class GitIntegrationTests {
  @Test('Complete feature development workflow')
  void testCompleteWorkflow() async {
    // 1. إنشاء فرع ميزة
    final featureBranch = await gitService.createFeatureBranch(
      'hr-payroll-system'
    );

    // 2. تطوير الميزة
    await developFeature(featureBranch);

    // 3. إنشاء PR إلى development
    final pr = await createPR(featureBranch, 'development');

    // 4. مراجعة وموافقة
    await approvePR(pr);

    // 5. دمج في development
    await mergePR(pr);

    // 6. اختبار التكامل
    final integrationResult = await runIntegrationTests();
    expect(integrationResult.success, isTrue);

    // 7. إنشاء release branch
    final releaseBranch = await createReleaseBranch('2.1.0');

    // 8. دمج في main
    await finishRelease('2.1.0');

    expect(await getLatestTag(), equals('v2.1.0'));
  }
}
```

## الأمان والصلاحيات

### نظام الصلاحيات

```yaml
# CODEOWNERS file
# Global owners
* @senior-developers @tech-leads

# ERP modules
/lib/features/accounting/ @accounting-team @senior-developers
/lib/features/hr/ @hr-team @senior-developers
/lib/features/payroll/ @payroll-team @senior-developers
/lib/features/inventory/ @inventory-team @senior-developers

# Core infrastructure
/lib/core/ @tech-leads
/.github/ @devops-team @tech-leads
/.kiro/ @senior-developers @tech-leads

# Documentation
/docs/ @documentation-team
README.md @tech-leads
```

### فحوصات الأمان

```dart
class SecurityChecks {
  // فحص الأسرار في الكود
  Future<bool> scanForSecrets(List<String> files) async {
    final secretPatterns = [
      r'password\s*=\s*["\'][^"\']+["\']',
      r'api_key\s*=\s*["\'][^"\']+["\']',
      r'secret\s*=\s*["\'][^"\']+["\']',
    ];

    for (final file in files) {
      final content = await File(file).readAsString();
      for (final pattern in secretPatterns) {
        if (RegExp(pattern, caseSensitive: false).hasMatch(content)) {
          return false; // أسرار موجودة
        }
      }
    }
    return true; // آمن
  }

  // فحص التبعيات للثغرات
  Future<SecurityScanResult> scanDependencies() async {
    final result = await Process.run('flutter', ['pub', 'deps', '--json']);
    final dependencies = jsonDecode(result.stdout);

    // فحص قاعدة بيانات الثغرات
    return await _vulnerabilityDatabase.scan(dependencies);
  }
}
```

## التوثيق والتدريب

### دليل المطور

````markdown
# دليل Git Workflow لمطوري بصير ERP

## البدء السريع

1. **إنشاء فرع ميزة جديدة:**
   ```bash
   git checkout development
   git pull origin development
   git checkout -b feature/hr-employee-management
   ```
````

2. **تطوير الميزة:**

   ```bash
   # اعمل على الكود
   git add .
   git commit -m "feat(hr): add employee model and validation"
   ```

3. **إنشاء Pull Request:**
   ```bash
   git push origin feature/hr-employee-management
   # ثم أنشئ PR عبر GitHub UI
   ```

## قواعد Commit Messages

استخدم Conventional Commits:

- `feat(module): description` - ميزة جديدة
- `fix(module): description` - إصلاح خطأ
- `docs(module): description` - تحديث توثيق
- `test(module): description` - إضافة اختبارات
- `refactor(module): description` - إعادة هيكلة

```

**التكوين المطلوب:**
- الحد الأدنى 100 تكرار لكل اختبار خاصية
- كل اختبار خاصية يجب أن يشير إلى خاصية التصميم
- تنسيق العلامة: **الميزة: git-strategy-erp-development، الخاصية {رقم}: {نص الخاصية}**
```
