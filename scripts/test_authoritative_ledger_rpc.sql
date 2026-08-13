\set ON_ERROR_STOP on

SELECT set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated","app_metadata":{"role":"accountant"}}',
  false
);

INSERT INTO accounts (id, code, name_ar, name_en, type) VALUES
  ('00000000-0000-0000-0000-000000000101', '1000', 'النقدية', 'Cash', 'Asset'),
  ('00000000-0000-0000-0000-000000000201', '4000', 'الإيرادات', 'Revenue', 'Revenue');

DO $$
DECLARE
  v_first JSONB;
  v_second JSONB;
  v_conflict_rejected BOOLEAN := false;
  v_unauthorised_rejected BOOLEAN := false;
BEGIN
  SELECT post_ledger_entry(
    '00000000-0000-0000-0000-000000000001',
    'JE-CI-0001',
    '2026-01-10T09:00:00Z',
    '2026-01-10T09:00:00Z',
    'IFRS',
    'CI authoritative posting',
    'ci_test',
    'source-0001',
    '[
      {"account_id":"00000000-0000-0000-0000-000000000101","description":"Debit cash","debit":"100.0000","credit":"0.0000"},
      {"account_id":"00000000-0000-0000-0000-000000000201","description":"Credit revenue","debit":"0.0000","credit":"100.0000"}
    ]'::JSONB
  ) INTO v_first;

  IF (v_first ->> 'idempotent_replay')::BOOLEAN THEN
    RAISE EXCEPTION 'First posting must not be marked as a replay';
  END IF;

  SELECT post_ledger_entry(
    '00000000-0000-0000-0000-000000000001',
    'JE-CI-0001',
    '2026-01-10T09:00:00Z',
    '2026-01-10T09:00:00Z',
    'IFRS',
    'CI authoritative posting',
    'ci_test',
    'source-0001',
    '[
      {"account_id":"00000000-0000-0000-0000-000000000101","description":"Debit cash","debit":"100.0000","credit":"0.0000"},
      {"account_id":"00000000-0000-0000-0000-000000000201","description":"Credit revenue","debit":"0.0000","credit":"100.0000"}
    ]'::JSONB
  ) INTO v_second;

  IF NOT (v_second ->> 'idempotent_replay')::BOOLEAN
     OR v_first ->> 'entry_hash' <> v_second ->> 'entry_hash' THEN
    RAISE EXCEPTION 'Idempotency receipt does not match original receipt';
  END IF;

  IF (SELECT COUNT(*) FROM journal_entries) <> 1
     OR (SELECT COUNT(*) FROM journal_entry_lines) <> 2
     OR (SELECT COUNT(*) FROM audit_log) <> 1 THEN
    RAISE EXCEPTION 'Posting is not exactly-once across ledger tables';
  END IF;

  BEGIN
    PERFORM post_ledger_entry(
      '00000000-0000-0000-0000-000000000001',
      'JE-CI-0001',
      '2026-01-10T09:00:00Z',
      '2026-01-10T09:00:00Z',
      'IFRS',
      'Payload changed after operation id assignment',
      'ci_test',
      'source-0001',
      '[
        {"account_id":"00000000-0000-0000-0000-000000000101","description":"Debit cash","debit":"100.0000","credit":"0.0000"},
        {"account_id":"00000000-0000-0000-0000-000000000201","description":"Credit revenue","debit":"0.0000","credit":"100.0000"}
      ]'::JSONB
    );
  EXCEPTION WHEN SQLSTATE '22000' THEN
    v_conflict_rejected := true;
  END;
  IF NOT v_conflict_rejected THEN
    RAISE EXCEPTION 'Operation identifier payload conflict was accepted';
  END IF;

  PERFORM set_config(
    'request.jwt.claims',
    '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated","app_metadata":{"role":"viewer"}}',
    false
  );
  BEGIN
    PERFORM post_ledger_entry(
      '00000000-0000-0000-0000-000000000002',
      'JE-CI-0002',
      '2026-01-10T09:00:00Z',
      '2026-01-10T09:00:00Z',
      NULL,
      'Unauthorised posting must fail',
      'ci_test',
      'source-0002',
      '[
        {"account_id":"00000000-0000-0000-0000-000000000101","description":"Debit cash","debit":"1.0000","credit":"0.0000"},
        {"account_id":"00000000-0000-0000-0000-000000000201","description":"Credit revenue","debit":"0.0000","credit":"1.0000"}
      ]'::JSONB
    );
  EXCEPTION WHEN SQLSTATE '42501' THEN
    v_unauthorised_rejected := true;
  END;
  IF NOT v_unauthorised_rejected THEN
    RAISE EXCEPTION 'Unauthorised role was allowed to post';
  END IF;
END;
$$;

SELECT 'AUTHORITATIVE_LEDGER_RPC_PASS' AS result;
