#!/usr/bin/env python3
"""Validate multi-agent tracking and coordination contracts."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT_TRACKER = ROOT / "ops" / "PROJECT_TRACKER.md"
COORD_STATE = ROOT / "ops" / "tracker" / "coordination.json"
HUMAN_QUICKSTART = ROOT / "ops" / "HUMAN_QUICKSTART.md"
AGENT_HANDOFF = ROOT / "ops" / "SESSION_HANDOFF_AGENT.md"

ROLE_ORDER = ["topic00", "topic01", "topic02", "topic03", "website", "ops-tooling", "integrator"]
OWNED_LANE_ROLES = {"topic00", "topic01", "topic02", "topic03", "website", "ops-tooling"}
LANE_NOTE_BY_ROLE = {
    "topic00": "content/topics/topic00_landscape-briefing/topic00_agent_working_note.md",
    "topic01": "content/topics/topic01_copper/topic01_agent_working_note.md",
    "topic02": "content/topics/topic02_iron-steel/topic02_agent_working_note.md",
    "topic03": "content/topics/topic03_alumina-aluminium/topic03_agent_working_note.md",
    "website": "site/website_agent_working_note.md",
    "ops-tooling": "ops/ops_tooling_agent_working_note.md",
}
IGNORED_PREFIXES = (
    "ops/qa-artifacts/",
    "ops/migration/",
    ".playwright-cli/",
    "site/.quarto/",
    "site/_site/",
    "scripts/__pycache__/",
)
IGNORED_SITE_OUTPUT_PREFIXES = (
    "site/docs/",
    "site/site_libs/",
    "site/styles/",
    "site/topic00_landscape-briefing/",
    "site/topic01_copper/",
    "site/topic02_iron-steel/",
    "site/topic03_alumina-aluminium/",
)
IGNORED_SITE_OUTPUT_FILES = {
    "site/index.html",
    "site/search.json",
    "site/topic00_landscape-briefing",
    "site/topic01_copper",
    "site/topic02_iron-steel",
    "site/topic03_alumina-aluminium",
}
LEGACY_WEBSITE_SOURCE_FILES = {
    "site/_quarto.yml",
    "site/index.qmd",
    "site/references",
    "content/topics/includes",
}
LEGACY_WEBSITE_SOURCE_PREFIXES = (
    "site/includes/",
)


def sh(cmd: list[str]) -> str:
    proc = subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True, check=False)
    if proc.returncode != 0:
        return ""
    return proc.stdout


def detect_changed_files(base_ref: str | None) -> list[str]:
    changes: set[str] = set()

    def collect(cmd: list[str]) -> None:
        out = sh(cmd)
        for line in out.splitlines():
            line = line.strip()
            if line:
                changes.add(line)

    if base_ref:
        collect(["git", "diff", "--name-only", f"{base_ref}...HEAD"])
    elif os.environ.get("GITHUB_BASE_REF"):
        ref = f"origin/{os.environ['GITHUB_BASE_REF']}"
        collect(["git", "diff", "--name-only", f"{ref}...HEAD"])
    else:
        collect(["git", "diff", "--name-only", "HEAD~1..HEAD"])
        collect(["git", "diff", "--name-only"])
        collect(["git", "diff", "--name-only", "--cached"])
    collect(["git", "ls-files", "--others", "--exclude-standard"])
    return sorted(changes)


def role_for_path(path: str) -> str | None:
    if path.startswith(IGNORED_PREFIXES):
        return None
    if path.startswith(IGNORED_SITE_OUTPUT_PREFIXES) or path in IGNORED_SITE_OUTPUT_FILES:
        return None
    if path in LEGACY_WEBSITE_SOURCE_FILES or path.startswith(LEGACY_WEBSITE_SOURCE_PREFIXES):
        return "website"
    if path.startswith("content/topics/topic00_landscape-briefing/"):
        return "topic00"
    if path.startswith("content/topics/topic01_copper/"):
        return "topic01"
    if path.startswith("content/topics/topic02_iron-steel/"):
        return "topic02"
    if path.startswith("content/topics/topic03_alumina-aluminium/"):
        return "topic03"
    if path.startswith("site/src/"):
        return "website"
    if path in {"site/website_agent_working_note.md", "site/.gitignore"}:
        return "website"
    if path.startswith("scripts/") or path.startswith("tools/") or path.startswith(".github/"):
        return "ops-tooling"
    if path.startswith("ops/tracker/coordination.json") or path.startswith("ops/ops_tooling_agent_working_note.md"):
        return "ops-tooling"
    if path == ".gitignore":
        return "ops-tooling"
    if path in {
        "AGENTS.md",
        "ops/PROJECT_TRACKER.md",
        "ops/HUMAN_QUICKSTART.md",
        "ops/SESSION_HANDOFF_AGENT.md",
    }:
        return "integrator"
    if path.startswith("ops/"):
        return "integrator"
    if path.startswith("content/references/"):
        return "integrator"
    return "unknown"


def parse_iso(value: str) -> datetime:
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def load_coord_state() -> dict:
    if not COORD_STATE.exists():
        return {"leases": [], "handoffs": [], "conflicts": []}
    return json.loads(COORD_STATE.read_text(encoding="utf-8"))


def active_lease_by_role(state: dict) -> dict[str, dict]:
    now = datetime.now(timezone.utc)
    out: dict[str, dict] = {}
    for lease in state.get("leases", []):
        try:
            if parse_iso(lease["expires_at"]) <= now:
                continue
        except Exception:
            continue
        role = lease.get("role", "")
        if role and role not in out:
            out[role] = lease
    return out


def extract_section(text: str, heading: str) -> str:
    pattern = re.compile(rf"^##\s+{re.escape(heading)}\s*$", re.MULTILINE)
    m = pattern.search(text)
    if not m:
        return ""
    start = m.end()
    tail = text[start:]
    n = re.search(r"^##\s+", tail, flags=re.MULTILINE)
    if not n:
        return tail
    return tail[: n.start()]


def parse_role_ledger_rows(project_tracker_text: str) -> list[tuple[str, str, str]]:
    section = extract_section(project_tracker_text, "2) Role Activity Ledger")
    if not section:
        return []
    rows: list[tuple[str, str, str]] = []
    for line in section.splitlines():
        if not line.strip().startswith("|"):
            continue
        parts = [item.strip() for item in line.strip().strip("|").split("|")]
        if len(parts) < 3:
            continue
        if parts[0] in {"session_id", "---"}:
            continue
        rows.append((parts[0], parts[1], parts[2]))
    return rows


def ensure_doc_contract(errors: list[str]) -> None:
    if not HUMAN_QUICKSTART.exists():
        errors.append("missing_human_quickstart: ops/HUMAN_QUICKSTART.md")
    if not AGENT_HANDOFF.exists():
        errors.append("missing_agent_handoff: ops/SESSION_HANDOFF_AGENT.md")


def validate_coord_state(state: dict, errors: list[str]) -> None:
    if not isinstance(state, dict):
        errors.append("invalid_coord_state:not-an-object")
        return
    for key in ("leases", "handoffs", "conflicts"):
        if key not in state or not isinstance(state[key], list):
            errors.append(f"invalid_coord_state:missing-or-invalid-{key}")

    now = datetime.now(timezone.utc)
    active_by_role: dict[str, list[dict]] = {}
    for lease in state.get("leases", []):
        role = (lease.get("role") or "").strip()
        agent = (lease.get("agent_id") or "").strip()
        scope = (lease.get("scope") or "").strip()
        session = (lease.get("session_id") or "").strip()
        expires = (lease.get("expires_at") or "").strip()
        if not role or not agent or not scope or not session or not expires:
            errors.append("invalid_lease_record:missing-required-fields")
            continue
        if session == "manual-session":
            errors.append(f"invalid_lease_session:{role}:{agent}:manual-session")
        try:
            exp_dt = parse_iso(expires)
        except Exception:
            errors.append(f"invalid_lease_record:bad-expires-at:{role}:{agent}")
            continue
        if exp_dt <= now:
            continue
        active_by_role.setdefault(role, []).append(lease)

    for role, leases in active_by_role.items():
        if len(leases) > 1:
            errors.append(f"multi_active_lease_conflict:{role}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate tracking + coordination contracts.")
    parser.add_argument("--check", action="store_true", help="Run validation checks.")
    parser.add_argument("--base-ref", help="Optional git base ref for diff detection.")
    parser.add_argument("--verbose", action="store_true", help="Print diagnostics.")
    args = parser.parse_args()

    if not args.check:
        print("Use --check")
        return 1

    changed = detect_changed_files(args.base_ref)
    changed = [path for path in changed if role_for_path(path) is not None]
    if args.verbose:
        print(f"[tracking] changed_files={len(changed)}")
    changed_set = set(changed)

    roles_touched: set[str] = set()
    unknown_paths: list[str] = []
    for path in changed:
        role = role_for_path(path)
        if role == "unknown":
            unknown_paths.append(path)
            continue
        if role:
            roles_touched.add(role)

    errors: list[str] = []
    ensure_doc_contract(errors)

    if unknown_paths:
        for path in unknown_paths:
            errors.append(f"unknown_scope_owner:{path}")

    for role in sorted(role for role in roles_touched if role in LANE_NOTE_BY_ROLE):
        lane_note_path = LANE_NOTE_BY_ROLE[role]
        if lane_note_path not in changed_set:
            errors.append(f"missing_lane_note_update:{role}")

    if not PROJECT_TRACKER.exists():
        errors.append("missing_master_tracker: ops/PROJECT_TRACKER.md")
    else:
        tracker_text = PROJECT_TRACKER.read_text(encoding="utf-8")
        ledger_rows = parse_role_ledger_rows(tracker_text)
        if not ledger_rows:
            errors.append("missing_role_ledger_section: expected heading '## 2) Role Activity Ledger'")

        rows_by_role_session_agent: dict[str, set[tuple[str, str]]] = {}
        for session_id, role, agent_id in ledger_rows:
            rows_by_role_session_agent.setdefault(role, set()).add((session_id, agent_id))

        state = load_coord_state()
        validate_coord_state(state, errors)
        active_by_role = active_lease_by_role(state)
        for role in sorted(roles_touched):
            lease = active_by_role.get(role)
            if lease is None:
                errors.append(f"missing_or_expired_lease:{role}")
                continue
            session_id = lease.get("session_id", "")
            agent_id = lease.get("agent_id", "")
            if role not in rows_by_role_session_agent:
                errors.append(f"missing_role_activity:{role}")
                continue
            if (session_id, agent_id) not in rows_by_role_session_agent[role]:
                errors.append(f"session_or_agent_mismatch:{role}:{session_id}:{agent_id}")

        lane_roles = sorted(role for role in roles_touched if role in OWNED_LANE_ROLES)
        if len(lane_roles) > 1:
            lease = active_by_role.get("integrator")
            if lease is None:
                errors.append("missing_or_expired_lease:integrator")
            elif "integrator" not in rows_by_role_session_agent:
                errors.append("missing_integrator_coordination")
            else:
                i_sid = lease.get("session_id", "")
                i_agent = lease.get("agent_id", "")
                if (i_sid, i_agent) not in rows_by_role_session_agent["integrator"]:
                    errors.append(f"session_or_agent_mismatch:integrator:{i_sid}:{i_agent}")

    if errors:
        print("[tracking][fail] tracking contract violations")
        for err in errors:
            print(f"- {err}")
        return 1

    if args.verbose:
        roles_str = ",".join(role for role in ROLE_ORDER if role in roles_touched) or "(none)"
        print(f"[tracking] roles_touched={roles_str}")
    print("[tracking] tracking contracts OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
