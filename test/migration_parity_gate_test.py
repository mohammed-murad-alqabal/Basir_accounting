#!/usr/bin/env python3
import json
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GATE = ROOT / "scripts" / "migration_parity_gate.py"

BASE = {
    "run_id": "unit-test",
    "application_commit": "deadbeef",
    "mapping_version": "v1",
    "mode": "full",
    "parity_coverage": 1.0,
    "financial_diff_count": 0,
    "trial_balance_delta_minor": 0,
    "debit_credit_imbalance_count": 0,
    "missing_records": 0,
    "extra_records": 0,
    "duplicate_source_ids": 0,
    "orphan_relations": 0,
    "cross_tenant_violations": 0,
    "inventory_quantity_delta_minor": 0,
    "inventory_value_delta_minor": 0,
    "hash_chain_mismatch": 0,
    "unresolved_commands": 0,
    "rollback_result": "PASS",
    "restore_verification": "PASS",
}


class MigrationParityGateTest(unittest.TestCase):
    def run_gate(self, summary, mode=None):
        with tempfile.TemporaryDirectory() as temp:
            temp_path = Path(temp)
            summary_path = temp_path / "summary.json"
            output_path = temp_path / "out"
            summary_path.write_text(json.dumps(summary), encoding="utf-8")
            command = ["python3", str(GATE), "--summary", str(summary_path), "--out", str(output_path)]
            if mode:
                command += ["--mode", mode]
            completed = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
            result_path = output_path / "parity_gate_result.json"
            result = json.loads(result_path.read_text(encoding="utf-8")) if result_path.exists() else None
            return completed, result

    def test_full_pass_requires_zero_blockers_and_rollback(self):
        completed, result = self.run_gate(BASE)
        self.assertEqual(completed.returncode, 0)
        self.assertEqual(result["decision"], "PASS")
        self.assertEqual(result["blockers"], [])

    def test_financial_difference_blocks_full_run(self):
        summary = {**BASE, "financial_diff_count": 1, "trial_balance_delta_minor": 25}
        completed, result = self.run_gate(summary)
        self.assertEqual(completed.returncode, 1)
        self.assertEqual(result["decision"], "BLOCKED")
        self.assertIn("financial_diff_count=1", result["blockers"])
        self.assertIn("trial_balance_delta_minor=25", result["blockers"])

    def test_full_run_requires_rollback_and_restore(self):
        summary = {**BASE, "rollback_result": "FAIL", "restore_verification": "NOT_RUN"}
        completed, result = self.run_gate(summary)
        self.assertEqual(completed.returncode, 1)
        self.assertIn("rollback_result=FAIL", result["blockers"])
        self.assertIn("restore_verification=NOT_RUN", result["blockers"])

    def test_incomplete_coverage_blocks(self):
        summary = {**BASE, "parity_coverage": 0.99}
        completed, result = self.run_gate(summary)
        self.assertEqual(completed.returncode, 1)
        self.assertIn("parity_coverage is below 1.0", result["blockers"])

    def test_smoke_allows_rollback_not_run_but_not_financial_diff(self):
        summary = {**BASE, "mode": "smoke", "rollback_result": "NOT_RUN", "restore_verification": "NOT_RUN"}
        completed, result = self.run_gate(summary, mode="smoke")
        self.assertEqual(completed.returncode, 0)
        self.assertEqual(result["decision"], "PASS")
        self.assertEqual(len(result["warnings"]), 2)

    def test_invalid_contract_returns_configuration_error(self):
        summary = {key: value for key, value in BASE.items() if key != "financial_diff_count"}
        completed, _ = self.run_gate(summary)
        self.assertEqual(completed.returncode, 2)


if __name__ == "__main__":
    unittest.main()
