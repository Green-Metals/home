# Workflow Quickstart

This is the practical guide for day-to-day work in this repo.

## 1) Repo Lanes

- `content/` = writing and evidence source-of-truth.
- `site/` = website shell, Quarto config, styles, includes, rendered site output.
- `ops/` = internal operations logs and QA artifacts.
- `tools/` = runtime/tooling dependencies (for example Playwright).

## 2) Where Humans Edit

Edit topic content in:

- `content/topics/topicXX_.../WORKING_NOTE.md`
- `content/topics/topicXX_.../subtopics/*.qmd`
- `content/topics/topicXX_.../WRITEUP.qmd`
- `content/topics/topicXX_.../meta/*`

Edit website shell in:

- `site/_quarto.yml`
- `site/index.qmd`
- `site/docs/*.qmd`
- `site/styles/*`
- `site/includes/*`

Do not treat `site/topicXX_*` as the primary place for edits. Those are mounted into the site for rendering; canonical files remain in `content/topics/...`.

Compatibility note:
- keep `content/topics/includes` (symlink to `site/includes`) so Quarto include injection works for mounted topic sources.

## 3) Standard Edit Order (Topic Work)

1. Edit `subtopics/*.qmd`.
2. Sync into `WRITEUP.qmd`.
3. Render site to regenerate web pages and topic PDFs.
4. Update `meta/*` (for example `sources.csv`, audit files).
5. Record non-trivial work in `ops/PROJECT_TRACKER.md`.

## 4) Build and Preview

From repo root:

```bash
./scripts/render_site.sh
```

This runs:

```bash
quarto render site
```

Outputs:

- Website HTML: `site/_site/`
- Topic rendered PDFs in site output: `site/_site/topicXX_.../WRITEUP.pdf`
- Synced canonical topic PDFs: `content/topics/topicXX_.../WRITEUP.pdf` (via `scripts/sync_writeup_pdfs.sh`)

## 5) Website Publishing

GitHub workflow:

- `.github/workflows/quarto-publish.yml`

Publish source:

- `site/_site`

Typical flow:

1. Confirm local render success.
2. Commit content/site changes.
3. Push and/or trigger workflow according to current CI policy.
4. Verify live site after deployment.

## 6) Human-Agent Collaboration Pattern

Use prompts like:

- "Update topic01 T2 module and sync writeup."
- "Adjust homepage layout and sidebar spacing."
- "Run full render and check TOC/menu interactions."
- "Prepare deploy-ready changes and summarize risks."

Expected agent behavior:

1. Edit the correct lane (`content/` vs `site/`).
2. Run validation/build.
3. Keep folder contracts intact.
4. Update `ops/PROJECT_TRACKER.md` for non-trivial sessions.

## 7) Operational Logging

Single tracker:

- `ops/PROJECT_TRACKER.md`

Log at minimum:

- major tool runs,
- QA outcomes,
- UI regressions/fixes,
- deployment notes,
- open risks.

## 8) Retention Policy (Lean)

- Keep migration history as manifests only in `ops/migration/`.
- Keep QA evidence as latest-only in `ops/qa-artifacts/screenshots/latest/`.
- Keep `ui-smoke-report.json` always.
- Keep failure screenshots by default; full screenshot capture is opt-in.

Rotate QA artifacts with:

```bash
./scripts/qa_artifacts_rotate.sh --dry-run
./scripts/qa_artifacts_rotate.sh
```

UI smoke capture modes:

```bash
# default strict gate (failure screenshots only)
RUN_UI_SMOKE=1 ./scripts/check_all.sh

# full screenshot evidence (opt-in)
RUN_UI_SMOKE=1 SAVE_UI_SMOKE_SCREENSHOTS=1 ./scripts/check_all.sh
```

## 9) Guardrails

- Keep topic naming strict: `WORKING_NOTE.md`, `WRITEUP.qmd`, `WRITEUP.pdf`.
- Keep subtopic numbering ordered (`00...`, `01...`, ..., `90...`).
- Do not introduce stale legacy paths.
- Keep refs and evidence-bearing files under each topic contract.
- Keep `ops/*` internal-only (not in public site nav/render list).

## 10) Session Closeout Checklist

Before ending a substantial work session:

1. Run consolidated checks:
   - `./scripts/check_all.sh`
   - For strict local UI gate: `RUN_UI_SMOKE=1 ./scripts/check_all.sh`
2. Confirm outputs:
   - `site/_site/index.html`
   - `site/_site/topicXX_.../WRITEUP.html`
   - `site/_site/topicXX_.../WRITEUP.pdf`
   - `content/topics/topicXX_.../WRITEUP.pdf`
3. If UI/nav changed, ensure smoke evidence is present in `ops/qa-artifacts/screenshots/latest/`.
   - required: `ui-smoke-report.json`
   - optional: full screenshot set only when explicitly requested
4. Update `ops/PROJECT_TRACKER.md` with:
   - tool runs,
   - QA/test outcomes,
   - open issues/risks,
   - topic verification snapshot.

Then start the next session from this file plus `ops/PROJECT_TRACKER.md`.
