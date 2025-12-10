# Requirements Document - Git Repository Optimization

**المشروع:** بصير MVP  
**Feature:** Git Repository Optimization  
**التاريخ:** 9 ديسمبر 2025  
**المنفذ:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** 📝 Draft

---

## Introduction

هذا المستند يحدد متطلبات تحسين وتنظيف Git repository لحل مشكلة الدفع إلى GitHub وضمان الاستدامة المستقبلية. المشكلة الحالية هي وجود عدد كبير من Git objects (9,811) في الـ commits المعلقة، مما يتجاوز حدود GitHub (5,000 objects) ويسبب فشل عملية الدفع. التحليل الأولي يشير إلى أن المشكلة ليست ملفات build كبيرة، بل عدد كبير من الـ commits والتغييرات المتراكمة.

---

## Glossary

- **Git_Optimization_System**: النظام المسؤول عن تحليل وتحسين وتنظيف Git repository
- **Repository**: مستودع Git الذي يحتوي على كود المشروع وتاريخه
- **Commit**: نقطة حفظ في تاريخ Git تحتوي على تغييرات
- **Squash**: دمج عدة commits في commit واحد
- **Build Artifacts**: ملفات مُولدة تلقائياً من عملية البناء تتجاوز 1MB في الحجم
- **Git History**: تاريخ جميع الـ commits في Repository
- **Remote**: المستودع البعيد على GitHub
- **Local**: المستودع المحلي على الجهاز
- **Hook**: سكريبت يعمل تلقائياً عند أحداث Git معينة
- **Exponential Backoff**: استراتيجية إعادة المحاولة بزيادة الفترة الزمنية تدريجياً
- **Object Count**: عدد الـ Git objects (blobs, trees, commits) في دفعة واحدة
- **Pending Commits**: الـ commits الموجودة محلياً ولم يتم دفعها إلى Remote
- **Commit Categorization**: تصنيف الـ commits حسب النوع (docs, feat, fix, chore)
- **Logical Grouping**: تجميع الـ commits المترابطة منطقياً حسب الميزة أو نطاق الإصلاح
- **Object Analysis**: تحليل نوع وحجم الـ Git objects لفهم مصدر مشكلة العدد الكبير
- **Comprehensive Commit Message**: رسالة commit تحتوي على قائمة بجميع التغييرات المدمجة مع أنواعها

---

## Requirements

### Requirement 1: Repository and Object Analysis

**User Story:** كمطور، أريد تحليل دقيق لحجم repository وعدد objects، حتى أفهم المشكلة الحقيقية وأحدد الحل المناسب.

#### Acceptance Criteria

1. WHEN the repository size analysis starts THEN THE Git_Optimization_System SHALL report total .git directory size in MB
2. WHEN large files are detected THEN THE Git_Optimization_System SHALL list all files larger than 1MB with their complete paths and exact sizes
3. WHEN the analysis completes THEN THE Git_Optimization_System SHALL categorize files by type (build artifacts, dependencies, source code)
4. WHEN object analysis runs THEN THE Git_Optimization_System SHALL identify the source of high object count (large files, many commits, or generated content)
5. WHEN the report is generated THEN THE Git_Optimization_System SHALL provide specific optimization steps based on object analysis results

---

### Requirement 2: Commit History Optimization

**User Story:** كمطور، أريد تنظيف تاريخ commits، حتى يكون repository قابل للدفع ومنظم.

#### Acceptance Criteria

1. WHEN multiple cleanup commits exist THEN THE Git_Optimization_System SHALL squash them into a single commit
2. WHEN squashing commits THEN THE Git_Optimization_System SHALL preserve all code changes without data loss
3. WHEN history modification starts THEN THE Git_Optimization_System SHALL create a backup branch before any changes
4. WHEN the squash completes THEN THE Git_Optimization_System SHALL generate a commit message containing summary of all squashed changes
5. WHEN verification runs THEN THE Git_Optimization_System SHALL compare working directory checksums before and after squash
6. WHEN backup and restore are performed THEN THE Git_Optimization_System SHALL produce identical repository state

---

### Requirement 3: Safe Push to Remote

**User Story:** كمطور، أريد دفع الكود إلى GitHub بنجاح، حتى يتم مزامنة العمل مع الفريق.

#### Acceptance Criteria

1. WHEN the repository optimization completes THEN THE Git_Optimization_System SHALL attempt to push to remote
2. WHEN push fails THEN THE Git_Optimization_System SHALL capture and analyze the error message with specific failure reasons
3. WHEN push succeeds THEN THE Git_Optimization_System SHALL verify that all local changes are synchronized on remote
4. WHEN network issues occur THEN THE Git_Optimization_System SHALL retry with exponential backoff up to 5 attempts
5. WHEN push completes THEN THE Git_Optimization_System SHALL confirm the remote repository state matches local state

---

### Requirement 4: Future Prevention System

**User Story:** كمطور، أريد منع إضافة ملفات كبيرة مستقبلاً، حتى لا تتكرر المشكلة.

#### Acceptance Criteria

1. WHEN a developer attempts to commit files larger than 10MB THEN THE Git_Optimization_System SHALL reject the commit with error message specifying the file name and size limit exceeded
2. WHEN build artifacts are staged THEN THE Git_Optimization_System SHALL warn the developer and provide specific commands to remove them
3. WHEN a push is attempted THEN THE Git_Optimization_System SHALL verify repository size is under 100MB total size
4. WHEN .gitignore is updated THEN THE Git_Optimization_System SHALL validate it covers all build directories including build/, .dart_tool/, and coverage/
5. WHEN hooks are installed THEN THE Git_Optimization_System SHALL verify they are executable and test their functionality

---

### Requirement 5: Backup and Recovery

**User Story:** كمطور، أريد نسخ احتياطية آمنة، حتى أتمكن من التراجع إذا حدثت مشكلة.

#### Acceptance Criteria

1. WHEN optimization starts THEN THE Git_Optimization_System SHALL create a backup branch with timestamp in format backup-YYYYMMDD-HHMMSS
2. WHEN backup is created THEN THE Git_Optimization_System SHALL verify it contains all commits by comparing commit counts
3. WHEN recovery is needed THEN THE Git_Optimization_System SHALL provide step-by-step commands to restore from backup
4. WHEN backup is older than 30 days THEN THE Git_Optimization_System SHALL suggest archiving or removing it
5. WHEN multiple backups exist THEN THE Git_Optimization_System SHALL list them with creation dates and sizes

---

### Requirement 6: Documentation and Reporting

**User Story:** كمطور، أريد توثيق شامل للعملية، حتى أفهم ما تم وكيف أتجنب المشاكل مستقبلاً.

#### Acceptance Criteria

1. WHEN optimization completes THEN THE Git_Optimization_System SHALL generate a report containing before/after metrics, file counts, and size changes
2. WHEN the report is created THEN THE Git_Optimization_System SHALL include repository size reduction percentage and commit count changes
3. WHEN issues are found THEN THE Git_Optimization_System SHALL document them with specific resolution steps
4. WHEN best practices are identified THEN THE Git_Optimization_System SHALL add them to project documentation in markdown format
5. WHEN the process finishes THEN THE Git_Optimization_System SHALL create a lessons-learned document with prevention strategies

---

### Requirement 7: Git Hooks Enhancement

**User Story:** كمطور، أريد hooks محسّنة، حتى تمنع المشاكل تلقائياً.

#### Acceptance Criteria

1. WHEN pre-commit hook runs THEN THE Git_Optimization_System SHALL check for files larger than 10MB and reject commits containing them
2. WHEN pre-push hook runs THEN THE Git_Optimization_System SHALL verify repository size is under 100MB total
3. WHEN hooks detect issues THEN THE Git_Optimization_System SHALL provide error messages specifying the problematic file and required action
4. WHEN hooks are bypassed using --no-verify THEN THE Git_Optimization_System SHALL log the bypass with timestamp and user for audit
5. WHEN hooks are updated THEN THE Git_Optimization_System SHALL test them automatically with sample scenarios

---

### Requirement 8: Pending Commits Resolution

**User Story:** كمطور، أريد حل مشكلة الـ commits المعلقة، حتى أتمكن من دفع جميع التغييرات بنجاح.

#### Acceptance Criteria

1. WHEN local commits exceed remote by more than 20 commits THEN THE Git_Optimization_System SHALL analyze and categorize each commit by type using command `git log --oneline --grep="^(feat|fix|docs|chore|test|style|refactor)" origin/main..HEAD` and classify remaining commits as 'chore'
2. WHEN commit categorization completes THEN THE Git_Optimization_System SHALL group related commits into logical units with maximum 7 final commits using algorithm: docs(>2)→squash, chore(>3)→squash, feat→keep, fix→keep, test+style(>2)→squash
3. WHEN squashing grouped commits THEN THE Git_Optimization_System SHALL preserve all file changes using `git rebase -i HEAD~30` and generate comprehensive commit messages with format: "type: summary\n\n- Change 1 (original commit hash)\n- Change 2 (original commit hash)\n\nConsolidated X commits for better history"
4. WHEN object count per commit exceeds 1000 THEN THE Git_Optimization_System SHALL analyze using `git rev-list --objects --count COMMIT^..COMMIT` and recommend splitting strategy based on file types and change scope
5. WHEN squashed commits are ready THEN THE Git_Optimization_System SHALL verify total object count using `git count-objects -v` and confirm result is under 5000 objects with safety margin of at least 500 objects

---

### Requirement 9: Object Count Optimization

**User Story:** كمطور، أريد تحسين عدد الـ objects، حتى يتم قبول الدفع من GitHub.

#### Acceptance Criteria

1. WHEN object analysis starts THEN THE Git_Optimization_System SHALL count objects per commit using `git rev-list --objects --count COMMIT^..COMMIT` for each of the 30 pending commits and identify commits with >1000 objects using threshold analysis
2. WHEN high object count detected THEN THE Git_Optimization_System SHALL recommend specific squashing strategy: if commit has >1500 objects from documentation changes→squash with similar docs commits, if >1000 objects from code changes→keep separate, if >1200 objects from mixed changes→analyze file types and split accordingly
3. WHEN object optimization runs THEN THE Git_Optimization_System SHALL ensure final push contains less than 5000 total objects by executing squash plan and verifying with `git count-objects -v | grep "in-pack"` that packed objects count is under limit
4. WHEN optimization completes THEN THE Git_Optimization_System SHALL calculate object count reduction percentage using formula: ((9811 - final_count) / 9811) \* 100 and document improvement in optimization report with before/after metrics
5. WHEN push preparation finishes THEN THE Git_Optimization_System SHALL verify object count meets GitHub limits by confirming final count < 4500 (safety margin of 500) and test push readiness with `git push --dry-run origin main`

---

### Requirement 10: Verification and Testing

**User Story:** كمطور، أريد التحقق من نجاح العملية، حتى أثق في النتيجة.

#### Acceptance Criteria

1. WHEN optimization completes THEN THE Git_Optimization_System SHALL verify no source code files were lost by comparing file counts and checksums
2. WHEN verification runs THEN THE Git_Optimization_System SHALL compare SHA-256 checksums of all source files before and after optimization
3. WHEN git status is checked THEN THE Git_Optimization_System SHALL confirm working directory shows no uncommitted changes
4. WHEN remote is queried THEN THE Git_Optimization_System SHALL confirm successful synchronization by comparing local and remote commit hashes
5. WHEN project tests are run THEN THE Git_Optimization_System SHALL verify they pass without errors or failures

---

## Success Metrics

| Metric                 | Target   | Current  | Priority |
| ---------------------- | -------- | -------- | -------- |
| Repository Size        | < 100 MB | 56 MB ✅ | Medium   |
| Push Success Rate      | 100%     | 0% ❌    | Critical |
| Commit Count (pending) | 0        | 30 ❌    | High     |
| Objects per Push       | < 5000   | 9,811 ❌ | Critical |
| Build Files in History | 0        | 0 ✅     | Low      |
| Hook Coverage          | 100%     | 50% ⚠️   | Medium   |
| Squash Success Rate    | 100%     | N/A      | High     |

---

## Constraints

1. **No Data Loss**: جميع التغييرات في الكود يجب أن تُحفظ
2. **Backward Compatibility**: يجب أن يعمل مع Git 2.x+
3. **Time Limit**: العملية يجب أن تكتمل في أقل من 10 دقائق
4. **Safety First**: نسخ احتياطية قبل أي تغيير خطير
5. **Documentation**: كل خطوة يجب أن تُوثق

---

## Dependencies

- Git 2.x or higher
- GitHub account with push access
- Bash shell for scripts
- Sufficient disk space for backups

---

## Risks and Mitigations

| Risk                    | Impact | Probability | Mitigation                       |
| ----------------------- | ------ | ----------- | -------------------------------- |
| Data loss during squash | High   | Low         | Backup branch + verification     |
| Push still fails        | Medium | Medium      | Multiple fallback solutions      |
| Hooks break workflow    | Low    | Low         | Thorough testing + documentation |
| Network issues          | Low    | Medium      | Retry logic + offline mode       |

---

---

## 📁 المواصفات المدمجة

تم دمج المواصفات التالية في هذا المجلد لتوحيد جهود تحسين المستودع:

### المواصفات الأساسية

- **repository-audit/** - فحص شامل للمستودع البعيد وإعداداته
- **error-tracking/** - نظام تتبع الأخطاء مع Git Hooks وGitHub Actions
- **release-management/** - إدارة الإصدارات والعلامات والحزم
- **testing-integration/** - نظام الاختبارات مع CI/CD integration

### المواصفات المساعدة

- **steering-cleanup/** - تنظيف وإعادة هيكلة ملفات التوجيه
- **code-quality/** - تحسينات الكود وbuild_runner
- **critical-fixes/** - إصلاحات حرجة لبيئة التطوير
- **documentation/** - نظام التوثيق الشامل
- **context-optimization-closure/** - إغلاق مشروع تحسين السياق

**للتفاصيل:** راجع `README.md` في هذا المجلد

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 9 ديسمبر 2025 (محدث: 10 ديسمبر 2025)  
**الإصدار:** 3.0 (موحد وشامل)  
**الحالة:** ✅ نشط ومعتمد - مع مواصفات مدمجة
