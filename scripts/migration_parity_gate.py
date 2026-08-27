#!/usr/bin/env python3
"""Fail-closed gate for Isar/Drift migration parity reports.

The program intentionally does not read either database. A separate, reviewed
extractor/migration harness produces summary.json; this gate validates its
machine-readable contract and converts findings into a deterministic CI result.
Exit codes: 0 PASS, 1 parity blocker, 2 invalid input/configuration.
"""
from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Any

ZERO_METRICS = (
    "financial_diff_count",
    "trial_balance_delta_minor",
    "debit_credit_imbalance_count",
    "missing_records",
    "extra_records",
    "duplicate_source_ids",
    "orphan_relations",
    "cross_tenant_violations",
    "inventory_quantity_delta_minor",
    "inventory_value_delta_minor",
    "hash_chain_mismatch",
    "unresolved_commands",
)
REQUIRED_FIELDS = {
    "run_id",
    "application_commit",
    "mapping_version",
    "mode",
    "parity_coverage",
    *ZERO_METRICS,
    "rollback_result",
    "restore_verification",
}


@dataclass(frozen=True)
class GateResult:
    decision: str
    exit_code: int
    run_id: str
    mode: str
    blockers: list[str]
    warnings: list[str]
    checked_metrics: dict[str, int]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--summary", required=True, type=Path)
    parser.add_argument("--out", required=True, type=Path)
    parser.add_argument("--mode", choices=("smoke", "full"), default=None)
    return parser.parse_args()


def load_summary(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot read valid JSON summary: {exc}") from exc
    if not isinstance(value, dict):
        raise ValueError("summary must be a JSON object")
    missing = sorted(REQUIRED_FIELDS - value.keys())
    if missing:
        raise ValueError("missing required fields: " + ", ".join(missing))
    if value["mode"] not in {"smoke", "full"}:
        raise ValueError("mode must be smoke or full")
    if not isinstance(value["parity_coverage"], (int, float)):
        raise ValueError("parity_coverage must be numeric")
    for field in ZERO_METRICS:
        value[field] = int(value[field])
        if value[field] < 0:
            raise ValueError(f"{field} cannot be negative")
    for field in ("run_id", "application_commit", "mapping_version"):
        if not isinstance(value[field], str) or not value[field].strip():
            raise ValueError(f"{field} must be a non-empty string")
    return value


def evaluate(summary: dict[str, Any], requested_mode: str | None) -> GateResult:
    mode = requested_mode or summary["mode"]
    blockers: list[str] = []
    warnings: list[str] = []
    checked = {field: int(summary[field]) for field in ZERO_METRICS}

    if requested_mode and requested_mode != summary["mode"]:
        blockers.append("requested mode does not match summary mode")
    if float(summary["parity_coverage"]) < 1.0:
        blockers.append("parity_coverage is below 1.0")
    for field, value in checked.items():
        if value != 0:
            blockers.append(f"{field}={value}")

    rollback = str(summary["rollback_result"]).upper()
    restore = str(summary["restore_verification"]).upper()
    if mode == "full":
        if rollback != "PASS":
            blockers.append(f"rollback_result={rollback}")
        if restore != "PASS":
            blockers.append(f"restore_verification={restore}")
    else:
        if rollback == "NOT_RUN":
            warnings.append("rollback_result=NOT_RUN; full mode is required before cutover")
        elif rollback != "PASS":
            warnings.append(f"rollback_result={rollback}; full mode is required before cutover")
        if restore == "NOT_RUN":
            warnings.append("restore_verification=NOT_RUN; full mode is required before cutover")
        elif restore != "PASS":
            warnings.append(f"restore_verification={restore}; full mode is required before cutover")

    if blockers:
        return GateResult(
            decision="BLOCKED",
            exit_code=1,
            run_id=summary["run_id"],
            mode=mode,
            blockers=blockers,
            warnings=warnings,
            checked_metrics=checked,
        )
    return GateResult(
        decision="PASS",
        exit_code=0,
        run_id=summary["run_id"],
        mode=mode,
        blockers=[],
        warnings=warnings,
        checked_metrics=checked,
    )


def write_outputs(result: GateResult, out: Path) -> None:
    out.mkdir(parents=True, exist_ok=True)
    payload = asdict(result)
    (out / "parity_gate_result.json").write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    lines = [
        f"# Migration Parity Gate: {result.decision}",
        "",
        f"- Run: `{result.run_id}`",
        f"- Mode: `{result.mode}`",
        f"- Exit code: `{result.exit_code}`",
        "",
        "## Checked zero-tolerance metrics",
        "",
    ]
    lines.extend(f"- `{name}`: `{value}`" for name, value in result.checked_metrics.items())
    lines.extend(["", "## Blockers", ""])
    lines.extend(f"- {item}" for item in result.blockers) or lines.append("- None")
    lines.extend(["", "## Warnings", ""])
    lines.extend(f"- {item}" for item in result.warnings) or lines.append("- None")
    (out / "parity_gate_result.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    args = parse_args()
    try:
        summary = load_summary(args.summary)
        result = evaluate(summary, args.mode)
        write_outputs(result, args.out)
    except ValueError as exc:
        print(f"::error title=Migration Parity Gate::{exc}", file=sys.stderr)
        return 2
    print(json.dumps(asdict(result), ensure_ascii=False, sort_keys=True))
    if result.blockers:
        for blocker in result.blockers:
            print(f"::error title=Migration Parity Blocker::{blocker}")
    return result.exit_code


if __name__ == "__main__":
    raise SystemExit(main())
