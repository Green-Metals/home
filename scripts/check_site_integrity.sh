#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TOPICS=(
  "topic00_landscape-briefing"
  "topic01_copper"
  "topic02_iron-steel"
  "topic03_alumina-aluminium"
)

echo "[site] rendering site..."
SYNC_WRITEUP_STRICT=1 quarto render site/src
echo "[site] render OK"

if [[ -d "site/_site" ]]; then
  echo "[site][fail] deprecated output layer exists: site/_site (expected render output directly under site/)"
  exit 1
fi

echo "[site] checking mount links..."
for m in references "${TOPICS[@]}"; do
  if [[ ! -L "site/src/$m" ]]; then
    echo "[site][fail] site/src/$m is not a symlink mount"
    exit 1
  fi
  if [[ ! -e "site/src/$m" ]]; then
    echo "[site][fail] site/src/$m is a broken symlink"
    exit 1
  fi
done
echo "[site] mount links OK"

echo "[site] checking required outputs..."
test -f "site/index.html" || { echo "[site][fail] missing site/index.html"; exit 1; }
for t in "${TOPICS[@]}"; do
  topic_id="$(cut -d'_' -f1 <<<"$t")"
  html_name="${topic_id}_agent_writeup.html"
  pdf_name="${topic_id}_agent_writeup.pdf"
  test -f "site/$t/$html_name" || { echo "[site][fail] missing site/$t/$html_name"; exit 1; }
  test -f "site/$t/$pdf_name" || { echo "[site][fail] missing site/$t/$pdf_name"; exit 1; }
  test -f "content/topics/$t/$html_name" || { echo "[site][fail] missing synced content/topics/$t/$html_name"; exit 1; }
  test -f "content/topics/$t/$pdf_name" || { echo "[site][fail] missing synced content/topics/$t/$pdf_name"; exit 1; }
  test ! -f "site/$t/WRITEUP.html" || { echo "[site][fail] deprecated site/$t/WRITEUP.html present"; exit 1; }
  test ! -f "site/$t/WRITEUP.pdf" || { echo "[site][fail] deprecated site/$t/WRITEUP.pdf present"; exit 1; }
  test ! -f "content/topics/$t/WRITEUP.html" || { echo "[site][fail] deprecated content/topics/$t/WRITEUP.html present"; exit 1; }
  test ! -f "content/topics/$t/WRITEUP.pdf" || { echo "[site][fail] deprecated content/topics/$t/WRITEUP.pdf present"; exit 1; }
done
echo "[site] output checks OK"

echo "[site] checking local links in generated HTML..."
python3 - <<'PY'
from pathlib import Path
from html.parser import HTMLParser
from urllib.parse import urlparse

root = Path("site").resolve()
html_files = sorted(
    f for f in root.rglob("*.html")
    if not f.relative_to(root).parts[:1] == ("src",)
)

class Parser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids = set()
        self.links = []
    def handle_starttag(self, tag, attrs):
        d = dict(attrs)
        if d.get("id"):
            self.ids.add(d["id"])
        if tag == "a" and d.get("href"):
            self.links.append(d["href"])

broken = []
checked = 0

for f in html_files:
    p = Parser()
    p.feed(f.read_text(encoding="utf-8", errors="ignore"))
    for href in p.links:
        if href.startswith(("http://", "https://", "mailto:", "tel:", "javascript:")):
            continue
        if href.startswith("#"):
            if len(href) > 1 and href[1:] not in p.ids:
                broken.append((str(f.relative_to(root)), href, "missing-self-anchor"))
            continue
        checked += 1
        parsed = urlparse(href)
        target = (f.parent / parsed.path).resolve() if parsed.path else f
        if target.is_dir():
            target = target / "index.html"
        if not target.exists():
            broken.append((str(f.relative_to(root)), href, "missing-file"))
            continue
        if parsed.fragment:
            p2 = Parser()
            p2.feed(target.read_text(encoding="utf-8", errors="ignore"))
            if parsed.fragment not in p2.ids:
                broken.append((str(f.relative_to(root)), href, "missing-target-anchor"))

print(f"[site] html_files={len(html_files)} local_links_checked={checked}")
if broken:
    print("[site][fail] broken local links found")
    for b in broken[:200]:
        print("|".join(b))
    raise SystemExit(1)
print("[site] local link integrity OK")
PY

echo "[site] checking menu drawer script guardrails..."
if rg -n '\\.qmd' site/src/includes/nav-drawer.js | grep -q .; then
  if ! rg -n 'skip source-only qmd|Include only rendered pages' site/src/includes/nav-drawer.js >/dev/null; then
    echo "[site][fail] nav-drawer.js references .qmd without source-skip guard"
    exit 1
  fi
fi
echo "[site] menu drawer guardrail OK"

echo "[site] all checks passed"
