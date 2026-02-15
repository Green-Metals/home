# Session Handoff

Updated: 2026-02-15 12:00 AEDT

## Current Baseline

- Lane split is active and stable:
  - `content/` writing source-of-truth
  - `site/` Quarto shell and publish output
  - `ops/` internal tracker and QA artifacts
  - `tools/` runtime deps
- Render status: `quarto render site` passes.
- Deploy status:
  - latest successful publish: `22013555142`
  - latest strict publish failure: `22013673921` (TinyTeX package/class resolution issue: `scrartcl.cls`)
- Branch protection status: `main` now requires `quality` status check + 1 approval + CODEOWNER review.
- Fast-check lane status: `scripts/check_fast.sh` is the PR-speed gate; strict gate remains `scripts/check_all.sh`.
- Local validation status: both `RUN_UI_SMOKE=1 ./scripts/check_fast.sh` and `RUN_UI_SMOKE=1 ./scripts/check_all.sh` pass.
- PR status:
  - open PR: `https://github.com/Green-Metals/home/pull/1`
  - latest pushed commit on PR branch: `31c66b1`
  - `quality` check: in progress for latest commit
  - merge state: blocked pending required review + passing `quality`
  - operational blocker: `gh` token invalid in current session (`gh auth status` fails)
  - merge automation blocker: repository auto-merge is currently disabled
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
- Code review workflow is now formalized:
  - `.github/CODEOWNERS` for auto-assignment,
  - `.github/PULL_REQUEST_TEMPLATE.md` checklist,
  - risk-based approval gate documented in `AGENTS.md`.
- PR quality workflow now runs fast-check:
  - `RUN_UI_SMOKE=1 ./scripts/check_fast.sh`
  - changed-only scope detection with auto full fallback
- Immediate release closeout remains pending:
  - restore GitHub CLI auth (`gh auth login -h github.com`)
  - wait for `quality` to finish green on commit `31c66b1`
  - get one required PR approval
  - merge PR #1
  - delete `codex/fast-check-pipeline` (local + remote)
  - verify next `Quarto Publish` run result

## Start-Next-Session Command Set

```bash
cd /Users/yuxiangw/Insync/2024_Monash-L/2026-02_Critical-Raw-Materials-Flagship
# fast local/PR gate:
RUN_UI_SMOKE=1 ./scripts/check_fast.sh
# strict local/release gate:
RUN_UI_SMOKE=1 ./scripts/check_all.sh
# full screenshot evidence (opt-in):
# RUN_UI_SMOKE=1 SAVE_UI_SMOKE_SCREENSHOTS=1 ./scripts/check_all.sh
```

Fast verification:

1. Run `RUN_UI_SMOKE=1 ./scripts/check_fast.sh`.
2. Open `ops/qa-artifacts/screenshots/latest/ui-smoke-report.json`.
3. If release-bound, run `RUN_UI_SMOKE=1 ./scripts/check_all.sh`.
4. Commit and open PR for pending local fast-check changes (direct push to `main` is blocked by protection rules).

PR closeout commands (once `gh` auth is restored):

```bash
gh pr view 1 --json url,state,mergeStateStatus,reviewDecision,statusCheckRollup
gh pr merge 1 --squash --delete-branch
git checkout main && git pull --ff-only
git branch -d codex/fast-check-pipeline
gh run list --workflow "Quarto Publish" --limit 1
```

Then open and continue from:

1. `ops/WORKFLOW_QUICKSTART.md`
2. `ops/PROJECT_TRACKER.md`
3. the active topic `content/topics/topicXX_.../WORKING_NOTE.md`
