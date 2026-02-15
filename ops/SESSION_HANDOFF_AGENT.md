# Agent Session Handoff (Integrator)

Updated: 2026-02-15

## 1) Role Topology
- `integrator`: cross-lane arbitration, governance, final gates.
- `topic00`, `topic01`, `topic02`, `topic03`: topic content lanes.
- `website`: `site/` lane.
- `ops-tooling`: `scripts/`, `tools/`, and tracker tooling lane.

## 2) Stateless Coordination Contract
- Agents are stateless workers.
- Coordination is valid only when persisted in repo state:
  - `ops/tracker/coordination.json`
  - `ops/PROJECT_TRACKER.md`
  - lane `*_agent_working_note.md` files
- `agent_id` and `session_id` are mandatory for lease and handoff events.

## 3) Required Handoff Routine
1. Export session identity:
   - `export AGENT_ID=<agent-id>`
   - `export AGENT_SESSION_ID=<session-id>`
2. Claim lease before edits:
   - `python3 scripts/agent_coord.py --claim --role <role> --agent-id "$AGENT_ID" --scope <path> --session-id "$AGENT_SESSION_ID"`
3. Keep lease alive during long runs:
   - `python3 scripts/agent_coord.py --heartbeat --role <role> --agent-id "$AGENT_ID"`
4. Record handoff when scope moves:
   - `python3 scripts/agent_coord.py --handoff --from-role <role> --to-role <role> --scope <path> --session-id "$AGENT_SESSION_ID" --note "..."`
5. Release lease at closeout:
   - `python3 scripts/agent_coord.py --release --role <role> --agent-id "$AGENT_ID"`

## 4) Reporting to Integrator (Mandatory)
- Every topic agent change must add/update a role row in `ops/PROJECT_TRACKER.md` (`## 2) Role Activity Ledger`).
- Any multi-lane session must add/update an integrator row in `## 3) Integrator Coordination Log`.
- Every touched lane must update its lane note in the same change set.

## 5) Validation and Gates
`python3 scripts/check_tracking_contracts.py --check` fails on:
- `missing_lane_note_update:<role>`
- `missing_or_expired_lease:<role>`
- `session_or_agent_mismatch:<role>:<session_id>:<agent_id>`
- `missing_integrator_coordination`

Release checks:
- `RUN_UI_SMOKE=1 ./scripts/check_fast.sh`
- `RUN_UI_SMOKE=1 ./scripts/check_all.sh`
