# Specs Directory - Quick Reference

**Last Updated:** January 14, 2026

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
# 1. Check if <5 active specs
ls -1 .kiro/specs/active | wc -l

# 2. Create structure
mkdir -p .kiro/specs/active/feature-name
cd .kiro/specs/active/feature-name

# 3. Create requirements.md
cat > requirements.md << 'EOF'
# Requirements: Feature Name
...
EOF

# 4. Commit
git add .kiro/specs/active/feature-name
git commit -m "spec: create feature-name requirements"
```

### Complete Spec

```bash
# Move to completed
mv .kiro/specs/active/feature-name .kiro/specs/completed/

# Commit
git add .kiro/specs
git commit -m "spec: complete feature-name"
```

### Archive Spec

```bash
# Move to archived
mv .kiro/specs/completed/feature-name \
   .kiro/specs/archived/$(date +%Y)-completed/

# Commit
git add .kiro/specs
git commit -m "spec: archive feature-name"
```

---

## 📋 Rules Summary

| Rule                  | Limit    | Enforcement     |
| --------------------- | -------- | --------------- |
| **Active Specs**      | ≤5       | Pre-commit hook |
| **Time in Active**    | <8 weeks | Manual review   |
| **Time in Completed** | <30 days | Monthly audit   |
| **Meta-Specs**        | 0        | Policy          |
| **Root-Level Docs**   | 3 only   | Policy          |

---

## 📁 Directory Structure

```
.kiro/specs/
├── README.md           # Index
├── GOVERNANCE.md       # Rules
├── QUICK_REFERENCE.md  # This file
├── active/             # Current work (max 5)
├── planning/           # Future work
├── completed/          # Temp (move within 24h)
└── archived/           # Historical
    ├── 2025-completed/
    ├── 2026-completed/
    └── superseded/
```

---

## ✅ Checklist: Creating a Spec

- [ ] Is this a user-facing feature? (not process improvement)
- [ ] Will this take >3 days?
- [ ] Does this need design decisions?
- [ ] Are there <5 active specs currently?
- [ ] Have I checked planning/ for duplicates?

**If all YES:** Create the spec  
**If any NO:** Use tasks.md or docs/ instead

---

## 🚫 Common Mistakes

| Mistake                           | Why Wrong          | What to Do Instead |
| --------------------------------- | ------------------ | ------------------ |
| Creating spec for bug fix         | Not a feature      | Use tasks.md       |
| Creating spec for cleanup         | Process work       | Use docs/          |
| Leaving completed spec in active/ | Violates lifecycle | Move within 24h    |
| Creating 6th active spec          | Exceeds limit      | Complete one first |
| Creating meta-spec                | Not a feature      | Use docs/          |

---

## 📊 Health Check

Run this weekly:

```bash
echo "Active Specs: $(ls -1 .kiro/specs/active | wc -l)/5"
echo "Total Files: $(find .kiro/specs -name '*.md' | wc -l)"
echo "Size: $(du -sh .kiro/specs | cut -f1)"
echo ""
echo "Completed specs >30 days old:"
find .kiro/specs/completed -type d -mtime +30
```

**Healthy Status:**

- Active: ≤5
- Files: <50
- Size: <500KB
- Old completed: 0

---

## 🔧 Troubleshooting

### "Pre-commit hook blocks my commit"

**Cause:** >5 active specs

**Solution:**

```bash
# Complete or archive a spec first
mv .kiro/specs/active/old-spec .kiro/specs/completed/
git add .kiro/specs
git commit -m "spec: complete old-spec"

# Then try your commit again
```

### "Can't find a spec I need"

**Check archived:**

```bash
find .kiro/specs/archived -name "*keyword*"
```

**Restore if needed:**

```bash
mv .kiro/specs/archived/2025-completed/spec-name \
   .kiro/specs/active/
```

### "Cleanup script failed"

**Restore from backup:**

```bash
BACKUP=$(ls -1dt .kiro/specs/backup-* | head -1)
rm -rf .kiro/specs/active .kiro/specs/completed .kiro/specs/archived
cp -r $BACKUP/* .kiro/specs/
```

---

## 📚 Full Documentation

- **Detailed Analysis:** SPECS_BLOAT_ANALYSIS.md
- **Governance Rules:** GOVERNANCE.md
- **Cleanup Summary:** CLEANUP_SUMMARY.md
- **This Reference:** QUICK_REFERENCE.md

---

## 🎯 Current Recommended Active Specs

1. accounting-standards-framework
2. i18n-localization-system
3. ui-ux-improvements
4. widget-tests-phase3
5. (one more if needed)

---

**Prepared by:** Basir Accounting System Development Agents Team  
**Date:** January 14, 2026
