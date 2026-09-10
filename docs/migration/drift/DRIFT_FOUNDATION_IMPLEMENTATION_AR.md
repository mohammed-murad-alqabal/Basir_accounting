# Drift Accounting Foundation — Implementation Note

**Branch:** `feat/drift-accounting-foundation-20260827`  
**Base:** `origin/main` at `a18214aef66e06316d3031ec580195b19efc95f5`  
**Pull request:** [#185](https://github.com/mohammed-murad-alqabal/Basir_accounting/pull/185)

## Scope

This change introduces a staged Drift foundation without deleting Isar or changing the production writer. Drift is added as a canonical relational adapter for future snapshot import, parity comparison, shadow reads, and a controlled canary. The existing Isar paths remain available until the migration gates are satisfied.

The schema includes tenant scope, fiscal periods, chart of accounts, source documents, journal entries, journal lines, idempotency keys, posting receipts, outbox events, audit events, and stock movements. Financial amounts use integer minor units and the database adds foreign keys, unique keys, `CHECK` constraints, query indexes, and immutability triggers for posted entries and lines.

`DriftLedgerWriter` is deliberately isolated from the current Isar repository. It validates command identity, line-side exclusivity, balance, fiscal-period status, account activity, and tenant scope, then writes the journal facts, receipt, outbox event, and idempotency completion in one database transaction. Replaying the same idempotency key returns the same receipt without creating a duplicate entry.

`DriftAccountingQueries` provides a read-side Trial Balance grouped by tenant, fiscal period, account, and currency and filters to `POSTED` facts only. Cached balances are not introduced as a second accounting authority.

## Verification evidence

| Check | Result |
|---|---|
| Drift source analysis | PASS — no issues in the new Drift source and tests |
| Dart formatting | PASS |
| Drift/SQLite schema tests | PASS — 4 tests |
| DriftLedgerWriter tests | PASS — 5 tests |
| Trial Balance query test | PASS — 1 test |
| Python parity-gate tests | PASS — 6 tests |
| Migration Parity Contract GitHub workflow | PASS on commit `6e4456014b3059f5d8bae3a9f60cfbb6d1bb3f2c` |
| Git whitespace check | PASS |
| `main` | Untouched by this branch |

The aggregate local Drift test result is **11/11 passed**. The parity contract gate remains intentionally fail-closed. It verifies contract semantics and fixtures; it does not claim that a real Isar snapshot has been imported or that full Isar-to-Drift data parity is complete.

## Dependency compatibility decision

The first proposed `drift_dev` constraint conflicted with the repository's legacy `isar_generator` analyzer constraint. The implementation therefore uses a compatible `^2.13.2` constraint, which resolved to `drift` and `drift_dev` `2.15.0` with the existing Isar generator. This is a transitional compatibility choice, not a request to remove or upgrade Isar in this change.

## Explicit non-goals

This PR does not delete Isar, change `AccountingService` to use Drift, implement a production Isar exporter/importer, perform real parity against sanitized production data, enable dual-write, or authorize a cutover. Those steps require a separate review with accounting, security, data migration, and rollback owners.

## Next required gates

1. Define and version the Isar-to-Drift mapping contract.
2. Implement an Isar snapshot exporter and a Drift importer with checkpoints.
3. Run identity, relation, financial, inventory, and hash-chain parity on a sanitized real dataset.
4. Add replay, idempotency, failure injection, backup restore, and rollback evidence.
5. Introduce Shadow Read only after parity is zero and retain Isar as the sole writer.
6. Proceed to canary only after the Web build and platform release gates are green.
