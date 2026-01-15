# Specs Directory Governance

**Document ID:** BASIR-SPECS-GOV-001  
**Version:** 1.0  
**Date:** January 14, 2026  
**Status:** ✅ Active Policy  
**Authority:** Basir Accounting System Development Agents Team

---

## 🎯 Purpose

This document establishes strict governance rules for the `.kiro/specs`
directory to prevent bloat, maintain clarity, and ensure efficient
development workflows.

---

## 📜 Core Principles

### 1. Specs Are For Features, Not Processes

**✅ Valid Specs:**

- New user-facing features
- Major technical migrations (e.g., Riverpod v2 → v3)
- Compliance requirements (e.g., ZATCA Phase 2)
- Core system capabilities (e.g., i18n, authentication)

**❌ Invalid Specs:**

- Code cleanup tasks
- Documentation updates
- Repository organization
- Process improvements
- Meta-work about specs

**Rule:** If it's not a feature users will interact with or a major
technical requirement, it doesn't need a spec.

### 2. Active Specs Limit

**Maximum:** 5 active specs at any time

**Rationale:** Focus prevents context switching and ensures completion.

**Enforcement:** Pre-commit hook blocks commits if >5 active specs exist.

### 3. Lifecycle Management

```
┌─────────┐    ┌─────────┐    ┌──────────┐    ┌──────────┐
│Planning │ -> │ Active  │ -> │Completed │ -> │ Archived │
└─────────┘    └─────────┘    └──────────┘    └──────────┘
   (days)        (weeks)        (24 hours)      (30 days)
```

**Timelines:**

- **Planning → Active:** When work begins
- **Active → Completed:** Within 24 hours of completion
- **Completed → Archived:** After 30 days
- **Archived → Deleted:** After 1 year (optional)

---

## 📁 Directory Structure

### Mandatory Structure

```
.kiro/specs/
├── README.md                    # Index and navigation
├── GOVERNANCE.md                # This document
├── active/                      # Current work (max 5)
│   ├── feature-name-1/
│   │   ├── requirements.md
│   │   ├── design.md
│   │   └── tasks.md
│   └── feature-name-2/
│       └── requirements.md
├── planning/                    # Future work
│   ├── roadmap.md
│   └── feature-ideas/
├── completed/                   # Recently finished (temp)
│   └── (empty - move to archived within 24h)
└── archived/                    # Historical reference
    ├── 2025-completed/
    ├── 2026-completed/
    └── superseded/
```

### Forbidden Patterns

❌ Root-level spec documents (except README, GOVERNANCE)  
❌ Duplicate directories (e.g., `feature/` and `feature-name/`)  
❌ Meta-specs (e.g., `specs-cleanup/`, `documentation-org/`)  
❌ Completed specs in `active/`  
❌ More than 5 specs in `active/`

---

## 📝 Spec Creation Rules

### When to Create a Spec

**Checklist:**

- [ ] Is this a user-facing feature or major technical requirement?
- [ ] Will this take more than 3 days to implement?
- [ ] Does this require design decisions and planning?
- [ ] Will multiple people need to understand this work?

**If 3+ checkboxes are YES:** Create a spec  
**If <3 checkboxes are YES:** Use tasks.md or docs/ instead

### Naming Convention

**Format:** `feature-name` (kebab-case)

**✅ Good Names:**

- `zatca-compliance`
- `multi-currency-support`
- `expense-tracking`
- `customer-portal`

**❌ Bad Names:**

- `fix-bugs` (too vague)
- `improve-performance` (not a feature)
- `cleanup-code` (process, not feature)
- `update-dependencies` (maintenance, not feature)

### Required Files

**Minimum:**

- `requirements.md` - EARS-formatted requirements

**Standard:**

- `requirements.md` - User stories and acceptance criteria
- `design.md` - Technical design and architecture
- `tasks.md` - Implementation checklist

**Optional:**

- `README.md` - Spec overview (for complex features)
- `*.png`, `*.svg` - Diagrams and mockups

**Forbidden:**

- Progress reports (use git commits)
- Status updates (use tasks.md checkboxes)
- Meeting notes (use docs/meetings/)

---

## 🔄 Lifecycle Procedures

### Moving to Active

**Trigger:** Work begins on a planned feature

**Procedure:**

```bash
# 1. Verify active specs count
count=$(ls -1 .kiro/specs/active | wc -l)
if [ $count -ge 5 ]; then
    echo "ERROR: Already 5 active specs. Complete one first."
    exit 1
fi

# 2. Move from planning
mv .kiro/specs/planning/feature-name .kiro/specs/active/

# 3. Update README.md
# 4. Commit
git add .kiro/specs
git commit -m "spec: activate feature-name"
```

### Moving to Completed

**Trigger:** All tasks in tasks.md are checked

**Procedure:**

```bash
# 1. Verify all tasks complete
if grep -q "\[ \]" .kiro/specs/active/feature-name/tasks.md; then
    echo "ERROR: Incomplete tasks found"
    exit 1
fi

# 2. Move to completed
mv .kiro/specs/active/feature-name .kiro/specs/completed/

# 3. Update README.md
# 4. Commit
git add .kiro/specs
git commit -m "spec: complete feature-name"
```

**Deadline:** Within 24 hours of completion

### Moving to Archived

**Trigger:** 30 days after completion

**Procedure:**

```bash
# 1. Create year directory if needed
mkdir -p .kiro/specs/archived/$(date +%Y)-completed

# 2. Move to archived
mv .kiro/specs/completed/feature-name \
   .kiro/specs/archived/$(date +%Y)-completed/

# 3. Update README.md
# 4. Commit
git add .kiro/specs
git commit -m "spec: archive feature-name"
```

**Automation:** Monthly cron job or GitHub Action

---

## 🚨 Enforcement

### Pre-Commit Hook

**Location:** `.githooks/pre-commit`

```bash
#!/bin/bash

# Check active specs count
ACTIVE_COUNT=$(find .kiro/specs/active -maxdepth 1 -type d | wc -l)
ACTIVE_COUNT=$((ACTIVE_COUNT - 1))

if [ $ACTIVE_COUNT -gt 5 ]; then
    echo "❌ ERROR: Too many active specs ($ACTIVE_COUNT/5)"
    echo "Complete or archive a spec before adding new ones."
    exit 1
fi

# Check for completed specs in active/
if grep -r "Status.*Complete" .kiro/specs/active/ 2>/dev/null; then
    echo "❌ ERROR: Completed specs found in active/"
    echo "Move to completed/ directory."
    exit 1
fi

# Check for old completed specs
THIRTY_DAYS_AGO=$(date -d "30 days ago" +%s)
for spec in .kiro/specs/completed/*/; do
    if [ -d "$spec" ]; then
        SPEC_DATE=$(stat -c %Y "$spec")
        if [ $SPEC_DATE -lt $THIRTY_DAYS_AGO ]; then
            SPEC_NAME=$(basename "$spec")
            echo "⚠️  WARNING: $SPEC_NAME is >30 days old"
            echo "Consider archiving it."
        fi
    fi
done

exit 0
```

### Monthly Audit

**Schedule:** First Monday of each month

**Checklist:**

- [ ] Active specs count ≤5
- [ ] No completed specs in active/
- [ ] Completed/ directory is empty or <30 days old
- [ ] README.md is up to date
- [ ] No root-level spec documents

**Owner:** Tech Lead

---

## 📊 Metrics and Monitoring

### Key Metrics

| Metric                    | Target   | Measurement                              |
| ------------------------- | -------- | ---------------------------------------- |
| **Active Specs**          | ≤5       | `ls -1 .kiro/specs/active \| wc -l`      |
| **Total Files**           | <50      | `find .kiro/specs -name "*.md" \| wc -l` |
| **Directory Size**        | <500KB   | `du -sh .kiro/specs`                     |
| **Avg Completion Time**   | <4 weeks | Git history analysis                     |
| **Specs Completed/Month** | ≥2       | Git history analysis                     |

### Dashboard

**Location:** `.kiro/specs/METRICS.md` (auto-generated)

**Update Frequency:** Weekly

**Contents:**

- Current active specs
- Completion rate
- Average time in active
- Size trends
- Compliance status

---

## 🔧 Tools and Automation

### Cleanup Script

**Location:** `.kiro/specs/cleanup_specs.sh`

**Usage:**

```bash
cd .kiro/specs
./cleanup_specs.sh
```

**Purpose:** Automated cleanup and reorganization

### Metrics Script

**Location:** `.kiro/specs/generate_metrics.sh`

**Usage:**

```bash
cd .kiro/specs
./generate_metrics.sh > METRICS.md
```

**Purpose:** Generate metrics dashboard

### Git Hooks

**Installation:**

```bash
./scripts/setup-git-hooks.sh
```

**Hooks:**

- `pre-commit` - Enforce active specs limit
- `post-commit` - Update metrics

---

## 📚 Examples

### Example 1: Creating a New Spec

```bash
# 1. Check if spec is needed
# - User-facing feature? YES
# - >3 days work? YES
# - Needs design? YES
# - Multiple people? YES
# → Create spec

# 2. Check active specs count
ls -1 .kiro/specs/active | wc -l
# Output: 4 (OK, can add one more)

# 3. Create spec structure
mkdir -p .kiro/specs/active/expense-tracking
cd .kiro/specs/active/expense-tracking

# 4. Create requirements.md
cat > requirements.md << 'EOF'
# Requirements: Expense Tracking

## Requirement 1: Record Expenses
...
EOF

# 5. Commit
git add .kiro/specs/active/expense-tracking
git commit -m "spec: create expense-tracking requirements"
```

### Example 2: Completing a Spec

```bash
# 1. Verify all tasks complete
grep "\[ \]" .kiro/specs/active/expense-tracking/tasks.md
# Output: (empty - all done)

# 2. Move to completed
mv .kiro/specs/active/expense-tracking \
   .kiro/specs/completed/

# 3. Update README
# Edit .kiro/specs/README.md

# 4. Commit
git add .kiro/specs
git commit -m "spec: complete expense-tracking"
```

### Example 3: Archiving Old Specs

```bash
# 1. Check age
stat -c %Y .kiro/specs/completed/expense-tracking
# Output: 1704067200 (>30 days ago)

# 2. Archive
mkdir -p .kiro/specs/archived/2026-completed
mv .kiro/specs/completed/expense-tracking \
   .kiro/specs/archived/2026-completed/

# 3. Commit
git add .kiro/specs
git commit -m "spec: archive expense-tracking"
```

---

## 🚫 Anti-Patterns to Avoid

### 1. Spec Proliferation

**Problem:** Creating specs for everything

**Example:**

```
❌ active/fix-button-padding/
❌ active/update-readme/
❌ active/refactor-providers/
```

**Solution:** Use tasks.md or docs/ instead

### 2. Eternal Active Specs

**Problem:** Specs that never complete

**Example:**

```
❌ active/improve-performance/  (6 months old)
❌ active/enhance-ui/           (1 year old)
```

**Solution:** Break into smaller, completable specs

### 3. Meta-Spec Recursion

**Problem:** Specs about managing specs

**Example:**

```
❌ active/specs-cleanup/
❌ active/specs-reorganization/
❌ active/specs-governance/
```

**Solution:** This governance doc is sufficient

### 4. Duplicate Specs

**Problem:** Multiple specs for same feature

**Example:**

```
❌ active/onboarding/
❌ active/enhanced-onboarding/
❌ active/onboarding-tutorial/
```

**Solution:** Consolidate into one spec

---

## 📞 Governance Review

### Review Schedule

**Frequency:** Quarterly

**Next Review:** April 14, 2026

**Participants:**

- Tech Lead
- Senior Developers
- Product Owner

**Agenda:**

1. Review metrics
2. Assess compliance
3. Update rules if needed
4. Plan improvements

### Amendment Process

**Proposal:**

1. Create issue with proposed change
2. Discuss with team
3. Vote (majority wins)
4. Update this document
5. Communicate to team

**Version Control:**

- Increment version number
- Update "Last Updated" date
- Document changes in CHANGELOG

---

## 📋 Checklist for Compliance

### Daily

- [ ] Active specs ≤5
- [ ] No completed specs in active/

### Weekly

- [ ] Update METRICS.md
- [ ] Review completed/ directory
- [ ] Check for old specs

### Monthly

- [ ] Archive specs >30 days old
- [ ] Audit all directories
- [ ] Update README.md
- [ ] Review metrics trends

### Quarterly

- [ ] Governance review meeting
- [ ] Update policies if needed
- [ ] Clean up archived/ if needed
- [ ] Celebrate successes

---

## 🎯 Success Criteria

This governance is successful when:

1. **Active specs ≤5** at all times
2. **Completion rate ≥2 specs/month**
3. **No specs >8 weeks in active/**
4. **Directory size <500KB**
5. **Zero meta-specs**
6. **100% compliance** with lifecycle rules

---

## 📚 References

- [Spec Workflow Documentation](../../docs/guides/kiro_reference/spec-workflow.md)
- [EARS Requirements Format](../../docs/guides/kiro_reference/ears-format.md)
- [Git Workflow](../../docs/guides/kiro_reference/git-standards.md)

---

**Document Control:**

- **Prepared by:** Basir Accounting System Development Agents Team
- **Approved by:** Tech Lead
- **Effective Date:** January 14, 2026
- **Next Review:** April 14, 2026
- **Version:** 1.0

---

**Compliance Status:** 🔴 Pending Initial Cleanup

**Action Required:** Execute cleanup_specs.sh before enforcing this policy
