#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SHOT_ROOT="${ROOT_DIR}/ops/qa-artifacts/screenshots"
LATEST_DIR="${SHOT_ROOT}/latest"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

run_cmd() {
  if [[ "${DRY_RUN}" == "true" ]]; then
    echo "[dry-run] $*"
  else
    eval "$@"
  fi
}

if [[ ! -d "${SHOT_ROOT}" ]]; then
  echo "screenshots directory not found: ${SHOT_ROOT}"
  exit 1
fi

revision_list="$(find "${SHOT_ROOT}" -mindepth 1 -maxdepth 1 -type d -name 'revision-*' | sort)"

if [[ -z "${revision_list}" ]]; then
  if [[ -d "${LATEST_DIR}" ]]; then
    echo "no revision-* directories found; latest already canonical (JSON + failure screenshots policy)"
    while IFS= read -r loose_file; do
      run_cmd "rm -f \"${loose_file}\""
    done < <(find "${SHOT_ROOT}" -mindepth 1 -maxdepth 1 -type f)
    echo "qa artifact rotation complete (latest JSON + failure screenshots canonical)"
    exit 0
  fi
  echo "no revision-* directories found under ${SHOT_ROOT} and no latest directory exists"
  exit 1
fi

latest_revision="$(printf '%s\n' "${revision_list}" | tail -n 1)"
echo "selected latest revision: ${latest_revision}"

run_cmd "rm -rf \"${LATEST_DIR}\""
run_cmd "mkdir -p \"${LATEST_DIR}\""
run_cmd "cp -a \"${latest_revision}\"/. \"${LATEST_DIR}\"/"

printf '%s\n' "${revision_list}" | while IFS= read -r d; do
  if [[ -n "${d}" && "${d}" != "${latest_revision}" ]]; then
    run_cmd "rm -rf \"${d}\""
  fi
done

if [[ "${latest_revision}" != "${LATEST_DIR}" ]]; then
  run_cmd "rm -rf \"${latest_revision}\""
fi

while IFS= read -r loose_file; do
  run_cmd "rm -f \"${loose_file}\""
done < <(find "${SHOT_ROOT}" -mindepth 1 -maxdepth 1 -type f)

echo "qa artifact rotation complete (latest JSON + failure screenshots canonical)"
