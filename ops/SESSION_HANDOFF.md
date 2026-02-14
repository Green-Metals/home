# Session Handoff

Updated: 2026-02-14 18:22 AEDT

## Current Baseline

- Lane split is active and stable:
  - `content/` writing source-of-truth
  - `site/` Quarto shell and publish output
  - `ops/` internal tracker and QA artifacts
  - `tools/` runtime deps
- Render status: `quarto render site` passes.
- Deploy status: `Quarto Publish` run `22013387463` passed on `main`.
- Topic outputs verified:
  - `site/_site/topic00_landscape-briefing/WRITEUP.html`
  - `site/_site/topic01_copper/WRITEUP.html`
  - `site/_site/topic02_iron-steel/WRITEUP.html`
  - `site/_site/topic03_alumina-aluminium/WRITEUP.html`
  - all topic `WRITEUP.pdf` files synced to `content/topics/...`.

## What Was Checked This Closeout

- Topic folder contract presence for all topics.
- `meta/sources.csv` schema + path existence checks.
- AGENTS quality gates:
  - deprecated filename scan
  - T1-T6 sequence check
  - stale legacy path check
  - placeholder scan
- Website checks:
  - local render integrity
  - local link integrity
  - browser click-through QA (desktop + mobile)
  - MENU open/close behavior and link validity
  - TOC presence on writeup pages
- Hygiene:
  - removed `.DS_Store` files.

Artifacts:
- `ops/qa-artifacts/screenshots/latest/ui-smoke-report.json`

## Key Fix Applied

- MENU drawer now excludes source-only `.qmd` links to avoid unreliable raw-source navigation:
  - `site/includes/nav-drawer.js`

## Known Open Items

- Subtopic pages are not currently emitted as standalone HTML outputs in `site/_site`; website is writeup-first.
- Deployment run IDs should continue being logged consistently in `ops/PROJECT_TRACKER.md`.
- Keep compatibility symlink `content/topics/includes -> ../../site/includes`; removing it breaks include injection on mounted topic pages.

## Start-Next-Session Command Set

```bash
cd /Users/yuxiangw/Insync/2024_Monash-L/2026-02_Critical-Raw-Materials-Flagship
./scripts/check_all.sh
# strict local UI gate:
# RUN_UI_SMOKE=1 ./scripts/check_all.sh
# full screenshot evidence (opt-in):
# RUN_UI_SMOKE=1 SAVE_UI_SMOKE_SCREENSHOTS=1 ./scripts/check_all.sh
```

Fast verification:

1. Run `RUN_UI_SMOKE=1 ./scripts/check_all.sh`.
2. Open `ops/qa-artifacts/screenshots/latest/ui-smoke-report.json`.

Then open and continue from:

1. `ops/WORKFLOW_QUICKSTART.md`
2. `ops/PROJECT_TRACKER.md`
3. the active topic `content/topics/topicXX_.../WORKING_NOTE.md`
