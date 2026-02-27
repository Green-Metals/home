#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

MODE="${1:---for all}"
if [[ "$MODE" == "--for" ]]; then
  MODE="${2:-all}"
fi

case "$MODE" in
  all|fast|content|site)
    ;;
  *)
    echo "[prereqs][fail] unknown mode: $MODE"
    echo "[prereqs][hint] use --for all|fast|content|site"
    exit 1
    ;;
esac

require_cmd() {
  local cmd="$1"
  local hint="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[prereqs][fail] missing required command: $cmd"
    echo "[prereqs][hint] $hint"
    return 1
  fi
  return 0
}

fails=0
require_cmd python3 "Install Python 3 and ensure it is on PATH." || fails=1
require_cmd quarto "Install Quarto: https://quarto.org/docs/get-started/." || fails=1
require_cmd rg "Install ripgrep (macOS: brew install ripgrep)." || fails=1

if [[ "$fails" -ne 0 ]]; then
  echo "[prereqs][fail] prerequisite check failed"
  exit 1
fi

echo "[prereqs] prerequisites OK (mode=$MODE)"
