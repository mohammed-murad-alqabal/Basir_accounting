#!/usr/bin/env python3
"""Replace literal GitHub PAT-shaped documentation examples with a safe placeholder."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TARGETS = (
    ROOT / 'docs/guides/kiro_reference/mcp-github-server-fix.md',
    ROOT / 'scripts/README.md',
)
PATTERN = re.compile(r'ghp_[A-Za-z0-9]{36}')
REPLACEMENT = '<GITHUB_PERSONAL_ACCESS_TOKEN>'

for target in TARGETS:
    content = target.read_text(encoding='utf-8')
    sanitized, substitutions = PATTERN.subn(REPLACEMENT, content)
    target.write_text(sanitized, encoding='utf-8')
    print(f'{target.relative_to(ROOT)}: replaced {substitutions} PAT-shaped value(s)')
