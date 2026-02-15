# Website Agent Working Note

## Agent Identity
- Agent: `website-agent`
- Role: `website`

## Scope
- Owned path: `site/`
- Source root: `site/src/`
- Render output root: `site/`
- Canonical topic HTML routes are `topicXX_agent_writeup.html`.
- Canonical topic PDF links must target `topicXX_agent_writeup.pdf`.

## Active Queue
- Keep site lane free of stale render cache/noise (`.quarto`, `.DS_Store`) after maintenance runs.
- Keep home/sidebar/drawer links aligned with `topicXX_agent_writeup.html`.
- Keep home/docs links aligned with canonical topic PDF filenames.
- Verify drawer/sidebar/navigation behavior after site-shell changes.
- Keep UI smoke routes and checklist language aligned with output contracts.

## Current Lease and Session
- lease_role: `website`
- agent_id: `codex`
- session_id: `2026-02-15-site-src-output-flatten`
- scope_claim: `site/`
- lease_expires_at: `managed via ops/tracker/coordination.json`

## Blockers
- (add blockers here)

## Next Handoff Action
- to_role:
- reason:
- expected_artifact:
