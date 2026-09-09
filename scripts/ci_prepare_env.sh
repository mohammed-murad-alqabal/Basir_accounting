#!/usr/bin/env bash
# Prepares a non-secret environment asset for clean CI checkouts.
# Real deployment secrets are supplied by the target environment, never by this script.
set -euo pipefail

if [[ -f .env ]]; then
  exit 0
fi

if [[ ! -f .env.example ]]; then
  echo "Missing tracked .env.example template required for CI asset preparation." >&2
  exit 1
fi

cp .env.example .env
echo "Prepared CI-only .env from the tracked non-secret template."
