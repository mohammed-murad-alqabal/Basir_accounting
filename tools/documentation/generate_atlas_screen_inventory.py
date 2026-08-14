#!/usr/bin/env python3
"""Generate the governed legacy Atlas reconciliation inventory."""
from __future__ import annotations

import csv
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / '.kiro/specs/active/basir_master_specification/08_FORENSIC_ATLAS_INDEX.md'
TARGET = ROOT / 'docs/02-domain/atlas_screen_legacy_inventory.csv'

ROW = re.compile(
    r'^\| \*\*(?P<id>\d{3})\*\* \| (?P<name>.*?) \| (?P<features>.*?) \| (?P<status>.*?) \|$'
)
MODULE = re.compile(r'^## (?P<module>Module \d+:.*?)$')

records: dict[str, list[dict[str, str]]] = defaultdict(list)
module = 'UNASSIGNED'
for line in SOURCE.read_text(encoding='utf-8').splitlines():
    if module_match := MODULE.match(line):
        module = module_match.group('module')
        continue
    if row_match := ROW.match(line):
        records[row_match.group('id')].append(
            {
                'module': module,
                'name': row_match.group('name'),
                'legacy_features': row_match.group('features'),
                'legacy_status': row_match.group('status'),
            }
        )

with TARGET.open('w', encoding='utf-8', newline='') as target:
    writer = csv.DictWriter(
        target,
        fieldnames=[
            'feature_register_id',
            'atlas_screen_id',
            'source_occurrences',
            'module',
            'legacy_name',
            'legacy_features',
            'legacy_status_claim',
            'reconciliation_state',
            'evidence_state',
        ],
    )
    writer.writeheader()
    for number in range(1, 100):
        screen_id = f'{number:03d}'
        entries = records.get(screen_id, [])
        common = {
            'feature_register_id': f'FR-ATLAS-{screen_id}',
            'atlas_screen_id': screen_id,
            'evidence_state': 'UNVERIFIED',
        }
        if not entries:
            writer.writerow(
                common
                | {
                    'source_occurrences': '0',
                    'module': '',
                    'legacy_name': '',
                    'legacy_features': '',
                    'legacy_status_claim': '',
                    'reconciliation_state': 'MISSING_IN_ATLAS',
                }
            )
        elif len(entries) > 1:
            writer.writerow(
                common
                | {
                    'source_occurrences': str(len(entries)),
                    'module': ' || '.join(entry['module'] for entry in entries),
                    'legacy_name': ' || '.join(entry['name'] for entry in entries),
                    'legacy_features': ' || '.join(entry['legacy_features'] for entry in entries),
                    'legacy_status_claim': ' || '.join(entry['legacy_status'] for entry in entries),
                    'reconciliation_state': 'DUPLICATE_LEGACY_REFERENCE',
                }
            )
        else:
            entry = entries[0]
            writer.writerow(
                common
                | {
                    'source_occurrences': '1',
                    'module': entry['module'],
                    'legacy_name': entry['name'],
                    'legacy_features': entry['legacy_features'],
                    'legacy_status_claim': entry['legacy_status'],
                    'reconciliation_state': 'EXTRACTED_FROM_ATLAS',
                }
            )

print(f'Wrote {TARGET.relative_to(ROOT)}')
print(f'Parsed source rows: {sum(len(entries) for entries in records.values())}')
print(f'Unique source IDs: {len(records)}')
