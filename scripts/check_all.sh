#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "[checks] running content contracts..."
./scripts/check_content_contracts.sh

echo "[checks] running site integrity..."
./scripts/check_site_integrity.sh

if [[ "${RUN_UI_SMOKE:-0}" == "1" ]]; then
  echo "[checks] running UI smoke (strict mode)..."
  ./scripts/check_ui_smoke.sh --require-tools
else
  echo "[checks] running UI smoke (best-effort mode, set RUN_UI_SMOKE=1 for strict)..."
  ./scripts/check_ui_smoke.sh
fi

echo "[checks] all checks passed"
