#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

SCOPE_FILE="${FAST_SCOPE_FILE:-/tmp/crm-fast-scope.json}"
ROUTES_FILE="${FAST_ROUTES_FILE:-/tmp/crm-fast-routes.txt}"

echo "[fast] running content contracts..."
./scripts/check_content_contracts.sh

echo "[fast] detecting changed scope..."
./scripts/detect_changed_scope.sh "$SCOPE_FILE"

MODE="$(python3 - "$SCOPE_FILE" <<'PY'
import json,sys
data=json.load(open(sys.argv[1], encoding="utf-8"))
print(data.get("mode",""))
PY
)"
REASON="$(python3 - "$SCOPE_FILE" <<'PY'
import json,sys
data=json.load(open(sys.argv[1], encoding="utf-8"))
print(data.get("reason",""))
PY
)"

if [[ "$MODE" == "full" ]]; then
  echo "[fast] scope fallback to full checks"
  if [[ -n "$REASON" ]]; then
    echo "[fast] reason: $REASON"
  fi
  ./scripts/check_site_integrity.sh
  if [[ "${RUN_UI_SMOKE:-0}" == "1" ]]; then
    echo "[fast] running UI smoke (strict mode)..."
    ./scripts/check_ui_smoke.sh --require-tools
  else
    echo "[fast] running UI smoke (best-effort mode, set RUN_UI_SMOKE=1 for strict)..."
    ./scripts/check_ui_smoke.sh
  fi
  echo "[fast] all checks passed (full fallback)"
  exit 0
fi

if [[ "$MODE" != "targeted" ]]; then
  echo "[fast][fail] unknown scope mode: $MODE"
  exit 1
fi

TMP_RENDER_LIST="$(mktemp)"
cleanup() {
  rm -f "$TMP_RENDER_LIST"
}
trap cleanup EXIT

python3 - "$SCOPE_FILE" > "$TMP_RENDER_LIST" <<'PY'
import json,sys
for item in json.load(open(sys.argv[1], encoding="utf-8")).get("render_qmd", []):
    print(item)
PY

RENDER_QMD=()
while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  RENDER_QMD+=("$line")
done < "$TMP_RENDER_LIST"

if [[ "${#RENDER_QMD[@]}" -eq 0 ]]; then
  echo "[fast][fail] no render targets in targeted mode"
  exit 1
fi

echo "[fast] targeted render..."
for rel in "${RENDER_QMD[@]}"; do
  qmd_path="site/${rel}"
  if [[ ! -f "$qmd_path" ]]; then
    echo "[fast][fail] render target missing: $qmd_path"
    exit 1
  fi
  echo "[fast] render -> $qmd_path"
  quarto render "$qmd_path"
done
./scripts/sync_writeup_pdfs.sh
echo "[fast] targeted render OK"

echo "[fast] targeted site integrity checks..."
./scripts/check_site_fast.sh "$SCOPE_FILE"

python3 - "$SCOPE_FILE" "$ROUTES_FILE" <<'PY'
import json
import pathlib
import sys

scope = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
routes = [r.strip() for r in scope.get("ui_routes", []) if r.strip()]
path = pathlib.Path(sys.argv[2])
path.parent.mkdir(parents=True, exist_ok=True)
path.write_text("\n".join(routes) + ("\n" if routes else ""), encoding="utf-8")
print(f"[fast] wrote routes file: {path}")
PY

if [[ "${RUN_UI_SMOKE:-0}" == "1" ]]; then
  echo "[fast] running targeted UI smoke (strict mode)..."
  UI_SMOKE_ROUTES_FILE="$ROUTES_FILE" ./scripts/check_ui_smoke.sh --require-tools
else
  echo "[fast] running targeted UI smoke (best-effort mode, set RUN_UI_SMOKE=1 for strict)..."
  UI_SMOKE_ROUTES_FILE="$ROUTES_FILE" ./scripts/check_ui_smoke.sh
fi

echo "[fast] all checks passed"
