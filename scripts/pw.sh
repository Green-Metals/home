#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILL_WRAPPER="$CODEX_HOME/skills/playwright/scripts/playwright_cli.sh"

if [[ -x "$SKILL_WRAPPER" ]]; then
  exec "$SKILL_WRAPPER" "$@"
fi

if command -v playwright-cli >/dev/null 2>&1; then
  exec playwright-cli "$@"
fi

if command -v npx >/dev/null 2>&1; then
  exec npx --yes --package @playwright/cli playwright-cli "$@"
fi

echo "Error: could not find a Playwright CLI runtime." >&2
echo "Tried:" >&2
echo "  1) $SKILL_WRAPPER" >&2
echo "  2) playwright-cli on PATH" >&2
echo "  3) npx --yes --package @playwright/cli playwright-cli" >&2
echo "Install Node.js/npm or ensure the Playwright skill is installed under \$CODEX_HOME/skills." >&2
exit 1
