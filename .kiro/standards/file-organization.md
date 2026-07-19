# File Organization Standards

**Project:** Basir MVP  
**Date:** December 9, 2025  
**Status:** ✅ Active and Approved

---

## 🎯 Objective

Ensure excellent and sustainable file organization throughout the project while preventing the accumulation of technical mess/clutter.

---

## 📁 Core Structure

### 1. Root Directory - Always Clean

**Golden Rule:** Only essential and standard configuration files are permitted in the root.

#### ✅ Allowed Files

```
README.md              # Project overview
LICENSE                # License information
CHANGELOG.md           # History of changes
CONTRIBUTING.md        # Contribution guidelines
SECURITY.md            # Security policy
ARCHITECTURE.md        # Architectural overview
TESTING.md             # Testing guide
```

#### ❌ Forbidden Files

```
*.log                  # Logs → Move to logs/
*.tmp                  # Temporary files → Move to /tmp/ or ignore
*.bak                  # Backups → Move to backups/
*.db                   # Databases → Move to .kiro/data/
*_REPORT.md            # Reports → Move to docs/ or .kiro/docs/
*_STATUS.md            # Status reports → Move to .kiro/docs/reports/
```

---

### 2. docs/ - Official Documentation

**Purpose:** Official external-facing project documentation and critical long-term reports.

#### Structure

```
docs/
├── api/               # API documentation
├── Archive/           # Archived legacy documents
├── Core/              # Fundamental strategic documents
├── guides/            # Comprehensive guides
│   ├── deployment/
│   └── development/
├── reports/           # High-impact reports
│   ├── analysis/
│   └── fixes/
└── sessions/          # Session logs (high-level)
```

#### Rules

- ✅ Official documentation only.
- ✅ Critical long-term reports.
- ✅ Comprehensive technical guides.
- ❌ No temporary reports.
- ❌ No experimental or "scratch" files.

#### Archiving Policy

- Files older than 90 days → `Archive/`
- Compressed archives → `.kiro/archives/`

---

### 3. .kiro/docs/ - Internal Documentation

**Purpose:** Internal reports, action plans, and technical specifications.

#### Structure

```
.kiro/docs/
├── plans/             # Action and implementation plans
├── reports/           # Internal technical reports
│   ├── kiro/         # Kiro Workflow reports
│   ├── phases/       # Phase-specific reports
│   ├── components/   # Component-specific reports
│   ├── sessions/     # Session-specific reports
│   ├── enhancements/ # Feature enhancement reports
│   ├── status/       # Status tracking reports
│   ├── quality/      # Quality and audit reports
│   └── reorganization/ # Maintenance and reorganization reports
└── [Other internal files]
```

#### Rules

- ✅ Internal technical reports.
- ✅ Action plans and technical specs.
- ✅ Low-level technical documentation.
- ❌ No `*_TEMP.md` files.
- ❌ No `*_OLD.md` files.

#### Archiving Policy

- Legacy reports (> 3 months) → Compressed archive.
- Retain only high-value reports.

---

### 4. scripts/ - Automation & Utilities

**Purpose:** All shell and automation scripts organized by category.

#### Structure

```
scripts/
├── archive/           # Deprecated/Archived scripts
├── hooks/             # Git hooks (pre-commit, etc.)
├── maintenance/       # Maintenance and cleanup scripts
├── utils/             # Helper tools and utilities
└── [Core scripts]
```

#### Rules

- ✅ Categorized organization.
- ✅ Clear, descriptive naming.
- ✅ Inline documentation/comments.
- ✅ Proper execution permissions (`chmod +x`).

#### Examples

```bash
# ✅ Correct
scripts/maintenance/cleanup_project.sh
scripts/utils/compress.sh
scripts/hooks/pre-commit

# ❌ Incorrect
cleanup.sh                    # Should not be in Root
scripts/script1.sh            # Ambiguous naming
scripts/temp_fix.sh           # Temporary/Non-standard
```

---

### 5. logs/ - Logs

**Purpose:** All logs organized by source/type.

#### Structure

```
logs/
├── errors/            # Error logs
├── flutter/           # Flutter build/run logs
├── git/               # Git operation logs
└── .gitignore         # Ensure temporary logs are not committed
```

#### Rules

- ✅ Categorized by source.
- ✅ Clear naming including timestamp.
- ✅ Periodic rotation/archiving.
- ❌ No logs in project root.

#### Naming Convention

```bash
# ✅ Correct
logs/errors/error_2025-12-09.log
logs/flutter/flutter_build_2025-12-09.log

# ❌ Incorrect
error.log                     # Should not be in Root
logs/log1.log                 # Ambiguous naming
```

---

### 6. .kiro/data/ - Internal Data Storage

**Purpose:** Local databases and internal configuration data for agentic workflows.

#### Rules

- ✅ MCP-specific databases.
- ✅ Internal configuration files.
- ✅ Temporary data storage.
- ❌ Do not store sensitive/private credentials here.

---

## 🚫 Forbidden Patterns

### Forbidden in Root

```bash
❌ *.log                # → logs/
❌ *.tmp                # → /tmp/
❌ *.bak                # → backups/
❌ *.db                 # → .kiro/data/
❌ *.so, *.dll          # Automatically generated binaries
❌ *_REPORT.md          # → docs/ or .kiro/docs/
❌ *_STATUS.md          # → .kiro/docs/reports/
❌ *_SUMMARY.md         # → .kiro/docs/reports/
❌ CHECKPOINT_*.md      # → .kiro/docs/reports/
```

### Forbidden Anywhere

```bash
❌ *_TEMP.md            # Use temporary folders, do not commit
❌ *_OLD.md             # Use Git for history, don't rename files to "OLD"
❌ test_*.txt           # Use the test/ directory for test data
❌ backup_*             # Unorganized backup files
```

---

## ✅ Practical Examples

### Example 1: Adding a New Report

```bash
# ❌ Incorrect
echo "content" > NEW_REPORT.md

# ✅ Correct - Official Report
echo "content" > docs/reports/analysis/feature_analysis.md

# ✅ Correct - Internal Report
echo "content" > .kiro/docs/reports/sessions/session_report.md
```

### Example 2: Adding a New Script

```bash
# ❌ Incorrect
echo "#!/bin/bash" > cleanup.sh

# ✅ Correct
echo "#!/bin/bash" > scripts/maintenance/cleanup_database.sh
chmod +x scripts/maintenance/cleanup_database.sh
```

### Example 3: Adding a Log Entry

```bash
# ❌ Incorrect
echo "error" > error.log

# ✅ Correct
echo "error" > logs/errors/error_$(date +%Y-%m-%d).log
```

---

## 🔍 Validation

### Pre-Commit Check

```bash
# Check for forbidden files in the root
ls -1 *.log *.tmp *.bak *_REPORT.md 2>/dev/null

# Output should be empty.
```

### Monthly Maintenance

```bash
# Monitor directory sizes
du -sh docs .kiro/docs scripts logs

# Identify old reports for archiving
find docs/Archive -mtime +90 -type f
```

---

## 📋 Checklist

### When adding a new file:

- [ ] Is the file in the correct category/directory?
- [ ] is the name clear and descriptive?
- [ ] Does it follow naming standards?
- [ ] Is it added to `.gitignore` if it's a temporary file?

### When creating a new directory:

- [ ] Is the directory absolutely necessary?
- [ ] is the hierarchical location logical?
- [ ] Does it contain a `README.md`?
- [ ] Is the internal structure clear?

---

## 🛠️ Utilities

### Git Hook

Utilize `.githooks/pre-commit-file-check` for automatic validation.

### Maintenance Scripts

```bash
# Monitor directory usage
scripts/maintenance/check_size.sh

# Archive legacy reports
scripts/maintenance/archive_old_reports.sh
```

---

## 📚 References

- **Git Guide:** `.kiro/guides/git-guide.md`
- **Quick Reference:** `.kiro/steering/core/quick-reference.md`
- **Philosophy:** `.kiro/steering/core/philosophy.md`

---

**Prepared by:** Basir Project Agentic Development Team  
**Date:** December 9, 2025  
**Status:** ✅ Active and Approved
