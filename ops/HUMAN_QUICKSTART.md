# Human Quickstart

Primary operator runbook for day-to-day execution.

## 1) Start Here
1. Open `AGENTS.md` for current contracts.
2. Open `ops/PROJECT_TRACKER.md` for active risks and role activity.
3. Open lane notes:
   - `content/topics/topic00_landscape-briefing/topic00_agent_working_note.md`
   - `content/topics/topic01_copper/topic01_agent_working_note.md`
   - `content/topics/topic02_iron-steel/topic02_agent_working_note.md`
   - `content/topics/topic03_alumina-aluminium/topic03_agent_working_note.md`
   - `site/website_agent_working_note.md`
   - `ops/ops_tooling_agent_working_note.md`

## 2) Topic Output Contract
- Canonical topic source: `topicXX_agent_writeup.qmd`
- Canonical topic HTML: `topicXX_agent_writeup.html`
- Canonical topic PDF: `topicXX_agent_writeup.pdf`
- Deprecated/forbidden: `WRITEUP.html`
- Deprecated/forbidden: `WRITEUP.pdf`
- Canonical route URL is `topicXX_agent_writeup.html`
- Website source root: `site/src/`
- Website render output root: `site/` (no `site/_site` layer)

## 3) Required Operator Sequence
1. Claim lease:
   - `python3 scripts/agent_coord.py --claim --role <role> --agent-id <id> --scope <path> --session-id <sid>`
2. Make lane-scoped edits.
3. Update the touched lane note (`*_agent_working_note.md`).
4. Update `ops/PROJECT_TRACKER.md`:
   - role row in `## 2) Role Activity Ledger`
   - integrator coordination row in `## 3) Integrator Coordination Log` for cross-lane work
5. Run checks:
   - `RUN_UI_SMOKE=1 ./scripts/check_fast.sh`
   - `RUN_UI_SMOKE=1 ./scripts/check_all.sh` for strict/release closure
6. Release lease:
   - `python3 scripts/agent_coord.py --release --role <role> --agent-id <id>`

## 4) Source and Bibliography Sync
When source files or `meta/sources.csv` change:

```bash
./scripts/sync_sources_and_bib.sh --apply
```

Validation only:

```bash
./scripts/sync_sources_and_bib.sh --check
```

## 5) Coordination State Files
- Lease/handoff state: `ops/tracker/coordination.json`
- Integrator handoff: `ops/SESSION_HANDOFF_AGENT.md`
- Master tracker: `ops/PROJECT_TRACKER.md`

All multi-agent coordination is valid only when written into these repo files.
