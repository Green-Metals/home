# AGENTS Operating Contract

This file is the single source of truth for agent behavior in this workspace.
No `README.md` is required.

## 1) Scope
- Workspace root: `/Users/yuxiangw/Insync/2024_Monash-L/2026-02_Critical-Raw-Materials-Flagship`
- Topics in scope:
  - `content/topics/topic00_landscape-briefing`
  - `content/topics/topic01_copper`
  - `content/topics/topic02_iron-steel`
  - `content/topics/topic03_alumina-aluminium`

## 1.1) Lane Separation
- `content/` is research and writing source-of-truth.
- `site/` is Quarto website shell and render lane.
- `ops/` is internal governance, tracking, and QA artifact lane.
- `tools/` is runtime/tooling lane.

## 2) Folder Contract
Each topic folder must follow:

```text
content/topics/topicXX_<name>/
  topicXX_agent_working_note.md
  topicXX_agent_writeup.qmd
  topicXX_agent_writeup.html
  topicXX_agent_writeup.pdf
  refs-sources/
  subtopics/
    *.qmd
  meta/
    sources.csv
```

## 3) File Role Contract
- `topicXX_agent_working_note.md`
  - Topic-agent operational control plane.
  - Queue, blockers, assumptions, and next handoff action.
- `topicXX_agent_writeup.qmd`
  - Canonical publishable source for the topic report.
  - Distilled evidence-backed synthesis and implications.
- `topicXX_agent_writeup.html`
  - Canonical topic HTML artifact generated from `topicXX_agent_writeup.qmd`.
  - Synced to each topic root from `site/<topic>/`.
- `topicXX_agent_writeup.pdf`
  - Distribution artifact generated from `topicXX_agent_writeup.qmd`.
  - Synced to each topic root from `site/<topic>/`.
- `subtopics/*.qmd`
  - Module source-of-truth.
  - Edit modules first, then sync into `topicXX_agent_writeup.qmd`.
- `refs-sources/`
  - Local source corpus for analysis.
  - Keep private-corpus policy unchanged.
- `meta/sources.csv`
  - Source index for each topic.
- `site/website_agent_working_note.md`
  - Website agent control plane for `site/` lane tasks.
- `ops/ops_tooling_agent_working_note.md`
  - Ops-tooling agent control plane for `scripts/`, `tools/`, and tracker-tooling tasks.

## 4) Naming Rules (Strict)
- Allowed canonical topic writeup filenames:
  - `topic00_agent_writeup.qmd`
  - `topic01_agent_writeup.qmd`
  - `topic02_agent_writeup.qmd`
  - `topic03_agent_writeup.qmd`
- Allowed canonical topic working-note filenames:
  - `topic00_agent_working_note.md`
  - `topic01_agent_working_note.md`
  - `topic02_agent_working_note.md`
  - `topic03_agent_working_note.md`
- Do not reintroduce deprecated names:
  - legacy top-level topic working-note filename (pre-agent-specific convention)
  - legacy top-level topic writeup filename (pre-agent-specific convention)
  - `WRITEUP.md`
  - `working-note.md`
  - `deep-dive.md`
  - `WRITEUP.pdf`
  - `WRITEUP.html`
- Published topic HTML route must be `topicXX_agent_writeup.html`.
- Keep module numbering ordered: `00_...`, `01_...`, ..., `90_...`.
- Keep topical section order (`topic01`/`topic02`/`topic03`): `## T1` -> `## T2` -> `## T3` -> `## T4` -> `## T5` -> `## T6`.

## 5) Update Order (Mandatory)
For topic updates:
1. Edit `subtopics/*.qmd` first.
2. Sync corresponding sections into `topicXX_agent_writeup.qmd`.
3. Regenerate topic output via `quarto render site/src` (HTML/PDF sync via `scripts/sync_writeup_pdfs.sh`).
4. Update topic metadata (`meta/*`, including `sources.csv`).
5. If sources changed, run `./scripts/sync_sources_and_bib.sh --apply`.
6. Update tracking in `ops/PROJECT_TRACKER.md` Role Activity Ledger.

## 6) Path and Reference Rules
- Use current workspace paths only.
- Keep paths repo-relative where possible.
- Keep compatibility mount `content/topics/includes -> ../../site/src/includes`.
- Keep migration history under `ops/migration/`.

## 7) Metadata Schema Rules
- `meta/sources.csv` header must be exactly:
  - `source_key,title,year,type,path,status,subtopic,notes`

## 8) Quality Gates (Run Before Closing Work)
From workspace root:

Fast gate:

```bash
RUN_UI_SMOKE=1 ./scripts/check_fast.sh
```

Strict gate:

```bash
RUN_UI_SMOKE=1 ./scripts/check_all.sh
```

## 8.1) Playwright Usage Policy
- Manual browser debugging: use `./scripts/pw.sh ...`
- Gate truth: `scripts/check_ui_smoke.sh` via `check_fast.sh` / `check_all.sh`
- MCP Playwright is exploratory only; reproduce via CLI/script before closure.

## 9) Hygiene
- Treat `.DS_Store` as ignorable local noise.
- Keep one canonical `topicXX_agent_writeup.html` and `topicXX_agent_writeup.pdf` at each topic root.
- `WRITEUP.html` is deprecated and forbidden in active topic/site contracts.
- `WRITEUP.pdf` is deprecated and forbidden in active topic/site contracts.
- Keep QA evidence in `ops/qa-artifacts/screenshots/latest/`:
  - always keep `ui-smoke-report.json`,
  - keep failure screenshots by default,
  - full screenshots only with `SAVE_UI_SMOKE_SCREENSHOTS=1`.

## 10) Change Discipline
- Prefer small, reversible edits.
- Preserve evidence-bearing content during restructure.

## 11) Tracking Discipline (Mandatory)
- Integrator master tracker is:
  - `ops/PROJECT_TRACKER.md`
- Role activity logs are embedded in `ops/PROJECT_TRACKER.md` (no separate `ROLE_LOGS.md`).
- Required sections in `ops/PROJECT_TRACKER.md`:
  - `## 2) Role Activity Ledger`
  - `## 3) Integrator Coordination Log`
  - `## 4) Decision Changelog`
  - `## 5) Open Issues and Risk Register`
  - `## 6) Topic Verification Snapshot`
- Any non-trivial scoped edit must add a role row with:
  - `session_id, role, agent_id, scope, activity, status, evidence, follow_up`

## 12) Code Review Discipline (Mandatory)
- Use pull requests for non-trivial changes.
- PR gate: `RUN_UI_SMOKE=1 ./scripts/check_fast.sh`.
- Release truth gate on `main`: `RUN_UI_SMOKE=1 ./scripts/check_all.sh`.
- Use `.github/CODEOWNERS` and PR checklist.
- Log review outcomes in `ops/PROJECT_TRACKER.md`.

## 13) Agent Hierarchy, Coordination, and Synchronization

### 13.1) Role Hierarchy
- Coordinator role: `integrator`.
- Domain lead roles:
  - `topic00`, `topic01`, `topic02`, `topic03`
  - `website`
  - `ops-tooling`

### 13.2) Ownership Map
- `topic00`: `content/topics/topic00_landscape-briefing/`
- `topic01`: `content/topics/topic01_copper/`
- `topic02`: `content/topics/topic02_iron-steel/`
- `topic03`: `content/topics/topic03_alumina-aluminium/`
- `website`: `site/`
- Website source root: `site/src/`
- Website rendered output root: `site/`
- `ops-tooling`: `scripts/`, `tools/`, `ops/tracker/`, `ops/ops_tooling_agent_working_note.md`
- `website` control note: `site/website_agent_working_note.md`
- `integrator`: `AGENTS.md`, `ops/PROJECT_TRACKER.md`, `ops/HUMAN_QUICKSTART.md`, `ops/SESSION_HANDOFF_AGENT.md`, cross-lane merge + final gates

### 13.3) Lease Lock Protocol (Mandatory Before Edits)
Stateless worker rule:
- Agents are stateless workers.
- Do not rely on transient chat memory for coordination.
- Coordination state must be repo-resident (`ops/tracker/coordination.json`, `ops/PROJECT_TRACKER.md`, lane notes).
- Every claim/handoff must include explicit `agent_id` and `session_id` (never `manual-session`).

Use:

```bash
python3 scripts/agent_coord.py --claim --role <role> --agent-id <id> --scope <path> --session-id <sid>
```

Heartbeat:

```bash
python3 scripts/agent_coord.py --heartbeat --role <role> --agent-id <id>
```

Release:

```bash
python3 scripts/agent_coord.py --release --role <role> --agent-id <id>
```

Status:

```bash
python3 scripts/agent_coord.py --status --json
```

### 13.4) Conflict Handling
- If lease conflict occurs, stop writes in conflicting scope.
- Escalate to `integrator` only.
- Record resolution in `## 3) Integrator Coordination Log` in `ops/PROJECT_TRACKER.md`.

### 13.5) Handoffs
Agent handoff records are maintained via:

```bash
python3 scripts/agent_coord.py --handoff --from-role <role> --to-role <role> --scope <path> --session-id <sid> --note "..."
```

## 14) Human vs Agent Docs
- Human-first runbook:
  - `ops/HUMAN_QUICKSTART.md`
- Agent/integrator handoff state:
  - `ops/SESSION_HANDOFF_AGENT.md`
- Integrator tracker of record:
  - `ops/PROJECT_TRACKER.md`

## 15) Tracking and Contract Validation
- `scripts/check_tracking_contracts.py --check` is mandatory and called by `scripts/check_content_contracts.sh`.
- Validation fails on:
  - missing role activity row in `ops/PROJECT_TRACKER.md`,
  - missing `agent_id` / `session_id` alignment between tracker and active lease state,
  - missing integrator coordination row for multi-lane changes,
  - duplicate active leases for the same role,
  - invalid lease records (missing fields or `manual-session`),
  - missing or expired role lease,
  - missing lane-note updates for touched owned lanes (`missing_lane_note_update:<role>`),
  - missing human/agent handoff docs after doc split.
