# Ops-Tooling Agent Working Note

## Agent Identity
- Agent: `ops-tooling-agent`
- Role: `ops-tooling`

## Scope
- Owned paths: `scripts/`, `tools/`, `ops/tracker/`
- Enforce stateless coordination and check contracts.

## Active Queue
- Keep `check_*` scripts aligned with canonical file contracts.
- Keep sync/check tooling enforcing `topicXX_agent_writeup.html` + `topicXX_agent_writeup.pdf`.
- Keep `scripts/agent_coord.py` and `scripts/check_tracking_contracts.py` in lockstep with AGENTS policy.
- Maintain extraction/tooling setup docs and scripts for repeatable runs.
- Harden local preflight behavior (explicit `rg` requirement) and reduce false tracking failures for non-live/historical diffs.
- Keep machine-readable tracking contract (`ops/tracker/contracts.json`) aligned with checker defaults.
- Provide a safe lease orchestration wrapper for repeatable claim/check/release flows.

## Current Lease and Session
- lease_role: `ops-tooling`
- agent_id: `codex`
- session_id: `2026-02-27-orchestration`
- scope_claim: `scripts/` or `tools/` or `ops/tracker/`
- lease_expires_at: `managed via ops/tracker/coordination.json`

## Blockers
- (add blockers here)

## Next Handoff Action
- to_role:
- reason:
- expected_artifact:
