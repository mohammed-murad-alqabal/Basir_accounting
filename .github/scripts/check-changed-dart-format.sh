#!/usr/bin/env bash
set -euo pipefail

base_sha="${PR_BASE_SHA:-}"
if [[ "${GITHUB_EVENT_NAME:-}" == "push" ]]; then
  base_sha="${PUSH_BEFORE_SHA:-}"
fi
if [[ -z "$base_sha" || "$base_sha" =~ ^0+$ ]]; then
  : "${DEFAULT_BRANCH:?DEFAULT_BRANCH must be set for non-PR dispatches}"
  base_sha="$(git merge-base HEAD "origin/${DEFAULT_BRANCH}")"
fi

mapfile -t dart_files < <(
  git diff --name-only "$base_sha" HEAD -- lib test integration_test \
    | grep -E '\.dart$' \
    | grep -vE '^lib/src/rust/' \
    | grep -vE '(^|/)(frb_generated(\.[^/]+)?|[^/]*_generated|[^/]+\.(g|freezed|mocks|gr))\.dart$' || true
)

if ((${#dart_files[@]} == 0)); then
  echo "No changed handwritten Dart files to format."
  exit 0
fi

tmp_base_file="$(mktemp --suffix=.dart)"
trap 'rm -f "$tmp_base_file"' EXIT

for file in "${dart_files[@]}"; do
  if git cat-file -e "${base_sha}:${file}" 2>/dev/null; then
    git show "${base_sha}:${file}" > "$tmp_base_file"
    if ! dart format --output=none --set-exit-if-changed "$tmp_base_file" >/dev/null 2>&1; then
      echo "::notice::Existing formatter debt in target branch; skipped whole-file check for $file."
      continue
    fi
  fi

  dart format --output=none --set-exit-if-changed "$file"
done
