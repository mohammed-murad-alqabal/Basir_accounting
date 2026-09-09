# Branch Integration Master Plan
**Document ID:** BASIR-MERGE-001
**Created:** September 9, 2026
**Status:** In Progress
**Author:** Basir Accounting System Development Agents Team

---

## Executive Summary

This document outlines a comprehensive strategy to integrate **59 unmerged branches** 
into a unified codebase, following a chronological, dependency-aware approach to 
minimize conflicts and ensure code integrity.

### Current State Analysis
- **Total Remote Branches:** 61
- **Branches Not Merged into Main:** 59
- **Develop Branch:** 18 commits ahead of main
- **Critical Integration Branch:** `integration/critical-features-20260909` (19 commits ahead)

---

## Phase 0: Pre-Integration Preparation

### 0.1 Create Integration Infrastructure
- Create dedicated integration branch: `integration/master-merge-20260909`
- Set up automated testing gates
- Configure conflict resolution protocols

### 0.2 Baseline Verification
- Ensure all tests pass on current main
- Run `flutter analyze` with zero errors
- Verify build integrity (Android/iOS)

---

## Phase 1: Foundation Layer (Oldest → Newest)

### 1.1 Core Security & Remediation Branches
**Priority: CRITICAL | Risk: HIGH | Order: Sequential**

| Order | Branch | Date | Commits | Files | Risk Level |
|-------|--------|------|---------|-------|------------|
| 1 | `remediation/ledger-security-hardening-20260812` | Aug 12 | 4 | 987 | HIGH |
| 2 | `fix/authoritative-ledger-authority-boundary` | Aug 13 | 13 | 973 | HIGH |

**Strategy:** These branches address security vulnerabilities and MUST be merged first.
They have large file counts, suggesting significant architectural changes.

### 1.2 CI/CD Baseline Fixes
**Priority: HIGH | Risk: MEDIUM | Order: Sequential by Date**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 3 | `fix/ci-baseline-202608` | Aug 13 | 2 | 823 |
| 4 | `fix/baseline-model-contracts-202608` | Aug 13 | 3 | 773 |
| 5 | `fix/restore-complete-generated-source-set-202608` | Aug 13 | 3 | 593 |
| 6 | `fix/ci-baseline-policy-202608` | Aug 13 | 3 | 823 |
| 7 | `fix/baseline-recovery-integration-202608` | Aug 13 | 5 | 539 |

**Strategy:** CI infrastructure must be stable before feature integration.

---

## Phase 2: Feature Foundation Branches

### 2.1 Storage & Database Foundation
**Priority: HIGH | Risk: HIGH | Order: Sequential**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 8 | `feat/supabase-governance-foundation-202608` | Aug 13 | 1 | 757 |
| 9 | `spike/drift-sqlite-cross-platform-202608` | Aug 15 | 21 | 723 |

**Strategy:** Data layer foundation must be established before feature branches.

### 2.2 Architecture & Contract Fixes
**Priority: HIGH | Risk: MEDIUM**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 10 | `audit/baseline-main-current-20260814` | Aug 14 | 6 | 493 |
| 11 | `fix/enhanced-ci-coverage-baseline-20260814` | Aug 14 | 7 | 493 |
| 12 | `fix/erp-architecture-gate-contract-20260814` | Aug 14 | 1 | 727 |

---

## Phase 3: CI/CD Workflow Stabilization

### 3.1 Platform-Specific Fixes
**Priority: MEDIUM | Risk: MEDIUM**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 13 | `fix/restore-generated-sources-main-20260815` | Aug 15 | 1 | 421 |
| 14 | `fix/ci-ios-flutter-platform-20260815` | Aug 15 | 1 | 651 |

### 3.2 Dependency & Configuration Fixes
**Priority: MEDIUM | Risk: LOW**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 15 | `fix/dependency-lockfiles-20260818` | Aug 18 | 2 | 13 |
| 16 | `chore/config-executable-debt-20260818` | Aug 18 | 2 | 15 |
| 17 | `chore/ignore-steering-cache-clean-20260818` | Aug 18 | 1 | 45 |

---

## Phase 4: Feature Branches (Complex Integration)

### 4.1 Storage Waves (Drift Implementation)
**Priority: HIGH | Risk: HIGH | Sequential Dependency**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 18 | `feat/customers-vendors-migration-parity-202608-v2` | Aug 15 | 1 | 729 |
| 19 | `feat/drift-barcode-wave0-20260816` | Aug 16 | 298 | 473 |
| 20 | `feat/drift-barcode-wave0-main-20260816` | Aug 16 | 4 | 437 |

**Note:** `feat/drift-barcode-wave0-20260816` has 298 commits - requires careful review.

### 4.2 Inventory & Stock Management
**Priority: HIGH | Risk: MEDIUM**

These branches are interrelated and should be merged together:

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 21 | `work/stock-movements-storage-base-20260817` | Aug 18 | 26 | 765 |
| 22 | `work/inventory-items-drift-20260817` | Sep 8 | 25 | 225 |
| 23 | `work/inventory-warehouses-drift-20260817` | Sep 8 | 24 | 221 |
| 24 | `work/stock-movements-drift-20260817` | Sep 8 | 28 | 245 |
| 25 | `work/stock-movements-contract-fix-20260817` | Sep 8 | 32 | 283 |
| 26 | `work/stock-movements-golden-fixtures-20260817` | Sep 8 | 26 | 233 |
| 27 | `work/stock-movements-importer-parity-20260817` | Sep 8 | 28 | 245 |

### 4.3 Additional Inventory Work
| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 28 | `feat/drift-inventory-wave1-main-20260818` | Aug 26 | 3 | 63 |

---

## Phase 5: CI/CD Workflow Fixes

### 5.1 Workflow Configuration
**Priority: MEDIUM | Risk: MEDIUM**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 29 | `fix/pr-comment-workflow-20260818` | Aug 18 | 2 | 47 |
| 30 | `fix/create-issue-workflow-20260818` | Aug 18 | 4 | 45 |
| 31 | `fix/ci-test-stability-20260818` | Aug 26 | 2 | 47 |
| 32 | `fix/ci-cd-foundation-20260818` | Aug 27 | 4 | 35 |
| 33 | `fix/pr-comment-workflow-clean-20260827` | Aug 26 | 1 | 47 |

### 5.2 Advanced CI Workflows
| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 34 | `fix/ci-workflow-yaml-20260823` | Aug 27 | 37 | 319 |
| 35 | `fix/ci-workflow-yaml-main-20260823` | Aug 27 | 2 | 9 |
| 36 | `fix/audit-conventional-commits-20260824` | Aug 27 | 4 | 21 |

---

## Phase 6: Feature Enhancements

### 6.1 UI/UX Foundation
**Priority: MEDIUM | Risk: MEDIUM**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 37 | `manus/basir-ui-ux-foundation` | Aug 23 | 12 | 75 |

### 6.2 Hardening & Security
**Priority: HIGH | Risk: MEDIUM**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 38 | `feat/basir-hardening-20260825` | Aug 27 | 6 | 63 |
| 39 | `bkip/authservice-remediation` | Aug 27 | 4 | 17 |

### 6.3 Data & Cloud Features
| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 40 | `feat/cloud-data-foundation-202608` | Aug 26 | 1 | 69 |
| 41 | `feat/drift-accounting-foundation-20260827` | Aug 30 | 4 | 85 |

---

## Phase 7: Audit & Quality Assurance

### 7.1 Production Readiness
**Priority: HIGH | Risk: MEDIUM**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 42 | `audit/production-readiness-20260826` | Aug 27 | 5 | 59 |
| 43 | `audit/accounting-engine-hardening` | Aug 27 | 12 | 69 |

---

## Phase 8: Dependabot Updates

### 8.1 GitHub Actions Updates
**Priority: LOW | Risk: LOW**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 44 | `dependabot/github_actions/actions/upload-artifact-7.0.1` | Sep 8 | 1 | 23 |
| 45 | `dependabot/github_actions/github/codeql-action/analyze-4.37.9` | Sep 8 | 1 | 3 |
| 46 | `dependabot/github_actions/actions/dependency-review-action-5.0.0` | Sep 8 | 1 | 5 |

### 8.2 Flutter/Dart Dependencies
**Priority: LOW | Risk: LOW**

| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 47 | `dependabot/pub/flutter-dependencies-40272144cc` | Sep 8 | 2 | 7 |
| 48 | `dependabot/pub/googleapis-16.0.0` | Aug 27 | 2 | 13 |
| 49 | `dependabot/pub/image_picker-1.2.3` | Aug 27 | 2 | 13 |
| 50 | `dependabot/pub/math_expressions-3.2.0` | Aug 27 | 2 | 13 |
| 51 | `dependabot/pub/path_provider-2.1.6` | Aug 27 | 2 | 13 |

---

## Phase 9: Remaining Feature & Work Branches

### 9.1 Work Branches
| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 52 | `work/actions-node24-20260827` | Aug 27 | 2 | 51 |
| 53 | `work/dependabot-config-fix-20260827` | Aug 27 | 1 | 47 |
| 54 | `work/customers-vendors-rebased-on-pr62-20260817` | Sep 8 | 23 | 215 |
| 55 | `work/real-snapshot-parity-gate-20260823` | Sep 8 | 38 | 299 |

### 9.2 Feature Branches
| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 56 | `feature/2.2-bulk-price-change` | Aug 28 | 12 | 53 |

### 9.3 BKIP Branches
| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 57 | `bkip/pr164-a-yaml-minimal` | Aug 25 | 1 | 45 |

### 9.4 Final Fixes
| Order | Branch | Date | Commits | Files |
|-------|--------|------|---------|-------|
| 58 | `fix/dependabot-config-valid-20260908` | Sep 8 | 1 | 0 |

---

## Phase 10: Develop Branch Integration

### 10.1 Final Integration
**Priority: CRITICAL | Risk: HIGH**

| Order | Branch | Commits | Status |
|-------|--------|---------|--------|
| 59 | `origin/develop` | 18 | Requires careful merge |

**Note:** The develop branch contains MFA implementation, AAOIFI models, 
and Rust API additions. This is a critical merge point.

---

## Conflict Resolution Protocol

### Priority Matrix
1. **Security branches** take precedence over all others
2. **CI/CD fixes** take precedence over feature branches
3. **Newer commits** take precedence over older ones (within same feature)
4. **Main branch** is the source of truth for conflicts

### Resolution Steps
1. Attempt automatic merge
2. If conflict detected:
   - Identify conflicting files
   - Analyze both versions
   - Choose resolution strategy (ours/theirs/manual)
   - Document resolution decision
3. Run `flutter analyze` after each resolution
4. Run test suite after resolution
5. Commit with descriptive message

---

## Verification Gates

### After Each Phase
- [ ] `flutter analyze` passes with 0 errors
- [ ] All unit tests pass
- [ ] No merge conflict markers remain
- [ ] Build succeeds (Android)
- [ ] Build succeeds (iOS) - if applicable

### Final Integration
- [ ] All 59 branches merged
- [ ] Full test suite passes
- [ ] Code coverage maintained or improved
- [ ] Security audit passes
- [ ] Documentation updated

---

## Rollback Strategy

At any point, if integration fails:
1. Tag current integration state: `git tag integration-failed-phase-N`
2. Reset to last known good state: `git reset --hard origin/main`
3. Document failure in `.kiro/specs/integration-log.md`
4. Re-plan integration strategy for problematic branch

---

## Timeline Estimate

| Phase | Estimated Time | Complexity |
|-------|----------------|------------|
| Phase 0: Preparation | 1 hour | Low |
| Phase 1: Foundation | 4-6 hours | High |
| Phase 2: Feature Foundation | 2-3 hours | Medium |
| Phase 3: CI/CD Stabilization | 2 hours | Medium |
| Phase 4: Feature Branches | 6-8 hours | High |
| Phase 5: CI/CD Fixes | 2-3 hours | Medium |
| Phase 6: Feature Enhancements | 3-4 hours | Medium |
| Phase 7: Audit & QA | 2 hours | Medium |
| Phase 8: Dependabot | 1 hour | Low |
| Phase 9: Remaining | 2 hours | Medium |
| Phase 10: Develop | 3-4 hours | High |
| **Total** | **28-36 hours** | |

---

## Risk Assessment

### High-Risk Branches
- `remediation/ledger-security-hardening-20260812` (987 files)
- `fix/authoritative-ledger-authority-boundary` (973 files)
- `feat/drift-barcode-wave0-20260816` (298 commits)

### Medium-Risk Branches
- All storage/Drift branches (interdependent)
- CI workflow branches (configuration conflicts)

### Low-Risk Branches
- Dependabot branches (dependency updates only)
- Simple fix branches (< 50 files)

---

## Success Criteria

1. ✅ All 59 branches successfully merged
2. ✅ Zero test failures
3. ✅ Zero analysis errors
4. ✅ Build succeeds on all platforms
5. ✅ No security vulnerabilities introduced
6. ✅ Documentation updated and accurate

---

**Document Control:**
- Prepared by: Basir Accounting System Development Agents Team
- Date: September 9, 2026
- Next Review: After Phase 5 completion
