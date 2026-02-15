#!/usr/bin/env python3
"""Lease and handoff coordinator for multi-agent sessions."""

from __future__ import annotations

import argparse
import json
import os
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
STATE_PATH = ROOT / "ops" / "tracker" / "coordination.json"
ROLES = {"topic00", "topic01", "topic02", "topic03", "website", "ops-tooling", "integrator"}


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


def iso(dt: datetime) -> str:
    return dt.isoformat().replace("+00:00", "Z")


def parse_iso(value: str) -> datetime:
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def default_state() -> dict[str, Any]:
    return {
        "schema_version": 1,
        "leases": [],
        "handoffs": [],
        "conflicts": [],
    }


def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


def load_state() -> dict[str, Any]:
    if not STATE_PATH.exists():
        return default_state()
    return json.loads(STATE_PATH.read_text(encoding="utf-8"))


def save_state(state: dict[str, Any]) -> None:
    ensure_parent(STATE_PATH)
    STATE_PATH.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")


def is_active(lease: dict[str, Any], now: datetime) -> bool:
    try:
        return parse_iso(lease["expires_at"]) > now
    except Exception:
        return False


def scopes_overlap(a: str, b: str) -> bool:
    a = a.rstrip("/")
    b = b.rstrip("/")
    return a == b or a.startswith(f"{b}/") or b.startswith(f"{a}/")


def normalize_state(state: dict[str, Any]) -> dict[str, Any]:
    out = dict(state)
    out.setdefault("schema_version", 1)
    out.setdefault("leases", [])
    out.setdefault("handoffs", [])
    out.setdefault("conflicts", [])
    return out


def claim(args: argparse.Namespace) -> int:
    state = normalize_state(load_state())
    now = utc_now()
    ttl = timedelta(minutes=args.ttl_min)
    expires_at = iso(now + ttl)

    leases = []
    for lease in state["leases"]:
        if is_active(lease, now):
            leases.append(lease)
    state["leases"] = leases

    for lease in state["leases"]:
        if lease["role"] != args.role:
            continue
        if lease["agent_id"] == args.agent_id:
            continue
        if scopes_overlap(lease["scope"], args.scope):
            state["conflicts"].append(
                {
                    "timestamp": iso(now),
                    "role": args.role,
                    "requested_by": args.agent_id,
                    "active_agent": lease["agent_id"],
                    "requested_scope": args.scope,
                    "active_scope": lease["scope"],
                    "session_id": args.session_id,
                    "decision": "rejected-active-lease",
                }
            )
            save_state(state)
            print(
                f"[agent-coord][fail] active lease conflict role={args.role} "
                f"scope={lease['scope']} held_by={lease['agent_id']} "
                f"until={lease['expires_at']}"
            )
            return 1

    replaced = False
    for lease in state["leases"]:
        if lease["role"] == args.role and lease["agent_id"] == args.agent_id and lease["scope"] == args.scope:
            lease["acquired_at"] = iso(now)
            lease["expires_at"] = expires_at
            lease["session_id"] = args.session_id
            replaced = True
            break

    if not replaced:
        state["leases"].append(
            {
                "role": args.role,
                "agent_id": args.agent_id,
                "scope": args.scope,
                "session_id": args.session_id,
                "acquired_at": iso(now),
                "expires_at": expires_at,
            }
        )

    save_state(state)
    print(
        f"[agent-coord] lease claimed role={args.role} agent={args.agent_id} "
        f"scope={args.scope} session={args.session_id} expires_at={expires_at}"
    )
    return 0


def heartbeat(args: argparse.Namespace) -> int:
    state = normalize_state(load_state())
    now = utc_now()
    ttl = timedelta(minutes=args.ttl_min)
    updated = False
    for lease in state["leases"]:
        if lease["role"] == args.role and lease["agent_id"] == args.agent_id and is_active(lease, now):
            lease["expires_at"] = iso(now + ttl)
            updated = True
    if not updated:
        print(f"[agent-coord][fail] no active lease for role={args.role} agent={args.agent_id}")
        return 1
    save_state(state)
    print(f"[agent-coord] heartbeat role={args.role} agent={args.agent_id}")
    return 0


def release(args: argparse.Namespace) -> int:
    state = normalize_state(load_state())
    before = len(state["leases"])
    state["leases"] = [
        lease
        for lease in state["leases"]
        if not (lease["role"] == args.role and lease["agent_id"] == args.agent_id)
    ]
    save_state(state)
    released = before - len(state["leases"])
    print(f"[agent-coord] released={released} role={args.role} agent={args.agent_id}")
    return 0


def handoff(args: argparse.Namespace) -> int:
    state = normalize_state(load_state())
    now = utc_now()
    state["handoffs"].append(
        {
            "timestamp": iso(now),
            "session_id": args.session_id,
            "from_role": args.from_role,
            "to_role": args.to_role,
            "scope": args.scope,
            "note": args.note,
        }
    )
    save_state(state)
    print(
        f"[agent-coord] handoff session={args.session_id} "
        f"{args.from_role} -> {args.to_role} scope={args.scope}"
    )
    return 0


def status(args: argparse.Namespace) -> int:
    state = normalize_state(load_state())
    now = utc_now()
    active = [lease for lease in state["leases"] if is_active(lease, now)]
    if args.json:
        print(json.dumps({"active_leases": active, "handoffs": state["handoffs"][-20:]}, indent=2))
        return 0

    print("[agent-coord] active leases")
    if not active:
        print("- none")
    for lease in active:
        print(
            f"- role={lease['role']} agent={lease['agent_id']} scope={lease['scope']} "
            f"session={lease.get('session_id', '')} expires_at={lease['expires_at']}"
        )
    if state["handoffs"]:
        print("[agent-coord] recent handoffs")
        for item in state["handoffs"][-10:]:
            print(
                f"- {item['timestamp']} session={item.get('session_id', '')} "
                f"{item['from_role']}->{item['to_role']} scope={item['scope']}"
            )
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Manage multi-agent coordination leases and handoffs.")
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--claim", action="store_true", help="Claim a lease for a role/scope.")
    action.add_argument("--heartbeat", action="store_true", help="Extend an existing lease.")
    action.add_argument("--release", action="store_true", help="Release a lease.")
    action.add_argument("--handoff", action="store_true", help="Record a role handoff.")
    action.add_argument("--status", action="store_true", help="Show coordination status.")

    parser.add_argument("--role", choices=sorted(ROLES))
    parser.add_argument("--agent-id")
    parser.add_argument("--scope")
    parser.add_argument("--ttl-min", type=int, default=90)
    parser.add_argument("--session-id", default=os.environ.get("AGENT_SESSION_ID", ""))

    parser.add_argument("--from-role", choices=sorted(ROLES))
    parser.add_argument("--to-role", choices=sorted(ROLES))
    parser.add_argument("--note", default="")

    parser.add_argument("--json", action="store_true", help="Print JSON for --status.")
    return parser


def require(args: argparse.Namespace, *fields: str) -> None:
    missing = [field for field in fields if not getattr(args, field)]
    if missing:
        raise SystemExit(f"[agent-coord][fail] missing required arguments: {', '.join(missing)}")


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    if args.claim:
        require(args, "role", "agent_id", "scope", "session_id")
        if args.session_id == "manual-session":
            raise SystemExit("[agent-coord][fail] session_id 'manual-session' is not allowed")
        return claim(args)
    if args.heartbeat:
        require(args, "role", "agent_id")
        return heartbeat(args)
    if args.release:
        require(args, "role", "agent_id")
        return release(args)
    if args.handoff:
        require(args, "from_role", "to_role", "scope", "session_id")
        if args.session_id == "manual-session":
            raise SystemExit("[agent-coord][fail] session_id 'manual-session' is not allowed")
        return handoff(args)
    return status(args)


if __name__ == "__main__":
    raise SystemExit(main())
