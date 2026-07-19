# Basir Master Specification - README

**Version:** 2.0 (Sovereign Edition)
**Created:** 2026-01-16
**Location:** `.kiro/specs/active/basir_master_specification/`

---

## Purpose

This directory contains the **authoritative engineering specification** for the Basir Accounting System. It synthesizes insights from:

1. **Legacy Visual Analysis** (99 screenshots in `FORENSIC_ATLAS.md`)
2. **Foundational Manifesto** (`00-03` documents from `basir_accounting`)
3. **Live Codebase Audit** (Flutter/Rust implementation)

---

## Document Index

| File                            | Title                   | Scope                                       |
| ------------------------------- | ----------------------- | ------------------------------------------- |
| `00_SPECIFICATION_MANIFESTO.md` | The Diamond Paradigm    | Philosophy, principles, strategic objective |
| `01_FUNCTIONAL_ARCHITECTURE.md` | Functional Architecture | Engine decomposition, data flow, modules    |
| `02_ACCOUNTING_ENGINE.md`       | Accounting Engine       | GL logic, CoA, sub-ledgers, controls        |
| `03_DATA_SCHEMA.md`             | Data Schema             | Isar/PostgreSQL entity definitions          |
| `04_UI_DESIGN_SYSTEM.md`        | UI/UX Design System     | Glassmorphism tokens, components            |
| `05_SECURITY_GOVERNANCE.md`     | Security & Governance   | Auth, RBAC, audit logging, encryption       |
| `06_COMPLIANCE_ENGINES.md`      | Compliance Engines      | ZATCA, VAT, Zakat, IFRS 18                  |
| `07_INTEGRATION_PROTOCOLS.md`   | Integration Protocols   | APIs, sync, backup, import/export           |
| `08_FORENSIC_ATLAS_INDEX.md`    | Forensic Atlas Index    | Screen-by-screen feature mapping            |

---

## How to Use This Specification

### For Developers:

1. **Before coding a new feature:** Review the relevant module in `01_FUNCTIONAL_ARCHITECTURE.md` and the screen entry in `08_FORENSIC_ATLAS_INDEX.md`.
2. **When implementing entities:** Refer to `03_DATA_SCHEMA.md` for field definitions and constraints.
3. **For UI work:** Adhere to tokens in `04_UI_DESIGN_SYSTEM.md`.

### For QA/Auditors:

1. **Verify feature completeness:** Cross-reference implemented screens against `08_FORENSIC_ATLAS_INDEX.md`.
2. **Validate compliance:** Use `06_COMPLIANCE_ENGINES.md` as the test baseline for ZATCA and Zakat.
3. **Audit security:** Review `05_SECURITY_GOVERNANCE.md` for expected behaviors.

### For Product Managers:

1. **Understand system scope:** Start with `00_SPECIFICATION_MANIFESTO.md`.
2. **Plan roadmap:** Use `08_FORENSIC_ATLAS_INDEX.md` to identify ⚠️ Planned features.

---

## Key Principles

> **Diamond Standard:** Zero lints, strict typing, immutable ledger.

> **Cognitive Design:** Simple for novices, powerful for experts.

> **Forensic Integrity:** Every mutation is cryptographically linked.

---

## Versioning

| Version | Date       | Changes                                                                 |
| ------- | ---------- | ----------------------------------------------------------------------- |
| 1.0     | 2026-01-12 | Initial extraction from legacy visuals                                  |
| 2.0     | 2026-01-16 | Full synthesis with live codebase, added compliance & integration specs |

---

## Maintainers

- Engineering Lead: (Your Team)
- Last Audit: 2026-01-16

---

_This specification is the single source of truth for all Basir engineering decisions._
