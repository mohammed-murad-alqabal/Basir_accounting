# 📇 Master Documentation Index: Basir Accounting System

**Project:** Basir Accounting System - Professional High-Fidelity Infrastructure  
**Format:** Searchable Technical Registry  
**Last Updated:** September 10, 2026  
**Author:** Basir Project Agentic Development Team  
**Status:** ✅ Specs Cleanup Complete

---

## 📁 Final Documentation Structure

```
/docs/
├── 00-governance/        # الحوكمة والسياسات
├── 01-core/              # الوثائق الأساسية للمشروع
├── 02-domain/            # متطلبات النطاق والمجال
├── 03-architecture/      # قرارات التصميم (ADRs + technical-layers)
├── 04-data/              # عقود البيانات
├── guides/               # أدلة التشغيل والتطوير
├── migration/            # ترحيل Drift/Supabase
├── phases/               # المراحل الاستراتيجية (سابقاً Strategic/)
├── reports/              # التقارير والتدقيقات
├── specs/                # المواصفات النشطة والمكتملة
│   └── active/           # المواصفات النشطة فقط (9)
├── templates/            # قوالب المستندات
├── reference/            # المراجع التقنية
├── standards/            # معايير التطوير
├── sessions/             # جلسات العمل والقرارات
├── releases/             # ملاحظات الإصدارات
├── project/              # ملفات المشروع العامة
├── strategic-core/       # الوثائق الاستراتيجية الأساسية (سابقاً Core/)
├── archive/              # الأرشيف والتاريخ
└── tools/                # أدوات وسكرابتات
```

---

## 📊 Final Statistics

| Metric | Value |
|:-------|:------|
| **Total Documentation Files** | 620 |
| **Total Directories** | 108 |
| **Files Cleaned (First Pass)** | ~100 (duplicates, empty, noise) |
| **Files Cleaned (Second Pass)** | ~60+ (specs cleanup) |
| **Files Cleaned (Final Pass)** | ~20 (kiro-reports, merged archives) |
| **Files Moved to Migration** | 34 (DRIFT files) |
| **Files Archived** | 120+ (kiro reports, JSON, scripts, old reports) |
| **Directories Cleaned** | 20+ (troubleshooting, audits, status, kiro-reports, etc.) |
| **Specs Active** | 7 (after filtering internal docs) |
| **Specs Archived** | 8 (strategic decisions, widget tests, status reviews) |

---

## 🏛️ Core Documentation (01-core/)

| Document | Description | Priority |
|:---------|:------------|:---------|
| [README.md](./01-core/README.md) | نظرة عامة على المشروع | ⭐⭐⭐⭐⭐ |
| [ARCHITECTURE.md](./01-core/ARCHITECTURE.md) | البنية المعمارية للنظام | ⭐⭐⭐⭐⭐ |
| [CHANGELOG.md](./01-core/CHANGELOG.md) | سجل التغييرات | ⭐⭐⭐⭐ |
| [CONTRIBUTING.md](./01-core/CONTRIBUTING.md) | دليل المساهمة | ⭐⭐⭐⭐ |
| [SECURITY.md](./01-core/SECURITY.md) | سياسة الأمان | ⭐⭐⭐⭐⭐ |
| [TECHNICAL_SPEC.md](./01-core/TECHNICAL_SPEC.md) | المواصفات التقنية | ⭐⭐⭐⭐ |
| [STRUCTURE.md](./01-core/STRUCTURE.md) | هيكل المشروع | ⭐⭐⭐⭐ |

---

## 📊 Reports (reports/)

### Audits & Reviews
| Document | Description |
|:---------|:------------|
| [ENGINEERING_AUDIT_REPORT.md](./reports/audits/ENGINEERING_AUDIT_REPORT.md) | تقرير التدقيق الهندسي |
| [SECURITY_HISTORY_REMEDIATION.md](./reports/audits/SECURITY_HISTORY_REMEDIATION.md) | سجل معالجة الأمان |
| [AUDIT_LOG_20251229.md](./reports/audits/AUDIT_LOG_20251229.md) | سجل التدقيق |

### Project Status
| Document | Description |
|:---------|:------------|
| [PRODUCTION_READINESS_REPORT_20260826.md](./reports/project-status/PRODUCTION_READINESS_REPORT_20260826.md) | جاهزية الإنتاج |
| [PR_RECONCILIATION_REGISTER_20260827.md](./reports/project-status/PR_RECONCILIATION_REGISTER_20260827.md) | سجل التسوية |
| [SYNC_STATUS_REPORT.md](./reports/project-status/SYNC_STATUS_REPORT.md) | تقرير المزامنة |

### Archive
- [archive/reports/2026-01/](./archive/reports/2026-01/) - تقارير مؤرشفة (يناير 2026) - 73 ملف
- [archive/analysis-temp/](./archive/analysis-temp/) - تحليلات مؤقتة

---

## 📖 Guides (guides/)

### Development
| Document | Description |
|:---------|:------------|
| [development/CONTINUATION_PLAN.md](./guides/development/CONTINUATION_PLAN.md) | خطة الاستمرارية |
| [development/MCP_QUICK_SETUP.md](./guides/development/MCP_QUICK_SETUP.md) | إعداد MCP السريع |

### Troubleshooting
| Document | Description |
|:---------|:------------|
| [ERROR_TRACKING_GUIDE.md](./guides/troubleshooting/ERROR_TRACKING_GUIDE.md) | دليل تتبع الأخطاء |
| [ERROR_RESOLUTION_LOG.md](./guides/troubleshooting/ERROR_RESOLUTION_LOG.md) | سجل حل الأخطاء |
| [debug-mobile-device-validation.md](./guides/troubleshooting/debug-mobile-device-validation.md) | تصحيح التحقق من الجهاز |

### CI/CD
| Document | Description |
|:---------|:------------|
| [CI_GITHUB_ACTIONS.md](./guides/ci/CI_GITHUB_ACTIONS.md) | GitHub Actions |
| [CI_PERFORMANCE_GUIDE.md](./guides/ci/CI_PERFORMANCE_GUIDE.md) | دليل أداء CI |
| [CI_PRODUCTION_GATE.md](./guides/ci/CI_PRODUCTION_GATE.md) | بوابة الإنتاج |

### Migration
| Document | Description |
|:---------|:------------|
| [riverpod-v3-migration-plan.md](./guides/migration/riverpod-v3-migration-plan.md) | خطة ترحيل Riverpod v3 |
| [git-workflow-guide.md](./guides/migration/git-workflow-guide.md) | دليل سير عمل Git |

### Other
| Document | Description |
|:---------|:------------|
| [customization_system.md](./guides/design/customization_system.md) | نظام التخصيص |
| [design_tokens_guide.md](./guides/design/design_tokens_guide.md) | دليل Design Tokens |
| [components_guide.md](./guides/engineering/components_guide.md) | دليل المكونات |

---

## 📝 Specifications (specs/active/)

### Active Specs (7 Total)

| Spec | Description | Files |
|:-----|:------------|:------|
| [basir_master_specification/](./specs/active/basir_master_specification/) | المواصفة الرئيسية للنظام | 10 |
| [accounting-core/](./specs/active/accounting-core/) | أساسيات المحاسبة | 1 |
| [ui-ux-improvements/](./specs/active/ui-ux-improvements/) | تحسينات UI/UX | 8 |
| [beta-testing-program/](./specs/active/beta-testing-program/) | برنامج التesting التجريبي | 1 |
| [enhanced-onboarding/](./specs/active/enhanced-onboarding/) | تجربة علىboarding المحسنة | 5 |
| [local-analytics/](./specs/active/local-analytics/) | التحليلات المحلية | 1 |
| [onboarding-tutorial/](./specs/active/onboarding-tutorial/) | درس التهيئة | 4 |

### Archived Specs
| Archive | Description |
|:--------|:------------|
| [archive/specs/completed/](./archive/specs/completed/) | المواصفات المكتملة |
| [archive/specs/kiro-meta/](./archive/specs/kiro-meta/) | أرشيف Kiro Meta |
| [archive/specs/legacy/](./archive/specs/legacy/) | الأنظمة القديمة |
| [archive/testing/widget-tests-phase3/](./archive/testing/widget-tests-phase3/) | اختبارات Widget (مؤرشفة) |
| [reports/strategic/](./reports/strategic/) | القرارات الاستراتيجية (مؤرشفة) |

### Recent Archivals (September 2026)
| Date | Removed | Reason |
|:-----|:--------|:-------|
| Sep 10 | strategic-decisions/ | قرارات داخلية، لا تحتاج كـ spec |
| Sep 10 | widget-tests-phase3/ | مهمة إصلاح اختبارات |
| Sep 10 | PROJECT_STATUS_REVIEW.md | تقرير داخلي |

---

## 🎯 Governance (00-governance/)

| Document | Description |
|:---------|:------------|
| [AUTHORITY_MODEL.md](./00-governance/AUTHORITY_MODEL.md) | نموذج الصلاحيات |
| [AUTOMATION.md](./00-governance/AUTOMATION.md) | سياسة الأتمتة |
| [DOCUMENTATION_REGISTER.md](./00-governance/DOCUMENTATION_REGISTER.md) | سجل التوثيق |

---

## 🧱 Architecture (03-architecture/)

### Architecture Decision Records (ADRs)
- [ADR-ACC-001-journal-entry-posting-invariants.md](./03-architecture/adrs/ADR-ACC-001-journal-entry-posting-invariants.md)
- [ADR-DATA-001-financial-data-boundaries.md](./03-architecture/adrs/ADR-DATA-001-financial-data-boundaries.md)
- [ADR-PLAT-001-web-build-support-boundary.md](./03-architecture/adrs/ADR-PLAT-001-web-build-support-boundary.md)

---

## 🔄 Migration

### Drift Database Migration
| Document | Description |
|:---------|:------------|
| [DRIFT_TARGET_ARCHITECTURE.md](./migration/drift/DRIFT_TARGET_ARCHITECTURE.md) | البنية المستهدفة |
| [DRIFT_MIGRATION_WAVES.md](./migration/drift/DRIFT_MIGRATION_WAVES.md) | موجات الترحيل |

### Supabase
| Document | Description |
|:---------|:------------|
| [SUPABASE_DEPLOYMENT_RUNBOOK.md](./migration/supabase/SUPABASE_DEPLOYMENT_RUNBOOK.md) | دليل نشر Supabase |

---

## 🗂️ Archives

| Archive | Description |
|:--------|:------------|
| [analysis-temp/](./archive/analysis-temp/) | تحليلات مؤقتة |
| [data-snapshots/](./archive/data-snapshots/) | لقطات بيانات (JSON) |
| [reports/](./archive/reports/) | تقارير مؤرشفة (73 ملف في 2026-01) |
| [specs/](./archive/specs/) | مواصفات مؤرشفة (legacy, completed, kiro-meta) |

---

## 📋 Project Files (project/)

| Document | Description |
|:---------|:------------|
| [todo.md](./project/todo.md) | قائمة المهام |

---

**Stewardship Entity:** Basir Project Agentic Development Team  
**Operational Status:** ✅ Deep Reorganization Complete  
**Specs Active:** 7 (after cleanup)
**Last Action:** Merged reports/archive/reports-2026-01 → archive/reports/2026-01, removed kiro-reports
