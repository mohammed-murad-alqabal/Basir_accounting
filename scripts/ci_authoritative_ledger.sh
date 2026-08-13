#!/usr/bin/env bash
# Validates the authoritative-ledger database contract against a clean Postgres.
set -euo pipefail

export PAGER=cat
export PGOPTIONS="${PGOPTIONS:--c client_min_messages=warning}"

: "${PGDATABASE:?PGDATABASE must identify the disposable CI database}"

psql -v ON_ERROR_STOP=1 <<'SQL'
CREATE SCHEMA IF NOT EXISTS auth;
CREATE OR REPLACE FUNCTION auth.uid()
RETURNS uuid
LANGUAGE sql
STABLE
AS $$ SELECT '11111111-1111-1111-1111-111111111111'::uuid $$;

CREATE OR REPLACE FUNCTION auth.jwt()
RETURNS jsonb
LANGUAGE sql
STABLE
AS $$
  SELECT COALESCE(
    NULLIF(current_setting('request.jwt.claims', true), '')::jsonb,
    '{"app_metadata":{"role":"accountant"}}'::jsonb
  )
$$;
SQL

while IFS= read -r migration; do
  echo "Applying ${migration}"
  psql -v ON_ERROR_STOP=1 -f "$migration"
done < <(find rust/migrations -maxdepth 1 -type f -name '*.sql' | sort)

psql -v ON_ERROR_STOP=1 -f scripts/test_authoritative_ledger_rpc.sql

health_output="$(psql -q -A -t -v ON_ERROR_STOP=1 -f scripts/ledger_health_check.sql)"
printf '%s\n' "$health_output"
if ! awk -F '|' '$2 != "0" { exit 1 }' <<< "$health_output"; then
  echo 'Authoritative ledger health check detected a violating record' >&2
  exit 1
fi

reconciliation_dir="$(mktemp -d "${TMPDIR:-/tmp}/basir-ledger-reconciliation.XXXXXX")"
trap 'rm -rf "$reconciliation_dir"' EXIT
reconciliation_output="$reconciliation_dir/result.json"

set +e
python3 scripts/reconcile_ledger.py \
  --isar scripts/fixtures/reconciliation_isar.json \
  --postgres scripts/fixtures/reconciliation_postgres.json \
  --output "$reconciliation_output"
reconciliation_status=$?
set -e

if [[ "$reconciliation_status" -ne 1 ]]; then
  echo "Expected reconciliation conflict exit 1, got ${reconciliation_status}" >&2
  exit 1
fi

if [[ ! -s "$reconciliation_output" ]] \
  || ! grep -q '"classification": "conflict"' "$reconciliation_output" \
  || ! grep -q '"source_of_truth": "postgres"' "$reconciliation_output"; then
  echo 'Reconciliation did not produce the expected conflict evidence' >&2
  exit 1
fi

echo 'AUTHORITATIVE_LEDGER_CI_GATE_PASS'
