-- BASIR authoritative ledger boundary.
-- Postgres owns posted facts, balances and the audit chain. Flutter may invoke
-- only post_ledger_entry and must never receive a database credential.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

ALTER TABLE journal_entries
    ADD COLUMN IF NOT EXISTS source_document TEXT,
    ADD COLUMN IF NOT EXISTS source_id TEXT,
    ADD COLUMN IF NOT EXISTS previous_hash TEXT,
    ADD COLUMN IF NOT EXISTS operation_hash TEXT,
    ADD COLUMN IF NOT EXISTS posted_at TIMESTAMP;

CREATE UNIQUE INDEX IF NOT EXISTS journal_entries_operation_hash_key
    ON journal_entries (operation_hash)
    WHERE operation_hash IS NOT NULL;

CREATE OR REPLACE FUNCTION post_ledger_entry(
    p_entry_id UUID,
    p_entry_number TEXT,
    p_transaction_date TIMESTAMPTZ,
    p_effective_date TIMESTAMPTZ,
    p_standard_reference TEXT,
    p_description TEXT,
    p_source_document TEXT,
    p_source_id TEXT,
    p_lines JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
    v_claims JSONB;
    v_actor TEXT;
    v_role TEXT;
    v_app_role TEXT;
    v_operation_hash TEXT;
    v_previous_hash TEXT;
    v_entry_hash TEXT;
    v_existing RECORD;
    v_line RECORD;
    v_debit NUMERIC(20, 4) := 0;
    v_credit NUMERIC(20, 4) := 0;
    v_line_count INTEGER := 0;
BEGIN
    -- Supabase exposes these GUCs from the verified JWT. The app role is
    -- supplied by the JWT app_metadata claim and must be set by trusted admin
    -- code, never by the client request body.
    v_claims := COALESCE(
      NULLIF(current_setting('request.jwt.claims', true), '')::JSONB,
      '{}'::JSONB
    );
    v_actor := COALESCE(
      NULLIF(current_setting('request.jwt.claim.sub', true), ''),
      NULLIF(v_claims ->> 'sub', '')
    );
    v_role := COALESCE(
      NULLIF(current_setting('request.jwt.claim.role', true), ''),
      NULLIF(v_claims ->> 'role', '')
    );
    v_app_role := COALESCE(
      NULLIF(current_setting('request.jwt.claim.app_role', true), ''),
      NULLIF(v_claims #>> '{app_metadata,role}', '')
    );
    IF v_actor IS NULL OR v_role <> 'authenticated'
       OR v_app_role NOT IN ('owner', 'admin', 'accountant') THEN
        RAISE EXCEPTION 'LEDGER_POST_NOT_AUTHORIZED'
            USING ERRCODE = '42501';
    END IF;

    IF p_entry_number IS NULL OR btrim(p_entry_number) = ''
       OR p_description IS NULL OR btrim(p_description) = ''
       OR p_lines IS NULL OR jsonb_typeof(p_lines) <> 'array' THEN
        RAISE EXCEPTION 'LEDGER_POST_INVALID_PAYLOAD'
            USING ERRCODE = '22023';
    END IF;

    v_operation_hash := encode(
      digest(
        jsonb_build_object(
          'entry_id', p_entry_id,
          'entry_number', p_entry_number,
          'transaction_date', p_transaction_date,
          'effective_date', p_effective_date,
          'standard_reference', p_standard_reference,
          'description', p_description,
          'source_document', p_source_document,
          'source_id', p_source_id,
          'lines', p_lines
        )::TEXT,
        'sha256'
      ),
      'hex'
    );

    SELECT id, hash, previous_hash, posted_at, operation_hash
      INTO v_existing
      FROM journal_entries
     WHERE id = p_entry_id;
    IF FOUND THEN
        IF v_existing.operation_hash IS DISTINCT FROM v_operation_hash THEN
            RAISE EXCEPTION 'LEDGER_OPERATION_ID_PAYLOAD_CONFLICT'
                USING ERRCODE = '22000';
        END IF;
        RETURN jsonb_build_object(
          'entry_id', v_existing.id::TEXT,
          'entry_hash', v_existing.hash,
          'previous_hash', v_existing.previous_hash,
          'posted_at', v_existing.posted_at,
          'idempotent_replay', true
        );
    END IF;

    FOR v_line IN
      SELECT * FROM jsonb_to_recordset(p_lines) AS x(
        account_id UUID,
        description TEXT,
        debit NUMERIC(20, 4),
        credit NUMERIC(20, 4),
        source_document_ref TEXT,
        original_currency TEXT,
        exchange_rate NUMERIC(20, 10),
        original_amount NUMERIC(20, 4)
      )
    LOOP
      v_line_count := v_line_count + 1;
      IF v_line.account_id IS NULL OR v_line.debit IS NULL OR v_line.credit IS NULL
         OR v_line.debit < 0 OR v_line.credit < 0
         OR (v_line.debit = 0 AND v_line.credit = 0) THEN
          RAISE EXCEPTION 'UNBALANCED_JOURNAL_ENTRY'
              USING ERRCODE = '22023';
      END IF;
      IF NOT EXISTS (SELECT 1 FROM accounts WHERE id = v_line.account_id) THEN
          RAISE EXCEPTION 'AUTHORITATIVE_ACCOUNT_NOT_FOUND'
              USING ERRCODE = '23503';
      END IF;
      v_debit := v_debit + v_line.debit;
      v_credit := v_credit + v_line.credit;
    END LOOP;

    IF v_line_count < 2 OR v_debit <> v_credit OR v_debit = 0 THEN
      RAISE EXCEPTION 'UNBALANCED_JOURNAL_ENTRY'
          USING ERRCODE = '22023';
    END IF;

    IF EXISTS (
      SELECT 1 FROM financial_periods
       WHERE p_effective_date::DATE BETWEEN start_date AND end_date
         AND status IN ('Locked', 'Closed')
    ) THEN
      RAISE EXCEPTION 'FINANCIAL_PERIOD_LOCKED_OR_CLOSED'
          USING ERRCODE = '55000';
    END IF;

    -- Serialises audit-chain construction across concurrent clients without
    -- imposing a global table lock on unrelated reads.
    PERFORM pg_advisory_xact_lock(hashtext('basir-authoritative-ledger-chain'));
    SELECT curr_hash INTO v_previous_hash
      FROM audit_log
     ORDER BY timestamp DESC, id DESC
     LIMIT 1;
    v_entry_hash := encode(
      digest(
        coalesce(v_previous_hash, '') || ':' || v_operation_hash || ':' || v_actor,
        'sha256'
      ),
      'hex'
    );

    INSERT INTO journal_entries (
      id, entry_number, entry_type, status, transaction_date, effective_date,
      recording_date, standard_reference, description, hash, previous_hash,
      operation_hash, source_document, source_id, posted_at
    ) VALUES (
      p_entry_id, p_entry_number, coalesce(p_source_document, 'manual'), 'Posted',
      p_transaction_date::DATE, p_effective_date::DATE, now(),
      p_standard_reference, p_description, v_entry_hash, v_previous_hash,
      v_operation_hash, p_source_document, p_source_id, now()
    );

    FOR v_line IN
      SELECT * FROM jsonb_to_recordset(p_lines) AS x(
        account_id UUID,
        description TEXT,
        debit NUMERIC(20, 4),
        credit NUMERIC(20, 4),
        source_document_ref TEXT,
        original_currency TEXT,
        exchange_rate NUMERIC(20, 10),
        original_amount NUMERIC(20, 4)
      )
    LOOP
      INSERT INTO journal_entry_lines (
        id, entry_id, account_id, description, debit, credit,
        original_currency, exchange_rate, original_amount
      ) VALUES (
        gen_random_uuid(), p_entry_id, v_line.account_id,
        coalesce(v_line.description, p_description), v_line.debit, v_line.credit,
        v_line.original_currency, v_line.exchange_rate, v_line.original_amount
      );
    END LOOP;

    INSERT INTO audit_log (
      id, timestamp, user_id, entity_type, entity_id, action, payload,
      prev_hash, curr_hash
    ) VALUES (
      gen_random_uuid(), now(), v_actor, 'journal_entry', p_entry_id, 'POSTED',
      jsonb_build_object(
        'operation_hash', v_operation_hash,
        'entry_number', p_entry_number,
        'source_document', p_source_document,
        'source_id', p_source_id,
        'total_debit', v_debit,
        'total_credit', v_credit
      ),
      v_previous_hash, v_entry_hash
    );

    RETURN jsonb_build_object(
      'entry_id', p_entry_id::TEXT,
      'entry_hash', v_entry_hash,
      'previous_hash', v_previous_hash,
      'posted_at', now(),
      'idempotent_replay', false
    );
END;
$$;

REVOKE ALL ON FUNCTION post_ledger_entry(UUID, TEXT, TIMESTAMPTZ, TIMESTAMPTZ, TEXT, TEXT, TEXT, TEXT, JSONB) FROM PUBLIC;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    GRANT EXECUTE ON FUNCTION post_ledger_entry(UUID, TEXT, TIMESTAMPTZ, TIMESTAMPTZ, TEXT, TEXT, TEXT, TEXT, JSONB) TO authenticated;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
    REVOKE INSERT, UPDATE, DELETE ON journal_entries, journal_entry_lines, audit_log FROM anon;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    REVOKE INSERT, UPDATE, DELETE ON journal_entries, journal_entry_lines, audit_log FROM authenticated;
  END IF;
END;
$$;
