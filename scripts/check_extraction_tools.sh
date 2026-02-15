#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

VENV_PY="tools/python/.venv/bin/python"

if [[ ! -x "$VENV_PY" ]]; then
  echo "[extract-tools][fail] missing virtualenv python at $VENV_PY"
  echo "[extract-tools][hint] run ./scripts/setup_extraction_tools.sh"
  exit 1
fi

echo "[extract-tools] checking Python modules..."
"$VENV_PY" - <<'PY'
modules = ["fitz", "pdfplumber", "pytesseract", "trafilatura", "bs4", "lxml"]
for mod in modules:
    __import__(mod)
print("[extract-tools] python modules OK")
PY

echo "[extract-tools] checking tesseract binary..."
if ! command -v tesseract >/dev/null 2>&1; then
  echo "[extract-tools][fail] tesseract not found in PATH"
  exit 1
fi

tesseract --version | head -n 1
tesseract --list-langs | head -n 20

"$VENV_PY" - <<'PY'
import pytesseract
print(f"[extract-tools] pytesseract sees tesseract {pytesseract.get_tesseract_version()}")
PY

echo "[extract-tools] all checks passed"
