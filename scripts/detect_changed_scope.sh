#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

OUT_FILE="${1:-${FAST_SCOPE_FILE:-/tmp/crm-fast-scope.json}}"
TMP_CHANGED="$(mktemp)"
FORCE_FULL_REASON=""

cleanup() {
  rm -f "$TMP_CHANGED"
}
trap cleanup EXIT

collect_changed() {
  local expr="$1"
  local out
  if out="$(eval "$expr" 2>/dev/null)"; then
    printf '%s\n' "$out" >> "$TMP_CHANGED"
    return 0
  fi
  return 1
}

if [[ -n "${GITHUB_BASE_REF:-}" ]]; then
  BASE_REF="origin/${GITHUB_BASE_REF}"
  if ! git rev-parse --verify --quiet "$BASE_REF" >/dev/null; then
    git fetch --no-tags --depth=1 origin "${GITHUB_BASE_REF}" >/dev/null 2>&1 || true
  fi
  if git rev-parse --verify --quiet "$BASE_REF" >/dev/null; then
    if ! collect_changed "git diff --name-only ${BASE_REF}...HEAD"; then
      FORCE_FULL_REASON="failed to diff against ${BASE_REF}"
    fi
  else
    FORCE_FULL_REASON="missing base ref ${BASE_REF}"
  fi
else
  collect_changed "git diff --name-only HEAD~1..HEAD" || true
  collect_changed "git diff --name-only" || true
  collect_changed "git diff --name-only --cached" || true
fi

sort -u "$TMP_CHANGED" -o "$TMP_CHANGED"

python3 - "$TMP_CHANGED" "$OUT_FILE" "$FORCE_FULL_REASON" <<'PY'
import json
import pathlib
import re
import sys

changed_file = pathlib.Path(sys.argv[1])
out_file = pathlib.Path(sys.argv[2])
force_full_reason = sys.argv[3].strip()

topics = [
    "topic00_landscape-briefing",
    "topic01_copper",
    "topic02_iron-steel",
    "topic03_alumina-aluminium",
]
writeup_by_topic = {
    "topic00_landscape-briefing": "topic00_agent_writeup.qmd",
    "topic01_copper": "topic01_agent_writeup.qmd",
    "topic02_iron-steel": "topic02_agent_writeup.qmd",
    "topic03_alumina-aluminium": "topic03_agent_writeup.qmd",
}
writeup_route_by_topic = {
    "topic00_landscape-briefing": "/topic00_landscape-briefing/topic00_agent_writeup.html",
    "topic01_copper": "/topic01_copper/topic01_agent_writeup.html",
    "topic02_iron-steel": "/topic02_iron-steel/topic02_agent_writeup.html",
    "topic03_alumina-aluminium": "/topic03_alumina-aluminium/topic03_agent_writeup.html",
}

fallback_prefixes = (
    "site/src/_quarto.yml",
    "site/src/includes/",
    "site/src/styles/",
    "site/src/index.qmd",
    "site/src/docs/",
    "scripts/check_",
    "tools/playwright/",
    ".github/workflows/",
)

changed = [line.strip() for line in changed_file.read_text(encoding="utf-8").splitlines() if line.strip()]

mode = "targeted"
reason = ""
if force_full_reason:
    mode = "full"
    reason = force_full_reason
else:
    for path in changed:
        if path.startswith(fallback_prefixes):
            mode = "full"
            reason = f"shared/core change: {path}"
            break

changed_topics = set()
render_qmd = set()
ui_routes = set()

topic_re = re.compile(r"^(?:content/topics|site/src)/(topic[0-9]{2}[^/]+)/(.+)$")

def qmd_to_html_route(rel_qmd: str) -> str:
    route = "/" + rel_qmd
    if route.endswith(".qmd"):
        route = route[:-4] + ".html"
    return route

for path in changed:
    if path == "site/src/index.qmd":
        render_qmd.add("index.qmd")
        ui_routes.add("/index.html")
        continue
    if path.startswith("site/src/docs/") and path.endswith(".qmd"):
        rel = path[len("site/src/"):]
        render_qmd.add(rel)
        ui_routes.add(qmd_to_html_route(rel))
        continue

    m = topic_re.match(path)
    if not m:
        continue
    topic, subpath = m.group(1), m.group(2)
    if topic not in topics:
        continue
    changed_topics.add(topic)
    render_qmd.add(f"{topic}/{writeup_by_topic[topic]}")
    ui_routes.add(writeup_route_by_topic[topic])
    if subpath.startswith("subtopics/") and subpath.endswith(".qmd"):
        render_qmd.add(f"{topic}/{subpath}")

# In targeted mode with no render candidates, keep a minimal baseline
# so CI has concrete outputs and menu/TOC checks still run.
if mode == "targeted" and not render_qmd:
    render_qmd.add("index.qmd")
    render_qmd.add("topic01_copper/topic01_agent_writeup.qmd")
    ui_routes.add("/index.html")
    ui_routes.add(writeup_route_by_topic["topic01_copper"])
    if not reason:
        reason = "no topic/docs qmd changes; using minimal baseline routes"

# Always include at least one writeup route in targeted mode.
if mode == "targeted" and not any(r.endswith("_agent_writeup.html") for r in ui_routes):
    ui_routes.add(writeup_route_by_topic["topic01_copper"])
    render_qmd.add("topic01_copper/topic01_agent_writeup.qmd")
    if not reason:
        reason = "added baseline writeup route for smoke continuity"

payload = {
    "mode": mode,
    "changed_topics": sorted(changed_topics),
    "render_qmd": sorted(render_qmd),
    "ui_routes": sorted(ui_routes),
    "reason": reason,
}

out_file.parent.mkdir(parents=True, exist_ok=True)
out_file.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
print(f"[fast-scope] wrote {out_file}")
print(f"[fast-scope] mode={mode}")
if reason:
    print(f"[fast-scope] reason={reason}")
if payload["changed_topics"]:
    print(f"[fast-scope] changed_topics={','.join(payload['changed_topics'])}")
PY
