#!/usr/bin/env python3
"""Produce a non-destructive reconciliation report for the authoritative ledger.

Inputs are JSON exports; this command never connects to, updates, or deletes an
Isar or PostgreSQL record.  PostgreSQL is always the source of truth for a
posted fact.  Exit 0 means no conflicts, 1 means operator review is required,
and 2 means the supplied evidence is invalid.
"""

from __future__ import annotations

import argparse
import json
import sys
from datetime import UTC, datetime
from pathlib import Path
from typing import Any


def load_entries(path: Path) -> list[dict[str, Any]]:
    try:
        raw = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot read {path}: {exc}") from exc
    entries = raw.get("entries", raw) if isinstance(raw, dict) else raw
    if not isinstance(entries, list) or not all(isinstance(item, dict) for item in entries):
        raise ValueError(f"{path} must be a JSON array or an object with an entries array")
    return entries


def pg_key(entry: dict[str, Any]) -> str | None:
    value = entry.get("entry_id") or entry.get("id") or entry.get("authoritativeEntryId")
    return str(value) if value else None


def isar_key(entry: dict[str, Any]) -> str | None:
    value = entry.get("authoritativeEntryId") or entry.get("authoritative_entry_id")
    return str(value) if value else None


def report(isar_entries: list[dict[str, Any]], pg_entries: list[dict[str, Any]]) -> dict[str, Any]:
    pg_by_id = {key: entry for entry in pg_entries if (key := pg_key(entry))}
    isar_by_authority = {key: entry for entry in isar_entries if (key := isar_key(entry))}
    findings: list[dict[str, Any]] = []

    for entry_id, pg_entry in sorted(pg_by_id.items()):
        cached = isar_by_authority.get(entry_id)
        if cached is None:
            findings.append({
                "entry_id": entry_id,
                "classification": "missing_local_cache",
                "source_of_truth": "postgres",
                "action": "refresh_local_cache_from_postgres",
            })
            continue
        pg_hash = pg_entry.get("hash") or pg_entry.get("entry_hash")
        local_hash = cached.get("hash") or cached.get("entryHash")
        if pg_hash and local_hash and pg_hash != local_hash:
            findings.append({
                "entry_id": entry_id,
                "classification": "conflict",
                "source_of_truth": "postgres",
                "action": "quarantine_local_cache_and_refresh_from_postgres",
                "postgres_hash": pg_hash,
                "isar_hash": local_hash,
            })
        else:
            findings.append({
                "entry_id": entry_id,
                "classification": "match",
                "source_of_truth": "postgres",
                "action": "none",
            })

    for cached in isar_entries:
        entry_id = isar_key(cached)
        status = str(cached.get("status", ""))
        if entry_id and entry_id not in pg_by_id:
            findings.append({
                "entry_id": entry_id,
                "classification": "conflict",
                "source_of_truth": "postgres",
                "action": "quarantine_local_cache_and_investigate_missing_postgres_receipt",
            })
        elif not entry_id and status.lower() == "posted":
            findings.append({
                "entry_id": str(cached.get("id", "unknown")),
                "classification": "conflict",
                "source_of_truth": "postgres",
                "action": "quarantine_unreceipted_local_posting",
            })

    counts: dict[str, int] = {}
    for finding in findings:
        classification = finding["classification"]
        counts[classification] = counts.get(classification, 0) + 1

    return {
        "generated_at": datetime.now(UTC).isoformat(),
        "mode": "read_only",
        "authoritative_source": "postgres",
        "summary": counts,
        "findings": findings,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--isar", required=True, type=Path, help="Isar JSON export")
    parser.add_argument("--postgres", required=True, type=Path, help="Postgres JSON export")
    parser.add_argument("--output", required=True, type=Path, help="report JSON path")
    args = parser.parse_args()

    try:
        result = report(load_entries(args.isar), load_entries(args.postgres))
    except ValueError as exc:
        print(f"reconciliation input error: {exc}", file=sys.stderr)
        return 2

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    conflicts = result["summary"].get("conflict", 0)
    return 1 if conflicts else 0


if __name__ == "__main__":
    raise SystemExit(main())
