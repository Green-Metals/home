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
  topic_id="$(basename "$t" | cut -d'_' -f1)"
  working_note="$t/${topic_id}_agent_working_note.md"
  writeup_qmd="$t/${topic_id}_agent_writeup.qmd"
  writeup_html="$t/${topic_id}_agent_writeup.html"
  writeup_pdf="$t/${topic_id}_agent_writeup.pdf"
  legacy_writeup_html="$t/WRITEUP.html"
  legacy_writeup_pdf="$t/WRITEUP.pdf"
  test -f "$working_note" || { echo "[content][fail] missing $working_note"; exit 1; }
  test -f "$writeup_qmd" || { echo "[content][fail] missing $writeup_qmd"; exit 1; }
  test -f "$writeup_html" || { echo "[content][fail] missing $writeup_html"; exit 1; }
  test -f "$writeup_pdf" || { echo "[content][fail] missing $writeup_pdf"; exit 1; }
  test ! -f "$legacy_writeup_html" || { echo "[content][fail] deprecated HTML filename present: $legacy_writeup_html"; exit 1; }
  test ! -f "$legacy_writeup_pdf" || { echo "[content][fail] deprecated PDF filename present: $legacy_writeup_pdf"; exit 1; }
  test -d "$t/subtopics" || { echo "[content][fail] missing $t/subtopics/"; exit 1; }
  test -d "$t/refs-sources" || { echo "[content][fail] missing $t/refs-sources/"; exit 1; }
  test -f "$t/meta/sources.csv" || { echo "[content][fail] missing $t/meta/sources.csv"; exit 1; }
done
echo "[content] topic contracts OK"

echo "[content] checking deprecated filenames..."
if find content/topics -type f \( -name "deep-dive.md" -o -name "working-note.md" -o -name "WRITEUP.md" \) | grep -q .; then
  echo "[content][fail] deprecated filenames found:"
  find content/topics -type f \( -name "deep-dive.md" -o -name "working-note.md" -o -name "WRITEUP.md" \) | sort
  exit 1
fi
if find content site ops -type f \( -name "WORKING_NOTE.md" -o -name "WORKFLOW_QUICKSTART.md" -o -name "SESSION_HANDOFF.md" \) | grep -q .; then
  echo "[content][fail] deprecated non-agent-specific markdown filenames found"
  find content site ops -type f \( -name "WORKING_NOTE.md" -o -name "WORKFLOW_QUICKSTART.md" -o -name "SESSION_HANDOFF.md" \) | sort
  exit 1
fi
legacy_topic_note_name="WORKING_NOTE"'.'"md"
if find content/topics -type f -name "$legacy_topic_note_name" | grep -q .; then
  echo "[content][fail] deprecated topic working-note filename found ($legacy_topic_note_name)"
  find content/topics -type f -name "$legacy_topic_note_name" | sort
  exit 1
fi
legacy_topic_writeup_name="WRITEUP"'.'"qmd"
if find content/topics -type f -name "$legacy_topic_writeup_name" | grep -q .; then
  echo "[content][fail] deprecated topic writeup filename found ($legacy_topic_writeup_name)"
  find content/topics -type f -name "$legacy_topic_writeup_name" | sort
  exit 1
fi
legacy_topic_writeup_html_name="WRITEUP"'.'"html"
if find content/topics -type f -name "$legacy_topic_writeup_html_name" | grep -q .; then
  echo "[content][fail] deprecated topic writeup html filename found ($legacy_topic_writeup_html_name)"
  find content/topics -type f -name "$legacy_topic_writeup_html_name" | sort
  exit 1
fi
echo "[content] deprecated filename check OK"

echo "[content] checking topical T1..T6 sequence..."
TOPICAL_WRITEUPS=(
  "content/topics/topic01_copper/topic01_agent_writeup.qmd"
  "content/topics/topic02_iron-steel/topic02_agent_writeup.qmd"
  "content/topics/topic03_alumina-aluminium/topic03_agent_writeup.qmd"
)
expected="T1,T2,T3,T4,T5,T6"
for writeup in "${TOPICAL_WRITEUPS[@]}"; do
  actual="$(rg -n '^## T[1-6]\.' "$writeup" | sed -E 's/.*## (T[1-6])\..*/\1/' | paste -sd ',' -)"
  if [[ "$actual" != "$expected" ]]; then
    echo "[content][fail] unexpected T-sequence in $writeup"
    echo "[content][fail] expected: $expected"
    echo "[content][fail] actual:   $actual"
    exit 1
  fi
done
t4_modules=()
while IFS= read -r f; do
  t4_modules+=("$f")
done < <(find content/topics/topic01_copper/subtopics content/topics/topic02_iron-steel/subtopics content/topics/topic03_alumina-aluminium/subtopics -maxdepth 1 -type f -name '04_*.qmd' | sort)
if rg -n '^## T4\.[0-9]+' "${TOPICAL_WRITEUPS[@]}" "${t4_modules[@]}" >/dev/null; then
  echo "[content][fail] invalid heading hierarchy found (## T4.x)"
  exit 1
fi
echo "[content] sequence check OK"

echo "[content] checking stale path references..."
if rg -n 'Literature-Review/' content/topics \
  -g 'topic*/topic*_agent_working_note.md' \
  -g 'topic*/topic*_agent_writeup.qmd' \
  -g 'topic*/subtopics/*.qmd' \
  -g 'topic*/meta/*.csv' \
  -g 'topic*/meta/*.md' >/dev/null; then
  echo "[content][fail] stale Literature-Review path references found in active topic files"
  rg -n 'Literature-Review/' content/topics \
    -g 'topic*/topic*_agent_working_note.md' \
    -g 'topic*/topic*_agent_writeup.qmd' \
    -g 'topic*/subtopics/*.qmd' \
    -g 'topic*/meta/*.csv' \
    -g 'topic*/meta/*.md' || true
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
                    # Refs corpus can be intentionally untracked (private source corpus policy).
                    if rel.startswith("content/topics/") and "/refs-sources/" in rel:
                        continue
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
                    # Refs corpus can be intentionally untracked (private source corpus policy).
                    if val.startswith("content/topics/") and "/refs-sources/" in val:
                        continue
                    errors.append((str(p.relative_to(root)), str(i), c, val))

if errors:
    print("[content][fail] broken path/file references in topic meta csv files")
    for e in errors:
        print("|".join(e))
    raise SystemExit(1)

print("[content] topic meta path/file references OK")
PY

echo "[content] checking refs-sources and bibliography sync..."
python3 scripts/sync_sources_and_bib.py --check

echo "[content] checking multi-agent tracking contracts..."
python3 scripts/check_tracking_contracts.py --check

echo "[content] checking .DS_Store hygiene..."
if find content site -name ".DS_Store" | grep -q .; then
  echo "[content][warn] .DS_Store files found (ignored):"
  find content site -name ".DS_Store" | sort
else
  echo "[content] .DS_Store hygiene OK"
fi

echo "[content] all checks passed"
