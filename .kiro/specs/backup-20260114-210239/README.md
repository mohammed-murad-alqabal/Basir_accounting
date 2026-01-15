# Specs Directory - Index & Navigation

**Project:** Basir Accounting System  
**Author:** Basir Accounting System Development Agents Team  
**Last Updated:** January 14, 2026  
**Status:** 🔴 Cleanup Required

---

## 🚨 IMPORTANT: Cleanup Required

This directory has **269 files** and **26 active specs** - far too many.

**Action Required:** Execute cleanup before proceeding with new work.

```bash
cd .kiro/specs
./cleanup_specs.sh
```

**Documentation:**

- 📊 [VISUAL_SUMMARY.md](VISUAL_SUMMARY.md) - Visual overview
- 📋 [CLEANUP_SUMMARY.md](CLEANUP_SUMMARY.md) - Executive summary
- 🔍 [SPECS_BLOAT_ANALYSIS.md](SPECS_BLOAT_ANALYSIS.md) - Detailed analysis
- 📚 [GOVERNANCE.md](GOVERNANCE.md) - Future governance rules
- ⚡ [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Quick commands

---

## 📁 Current Structure (Before Cleanup)

### **active/** - Active Specs (26 - TOO MANY)

**Core Features (Keep):**

- `accounting-standards-framework/` - Core accounting features
- `i18n-localization-system/` - Localization system
- `ui-ux-improvements/` - UI/UX enhancements
- `widget-tests-phase3/` - Current testing work

**To Be Archived (22):**

- See CLEANUP_SUMMARY.md for full list

### **completed/** - Completed Specs (12)

- All should be archived to `archived/2025-completed/`

### **archived/** - Archived Specs (2)

- Will grow to ~30 after cleanup

### **planning/** - Planning & Future Work

- `strategic-decisions/` - Strategic decisions
- `analysis-reports/` - Analysis reports
- `local-analytics/` - Local analytics (planning)

---

## 📁 Target Structure (After Cleanup)

### **active/** - Active Specs (≤5)

1. `accounting-standards-framework/` - Core accounting
2. `i18n-localization-system/` - Localization
3. `ui-ux-improvements/` - UI/UX
4. `widget-tests-phase3/` - Testing
5. [One more slot available]

### **completed/** - Completed Specs (0)

- Temporary staging only (move within 24h)

### **archived/** - Historical Reference

- `2025-completed/` - Completed specs from 2025
- `2026-completed/` - Completed specs from 2026
- `meta-work/` - Process improvement specs
- `superseded/` - Replaced/obsolete specs

### **planning/** - Future Work

- Roadmap and future features

---

## 📊 Statistics

### Current (Before Cleanup)

- **Active Specs:** 26 (Target: ≤5)
- **Total Files:** 269 (Target: <50)
- **Directory Size:** 4.3 MB (Target: <500KB)
- **Status:** 🔴 Critical

### Target (After Cleanup)

- **Active Specs:** 5 (-81%)
- **Total Files:** ~50 (-81%)
- **Directory Size:** ~500 KB (-88%)
- **Status:** ✅ Healthy

---

## 🎯 Governance Rules

### Active Specs

- **Maximum:** 5 specs at any time
- **Criteria:** User-facing features or major technical requirements
- **Duration:** <8 weeks in active/

### Lifecycle

1. **Planning** → Ideas and future work
2. **Active** → Current development (max 5)
3. **Completed** → Finished work (move within 24h)
4. **Archived** → Historical reference (after 30 days)

### Forbidden

- ❌ Meta-specs (process improvements)
- ❌ More than 5 active specs
- ❌ Completed specs in active/
- ❌ Root-level spec documents

**Full Rules:** See [GOVERNANCE.md](GOVERNANCE.md)

---

## 🚀 Quick Commands

### Check Status

```bash
# Count active specs
ls -1 .kiro/specs/active | wc -l

# Count total files
find .kiro/specs -name "*.md" | wc -l

# Check size
du -sh .kiro/specs
```

### Execute Cleanup

```bash
cd .kiro/specs
./cleanup_specs.sh
```

### Create New Spec

```bash
# 1. Verify <5 active specs
ls -1 .kiro/specs/active | wc -l

# 2. Create structure
mkdir -p .kiro/specs/active/feature-name
cd .kiro/specs/active/feature-name

# 3. Create requirements.md
# 4. Commit
git add .kiro/specs/active/feature-name
git commit -m "spec: create feature-name requirements"
```

**More Commands:** See [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

---

## 📚 Documentation Index

| Document                                           | Purpose                        | Size |
| -------------------------------------------------- | ------------------------------ | ---- |
| [README.md](README.md)                             | This file - Index & navigation | 4KB  |
| [VISUAL_SUMMARY.md](VISUAL_SUMMARY.md)             | Visual overview with diagrams  | 8KB  |
| [CLEANUP_SUMMARY.md](CLEANUP_SUMMARY.md)           | Executive summary              | 4KB  |
| [SPECS_BLOAT_ANALYSIS.md](SPECS_BLOAT_ANALYSIS.md) | Detailed analysis              | 12KB |
| [GOVERNANCE.md](GOVERNANCE.md)                     | Rules and policies             | 16KB |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md)           | Quick commands                 | 4KB  |
| [cleanup_specs.sh](cleanup_specs.sh)               | Automated cleanup script       | 5KB  |

**Total:** 53KB of documentation to manage 4.3MB of specs

---

## 🎯 Recommended Reading Order

### For Quick Understanding (5 minutes)

1. [VISUAL_SUMMARY.md](VISUAL_SUMMARY.md) - See the problem visually
2. [CLEANUP_SUMMARY.md](CLEANUP_SUMMARY.md) - Understand the solution

### For Execution (10 minutes)

1. [CLEANUP_SUMMARY.md](CLEANUP_SUMMARY.md) - Read the plan
2. Execute `./cleanup_specs.sh` - Run the cleanup
3. [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Learn the commands

### For Deep Understanding (30 minutes)

1. [SPECS_BLOAT_ANALYSIS.md](SPECS_BLOAT_ANALYSIS.md) - Full analysis
2. [GOVERNANCE.md](GOVERNANCE.md) - Complete rules
3. [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Reference guide

---

## ✅ Next Steps

### Immediate (Today)

1. ⏳ Read [CLEANUP_SUMMARY.md](CLEANUP_SUMMARY.md)
2. ⏳ Execute `./cleanup_specs.sh`
3. ⏳ Verify results
4. ⏳ Commit changes

### This Week

1. ⏳ Read [GOVERNANCE.md](GOVERNANCE.md)
2. ⏳ Install git hooks
3. ⏳ Update team on new rules

### Ongoing

1. ⏳ Maintain ≤5 active specs
2. ⏳ Archive completed specs monthly
3. ⏳ Review governance quarterly

---

## 📞 Support

### Questions?

- See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for common tasks
- See [GOVERNANCE.md](GOVERNANCE.md) for rules
- See [SPECS_BLOAT_ANALYSIS.md](SPECS_BLOAT_ANALYSIS.md) for details

### Issues?

- Backup is created automatically by cleanup script
- Restore with: `cp -r .kiro/specs/backup-*/* .kiro/specs/`

---

## 🎯 Success Criteria

After cleanup, you should have:

- ✅ ≤5 active specs
- ✅ <50 total files
- ✅ <500KB directory size
- ✅ Clear focus on current work
- ✅ No confusion about priorities

---

**Prepared by:** Basir Accounting System Development Agents Team  
**Date:** January 14, 2026  
**Priority:** 🔴 Critical - Execute cleanup before new work

---

**🚀 Action Required: Execute `./cleanup_specs.sh` now**
