## Summary

- What changed:
- Why:

## Scope

- [ ] `content/` only
- [ ] `site/` UI/layout/styling
- [ ] `scripts/` checks/tooling
- [ ] `.github/workflows/` CI/publish
- [ ] `ops/` governance/tracking

## Quality Gates

- [ ] Ran `./scripts/check_all.sh`
- [ ] Ran strict gate `RUN_UI_SMOKE=1 ./scripts/check_all.sh` (required for infra/UI/CI changes)
- [ ] Confirmed no stale paths or deprecated filename regressions
- [ ] Confirmed expected outputs (`site/*.html`, topic `topicXX_agent_writeup.{html,pdf}` sync where applicable)

## Code Review

- [ ] CODEOWNERS reviewers requested
- [ ] At least one approval received for infra/UI/automation changes
- [ ] Risks and rollback plan documented (if non-trivial)

## Ops Logging

- [ ] Added/updated role row(s) in `ops/PROJECT_TRACKER.md` (`## 2) Role Activity Ledger`) with `session_id`, `role`, and `agent_id`
- [ ] Added/updated integrator coordination row when cross-lane (`## 3) Integrator Coordination Log`)
- [ ] Updated topic verification snapshot if topic-impacting

## Notes for Reviewer

- Key files to inspect:
- Potential risk areas:
