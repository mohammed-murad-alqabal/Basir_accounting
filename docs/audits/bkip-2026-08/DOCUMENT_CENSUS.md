# BKIP — Document Census

> **Generated:** 2026-08-13T18:30:07Z
> **Scope:** 1256 tracked documentation candidates. The accompanying CSV is the complete, machine-readable census.

## Method

The census is generated from `git ls-files`, not the working tree, so it represents tracked repository knowledge assets. Classification, status, related module, and authority are initial evidence-based candidates that must be confirmed by the detailed audit; the script deliberately does not infer implementation or test coverage from a document name alone.

## Classification distribution

| Type | Documents |
|---|---:|
| ANALYSIS | 62 |
| ARCHITECTURE | 10 |
| ARCHIVE | 17 |
| DESIGN | 18 |
| GOVERNANCE | 2 |
| GUIDE | 98 |
| MASTER_SPEC | 10 |
| PLAN | 33 |
| REFERENCE | 34 |
| REPORT | 228 |
| REQUIREMENT | 6 |
| SPECIFICATION | 288 |
| STANDARD | 20 |
| STATUS | 169 |
| TASK | 52 |
| UNKNOWN | 209 |

## Census fields

| Field | Meaning |
|---|---|
| ID | Stable audit identifier for this census generation. |
| Path / Title / Location / Size bytes | Repository identity and basic metadata. |
| Type / Status candidate / Authority candidate | Initial classification, never proof of authority or completeness. |
| Last modification / Last commit | Git-derived evolution evidence. |
| Related module / Related specification | Triage links; detailed traceability is in the audit matrix. |
| Related code / tests | Explicitly unresolved until evidence is collected; prevents false linkage. |

## Complete inventory

The complete inventory is maintained in [`DOCUMENT_CENSUS.csv`](appendices/DOCUMENT_CENSUS.csv). It is intentionally separate from this overview so that it remains usable in spreadsheet and automation workflows.
