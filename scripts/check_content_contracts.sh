#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TOPICS=(
  "content/topics/topic00_landscape-briefing"
  "content/topics/topic01_copper"
  "content/topics/topic02_iron-steel"
  "content/topics/topic03_alumina-aluminium"
)

echo "[content] checking topic contracts..."
for t in "${TOPICS[@]}"; do
  test -f "$t/WORKING_NOTE.md" || { echo "[content][fail] missing $t/WORKING_NOTE.md"; exit 1; }
  test -f "$t/WRITEUP.qmd" || { echo "[content][fail] missing $t/WRITEUP.qmd"; exit 1; }
  test -f "$t/WRITEUP.pdf" || { echo "[content][fail] missing $t/WRITEUP.pdf"; exit 1; }
  test -d "$t/subtopics" || { echo "[content][fail] missing $t/subtopics/"; exit 1; }
  test -d "$t/refs" || { echo "[content][fail] missing $t/refs/"; exit 1; }
  test -f "$t/meta/sources.csv" || { echo "[content][fail] missing $t/meta/sources.csv"; exit 1; }
done
echo "[content] topic contracts OK"

echo "[content] checking deprecated filenames..."
if find content/topics -type f \( -name "deep-dive.md" -o -name "working-note.md" -o -name "WRITEUP.md" \) | grep -q .; then
  echo "[content][fail] deprecated filenames found:"
  find content/topics -type f \( -name "deep-dive.md" -o -name "working-note.md" -o -name "WRITEUP.md" \) | sort
  exit 1
fi
echo "[content] deprecated filename check OK"

echo "[content] checking copper T1..T6 sequence..."
actual="$(rg -n '^## T[1-6]\.' content/topics/topic01_copper/WRITEUP.qmd | sed -E 's/.*## (T[1-6])\..*/\1/' | paste -sd ',' -)"
expected="T1,T2,T3,T4,T5,T6"
if [[ "$actual" != "$expected" ]]; then
  echo "[content][fail] unexpected T-sequence in topic01 WRITEUP.qmd"
  echo "[content][fail] expected: $expected"
  echo "[content][fail] actual:   $actual"
  exit 1
fi
if rg -n '^## T4\.[0-9]+' content/topics/topic01_copper/WRITEUP.qmd content/topics/topic01_copper/subtopics/04_T4_research-and-collaboration-landscape.qmd >/dev/null; then
  echo "[content][fail] invalid heading hierarchy found (## T4.x)"
  exit 1
fi
echo "[content] sequence check OK"

echo "[content] checking stale path references..."
if rg -n 'Literature-Review/' content/topics/topic01_copper/WORKING_NOTE.md content/topics/topic01_copper/WRITEUP.qmd content/topics/topic01_copper/subtopics/*.qmd content/topics/topic01_copper/meta/*.csv >/dev/null; then
  echo "[content][fail] stale Literature-Review path references found in active topic01 files"
  rg -n 'Literature-Review/' content/topics/topic01_copper/WORKING_NOTE.md content/topics/topic01_copper/WRITEUP.qmd content/topics/topic01_copper/subtopics/*.qmd content/topics/topic01_copper/meta/*.csv || true
  exit 1
fi
echo "[content] stale path check OK"

echo "[content] scanning placeholders..."
if rg -n 'TBD|CITATION NEEDED|to be added' content/topics/topic01_copper content/topics/topic02_iron-steel content/topics/topic03_alumina-aluminium >/dev/null; then
  echo "[content][fail] placeholders found in active topics"
  rg -n 'TBD|CITATION NEEDED|to be added' content/topics/topic01_copper content/topics/topic02_iron-steel content/topics/topic03_alumina-aluminium || true
  exit 1
fi
echo "[content] placeholder scan OK"

echo "[content] checking sources.csv schema and path validity..."
python3 - <<'PY'
import csv
from pathlib import Path

root = Path(".")
expected = ["source_key","title","year","type","path","status","subtopic","notes"]
errors = []

for p in sorted(root.glob("content/topics/*/meta/sources.csv")):
    with p.open(newline="", encoding="utf-8") as f:
        r = csv.reader(f)
        try:
            header = next(r)
        except StopIteration:
            errors.append((str(p), "EMPTY_FILE"))
            continue
        if header != expected:
            errors.append((str(p), f"BAD_HEADER:{header}"))
        for i, row in enumerate(r, start=2):
            if len(row) < 8:
                errors.append((str(p), f"ROW_{i}_SHORT"))
                continue
            rel = row[4].strip()
            if rel and not rel.startswith(("http://", "https://")):
                target = root / rel
                if not target.exists():
                    errors.append((str(p), f"ROW_{i}_MISSING_PATH:{rel}"))

if errors:
    print("[content][fail] sources.csv validation failed")
    for e in errors:
        print("|".join(e))
    raise SystemExit(1)

print("[content] sources.csv validation OK")
PY

echo "[content] checking topic meta path/file fields..."
python3 - <<'PY'
import csv
from pathlib import Path

root = Path(".").resolve()
errors = []

for p in sorted((root / "content/topics").glob("*/meta/*.csv")):
    with p.open(newline="", encoding="utf-8") as f:
        r = csv.DictReader(f)
        if not r.fieldnames:
            continue
        cols = [c for c in r.fieldnames if c and ("path" in c.lower() or "file" in c.lower())]
        for i, row in enumerate(r, start=2):
            for c in cols:
                val = (row.get(c) or "").strip()
                if not val or val.startswith(("http://", "https://")):
                    continue
                if "/" not in val and "\\" not in val:
                    continue
                target = Path(val) if val.startswith("/") else (root / val)
                if not target.exists():
                    errors.append((str(p.relative_to(root)), str(i), c, val))

if errors:
    print("[content][fail] broken path/file references in topic meta csv files")
    for e in errors:
        print("|".join(e))
    raise SystemExit(1)

print("[content] topic meta path/file references OK")
PY

echo "[content] checking .DS_Store hygiene..."
if find content site -name ".DS_Store" | grep -q .; then
  echo "[content][fail] .DS_Store files found:"
  find content site -name ".DS_Store" | sort
  exit 1
fi
echo "[content] .DS_Store hygiene OK"

echo "[content] all checks passed"
