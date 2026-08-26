#!/usr/bin/env python3
"""Parse local PostgreSQL migrations without executing SQL or connecting remotely."""
from pathlib import Path
from pglast import parse_sql

paths = sorted(Path('supabase/migrations').glob('*.sql')) + sorted(Path('supabase/tests').glob('**/*.sql'))
for path in paths:
    statements = parse_sql(path.read_text(encoding='utf-8'))
    print(f'{path.name}: statements={len(statements)} parse=ok')
