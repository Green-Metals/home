#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

SCOPE_FILE="${1:-${FAST_SCOPE_FILE:-/tmp/crm-fast-scope.json}}"

if [[ ! -f "$SCOPE_FILE" ]]; then
  echo "[site-fast][fail] scope file not found: $SCOPE_FILE"
  exit 1
fi

MODE="$(python3 - "$SCOPE_FILE" <<'PY'
import json,sys
data=json.load(open(sys.argv[1], encoding="utf-8"))
print(data.get("mode",""))
PY
)"

if [[ "$MODE" == "full" ]]; then
  echo "[site-fast] mode=full; delegating to strict site integrity checks"
  ./scripts/check_site_integrity.sh
  exit 0
fi

if [[ "$MODE" != "targeted" ]]; then
  echo "[site-fast][fail] unknown mode in scope file: $MODE"
  exit 1
fi

TOPICS=(
  "topic00_landscape-briefing"
  "topic01_copper"
  "topic02_iron-steel"
  "topic03_alumina-aluminium"
)

echo "[site-fast] checking mount links..."
for m in references "${TOPICS[@]}"; do
  if [[ ! -L "site/$m" ]]; then
    echo "[site-fast][fail] site/$m is not a symlink mount"
    exit 1
  fi
  if [[ ! -e "site/$m" ]]; then
    echo "[site-fast][fail] site/$m is a broken symlink"
    exit 1
  fi
done
echo "[site-fast] mount links OK"

echo "[site-fast] checking targeted output presence..."
python3 - "$SCOPE_FILE" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(".").resolve()
scope = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
errors = []

for route in scope.get("ui_routes", []):
    rel = route.lstrip("/")
    if not rel:
        continue
    target = root / "site" / "_site" / rel
    if not target.exists():
        errors.append(f"missing route output: site/_site/{rel}")

for topic in scope.get("changed_topics", []):
    html = root / "site" / "_site" / topic / "WRITEUP.html"
    pdf = root / "site" / "_site" / topic / "WRITEUP.pdf"
    synced = root / "content" / "topics" / topic / "WRITEUP.pdf"
    if not html.exists():
        errors.append(f"missing writeup html: site/_site/{topic}/WRITEUP.html")
    if not pdf.exists():
        errors.append(f"missing writeup pdf: site/_site/{topic}/WRITEUP.pdf")
    if not synced.exists():
        errors.append(f"missing synced pdf: content/topics/{topic}/WRITEUP.pdf")

if errors:
    print("[site-fast][fail] targeted output checks failed")
    for e in errors:
        print(e)
    raise SystemExit(1)

print("[site-fast] targeted output checks OK")
PY

echo "[site-fast] checking menu drawer script guardrails..."
if rg -n '\\.qmd' site/includes/nav-drawer.js | grep -q .; then
  if ! rg -n 'skip source-only qmd|Include only rendered pages' site/includes/nav-drawer.js >/dev/null; then
    echo "[site-fast][fail] nav-drawer.js references .qmd without source-skip guard"
    exit 1
  fi
fi
echo "[site-fast] menu drawer guardrail OK"

echo "[site-fast] all checks passed"

