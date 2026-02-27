#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

AGENT_ID=""
SESSION_ID=""
LEASES=()

usage() {
  cat <<'EOF'
Usage:
  ./scripts/agent_run.sh --agent-id <id> --session-id <sid> --lease <role>:<scope> [--lease <role>:<scope> ...] -- <command>

Example:
  ./scripts/agent_run.sh \
    --agent-id codex \
    --session-id 2026-02-27-example \
    --lease ops-tooling:scripts \
    --lease integrator:ops \
    -- RUN_UI_SMOKE=1 ./scripts/check_fast.sh
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent-id)
      AGENT_ID="${2:-}"
      shift 2
      ;;
    --session-id)
      SESSION_ID="${2:-}"
      shift 2
      ;;
    --lease)
      LEASES+=("${2:-}")
      shift 2
      ;;
    --)
      shift
      break
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[agent-run][fail] unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$AGENT_ID" || -z "$SESSION_ID" ]]; then
  echo "[agent-run][fail] --agent-id and --session-id are required"
  usage
  exit 1
fi

if [[ "$SESSION_ID" == "manual-session" ]]; then
  echo "[agent-run][fail] session_id 'manual-session' is not allowed"
  exit 1
fi

if [[ ${#LEASES[@]} -eq 0 ]]; then
  echo "[agent-run][fail] at least one --lease role:scope is required"
  usage
  exit 1
fi

if [[ $# -eq 0 ]]; then
  echo "[agent-run][fail] missing command after --"
  usage
  exit 1
fi

ROLE_LIST=()
for item in "${LEASES[@]}"; do
  role="${item%%:*}"
  scope="${item#*:}"
  if [[ -z "$role" || -z "$scope" || "$role" == "$scope" ]]; then
    echo "[agent-run][fail] invalid --lease value: $item"
    echo "[agent-run][hint] expected format role:scope"
    exit 1
  fi
  python3 "scripts/agent_coord.py" --claim --role "$role" --agent-id "$AGENT_ID" --scope "$scope" --session-id "$SESSION_ID"
  ROLE_LIST+=("$role")
done

cleanup() {
  for role in "${ROLE_LIST[@]}"; do
    python3 "scripts/agent_coord.py" --release --role "$role" --agent-id "$AGENT_ID" >/dev/null 2>&1 || true
  done
}
trap cleanup EXIT

echo "[agent-run] running command: $*"
"$@"
echo "[agent-run] command completed"
