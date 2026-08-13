\pset tuples_only on
\pset format unaligned
\pset fieldsep '|'

WITH posted_totals AS (
  SELECT
    e.id,
    COALESCE(SUM(l.debit), 0) AS total_debit,
    COALESCE(SUM(l.credit), 0) AS total_credit
  FROM journal_entries e
  LEFT JOIN journal_entry_lines l ON l.entry_id = e.id
  WHERE e.status = 'Posted'
  GROUP BY e.id
), checks AS (
  SELECT 'unbalanced_posted_entries' AS check_name, COUNT(*)::BIGINT AS violations
  FROM posted_totals
  WHERE total_debit <> total_credit OR total_debit = 0

  UNION ALL

  SELECT 'posted_entries_missing_authoritative_receipt', COUNT(*)::BIGINT
  FROM journal_entries
  WHERE status = 'Posted'
    AND (operation_hash IS NULL OR hash IS NULL OR posted_at IS NULL)

  UNION ALL

  SELECT 'posted_entries_without_post_audit', COUNT(*)::BIGINT
  FROM journal_entries e
  WHERE e.status = 'Posted'
    AND NOT EXISTS (
      SELECT 1 FROM audit_log a
      WHERE a.entity_type = 'journal_entry'
        AND a.entity_id = e.id
        AND a.action = 'POSTED'
        AND a.curr_hash = e.hash
    )

  UNION ALL

  SELECT 'orphan_post_audit_records', COUNT(*)::BIGINT
  FROM audit_log a
  LEFT JOIN journal_entries e
    ON e.id = a.entity_id AND a.entity_type = 'journal_entry'
  WHERE a.entity_type = 'journal_entry'
    AND a.action = 'POSTED'
    AND e.id IS NULL
)
SELECT check_name, violations
FROM checks
ORDER BY check_name;
