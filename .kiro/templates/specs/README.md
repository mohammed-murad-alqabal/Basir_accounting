# Specs Templates

**Project:** Basser MVP  
**Date:** December 8, 2025  
**Status:** ✅ Active

---

## Available Templates

### 1. feature_spec_template.md

Complete feature specification with EARS syntax requirements.

**Usage:**

```bash
cp feature_spec_template.md .kiro/specs/[feature]-spec.md
# Fill in the details
```

### 2. design_template.md

Technical design document with architecture diagrams (Mermaid.js MANDATORY).

**Usage:**

```bash
cp design_template.md .kiro/specs/[feature]-design.md
# Add diagrams and design details
```

### 3. task_breakdown_template.md

Detailed task breakdown with time estimates and progress tracking.

**Usage:**

```bash
cp task_breakdown_template.md .kiro/specs/[feature]-tasks.md
# Break down into actionable tasks
```

---

## Workflow

1. **Spec** → Define requirements using EARS syntax
2. **Design** → Create architecture with Mermaid diagrams
3. **Tasks** → Break down into implementable tasks
4. **Execute** → Implement following the plan

---

## EARS Syntax Reference

- **UR:** Ubiquitous Requirements (always apply)
- **ED:** Event-Driven (WHEN...SHALL)
- **SD:** State-Driven (WHILE...SHALL)
- **OF:** Optional Features (WHERE...SHALL)
- **UB:** Unwanted Behaviors (IF...THEN...SHALL)

---

**Prepared by:** Basser Project Development Agents Team
